<%@page import = "java.sql.*" %>
<%
/*******************************************************************************
**
** Filename:  courseRegister.jsp
**
** File Description:     
**
** This file defines the courseRegister.jsp that shows a user which courses 
** they may register for and allows them to select ones to register for.
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
<SCRIPT LANGUAGE="javascript">
   <!--
   /*************************************************************************
   * Method: newWindow()
   * Input: pageName
   * Output: none
   *
   * Description: Opens the page input by 'pageName' in a new browser window.
   *************************************************************************/
   function newWindow(pageName)
   {
      window.open(pageName, 'Help', "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=500,height=500");
   }
   // -->
</SCRIPT>

<%! 
   Connection conn; 
   PreparedStatement stmtSelectCourse;
   PreparedStatement stmtSelectUserCourse;

   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: conn, stmtSelectCourse, and stmtSelectUserCourse are given
   *         new values.
   *
   * Description: This function sets the driverName and connectionURL
   *              variables and establishes the database connection.  The
   *              SQL strings are also assigned and converted to prepared
   *              statements.
   *********************************************************************/
   public void jspInit() 
   {
	   System.out.println("===");
      try
      {
         String sqlSelectUserCourse
          = "SELECT * FROM UserCourseInfo WHERE UserID = ?";
           
         String sqlSelectCourse
          = "SELECT * FROM CourseInfo WHERE Active = '1'";
          
         String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
         String connectionURL = "jdbc:odbc:SampleRTE";

//          Class.forName(driverName).newInstance();
//          conn = DriverManager.getConnection(connectionURL);
         Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
         stmtSelectCourse= conn.prepareStatement( sqlSelectCourse );
         stmtSelectUserCourse= conn.prepareStatement( sqlSelectUserCourse );
      }
      catch(SQLException e){}
      catch(ClassNotFoundException e){}
      catch(Exception e){}
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
         stmtSelectCourse.close();
         stmtSelectUserCourse.close();
         conn.close();
      } 
      catch(SQLException e) {}
   } 
%>

<%

String formBody = "";

try
{
   String userID = (String)session.getAttribute( "USERID" );
   
   ResultSet userCourseRS = null;
   /*********************************************************************
   * Method: synchronized()
   * Input: stmtSelectUserCourse
   * Output: stmtSelectUserCourse
   *
   * Description: Inserts the value of the variable 'userID' into the
   *              prepared statement 'stmtSelectUserCourse'.  The result
   *              set 'userCourseRS' is also assigned the results of the
   *              query.  This will give all of the courses associated
   *              with the particular user.
   *********************************************************************/
   synchronized( stmtSelectUserCourse )
   {
      stmtSelectUserCourse.setString( 1, userID );
      userCourseRS = stmtSelectUserCourse.executeQuery();
   }

   // Loops through the result set 'userCourseRS' and adds each course ID to the
   // 'userCourses' string.
   String userCourses = "|";
   while(userCourseRS.next())
   {
      userCourses += userCourseRS.getString( "CourseID" ) + "|";
   }

   ResultSet courseRS = null;
   /*********************************************************************
   * Method: synchronized()
   * Input: stmtSelectCourse
   * Output: stmtSelectCourse
   *
   * Description: The result set 'courseRS' is assigned the results of
   *              the query.  This will give all of the courses.
   *********************************************************************/
   synchronized( stmtSelectCourse )
   {
      courseRS = stmtSelectCourse.executeQuery();
   }     

   // Loops through the result set of all courses and if the current course is
   // in the string 'userCourses', the string 'checked' is assigned the value
   // "checked".  The body of the table is then formed by assigning it to the
   // string 'formBody'.  The 'checked' string is output in the checkbox tag.
   // If the course was in the 'userCourses' string, the checkbox will be
   // checked.
   while( courseRS.next() )
   {
      String courseID = courseRS.getString( "CourseID" );
      String courseTitle = courseRS.getString( "CourseTitle" );
      
      String checked = "";

      if(userCourses.indexOf("|"+courseID+"|") != -1)
      {
         checked = "checked";
      }
         
      formBody += "<tr><td width='10%'><input type='checkbox' name='"+courseID +"' value='1'" +
            checked +"/></td><td>" + courseTitle + "</td></tr>";

   }

   formBody += "<tr><td colspan=2><hr></td></tr>";
}
catch(Exception e)
{  
}

%>
<html>
<head>
<title>Sample Run-Time Environment Course Register</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<META http-equiv="expires" CONTENT="Tue, 05 DEC 2000 01:00:00 GMT">
<META http-equiv="Pragma" CONTENT="no-cache">
</head>
<body bgcolor="#FFFFFF">
<jsp:include page="gotoMenu.jsp" flush="true" />

<p>
<font face="tahoma" size="3"><b>
Course Registration
</b></font>
</p>
<form name="courseRegForm" method="POST" action="processCourseReg.jsp">
   <table width="548" border="0">
      <tr> 
         <td colspan="3"> 
            <hr>
         </td>
      </tr>
      <tr> 
         <td colspan="3" height="71">
            <font face="tahoma" size="2">
               Please select all of the courses you wish to register in by 
               checking the checkbox or select the courses you would like to be
               removed from by unchecking the checkbox.  Note that 
               unregistering for a course will remove all associated saved data 
               for the course.
            </font>
         </td>
      </tr>
      <tr><td><BR></td></tr>
      <tr>
         <td colspan="6" bgcolor="#5E60BD">
            <font face="tahoma" size="2" color="#ffffff"><b>
               &nbsp;Available Courses:
            </b></font>
         </td>
      </tr>
      <%=formBody%>
   </table>
   <table width="547" border="0">
      <tr> 
         <td width="45%">&nbsp;</td>
         <td width="55%"> 
            <input type="submit" name="submit" value="Submit Form">
         </td>
      </tr>
      <TR>
         <td>
            <A HREF="javascript:newWindow('courseRegisterHelp.htm');">Help!</A>
         </td>
      </TR>
   </table>
</form>
</body>
</html>