package baseOpera;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.StringUtil;
import model.Clazz;
import model.Course;
import model.Page;

public class CourseOpera extends baseOpera {
	public boolean addCourse(Course course){
		  

		  String sql="insert into course values(null,'"+course.getName()+"',"+course.getTeacherId()+",'"+course.getCourseDate()+"',0,"+course.getMaxNum()+",'"+course.getInfo()+"') ";
		  
		  return update(sql);
	}
	 public List<Course> getCourseList(Course course, Page page ){
		  
		  List<Course> ret=new ArrayList<Course>();
		  String sql="select * from course ";
		  if(!StringUtil.isEmpty(course.getName())){
			  sql+="and name like '%"+ course.getName()+"%'";
		  }
		  if(course.getTeacherId()!=0){
			  sql+="and teacher_id ="+ course.getTeacherId()+"";
		  }
		  sql +=" limit "+ page.getStart() +","+ page.getPageSize();
		  ResultSet resultSet = query(sql.replaceFirst("and","where"));
		  try {
			while(resultSet.next()){
				  Course cl=new Course();
				  cl.setId(resultSet.getInt("id"));
				  cl.setName(resultSet.getString("name"));
				  cl.setTeacherId(resultSet.getInt("teacher_id"));
				  cl.setInfo(resultSet.getString("info"));
				  cl.setCourseDate(resultSet.getString("course_date"));
				  cl.setSelectedNum(resultSet.getInt("selected_num"));
				  cl.setMaxNum(resultSet.getInt("max_num"));
				  ret.add(cl);
			  }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  
		  return ret;
	  }
	 public int getClazzListTotal(Course course){
		  
		  int total=0;
		  String sql="select count(*)as total from course ";
		  if(!StringUtil.isEmpty(course.getName())){
			  sql+="and name like '%"+ course.getName()+"%'";
		  }
		  if(course.getTeacherId()!=0){
			  sql+="and teacher_id ="+ course.getTeacherId()+"";
		  }
		  
		  ResultSet resultSet = query(sql.replaceFirst("and","where"));
		  try {
			while(resultSet.next()){
				 
				  total=resultSet.getInt("total");
				 
				
			  }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  
		  return total;
	  }
	 public boolean isFull(int courseId){
		 boolean ret=false;
		 String sql="select * from course where selected_num >= max_num and id=1 " + courseId;
		 ResultSet query=query(sql);
		 try {
			if(query.next()){
				return true;
			 }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 return ret;
	 }
	 public void updateCourseSelectedNum(int courseId,int num){
		 String sql ="";
		 if(num>0){
		 sql="update course set selected_num= selected_num +" + num +"where id=" +courseId;
		 }else{
			 sql="update course set selected_num= selected_num -" + Math.abs(num) +"where id=" +courseId;
		 }
		 update(sql);
		 }
	public List<Course> getCourse(String ids){
		List<Course> ret=new ArrayList<Course>();
		String sql="select * from course where id in("+ids+")";
		ResultSet query=query(sql);
		try {
			while (query.next()){
				  Course cl=new Course();
				  cl.setId(query.getInt("id"));
				  cl.setName(query.getString("name"));
				  cl.setTeacherId(query.getInt("teacher_id"));
				  cl.setInfo(query.getString("info"));
				  cl.setCourseDate(query.getString("course_date"));
				  cl.setSelectedNum(query.getInt("selected_num"));
				  cl.setMaxNum(query.getInt("max_num"));
				  ret.add(cl);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ret;
	}
}
