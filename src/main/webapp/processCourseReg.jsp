<%@page import = "java.sql.*, java.util.*, org.adl.samplerte.util.*, org.adl.parsers.dom.*, java.io.*" %>
<%
/*******************************************************************************
**
** Filename:  processCourseReg.jsp
**
** File Description:     
**
** This class defines the processCourseReg.jsp that is used to respond to the user
** when they have chosen a course.
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
*******************************************************************************/
%>
<%! 
   Connection conn; 
   PreparedStatement stmtSelectCourse;
   PreparedStatement stmtSelectUserCourse;
   PreparedStatement stmtInsertUserCourse;
   PreparedStatement stmtDeleteUserCourse;
   PreparedStatement stmtDeleteUserSCO;

   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: 'conn' is given the value of the database connection and 
   *         'stmtSelectCourse', 'stmtSelectUserCourse',
   *         'stmtInsertUserCourse', 'stmtDeleteUserCourse',
   *         'stmtDeleteUserSco' are given the values of their respective
   *         SQL strings.
   *
   * Description: This function sets the driverName and connectionURL
   *              variables and establishes the database connection.  The
   *              SQL strings are also converted and assigned  to prepared
   *              statements.
   *********************************************************************/
   public void jspInit() 
   {
      try
      {
          String sqlSelectUserCourse
           = "SELECT * FROM UserCourseInfo WHERE UserID = ? AND CourseID = ?";
           
          String sqlSelectCourse
           = "SELECT * FROM CourseInfo";
           
          String sqlInsertUserCourse
           = "INSERT INTO UserCourseInfo (UserID, CourseID) VALUES(?,?)";
           
          String sqlDeleteUserCourse
           = "DELETE FROM UserCourseInfo WHERE UserID = ? AND CourseID = ?";
           
          String sqlDeleteUserSCO
           = "DELETE FROM UserSCOInfo WHERE UserID = ? AND CourseID = ?";
          
          String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
          String connectionURL = "jdbc:odbc:SampleRTE";

//           Class.forName(driverName).newInstance();
//           conn = DriverManager.getConnection(connectionURL);
          Class.forName("com.mysql.jdbc.Driver");
		  conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
          stmtSelectCourse = conn.prepareStatement( sqlSelectCourse );
          stmtSelectUserCourse = conn.prepareStatement( sqlSelectUserCourse );
          stmtInsertUserCourse = conn.prepareStatement( sqlInsertUserCourse );
          stmtDeleteUserCourse = conn.prepareStatement( sqlDeleteUserCourse );
          stmtDeleteUserSCO = conn.prepareStatement( sqlDeleteUserSCO );
      }
      catch(SQLException e){e.printStackTrace();}
      catch(ClassNotFoundException e){e.printStackTrace();}
      catch(Exception e){e.printStackTrace();}
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
         stmtInsertUserCourse.close();
         stmtDeleteUserCourse.close();
         stmtDeleteUserSCO.close();
         conn.close();
      } 
      catch(SQLException e) {e.printStackTrace();}
   } 
%>
<%

