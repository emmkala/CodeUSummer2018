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
import java.text.ParseException;
import java.time.Instant;
import java.util.UUID;

import java.util.*;

enum OccupationType{
	STUDENT, EMPLOYED, UNEMPLOYED
}

/** Class representing a registered user. */
public class User {
	public enum Sex {
		MALE, FEMALE, UNKOWN
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
		this.setSex(Sex.UNKOWN);
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

	public Date getBirthday() {
		return birthday;
	}

	public String getBirthdayAsString() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/YYYY");
		return sdf.format(birthday);
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public String getDescription() {
		if(description == null) {
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
		
		if(valueArray[0].equals("STUDENT")) {
			Occupation out = new Occupation(
					valueArray[1],
					Integer.parseInt(valueArray[2])
			);
			return out;
		} else if(valueArray[1].equals("EMPLOYED")) {
			Occupation out = new Occupation(
					valueArray[0],
					valueArray[1]
			);
			return out;
		} else {
			Occupation out = new Occupation();
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
		private int schoolYear;
		private String school;
		private String position;
		private String employer;

		public Occupation(String school, int schoolYear){
			this.occupationType = OccupationType.STUDENT;
			this.school = school;
			this.schoolYear = schoolYear;
		}

		public Occupation(String employer, String position){
			this.occupationType = OccupationType.EMPLOYED;
			this.employer = employer;
			this.position = position;
		}
		
		public Occupation() {
			this.occupationType = OccupationType.UNEMPLOYED;
		}
		
		public String getOccupationType() {
			return occupationType.toString();
		}
		
		public String toString() {
			if(occupationType == OccupationType.STUDENT) {
				return yearName(schoolYear) + " at " + school;
			} else if(occupationType == OccupationType.EMPLOYED) {
				return position + " at " + employer;
			}
			return "Unemployed";
		}
		
		private String yearName(int year) {
			switch(year) {
				case 1:
					return "Freshman";
				case 2:
					return "Sophmore";
				case 3:
					return "Junior";
				case 4:
					return "Senior";
				default:
					return "Senior";
			}
		}

		public String storableValue() {
			if(occupationType == null) {
				return "null";
			}
			String out = "";
			
			out += occupationType.toString();
			
			out += ";";
			
			switch(occupationType) {
				case STUDENT:
					if(schoolYear != 0) {
						out += schoolYear;
					} else {
						out+=" ";
					}
					
					out += ";";
					
					if(school != null || school.trim() != "") {
						out += school;
					} else {
						out+=" ";
					}
					return out;

				case EMPLOYED:
					if(position != null || position.trim() != "") {
						out += position;
					} else {
						out+=" ";
					}

					out += ";";

					if(employer != null || employer.trim() != "") {
						out += employer;
					} else {
						out+=" ";
					}
					return out;
				default:
					return out;
			}
		}
	}
}
