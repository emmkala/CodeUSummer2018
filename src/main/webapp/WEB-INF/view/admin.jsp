<!DOCTYPE html>
<html>
<head>
<title>Administration</title>
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
	    <jsp:include page="/WEB-INF/view/navbar.jsp">
            <jsp:param name="user" value="<%=request.getSession().getAttribute(\"user\")%>"/>
            <jsp:param name="isAdmin" value="<%=request.getSession().getAttribute(\"isAdmin\")%>"/>
        </jsp:include>
        
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
