<%@page import = "java.sql.*, java.util.*, org.adl.util.*" %>

<%
/*******************************************************************************
**
** Filename:  sequencingEngine.jsp
**
** File Description:   This file determines which item should be launched in
**                     the current course.  It responds to the following events
**                     Next - Launch the next sco or asset
**                     Previous - Launch the previous sco or asset
**                     Menu - Launch the selected item
**
** Author: ADL Technical Team
**
** Contract Number:
** Company Name: CTC
**
** Module/Package Name:
** Module/Package Description:
**
** Design Issues: This is a proprietary solution for a sequencing engine.  
**                This version will most likely be replaced when the SCORM
**                adopts the current draft sequencing specification.
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

//  Booleans for a completed course and request type
boolean courseComplete = true;
boolean wasAMenuRequest = false;
boolean wasANextRequest = false;
boolean wasAPrevRequest = false;
boolean wasFirstSession = false;
boolean empty_block = false;

//  The type of controls shown
String control = new String();
//  The next item that will be launched
String nextItemToLaunch = new String();
//  The type of button request if its a button request
String buttonType = new String();
//  whether the launched unit is a sco or an asset
String type = new String();
// is the item a block with no content
String item_type = new String();
//is the identifier column 
String identifier = new String();

// The courseID is passed as a parameter on initial launch of a course
String courseID = (String)request.getParameter( "courseID" );
//  Get the requested sco if its a menu request
String requestedSCO = (String)request.getParameter( "scoID" );
//  Get the button that was pushed if its a button request
buttonType = (String)request.getParameter( "button" );

// Set boolean for the type of navigation request
if ( (! (requestedSCO == null)) && (! requestedSCO.equals("") ))
{
   wasAMenuRequest = true;
}
else if ( (! (buttonType == null) ) && ( buttonType.equals("next") ) )
{
   wasANextRequest = true;
}
else if ( (! (buttonType == null) ) && ( buttonType.equals("prev") ) )
{
   wasAPrevRequest = true;
}
else
{
   // First launch of the course in this session.
   wasFirstSession = true;
}
//  If the course has not been launched
if ( courseID != null )
{
   //  set the course ID
   session.setAttribute( "COURSEID", courseID );
}
else // Not the initial launch of course, use session data
{
   courseID = (String)session.getAttribute( "COURSEID" );
}

try
{
   //  Prepare the database connection and statements
   Connection conn; 
   PreparedStatement stmtSelectUserSCO;
   PreparedStatement stmtUpdateUserSCO;
   PreparedStatement stmtSelectCourse;
   PreparedStatement stmtSelectItemInfo;
   PreparedStatement stmtGetTypeUserSCO;
   
   //  Get a users sco and asset information
   String sqlSelectUserSCO
    = "SELECT * FROM UserSCOInfo WHERE UserID = ? AND CourseID = ? ORDER BY Sequence";

   //  Get the type info from a specific sco by a user
   String sqlGetTypeUserSco
    = "SELECT Type FROM UserSCOInfo WHERE UserID = ? AND CourseID = ? AND SCOID = ?";
   
   // Update sco and asset information (LessonStatus)
   String sqlUpdateUserSCO
    = "Update UserSCOInfo set LessonStatus = ? WHERE SCOID = ? AND CourseID = ?";

   //  Get the course information
   String sqlSelectCourse
    = "SELECT * FROM CourseInfo WHERE CourseID = ?";
   
   String sqlInsertUserCourse
    = "INSERT INTO UserCourseInfo (UserID, CourseID) VALUES(?,?)";
           
   String sqlDeleteUserCourse
    = "DELETE FROM UserCourseInfo WHERE UserID = ? AND CourseID = ?";
   String sqlSelectItemInfo
    = "SELECT * FROM ItemInfo WHERE CourseID = ?";
          
   String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
   String connectionURL = "jdbc:odbc:SampleRTE";

//    Class.forName(driverName).newInstance();
//    conn = DriverManager.getConnection(connectionURL);
   Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection(
			"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
			"allwin", "3edc$RFV5tgb"); 
   stmtSelectUserSCO = conn.prepareStatement( sqlSelectUserSCO );
   stmtGetTypeUserSCO = conn.prepareStatement( sqlGetTypeUserSco );
   stmtUpdateUserSCO = conn.prepareStatement( sqlUpdateUserSCO );
   stmtSelectCourse = conn.prepareStatement( sqlSelectCourse );
   stmtSelectItemInfo = conn.prepareStatement( sqlSelectItemInfo );
   
   //  Get the user's id
   String userID = (String)session.getAttribute( "USERID" );
   
   //  Execute the course info database query
   ResultSet courseInfo = null;
   synchronized( stmtSelectCourse )
   {
      stmtSelectCourse.setString( 1, courseID );
      courseInfo = stmtSelectCourse.executeQuery();
   }
   
   // Move into the first record in the record set
   while ( courseInfo.next() )
   {
      //  Get the CONTROL column
      control = courseInfo.getString("Control");
      session.setAttribute( "control", control );
   }
   
   //  Get the session exit flag to see if its a logout request
   String exitFlag = (String)session.getAttribute( "EXITFLAG" );
       
   if ( exitFlag != null && exitFlag.equals( "true" ) )
   {
      //  It is a logout, so redirect to the logout page
      session.removeAttribute( "EXITFLAG" );
      response.sendRedirect("logout.jsp");
   }
   else  // It is a navigation request
   {
       //  Get the users record of the course items
      ResultSet userSCORS = null;
      synchronized( stmtSelectUserSCO )
      {
         stmtSelectUserSCO.setString( 1, userID );
         stmtSelectUserSCO.setString( 2, courseID );
         userSCORS = stmtSelectUserSCO.executeQuery();
      }
      // Initialize variables that help with sequencing
      String scoID = new String();
      String lessonStatus = new String();
      String launch = new String();
      
      //  If the user selected a menu option, handle appropriately
      if ( wasAMenuRequest )
      {
         ResultSet MenuInfo = null;
         synchronized( stmtSelectItemInfo )
         {
            stmtSelectItemInfo.setString( 1, courseID );
            MenuInfo = stmtSelectItemInfo.executeQuery();
         }
         // Move into the first record in the record set
         while ( MenuInfo.next() )
         {
            //  Get the TYPE column
            item_type = MenuInfo.getString("Type");
            identifier = MenuInfo.getString("Identifier");
           
            // the item is not an asset or sco, it is a contain block
            if  ((item_type.equals("")) && ( identifier.equals(requestedSCO)))
            {
               // Launch the next sco or item that is the first child
               // of the block item.
               MenuInfo.next();
               requestedSCO = MenuInfo.getString("Identifier");
               empty_block = true;
            }
               if ( empty_block)
               break;
         }

        // Handle appropriately for a menu request
        //  Get the last sco id that was taken
        String lastScoID = (String)session.getAttribute("SCOID");
        
        //  Loop through to find the next one to launch
        while ( userSCORS.next() )
        {
            scoID = userSCORS.getString("SCOID");
            lessonStatus = userSCORS.getString("LessonStatus");
            launch = userSCORS.getString("Launch");
            type = userSCORS.getString("Type");
            
            if ( requestedSCO.equals(scoID) ) 
            {
               nextItemToLaunch = launch;
               courseComplete = false;
               session.setAttribute( "SCOID", scoID );
               break;
            }
         }

         // insert the correct values in stmtUpdateUserSCO
         synchronized( stmtUpdateUserSCO )
         {
            stmtUpdateUserSCO.setString( 1, "completed" );
            stmtUpdateUserSCO.setString( 2, scoID );
            stmtUpdateUserSCO.setString( 3, courseID);
         }
         // If it is an asset, execute the query, marking the asset as completed.
         if ( (! (type == null) ) && type.equals("asset") )
         {
            stmtUpdateUserSCO.executeUpdate();
         }

       
      }
      else // It was a next request, previous request, or first launch of session (or auto)
      {

         //  If its auto or first session
         if ( wasFirstSession || ( control.equals( "auto" )) )
         {
            //  Launch the first item that is not in a completed state
            while ( userSCORS.next() )
            {
               scoID = userSCORS.getString( "SCOID" );
               lessonStatus = userSCORS.getString( "LessonStatus" );
               launch = userSCORS.getString( "Launch" );
               type = userSCORS.getString("Type");
               // Set nextItemToLaunch to the next incomplete sco or asset
               if ( ! (lessonStatus.equalsIgnoreCase( "completed" ) ) &&
                    ! (lessonStatus.equalsIgnoreCase( "passed" ) ) &&
                    ! (lessonStatus.equalsIgnoreCase( "failed" ) ) )
               {
                  nextItemToLaunch = launch;
                  courseComplete = false;
                  session.setAttribute( "SCOID", scoID );
                  break;
               }
            }
         }  //  Ends if it was the first time in for the session
         else if ( wasANextRequest )// Its a next request
         {
        
            // Handle the next request
            //  Get the last sco id that was taken
            String lastScoID = (String)session.getAttribute("SCOID");
            //  Boolean to trigger the correct sco to launch
            boolean timeToLaunch = false;
            
            //  Loop through to find the next one to launch
            while ( userSCORS.next() )
            {
               // Launch the next sequential sco
               scoID = userSCORS.getString("SCOID");
               lessonStatus = userSCORS.getString("LessonStatus");
               launch = userSCORS.getString("Launch");
               type = userSCORS.getString("Type");
               if ( timeToLaunch )
               {

                  nextItemToLaunch = launch;
                  courseComplete = false;
                  session.setAttribute( "SCOID", scoID );
                  break;
               }
                
               if ( lastScoID.equals(scoID) )
               {
                  timeToLaunch = true;
               }
             }
             // insert the correct values in stmtUpdateUserSCO
             synchronized( stmtUpdateUserSCO )
             {
                stmtUpdateUserSCO.setString( 1, "completed" );
                stmtUpdateUserSCO.setString( 2, scoID );
                stmtUpdateUserSCO.setString( 3, courseID);
             }
             // Execute the query, marking the asset as completed.
            
             if ( (! (type == null) ) && type.equals("asset") )
             { 
                stmtUpdateUserSCO.executeUpdate();
             }

         }  //  Ends if its a next request
         else if ( wasAPrevRequest )// Its a previous request
         {
            // Handle the previous request
            String lastScoID = (String)session.getAttribute("SCOID");
            String prevScoID = new String();
            String prevScoLaunch = new String();
            boolean timeToLaunch = false;
            int count = 0;
           
            while ( userSCORS.next() )
            {
               if ( timeToLaunch )
               {
                  // Launch the previous sequential sco or asset
                  nextItemToLaunch = prevScoLaunch;
                  courseComplete = false;
                  session.setAttribute( "SCOID", prevScoID );
                  break;
               }
               //  Get the previous scoID and launch
               prevScoID = scoID;
               prevScoLaunch = launch;
               
               //  Get the new info
               scoID = userSCORS.getString("SCOID");
               lessonStatus = userSCORS.getString("LessonStatus");
               launch = userSCORS.getString("Launch");
               type = userSCORS.getString("Type");
               count++;//the first time through the loop, check to see if
                      // the request was made by the first sco in the course
               if ( lastScoID.equals(scoID) )
               {
                  if ( count == 1)
                  {  prevScoID = scoID;
                     prevScoLaunch = launch;
                  }
                  timeToLaunch = true;
               }//end if
               }//end while
               
               if (! userSCORS.next())
                 {// Launch the previous sequential sco or asset
                  nextItemToLaunch = prevScoLaunch;
                  courseComplete = false;
                  session.setAttribute( "SCOID", prevScoID );
                  } 
                       
         }//end previous

      }  // Ends if it was a button request
      
   }  //  Ends if it was a navigation request

   //  If the course is complete redirect to the course
   //  complete page
   
   if ( courseComplete )
   {
      session.removeAttribute( "COURSEID" );
      response.sendRedirect("courseComplete.jsp"); 
   }
   else
   {
%>

<!-- ****************************************************************
**   Build the html 'please wait' page that sets the client side 
**   variables and refreshes to the appropriate course page
*******************************************************************-->  
<html>
   <head>
   <title>Sample Run-Time Environment - Sequencing Engine</title>
   <!-- **********************************************************
   **  This value is determined by the JSP database queries
   **  that are located above in this file
   **  Refresh the html page to the next item to launch  
   ***************************************************************-->
   <meta http-equiv="refresh" content="3; url=<%= nextItemToLaunch %>">
 
      <script language="JAVASCRIPT">
         function initLMSFrame()
         {
            // Set the type of control for the course in the LMS Frame 
            if ( window.opener == null )
            {
               window.top.frames[0].document.forms[0].control.value = "<%= control %>";
            }
            else //  Set up control type in the window opener (if its auto mode)
            {
               // The sequencingEngine.jsp file runs in the opened window if it is auto
               // mode so special cases exist
               window.opener.top.frames[0].document.forms[0].control.value = "<%= control %>";
            }
         }
      </script>
   </head>
         
   <body bgcolor="#FFFFFF" onload="initLMSFrame()">    
      <%  
         //  If control is not auto. work in this window. 
         if ( ! control.equals("auto") )
         {  %>
            <script language="javascript">
               // Hide the next and previous buttons if it is of type "choice".
               var ctrl = "<%= control %>";
               
               if (ctrl == "choice")
               { 
                  window.top.frames[0].document.forms[0].next.style.visibility = "hidden";
                  window.top.frames[0].document.forms[0].previous.style.visibility = "hidden";
                  window.top.frames[0].document.forms[0].quit.style.visibility = "visible";
               }
               else
               {
                  // Make the buttons visible
                  window.top.frames[0].document.forms[0].next.style.visibility = "visible";
                  window.top.frames[0].document.forms[0].previous.style.visibility = "visible";
                  window.top.frames[0].document.forms[0].quit.style.visibility = "visible";
               }
            </script>
 
          
            <p><font size="4">
               Please Wait....
            </font></p>
         </body>
      </html> 
   <% } // Ends if its not auto sequencing... then configure controls  
      else {
     	 %> 
     	 	<script>
     	 		alert("auto")
     	 		window.open(<%=nextItemToLaunch%>);
     	 	</script>
     	 <%
      }
   %>  
      
<%
   }  // Ends else display the please wait page

}
catch ( Exception e )
{ 
   out.println("!! Exception Occurred: " + e + " !!");
} 
%>