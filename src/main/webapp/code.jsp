<%@page import = "java.sql.*, java.util.*" %>

<%
/*******************************************************************************
**
** Filename:  code.jsp
**
** File Description:   This file implements a menu built from the SCOs in 
** the current course.  It includes code from mtmcode.js which contains 
** the copyright information for this menu implemention.  
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
** Module/Package Name: Sample RTE
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
/* This menu uses  
** Morten's JavaScript Tree Menu
** version 2.3.0, dated 2001-04-30
** http://www.treemenu.com/

** Copyright (c) 2001, Morten Wang & contributors
** All rights reserved.
***************************************************************************/
%>

<html>
<head>
<title>Menu</title>

<script type="text/javascript" src="mtmcode.js">
</script>

<script type="text/javascript">

 
/******************************************************************************
* User-configurable options.                                                  *
******************************************************************************/

// Menu table width, either a pixel-value (number) or a percentage value.
var MTMTableWidth = "100%";

// Name of the frame where the menu is to appear.
var MTMenuFrame = "menu";

// variable for determining whether a sub-menu always gets a plus-sign
// regardless of whether it holds another sub-menu or not
var MTMSubsGetPlus = "Never";

// variable that defines whether the menu emulates the behaviour of
// Windows Explorer
var MTMEmulateWE = true;

// Directory of menu images/icons
var MTMenuImageDirectory = "menu-images/";

// Variables for controlling colors in the menu document.
// Regular BODY atttributes as in HTML documents.
var MTMBGColor = "white";
var MTMBackground = "";
var MTMTextColor = "black";

// color for all menu items
var MTMLinkColor = "black";

// Hover color, when the mouse is over a menu link
var MTMAhoverColor = "red";

// Foreground color for the tracking & clicked submenu item
var MTMTrackColor ="yellow";
var MTMSubExpandColor = "black";
var MTMSubClosedColor = "black";

// All options regarding the root text and it's icon
//var MTMRootIcon = "menu_new_root.gif";
var MTMRootIcon = "adl_tm_24x16.jpg";
var MTMenuText = "";
var MTMRootColor = "black";
var MTMRootFont = "Arial, Helvetica, sans-serif";
var MTMRootCSSize = "84%";
var MTMRootFontSize = "-1";

// Font for menu items.
var MTMenuFont = "Arial, Helvetica, sans-serif";
var MTMenuCSSize = "84%";
var MTMenuFontSize = "-1";

// Variables for style sheet usage
// 'true' means use a linked style sheet.
var MTMLinkedSS = false;
var MTMSSHREF = "style/menu.css";

// Additional style sheet properties if you're not using a linked style sheet.
// See the documentation for details on IDs, classes & elements used in the menu.
// Empty string if not used.
var MTMExtraCSS = "";

// Header & footer, these are plain HTML.
// Leave them to be "" if you're not using them

var MTMHeader = "";
var MTMFooter = "";

// Whether you want an open sub-menu to close automagically
// when another sub-menu is opened.  'true' means auto-close
var MTMSubsAutoClose = false;

// This variable controls how long it will take for the menu
// to appear if the tracking code in the content frame has
// failed to display the menu. Number if in tenths of a second
// (1/10) so 10 means "wait 1 second".
var MTMTimeOut = 10;

// Cookie usage.  First is use cookie (yes/no, true/false).
// Second is cookie name to use.
// Third is how many days we want the cookie to be stored.
var MTMUseCookies = false;
var MTMCookieName = "MTMCookie";
var MTMCookieDays = 3;

// Tool tips.  A true/false-value defining whether the support
// for tool tips should exist or not.
var MTMUseToolTips = true;

/******************************************************************************
* User-configurable list of icons.                                            *
******************************************************************************/

var MTMIconList = null;
MTMIconList = new IconList();
MTMIconList.addIcon(new MTMIcon("menu_link_external.gif", "http://", "pre"));
MTMIconList.addIcon(new MTMIcon("menu_link_pdf.gif", ".pdf", "post"));

var menu = new MTMenu();

<%
 //  Get the information needed to build the menu
 Vector title_vector = new Vector();
 Vector id_vector = new Vector();
 Vector level_vector = new Vector();
 Vector parent_vector = new Vector();
 Vector item_number_vector = new Vector();
 String userID = "";
 String courseID = "";
 String control = "";

 int length;
 int current_int_level;
 int current_index;
 int z;
 String previous_level = new String();
 int parent_index;
 String course_title = new String();
 String menu_name = new String();
 int new_level;
 
