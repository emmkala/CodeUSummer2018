package codeu.model.store.basic;

import codeu.model.data.Post;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import codeu.model.store.persistence.PersistentStorageAgent;

public class PostStore{

    private static PostStore instance;

    public static PostStore getInstance() {
        if (instance == null) {
            instance = new PostStore (PersistentStorageAgent.getInstance());
        }
        return instance;
    }

    public static PostStore getTestInstance(PersistentStorageAgent persistentStorageAgent) {
        return new PostStore(persistentStorageAgent);
    }

    private PersistentStorageAgent persistentStorageAgent;

    private List<Post> postList;

    private PostStore(PersistentStorageAgent persistentStorageAgent) {
        this.persistentStorageAgent = persistentStorageAgent;
        postList = new ArrayList<>();
    }

    public void setPosts(List<Post> postList) {
        this.postList = postList;
    }

    public List<Post> getAllPosts() {
        return postList;
    }

    public void addPost(Post post) {
        postList.add(post);
        persistentStorageAgent.writeThrough(post);
    }

    public List<Post> getPostsByUserID(String userID) {
      return persistentStorageAgent.getPostsForUser(userID);
    }

}
