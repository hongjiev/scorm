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
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.InputSource;

import com.xiaolong.utils.ManifestHandler;
import com.xiaolong.utils.Utils;

@Controller
@RequestMapping("")
public class CourseController {

	private static final Logger logger = LoggerFactory.getLogger(CourseController.class);

	@RequestMapping("/addCourse")
	public void addCourse(String coursename, @RequestParam(value = "coursezipfile") MultipartFile coursezipfile,
			String controltype, HttpSession session) throws IOException {
		logger.info(">> upload course: coursename: {}, controltype: {}", coursename, controltype);

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

		Utils.extract(zipFile, "imsmanifest.xml", uploadDir);

		String manifestFile = uploadDir + "/" + "imsmanifest.xml";

		InputSource fileToParse = null;
		try {
			fileToParse = new InputSource(new FileInputStream(new File(manifestFile)));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		// TODO
//		String courseId = RandomStringUtils.randomAlphabetic(5);
//		logger.info("courseId: {}", courseId);
//
//		ManifestHandler handler = new ManifestHandler();
//		handler.setCourseId(courseId);
//		handler.setCourseName(coursename);
//		handler.setFileToParse(fileToParse);
//		handler.setControl(controltype);

		
		LMSManifestHandler myManifestHandler = new LMSManifestHandler();
		myManifestHandler.setCourseName(coursename);
		myManifestHandler.setFileToParse(fileToParse);
		myManifestHandler.setControl(controltype);
		boolean result = myManifestHandler.processManifest();
		String courseId = myManifestHandler.getCourseID();
		
		logger.info("handle manifest file result: " + result);

		@SuppressWarnings("resource")
		ZipFile archive = new ZipFile(zipFile);

		byte[] buffer = new byte[16384];

		for (Enumeration<?> e = archive.entries(); e.hasMoreElements();) {
			ZipEntry entry = (ZipEntry) e.nextElement();

			if (!entry.isDirectory()) {
				String filename = entry.getName();
				filename = filename.replace('/', java.io.File.separatorChar);
				filename = session.getServletContext().getRealPath("/") + "/adl/CourseImports/" + courseId + "/"
						+ filename;
				java.io.File destFile = new java.io.File(filename);

				String parent = destFile.getParent();
				if (parent != null) {
					java.io.File parentFile = new java.io.File(parent);
					if (!parentFile.exists()) {
						parentFile.mkdirs();
					}
				}

				InputStream in = archive.getInputStream(entry);

				OutputStream outStream = new FileOutputStream(filename);

				int count;
				while ((count = in.read(buffer)) != -1)
					outStream.write(buffer, 0, count);

				in.close();
				outStream.close();
			}
		}
		String sequencingFileName = session.getServletContext().getRealPath("/") + "/adl/CourseImports/" + courseId
				+ "/sequence.obj";
		logger.info("Write the Sequencing Object to file: " + sequencingFileName);

		ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(new java.io.File(sequencingFileName)));
		oos.writeObject(myManifestHandler.getOrgsCopy());
		oos.flush();
		oos.close();

		// logger.info("delete zip file and manifest file.");
		// FileUtils.deleteQuietly(new File(zipFile));
		// FileUtils.deleteQuietly(new File(manifestFile));
	}
}
