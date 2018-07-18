// Copyright 2017 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package codeu.model.store.persistence;

import codeu.model.data.Conversation;
import codeu.model.data.Message;
import codeu.model.data.ProfileImage;
import codeu.model.data.User;
import codeu.model.data.Post;
import codeu.model.data.Comment;
import codeu.model.data.User.Sex;
import codeu.model.store.persistence.PersistentDataStoreException;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.SortDirection;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * This class handles all interactions with Google App Engine's Datastore service. On startup it
 * sets the state of the applications's data objects from the current contents of its Datastore. It
 * also performs writes of new of modified objects back to the Datastore.
 */
public class PersistentDataStore {
	// Handle to Google AppEngine's Datastore service.
	private DatastoreService datastore;

	/**
	 * Constructs a new PersistentDataStore and sets up its state to begin loading objects from the
	 * Datastore service.
	 */
	public PersistentDataStore() {
		datastore = DatastoreServiceFactory.getDatastoreService();
	}

	/**
	 * Loads all User objects from the Datastore service and returns them in a List.
	 *
	 * @throws PersistentDataStoreException if an error was detected during the load from the
	 *     Datastore service
	 */
	public List<User> loadUsers() throws PersistentDataStoreException {
		List<User> users = new ArrayList<>();

		// Retrieve all users from the datastore.
		Query query = new Query("chat-users");
		PreparedQuery results = datastore.prepare(query);

		for (Entity entity : results.asIterable()) {
			try {
				UUID uuid = UUID.fromString((String) entity.getProperty("uuid"));
				String userName = (String) entity.getProperty("username");
				String passwordHash = (String) entity.getProperty("password_hash");
				Instant creationTime = Instant.parse((String) entity.getProperty("creation_time"));
				User user = new User(uuid, userName, passwordHash, creationTime);


				//Newly implemented properties might not be set for old users, so you can only try to pull new values
				try {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Date birthday = sdf.parse((String) entity.getProperty("birthday"));
					user.setBirthday(birthday);
				} catch(Exception e) {
					//Do nothing
				}

				try {
					String description = (String) entity.getProperty("description");
					user.setDescription(description);
				} catch(Exception e) {
					//Do nothing
				}

				try {
					String occupationString = (String) entity.getProperty("occupation");
					user.setOccupation(user.parseOccupation(occupationString));
				} catch(Exception e) {
					//Do nothing
				}

				try {
					String sexString = (String) entity.getProperty("sex");
					user.setSex(Sex.valueOf(sexString));
				} catch(Exception e) {
					//Do nothing
				}

				try {
					String email = (String) entity.getProperty("email");
					user.setEmail(email);
				} catch(Exception e) {
					//Do nothing
				}

				try {
					String profileImageString = (String) entity.getProperty("profile_image");
					if(profileImageString != null && !profileImageString.trim().equals("")) {
						user.setProfileImage(new ProfileImage(profileImageString));
					} else {
						user.setProfileImage(ProfileImage.getDefaultImage(user.getSex()));
					}
				} catch(Exception e) {
					//Do nothing
				}


				users.add(user);
			} catch (Exception e) {
				// In a production environment, errors should be very rare. Errors which may
				// occur include network errors, Datastore service errors, authorization errors,
				// database entity definition mismatches, or service mismatches.
				throw new PersistentDataStoreException(e);
			}
		}

		return users;
	}

	/**
	 * Loads all Conversation objects from the Datastore service and returns them in a List, sorted in
	 * ascending order by creation time.
	 *
	 * @throws PersistentDataStoreException if an error was detected during the load from the
	 *     Datastore service
	 */
	public List<Conversation> loadConversations() throws PersistentDataStoreException {

		List<Conversation> conversations = new ArrayList<>();

		// Retrieve all conversations from the datastore.
		Query query = new Query("chat-conversations").addSort("creation_time", SortDirection.ASCENDING);
		PreparedQuery results = datastore.prepare(query);

		for (Entity entity : results.asIterable()) {
			try {
				UUID uuid = UUID.fromString((String) entity.getProperty("uuid"));
				UUID ownerUuid = UUID.fromString((String) entity.getProperty("owner_uuid"));
				String title = (String) entity.getProperty("title");
				Instant creationTime = Instant.parse((String) entity.getProperty("creation_time"));
				Conversation conversation = new Conversation(uuid, ownerUuid, title, creationTime);
				conversations.add(conversation);
			} catch (Exception e) {
				// In a production environment, errors should be very rare. Errors which may
				// occur include network errors, Datastore service errors, authorization errors,
				// database entity definition mismatches, or service mismatches.
				throw new PersistentDataStoreException(e);
			}
		}

		return conversations;
	}

