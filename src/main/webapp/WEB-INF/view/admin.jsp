<!DOCTYPE html>
<html>
<head>
<title>Administration</title>
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
	<nav>
		<a id="navTitle" href="/">CodeU Chat App</a> <a href="/conversations">Conversations</a>
		<% if(request.getSession().getAttribute("user") != null){ %>
			<a>Hello <%= request.getSession().getAttribute("user") %>!</a>
			<a href="/profile">My Profile</a>
		<% } else{ %>
			<a href="/login">Login</a>
		<% } %>
		<a href="/admin">Admin</a>
		<a href="/about.jsp">About</a>
	</nav>
	<%boolean isAdmin = (Boolean) request.getAttribute("isAdmin");%>
	<%if(isAdmin){%>
		<h1>Administration</h1>
		<h2>Site Statistics</h2>
		<p>Here are some site stats:</p>
		<ul>
			<li>Users: <a><%= request.getAttribute("numUser")%></a>
			<li>Conversations: <a><%= request.getAttribute("numConvo") %></a>
			<li>Messages: <a><%= request.getAttribute("numMessages") %></a>
			<li>Most active user: <% if(request.getAttribute("mostActive") != null){ %>
				<a><%= request.getAttribute("mostActive")  %></a> <% } %>
			<li>Newest user: <% if(request.getAttribute("lastUser") != null){ %>
				<a><%= request.getAttribute("lastUser")  %></a> <% } %>
			<li>Wordiest user: <% if(request.getAttribute("wordiest") != null){ %>
				<a><%= request.getAttribute("wordiest")  %></a> <% } %>
		</ul>
		<form action="/admin" method="POST">
			<input name="deleteEverything" type="submit" value="DELETE DATASTORE">
		</form>
	<%} else {%>
		<h1>Access denied: Not logged into an admin account</h1>
	<%}%>

</html>
