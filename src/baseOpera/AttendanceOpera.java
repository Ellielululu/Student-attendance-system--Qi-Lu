package baseOpera;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Attendance;
import model.Page;



public class AttendanceOpera extends baseOpera {
	public boolean addAttendance(Attendance attendance){
		  

		  String sql="insert into attendance values(null,"+attendance.getCourseId()+","+attendance.getStudentId()+",'"+attendance.getType()+"','"+attendance.getDate()+"')";
		  
		  return update(sql);
	}
	public boolean isAttended(int studentId, int courseId,String type,String date){
		boolean ret=false;
		String sql="select * from attendance where student_id=" + studentId+" and course_id ="+courseId+" and type = '" + type +"' and date = '" + date + "'";
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
	public List<Attendance> getSelectedCourseList(Attendance attendance, Page page ){
		  
		  List<Attendance> ret=new ArrayList<Attendance>();
		  String sql="select * from attendance ";
		  if(attendance.getStudentId()!=0){
			  sql+=" and student_id ="+ attendance.getStudentId();
		  }
		  if(attendance.getCourseId()!=0){
			  sql+=" and course_id ="+ attendance.getCourseId();
		  }
		  sql +=" limit "+ page.getStart() +","+ page.getPageSize();
		  ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		  try {
			while(resultSet.next()){
				  Attendance a=new Attendance();
				  a.setId(resultSet.getInt("id"));
				  a.setCourseId(resultSet.getInt("course_id"));
				  a.setStudentId(resultSet.getInt("student_id"));
				  a.setType(resultSet.getString("type"));
				  a.setDate(resultSet.getString("date"));
				  ret.add(a);
			  }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  
		  return ret;
	  }
	public int getAttendanceListTotal(Attendance attendance){
		  
		  int total=0;
		  String sql="select count(*)as total from attendance ";
		  if(attendance.getStudentId()!=0){
			  sql+=" and student_id ="+ attendance.getStudentId();
		  }
		  if(attendance.getCourseId()!=0){
			  sql+=" and course_id ="+ attendance.getCourseId();
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
	public boolean deleteAttendance(int id){
		String sql = "delete from attendance where id = " + id;
		return update(sql);
	}
}
