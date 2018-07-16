package codeu.model.data;

import java.util.UUID;
import java.time.Instant;
import java.util.List;

public class Comment {

    private final UUID id;
    private final UUID ownerId;
    private final Instant creationTime;
    private final UUID post;
    private final UUID parent;
    private final String content;
    private List<Comment> children = new ArrayList<>();

    public Comment(UUID id, UUID ownerId, Instant creationTime, UUID post, UUID parent, String content){
        this.id = id;
        this.ownerId = ownerId;
        this.creationTime = creationTime;
        this.post = post;
        this.parent = parent;
        this.content = content;
    }

    public UUID getId() { return id; }

    public String getContent() { return content; }

    public UUID getParentId() { return parent;}

    public UUID getPostId() { return post; }

    public UUID getOwnerId() { return ownerId; }

    public Instant getCreationTime() { return creationTime; }

    public void setChildren(List<Comment> children) {this.children = children;}

    public List<Comment> getChildren() {return children;}
}