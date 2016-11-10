
<%@page import = "java.sql.*, java.util.*" %>
<% 
/*******************************************************************************
**
** Filename:  clearDatabase.jsp
**
** File Description: This file deletes all course and registration information
**                   from the database.
**
** Author: ADL Technical Team
**
** Contract Number:
** Company Name: CTC
**
** Module/Package Name:
** Module/Package Description:
**
** Design Issues:
**
** Implementation Issues:
** Known Problems:
** Side Effects:
**
** References: ADL SCORM
**
/*******************************************************************************
**
** Concurrent Technologies Corporation (CTC) grants you ("Licensee") a non-
** exclusive, royalty free, license to use, modify and redistribute this
** software in source and binary code form, provided that i) this copyright
** notice and license appear on all copies of the software; and ii) Licensee does
** not utilize the software in a manner which is disparaging to CTC.
**
** This software is provided "AS IS," without a warranty of any kind.  ALL
** EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING ANY
** IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON-
** INFRINGEMENT, ARE HEREBY EXCLUDED.  CTC AND ITS LICENSORS SHALL NOT BE LIABLE
** FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR
** DISTRIBUTING THE SOFTWARE OR ITS DERIVATIVES.  IN NO EVENT WILL CTC  OR ITS
** LICENSORS BE LIABLE FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT,
** INDIRECT, SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER
** CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF THE USE OF
** OR INABILITY TO USE SOFTWARE, EVEN IF CTC  HAS BEEN ADVISED OF THE POSSIBILITY
** OF SUCH DAMAGES.
**
*******************************************************************************/
%>

<html>
<head>
   <title>ADL Sample RTE Clear Database</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <meta http-equiv="expires" content="Tue, 20 Aug 1999 01:00:00 GMT">
   <meta http-equiv="Pragma" content="no-cache">
</head>
<body bgcolor="#FFFFFF">

<jsp:include page="gotoMenu.jsp" flush="true" />
<%!
   Connection conn;
   PreparedStatement stmtDeleteCourseInfo;
   PreparedStatement stmtUpdateApplicationData;

   /***************************************************************************
   **
   ** Function:  jspInit()
   ** Input:   none
   ** Output:  conn, driverName and connectionURL are established.
   **          sqlDeleteCourseInfo is assigned the SQL query to delete
   **          everything in the CourseInfo table, which is then converted to
   **          a prepared statement and assigned to stmtDeleteCourseInfo.
   **
   ** Description:  This function sets the driverName and connectionURL
   **               variables and establishes the database connection.  The
   **               SQL string are also assigned and converted to a prepared
   **               statement.
   **
   ***************************************************************************/
   public void jspInit()
   {
      try
      {
         String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
         String connectionURL = "jdbc:odbc:SampleRTE";
//          Class.forName(driverName).newInstance();
//          conn = DriverManager.getConnection(connectionURL);
         Class.forName("com.mysql.jdbc.Driver");
     	conn = DriverManager.getConnection(
     			"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
     			"allwin", "3edc$RFV5tgb"); 
         String sqlDeleteCourseInfo = "Delete FROM CourseInfo";
         String sqlUpdateApplicationData = "UPDATE ApplicationData SET numberValue = '1' WHERE dataName = 'nextCourseID'";

         stmtDeleteCourseInfo = conn.prepareStatement( sqlDeleteCourseInfo );
         stmtUpdateApplicationData = conn.prepareStatement( sqlUpdateApplicationData);
      }
      catch(SQLException e) {}
      catch(ClassNotFoundException e) {}
      catch(Exception e) {}
   }

   /*********************************************************************
   * Method: jspDestroy()
   * Input: none
   * Output: none
   *
   * Description: Closes the statement and the database connection.    
   *********************************************************************/
   public void jspDestroy()
   {
      try
      {
         stmtDeleteCourseInfo.close();
         stmtUpdateApplicationData.close();
         conn.close();
      }
      catch(Exception e) {}
   }
%>
<%
   //executes the query to delete all records in the CourseInfo table.
   try
   {
      stmtDeleteCourseInfo.executeUpdate();
      stmtUpdateApplicationData.executeUpdate();
   }
   catch(Exception e)
   {
      e.printStackTrace();   
   }
%>
<b> Database Cleared </b>

</body>
</html>
