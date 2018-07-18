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
<%@ page import="codeu.model.data.Post" %>
<%@ page import="codeu.model.data.Comment" %>

<!DOCTYPE html>
<html>
<head>
<title>Profile</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootswatch/4.1.2/litera/bootstrap.min.css">
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

	<%if(!canEdit) {%>

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
 					&emsp; &nbsp Birthday : <%=user.getBirthday(new SimpleDateFormat("MM-dd-yyyy"))%></p>
      </div>
      </div>
    </div>


		<h4><%=user.getName()%>'s Post's</h4>
    <style> h4{ text-align:center; } </style>

		<% List<Post> everyPost = (List<Post>) request.getAttribute("usersPosts");
		List<Comment> everyComment = (List<Comment>) request.getAttribute("totalComments"); %>

		<!--<div class="card text-white bg-info mb-3" style="max-width: 20rem;">
  			<div class="card-body">-->

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
				<form action="/comment?post_id=<%= post.getId() %>&user=<%user.getName();%>">
				<input type="text" name="content" placeholder="Comment on This Post!"> <br />
				<button type="submit">Send</button>
			   </form>

		<% }
		} %>
			<!--	</div>
		</div> -->

	<%} else {%>
		<%BlobstoreService blobstoreService = (BlobstoreService) request.getAttribute("blobstoreService");%>
		<img src=<%=user.getProfileImage().getURL()%> height = "150" width = "200">

		<span>Your profile</span>

		<form action=<%=blobstoreService.createUploadUrl("/upload")%> method="POST" enctype="multipart/form-data">
			<input type="file" name="profileImage">
			<input type="submit" value="Upload Image">
		</form>

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

			<script>
				reflectCurrentValues();
				updateFieldVisibility();
			</script>

			<h4>Work Status:</h4>
			<select name="updated work status" id="workStatus" onload="updateFieldVisibility()" onchange="updateFieldVisibility()" onclick = "removeDefault(this);">
				<option disabled value="default"> -- select an option -- </option>
				<option value="employed">Employed</option>
				<option value="unemployed">Unemployed</option>
				<option value="student">Student</option>
			</select>

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

			<h5> Make a Post! </h5>
			<form action="/post" method="POST">
			<input type="text" name="post" placeholder="Post about any topic you want!">
			<button type="submit">Send</button>
			</form>
      </form>

			<h4> Your Posts </h4>

			<% List<Post> everyPost = (List<Post>) request.getAttribute("usersPosts");
				 List<Comment> everyComment = (List<Comment>) request.getAttribute("totalComments");
				 if(everyPost == null){ %>
						<p> You haven't made any posts. </p>
			<% } else { %>
				<% for(Post post : everyPost){ %>
				<div class="card text-white bg-info mb-3" style="max-width: 20rem;">
					<div class="card-body">
						<p class="card-text"><%=post.getContent()%></p>
					</div>
				</div>
						<%for(Comment comment : everyComment){
								if(comment.getPostId() == post.getId()){%>
								<p> <%=comment.getContent()%> </p>
						<% }
					}%>


					<form action="/comment?post_id=<%= post.getId() %>&user=<%user.getName();%>">
					<input type="text" name="content" placeholder="Comment on Your Post!"> <br />
					<button type="submit">Send</button>
				</form>
			<% }
			} %>

			<input type="submit" value="Update">
		</form>
	<%}%>
</body>
</html>
