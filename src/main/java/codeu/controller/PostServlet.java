package codeu.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import codeu.model.data.User;
import codeu.model.data.Post;
import codeu.model.store.basic.UserStore;
import codeu.model.store.basic.PostStore;
import codeu.model.store.persistence.PersistentStorageAgent;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

public class PostServlet extends HttpServlet{
    private UserStore userStore;
    private PostStore postStore;

    @Override
    public void init() throws ServletException{
      super.init();
      setUserStore(UserStore.getInstance());
      setPostStore(PostStore.getInstance());
    }

    void setUserStore(UserStore userStore) {
      this.userStore = userStore;
    }

    void setPostStore(PostStore PostStore) {
        this.postStore = postStore;
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {

      String userName = request.getParameter("user");

  		User currentUser = userStore.getUser(userName);
      UUID currentUserID = currentUser.getId();


      List<Post> allUsersPosts = postStore.getPostsByUserID(currentUserID);
      request.setAttribute("usersPosts", allUsersPosts);

      request.getRequestDispatcher("/WEB-INF/view/profile.jsp").forward(request, response);

      }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
          throws IOException, ServletException {

      String userName = (String) request.getSession().getAttribute("user");

      String postContent = request.getParameter("post");
      // this removes any HTML from the message content
      String cleanedPostContent = Jsoup.clean(postContent, Whitelist.none());

      Post post =
          new Post(
              UUID.randomUUID(),
              userStore.getUser(userName).getId(),
              Instant.now(),
              cleanedPostContent);

      postStore.addPost(post);
      // redirect to a GET request
      response.sendRedirect("/user/" + userName);

    }
    private String getNameFromURL(StringBuffer URL) {
  		String URL_String = URL.toString();
  		int usernameStartIndex = URL_String.indexOf("/user/");
  		usernameStartIndex += "/user/".length();
  		return URL_String.substring(usernameStartIndex);
  	}




}
