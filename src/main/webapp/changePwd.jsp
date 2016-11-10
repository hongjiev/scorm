<%@page import = "java.sql.*, java.util.*, java.io.*" %>

<%
/*******************************************************************************
**
** Filename:  changePwd.jsp
**
** File Description:     
**
** This file provides an interface for a user to change their password.
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
   <title>Change Password</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    
   <script language="JavaScript">
   
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
   {
      if ( init==true ) with ( navigator ) 
      {
         if ( ( appName=="Netscape" ) && ( parseInt(appVersion)==4 ) ) 
         {
            document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage;
         }
      } 
      else if ( innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH ) 
      {   
         location.reload();
      }
   }
   
   MM_reloadPage(true);
   /****************************************************************************
   **
   ** Function:  checkData()
   ** Input:   none
   ** Output:  boolean
   **
   ** Description:  This function ensures that there are values in each text
   **               box before submitting
   **
   ***************************************************************************/
	function checkData() 
   {		
      if ( (changePwd.oldPwd.value == "") || (changePwd.newPwd.value == "") || 
           (changePwd.newPwdConfirm.value == "") )
      {
         alert ( "You must provide a value for all fields!!" );
         return false;
      }

      if ( changePwd.newPwd.value != changePwd.newPwdConfirm.value)
      {
         alert ( "New password and confirmed new password are not the same!!" );
         return false;
      }

   }
   
   /****************************************************************************
   **
   ** Function:  newWindow()
   ** Input:   pageName = Name of the window
   ** Output:  none
   **
   ** Description:  This method opens a window named <pageName>
   **
   ***************************************************************************/
   function newWindow(pageName)
   {
      window.open(pageName, 'Help', 
      "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=500,height=500");
   }
	 
   // -->
	</script>
</head>      
      
<body bgcolor="FFFFFF">
<jsp:include page="gotoMenu.jsp" flush="true" />
<p>
<font face="tahoma" size="3"><b>
Change Password
</b></font>
</p>
 
<form method="post" action="processChangePwd.jsp" name="changePwd" 
      onSubmit="return checkData()">
 
      <table width="450" border="0" align="left">
         <tr>
            <td bgcolor="#5E60BD" colspan="2">
               <font face="tahoma" size="2" color="#ffffff"><b>
                  &nbsp;Please provide the following information:
               </font>
            </td>
         </tr>
			<tr>
				<td width="37%">
               <font face="tahoma" size="2">
					Old Password:
               </font>
				</td>
				<td width="63%">
					<input type="text" name="oldPwd" maxlength="50">
            </td>
			</tr>
			<tr>
				<td width="37%">
               <font face="tahoma" size="2">
					   New Password:
               </font>
				</td>
				<td width="63%">
					<input type="text" name="newPwd" maxlength="50">
				</td>
			</tr>
			<tr>
				<td width="37%">
               <font face="tahoma" size="2">
					   Confirm New Password:
				   </font>
            </td>
				<td width="63%">
					<input type="text" name="newPwdConfirm" maxlength="50">
				</td>
			</tr>
			<tr>
				<td width="37%">&nbsp;</td>
				<td width="63%">&nbsp;</td>
			</tr>
         <tr>
            <td align="center" colspan="2">
			      <input type="submit" name="Submit" value="Submit Form">
            </td>
         </tr>
         <tr>
            <td colspan="2">
               <br><br>      
               <a href="javascript:newWindow('changePwdHelp.htm');">Help!</a>
            </td>
         </tr>
		</table>

</form>

</body>
</html>

