<%@page import = "java.sql.*, java.util.*, org.adl.util.*" %>

<%
/*******************************************************************************
**
** Filename:  processDeleteCourse.jsp
**
** File Description:   This file implements the processing necessary 
** to delete a course.
**
**
**
**
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
** notice and license appear on all copies of the software; and ii) Licensee
** does not utilize the software in a manner which is disparaging to CTC.
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
** OR INABILITY TO USE SOFTWARE, EVEN IF CTC HAS BEEN ADVISED OF THE POSSIBILITY
** OF SUCH DAMAGES.
**
*******************************************************************************/%>



<html>
<head>
   <title>ADL Sample RTE V 1.2.2  Process Delete Course</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF">

<jsp:include page="gotoMenu.jsp" flush="true" />
<%!
   Connection conn;
   PreparedStatement stmtUpdateCourse;

   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: 'conn' is given the value of the database connection and 
   *         'stmtUpdateCourse' is assigned the value of the SQL string.
   *
   * Description: This function sets the driverName and connectionURL
   *              variables and establishes the database connection.  The
   *              SQL string is also assigned and converted to a prepared
   *              statement.
   *********************************************************************/
   public void jspInit()
   {
      try
      {
         String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
         String connectionURL = "jdbc:odbc:SampleRTE";
//          Class.forName(driverName).newInstance();
//          conn= DriverManager.getConnection(connectionURL);
		Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
         String sqlUpdateCourse
          = "UPDATE CourseInfo set Active = no where CourseID = ?";

         stmtUpdateCourse = conn.prepareStatement( sqlUpdateCourse );
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
   * Description: Closes statements and the database connection.    
   *********************************************************************/
   public void jspDestroy()
   {
      try
      {
         stmtUpdateCourse.close();
         conn.close();
      }
      catch(Exception e) {}      
   }

%>

<%
   String strCourses = "";
   String[] arrCourses;
   strCourses = request.getParameter("chkCourse");

   int loopCount = 0;
   int courseCount = 0;
   String courseID;

   // If 'strCourses' is not null, the values of the checked checkboxes
   // submitted from deleteCourse.jsp are assigned to 'arrCourses', creating
   // an array of course IDs.  The courses are then made inactive in the
   // function 'snychronized()'.  If 'strCourses' is null (meaning no courses
   // were checked on deleteCourse.jsp), an error message is displayed
   // instructing the user to select a course to delete, along with a link
   // which takes the user back to deleteCourse.jsp.
   if(strCourses != null)
   {
      arrCourses = request.getParameterValues("chkCourse");
      courseCount = arrCourses.length;

      /*********************************************************************
      * Method: synchronized()
      * Input: stmtUpdateCourse, courseCount
      * Output: none
      *
      * Description: Loops through 'arrCourses', sets 'courseID' to the
      *              value in the current position of the array (determined
      *              by 'loopCount'), inserts the value of 'courseID' into
      *              'stmtUpdateCourse' and executes stmt'UpdateCourse'.
      *              This changes every course selected by the admin as
      *              inactive.
      *********************************************************************/
      synchronized( stmtUpdateCourse )
      {
         for(loopCount = 0; loopCount < courseCount; loopCount++)
         {
            courseID = arrCourses[loopCount];
            stmtUpdateCourse.setString( 1, courseID);
            stmtUpdateCourse.executeUpdate();
         }
      }
      %>
      
      <b>Delete successful.</b>
      
      <%
   }
   else
   {
      %>
         <b>Please check one of the courses for deletion</b><br>
         <a href="javascript:history.go(-1);">Back To Delete Course</a>
      <%
   }
%>
</body>
</html>