try
{
   String userID = (String)session.getAttribute( "USERID" );
   
   String selectedCourses = "|";
   
   RTEFileHandler fileHandler = new RTEFileHandler();

   Enumeration requestNames = request.getParameterNames();
   String testString = "Course-";
   while( requestNames.hasMoreElements() )
   {
      String paramName = (String)requestNames.nextElement();
      int locSkillId = paramName.indexOf( testString );
          
      if( locSkillId != -1)
      {
         //String courseID = paramName.substring( testString.length() );
         String courseID = paramName;
         selectedCourses += courseID + "|";
         ResultSet userCourseRS = null;

         /*********************************************************************
         * Method: synchronized()
         * Input: stmtSelectUserCourse
         * Output: userCourseRS
         *
         * Description: Inserts the value of the variables 'userID' and
         *              'compID' into the prepared statement
         *              'stmtSelectUserCourse'.  The statement is then executed
         *              and the result assigned to 'userCourseRS'.
         *********************************************************************/
         synchronized( stmtSelectUserCourse )
         {
            stmtSelectUserCourse.setString( 1, userID );
            stmtSelectUserCourse.setString( 2, courseID );
            userCourseRS = stmtSelectUserCourse.executeQuery();
         }

         if ( userCourseRS.next() == false )
         {
            /******************************************************************
            * Method: synchronized()
            * Input: stmtInsertUserCourse
            * Output: stmtInsertUserCourse
            *
            * Description: Inserts the value of the variables 'userID' and
            *              'compID' into the prepared statement 
            *              'stmtInsertUserCourse'.  The statement is then
            *              executed, performing the insert.
            ******************************************************************/
            synchronized( stmtInsertUserCourse )
            {
               stmtInsertUserCourse.setString( 1, userID );
               stmtInsertUserCourse.setString( 2, courseID );
               stmtInsertUserCourse.executeUpdate();
            }
            
            fileHandler.setUserID( userID );
            fileHandler.setCourseID( courseID );
            fileHandler.initializeCourseFiles();

            //////////////////////////////////////////////////////////////////
            // Create an ADLOrganizations object for the user and the course
            /////////////////////////////////////////////////////////////////
            //System.out.println("About to open the sequencing file");

            String theWebPath = getServletConfig().getServletContext().getRealPath( "/" );
            String courseSeqFile = theWebPath + "/adl/CourseImports/" + courseID + "/sequence.obj";
            FileInputStream istream = new FileInputStream( courseSeqFile );
	         ObjectInputStream ois = new ObjectInputStream(istream);

	                     
            ADLOrganizations sequenceObj = (ADLOrganizations)ois.readObject();
            
	        istream.close();

            //////////////////////////////////////////////////////////////////
            // Create a file for that user in this specific course
            /////////////////////////////////////////////////////////////////
            //  Write the Sequencing Object to a file
            String sequencingFileName = theWebPath + "/adl/CourseImports/" + courseID + "/sequence." + 
                                        userID;
            java.io.File userSequence = new java.io.File(sequencingFileName);
            FileOutputStream ostream = new FileOutputStream(userSequence);
            ObjectOutputStream oos = new ObjectOutputStream(ostream); 
            oos.writeObject(sequenceObj);
            oos.flush();
            oos.close();
 
         }
      }
   }
   
   

   ResultSet courseRS = null;

   /*********************************************************************
   * Method: synchronized()
   * Input: stmtSelectCourse
   * Output: courseRS
   *
   * Description: 'stmtSelectCourse' is executed and this is assigned to
   *              the result set 'courseRS'.
   *********************************************************************/
   synchronized( stmtSelectCourse )
   {
      courseRS = stmtSelectCourse.executeQuery();
   }     

   while( courseRS.next() )
   {
      String courseID = courseRS.getString( "CourseID" );

      // Look for courses that are not selected for the user
      if( selectedCourses.indexOf( "|"+courseID+"|" ) == -1 )
      {
         //Now check if the user was enrolled in the course and delete
         ResultSet userCourseRS = null;

         /*********************************************************************
         * Method: synchronized()
         * Input: stmtSelectUserCourse
         * Output: userCourseRS
         *
         * Description: Inserts the value of the variable 'compID' into the
         *              prepared statement 'stmtDeleteComp'.  This statement is
         *              then executed and the result is assigned to
         *             'userCourseRS'.
         *********************************************************************/
         synchronized( stmtSelectUserCourse )
         {
            stmtSelectUserCourse.setString( 1, userID );
            stmtSelectUserCourse.setString( 2, courseID );
            userCourseRS = stmtSelectUserCourse.executeQuery();
         }
         if ( userCourseRS.next() == true )
         {
            synchronized( stmtDeleteUserCourse )
            {
               stmtDeleteUserCourse.setString( 1, userID );
               stmtDeleteUserCourse.setString( 2, courseID );
               stmtDeleteUserCourse.executeUpdate();
               
               fileHandler.setUserID( userID );
               fileHandler.setCourseID( courseID );
               fileHandler.deleteCourseFiles();
            }
            
            synchronized( stmtDeleteUserSCO )
            {
               stmtDeleteUserSCO.setString( 1, userID );
               stmtDeleteUserSCO.setString( 2, courseID );
               stmtDeleteUserSCO.executeUpdate();
            }
         }
      }
   }
}
catch(Exception e)
{
   e.printStackTrace();   
}

%>
<html>
<head>
<title>Process Course Registration</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<META http-equiv="expires" CONTENT="Tue, 05 DEC 2000 01:00:00 GMT">
<META http-equiv="Pragma" CONTENT="no-cache">
</head>
<body bgcolor="#FFFFFF">
<jsp:include page="gotoMenu.jsp" flush="true" />

<p><font size="4">Course Registration Processing Complete</font></p>
</body>
</html>
