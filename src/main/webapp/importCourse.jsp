<%
/*******************************************************************************
**
** Filename:  importCourse.jsp
**
** File Description:  This file allows the user to enter a name for a new
**                    course, and select the zip
**                    file that contains the manifest and course content.   
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
<html>
<head>
   <title>Sample Run-Time Environment - Import Course</title>
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
   function MM_reloadPage( init )
   { 
      if (init == true) with (navigator)
      {               
         if ( (appName == "Netscape") && (parseInt(appVersion) == 4) )
         {
            document.MM_pgW = innerWidth;
            document.MM_pgH = innerHeight;
            onresize = MM_reloadPage;
         }
      }
      else if (innerWidth != document.MM_pgW || innerHeight != document.MM_pgH)
      {
         location.reload();
      }
   }
   MM_reloadPage(true);
   
   /****************************************************************************
   **
   ** Function:  checkValues()
   ** Input:   none
   ** Output:  boolean
   **
   ** Description:  This function ensures that there are values in each text
   **               box before submitting
   **
   ***************************************************************************/
   function checkValues()
   {
      if ( courseInfo.coursename.value == "" || 
           courseInfo.coursezipfile.value == "" ) 
      {
         alert( "You must enter a value for all items" );
         return false;
      }
      
      courseInfo.theZipFile.value = courseInfo.coursezipfile.value;
      return true;
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
   function newWindow( pageName )
   {
      window.open(pageName, 'Help', 
      "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=500,height=500");
   }
   
   </script>
</head>

<body bgcolor="#FFFFFF">

<jsp:include page="gotoMenu.jsp" flush="true" />

    
<form method="post" action="LMSCourseImport.jsp" name="courseInfo"
      onSubmit="return checkValues()" enctype="multipart/form-data">

   <p>
   <font face="tahoma" size="3"><b>
      Course Import
   </b></font>
   </p>
   
   
   <table width="550" border="0" align="left">
      <tr>
         <td bgcolor="#5E60BD" colspan="2">
            <font face="tahoma" size="2" color="#ffffff"><b>
               &nbsp;Please provide the following course information:
            </b></font>
         </td>
      </tr>
      <tr> 
         <td>
            <font face="tahoma" size="2">
               Enter the title you want to use for the course you wish to import:
            </font>
         </td>
      </tr>
      <tr>
         <td width="49%"> 
            <input id="coursename" name="coursename" type=text>
         </td>
      </tr>
      <tr> 
         <td width="51%">&nbsp;</td>
      </tr>
      <tr> 
         <td>
            <font face="tahoma" size="2">
               Enter the name of the Zip file containing your course 
               content that you wish to import:
            </font>
         </td>
      </tr>
      <tr>
         <td width="49%"> 
            <input id="coursezipfile" name="coursezipfile" type=file>
         </td>
      </tr>
      <tr> 
         <td width="51%">&nbsp;</td>
      </tr>
      <tr>
         <td>
            <font face="tahoma" size="2">
               Select the type of navigation controls that you would like present during the course.
               <br >
               <i>See the 'Help' Section for details</i>
            </font>
         </td>
      </tr>
      <tr>
         <td>
            Flow&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="controltype" value="flow" checked>
         </td>
      </tr>
      <tr>
         <td>
            Choice&nbsp;
            <input type="radio" name="controltype" value="choice">
         </td>
      </tr>
      <tr>
         <td>
            Auto&nbsp;
            <input type="radio" name="controltype" value="auto">
         </td>
      </tr>


      <tr>
         <td width="100%" colspan="2">&nbsp;</td>
      </tr>
      <tr> 
         <td width="100%" colspan="2">  
            <input type="submit" name="Submit" value="Submit">
         </td>
      </tr>
      <tr>
         <td>
            <br>
            <a href="javascript:newWindow('importHelp.htm');">Help!</a>
         </td>
      </tr>
   </table>

   <input type=hidden name="theManifest">
   <input type=hidden name="theZipFile">
</form>

</body>
</html>