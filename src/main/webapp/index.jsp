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
<!DOCTYPE html>
<html>
<head>
  <title>ECBC - CodeU App</title>
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

  <div id="container">
    <div style="width:75%; margin-left:auto; margin-right:auto; margin-top: 50px;">
      <br> <br>
      <h2>ECBC - CodeU App</h2>
      <br>
      <h3>Welcome!</h3>

        <p style="border-style: solid; border-radius: 5px; background-color: #cbebf2; width: 116.5%; border-color: #cbebf2"><a href="/login">Login</a> to get started.</p>
        <br>
        <p style="border-style: solid; border-radius: 5px; background-color: #84c2ce; width: 100%; border-color: #84c2ce">Go to the <a href="/conversations">conversations</a> page to
            create or join a conversation.</p>
        <br>
        <p style="border-style: solid; border-radius: 5px; background-color: #cbebf2; width: 116.5%; border-color: #cbebf2">View the <a href="/about.jsp">about</a> page to learn more about the
            project.</p>
    </div>
  </div>
</body>
</html>
