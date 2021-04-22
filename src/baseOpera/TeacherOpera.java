package baseOpera;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.StringUtil;
import model.Page;
import model.Student;
import model.Teacher;

public class TeacherOpera extends baseOpera{
	public boolean addTeacher(Teacher teacher) {

		String sql = "insert into teacher (sn,name,lastName,password,clazz_id,gender) "
				+ "values('"+ teacher.getSn()+ "','"+ teacher.getname()+ "','"+ teacher.getLastName() + "'";
		sql += ",'" + teacher.getPassword() + "'," + teacher.getClazzId();
		sql += ",'" + teacher.getGender() + "')";

		return update(sql);
	}
	 public List<Teacher> getTeacherList(Teacher teacher, Page page ){
		  
		  List<Teacher> ret=new ArrayList<Teacher>();
		  String sql="select * from teacher";
		  if(!(StringUtil.isEmpty(teacher.getname())&&StringUtil.isEmpty(teacher.getLastName()))){
			  sql+="and name like '%"+ teacher.getname()+"%' '%"+teacher.getLastName()+"%'";
		  }
		  
		  if(teacher.getClazzId() != 0){
			  sql +=" and clazz_id = " + teacher.getClazzId();
		  }
		  
		  if(teacher.getId() !=0){
			  sql +=" and id = " + teacher.getId();
		  }
			
		  sql +=" limit "+ page.getStart() +","+ page.getPageSize();
		  ResultSet resultSet = query(sql.replaceFirst("and", "where"));
		  try {
			while(resultSet.next()){
				  Teacher t=new Teacher();
				  t.setId(resultSet.getInt("id"));
				  t.setClazzId(resultSet.getInt("clazz_id"));
				  t.setname(resultSet.getString("name"));
				  t.setLastName(resultSet.getString("lastName"));
				  t.setGender(resultSet.getString("gender"));
				  t.setPassword(resultSet.getString("password"));
				  t.setSn(resultSet.getString("sn"));
				  ret.add(t);
			  }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		  
		  return ret;
	  }
	 public int getTeacherListTotal(Teacher teacher){
		  
		  int total=0;
		  String sql="select count(*)as total from teacher ";
		  if(!(StringUtil.isEmpty(teacher.getname())&&StringUtil.isEmpty(teacher.getLastName()))){
			  sql+="and name like '%"+ teacher.getname()+"%' '%"+ teacher.getLastName()+"%'";
		  }
		  
		  if(teacher.getId() !=0){
			  sql +=" and id = " + teacher.getId();
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
	 public Teacher login(String name, String password){
	    	String sql = "select * from teacher where name = '" + name + "' and password = '" + password + "'";
	    	ResultSet resultSet = query(sql);
	    	try {
				if(resultSet.next()){
					Teacher teacher=new Teacher();
					teacher.setId(resultSet.getInt("id"));
					teacher.setname(resultSet.getString("name"));
					teacher.setPassword(resultSet.getString("password"));
					teacher.setClazzId(resultSet.getInt("clazz_id"));
					teacher.setGender(resultSet.getString("gender"));
					teacher.setSn(resultSet.getString("sn"));
					return teacher;
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	return null;
	    }
}

