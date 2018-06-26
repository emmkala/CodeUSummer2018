package codeu.model.data;

import java.util.UUID;

public class Comment {

    private final UUID id;
    private final UUID post;
    private final UUID parent;
    private final String content;

    public Comment(UUID id, UUID post, UUID parent, String content){
        this.id = id;
        this.post = post;
        this.parent = parent;
        this.content = content;
    }

    public UUID getId() { return id; }

    public String getContent() { return content; }

    public UUID getParentId() { return parent;}

    public UUID getPostId() { return post; }
}