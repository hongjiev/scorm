<%@page import = "java.sql.*, java.util.*" %>

<%
/*******************************************************************************
**
** Filename:  processDeleteUser.jsp
**
** File Description:   This file implements the deletion of a user account.
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
   <title>ADL Sample RTE Version 1.2.2 Process Delete User</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF">

<jsp:include page="gotoMenu.jsp" flush="true" />
<%!
   Connection conn;
   PreparedStatement stmtUpdateUser;

   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: 'conn' is given the value of the database connection and
   *         'stmtUpdateUser' is given the value of 'sqlUpdateUser'
   *         converted to a prepared statement.
   *
   * Description: This function sets the driverName and connectionURL
   *              variables and establishes the database connection.  The
   *              SQL string is also created, converted to a prepared
   *              statement, and then assigned to 'stmtUpdateUser'.
   *********************************************************************/
   public void jspInit()
   {
      try
      {
        String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
        String connectionURL = "jdbc:odbc:SampleRTE";
//         Class.forName(driverName).newInstance();
//         conn = DriverManager.getConnection(connectionURL);
        Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(
				"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
				"allwin", "3edc$RFV5tgb");
        String sqlUpdateUser
         = "UPDATE UserInfo set Active = no where UserID = ?";

        stmtUpdateUser = conn.prepareStatement( sqlUpdateUser );
      }
      catch(SQLException e) {System.out.println("SQL EXCEPTION" + e);}
      catch(ClassNotFoundException e) {System.out.println("CLASS EXCEPTION" + e);}
      catch(Exception e) {System.out.println("GENERAL EXCEPTION" + e);}
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
         stmtUpdateUser.close();
         conn.close();
      }
      catch(SQLException e) {System.out.println("SQL EXCEPTION DESTROY" + e);}
   }
%>

<%
   String strUsers = "";
   String[] arrUsers;
   strUsers = request.getParameter("chkUser");
     
   int loopCount = 0;
   int userCount = 0;
   String userID;

   // If 'strUsers' is not null, 'arrUsers' is assigned the value of all of the
   // checkboxes checked on the previous page.  The users are then made
   // in the 'synchronized()' function.
   if(strUsers != null)
   {
      arrUsers = request.getParameterValues("chkUser");
      userCount = arrUsers.length;

      synchronized( stmtUpdateUser )
      {
         for(loopCount = 0; loopCount < userCount; loopCount++)
         {
            userID = arrUsers[loopCount];
            stmtUpdateUser.setString( 1, userID);
            stmtUpdateUser.executeUpdate();
         }
      }
      %>
      <b>Delete Successful.</b>
      <%
   }
   else
   {
      %>
         <b>Please check one of the users for deletion</b><br>
         <a href="javascript:history.go(-1);">Back To Delete User</a>
      <%
   }
%>

</body>
</html>
