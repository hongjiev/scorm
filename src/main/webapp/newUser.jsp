<%
/*******************************************************************************
**
** Filename:  newUser.jsp
**
** File Description:   This file allows an admin to enter information to
**                     create a new user account.
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
<html>
<head>
   <title>Add New User</title>
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
      if (init==true) with (navigator)
      {
         if ( (appName=="Netscape")&&(parseInt(appVersion)==4) )
         {
            document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage;
         }
      }
      else if ( (innerWidth!=document.MM_pgW) || (innerHeight!=document.MM_pgH) ) 
      {
         location.reload();
      }
   }
   //MM_reloadPage( true );

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
      if ( newUser.userID.value == "" || newUser.firstName.value == "" || 
           newUser.lastName.value == "" || newUser.password.value == "" || 
           newUser.cPassword.value == "" )
      {
         alert ( "You must provide a value for all fields!!" );
         return false;
      }

      if ( newUser.password.value != newUser.cPassword.value)
      {
         alert ( "Password and confirmed password are not the same!!" );
         return false;
      }

   }
   
   /****************************************************************************
   **
   ** Function:  newWindow()
   ** Input:   pageName
   ** Output:  none
   **
   ** Description:  This function opens the help window
   **
   ***************************************************************************/
   function newWindow(pageName)
   {
      window.open(pageName, 'Help', 
      "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=500,height=500");
   }
   
   </script>
</head>

<body bgcolor="#FFFFFF">

<jsp:include page="gotoMenu.jsp" flush="true" />

<%
  
String newUserError = (String)session.getAttribute( "NEWUSERERROR" );
if ( newUserError != null )
{
   if ( newUserError.equals( "dupid" ))
   {
%>
      <h2>The following error was caught</h2>
      <p>User ID already exists, please choose another ID</p>
<%
      session.removeAttribute( "NEWUSERERROR" );
   }
%>
<%
}
%>
    
<%
String userID = (String) session.getAttribute( "NEWUSERID" );
String firstName = (String) session.getAttribute( "NEWUSERFN" );
String lastName = (String) session.getAttribute( "NEWUSERLN" );


%>
   
<p>
<font face="tahoma" size="3"><b>
   Add a New User
</b></font>
</p>
    
<form method="post" action="processNewUser.jsp" name="newUser" onSubmit="return checkData()">
   <table width="450" border="0" align="left">
      <tr>
         <td bgcolor="#5E60BD" colspan="2">
            <font face="tahoma" size="2" color="#ffffff"><b>
               &nbsp;Please provide the following new user information:
            </font>
         </td>
      </tr>
      <tr>
         <td width="37%">
            User ID:
         </td>
         <td width="63%">
            <%
            
            if ( userID != null )
            { 
            %>
               <input type="text" name="userID" value="<%= userID %>">
            <%
            }
            else
            {
            %>
               <input type="text" name="userID"> 
            <%
            }
            %>
         </td>
      </tr>
      <tr>
         <td width="37%">First Name:</td>
            <td width="63%">
            <%
               if ( firstName != null )
               {
            %>
                  <input type="text" name="firstName" value="<%= firstName %>">
               <%
               }
               else
               { 
               %>
                  <input type="text" name="firstName">  
               <%
               }
               %>
           </td>
        </tr>
        <tr>
          <td width="37%">Last Name:</td>
             <td width="63%">
             <%
             if ( lastName != null )
             {
             %>
                <input type="text" name="lastName" value="<%= lastName %>">
             <%
             }
             else
             { 
             %> 
                <input type="text" name="lastName">
             <%
             }
             %>
             </td>
         </tr>
         <tr>
             <td width="37%">
                Password:
             </td>
             <td width="63%">
                 <input type="password" name="password">
             </td>
         </tr>
         <tr>
             <td width="37%">
                Password Confirmation:
             </td>
             <td width="63%">
                 <input type="password" name="cPassword">
             </td>
         </tr>
         <tr>
             <td width="37%">
                Admin:
             </td>
             <td width="63%">
                 <select name="admin">
                     <option>No</option> <option>Yes</option>
                 </select>    
             </td>
         </tr>
         <tr>
             <td width="37%">
                &nbsp;
             </td>
             <td width="63%">
                &nbsp;
             </td>
         </tr>
         <tr>
            <td colspan="2" align="center">     
               <input type="submit" name="Submit" value="Submit">
            </td>
         </tr>
         <tr>
            <td colspan="2">
               <br><br>      
               <a href="javascript:newWindow('newUserHelp.htm');">Help!</a>
            </td>
         </tr>
     </table>
</form>
<p>
&nbsp;
</p>
</body>
</html>
