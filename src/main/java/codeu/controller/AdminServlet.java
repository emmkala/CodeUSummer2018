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


public class AdminServlet extends HttpServlet {
    //Set<String> admin = new HashSet<>(Arrays.asList("anAdmin", "Admin1", "Admin2"));
    private ConversationStore conversationStore;
    private MessageStore messageStore;
    private UserStore userStore;
    private PersistentStorageAgent persistentStorage;

    @Override
    public void init() throws ServletException {
        super.init();
        setConversationStore(ConversationStore.getInstance());
        setMessageStore(MessageStore.getInstance());
        setUserStore(UserStore.getInstance());
        setPersistentStore(PersistentStorageAgent.getInstance());
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
    
    void setPersistentStore(PersistentStorageAgent persistentStorage) {
        this.persistentStorage = persistentStorage;
    }
    
    void addToHashMap(HashMap<User, Integer> map, User key, int val){
        if (map.containsKey(key)){
            map.put(key, map.get(key) + val);
        } else {
            map.put(key, val);
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        List<Conversation> conversations = conversationStore.getAllConversations();
        HashMap<User, Integer> mostActive = new HashMap<User, Integer>();
        HashMap<User, Integer> wordiest = new HashMap<User, Integer>();
        int numMessages = 0;
        for (Conversation convo : conversations){
            User convoUser = userStore.getUser(convo.getOwnerId());
            addToHashMap(mostActive, convoUser, 1);
            List<Message> messageList = messageStore.getMessagesInConversation(convo.getId());
            numMessages += messageList.size();
            for (Message mess : messageList){
                int length = mess.getContent().length();
                User messUser = userStore.getUser(mess.getAuthorId());
                addToHashMap(mostActive, messUser, 1);
                addToHashMap(wordiest, messUser, length);
            }

        }
        User actUser = Collections.max(mostActive.entrySet(),
                Map.Entry.comparingByValue()).getKey();
        User wordUser = Collections.max(wordiest.entrySet(),
                Map.Entry.comparingByValue()).getKey();
        int numConvo = conversations.size();
        int numUser = userStore.numUsers();
        request.setAttribute("numConvo", numConvo);
        request.setAttribute("numUser", numUser);
        request.setAttribute("numMessages", numMessages);
        request.setAttribute("lastUser", userStore.lastUser().getName());
        request.setAttribute("mostActive", actUser.getName());
        request.setAttribute("wordiest", wordUser.getName());
        String username = (String) request.getSession().getAttribute("user");
        if (username == null){return;}
        User user = userStore.getUser(username);
        
        request.setAttribute("isAdmin", user != null ? user.checkAdmin() : false);
        
        request.getRequestDispatcher("/WEB-INF/view/admin.jsp").forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
    	if(request.getParameter("deleteEverthing") != null) {
    		persistentStorage.clearData();
    	}
    	
        String username = (String) request.getSession().getAttribute("user");
        User user = userStore.getUser(username);
                
        if (user.checkAdmin()) {
            response.sendRedirect("/admin");
            return;
        }
    }
}
