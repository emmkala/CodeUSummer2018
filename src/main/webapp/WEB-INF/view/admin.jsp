<!DOCTYPE html>
<html>
<head>
  <title>Administration</title>
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
    <a href="/admin">Admin</a>
  </nav>
  <h1>Administration</h1>

  <p>This is the admin page</p>
  <h2>Site Statistics</h2>
  <p>Here are some site stats:</p>
  <ul>
  <li>Users:
  <li>Conversations:
  <%if(request.getSession().getAttribute("numofConvo") == null) {%>
    <a>0</a>
    <% }else { %>
          <a><%= request.getSession().getAttribute("numofConvo")%></a>
           <% } %> 
  <li>Messages:
  </ul>
</body>
</html>
