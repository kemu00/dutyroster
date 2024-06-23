package com.kemu.dutyroster.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.kemu.dutyroster.dmain.model.entity.Users;
import com.kemu.dutyroster.dmain.service.UserService;

@Controller
public class UserWindowController {
	
	@Autowired
    private UserService userService;
	
	@RequestMapping("/userList")
	public ModelAndView userList(@ModelAttribute Users user, ModelAndView m) {
		List<Users> users = userService.getAllUsers();
		m.addObject("users", users);
		m.setViewName("userList.html");
		return m;
	}
}