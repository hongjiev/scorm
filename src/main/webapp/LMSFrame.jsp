<html>
<!--
/*******************************************************************************
**
** Filename: LMSFrame.jsp
**
** File Description: This page contains the API Adapter applet.  The API 
**                   Adapter applet has no visual display elements and is 
**                   therefore invisible to the user.  Note that the API 
**                   Adapter object is exposed to SCOs via the LMSMain.htm 
**                   page.  The SCOs communicate with the Run-time 
**                   Environment through this API.  This page also contains
**                   the Run-time Environment login and logout buttons and the
**                   button for Next, Previous, and Quit.
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
-->
<head>
<meta http-equiv="expires" content="Tue, 20 Aug 1999 01:00:00 GMT">
<meta http-equiv="Pragma" content="no-cache">
<title>ADL Sample Run-Time Environment Version 1.2.2</title>
<script type="text/javascript" src="api.js"></script>
<script language=javascript>
/****************************************************************************
**
** Function: LMSIsInitialized()
** Input:   none
** Output:  boolean
**
** Description:  This function returns a boolean that represents where or 
**               no LMSInitialize() has been called by the SCO.
**
***************************************************************************/
function LMSIsInitialized()
{
   // Determines if the API (LMS) is in an initialized state.
   // There is no direct method for determining if the LMS API is initialized
   // for example an LMSIsInitialized function defined on the API so we'll try
   // a simple LMSGetValue and trap for the LMS Not Initialized Error
   
   var value = API.LMSGetValue("cmi.core.student_name");
   var errCode = API.LMSGetLastError().toString();
   if (errCode == 301)
   {
      return false;
   }
   else
   {
      return true;
   }
}

/****************************************************************************
**
** Function: login_onclick()
** Input:   none
** Output:  none
**
** Description:  This function changes the content frame to the login page,
**               as "hides" the login button.
**
***************************************************************************/
function login_onclick() 
{
   window.parent.frames[3].document.location.href = "LMSLogin.htm";
   if ( document.layers != null )
   {
      swapLayers();
   }
   else if ( document.all != null )
   {
      window.document.forms[0].login.style.visibility = "hidden";
   }
   else
   {
      //Niether IE nor Netscape is being used
      alert("your browser may not be supported");
   }
}

/****************************************************************************
**
** Function: logout_onclick()
** Input:   none
** Output:  none
**
** Description:  This function redirects to logout.jsp, but first checks
**               to see if there is a course executing.
**
***************************************************************************/
function logout_onclick() 
{
   // two known potential difficulties exist with having the logout
   // button in this frame...   The first is that the user may not
   // have exited the lesson before attempting to log out.  The second
   // problem is that a child window may be open containing the lesson
   // if the user has not exited.   To deal with these two cases, we'll
   // force the user to exit the lesson before we allow a logout.

   if (LMSIsInitialized() == true)
   {
      // we're making an assumtion that the user is trying
      // to log out without first exiting the lesson via the
      // appropriate means - because if the user had exited
      // the lesson, the LMS would not still be initialized.
      var  mesg = "You must exit the lesson before you logout";
      alert(mesg);
   }
   else
   {
      window.parent.frames[3].location.href="logout.jsp";
   }

   return;
}

/****************************************************************************
**
** Function: changeSCOContent()
** Input:   none
** Output:  none
**
** Description:  This function enables the appropriate controls so that
**               the user can progress to the next item.
**
***************************************************************************/
function changeSCOContent()
{
   //This function is called by the APIAdapterApplet during 
   //LMSFinish.
   if ( document.layers != null )
   {
     swapLayers();
   }
   else if ( document.all != null )
   {
     ctrl = window.document.forms[0].control.value; 
     
     if ( ctrl == "mixed" || ctrl == "flow" || ctrl == "" || ctrl == null )
     {
         window.top.frames[0].document.forms[0].next.style.visibility = "visible"; 
         window.top.frames[0].document.forms[0].previous.style.visibility = "visible";
         window.top.frames[0].document.forms[0].quit.style.visibility = "visible";
         window.top.frames[0].document.forms[0].next.disabled = false;
         window.top.frames[0].document.forms[0].previous.disabled = false;
     }
     else if ( ctrl == "choice" )
      { 
         window.top.frames[0].document.forms[0].next.style.visibility = "hidden"; 
         window.top.frames[0].document.forms[0].previous.style.visibility = "hidden"; 
         window.top.frames[0].document.forms[0].quit.style.visibility = "visible";
      }  
      else if ( ctrl = "auto" )
      {
         window.top.contentWindow.document.location.href = "sequencingEngine.jsp";
      }
   }
        
   else
   {
     //Neither IE nor Netscape is being used
     alert("your browser may not be supported");
   }


}

