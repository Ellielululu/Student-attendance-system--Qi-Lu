package model;

public class Teacher {
  private int id;
  private String sn;
  private String name;
  private String lastName;
  private String gender;
  private int clazzId;
  private String password;
public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}
public String getSn() {
	return sn;
}
public void setSn(String sn) {
	this.sn = sn;
}
public String getname() {
	return name;
}
public void setname(String firstName) {
	this.name = firstName;
}
public String getLastName() {
	return lastName;
}
public void setLastName(String lastName) {
	this.lastName = lastName;
}

public int getClazzId() {
	return clazzId;
}
public void setClazzId(int clazzId) {
	this.clazzId = clazzId;
}
public String getGender() {
	return gender;
}
public void setGender(String gender) {
	this.gender = gender;
}

public String getPassword() {
	return password;
}
public void setPassword(String password) {
	this.password = password;
}
  
}
