<!--
/*******************************************************************************
**
** Filename:  processAddComp.jsp
**
** File Description: This page performs the SQL operations, inserting the 
**                   competency record information to the database. 
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


<%@page import = "java.sql.*, java.util.*, java.io.*" %>
<html>
<head>
    <title>ADL Sample RTE v 1.2.2 Process Add Competency</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <script language="JavaScript">
    <!--
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
     // -->
    </script>
</head>
   
<BODY BGCOLOR="#FFFFFF">
  
<jsp:include page="gotoMenu.jsp" flush="true" />
<%!

   Connection conn;
   PreparedStatement stmtInsertComp;

   /*********************************************************************
   * Method: jspInit()
   * Input: none
   * Output: conn and stmtInsertComp are given new values
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
         String sqlInsertComp = "INSERT INTO Competency (CompID, PassFail) VALUES('?', '?')";
         stmtInsertComp = conn.prepareStatement( sqlInsertComp );
      }
      catch (SQLException e) {}
      catch (ClassNotFoundException e) {}
      catch (Exception e) {}
   )

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
         stmtInsertComp.close();
         conn.close();
      }
      catch (Exception e) {e.printStackTrace();}
    }
%>

<%
   // The values of compID and passFail are inserted into stmtDeleteComp
   // and the statement is executed, inserting the competency record to
   // the database.
   try
   {
      String compID = (String)request.getParameter( "txtCompID" );
      String passFail = (String)request.getParameter( "selPassFail" );

      /*********************************************************************
      * Method: synchronized()
      * Input: stmtInsertComp
      * Output: stmtInsertComp
      *
      * Description: Inserts the values of the variables 'compID' and
      *              'passFail' into the prepared statement 'stmtDeleteComp'.
      *********************************************************************/
      synchronized( stmtInsertComp )
      {
         stmtInsertComp.setString(1, compID);
         stmtInsertComp.setString(2, passFail);
      }
      stmtInsertComp.executeUpdate();

   }
   catch (Exception e) {e.printStackTrace();}
%>

</BODY>
</HTML>
