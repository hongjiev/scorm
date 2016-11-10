package com.xiaolong.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("")
public class UserController {

	@RequestMapping("/login")
	public void addCourse(String username, String password, HttpSession session) {
		session.setAttribute("username", username);
		session.setAttribute("USERID", username);
		session.setAttribute("RTEADMIN", "admin".equals(username));
	}
}