try
{
   // Get the course and item info from the database
   Connection conn; 
   PreparedStatement stmtSelectUserSCO;
   PreparedStatement stmtSelectCourse;
   String sqlSelectUserSCO
    = "SELECT * FROM ItemInfo WHERE CourseID = ? ORDER BY Sequence";
           
   String sqlSelectCourse
    = "SELECT * FROM CourseInfo WHERE CourseID = ?";
                     
   String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
   String connectionURL = "jdbc:odbc:SampleRTE";

//    Class.forName(driverName).newInstance();
//    conn = DriverManager.getConnection(connectionURL);
   Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection(
			"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
			"allwin", "3edc$RFV5tgb");
   stmtSelectUserSCO= conn.prepareStatement( sqlSelectUserSCO );
   stmtSelectCourse= conn.prepareStatement( sqlSelectCourse );
   
   userID = (String)session.getAttribute( "USERID" );
   
   courseID = (String)session.getAttribute( "COURSEID" );
    
   control = (String)session.getAttribute( "control" );
    
   if (courseID != "") 
   {//  Execute the course info database query
      ResultSet courseInfo = null;
      synchronized( stmtSelectCourse )
      {
         stmtSelectCourse.setString( 1, courseID );
         courseInfo = stmtSelectCourse.executeQuery();
      }
   
    // Move into the first record in the record set
      while ( courseInfo.next() )
      {
      //  Get the CONTROL column
         control = courseInfo.getString("Control");
      //get course name
         course_title = courseInfo.getString("CourseTitle");
      }
      }
      userID = (String)session.getAttribute( "USERID" );
  
      ResultSet itemInfo = null;
      if ((courseID != "")  && ((control != null) && ((control.equals( "mixed")) || (control.equals( "choice")))))
      {
         synchronized( stmtSelectUserSCO )
         {
            stmtSelectUserSCO.setString( 1, courseID );
            itemInfo = stmtSelectUserSCO.executeQuery();
         }  
         int i = 0;
         while(itemInfo.next())
         {
            // add the info to the vectors
            title_vector.addElement(itemInfo.getString("Title"));
            id_vector.addElement(itemInfo.getString("Identifier"));
            level_vector.addElement(itemInfo.getString("TheLevel"));
         } //end while
      }  // end if
    
} // end try
  catch(Exception e)
{
   e.printStackTrace();   
}
  %>  
    
    
<% // begin menu construction
   if ((courseID != "")  && (courseID != null) && ((control != null) && ((control.equals( "mixed")) || (control.equals( "choice")))))
   {  
      int i = 0;
    %>var MTMenuText = "<%=course_title%>";
      <% String previous_parent = "menu";
      previous_level = level_vector.elementAt(i).toString();%>
      // first item is menu root
      menu.MTMAddItem(new MTMenuItem("<%=title_vector.elementAt(i).toString()%>", "javascript:launchItem('<%=id_vector.elementAt(i).toString()%>')", "code"));
      <% parent_index = 0;
      parent_vector.addElement("menu");
      length = title_vector.size();
      item_number_vector.addElement("0");
      current_index = 0; 
      i++;
      while ( i < length )
      {   // if nesting level of current item is same as that of previous item
            if (level_vector.elementAt(i).toString().equals(previous_level))
            { %>
                <%=parent_vector.elementAt(parent_index).toString()%>.MTMAddItem(new MTMenuItem("<%=title_vector.elementAt(i).toString()%>", "javascript:launchItem('<%=id_vector.elementAt(i).toString()%>')", "code"));
               <% //increment item_number_vector at current_index so know which item are at
               Integer inc = new Integer(item_number_vector.elementAt(current_index).toString());
               new_level = inc.intValue();
               new_level++;
               item_number_vector.setElementAt(inc.toString(new_level), current_index);
               i++;
            }// end if
            //if level is greater, get new menu name, add name to 
            //parent_vector and use as current menu name
            else if ( (previous_level.compareTo(level_vector.elementAt(i).toString()))<0)
            {  
               menu_name = "sub"+parent_index;
               Integer tempInt = new Integer(item_number_vector.elementAt(current_index).toString()); 
               int item_number = tempInt.intValue();
               %>var <%=menu_name%> = new MTMenu();
               <%= parent_vector.elementAt(parent_index).toString()%>.items[<%=item_number%>].MTMakeSubmenu(<%=menu_name%>);
               <% parent_vector.addElement(menu_name);
               parent_index++;
               item_number_vector.addElement("0");
               current_index++;%>                 
               <%=menu_name%>.MTMAddItem(new MTMenuItem("<%=title_vector.elementAt(i).toString()%>", "javascript:launchItem('<%=id_vector.elementAt(i).toString()%>')", "code")); 
               <%
               previous_level = level_vector.elementAt(i++).toString();
            } //end else if
            else
              //if level is less
            { 
               Integer int1 = new Integer(previous_level);
               Integer int2 = new Integer(level_vector.elementAt(i).toString());
               current_int_level = int1.intValue() - int2.intValue(); 
               for (z = 0; z<current_int_level; z++)
               {  
                  parent_vector.removeElementAt(parent_index--);
                  item_number_vector.removeElementAt(current_index--);
               }// end for %>
                                  <%=parent_vector.elementAt(parent_index).toString()%>.MTMAddItem(new MTMenuItem("<%=title_vector.elementAt(i).toString()%>", "javascript:launchItem('<%=id_vector.elementAt(i).toString()%>')", "code")); 
               <% //increment item_number_vector at current_index so know which item are at
               Integer inc = new Integer(item_number_vector.elementAt(current_index).toString());
               new_level = inc.intValue();
               new_level++;
               item_number_vector.setElementAt(inc.toString(new_level), current_index);
               previous_level = level_vector.elementAt(i++).toString();
            }// end else
    } //end while
 } // end menu creation%>
 
      </script>
</head> 

<body onload="MTMStartMenu()" bgcolor="#FFFFFF" text="#black" link="yellow" vlink="lime" alink="red"  >
</body>

</html>
