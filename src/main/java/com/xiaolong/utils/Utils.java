package com.xiaolong.utils;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Utils {

	private static final Logger logger = LoggerFactory.getLogger(Utils.class);

	public static String extract(String zipFileName, String extractedFile, String pathOfExtract) {
		logger.debug("zip file: " + zipFileName);
		logger.debug("file to extract: " + extractedFile);

		String nameOfExtractedFile = "";

		try {
			ZipInputStream in = new ZipInputStream(new FileInputStream(zipFileName));

			nameOfExtractedFile = extractedFile.substring(extractedFile.lastIndexOf("/") + 1);
			String pathAndName = pathOfExtract + "/" + nameOfExtractedFile;

			OutputStream out = new FileOutputStream(pathAndName);

			ZipEntry entry;
			byte[] buf = new byte[1024];
			int len;
			int flag = 0;

			while (flag != 1) {
				entry = in.getNextEntry();

				if ((entry.getName()).equalsIgnoreCase(extractedFile)) {
					flag = 1;
				}
			}

			while ((len = in.read(buf)) > 0) {

				out.write(buf, 0, len);
			}

			out.close();
			in.close();
		} catch (IOException e) {
		}
		return nameOfExtractedFile;
	}

}
