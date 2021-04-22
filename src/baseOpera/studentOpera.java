package baseOpera;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.StringUtil;
import model.Clazz;
import model.Page;
import model.Student;
import model.admin;

public class studentOpera extends baseOpera {
	public boolean addStudent(Student student) {

		String sql = "insert into student(sn,name,lastName,password,clazz_id,gender) "
				+ "values('"+ student.getSn()+ "','"+ student.getname()+ "','"+ student.getLastName() + "'";
		sql += ",'" + student.getPassword() + "'," + student.getClazzId();
		sql += ",'" + student.getGender() + "')";

		return update(sql);
	}
	public boolean editStudent(Student student){
		
		
		
		String sql="update student set name = '" +student.getname()+"'";
		sql +=",gender= '"+ student.getGender()+"'";
		sql +=", clazz_id= " + student.getClazzId();
		sql +=" where id = " + student.getId();
		return update(sql);
	}
	
	
	 public List<Student> getStudentList(Student student, Page page ){
		  
		  List<Student> ret=new ArrayList<Student>();
		  String sql="select * from student ";
		  if(!(StringUtil.isEmpty(student.getname())&&StringUtil.isEmpty(student.getLastName()))){
			  sql+="and name like '%"+ student.getname()+"%' '%"+student.getLastName()+"%'";
		  }
		  
		  if(student.getClazzId() != 0){
			  sql +=" and clazz_id = " + student.getClazzId();
		  }
		 if(student.getId() !=0){
			 sql +=" and id = " + student.getId();
		 }
		  sql +=" limit "+ page.getStart() +","+ page.getPageSize();
		  ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		  try {
			while(resultSet.next()){
				  Student s=new Student();
				  s.setId(resultSet.getInt("id"));
				  s.setClazzId(resultSet.getInt("clazz_id"));
				  s.setname(resultSet.getString("name"));
				  s.setLastName(resultSet.getString("lastName"));
				  s.setGender(resultSet.getString("gender"));
				  s.setPassword(resultSet.getString("password"));
				  s.setSn(resultSet.getString("sn"));
				  ret.add(s);
			  }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  
		  return ret;
	  }
	 public boolean deleteStudent(String ids){
			
			
			
			String sql="delete from student where id in (" +ids+")";
			
			return update(sql);
		}
		
	public int getStudentListTotal(Student student){
		  
		  int total=0;
		  String sql="select count(*)as total from student ";
		  if(!(StringUtil.isEmpty(student.getname())&&StringUtil.isEmpty(student.getLastName()))){
			  sql+="and name like '%"+ student.getname()+"%' '%"+ student.getLastName()+"%'";
		  }
		  if(student.getId() !=0){
				 sql +=" and id = " + student.getId();
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
	public Student login(String name, String password){
    	String sql = "select * from student where name = '" + name + "' and password = '" + password + "'";
    	ResultSet resultSet = query(sql);
    	try {
			if(resultSet.next()){
				Student student=new Student();
				student.setId(resultSet.getInt("id"));
				student.setname(resultSet.getString("name"));
				student.setPassword(resultSet.getString("password"));
				student.setClazzId(resultSet.getInt("clazz_id"));
				student.setGender(resultSet.getString("gender"));
				student.setSn(resultSet.getString("sn"));
				return student;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return null;
    }
}
