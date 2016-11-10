<!--
/*******************************************************************************
**
** Filename:  competency.jsp
**
** File Description: This page displays all of the competency records currently
**                   in the system, and gives the user the option to Update,
**                   Delete, or Add a record.
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
<HTML>
<HEAD>
   <TITLE>ADL Sample RTE Display Competency Records</TITLE>
   <META HTTP-EQUIV-equiv="Content-Type" CONTENT="text/html; charset=iso-8859-1">
   <SCRIPT LANGUAGE="JavaScript">
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
</HEAD>

<BODY BGCOLOR="#FFFFFF">
   <jsp:include page="gotoMenu.jsp" flush="true" />
   <TABLE WIDTH="458" BORDER="0">
      <%!
         Connection conn;
         PreparedStatement stmtSelectComp;
          
         /*********************************************************************
         * Method: jspInit()
         * Input: none
         * Output: conn and stmtSelectComp are given new values
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
               Class.forName(driverName).newInstance();
               conn = DriverManager.getConnection(connectionURL);

               String sqlSelectComp = "SELECT * FROM Competency";
               stmtSelectComp = conn.prepareStatement( sqlSelectComp );
            }
            catch(SQLException e){}
            catch(ClassNotFoundException e){}
            catch(Exception e){}
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
               stmtSelectComp.close();
               conn.close();
            }
            catch(SQLException e) {}
         }
      %>
       
      <%
         try
         {
            ResultSet compRS;
            String compID = null;
            String passFail = null;

            compRS = stmtSelectComp.executeQuery();

            // Checks to see if the result set (compRS) contains anything
            // and Prints column headers if so.
            if( compRS.next() )
            {
               %>
               <TR>
                  <TD>
                     <B><U>Competency ID</U></B>
                  </TD>
                  <TD>
                     <B><U>Results</U></B>
                  </TD>
                  <TD>
                     <B><U>Update</U></B>
                  </TD>
                  <TD>
                     <B><U>Delete</U></B>
                  </TD>
               </TR>
               <%
            }
            
            // Loops through the result set (compRS) and outputs the
            // information in it's corresponding column.
            while( compRS.next() )
            {
               compID = compRS.getString("CompID");
               passFail = compRS.getString("PassFail");

               %>
               <TR>
                  <TD>
                     <%=compID%>
                  </TD>
                  <TD>
                     <%=passFail%>
                  </TD>
                  <TD>
                     <A HREF="updateComp.jsp?ID=<%=compID%>">Update</a>
                  </TD>
                  <TD>
                     <A HREF="deleteComp.jsp?ID=<%=compID%>">Delete</A>
                  </TD>
               </TR>
               <%
            }
         }
         catch(Exception e){}
      %>
   </TABLE>
   <BR>
   <A HREF="addComp.jsp">Add Competency Record</A>
</BODY>
</HTML>
