package com.xiaolong.utils;

import java.io.IOException;
import java.io.Serializable;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Vector;

import org.adl.parsers.dom.ADLItem;
import org.adl.parsers.dom.ADLOrganizations;
import org.adl.parsers.dom.CPDOMParser;
import org.adl.samplerte.util.DBUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Attr;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class ManifestHandler extends CPDOMParser implements Serializable {

	private static final Logger logger = LoggerFactory.getLogger(ManifestHandler.class);

	private static final long serialVersionUID = 9189303733137193268L;

	protected Vector items;

	private Vector tempItemList;

	protected InputSource sourceToParse;
	protected String courseName;
	protected String courseId;
	protected String control;

	public ManifestHandler() {
		super();
		tempItemList = new Vector();
		items = new Vector();
		courseName = "";
		courseId = "";
		control = "";
	}

	public boolean processManifest() {
		boolean result = false;

		try {
			parse(sourceToParse);

			logger.debug("Document parsing complete.");

			document = getDocument();

			result = processContent();
			logger.debug("processContent result: {}", result);
		} catch (SAXException se) {
			logger.debug("Parser threw a SAXException.");
		} catch (IOException ioe) {
			logger.debug("Parser threw a IOException.");
		}
		// 持久化
		updateDB();

		return result;
	}

	public boolean processContent() {
		boolean result = true;

		if (document == null) {
			logger.info("the document is null");
		}

		Node contentNode = document.getDocumentElement();

		NodeList contentChildren = contentNode.getChildNodes();

		this.manifest.fillManifest(contentNode);

		this.items = this.getItemList();

		for (int i = 0; i < contentChildren.getLength(); i++) {
			Node currentNode = contentChildren.item(i);

			if (currentNode.getNodeType() == Node.ELEMENT_NODE) {

				if (currentNode.getNodeName().equalsIgnoreCase("resources")) {
					logger.debug("*** Found Current Node: " + currentNode.getNodeName());

					result = processResources(currentNode);
					if (result == false) {
						break;
					}
				}
			}
		}

		return result;
	}

	public boolean processResources(Node resourcesNode) {

		boolean result = true;

		NodeList resourcesChildren = resourcesNode.getChildNodes();

		for (int i = 0; i < resourcesChildren.getLength(); i++) {
			Node currentNode = resourcesChildren.item(i);

			if (currentNode.getNodeType() == Node.ELEMENT_NODE) {
				if (currentNode.getNodeName().equalsIgnoreCase("resource")) {

					result = processResource(currentNode);
					if (result == false) {
						break;
					}
				}
			}
		}

		return result;
	}

	public boolean processResource(Node resourceNode) {
		boolean result = true;

		String id = getAttribute(resourceNode, "identifier");
		String scormType = getAttribute(resourceNode, "adlcp:scormtype");
		String type = getAttribute(resourceNode, "type");
		String href = getAttribute(resourceNode, "href");

		updateItemList(id, scormType, type, href);

		return result;

	}

	public void updateItemList(String id, String scormType, String type, String href) {

		ADLItem tempItem = new ADLItem();

		for (int i = 0; i < items.size(); i++) {
			tempItem = (org.adl.parsers.dom.ADLItem) this.items.elementAt(i);
			String idref = tempItem.getIdentifierref();

			if (idref.equals(id)) {

				if (type != null && !type.equals("")) {
					tempItem.setType(type);
				}
				if (scormType != null && !type.equals("")) {
					tempItem.setScormType(scormType);
				}
				if (href != null && !href.equals("")) {
					tempItem.setLaunchLocation(href);
				}
				items.removeElementAt(i);
				items.insertElementAt(tempItem, i);
			}
		}

	}

	public String getCourseID() {
		return this.courseId;
	}

	public ADLOrganizations getOrgsCopy() {
		return this.manifest.getOrganizations();
	}

	public void setCourseId(String courseId) {
		this.courseId = courseId;
	}

	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}

	public void setControl(String controlType) {
		this.control = controlType;
	}

	public void setFileToParse(InputSource inputStream) {
		this.sourceToParse = inputStream;
	}

	protected void updateDB() {

		try {
			Connection conn = null;

			PreparedStatement stmtInsertCourse;
			PreparedStatement stmtInsertItem;

			String sqlInsertCourse = "INSERT INTO CourseInfo (CourseID, CourseTitle, Active, Control) "
					+ "VALUES(?, ?, ?, ?)";

			String sqlInsertItem = "INSERT INTO ItemInfo (CourseID, Identifier, Type, Title, Launch, "
					+ "ParameterString, DataFromLMS, Prerequisites, MasteryScore, "
					+ "MaxTimeAllowed, TimeLimitAction, Sequence, TheLevel) "
					+ "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			conn = DBUtils.createConn();

			stmtInsertCourse = conn.prepareStatement(sqlInsertCourse);
			stmtInsertItem = conn.prepareStatement(sqlInsertItem);

			logger.info("Insert the course into the course Info table");
			stmtInsertCourse.setString(1, courseId);
			stmtInsertCourse.setString(2, courseName);
			stmtInsertCourse.setBoolean(3, true);
			stmtInsertCourse.setString(4, control);
			stmtInsertCourse.executeUpdate();

			ADLItem tempItem = new ADLItem();

			for (int i = 0; i < items.size(); i++) {
				tempItem = (org.adl.parsers.dom.ADLItem) items.elementAt(i);

				URLDecoder urlDecoder = new URLDecoder();
				String alteredLocation = new String();

				// If its external, don't concatenate to the local Web root.
				if ((tempItem.getLaunchLocation().startsWith("http://"))
						|| (tempItem.getLaunchLocation().startsWith("https://"))) {
					alteredLocation = urlDecoder.decode(tempItem.getLaunchLocation());
				} else {
					// Create the altered location (with decoded url)
					alteredLocation = "/adl/CourseImports/" + courseId + "/"
							+ urlDecoder.decode(tempItem.getLaunchLocation());
				}

				stmtInsertItem.setString(1, courseId);
				stmtInsertItem.setString(2, tempItem.getIdentifier());
				stmtInsertItem.setString(3, tempItem.getScormType());
				stmtInsertItem.setString(4, tempItem.getTitle());
				stmtInsertItem.setString(5, alteredLocation);
				stmtInsertItem.setString(6, tempItem.getParameterString());
				stmtInsertItem.setString(7, tempItem.getDataFromLMS());
				stmtInsertItem.setString(8, tempItem.getPrerequisites());
				stmtInsertItem.setString(9, tempItem.getMasteryScore());
				stmtInsertItem.setString(10, tempItem.getMaxTimeAllowed());
				stmtInsertItem.setString(11, tempItem.getTimeLimitAction());
				stmtInsertItem.setInt(12, i);
				stmtInsertItem.setInt(13, tempItem.getLevel());
				stmtInsertItem.executeUpdate();
			}

			if (conn != null) {
				conn.close();
			}

		} catch (SQLException se) {
			logger.debug(se.getSQLState());
			logger.debug("error code: " + se.getErrorCode());
			se.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected String getAttribute(Node theNode, String theAttribute) {
		String returnValue = new String();

		Attr attrs[] = sortAttributes(theNode.getAttributes());

		Attr attribute;
		for (int i = 0; i < attrs.length; i++) {
			attribute = attrs[i];

			if (attribute.getName().equals(theAttribute)) {
				returnValue = attribute.getValue();
				break;
			}
		}

		return returnValue;
	}

	protected Attr[] sortAttributes(NamedNodeMap attrs) {
		int len = (attrs != null) ? attrs.getLength() : 0;
		Attr array[] = new Attr[len];
		for (int i = 0; i < len; i++) {
			array[i] = (Attr) attrs.item(i);
		}
		for (int i = 0; i < len - 1; i++) {
			String name = array[i].getNodeName();
			int index = i;
			for (int j = i + 1; j < len; j++) {
				String curName = array[j].getNodeName();
				if (curName.compareTo(name) < 0) {
					name = curName;
					index = j;
				}
			}
			if (index != i) {
				Attr temp = array[i];
				array[i] = array[index];
				array[index] = temp;
			}
		}

		return (array);

	}

	public String getSubElement(Node node, String element) {
		String value = new String();
		NodeList kids = node.getChildNodes();
		if (kids != null) {
			for (int i = 0; i < kids.getLength(); i++) {
				if (kids.item(i).getNodeType() == Node.ELEMENT_NODE) {
					if (kids.item(i).getNodeName().equalsIgnoreCase(element)) {
						value = getText(kids.item(i));
						return value;
					}
				}
			}
		}
		return value;
	}

	public String getText(Node node) {
		String value = new String();
		NodeList kids = node.getChildNodes();
		if (kids != null) {
			for (int i = 0; i < kids.getLength(); i++) {
				if ((kids.item(i).getNodeType() == Node.TEXT_NODE)
						|| (kids.item(i).getNodeType() == Node.CDATA_SECTION_NODE)) {
					value = value + kids.item(i).getNodeValue().trim();
				}
			}
		}

		return value;
	}

}
