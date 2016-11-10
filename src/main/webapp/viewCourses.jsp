<%@page import = "java.sql.*, java.util.*, org.adl.util.*" %>
<%
/*******************************************************************************
**
** Filename:  viewCourses.jsp
**
** File Description:   This file displays a list of courses that a user 
**                     is registered for.  The user can click on the link and
**                     launch the course.
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

 
<%! 
   Connection conn; 
   PreparedStatement stmtSelectUserCourse;
   
   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: 'conn' is assigned the value of the database connection and
   *         'driverName' is assigned the driver.  'sqlSelectUserCourse'
   *         is assigned the SQL string, converted to a prepared
   *         statement and assigned to 'stntSelectUserCourse'.
   *
   * Description: This function sets the 'driverName' and 'connectionURL'
   *              variables and establishes the database connection.  The
   *              SQL string is also assigned and converted to a prepared
   *              statement.
   *********************************************************************/
   public void jspInit() 
   {
      try
      {
         String sqlSelectUserCourse = "SELECT CourseInfo.CourseID, " + 
                "CourseInfo.CourseTitle, CourseInfo.Control FROM CourseInfo, UserCourseInfo " +
                "WHERE UserCourseInfo.UserID = ? AND " + 
                "CourseInfo.CourseID = UserCourseInfo.CourseID AND CourseInfo.Active = '1' ORDER BY CourseInfo.CourseTitle";
         
         String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
         String connectionURL = "jdbc:odbc:SampleRTE";

//          Class.forName(driverName).newInstance();
//          conn = DriverManager.getConnection(connectionURL);
         Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
         stmtSelectUserCourse= conn.prepareStatement( sqlSelectUserCourse );
      }
      catch(SQLException e)
      {
         e.printStackTrace();
      }
      catch(ClassNotFoundException e)
      {
         e.printStackTrace();
      }
      catch(Exception e)
      {
         e.printStackTrace();
      }
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
         stmtSelectUserCourse.close();
         conn.close();
      } 
      catch(SQLException e) {e.printStackTrace();}
   } 
%>

<html>
<head>
   <title>ADL Sample Run-Time Environment Version 1.2.2 View Courses</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <meta http-equiv="expires" content="Tue, 05 DEC 2000 01:00:00 GMT">
   <meta http-equiv="Pragma" content="no-cache">
 
<script language="javascript">

/****************************************************************************
**
** Function:  launchAutoWindow()
** Input:   courseID - String - The identifier of the course that is being
**                              launched in the new window.
** Output:  none
**
** Description:  Launches course content in a new window.
**
***************************************************************************/      
function launchAutoWindow( courseID )
{
   var theURL = "sequencingEngine.jsp?courseID=" + courseID;;
   window.document.location.href = "LMSMenu.jsp";
   window.top.contentWindow=window.open( theURL, 'displayWindow' ); 
}

/****************************************************************************
**
** Function:   init_menu()
** Input:   none
** Output:  none
**
** Description:  Refreshes the left menu page to build the current menu
**               for the currently launched course.
**
***************************************************************************/  
function init_menu()
{
   window.parent.frames[1].document.location.href = "code.jsp";
}

/****************************************************************************
**
** Function:   newWindow()
** Input:   pageName - String - The page that will be launched in the new
**                              window.  At this time, only the help page.
** Output:  none
**
** Description:  Launches a new window with additional user help
**
***************************************************************************/  
function newWindow(pageName)
{
   window.open(pageName, 'Help', 
   "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=500,height=500");
}

</script>      
</head>

<body bgcolor="#FFFFFF"  ONUNLOAD="init_menu()">
<jsp:include page="gotoMenu.jsp" flush="true" />

<p>
<font face="tahoma" size="3" ><b>
   Available Courses
</b></font>
</p>

<table width="200">
   <tr>
      <td bgcolor="#5E60BD">
         <font face="tahoma" size="2" color="#ffffff"><b>
            &nbsp;Please Select a Course:
         </b></font>
      </td>
   </tr>
   
   <%
     // Query for all courses the the logged in user is 
      try
      {
         String userID = (String)session.getAttribute( "USERID" );
         
         ResultSet userCourseRS = null;
         synchronized( stmtSelectUserCourse )
         {
            stmtSelectUserCourse.setString( 1, userID );
            userCourseRS = stmtSelectUserCourse.executeQuery();
         }
   
         //Loops through the result set 'userCourseRS' outputting the name of
         //the course as a link to the sequencing engine with the courseID
         //so that the course can be launched by clicking on the link.
         while ( userCourseRS.next() )
         {
            String courseID = userCourseRS.getString( "CourseID" );
            String courseTitle = userCourseRS.getString( "CourseTitle" );
            String control = userCourseRS.getString( "Control" );
   %>
            <tr>
               <td>    
                  <%  // If its auto, launch in a new window.  If not, launch in the frameset
                  if ( (! (control == null ) ) && ( control.equals( "auto" ) ) )
                  {   %>
                     <p>
                     <a href="javascript:launchAutoWindow('<%=courseID%>')">
                        <%= courseTitle %>
                     </a>
                     </p>  
               <% }
                  else
                  {   %>
                     <p><a href="sequencingEngine.jsp?courseID=<%=courseID%>"><%=courseTitle%></a></p>
               <% } %>
               </td>
            </tr>
   <%    }
      }
      catch(Exception e)
      {
         e.printStackTrace();   
      }
   %>
   <tr>
      <td>
         <br><br>
         <a href="javascript:newWindow( 'launchCourseHelp.htm' );">Help!</a>
      </td>
   </tr>
</table>

</body>
</html>
