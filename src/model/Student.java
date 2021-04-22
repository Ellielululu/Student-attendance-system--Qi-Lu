package model;

public class Student {
   private int id;
   private String sn;
   private int clazzId;
   private String gender="Male";
   private String name;
   private String lastName;
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
public String getname() {
	return name;
}
public void setname(String name) {
	this.name = name;
}
public String getLastName() {
	return lastName;
}
public void setLastName(String lastName) {
	this.lastName = lastName;
}
public String getPassword() {
	return password;
}
public void setPassword(String password) {
	this.password = password;
}
   
}
