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
    <div
      style="width:75%; margin-left:auto; margin-right:auto; margin-top: 50px;">

      <h1>ECBC CodeU App</h1>
      <p>
        ECBC (East Coast Beast Coast) CodeU App is an app in which our team, Biya Haile, Emma Landry, and Peilin Zhen,
        worked with a mentor Faisal Animashaun and built upon an existing code base provided by the CodeU Team at Google.
      </p>

      <ul>
        <li><strong>Algorithms and data structures:</strong> We've made the app
            and the code as simple as possible. You will have to extend the
            existing data structures to support your enhancements to the app,
            and also make changes for performance and scalability as your app
            increases in complexity.</li>
        <li><strong>Look and feel:</strong> The focus of CodeU is on the Java
          side of things, but if you're particularly interested you might use
          HTML, CSS, and JavaScript to make the chat app prettier.</li>
        <li><strong>Customization:</strong> Think about a group you care about.
          What needs do they have? How could you help? Think about technical
          requirements, privacy concerns, and accessibility and
          internationalization.</li>
      </ul>

      <p>
        This is your code now. Get familiar with it and get comfortable
        working with your team to plan and make changes. Start by updating the
        homepage and this about page to tell your users more about your team.
        This page should also be used to describe the features and improvements
        you've added.
      </p>
    </div>
  </div>
</body>
</html>
