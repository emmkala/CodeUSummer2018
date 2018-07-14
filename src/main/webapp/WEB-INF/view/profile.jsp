<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="codeu.model.data.User"%>
<%@ page import="codeu.model.store.basic.UserStore"%>
<%@ page import="java.util.Date"%>
<%@ page import="codeu.model.data.Conversation" %>
<%@ page import="codeu.model.data.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="codeu.model.store.basic.MessageStore" %>
<%@ page import="codeu.model.data.Post" %>

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

		<h2><%=user.getName()%>'s Post's<h2>
		<% List<Post> everyPost = (List<Post>) request.getAttribute("usersPosts"); %>
		<!-- List<Comment> everyComment = (List<Post>) request.getAttribute("postComments"); -->
		<% if(everyPost == null){ %>
					<p> They haven't made any posts. </p>
		<% } else { %>
			<% for(Post post : everyPost){ %>
				<p> <%=post.getContent()%> </p>

				<form action="/comment?post_id=<%= post.getId() %>&user=<%user.getName();%>">
				<input type="text" name="content" placeholder="Comment on This Post!"> <br />
				<button type="submit">Send</button>
			</form>
		<% }
		} %>

	<%} else {%>
		<img src=<%=user.getProfileImage().getURL()%> height = "150" width = "200">
		<h1>Your profile</h1>
		<%BlobstoreService blobstoreService = (BlobstoreService) request.getAttribute("blobstoreService");%>
		<form action=<%=blobstoreService.createUploadUrl("/upload")%> method="POST" enctype="multipart/form-data">
			<input type="file" name="profileImage">
			<input type="submit" value="Upload Image">
		</form>

		<h2> Make a Post! </h2>
		<form action="/user/<%= user.getName() %>"> 
		<input type="text" name="post" placeholder="Post about any topic you want!">
		<button type="submit">Send</button>
		</form>

		<h2> Your Posts </h2>
		<% List<Post> everyPost = (List<Post>) request.getAttribute("usersPosts"); %>
		<!-- List<Comment> everyComment = (List<Post>) request.getAttribute("postComments"); -->
		<% if(everyPost == null){ %>
					<p> You haven't made any posts. </p>
		<% } else { %>
			<% for(Post post : everyPost){ %>
				<p> <%=post.getContent()%> </p>

				<form action="/comment?post_id=<%= post.getId() %>&user=<%user.getName();%>">
				<input type="text" name="content" placeholder="Comment on Your Post!"> <br />
				<button type="submit">Send</button>
			</form>
		<% }
		} %>

		<form action="/user/<%=requestedProfile%>" method="POST">
			<h2>Edit About Me</h2>

			<p>About Me:</p>
			<input name="updated description" type="text"
				value="<%=user.getDescription()%>" width="300" height="200">

			<br>
			<input name="updated description" type="text" value="<%=user.getDescription()%>">
	
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

			<p>Email:</p>
			<input name="updated email" type="text" value="<%=user.getEmail()%>">

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
	              if(workStatus.value == "unemployed" || workStatus.value == "default"){
	                  schoolField.style.display = "none";
	                  schoolYearField.style.Display = "none";
	                  employerField.style.display = "none";
	                  positionField.style.display = "none";
	              }
	            }
	            updateFields();

	        	

				function removeDefault(elem) {
					var options = elem.childNodes;
					for (i = 0; i < options.length; i++) {
						if (options[i].value == "default") {
							options[i].style = "display:none";
							break;
						}
					}
				}
				
				//This doesn't work
				/*
				function setStoredWorkStatus(){
					var workStatus = document.getElementById("workStatus");
					var currentWorkStatus = "<%=user.getOccupation().getOccupationType()%>".toLowerCase();
					for(i = 0; i < workStatus.childNodes; i++){
						if(workStatus.childNodes[i] == currentWorkStatus){
							workStatus.childNodes[i].selected = "selected";
						}
					}
				}
				
				<%if(user.getOccupation() != null) {%>
					setStoredWorkStatus();
				<%}%>
				*/
				updateFields();
			</script>

			<h2>Work Status:</h2>
			<select name="updated work status" id="workStatus" onchange="updateFields(); removeDefault(this);">
				<option disabled selected value="default"> -- select an option -- </option>
				<option value="employed">Employed</option>
				<option value="unemployed">Unemployed</option>
				<option value="student">Student</option>
			</select>
	        
	        <div id="schoolField" style="display:none">
	        	<h3>High School/University</h3>
	        	<input name="updated school name" type="text" name="school">
			</div>
	        
	        <div id="schoolYearField" style="display:none">
	        	<h3>Year</h3>
	        	<select name="updated school year" onchange="updateFields(); removeDefault(this)">
	        		<option disabled selected value="default"> -- select an option -- </option>
	        	    <option style="display:none;" disabled selected value="0"> -- select an option -- </option>
	            	<option value=1>Freshman</option>
	                <option value=2>Sophmore</option>
	        		<option value=3>Junior</option>
	                <option value=4>Senior</option>
	             </select>
	        </div>
	        
	        <div id="employerField" style="display:none">
	        	<h3>Employer</h3>
	        	<input name="updated employer" type="text" name="employer">
			</div>
	           
	        <div id="positionField" style="display:none">
	        	<h3>Position</h3>
	        	<input name="updated position" type="text" name="position">
			</div>
			
			<br>
			<br>

			<input type="submit" value="Update">
		</form>
	<%}%>
</body>
</html>
