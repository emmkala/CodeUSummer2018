package codeu.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

import codeu.model.data.ProfileImage;
import codeu.model.data.User;
import codeu.model.store.basic.UserStore;

public class UploadServlet extends HttpServlet{
	
	private BlobstoreService blobstoreService;
	private UserStore userStore;
	
	@Override
	public void init() throws ServletException {
		super.init();
		blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
		userStore = UserStore.getInstance();
	}
	
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String currentUserName = (String) request.getSession().getAttribute("user");
		User currentUser = userStore.getUser(currentUserName);
		
		Map<String, List<BlobKey>>blobMap = blobstoreService.getUploads(request);
		List<BlobKey> imageBlobs = blobMap.get("profileImage");
		
		currentUser.setProfileImage(new ProfileImage(imageBlobs));
		
		response.sendRedirect("/user/"+currentUserName);
	}
}
