<%--
  Copyright 2017 Google Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>
<%@ page import="java.util.List" %>
<%@ page import="codeu.model.data.Conversation" %>

<!DOCTYPE html>
<html>
<head>
  <title>Conversations</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootswatch/4.1.2/litera/bootstrap.min.css">
</head>
<body>

  <nav class="navbar navbar-expand-lg navbar-light bg-light">
  <img src="whaleTaleLogoFullOutline.png" height="35px" width="35px">
  <a class="navbar-brand" href="/">&nbsp; ECBC CodeU App</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor03" aria-controls="navbarColor03" aria-expanded="false" aria-label="Toggle navigation">
  	<span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarColor03">
  	<ul class="navbar-nav mr-auto">
  		<li class="nav-item active">
  			<a class="nav-link" href="/conversations">Conversations <span class="sr-only">(current)</span></a>
  		</li>
      <li class="nav-item">
  			<% if(request.getSession().getAttribute("user") != null){
          String profileName = String.valueOf(request.getSession().getAttribute("user"));%>
  				<a class="nav-link" href=<%="/user/"+profileName%>> Hello <%=request.getSession().getAttribute("user") %>!</a>
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

  <div id="container">

    <% if(request.getAttribute("error") != null){ %>
        <h2 style="color:red"><%= request.getAttribute("error") %></h2>
    <% } %>
    <div align="center">
    <% if(request.getSession().getAttribute("user") != null){ %>
      <h3>New Conversation</h3>
      <form action="/conversations" method="POST">
          <div class="form-group">
          <input style= "background-color: #c5e3e5" type="text" placeholder="Title" class="form-control" name="conversationTitle">
        </div>

        <button type="submit"  class="btn btn-outline-info">Create</button>
      </form>

      <hr/>
    <% } %>

    <h3>Conversations</h3>

    <%
    List<Conversation> conversations =
      (List<Conversation>) request.getAttribute("conversations");
    if(conversations == null || conversations.isEmpty()){
    %>
      <p>Create a conversation to get started.</p>
    <%
    }
    else{
    %>
      <!-- <ul class="mdl-list"> -->
    <%
      for(Conversation conversation : conversations){
    %>
      <a href="/chat/<%= conversation.getTitle() %>" style= "color: #64a6ad">
        <%= conversation.getTitle() %></a>
        &emsp; &emsp;
    <%
      }
    %>
      <!--</ul>-->
    <%
    }
    %>
  </div>
    <hr/>
  </div>
</body>
</html>
