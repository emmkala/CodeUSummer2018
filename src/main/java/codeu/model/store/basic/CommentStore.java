package codeu.model.store.basic;

import codeu.model.data.Comment;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import codeu.model.store.persistence.PersistentStorageAgent;

public class CommentStore{

    private static CommentStore instance;

    public static CommentStore getTestInstance(PersistentStorageAgent persistentStorageAgent) {
        return new CommentStore(persistentStorageAgent);
    }

    private PersistentStorageAgent persistentStorageAgent;

    private List<Comment> commentList;

    private CommentStore(PersistentStorageAgent persistentStorageAgent) {
        this.persistentStorageAgent = persistentStorageAgent;
        commentList = new ArrayList<>();
    }

    public List<Comment> getAllComment() {
        return commentList;
    }

    public void addComment(Comment comment) {
        commentList.add(comment);
        persistentStorageAgent.writeThrough(comment);
    }

    public List<List<Comment>> getAllCommentsInPost(UUID postId) {
        List<List<Comment>> commentInPost = new ArrayList<List<Comment>>();

        return commentInPost;

    }


}