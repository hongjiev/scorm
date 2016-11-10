<%@page import = "java.util.*" %>

<%
/*******************************************************************************
**
** Filename:  pleaseWait.jsp
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
//  The type of button request if its a button request
String buttonType = new String();
String request_type = new String();


//  Get the requested sco if its a menu request
String requestedSCO = (String)request.getParameter( "scoID" );
//  Get the button that was pushed if its a button request
buttonType = (String)request.getParameter( "button" );

// Set boolean for the type of navigation request
if ( (! (requestedSCO == null)) && (! requestedSCO.equals("") ))
{
   request_type = "sequencingEngine.jsp?scoID="+requestedSCO;
   }
else if ( (! (buttonType == null) ) && ( buttonType.equals("next") ) )
{
   request_type = "sequencingEngine.jsp?button=next";
}
else if ( (! (buttonType == null) ) && ( buttonType.equals("prev") ) )
{
   request_type = "sequencingEngine.jsp?button=prev";
}%>





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
   <meta http-equiv="refresh" content="2; url=<%=request_type%>">
</head>
<body><br>

            <p></p>
         </body>
      </html> </body>