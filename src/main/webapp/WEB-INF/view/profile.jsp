<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="codeu.model.data.User"%>
<%@ page import="codeu.model.store.basic.UserStore"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
	<nav>
		<a id="navTitle" href="/">CodeU Chat App</a> <a href="/conversations">Conversations</a>
		<% if(request.getSession().getAttribute("user") != null){ %>
			<a>Hello <%= request.getSession().getAttribute("user") %>!</a>
		<% } else{ %>
			<a href="/login">Login</a>
		<% } %>
		<a href="/about.jsp">About</a>
	</nav>

	<%    
    String requestedProfile = (String) request.getAttribute("requestedProfile");
    User user = UserStore.getInstance().getUser(requestedProfile);
  	boolean canEdit = (boolean) request.getAttribute("canEdit");
 	%>
 	
	<%if(!canEdit) {%>
		<img src=<%=user.getProfileImage().getURL()%> height = "150" width = "150">
		<h1><%=user.getName()%>'s Page</h1>
		<hr/>
		<h2> About <%=user.getName()%></h2>
		<%if(!user.getDescription().trim().equals("")) {%>
			<p><%= user.getDescription() %></p>
		<%} else {%>
			<p>no description</p>
		<%}%>
	
		<br>
		<br>
	
		<h2><%=user.getName()%>'s Birthday
		</h2>
		<%if(user.getBirthday() != null) {%>
			<p><%=user.getBirthday()%></p>
		<%} else {%>
			<p>Birthday not set</p>
		<%}%>
	<%} else {%>
		<img src=<%=user.getProfileImage().getURL()%> height = "150" width = "200">
		<h1>Your profile</h1>
		<%BlobstoreService blobstoreService = (BlobstoreService) request.getAttribute("blobstoreService");%>
		<form action=<%=blobstoreService.createUploadUrl("/upload")%> method="POST" enctype="multipart/form-data">
			<input type="file" name="profileImage">
			<input type="submit" value="Upload Image">
		</form>
		
		<hr/>
		
		<form action="/user/<%=requestedProfile%>" method="POST">
			<h2>Edit About Me</h2>
			
			<p>About Me:</p>
			<input name="updated description" type="text"
				value="<%=user.getDescription()%>" width="300" height="200">
	
			<br> 
			<br>
	
			<h2>Edit Birthday</h2>
			<%if(user.getBirthday() == null) {%>
				<p>Birthday not set</p>
			<%} else {%>
				<p>Birthday:<%=user.getBirthdayAsString()%></p>
			<%}%>
	
			<input name="updated birthday" type="date"> 
			
			<br> 
			<br>
	
			<h3>Sex: </h3> 
			<select name="updated sex">
				<option value="MALE">Male</option>
				<option value="FEMALE">Female</option>
			</select>
			
			<br>
			<br>
				
			<h2>Work Status:</h2>
			<select name="updated work status" id="workStatus" onchange="updateFields()">
				<option value="employed">Employed</option>
				<option value="unemployed">Unemployed</option>
				<option value="student">Student</option>
			</select>
	        
	        <div id="schoolField">
	        	<h3>High School/University</h3>
	        	<input name="updated school name" type="text" name="school">
			</div>
	        
	        <div id="schoolYearField">
	        	<h3>Year</h3>
	        	<select name="updated school year">
	            	<option value=1>Freshman</option>
	                <option value=2>Sophmore</option>
	        		<option value=3>Junior</option>
	                <option value=4>Senior</option>
	             </select>
	        </div>
	        
	        <div id="employerField">
	        	<h3>Employer</h3>
	        	<input name="updated employer" type="text" name="employer">
			</div>
	           
	        <div id="positionField">
	        	<h3>Position</h3>
	        	<input name="updated position" type="text" name="position">
			</div>
	       
			<script>
	        	function updateFields(){
	              var workStatus = document.getElementById("workStatus");
	              var schoolField = document.getElementById("schoolField");
	              var schoolYearField = document.getElementById("schoolYearField");
	              var employerField = document.getElementById("employerField");
	              var positionField = document.getElementById("positionField");
	
	              if(workStatus.value == "employed"){
	              	  schoolField.style.display = "none";
	                  schoolYearField.style.display = "none";
	                  employerField.style.display = "block";
	                  positionField.style.display = "block";
	                  
	              }
	              if(workStatus.value == "student"){
	                  schoolField.style.display = "block";
	                  schoolYearField.style.display = "block";
	                  employerField.style.display = "none";
	                  positionField.style.display = "none";
	              }
	              if(workStatus.value == "unemployed"){
	                  schoolField.style.display = "none";
	                  schoolYearField.style.Display = "none";
	                  employerField.style.display = "none";
	                  positionField.style.display = "none";
	              }
	            }
	            updateFields();
	     	</script>
			
			<br>
			<br>
			
			<input type="submit" value="Update">
		</form>
	<%}%>
</body>
</html> 
    
