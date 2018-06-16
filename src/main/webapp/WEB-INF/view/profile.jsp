<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="codeu.model.data.User"%>
<%@ page import="codeu.model.store.basic.UserStore" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
  <title>Profile</title>
  <link rel="stylesheet" href="/css/main.css">
</head>
<body>
  <nav>
    <a id="navTitle" href="/">CodeU Chat App</a>
    <a href="/conversations">Conversations</a>
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
   <%if(canEdit) {%>
     <h1>Your profile</h1>
   <%} else {%>
    <h1><%=user.getName()%>'s Page</h1>
  <%}%>
  
  <hr>
  
  <%if(!canEdit) {%>
	<h2>About <%=user.getName()%></h2>
	<%if(user.getDescription().trim() != "") {%>
		<p><%= user.getDescription() %></p>
	<%} else {%>
		<p>no description</p>
 	<%}%>
  
  	<br><br>
  
    <h2><%=user.getName()%>'s Birthday</h2>
    <%if(user.getBirthday() != null) {%>
	    <p><%=user.getBirthday()%></p>
    <%} else {%>
	    <p>Birthday not set</p>
    <%} %>
  <%} else {%>
    <form action="/user/<%=requestedProfile%>" method="POST">	
     <h2>Edit About Me</h2>
     <p>About Me:</p>
     <input name = "updated description" type = "text" value="<%=user.getDescription()%>" width = "300" height="200">
  	 <br><br>
  
  	 <h2>Edit Birthday</h2>
     <%if(user.getBirthday() != null) {%>
    	<p>Birthday: <%=user.getBirthdayAsString()%></p>
     <%} else {%>
         <p>Birthday not set</p>
     <%}%>
     
     <input name = "updated birthday" type = "date">
     
     <br>
     <br>
     
     <input type = "submit" value = "update">
     </form>
  <%}%>
</body>
</html>
