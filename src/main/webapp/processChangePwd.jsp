<%@page import = "java.sql.*, java.util.*, java.io.*" %>
<%
/*******************************************************************************
**
** Filename:  processChangePwd.jsp
**
** File Description:   This file processes a change in password.
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
   **************************************************************************
   function MM_reloadPage(init)
   {
       if (init==true) with (navigator)
       {
          if ((appName=="Netscape")&&(parseInt(appVersion)==4))
          {
             document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage;
          }
       }
       else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) 
       {
          location.reload();
       }
    } */

    </script>
</head>
   
<body bgcolor="#FFFFFF">
  
<jsp:include page="gotoMenu.jsp" flush="true" />
<%!
   Connection conn;
   PreparedStatement stmtGetPwd;
   PreparedStatement stmtUpdatePwd;

   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: conn is given the value of the database connection and
   *         stmtGetPwd and stmtUpdatePwd are assigned the values of the
   *         converted SQL strings. 
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

//          Class.forName(driverName).newInstance();
//          conn = DriverManager.getConnection( connectionURL );
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
         //query string to obtain password.
         String SQLQuery = "SELECT Password FROM UserInfo Where UserID = ?";
         stmtGetPwd = conn.prepareStatement( SQLQuery );
         //query string to update the database with the new password.
         String SQLQueryUpdate = "UPDATE UserInfo set Password = ? where UserID = ?";
         stmtUpdatePwd = conn.prepareStatement( SQLQueryUpdate );
      }
      catch (SQLException e) {}
      catch (ClassNotFoundException e) {}
      catch (Exception e) {}
   }

   /*********************************************************************
   * Method: jspDestroy()
   * Input: none
   * Output: none
   *
   * Description: Closes statements and the database connection.    
   *********************************************************************/
   public void jspDestroy ()
   {
      try
      {
         stmtGetPwd.close();
         stmtUpdatePwd.close();
         conn.close();
      }
      catch(Exception e) {e.printStackTrace();}
   }
%>
<%
   try
   {
      String userID = (String)session.getAttribute( "USERID" );
      String oldPwd = request.getParameter( "oldPwd" );
      String newPwd = request.getParameter( "newPwd" );
      String newPwdConfirm = request.getParameter( "newPwdConfirm" );
      String dbPwd = null;
      ResultSet rsGetPwd = null;
      ResultSet rsUpdatePwd = null;

      synchronized( stmtGetPwd )
      {
         stmtGetPwd.setString(1, userID);
         stmtUpdatePwd.setString(1, newPwd);
         stmtUpdatePwd.setString(2, userID);
         rsGetPwd = stmtGetPwd.executeQuery();
      }

      // Checks if 'rsGetPwd' is empty, if not it assigns the value returned
      // to 'dbPwd', which represents the password already contained in the
      // data base.
      if ( rsGetPwd.next())
      {
         dbPwd = rsGetPwd.getString("Password");
      }

      // Checks if the password in the database equals the password entered
      // in the "Old Password" feild by the user.  If not, an error message
      // is outputted with a link to take the user back to the change
      // password page.  If they are equal, 'stmtUpdatePwd' is executed and
      // a message is outputted to informt he user that the change was
      // successfull.
      if ( !(dbPwd.equals(oldPwd )) )
      {
          %>
         <font face="tahoma" size="2"><b>
            Incorrect Password.
         </b> Please click
         <a href="javascript:history.go(-1);">here</a> to try again.
         </font> 
         <%
      }
      else
      { 
         stmtUpdatePwd.executeUpdate();
         %>
         <font face="tahoma" size="2"><b>
            Password successfully changed.
         </b></font>
         <%
      }
   }
   catch(Exception e) {e.printStackTrace();}

%>

</body>
</html>
