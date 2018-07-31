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
import codeu.model.data.Comment;
import codeu.model.store.basic.UserStore;
import codeu.model.store.basic.CommentStore;
import codeu.model.store.basic.PostStore;
import codeu.model.store.persistence.PersistentStorageAgent;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

public class CommentServlet extends HttpServlet{
  private CommentStore commentStore;
  private UserStore userStore;
  private PostStore postStore;

  @Override
  public void init() throws ServletException{
    super.init();
    commentStore = CommentStore.getInstance();
    userStore = UserStore.getInstance();
    postStore = PostStore.getInstance();
  }

  @Override
  public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {

        String usersProfile = getNameFromURL(request.getRequestURL());
        System.out.println(usersProfile);

      request.getRequestDispatcher("/WEB-INF/view/profile.jsp").forward(request, response);

  }

public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {

        String usersProfile = getNameFromURL(request.getRequestURL());
        System.out.println(usersProfile);
        
        String stringPostId = request.getParameter("post_id");
        String content = request.getParameter("content");
        String user = (String) request.getSession().getAttribute("user");

        UUID postId = UUID.fromString(stringPostId);

        String cleanedCommentContent = Jsoup.clean(content, Whitelist.none());

        Comment comment =
            new Comment(
                UUID.randomUUID(),
                userStore.getUser(user).getId(),
                Instant.now(),
                postId,
                UUID.randomUUID(),
                cleanedCommentContent);

        CommentStore.getInstance().addComment(comment);

      response.sendRedirect("/user/newPerson");

  }

  private String getNameFromURL(StringBuffer URL) {
		String URL_String = URL.toString();
		int usernameStartIndex = URL_String.indexOf("/user/");
		usernameStartIndex += "/user/".length();
		return URL_String.substring(usernameStartIndex);
	}

}
