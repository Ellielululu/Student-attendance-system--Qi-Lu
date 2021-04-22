package model;

public class Course {
   private int id;
   private String name;
   private int teacherId;
   private String info;
   private String courseDate;
   private int selectedNum=0;
   private int maxNum=50;
   
public int getSelectedNum() {
	return selectedNum;
}
public void setSelectedNum(int selectedNum) {
	this.selectedNum = selectedNum;
}
public int getMaxNum() {
	return maxNum;
}
public void setMaxNum(int maxNum) {
	this.maxNum = maxNum;
}
public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public String getCourseDate() {
	return courseDate;
}
public void setCourseDate(String courseDate) {
	this.courseDate = courseDate;
}
public int getId() {
	return id;
}
public void setId(int id) {
	this.id = id;
}

public int getTeacherId() {
	return teacherId;
}
public void setTeacherId(int teacherId) {
	this.teacherId = teacherId;
}
public String getInfo() {
	return info;
}
public void setInfo(String info) {
	this.info = info;
}
   
}
