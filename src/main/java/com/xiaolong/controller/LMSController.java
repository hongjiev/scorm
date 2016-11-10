package com.xiaolong.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.adl.datamodels.DataModelInterface;
import org.adl.datamodels.SCODataManager;
import org.adl.datamodels.cmi.CMICore;
import org.adl.datamodels.cmi.CMIRequest;
import org.adl.datamodels.cmi.CMITime;
import org.adl.datamodels.cmi.DMErrorManager;
import org.adl.samplerte.client.LMSErrorManager;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("")
public class LMSController {

	public static final String cmiBooleanFalse = "false";

	public static final String cmiBooleanTrue = "true";

	@RequestMapping("/LMSInitialize")
	public String LMSInitialize(String param, HttpSession session, HttpServletRequest request,
			HttpServletResponse response) {

		System.out.println("*********************");
		System.out.println("In API::LMSInitialize");
		System.out.println("*********************");

		String result = cmiBooleanFalse;

		DMErrorManager dmErrorManager = new DMErrorManager();
		if (session.getAttribute("dmErrorManager") != null) {
			dmErrorManager = (DMErrorManager) session.getAttribute("dmErrorManager");
		}
		LMSErrorManager lmsErrorManager = new LMSErrorManager();
		if (session.getAttribute("lmsErrorManager") != null) {
			lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");
		}
		SCODataManager scoData = null;
		if (session.getAttribute("scoData") != null) {
			scoData = (SCODataManager) session.getAttribute("scoData");
		}
		boolean isLMSInitialized = false;
		if (session.getAttribute("isLMSInitialized") != null) {
			isLMSInitialized = (boolean) session.getAttribute("isLMSInitialized");
		}

		String tempParm = String.valueOf(param);
		if ((tempParm.equals("null") || tempParm.equals("")) != true) {
			lmsErrorManager.SetCurrentErrorCode("201");
			return result;
		}

		if (isLMSInitialized) {
			lmsErrorManager.SetCurrentErrorCode("101");
		} else {
			String userId = (String) session.getAttribute("USERID");
			String courseId = (String) session.getAttribute("COURSEID");
			String scoId = (String) session.getAttribute("SCOID");
			
			System.out.println("init [userId=" + userId + "],[courseId=" + courseId + "][scoId=" + scoId + "]");

			scoData = RequestHandler.handleInit(userId, courseId, scoId, request, response);
			isLMSInitialized = true;
		}
		// flush to session
		session.setAttribute("dmErrorManager", dmErrorManager);
		session.setAttribute("lmsErrorManager", lmsErrorManager);
		session.setAttribute("scoData", scoData);
		session.setAttribute("isLMSInitialized", isLMSInitialized);

		result = cmiBooleanTrue;
		return result;
	}

	@RequestMapping("/LMSFinish")
	public String LMSFinish(String param, HttpSession session, HttpServletRequest request,
			HttpServletResponse response) {

		System.out.println("*****************");
		System.out.println("In API::LMSFinish");
		System.out.println("*****************");

		String result = cmiBooleanFalse;
		String tempParm = String.valueOf(param);

		if ((tempParm.equals("null")) || (tempParm.equals(""))) {

			if (checkInitialization(session)) {

				SCODataManager theSCOData = (SCODataManager) session.getAttribute("scoData");
				CMICore lmsCore = theSCOData.getCore();

				// Need to add the SCOs Session Time into the running total time
				CMITime totalTime = new CMITime(lmsCore.getTotalTime().getValue());

				System.out.println("\tTotal time: " + totalTime.toString());

				CMITime sessionTime = new CMITime(lmsCore.getSessionTime().getValue());

				System.out.println("\tSession time: " + sessionTime.toString());

				totalTime.add(sessionTime);
				lmsCore.setTotalTime(totalTime.toString());

				System.out.println("\t\tTotal time: " + totalTime.toString());

				// If changes are left uncommitted when LMSFinish
				// is called, the LMS forces an LMSCommit.
				if (lmsCore.getExit().getValue().equalsIgnoreCase("suspend")) {
					lmsCore.setEntry("resume");
				} else {
					lmsCore.setEntry("");
				}

				if (lmsCore.getLessonStatus().getValue().equalsIgnoreCase("not attempted")) {
					lmsCore.setLessonStatus("incomplete");
				}

				theSCOData.setCore(lmsCore);

				result = LMSCommit("", session, request, response);

				session.setAttribute("scoData", theSCOData);
			}
		} else {
			setLmsErrorManager(session, "201");
		}

		return result;
	}

	@RequestMapping("/LMSCommit")
	public String LMSCommit(String param, HttpSession session, HttpServletRequest request,
			HttpServletResponse response) {

		System.out.println("*****************");
		System.out.println("In API::LMSCommit");
		System.out.println("*****************");

		String result = cmiBooleanFalse;

		String tempParm = String.valueOf(param);
		if (tempParm.equals("null") || tempParm.equals("")) {
			if (checkInitialization(session)) {
				try {
					SCODataManager scoDataManager = getScoData(session);

					String userId = (String) session.getAttribute("USERID");
					String courseId = (String) session.getAttribute("COURSEID");
					String scoId = (String) session.getAttribute("SCOID");

					RequestHandler.handleCommit(userId, courseId, scoId, scoDataManager, request, response);
					clearLMSErrorCode(session);
					result = cmiBooleanTrue;
					session.setAttribute("scoData", scoDataManager);

				} catch (IOException e) {
					e.printStackTrace();
					setLmsErrorManager(session, "101");
				}
			}
		} else {
			setLmsErrorManager(session, "201");
		}

		return result;
	}

