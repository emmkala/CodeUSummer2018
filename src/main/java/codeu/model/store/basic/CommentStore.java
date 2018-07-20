package codeu.model.store.basic;

import codeu.model.data.Comment;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import codeu.model.store.persistence.PersistentStorageAgent;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.Stack;
import java.util.Map;

public class CommentStore {

    private static CommentStore instance;

    public static CommentStore getInstance() {
        if (instance == null) {
            instance = new CommentStore (PersistentStorageAgent.getInstance());
        }
        return instance;
    }

    public static CommentStore getTestInstance(PersistentStorageAgent persistentStorageAgent) {
        return new CommentStore(persistentStorageAgent);
    }

    private PersistentStorageAgent persistentStorageAgent;

    private List<Comment> commentList;

    private CommentStore(PersistentStorageAgent persistentStorageAgent) {
        this.persistentStorageAgent = persistentStorageAgent;
        commentList = new ArrayList<>();
    }

    public List<Comment> getAllComments() {
        try  {
            return persistentStorageAgent.loadComments();
        } catch(Exception e) {
            System.out.println("Unable to getAllComments()");
            System.out.println(e);
            return new ArrayList<>();
        }
    }

    public void addComment(Comment comment) {
        commentList.add(comment);
        persistentStorageAgent.writeThrough(comment);
    }

    public List<Comment> getAllCommentsInPost(String postId) {

        UUID id = UUID.fromString(postId);

        // gets all comments with same postId into a list
        List<Comment> allCommentsInPost = new ArrayList<>();
        try {
            List<Comment> comments = persistentStorageAgent
                .getCommentsForPost(postId)
                .stream()
                .filter(comment -> comment.getPostId() == id)
                .collect(Collectors.toList());
            allCommentsInPost.addAll(comments);
        } catch (Exception e) {
            System.out.println("Unable to get comments for post");
            System.out.println(e);
        }

        //separates them into ancestors and children
        List<Comment> ancestors = allCommentsInPost.stream().filter(comment -> comment.getParentId() == null)
                .collect(Collectors.toList());
        List<Comment> children = allCommentsInPost.stream().filter(comment -> comment.getParentId() != null)
                .collect(Collectors.toList());

        //sorts all the chilren based on the corresponding parentId into a hash map
        Map<UUID, List<Comment>> hmap = new HashMap<>();
        for (Comment child: children){
            UUID parentid = child.getParentId();
            List<Comment> nested = hmap.containsKey(parentid) ? hmap.get(parentid): new ArrayList<>();
            nested.add(child);
            hmap.put(parentid, nested);
        }

        Stack<Comment> commentStack = new Stack<>();
        commentStack.addAll(ancestors);

        while (!commentStack.isEmpty()){
            Comment comment = commentStack.pop();
            if (hmap.containsKey(comment.getId())) {
                comment.setChildren(hmap.get(comment.getId()));
                List<Comment> commentChildren = comment.getChildren();
                commentStack.addAll(commentChildren);
            }
        }
        return ancestors;
    }
}
