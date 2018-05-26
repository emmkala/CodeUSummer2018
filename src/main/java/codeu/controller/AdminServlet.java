package codeu.controller;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.time.Instant;
import codeu.model.data.Conversation;
import codeu.model.data.User;
import codeu.model.data.Message;
import codeu.model.store.basic.ConversationStore;
import codeu.model.store.basic.UserStore;
import codeu.model.store.basic.MessageStore;
import codeu.model.store.persistence.PersistentStorageAgent;


public class AdminServlet extends HttpServlet {
    //Set<String> admin = new HashSet<>(Arrays.asList("anAdmin", "Admin1", "Admin2"));
    private ConversationStore conversationStore;
    private MessageStore messageStore;
    private UserStore userStore;

    @Override
    public void init() throws ServletException {
        super.init();
        setConversationStore(ConversationStore.getInstance());
        setMessageStore(MessageStore.getInstance());
        setUserStore(UserStore.getInstance());
    }

    void setUserStore(UserStore userStore) {
        this.userStore = userStore;
    }
    void setConversationStore(ConversationStore conversationStore) {
        this.conversationStore = conversationStore;
    }
    void setMessageStore(MessageStore messageStore) {
        this.messageStore = messageStore;
    }


    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        List<Conversation> conversations = conversationStore.getAllConversations();
        int numMessages = 0;
        for (Conversation convo : conversations){
            numMessages += messageStore.getMessagesInConversation(convo.getId()).size();
        }
        int numConvo = conversations.size();
        int numUser = userStore.numUsers();
        request.setAttribute("numConvo", numConvo);
        request.setAttribute("numUser", numUser);
        request.setAttribute("numMessages", numMessages);
        String username = (String) request.getSession().getAttribute("user");
        if (username == null){return;}
        User user = userStore.getUser(username);
        if (user.checkAdmin()) {
            request.getRequestDispatcher("/WEB-INF/view/admin.jsp").forward(request, response);
            return;
        }

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String username = (String) request.getSession().getAttribute("user");
        User user = userStore.getUser(username);
        if (user.checkAdmin()) {
            response.sendRedirect("/admin");
            return;
        }
    }
}
