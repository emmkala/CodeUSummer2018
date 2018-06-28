package codeu.model.data;

import java.util.List;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;

import codeu.model.data.User.Sex;

public class ProfileImage {
	private static final ProfileImage defaultMale = new ProfileImage("../blankManFace.jpg");
	private static final ProfileImage defaultFemale = new ProfileImage("../blankWomanFace.jpg");
	
	private String imageURL;
	
	public ProfileImage(List<BlobKey> imageKeys) {
		ImagesService imageServices = ImagesServiceFactory.getImagesService();
		ServingUrlOptions servingUrlOptions = ServingUrlOptions.Builder.withBlobKey(imageKeys.get(0));
		imageURL = imageServices.getServingUrl(servingUrlOptions);
	}
	
	public ProfileImage(String URL) {
		imageURL = URL;
	}
	
	public String getURL() {
		return imageURL;
	}
	
	static ProfileImage getDefaultImage(Sex sex) {
		if(sex == Sex.FEMALE) {
			return defaultFemale;
		}
		return defaultMale;
	}
}
