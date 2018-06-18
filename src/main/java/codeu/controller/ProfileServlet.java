// Copyright 2017 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package codeu.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import codeu.model.data.User;
import codeu.model.data.User.Occupation;
import codeu.model.store.basic.UserStore;

public class ProfileServlet extends HttpServlet {
	private UserStore userStore;
	@Override
	public void init() throws ServletException {
		super.init();
		userStore = UserStore.getInstance();
	}

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
		String profileEditName = getNameFromURL(request.getRequestURL());
		
		User user = userStore.getUser(profileEditName);
		
		Date newBirthday = parseDate(request.getParameter("updated birthday"));
		
		if(newBirthday != null) {
			user.setBirthday(newBirthday);
		}
		
		String newDescription = request.getParameter("updated description");
		
		if(newDescription != null && newDescription.trim() != "") {
			user.setDescription(newDescription);
		}
		
		String workStatus = request.getParameter("updated work status");
		
		Occupation occupation = null;
		if(workStatus.equals("employed")) {
			String employer = request.getParameter("updated employer");
			String position = request.getParameter("updated position");
			occupation = user.new Occupation(employer, position);
		} else if (workStatus.equals("student")){
			String school = request.getParameter("updated school");
			int year = Integer.parseInt(request.getParameter("updated school year"));
			occupation = user.new Occupation(school, year);
		} else if (workStatus.equals("unemployed")) {
			occupation = user.new Occupation();
		} else {
			System.out.println("Unrecongized work status");
		}
		
		user.setOccupation(occupation);
		
		UserStore userStore = UserStore.getInstance();
		userStore.updateUser(user);
		
		doGet(request,response);
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String profileRequestName = getNameFromURL(request.getRequestURL());
		System.out.println(profileRequestName);
		
		if (userStore.isUserRegistered(profileRequestName)) {
			User requestedProfile = userStore.getUser(profileRequestName);
		} else {
			response.sendRedirect("../404.html");
			return;
		}
		/*
		Image displayedImage;
		if(user.getProfileImage() == null) {
			displayedImage = defaultImage;
		} else {
			displayedImage = user.getProfileImage();
		}
		
		request.setAttribute("image", displayedImage);
		*/
		
		request.setAttribute("requestedProfile", profileRequestName);
	  	
		if(request.getSession().getAttribute("user") != null) {
		  	String loggedInUserName = (String) request.getSession().getAttribute("user");
		  	request.setAttribute("canEdit", loggedInUserName.equals(profileRequestName));
		} else {
		  	request.setAttribute("canEdit", false);
		}
		
		request.getRequestDispatcher("/WEB-INF/view/profile.jsp").forward(request, response);

	}
	
	private Date parseDate(String in) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date out;
		
		try {
			out = sdf.parse(in);
		} catch (ParseException e) {
			out = null;
		}
		
		return out;
	}
	
	private String getNameFromURL(StringBuffer URL) {
		String URL_String = URL.toString();
		int usernameStartIndex = URL_String.indexOf("/user/");
		usernameStartIndex += "/user/".length();
		return URL_String.substring(usernameStartIndex);
	}
}
