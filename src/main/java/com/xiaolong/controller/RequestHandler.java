package com.xiaolong.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.adl.datamodels.SCODataManager;
import org.adl.datamodels.cmi.CMICore;
import org.adl.samplerte.util.DBUtils;

public class RequestHandler {

	public static void handleCommit(String userId, String courseId, String scoId, SCODataManager inSCOData,
			HttpServletRequest request, HttpServletResponse response) throws IOException {

		HttpSession session = request.getSession();

		boolean logoutFlag = false;

		CMICore lmsCore = inSCOData.getCore();
		if (lmsCore.getExit().getValue().equalsIgnoreCase("logout")) {
			logoutFlag = true;
		}
		String lessonStatus = lmsCore.getLessonStatus().getValue();
		String lessonExit = lmsCore.getExit().getValue();
		String lessonEntry = lmsCore.getEntry().getValue();
		// String lessonScore = lmsCore.getScore().getRaw().getValue();
		// System.out.println("==score: " + lessonScore);

		inSCOData.setCore(lmsCore);

		// Write out the updated data to disk
		String scoFile = session.getServletContext().getRealPath("/") + "/adl/" + userId + "/" + courseId + "/" + scoId;

		ObjectOutputStream out_file = new ObjectOutputStream(new FileOutputStream(scoFile));
		out_file.writeObject(inSCOData);
		out_file.close();

		// update UserSCOInfo in DB
		Connection conn;
		PreparedStatement stmtUpdateUserSCO;
		PreparedStatement stmtSelectUserSCO;

		String sqlUpdateUserSCO = "UPDATE UserSCOInfo SET LessonStatus = ?, `Exit` = ?, Entry = ? WHERE UserID = ? AND CourseID = ? AND SCOID = ?";

		String sqlSelectUserSCO = "SELECT * FROM UserSCOInfo WHERE UserID = ? AND CourseID = ? AND SCOID = ?";
		try {
			conn = DBUtils.createConn();
			stmtUpdateUserSCO = conn.prepareStatement(sqlUpdateUserSCO);
			stmtSelectUserSCO = conn.prepareStatement(sqlSelectUserSCO);

			stmtUpdateUserSCO.setString(1, lessonStatus);
			stmtUpdateUserSCO.setString(2, lessonExit);
			stmtUpdateUserSCO.setString(3, lessonEntry);
			stmtUpdateUserSCO.setString(4, userId);
			stmtUpdateUserSCO.setString(5, courseId);
			stmtUpdateUserSCO.setString(6, scoId);
			stmtUpdateUserSCO.executeUpdate();

			ResultSet userSCORS = null;
			stmtSelectUserSCO.setString(1, userId);
			stmtSelectUserSCO.setString(2, courseId);
			stmtSelectUserSCO.setString(3, scoId);
			userSCORS = stmtSelectUserSCO.executeQuery();
			userSCORS.next();
			String newStatus = userSCORS.getString("LessonStatus");

			System.out.println("new status: " + newStatus);
			close(userSCORS);

			close(stmtSelectUserSCO);
			close(stmtUpdateUserSCO);

			close(conn);

		} catch (SQLException e1) {
			e1.printStackTrace();
		}

		if (logoutFlag == true) {
			session.setAttribute("EXITFLAG", "true");
		} else {
			session.removeAttribute("EXITFLAG");
		}
	}

	private static void close(ResultSet resultSet) {
		try {
			if (null != resultSet) {
				resultSet.close();
			}
		} catch (Exception e) {
		}
	}

	private static void close(PreparedStatement preparedStatement) {
		try {
			if (preparedStatement != null) {
				preparedStatement.close();
			}
		} catch (Exception e) {
		}
	}

	private static void close(Connection connection) {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException e) {
		}
	}

}