	/**
	 * Loads all Message objects from the Datastore service and returns them in a List, sorted in
	 * ascending order by creation time.
	 *
	 * @throws PersistentDataStoreException if an error was detected during the load from the
	 *     Datastore service
	 */
	public List<Message> loadMessages() throws PersistentDataStoreException {

		List<Message> messages = new ArrayList<>();

		// Retrieve all messages from the datastore.
		Query query = new Query("chat-messages").addSort("creation_time", SortDirection.ASCENDING);
		PreparedQuery results = datastore.prepare(query);

		for (Entity entity : results.asIterable()) {
			try {
				UUID uuid = UUID.fromString((String) entity.getProperty("uuid"));
				UUID conversationUuid = UUID.fromString((String) entity.getProperty("conv_uuid"));
				UUID authorUuid = UUID.fromString((String) entity.getProperty("author_uuid"));
				Instant creationTime = Instant.parse((String) entity.getProperty("creation_time"));
				String content = (String) entity.getProperty("content");
				Message message = new Message(uuid, conversationUuid, authorUuid, content, creationTime);
				messages.add(message);
			} catch (Exception e) {
				// In a production environment, errors should be very rare. Errors which may
				// occur include network errors, Datastore service errors, authorization errors,
				// database entity definition mismatches, or service mismatches.
				throw new PersistentDataStoreException(e);
			}
		}

		return messages;
	}

	/** Write a User object to the Datastore service. */
	public void writeThrough(User user) {
		Entity userEntity = new Entity("chat-users", user.getId().toString());
		userEntity.setProperty("uuid", user.getId().toString());
		userEntity.setProperty("username", user.getName());
		userEntity.setProperty("password_hash", user.getPasswordHash());
		userEntity.setProperty("creation_time", user.getCreationTime().toString());
		userEntity.setProperty("birthday", user.getBirthday(new SimpleDateFormat("yyyy-MM-dd")));
		userEntity.setProperty("description", user.getDescription());
		//userEntity.setProperty("sex", user.getSex().toString());
		userEntity.setProperty("email", user.getEmail());
		userEntity.setProperty("occupation", user.getOccupation().storableValue());
		userEntity.setProperty("profile_image", user.getProfileImage().getURL());
		datastore.put(userEntity);
	}

	/** Write a Message object to the Datastore service. */
	public void writeThrough(Message message) {
		Entity messageEntity = new Entity("chat-messages", message.getId().toString());
		messageEntity.setProperty("uuid", message.getId().toString());
		messageEntity.setProperty("conv_uuid", message.getConversationId().toString());
		messageEntity.setProperty("author_uuid", message.getAuthorId().toString());
		messageEntity.setProperty("content", message.getContent());
		messageEntity.setProperty("creation_time", message.getCreationTime().toString());
		datastore.put(messageEntity);
	}

	/** Write a Conversation object to the Datastore service. */
	public void writeThrough(Conversation conversation) {
		Entity conversationEntity = new Entity("chat-conversations", conversation.getId().toString());
		conversationEntity.setProperty("uuid", conversation.getId().toString());
		conversationEntity.setProperty("owner_uuid", conversation.getOwnerId().toString());
		conversationEntity.setProperty("title", conversation.getTitle());
		conversationEntity.setProperty("creation_time", conversation.getCreationTime().toString());
		datastore.put(conversationEntity);
	}

	public void clearData() {
		// Retrieve all users from the datastore.
		Query chatUsers = new Query("chat-users");
		PreparedQuery results = datastore.prepare(chatUsers);
		for(Entity user: results.asIterable()) {
			datastore.delete(user.getKey());
		}

		Query conversations = new Query("chat-conversations");
		results = datastore.prepare(conversations);
		for(Entity conversation: results.asIterable()) {
			datastore.delete(conversation.getKey());
		}

		Query messages = new Query("chat-messages");
		results = datastore.prepare(messages);
		for(Entity message: results.asIterable()) {
			datastore.delete(message.getKey());
		}
	}

