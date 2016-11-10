<%@page import = "java.sql.*, java.util.*, java.io.*" %>
<%
/*******************************************************************************
**
** Filename:  deleteCourse.jsp
**
** File Description:   This file allows an administrator to select a 
** course to be deleted.
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
   <title>ADL Sample RTE Delete Course</title> 
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <script language="JavaScript">
   <!--
    
   /****************************************************************************
   **
   ** Function:  MM_reloadPage()
   ** Input:   init - boolean
   ** Output:  boolean
   **
   ** Description:  This function reloads the window if Nav4 is resized
   **
   ** Issues:  This method is not in use in Version 1.2.2 due to the lack of
   **          Netscape support.
   **
   ***************************************************************************/
   function MM_reloadPage(init)
   { //reloads the window if Nav4 resized
      if (init==true) with (navigator)
      {
         if ((appName=="Netscape")&&(parseInt(appVersion)==4))
         {
            document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage;
         }
      }
      else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
   }
   MM_reloadPage(true);
   function checkData()
   {
      return true;
   }
   // -->
   </script>
</head>
   
<body bgcolor="#FFFFFF">
  
   <jsp:include page="gotoMenu.jsp" flush="true" />
   <form method="post" action="processDeleteCourse.jsp" name="deleteCourse" ONSUBMIT="return checkData()">
      <table width="458" border="0">
         <tr>
            <td bgcolor="#5E60BD" colspan="2">
               <font face="tahoma" size="2" color="#ffffff"><b>
                  &nbsp;Please select the course you would like to delete
               </b></font>
            </td>
         </tr>
         <%!
            Connection conn;
            PreparedStatement stmtSelectCourses;
            String TempString;

            /******************************************************************
            * Method: jspInit()
            * Input: none
            * Output: conn and stmtSelectCourses are given new values
            *
            * Description: This function sets the driverName and connectionURL
            *              variables and establishes the database connection.
            *              The SQL string is also assigned and converted to a
            *              prepared statement.
            ******************************************************************/
            public void jspInit()
            {
               try
               {
                  String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
                  String connectionURL = "jdbc:odbc:SampleRTE";
//                   Class.forName(driverName).newInstance();
//                   conn = DriverManager.getConnection(connectionURL);
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
                  //Query String to obtain Courses
                  String sqlSelectCourses = "SELECT * FROM CourseInfo WHERE Active = yes ORDER BY CourseTitle";
                  stmtSelectCourses = conn.prepareStatement( sqlSelectCourses );
               }
               catch(SQLException e){TempString = "SQL EXCEPTION";}
               catch(Exception e){TempString = "Caught Genearl Exception";}
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
                  stmtSelectCourses.close();
                  conn.close();
               }
               catch(SQLException e) {};
             
            }
         %>
        
         <%

            // The result set 'coursesRS' is assigned the results of the executed
            // statement 'stmtSelectCourses'.  This gives all of the courses.
            // 'courseRS' is then looped through and each course is outputted in
            // the table.  
            try
            {
               ResultSet coursesRS;
               String courseID = null;
               String courseTitle = null;

               coursesRS = stmtSelectCourses.executeQuery();

               // Loops through all of the courses and outputs them in the
               // table with a check box.
               while( coursesRS.next() )
               {
                  courseID = coursesRS.getString("CourseID");
                  courseTitle = coursesRS.getString("CourseTitle");

                  %>
                  <tr>
                     <td width='10%'>
                        <input type='checkbox' name='chkCourse' value='<%=courseID%>'/>
                     </td>
                     <td>
                        <%=courseTitle%>
                     </td>
                  </tr>
                  <%
               }
            }
            catch(Exception e) {System.out.println("IN EXCEPTION" + e + TempString);}
         %>
        
         <tr>
            <td colspan="2">
               &nbsp;
            </td>
         </tr>
         <tr>
            <td colspan="2">
               <input type="submit" name="submit" value="Submit Form" />
            </td>
         </tr>
      </table>
   <form>
</body>
</html>
     
