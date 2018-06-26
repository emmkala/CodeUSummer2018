package codeu.model.data;

import java.time.Instant;
import java.util.UUID;

public class Post{
    private final UUID id;
    private final UUID ownerId;
    private final Instant creation;
    private final String content;

    public Post(UUID id, UUID owner, Instant creation, String content){
        this.id = id;
        this.ownerId = owner;
        this.creation = creation;
        this.content = content;
    }

    public UUID getId() {
        return id;
    }

    public UUID getOwnerId() {return ownerId;}

    public Instant getCreationTime() { return creation; }

    public String getContent() { return content; }
}