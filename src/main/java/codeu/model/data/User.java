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

package codeu.model.data;

import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.UUID;

import java.util.*;

/** Class representing a registered user. */
public class User {
	public enum Sex {
		MALE, FEMALE
	}

	public enum OccupationType{
		STUDENT, EMPLOYED, UNEMPLOYED
	}
	
	Set<String> admin = new HashSet<>(Arrays.asList("anAdmin", "Admin1", "Admin2","Hazim"));
	
	private final UUID id;
	private final String name;
	private final String passwordHash;
	private final Instant creation;
	private Date birthday;
	private String description;
	private Occupation occupation;
	private ProfileImage profileImage;
	private Sex sex;
	private String email;

	/**
	 * Constructs a new User.
	 *
	 * @param id the ID of this User
	 * @param name the username of this User
	 * @param passwordHash the password hash of this User
	 * @param creation the creation time of this User
	 */

	public User(UUID id, String name, String passwordHash, Instant creation) {
		this.id = id;
		this.name = name;
		this.passwordHash = passwordHash;
		this.creation = creation;
	}

	/** Returns the ID of this User. */
	public UUID getId() {
		return id;
	}

	/** Returns the username of this User. */
	public String getName() {
		return name;
	}

	/** Returns the password hash of this User. */
	public String getPasswordHash() {
		return passwordHash;
	}

	/** Returns the creation time of this User. */
	public Instant getCreationTime() {
		return creation;
	}

	public boolean checkAdmin() {
		return admin.contains(name);
	}

	public String getBirthday(SimpleDateFormat sdf) {
		if(birthday != null) {
			return sdf.format(birthday);
		} 
		return "Birthday not set";
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public String getDescription() {
		if(description == null || description.trim().equals("")) {
			return "Description not set";
		}
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Occupation getOccupation() {
		if(occupation == null) {
			return new Occupation();
		}
		return occupation;
	}

	public void setOccupation(Occupation occupation) {
		this.occupation = occupation;
	}
	
	public Occupation parseOccupation(String occupationString) {
		if(occupationString.equals("null")) {
			return null;
		}
		
		String[] valueArray = occupationString.split(";");
		for(String value : valueArray) {
			while(value.indexOf(-1) != -1) {
				value = value.substring(0,value.indexOf(";")) + value.substring(value.indexOf(";")+1);
			}
		}
		
		if(valueArray[0].equals("UNEMPLOYED")) {
			Occupation out = new Occupation();
			return out;
		} else {
			Occupation out = new Occupation(
					valueArray[0],
					valueArray[1]
			);
			return out;
		}
	}
	
	public ProfileImage getProfileImage() {
		if(profileImage == null) {
			return ProfileImage.getDefaultImage(sex);
		}
		return profileImage;
	}

	public void setProfileImage(ProfileImage profileImage) {
		this.profileImage = profileImage;
	}

	public Sex getSex() {
		return sex;
	}

	public void setSex(Sex sex) {
		this.sex = sex;
	}

	public String getEmail() {
		if(email == null) {
			return "Email not set";
		}
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	
	//Inner class
	public class Occupation {
		private OccupationType occupationType;
		private String f1;
		private String f2;

		public Occupation(String f1, String f2){
			this.occupationType = OccupationType.EMPLOYED;
			this.f1 = f1;
			this.f2 = f2;
		}
		
		public Occupation() {
			this.occupationType = OccupationType.UNEMPLOYED;
		}
		
		public OccupationType getOccupationType() {
			return occupationType;
		}
		
		public String getf1() {
			return f1;
		}

		public String getf2() {
			return f2;
		}
		
		public String toString() {
			if(occupationType == OccupationType.UNEMPLOYED && f1 != null && f2 != null) {
				return f1 + " at " + f2;
			}
			return "Unemployed";

		}
		
		public String storableValue() {
			if(occupationType == null) {
				return "null";
			}
			
			String out = "";
			
			out += occupationType.toString();
			
			out += ";";
			
			if(occupationType == OccupationType.STUDENT || occupationType == OccupationType.EMPLOYED) {
				out += f1 + ";" + f2;
			}
			
			return out;
		}
	}
}
