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
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;

import codeu.model.data.User.Sex;
import codeu.model.data.User;
import codeu.model.store.basic.UserStore;

public class ProfileServlet extends HttpServlet {
	private UserStore userStore;
	
	BlobstoreService blobstoreService;
	ImagesService imagesService;
	
	@Override
	public void init() throws ServletException {
		super.init();
		userStore = UserStore.getInstance();
		
		//Some necessities for grabbing images
		blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
		imagesService = ImagesServiceFactory.getImagesService();
	}

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
		String profileEditName = getNameFromURL(request.getRequestURL());
		
		User user = userStore.getUser(profileEditName);
		UserStore userStore = UserStore.getInstance();

		//Sets the birthday from the user's form if he filled it out
		String newBirthday = request.getParameter("updated birthday");
		if(newBirthday != null) {
			user.setBirthday(parseDate(newBirthday));
		}
		
		//Sets the description from the user's form if it's been filled out
		String newDescription = request.getParameter("updated description");
		//Using short circuit boolean to avoid NullPointerException
		if(newDescription != null && !newDescription.trim().equals("")) {
			user.setDescription(newDescription);
		}
		
		//Sets the sex from the user's form if it's been changed
		String newSex = request.getParameter("updated sex");
		if(newSex != null && !newSex.equals("default")) {
			user.setSex(Sex.valueOf(newSex));
		}
		
		//Sets the email from the user's form if it's been filled out
		String newEmail = request.getParameter("updated email");
		if(newEmail != null && !newEmail.trim().equals("")) {
			user.setEmail(newEmail);
		}

		//Sets occupation based on what the workstatus is for the user
		String workStatus = request.getParameter("updated work status");
		if(workStatus != null  && !workStatus.equals("default")) {
			if(!workStatus.equals("unemployed")) {
				String f1 = request.getParameter("updated f1");
				String f2 = request.getParameter("updated f2");
				if(f1 != null && f2 != null &
						!f1.trim().equals("") && !f2.trim().equals("")) {
					System.out.println("set occ");
					user.setOccupation(user.new Occupation(f1,f2));
				} else {
					//Make them redo the form
				}
			} else  {
				user.setOccupation(user.new Occupation());
			}
		}
		
		userStore.updateUser(user);
		
		doGet(request,response);
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//Gets the user name from the URL
		String profileRequestName = getNameFromURL(request.getRequestURL());
		
		//Checks to make sure the page requested is a valid username
		if (!userStore.isUserRegistered(profileRequestName)) {
			response.sendRedirect("../404.html");
			return;
		}
		
		//forwards the blob-stuff to the jsp
		request.setAttribute("blobstoreService", blobstoreService);
		//forwards the profile name to the jsp
		request.setAttribute("requestedProfile", profileRequestName);
	  	
		//Checks to see if the user that's logged in is the same user whose page is being requested and forwards
		//that information to the jsp
		if(request.getSession().getAttribute("user") != null) {
		  	String loggedInUserName = (String) request.getSession().getAttribute("user");
		  	request.setAttribute("canEdit", loggedInUserName.equals(profileRequestName));
		} else {
		  	request.setAttribute("canEdit", false);
		}
		
		request.getRequestDispatcher("/WEB-INF/view/profile.jsp").forward(request, response);
	}
	
	//A method I'm using to parse dates from String to Date
	private Date parseDate(String in) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date out;
		
		try {
			out = sdf.parse(in);
		} catch (Exception e) {
			out = null;
		}
		
		return out;
	}
	
	
	//A method I'm using to get the name given either a relative or absolute URL
	private String getNameFromURL(StringBuffer URL) {
		String URL_String = URL.toString();
		int usernameStartIndex = URL_String.indexOf("/user/");
		usernameStartIndex += "/user/".length();
		return URL_String.substring(usernameStartIndex);
	}
}
