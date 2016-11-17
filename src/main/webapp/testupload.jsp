<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<form action="addCourse" enctype="multipart/form-data" method="post">
	courseID		<input type="text" name="courseID" value="course-1" />
	zipFile:		<input type="text" name="coursename" value="maritime"/><br>
	zipFile:		<input type="file" name="coursezipfile" /><br>
	controltype:	<input type="text" name="controltype" value="flow"/><br>
	<input type="submit" value="提交"/>
</form>
</body>
</html>