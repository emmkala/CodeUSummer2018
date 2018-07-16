<%@page import="codeu.model.data.User.OccupationType"%>
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

<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
<link rel="stylesheet" href="/css/main.css">
<%
   String requestedProfile = (String) request.getAttribute("requestedProfile");
   User user = UserStore.getInstance().getUser(requestedProfile);
 	boolean canEdit = (boolean) request.getAttribute("canEdit");
%>
<script>
 	function updateFieldVisibility(){
       var workStatus = document.getElementById("workStatus");
       var occupationField1 = document.getElementById("OF1");
       var occupationField2 = document.getElementById("OF2");


       if(workStatus.value != "unemployed" && workStatus.value != "default"){
    	   occupationField1.style.display = "block";
    	   occupationField2.style.display = "block";
    	   if(workStatus.value == "student"){
    		   document.getElementById("OF1Header").innerHTML = "School";
    		   document.getElementById("OF2YearSelect").style.display = "block";
    		   document.getElementById("OF2PositionSection").style.display = "none";
    		   document.getElementById("OF2YearInput").name = "updated f2";
    		   document.getElementById("OF2PositionInput").name = "";
    	   }
    	   if(workStatus.value == "employed"){
    		   document.getElementById("OF1Header").innerHTML = "Employer";
    		   document.getElementById("OF2YearSelect").style.display = "none";
    		   document.getElementById("OF2PositionSection").style.display = "block";
    		   document.getElementById("OF2YearInput").name = "";
    		   document.getElementById("OF2PositionInput").name = "updated f2";
    	   }

       } else {
    	   occupationField1.style.display = "none";
    	   occupationField2.style.display = "none";
       }
     }


	function removeDefault(elem) {
		var options = elem.childNodes;
		for (i = 0; i < options.length; i++) {
			if (options[i].value == "default") {
				options[i].style = "display:none";
				break;
			}
		}
	}

	function reflectCurrentValues(){
		<%if(user.getOccupation() == null) {%>
			document.getElementById("workStatus").value = "default";
		<%} else if(user.getOccupation().getOccupationType() == User.OccupationType.UNEMPLOYED) {%>
			document.getElementById("workStatus").value = "<%=user.getOccupation().getOccupationType()%>";
		<%}%>
		if(document.getElementById("workStatus").value == <%=user.getOccupation().getOccupationType().toString().toLowerCase()%>){
			document.getElementById("workStatus").value =  "<%=user.getOccupation().getOccupationType()%>";
			document.getElementById("OF1").value = <%=user.getOccupation().getf1()%>;
			document.getElementById("OF2").value = <%=user.getOccupation().getf2()%>;
		}
	}
