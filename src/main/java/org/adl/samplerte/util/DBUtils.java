package org.adl.samplerte.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {
	public static Connection createConn() {

		// spring.datasource.url=jdbc:mysql://106.75.29.149:3306/test?useUnicode=true&characterEncoding=utf8&useSSL=false
		// spring.datasource.username=allwin
		// spring.datasource.password=3edc$RFV5tgb

		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://106.75.29.149:3306/scorm_official?useUnicode=true&characterEncoding=utf8&useSSL=false",
					"allwin", "3edc$RFV5tgb");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}
}