	@RequestMapping("/LMSGetLastError")
	public String LMSGetLastError(HttpSession session) {

		System.out.println("***********************");
		System.out.println("In API::LMSGetLastError");
		System.out.println("***********************");

		LMSErrorManager lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");

		return lmsErrorManager.GetCurrentErrorCode();
	}

	@RequestMapping("/LMSGetErrorString")
	public String LMSGetErrorString(String errorCode, HttpSession session) {

		System.out.println("*************************");
		System.out.println("In API::LMSGetErrorString");
		System.out.println("*************************");
		System.out.println(">> errorCode: " + errorCode);

		LMSErrorManager lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");

		return lmsErrorManager.GetErrorDescription(errorCode);
	}

	@RequestMapping("/LMSGetDiagnostic")
	public String LMSGetDiagnostic(String errorCode, HttpSession session) {

		System.out.println("*************************");
		System.out.println("In API::LMSGetDiagnostic ");
		System.out.println("*************************");
		System.out.println(">> errorCode: " + errorCode);

		LMSErrorManager lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");

		return lmsErrorManager.GetErrorDiagnostic(errorCode);
	}

	@RequestMapping("/LMSGetValue")
	public String LMSGetValue(String element, HttpSession session) {

		System.out.println("***********************");
		System.out.println("In API::LMSGetValue    ");
		System.out.println("***********************");
		System.out.println(">> element: " + element);

		String result = "";

		if (!checkInitialization(session)) {
			return "";
		} else {
			CMIRequest request = new CMIRequest(element, true);
			System.out.println("Looking for the element " + request.getRequest());
			clearDMErrorCode(session);
			clearLMSErrorCode(session);

			DataModelInterface dmInterface = new DataModelInterface();

			SCODataManager scoData = (SCODataManager) session.getAttribute("scoData");
			DMErrorManager dmErrorManager = (DMErrorManager) session.getAttribute("dmErrorManager");

			result = dmInterface.processGet(element, scoData, dmErrorManager);
			setLmsErrorManager(session, dmErrorManager.GetCurrentErrorCode());

			// flush back to session
			session.setAttribute("scoData", scoData);
			session.setAttribute("dmErrorManager", dmErrorManager);

			return result;
		}
	}

	@RequestMapping("/LMSSetValue")
	public String LMSSetValue(String element, String value, HttpSession session) {

		System.out.println("***********************");
		System.out.println("In API::LMSSetValue    ");
		System.out.println("***********************");
		System.out.println(">> element: " + element);
		System.out.println(">> value:   " + value);

		String result = cmiBooleanFalse;

		clearDMErrorCode(session);
		clearLMSErrorCode(session);

		if (!checkInitialization(session)) {
			return result;
		} else {
			String setValue;
			String tempValue = String.valueOf(value);
			if (tempValue.equals("null")) {
				setValue = "";
			} else {
				setValue = tempValue;
			}
			String theRequest = element + "," + setValue;

			DataModelInterface dmInterface = new DataModelInterface();

			SCODataManager scoData = (SCODataManager) session.getAttribute("scoData");
			DMErrorManager dmErrorManager = (DMErrorManager) session.getAttribute("dmErrorManager");

			dmInterface.processSet(theRequest, scoData, dmErrorManager);
			setLmsErrorManager(session, dmErrorManager.GetCurrentErrorCode());

			session.setAttribute("scoData", scoData);
			session.setAttribute("dmErrorManager", dmErrorManager);

			if (dmErrorManager.GetCurrentErrorCode().equals("0")) {
				result = cmiBooleanTrue;
			}
		}
		return result;
	}

	private boolean setLmsErrorManager(HttpSession session, String code) {
		if (session.getAttribute("lmsErrorManager") != null) {
			LMSErrorManager lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");
			lmsErrorManager.SetCurrentErrorCode(code);
			session.setAttribute("lmsErrorManager", lmsErrorManager);
			return true;
		}
		return false;
	}

	private void clearLMSErrorCode(HttpSession session) {
		LMSErrorManager lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");
		lmsErrorManager.ClearCurrentErrorCode();
		session.setAttribute("lmsErrorManager", lmsErrorManager);
	}

	private void clearDMErrorCode(HttpSession session) {
		DMErrorManager dmErrorManager = (DMErrorManager) session.getAttribute("dmErrorManager");
		dmErrorManager.ClearCurrentErrorCode();
		session.setAttribute("dmErrorManager", dmErrorManager);
	}

	private SCODataManager getScoData(HttpSession session) {
		if (session.getAttribute("scoData") != null) {
			return (SCODataManager) session.getAttribute("scoData");
		} else {
			return null;
		}
	}

	private boolean checkInitialization(HttpSession session) {
		Object isLMSInitialized = session.getAttribute("isLMSInitialized");

		if (isLMSInitialized == null || (boolean) isLMSInitialized == false) {

			LMSErrorManager lmsErrorManager = (LMSErrorManager) session.getAttribute("lmsErrorManager");
			lmsErrorManager.SetCurrentErrorCode("301");

			session.setAttribute("lmsErrorManager", lmsErrorManager);
			return false;
		} else {
			return true;
		}
	}
}