/****************************************************************************
**
** Function: nextSCO()
** Input:   none
** Output:  none
**
** Description:  This function is called when the user clicks the "next"
**               button.  The Sequencing Engine is called, and all relevant
**               controls are affected. 
**
***************************************************************************/
function  nextSCO()
{
   // This is the launch line for the next SCO...
   // The Sequencing Engine determines which to launch and
   // serves it up into the LMS's content frame or child window - depending
    //on the method that was used to launch the content in the first place.
   var scoWinType = typeof(window.parent.frames[3].scoWindow);
   var theURL = "pleaseWait.jsp?button=next";
  
   if (scoWinType != "undefined" && scoWinType != "unknown")
   {
      if (window.parent.frames[3].scoWindow != null)
      {
         // there is a child content window so display the sco there.
         window.parent.frames[3].scoWindow.document.location.href = theURL;
         window.parent.frames[2].document.location.href = "code.jsp";
      }
      else
      {
         window.parent.frames[3].document.location.href = theURL;
         window.parent.frames[2].document.location.href = "code.jsp";
      }
   }
   else
   {
      window.parent.frames[3].document.location.href = theURL;
      window.parent.frames[2].document.location.href = "code.jsp";
   }
   if ( document.layers != null )
   {
      swapLayers();
   }
   else if ( document.all != null )
   {
     // window.top.frames[0].document.forms[0].next.disabled = true;
     // window.top.frames[0].document.forms[0].previous.disabled = true;
   }
   else
   {
      //Neither IE nor Netscape is being used
      alert("your browser may not be supported");
   }  
}


/****************************************************************************
**
** Function: previousSCO()
** Input:   none
** Output:  none
**
** Description:  This function is called when the user clicks the "previous"
**               button.  The Sequencing Engine is called, and all relevant
**               controls are affected. 
**
***************************************************************************/
function  previousSCO()
{

   // This function is called when the "Previous" button is clicked.
   // The LMSLesson servlet figures out which SCO to launch and
   // serves it up into the LMS's content frame or child window - depending
   //on the method that was used to launch the content in the first place.

   var scoWinType = typeof(window.parent.frames[3].scoWindow);
   var theURL = "pleaseWait.jsp?button=prev";
   
   if (scoWinType != "undefined" && scoWinType != "unknown")
   {
      if (window.parent.frames[3].scoWindow != null)
      {
         // there is a child content window so display the sco there.
         window.parent.frames[3].scoWindow.document.location.href = theURL;
         window.parent.frames[2].document.location.href = "code.jsp";
      }
      else
      {
         window.parent.frames[3].document.location.href = theURL;
         window.parent.frames[2].document.location.href = "code.jsp";
      }
   }
   else
   {
      window.parent.frames[3].document.location.href = theURL;
      window.parent.frames[2].document.location.href = "code.jsp";

      //  scoWindow is undefined which means that the content frame
      //  does not contain the lesson menu at this time.
   }
   if ( document.layers != null )
   {
      swapLayers();
   }
   else if ( document.all != null )
   {
     // window.document.forms[0].next.disabled = true;
     // window.document.forms[0].previous.disabled = true;
   }
   else
   {
     //Neither IE nor Netscape is being used
      alert("your browser may not be supported");
   }
  
}

/****************************************************************************
**
** Function: closeSCOContent()
** Input:   none
** Output:  none
**
** Description:  This function exits out of the current lesson and presents
**               the RTE menu. 
**
***************************************************************************/
function closeSCOContent()
{
   var scoWinType = typeof(window.parent.frames[3].window);
   
   ctrl = window.document.forms[0].control.value;
   
   if ( ctrl == "auto" )
   {
      window.parent.frames[2].document.location.href = "code.jsp";
      window.top.frames[3].location.href = "LMSMenu.jsp"
      window.top.contentWindow.close();
   }
   else
   {
      window.parent.frames[2].document.location.href = "code.jsp";   
      if (scoWinType != "undefined" && scoWinType != "unknown")
      {
         if (window.parent.frames[3].scoWindow != null)
         {      
            // there is a child content window so close it.
            window.parent.frames[3].scoWindow.close();
            window.parent.frames[3].scoWindow = null;
         }
         window.parent.frames[3].document.location.href = "LMSMenu.jsp";
      }
      else
      {
         //  scoWindow is undefined which means that the content frame
         //  does not contain the lesson menu so do nothing...
      }
   }   
}

/****************************************************************************
**
** Function: swapLayers()
** Input:   none
** Output:  none
**
** Description:  This function is used to swap the login and logout buttons
**
***************************************************************************/
function swapLayers()
{
   if ( document.loginLayer.visibility == "hide" )
   {
      document.logoutLayer.visibility = "hide";
      document.loginLayer.visibility = "show";
   }
   else
   {
      document.loginLayer.visibility = "hide";
      document.logoutLayer.visibility = "show";
   }
}

