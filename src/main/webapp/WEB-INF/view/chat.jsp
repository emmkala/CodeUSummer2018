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
<link rel="stylesheet" href="/css/chat.css" type="text/css">
<link rel="stylesheet" href="/css/main.css" type="text/css">

<script>
    // scroll the chat div to the bottom
    function scrollChat() {
      var chatDiv = document.getElementById('chat');
      chatDiv.scrollTop = chatDiv.scrollHeight;
    };
  </script>
</head>
<body onload="scrollChat()">
	<nav>
		<a id="navTitle" href="/">CodeU Chat App</a> <a href="/conversations">Conversations</a>
		<% if (request.getSession().getAttribute("user") != null) { %>
			<a>Hello <%= request.getSession().getAttribute("user") %>!</a>
			<a href="/profile">My Profile</a>
			<% if (request.getAttribute("isAdmin") != null) { %>
                    				<a href="/admin">Admin</a>
                    			<% } %>
		<% } else { %>
			<a href="/login">Login</a>
		<% } %>
		<a href="/about.jsp">About</a>

	</nav>

	<div id="container">
		<h1><%= conversation.getTitle() %>
			<a href="" style="float: right">&#8635;</a>
		</h1>

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
				  String authorName = UserStore.getInstance()
				    .getUser(message.getAuthorId()).getName();
				  User author = UserStore.getInstance().getUser(authorName);
				%>
					<li>
						<!-- Creates a pop-up that comes up when you hover over a person's name -->
						<span class="author">
						  <a href=<%="/user/"+authorName%>><%=authorName + " "%></a>
						  <div class="popup">
							    <img class="popup-image" src="<%=author.getProfileImage().getURL()%>">
							    <div class="popup-text">
								    <h3 class="popup-name"> <%=authorName%> </h3>
								    <p class="popup-occupation"><%=author.getOccupation()%></p>
								    <p class="popup-email"><%=author.getEmail()%></p>
								</div>
						  </div>
						</span>
					</li>
				<%}%>
			</ul>
		</div>

		<hr/>

		<% if (request.getSession().getAttribute("user") != null) { %>
			<form action="/chat/<%= conversation.getTitle() %>" method="POST">
				<input type="text" name="message"> <br />
				<button type="submit">Send</button>
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
