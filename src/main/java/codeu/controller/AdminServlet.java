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


public class AdminServlet extends HttpServlet {
    Set<String> admin = new HashSet<>(Arrays.asList("anAdmin", "Admin1", "Admin2"));
    private UserStore userStore;
    private ConversationStore conversationStore;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (admin.contains(username)) {
            request.getRequestDispatcher("/WEB-INF/view/admin.jsp").forward(request, response);
            return;
        } 
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int numOfConvo = conversationStore.getAllConversations().size();
        request.setAttribute("numofConvo", numOfConvo);

        String username = (String) request.getSession().getAttribute("user");
        if (admin.contains(username)) {
            //if(username.equals("anAdmin")){
            response.sendRedirect("/admin");
        }

    }
}
