package com.xiaolong.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.servlet.http.HttpSession;

import org.adl.samplerte.server.LMSManifestHandler;
import org.adl.samplerte.server.LMSPackageHandler;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.InputSource;

@Controller
@RequestMapping("")
public class CourseController {

	/**
	 * 
	 * @param coursename
	 * @param coursezipfile
	 * @param controltype=>>flow,
	 *            choice, auto(?)
	 * @throws IOException
	 */
	@RequestMapping("/addCourse")
	public void addCourse(String coursename, @RequestParam(value = "coursezipfile") MultipartFile coursezipfile,
			String controltype, HttpSession session) throws IOException {

		// 课件上传路径
		String baseDir = session.getServletContext().getRealPath("/");
		String uploadDir = baseDir + "/temp/" + session.getId();
		File dir = new File(uploadDir);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		String zipFile = uploadDir + "/" + coursezipfile.getOriginalFilename();
		System.out.println(">> zipFile: " + zipFile);
		FileUtils.writeByteArrayToFile(new File(zipFile), coursezipfile.getBytes());

		LMSPackageHandler.extract(zipFile, "imsmanifest.xml", uploadDir);

		String manifestFile = uploadDir + "/" + "imsmanifest.xml";

		InputSource fileToParse = null;
		try {
			fileToParse = new InputSource(new FileInputStream(new File(manifestFile)));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		LMSManifestHandler myManifestHandler = new LMSManifestHandler();
		myManifestHandler.setCourseName(coursename);
		myManifestHandler.setFileToParse(fileToParse);
		myManifestHandler.setControl(controltype);

		boolean result = myManifestHandler.processManifest();

		// TODO
		String courseID = myManifestHandler.getCourseID();

		ZipFile archive = new ZipFile(zipFile);

		byte[] buffer = new byte[16384];

		for (Enumeration e = archive.entries(); e.hasMoreElements();) {
			ZipEntry entry = (ZipEntry) e.nextElement();

			if (!entry.isDirectory()) {
				// Set up the name and location of where the file will be
				// extracted to
				String filename = entry.getName();
				filename = filename.replace('/', java.io.File.separatorChar);
				filename = session.getServletContext().getRealPath("/") + "/adl/CourseImports/" + courseID + "/"
						+ filename;
				java.io.File destFile = new java.io.File(filename);

				String parent = destFile.getParent();
				if (parent != null) {
					java.io.File parentFile = new java.io.File(parent);
					if (!parentFile.exists()) {
						// create the chain of subdirs to the file
						parentFile.mkdirs();
					}
				}

				// get a stream of the archive entry's bytes
				InputStream in = archive.getInputStream(entry);

				// open a stream to the destination file
				OutputStream outStream = new FileOutputStream(filename);

				// repeat reading into buffer and writing buffer to file,
				// until done. count will always be # bytes read, until
				// EOF when it is -1.
				int count;
				while ((count = in.read(buffer)) != -1)
					outStream.write(buffer, 0, count);

				in.close();
				outStream.close();
			}
		}
		// Write the Sequencing Object to a file
		String sequencingFileName = session.getServletContext().getRealPath("/") + "/adl/CourseImports/" + courseID
				+ "/sequence.obj";
		ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(new java.io.File(sequencingFileName)));
		oos.writeObject(myManifestHandler.getOrgsCopy());
		oos.flush();
		oos.close();
		
		 FileUtils.deleteQuietly(new File(zipFile));
		 FileUtils.deleteQuietly(new File(manifestFile));
	}
}
