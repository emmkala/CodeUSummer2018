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
import codeu.model.store.basic.CommentStore;
import codeu.model.store.persistence.PersistentStorageAgent;
import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

public class CommentServlet extends HttpServlet{
  private CommentStore commentStore;

  @Override
  public void init() throws ServletException{
    super.init();
    commentStore = CommentStore.getInstance();
  }



public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {

        String postId = request.getParameter("post_id");
        String content = request.getParameter("content");
        String user = request.getParameter("user");

        System.out.println(postId);
        System.out.println(content);

        response.sendRedirect("/user/" + user);

  }

}