/****************************************************************************
**
** Function: init()
** Input:   none
** Output:  none
**
** Description:  This function sets the API variable and hides the
**               the navigation buttons
**
***************************************************************************/
function init()
{
//    API = this.document.APIAdapter;
   API = APIAdapter2;
   window.top.frames[0].document.forms[0].next.style.visibility = "hidden"; 
   window.top.frames[0].document.forms[0].previous.style.visibility = "hidden";
}

/****************************************************************************
**
** Function: doConfirms()
** Input:   none
** Output:  none
**
** Description:  This function prompts the user that they may lose
**               data if they exit the course
**
***************************************************************************/
function doConfirm()
{
    if( confirm("If you quit now the course information may not be saved.  Do you wish to quit?") )
    {
       window.parent.frames[3].document.location.href = "LMSMenu.jsp";
    }
    else
    {
    }
}
</script>
</head>

<body onload="init();">

<!--  For MS IE Use the Java 1.3 JRE Plug-in instead of the Browser's JVM
      Netscape 4.x can't use the plug-in because it's liveconnect doesn't work with the Plug-in
-->
<form name="buttonform">

    <object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93"
            width="0" height="0" id="APIAdapter"
            codebase="http://java.sun.com/products/plugin/1.3/jinstall-13-win32.cab#Version=1,3,0,0">
    <param name = "code" value = "org/adl/samplerte/client/APIAdapterApplet.class" >
    <param name = "codebase" value = "/adl" >
    <param name = "type" value="application/x-java-applet;version=1.3">
    <param name = "mayscript" value="true" >
    <param name = "scriptable" value="true" >
    <param name = "archive" value = "cmidatamodel.jar,lmsclient.jar,debug.jar" >
    <comment>
    <applet code="org/adl/samplerte/client/APIAdapterApplet.class" 
            archive="cmidatamodel.jar,lmsclient.jar,debug.jar" 
            codebase="/adl"
            src="/adl" 
            height="1" 
            id="APIAdapter" 
            name="APIAdapter" 
            width="1" 
            mayscript="true">
    </applet>
    </comment>
    </object>
    
    <applet code="org.adl.samplerte.util.TestApplet.class"
    archive="testApplet.jar"
    id="testApplet"
    name="testApplet"
    codebase="."
    width="100"
    height="100">
    aaaa</applet>
       
         
    <table width="800">
    <tr valign="top"> 
       <td>
          <!--IMG ALIGN="Left" SRC="/adl/adlLogo.gif"/-->
          <img align="Left" src="/adl/tiertwo.gif"/>
       </td>
       <td align="center">   
          <font color="purple" face="Tahoma" size="2"><b>
             Advanced Distributed Learning <br>
             Sharable Content Object Reference Model (SCORM&reg;) Version 1.2<br>
          </b></font>
          <font color="purple" face="Tahoma" size="2"><b>
             Sample Run-Time Environment<br>
          </b></font>
          <font color="purple" face="Tahoma" size="2"><b>
             Version 1.2.2
          </b></font>
       </td>
    </tr>
    </table> 
    
     
    <input type="hidden" name="control" value="" />            
    
       
    <!--NOLAYER-->
    <table width="600" align="left" cellspacing=0>
    <tr>
       <td> 
          <input type="button" value="Log In" id="login" name="login" language="javascript"
                 onclick="return login_onclick();">&nbsp;       
          </td>
       <td align="left">
          <input type="button" value="Log Out" id="logout" name="logout" style="visibility: hidden"
                 language="javascript" onclick="return logout_onclick();"> 
       </td>
       <TD ALIGN="center">
             <INPUT type="button" ALIGN = "right" VALUE="    Quit    " name="quit" language="javascript"
                ONCLICK="doConfirm();" STYLE="visibility: hidden">
       </TD>
       <td align="left">
          <input type="button" align ="left" value="Glossary" id="glossary" name="glossary"  language="javascript"
                 onclick="return nextSco();"  style="visibility: hidden" disabled>&nbsp; 
       </td>
       <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
       <td align="center"> 
          
          <input type="button" align ="right" value="<- Previous" id="previous" name="previous"  language="javascript"
                      onclick="return previousSCO();"  style="visibility: hidden"> 
          
       </td>
       <td align="center">
             
             <input type="button" align ="right" value="    Next ->    " id="next" name="next"  language="javascript"
                    onclick="return nextSCO();" style="visibility: hidden">   
       </td>
    </tr>
</table>
    
<!--/NOLAYER-->
</form>
<script type="text/javascript">
// 	var tt = document.getElementById("testApplet");
// 	console.log(tt)
// 	tt.ttt();
</script>
</body>
</html>
