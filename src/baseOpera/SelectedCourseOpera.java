package baseOpera;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Clazz;
import model.Course;
import model.Page;
import model.SelectedCourse;
import util.StringUtil;

public class SelectedCourseOpera extends baseOpera {
	public List<SelectedCourse> getSelectedCourseList(SelectedCourse selectedCourse, Page page ){
		  
		  List<SelectedCourse> ret=new ArrayList<SelectedCourse>();
		  String sql="select * from selected_course ";
		  if(selectedCourse.getStudentId()!=0){
			  sql+="and student_id ="+ selectedCourse.getStudentId();
		  }
		  if(selectedCourse.getCourseId()!=0){
			  sql+="and course_id ="+ selectedCourse.getCourseId();
		  }
		  sql +=" limit "+ page.getStart() +","+ page.getPageSize();
		  ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		  try {
			while(resultSet.next()){
				  SelectedCourse cl=new SelectedCourse();
				  cl.setId(resultSet.getInt("id"));
				  cl.setCourseId(resultSet.getInt("course_id"));
				  cl.setStudentId(resultSet.getInt("student_id"));
				
				  ret.add(cl);
			  }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  
		  return ret;
	  }
	public int getSelectedCourseListTotal(SelectedCourse selectedCourse){
		  
		  int total=0;
		  String sql="select count(*)as total from selected_course ";
		  if(selectedCourse.getStudentId()!=0){
			  sql+="and student_id ="+ selectedCourse.getStudentId();
		  }
		  if(selectedCourse.getCourseId()!=0){
			  sql+="and course_id ="+ selectedCourse.getCourseId();
		  }
		  
		  ResultSet resultSet = query(sql.replaceFirst("and", "where"));
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
	public boolean isSelected(int studentId, int courseId){
		boolean ret=false;
		String sql="select count(*) from selected_course where student_id=" + studentId+" and course_id ="+courseId;
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
	public boolean addSelectedCourse(SelectedCourse selectedCourse){
		  

		  String sql="insert into selected_course values(null,"+selectedCourse.getStudentId()+"',"+selectedCourse.getCourseId()+")";
		  
		  return update(sql);
	}
}
