package codeu.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import codeu.model.data.Conversation;
import codeu.model.data.User;
import codeu.model.data.Message;
import codeu.model.store.basic.ConversationStore;
import codeu.model.store.basic.UserStore;
import codeu.model.store.basic.MessageStore;
import codeu.model.store.persistence.PersistentStorageAgent;

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






}
