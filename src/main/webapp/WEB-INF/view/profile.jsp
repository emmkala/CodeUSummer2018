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
<%@ page import="codeu.model.data.Comment" %>

<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootswatch/4.1.2/litera/bootstrap.min.css">
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="/">CodeU Chat App</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor03" aria-controls="navbarColor03" aria-expanded="false" aria-label="Toggle navigation">
  	<span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarColor03">
  	<ul class="navbar-nav mr-auto">
  		<li class="nav-item active">
  			<a class="nav-link" href="/conversations">Conversations <span class="sr-only">(current)</span></a>
  		</li>
  		<li class="nav-item">
  			<% if(request.getSession().getAttribute("user") != null){ %>
  				<a class="nav-link"> Hello <%=request.getSession().getAttribute("user") %>!</a>
  			<% } else{ %>
  					<a class="nav-link" href="/login">Login</a>
  			<% } %>
  		</li>
  		<li class="nav-item">
  			<a class="nav-link" href="/about.jsp">About</a>
  		</li>
  	</ul>
  </div>
  </nav>

	<%
    String requestedProfile = (String) request.getAttribute("requestedProfile");
    User user = UserStore.getInstance().getUser(requestedProfile);
  	boolean canEdit = (boolean) request.getAttribute("canEdit");
 	%>

	<% if(canEdit) {%>
		<img src=<%=user.getProfileImage().getURL()%> height = "150" width = "200">
		<h1>Your profile</h1>
		<%BlobstoreService blobstoreService = (BlobstoreService) request.getAttribute("blobstoreService");%>
		<form action=<%=blobstoreService.createUploadUrl("/upload")%> method="POST" enctype="multipart/form-data">
			<input type="file" name="profileImage">
			<input type="submit" value="Upload Image">
		</form>
  </form>

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

			<h5>Sex: </h5>
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
	        	<h5>High School/University</h5>
	        	<input name="updated school name" type="text" name="school">
			</div>

	        <div id="schoolYearField">
	        	<h5>Year</h5>
	        	<select name="updated school year">
	            	<option value=1>Freshman</option>
	                <option value=2>Sophmore</option>
	        		<option value=3>Junior</option>
	                <option value=4>Senior</option>
	             </select>
	        </div>

	        <div id="employerField">
	        	<h5>Employer</h5>
	        	<input name="updated employer" type="text" name="employer">
			</div>

	        <div id="positionField">
	        	<h5>Position</h5>
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

			<h5>Work Status:</h5>
			<select name="updated work status" id="workStatus" onchange="updateFields(); removeDefault(this);">
				<option disabled selected value="default"> -- select an option -- </option>
				<option value="employed">Employed</option>
				<option value="unemployed">Unemployed</option>
				<option value="student">Student</option>
			</select>

	        <div id="schoolField" style="display:none">
	        	<h5>High School/University</h5>
	        	<input name="updated school name" type="text" name="school">
			</div>

	        <div id="schoolYearField" style="display:none">
	        	<h5>Year</h5>
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
	        	<h5>Employer</h5>
	        	<input name="updated employer" type="text" name="employer">
			</div>

	        <div id="positionField" style="display:none">
	        	<h5>Position</h5>
	        	<input name="updated position" type="text" name="position">
			</div>

			<br>

			<input type="submit" value="Update">
		</form>
	<%} else {%>
      <p style="text-align:center;"> <img src="<%=user.getProfileImage().getURL()%>" height=150 width=150> </p>
      <h6><%=user.getName()%>'s Profile</h6>
      <h6> <%=user.getOccupation()%> </h6>
      <style> h6{text-align: center;} </style>

      <hr/>

      <div class="card-deck">
      <div class="card">
        <div class="card border-info mb-3" style="max-width: 65rem;">
          <div class="card-body"></div>
          <div class="card-header">About <%=user.getName()%></div>
             <p class="card-text"> &nbsp <%= user.getDescription() %></p>
        </div>
      </div>
      <div class="card">
        <div class="card border-info mb-3" style="max-width: 65rem;">
          <div class="card-body"></div>
          <div class="card-header">General Informaion</div>
             <p class="card-text">
            &emsp; Email : <%= user.getEmail()%>
            &emsp; &nbsp Birthday : <%=user.getBirthday(new SimpleDateFormat("MM,dd,yyyy"))%></p>
        </div>
        </div>
      </div>

    <%}%>
    <% if(canEdit) {%>
    <h5> Make a Post! </h5>
    <form action="/post" method="POST">
    <input type="text" name="post" placeholder="Post about any topic you want!">
    <button type="submit">Send</button>
    </form>
    <br>
    <%}%>

  <h5> Posts </h5>
  <style>h5{text-align: center;}</style>

  <% List<Post> everyPost = (List<Post>) request.getAttribute("usersPosts");
  List<Comment> everyComment = (List<Comment>) request.getAttribute("totalComments"); %>

  <% if(everyPost == null){ %>
        <p> They haven't made any posts. </p>
  <% } else { %>
    <% for(Post post : everyPost){ %>
      <p> <%=post.getContent()%> </p>
      <%for(Comment comment : everyComment){
          if(comment.getPostId() == post.getId()){%>
          <p> <%=comment.getContent()%> </p>
      <% }
    }%>
      <form action="/comment?post_id=<%= post.getId() %>&user=<%user.getName();%>" method="POST">
      <input type="text" name="content" placeholder="Comment on This Post!"> <br />
      <button type="submit">Send</button>
      </form>

  <% }
  } %>


</body>
</html>
