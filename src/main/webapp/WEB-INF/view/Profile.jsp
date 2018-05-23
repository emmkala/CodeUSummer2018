<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
  <title>Profile </title>
  <link rel="stylesheet" href="/css/main.css" type="text/css">
</head>


  <nav>
    <a id="navTitle" href="/">CodeU Chat App</a>
    <a href="/conversations">Conversations</a>
      <% if (request.getSession().getAttribute("user") != null) { %>
    <a>Hello <%= request.getSession().getAttribute("user") %>!</a>
    <% } else { %>
      <a href="/login">Login</a>
    <% } %>
    <a href="/about.jsp">About</a>
  </nav>
<h1> Hello This_is_test </h1>

</body>
</html>