</script>
</head>
<body>
	<nav>
		<a id="navTitle" href="/">CodeU Chat App</a> <a href="/conversations">Conversations</a>
		<% if(request.getSession().getAttribute("user") != null){ %>
			<a>Hello <%=request.getSession().getAttribute("user") %>!</a>
			<a href="/profile">My Profile</a>
			  <% if (request.getAttribute("isAdmin") != null) { %>
                                  <a href="/admin">Admin</a>
                     <% } %>
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
		<span><%=user.getName()%>'s Profile</span>
		<div> <%=user.getOccupation()%> </div>

		<hr/>

		<div> About <%=user.getName()%></div>
		<p><%= user.getDescription() %></p>

		<br>

		<span>Sex : </span>
		<span><%= user.getSex().toString().substring(0,1) + user.getSex().toString().substring(1).toLowerCase()%></span>

		<br>

		<span>Email : </span>
		<span><%= user.getEmail()%></span>

		<br>

		<span>Birthday : </span>
		<span><%=user.getBirthday(new SimpleDateFormat("MM-dd-yyyy"))%></span>

		<h2><%=user.getName()%>'s Posts</h2>
		<% List<Message> everyMessage = (List<Message>) request.getAttribute("totalMessages");
		int p = 0;
		for(Message mess : everyMessage){
			if(mess.getAuthorId().equals(user.getId())){ %>
				<p> <%= mess.getContent() %> </p>
				<form action="/user/<%= user.getName() %>">
				<input type="text" name="comment" placeholder="Comment on this post!"> <br />
				<button type="submit">Send</button>
				<% p++; %>
			<% } %>
		<% } %>
		<% if(p == 0){ %>
			<p> You have not made any posts. Head to conversations to get started! </p>
		<% } %>
	<%} else {%>
		<%BlobstoreService blobstoreService = (BlobstoreService) request.getAttribute("blobstoreService");%>
		<img src=<%=user.getProfileImage().getURL()%> height = "150" width = "200">

		<span>Your profile</span>

		<form action=<%=blobstoreService.createUploadUrl("/upload")%> method="POST" enctype="multipart/form-data">
			<input type="file" name="profileImage">
			<input type="submit" value="Upload Image">
		</form>

		<h2>Your Posts</h2>
		<% List<Message> everyMessage = (List<Message>) request.getAttribute("totalMessages");
		int i = 0;
		for(Message mess : everyMessage){
			if(mess.getAuthorId().equals(user.getId())){ %>
				<p> <%= mess.getContent() %> </p>
				<% i++; %>
			<% } %>
		<% } %>
		<% if(i == 0){ %>
			<p> You have not made any posts. Head to conversations to get started! </p>
		<% } %>
		<hr/>

		<form action="/user/<%=requestedProfile%>" method="POST">
			<div>About Me</div>
			<input name="updated description" type="text" value="<%=user.getDescription()%>">

			<br>
			<br>

			<span>Birthday : </span>
			<input name="updated birthday" type="date" value=<%=user.getBirthday(new SimpleDateFormat("yyyy-MM-dd"))%>>

			<br>
			<br>

			<span>Sex : </span>
			<select name="updated sex" onload="setDefault(this)">
				<%if(user.getSex() == User.Sex.MALE) {%>
					<option value="MALE" selected> Male</option>
					<option value="FEMALE">Female</option>
				<%} else if (user.getSex() == User.Sex.FEMALE) {%>
					<option value="MALE"> Male</option>
					<option value="FEMALE" selected>Female</option>
				<%} else {%>
					<option value="default" disabled selected>  -- select an option -- </option>
					<option value="MALE"> Male</option>
					<option value="FEMALE">Female</option>
				<%}%>
			</select>

			<br>
			<br>

			<span>Email : </span>
			<input name="updated email" type="text" value="<%=user.getEmail()%>">
<<<<<<< HEAD

			<script>
				reflectCurrentValues();
				updateFieldVisibility();
			</script>

			<h2>Work Status:</h2>
			<select name="updated work status" id="workStatus" onload="updateFieldVisibility()" onchange="updateFieldVisibility()" onclick = "removeDefault(this);">
				<option disabled value="default"> -- select an option -- </option>
				<option value="employed">Employed</option>
				<option value="unemployed">Unemployed</option>
				<option value="student">Student</option>
			</select>

	        <script>

			</script>

	        <div id="OF1" style="display:none">
	        	<div id="OF1Header">Job Position</div>
	        	<input name="updated f1" type="text">
			</div>

	        <div id="OF2" style="display:none">
				<div id="OF2YearSelect">
		        	<h3>Year</h3>
		        	<select onchange="removeDefault(this)" id="OF2YearInput">
		        		<option disabled selected value="default"> -- select an option -- </option>
		        	    <option style="display:none;" disabled selected value="0"> -- select an option -- </option>
		            	<option value="Freshman">Freshman</option>
		                <option value="Sophmore">Sophmore</option>
		        		<option value="Junior">Junior</option>
		                <option value="Senior">Senior</option>
		             </select>
				</div>
				<div id="OF2PositionSection">
					<h3>Job Position</h3>
					<input type="text" id="OF2PositionInput">
				</div>
	        </div>

			<input type="submit" value="Update">
		</form>
	<%}%>
</body>
</html>
