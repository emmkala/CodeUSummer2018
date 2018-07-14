package codeu.model.store.basic;

import codeu.model.data.Comment;
import java.util.ArrayList;
import java.util.List;
import java.util.*;
import java.util.UUID;
import codeu.model.store.persistence.PersistentStorageAgent;

public class CommentStore {

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

    public static CommentStore getInstance() {
      if (instance == null) {
        instance = new CommentStore(PersistentStorageAgent.getInstance());
      }
      return instance;
    }

    public Map<Comment, List<List<Comment>>> getAllCommentsInPost(UUID postId) {
        Map<Comment, List<List<Comment>>> commentInPost = new HashMap<>();
        for (Comment comment : commentList) {
            //add comment when the postId is the same as the given ID
            if (comment.getPostId() == postId) {
                // if it is the first comment of the post
                if (comment.getParentId() == null) {
                    commentInPost.put(comment, null);
                } else { //otherwise it is the reply of some other comments (have parents)
                    UUID parentId = comment.getParentId();
                    if (commentInPost.containsKey(parentId)) { //if it is the reply of the first comments
                        if (commentInPost.get(parentId) == null) { //then the reply becomes the list (first reply)
                            commentInPost.put(comment, new ArrayList<>()); //makes a new list
                            List<Comment> theList = new ArrayList<>();
                            theList.add(comment);
                            commentInPost.get(parentId).add(theList); //list within a list
                        } else { //other replies of the first comments
                            List<Comment> theList = new ArrayList<>();
                            theList.add(comment);
                            commentInPost.get(parentId).add(theList);
                        }
                    } else { //reply of a reply
                        for (Map.Entry<Comment, List<List<Comment>>> entry : commentInPost.entrySet()) {
                            for (List<Comment> each : entry.getValue()) {
                                if (each.get(each.size() - 1).getId() == parentId) {
                                    //the last elem of the list within a list should be the parent of the curr comment
                                    each.add(comment);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return commentInPost;
    }
}
