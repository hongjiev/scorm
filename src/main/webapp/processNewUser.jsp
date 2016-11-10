<%@ page import="java.sql.*, java.util.*, org.adl.util.*, java.io.*" %>

<%
/*******************************************************************************
**
** Filename:  processNewUser.jsp
**
** File Description:   This file processes the creation of a new user account.
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
    <title>ADL Sample RTE Version 1.2.2 Process New User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <script language="JavaScript">
     <!-- 
     function MM_reloadPage(init) { //reloads the window if Nav4 resized
         if (init==true) with (navigator) {
                 if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
                     document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage;
                 }
             } else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
     }
     MM_reloadPage(true);
      //-->
      
    </script>
</head>
<% 
String userID = request.getParameter("userID");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String password = request.getParameter("password");
String cpassword = request.getParameter("cPassword");
String admin = request.getParameter("admin");

if ( admin.equals( "Yes" ) )
{
   admin = "1";
}
else
{
   admin = "0";
}

session.setAttribute( "NEWUSERID", userID );
session.setAttribute( "NEWUSERFN", firstName );
session.setAttribute( "NEWUSERLN", lastName );

String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
String connectionURL = "jdbc:odbc:SampleRTE";

Connection conn = null;
PreparedStatement stmtSelectUserInfo = null;
ResultSet rsSelectUserInfo = null;
ResultSetMetaData rsmd = null;

try {
// Class.forName(driverName).newInstance();
// conn= DriverManager.getConnection(connectionURL);
Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection(
		"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
		"allwin", "3edc$RFV5tgb");
String sqlSelectUserInfo = "SELECT * FROM UserInfo WHERE UserID = '" + userID + "'";

stmtSelectUserInfo = conn.prepareStatement( sqlSelectUserInfo );
rsSelectUserInfo = stmtSelectUserInfo.executeQuery();


rsmd = rsSelectUserInfo.getMetaData();
}
catch (Exception e)
{
   e.printStackTrace(); 
}

if ( rsSelectUserInfo.next() == true )
{
   session.setAttribute( "NEWUSERERROR", "dupid" );
   response.sendRedirect( "newUser.jsp" );
}

else {
try {
PreparedStatement stmtInsertUserInfo;
String sqlInsertUserInfo = "INSERT INTO UserInfo VALUES ('" + userID + "','" + lastName + "','" + firstName + "','" + admin + "','" + password + "'," + "'1'" + ")";
stmtInsertUserInfo = conn.prepareStatement( sqlInsertUserInfo );
stmtInsertUserInfo.executeUpdate();
}
catch (Exception e)
{
   e.printStackTrace(); 
}
session.removeAttribute( "NEWUSERID" );
session.removeAttribute( "NEWUSERFN" );
session.removeAttribute( "NEWUSERLN" );
%>

<body bgcolor="#FFFFFF">
<jsp:include page="gotoMenu.jsp" flush="true" />

<h2>New user has been processed:</h2>
</body>
</html>

<% } %>
