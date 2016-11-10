<%@page import = "java.sql.*, java.util.*, java.io.*" %>

<%
/*******************************************************************************
**
** Filename:  deleteUser.jsp
**
** File Description:     
**
** This file selects users to be deleted.
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
   <title>Delete User</title> 
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
   <form method="post" action="processDeleteUser.jsp" name="deleteUser" ONSUBMIT="return checkData()">
   <table width="458" border="0">
      <tr>
         <td colspan="2" bgcolor="#5E60BD">
            <font face="tahoma" size="2" color="#ffffff"><b>
               &nbsp;Please select which user you would like to delete
            </b></font>
         </td>
      </tr>
      <%!
         Connection conn;
         PreparedStatement stmtSelectUsers;
         String TempString;
         
         /*********************************************************************
         * Method: jspInit()
         * Input: none
         * Output: conn and stmtSelectUsers are given new values
         *
         * Description: This function sets the driverName and connectionURL
         *              variables and establishes the database connection.  The
         *              SQL string is also assigned and converted to a prepared
         *              statement.
         *********************************************************************/
         public void jspInit()
         {
            try
            {
               String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
               String connectionURL = "jdbc:odbc:SampleRTE";
//                Class.forName(driverName).newInstance();
//                conn = DriverManager.getConnection(connectionURL);
               Class.forName("com.mysql.jdbc.Driver");
   			conn = DriverManager.getConnection(
   					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
   					"allwin", "3edc$RFV5tgb");
               //Query String to obtain Users
               String sqlSelectUsers = "SELECT * FROM UserInfo WHERE Active = yes ORDER BY LastName";
               stmtSelectUsers = conn.prepareStatement( sqlSelectUsers );
            }
            catch(SQLException e){TempString = "SQL Exception";}
            //catch(ClasNotFoundException e){}
            catch(Exception e){TempString = "Caught General Exception";}
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
               stmtSelectUsers.close();
               conn.close();
            }
            catch(SQLException e) {}
         }
      %>

      <%
         try
         {
            ResultSet usersRS;
            String userID = null;
            String userLastName = null;
            String userFirstName = null;
            
            usersRS = stmtSelectUsers.executeQuery();

            // Loops through all of the users and outputs each one, along with
            // a checkbox, into the table.
            while( usersRS.next() )
            {
               userID = usersRS.getString("UserID");
               userLastName = usersRS.getString("LastName");
               userFirstName = usersRS.getString("FirstName");

               %>
               <tr>
                  <td width='10%'>
                     <input type='checkbox' name='chkUser' value='<%=userID%>'/>
                  </td>
                  <td>
                     <%=userLastName%>, <%=userFirstName%>
                  </td>
               </tr>
               <%
            }
         }
         catch(Exception e) {}
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
   </form>
</body>
</html>
