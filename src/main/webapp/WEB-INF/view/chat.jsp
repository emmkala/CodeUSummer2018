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
<%@ page import="java.util.List"%>
<%@ page import="codeu.model.data.Conversation"%>
<%@ page import="codeu.model.data.Message"%>
<%@ page import="codeu.model.data.User"%>
<%@ page import="codeu.model.store.basic.UserStore"%>
<%
Conversation conversation = (Conversation) request.getAttribute("conversation");
List<Message> messages = (List<Message>) request.getAttribute("messages");
%>

<!DOCTYPE html>
<html>
<head>
<title><%= conversation.getTitle() %></title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootswatch/4.1.2/litera/bootstrap.min.css" type="text/css">
<link rel="stylesheet" href="/css/chat.css" type="text/css">

<script>
    // scroll the chat div to the bottom
    function scrollChat() {
      var chatDiv = document.getElementById('chat');
      chatDiv.scrollTop = chatDiv.scrollHeight;
    };
  </script>
</head>
<body onload="scrollChat()">
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
		<h3>&emsp; <%= conversation.getTitle() %>
			<a href="" style="float: right">&#8635;</a>
		</h3>

		<hr/>
		<!--
					IN PROGRESS WORK ON POP MENU

					HTML:
					<div class="author">
					  David Lawson
					  <div class="popup">
					    <img class="image" src="https://yogifil.la/200/200">
					    <h3 class="name"> David Lawson </h3>
					    <p class="description">Baseball player for Atlanta Braves</p>
					    <p class="email">dLawson@gmail.com</p>
					  </div>
					</div>

					CSS:
					.popup {
					  position: absolute;
					  background-color: black;
					  left: 100px;
					  display: none;
					}

					.image {
					  height: 100px;
					  width: 100px;
					}

					.name {
					  position: absolute;
					  bottom: 65px;
					  left: 105px;
					  white-space: nowrap;
					}

					.description {
					  position: absolute;
					  font-size: 12px;
					  bottom: 50px;
					  left: 105px;
					  white-space: nowrap;
					}

					.email {
					  position: absolute;
					  font-size: 12px;
					  bottom: 30px;
					  left: 105px;
					  white-space: nowrap;
					}

					.author:hover .popup {
					  display: block;
					}
		-->
		<div id="chat">
			<ul>
            <%
            for (Message message : messages) {
              String authorName = UserStore.getInstance().getUser(message.getAuthorId()).getName();
              User author = UserStore.getInstance().getUser(authorName);
              %>
						<!-- Creates a pop-up that comes up when you hover over a person's name -->
            <li>
						<span class="author">
						  <a href=<%="/user/"+authorName%>><%=authorName + " "%></a>
						  <div class="popup">
							    <img class="popup-image" src="<%=author.getProfileImage().getURL()%>">
							    <div class="popup-text">
								    <h6 class="popup-name"> <%=authorName%> </h6>
								    <p class="popup-occupation"><%=author.getOccupation()%></p>
								    <p class="popup-email"><%=author.getEmail()%></p>
								</div>
						  </div>
						</span>
            <p><%=message.getContent()%></p>
					</li>
				<%}%>
			</ul>
		</div>

		<hr/>

		<% if (request.getSession().getAttribute("user") != null) { %>
			<form action="/chat/<%= conversation.getTitle() %>" method="POST">
        <div id="outer">
        <div class="inner"><button class="btn btn-info" type="submit">Send</button></div>
				<div class="inner" id="text"><input style= "width:75%; background-color: #dcf4f7" class="form-control" type="text" name="message"></div>
        </div>
			</form>
		<% } else { %>
			<p>
				<a href="/login">Login</a> to send a message.
			</p>
		<% } %>

		<hr/>

	</div>
</body>
</html>