  public List<Post> loadPosts() throws PersistentDataStoreException {
        List<Post> posts = new ArrayList<>();
        Query query = new Query("posts").addSort("creation_time", SortDirection.ASCENDING);
        PreparedQuery results = datastore.prepare(query);

        for (Entity entity : results.asIterable()) {
            try {
                UUID uuid = UUID.fromString((String) entity.getProperty("uuid"));
                UUID ownerUuid = UUID.fromString((String) entity.getProperty("owner_uuid"));
                Instant creationTime = Instant.parse((String) entity.getProperty("creation_time"));
                String content = (String) entity.getProperty("content");
                Post post = new Post(uuid, ownerUuid, creationTime, content);
                posts.add(post);
            } catch (Exception e) {
                throw new PersistentDataStoreException(e);
            }
        }
        return posts;
  }

  public List<Comment> loadComments() throws PersistentDataStoreException {
        List<Comment> comments = new ArrayList<>();
        Query query = new Query("comments");
        PreparedQuery results = datastore.prepare(query);

        for (Entity entity : results.asIterable()) {
            try {
                UUID uuid = UUID.fromString((String) entity.getProperty("uuid"));
                UUID ownerUuid = UUID.fromString((String) entity.getProperty("owner_uuid"));
                Instant creationTime = Instant.parse((String) entity.getProperty("creation_time"));
                UUID postUuid = UUID.fromString((String) entity.getProperty("post_uuid"));
                UUID parentUuid = UUID.fromString((String) entity.getProperty("parent_uuid"));
                String content = (String) entity.getProperty("content");
                Comment comment = new Comment(uuid, ownerUuid, creationTime, postUuid, parentUuid, content);
                comments.add(comment);
            } catch (Exception e) {
                throw new PersistentDataStoreException(e);
            }
        }
        return comments;
  }

  public void writeThrough(Post post){
      Entity postEntity = new Entity("posts", post.getId().toString());
      postEntity.setProperty("uuid", post.getId().toString());
      postEntity.setProperty("owner_uuid", post.getOwnerId().toString());
      postEntity.setProperty("creation_time", post.getCreationTime().toString());
      postEntity.setProperty("content", post.getContent());
      datastore.put(postEntity);
  }

  public void writeThrough(Comment comment){
      Entity commentEntity = new Entity("comments", comment.getId().toString());
      commentEntity.setProperty("uuid", comment.getId().toString());
      commentEntity.setProperty("owner_uuid", comment.getOwnerId().toString());
      commentEntity.setProperty("creation_time", comment.getCreationTime().toString());
      commentEntity.setProperty("post_uuid", comment.getPostId().toString());
      commentEntity.setProperty("parent_uuid", comment.getParentId().toString());
      commentEntity.setProperty("content", comment.getContent());
      datastore.put(commentEntity);
  }

  public List<Post> getPostsForUser(String userId){
	  Filter filter = new FilterPredicate("owner_uuid", FilterOperator.EQUAL, userId);
	  Query query = new Query("posts").setFilter(filter);
	  PreparedQuery pq = datastore.prepare(query);

	  ArrayList<Post> out = new ArrayList<Post>();
	  for(Entity ent: pq.asIterable()) {
		  UUID uuid = UUID.fromString((String) ent.getProperty("uuid"));
		  UUID ownerUuid = UUID.fromString((String) ent.getProperty("owner_uuid"));
		  Instant creationTime = Instant.parse((String) ent.getProperty("creation_time"));
		  out.add(new Post(uuid, ownerUuid, creationTime, (String) ent.getProperty("content")));
	  }

	  return out;
  }

  public List<Comment> getCommentsForPost(String postId){
	  Filter filter = new FilterPredicate("post_uuid", FilterOperator.EQUAL, postId);
	  Query query = new Query("comments").setFilter(filter);
	  PreparedQuery pq = datastore.prepare(query);

	  ArrayList<Comment> out = new ArrayList<Comment>();
	  for(Entity ent: pq.asIterable()) {
		  UUID uuid = UUID.fromString((String) ent.getProperty("uuid"));
		  UUID ownerUuid = UUID.fromString((String) ent.getProperty("owner_uuid"));
		  Instant creationTime = Instant.parse((String) ent.getProperty("creation_time"));
		  UUID postUuid = UUID.fromString((String) ent.getProperty("post_uuid"));
		  UUID parentUuid = UUID.fromString((String) ent.getProperty("parent_uuid"));
		  out.add(new Comment(uuid, ownerUuid, creationTime, postUuid, parentUuid, (String) ent.getProperty("content")));
	  }

	  return out;
  	}
  //public void clearData() { }

}
