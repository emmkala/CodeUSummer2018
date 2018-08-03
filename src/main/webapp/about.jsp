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
  <link rel="stylesheet" href="/css/main.css">
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
    <div
      style="width:75%; margin-left:auto; margin-right:auto; margin-top: 50px;">

      <h3>ECBC CodeU App</h3>
      <p>
        ECBC (East Coast Beast Coast) CodeU App is an app in which our team, Biya Haile, Emma Landry, and Peilin Zhen,
        worked with a mentor Faisal Animashaun and built upon an existing code base provided by the CodeU Team at Google.
      </p>
      <div class="teamRow">
      <h4> Our Team </h4>
      <div align="center">
      <figure class="team">
      <div align="center"><img class="profile" src="BiyaDescription.jpg" style="width: 60%"></div>
        <figcaption style="font-size: 15px">
          My name is Biya Haile. I was born and raised in Ethiopia.
          Currently, I am undergraduate student at Georgia Tech, majoring in Mechanical
          Engineering and minoring in Aerospace Engineering.
        </figcaption>
      </figure>

      <figure class="team">
      <div align="center"><img class="profile" src="EmmaDescription.jpg" style="width: 70%"></div>
          <figcaption style="font-size: 15px">
            My name is Emma Landry. I was born in raised in a little town in Nova Scotia Canada.
            I'm going into my second year at Queen's University for Computer Science with a specializaiton in
            Software Development. I'm part of the all female a capella group there and also love to
            spend hours watching questionably good shows on netflix.
          </figcaption>
      </figure>

      <figure class="team">
        <div align="center"><img class="profile" src="PeilinDescription.jpg" style="width: 60%"></div>
          <figcaption style="font-size: 15px">
            My name is Peilin Zhen and I'm a rising third-year math student at New York University.
            I was born in Canton, China and moved to New York when I was 12. During my leisure
            time, I like outdoor running and watching entertainment shows.
          </figcaption>
      <figure>
      </div>
      </div>
      <h4> Our App </h4>
      <p> We have created an online sharing site, where users can create conversations as well as make posts
        which others can comment on. We have also implemented the ability to personalize your profile with information
        as well as a profile picture, which shows up in a snippet upon hovering over a users name in the chat section.
        Finally, we have used Bootstrap to style our site, making it unique and modern, with a intuitive structure.
      </p>
    </div>
  </div>
</body>
</html>
