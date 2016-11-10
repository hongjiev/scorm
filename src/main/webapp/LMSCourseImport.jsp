<%@page import = "java.sql.*,java.io.*,org.adl.samplerte.server.*,org.adl.parsers.dom.*, com.jspsmart.upload.*,java.util.*,java.util.zip.*,org.xml.sax.InputSource"%>
<%@ include file="importUtil.jsp" %>
<jsp:useBean id="myUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
/*******************************************************************************
**
** Filename:  LMSCourseImport.jsp
**
** File Description: This file is responsible for handling the full import
**                   process of the Sample RTE.  Files are moved to the server
**                   unpacked, the manifest is parsed, and relevant information
**                   is saved in the RTE database.
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

String sessionID = new String();
String uploadDir = new String();
String userDir = new String();
String error = new String();
LMSManifestHandler myManifestHandler;
LMSPackageHandler myPackageHandler;

try
{
   sessionID = session.getId();
   
   String theWebPath = getServletConfig().getServletContext().getRealPath( "/" );
   
   myUpload.initialize(pageContext);
   myUpload.upload();
   
   uploadDir = "\\SampleRTEFiles\\tempUploads\\" + sessionID;
   java.io.File theRTEUploadDir = new java.io.File( uploadDir );
   
   //  The course directory should not exist yet
   if ( !theRTEUploadDir.isDirectory() )
   {
      theRTEUploadDir.mkdirs();
   }
      
   // Save the file in the virtual path of the web server
   int count2 = myUpload.save( uploadDir, myUpload.SAVE_PHYSICAL);
   
   String courseTitle = myUpload.getRequest().getParameter( "coursename" );
   String zipFile = myUpload.getRequest().getParameter( "theZipFile" );

   String controlType = myUpload.getRequest().getParameter( "controltype" );
   
   // Extract the manfest from the package
   myPackageHandler = new LMSPackageHandler();
   myPackageHandler.extract(zipFile, "imsmanifest.xml", uploadDir); 

   String manifestFile = uploadDir + "\\" + "imsmanifest.xml";
   String newZip = zipFile.substring( zipFile.lastIndexOf("\\")+1);
   zipFile = uploadDir + "\\" + newZip;
   
   // Create a manifest handler instance
   myManifestHandler = new LMSManifestHandler();
   
   InputSource fileToParse = setUpInputSource( manifestFile );
   myManifestHandler.setCourseName( courseTitle );
   myManifestHandler.setFileToParse( fileToParse );
   myManifestHandler.setControl( controlType );


   // Parse the manifest and fill up the object structure
   boolean result = myManifestHandler.processManifest();
   
   // Get the course ID
   String courseID = myManifestHandler.getCourseID();
   
   ZipFile archive = new ZipFile( zipFile );
   
   // do our own buffering; reuse the same buffer.
   byte[] buffer = new byte[16384];
   
   // Loop through each Zip file entry
   for ( Enumeration e=archive.entries(); e.hasMoreElements(); )
   {
      // get the next entry in the archive
      ZipEntry entry = (ZipEntry) e.nextElement();
      
      if ( !entry.isDirectory() )
      {
         // Set up the name and location of where the file will be 
         // extracted to
         String filename = entry.getName();
         filename = filename.replace('/',java.io.File.separatorChar);
         filename = theWebPath + "CourseImports\\" + courseID + "\\" + filename;
         java.io.File destFile = new java.io.File(filename);
         
         String parent = destFile.getParent();
         if ( parent != null )
         {
            java.io.File parentFile = new java.io.File(parent);
            if ( !parentFile.exists() )
            {
               // create the chain of subdirs to the file
               parentFile.mkdirs();
            }
         }
         
         // get a stream of the archive entry's bytes
         InputStream in = archive.getInputStream(entry);
         
         // open a stream to the destination file
         OutputStream outStream = new FileOutputStream(filename);
         
         // repeat reading into buffer and writing buffer to file,
         // until done.  count will always be # bytes read, until
         // EOF when it is -1.
         int count;
         while ( (count=in.read(buffer)) != -1 )
            outStream.write(buffer, 0, count);

         in.close();
         outStream.close();
      }
   }
      
   //  Write the Sequencing Object to a file
   String sequencingFileName = theWebPath + "CourseImports\\" + courseID + "\\sequence.obj";
   java.io.File sequencingFile = new java.io.File(sequencingFileName);
   FileOutputStream ostream = new FileOutputStream(sequencingFile);
   ObjectOutputStream oos = new ObjectOutputStream(ostream); 
   oos.writeObject(myManifestHandler.getOrgsCopy());
   oos.flush();
   oos.close();

   // Delete uploaded files
   boolean wasdeleted = false;
   java.io.File uploadFiles[] = theRTEUploadDir.listFiles();
   for( int i = 0; i < uploadFiles.length; i++ )
   {
      uploadFiles[i].deleteOnExit();
   }   theRTEUploadDir.deleteOnExit();  

   // set content-type header before accessing Writer
   response.setContentType("text/html");
   response.sendRedirect( "confirmImport.jsp" );

}
catch (Exception e)
{
   error = e.toString();
}

%>

Error!: <%=error%>

