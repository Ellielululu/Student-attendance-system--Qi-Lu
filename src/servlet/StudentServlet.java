package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import baseOpera.studentOpera;
import util.SnGenerateUtil;
import model.Page;
import model.Student;

public class StudentServlet extends HttpServlet {
  public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
      doPost(request,response);
  }
  public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
     String method=request.getParameter("method");
     if("toStudentListView".equals(method)){
    	 studentList(request,response);
     }else if("AddStudent".equals(method)){
    	 addStudent(request,response);
     }else if("StudentList".equals(method)){
    	 getStudentList(request,response);
     }else if("EditStudent".equals(method)){
    	 editStudent(request,response);
     }else if("DeleteStudent".equals(method)){
    	 deleteStudent(request,response);
     }
	}
private void deleteStudent(HttpServletRequest request,
		HttpServletResponse response) {
	// TODO Auto-generated method stub
	String[] ids=request.getParameterValues("ids[]");
    String idStr="";
	for(String id: ids){
    	idStr += id+ "," ;
    }
	idStr=idStr.substring(0,idStr.length()-1);
	studentOpera studentOpera=new studentOpera();
	if(studentOpera.deleteStudent(idStr)){
		try {
			response.getWriter().write("success");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			studentOpera.closeCon();
		}
	}
}
private void editStudent(HttpServletRequest request,
		HttpServletResponse response) {
	// TODO Auto-generated method stub
	String name=request.getParameter("name");
	String lastName=request.getParameter("lastName");
	int id=Integer.parseInt(request.getParameter("id"));
	String gender=request.getParameter("gender");
	int clazzId=Integer.parseInt(request.getParameter("clazzid"));
    Student student =new Student();
    student.setClazzId(clazzId);
    student.setname(name);
    student.setGender(gender);
    student.setLastName(lastName);
    student.setId(id);
    studentOpera studentOpera=new studentOpera();
    if(studentOpera.editStudent(student)){
    	try {
			response.getWriter().write("success");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
private void getStudentList(HttpServletRequest request,
		HttpServletResponse response) {
	// TODO Auto-generated method stub
	String name=request.getParameter("name");
	String lastName=request.getParameter("lastName");
	Integer currentPage=request.getParameter("page") == null ? 1:Integer.parseInt(request.getParameter("page"));
	Integer pageSize=request.getParameter("rows")==null ? 999:Integer.parseInt(request.getParameter("rows"));
	Integer clazz=request.getParameter("clazzid")==null ? 0:Integer.parseInt(request.getParameter("clazzid"));
    int userType=Integer.parseInt(request.getSession().getAttribute("userType").toString());
	Student student=new Student();
    student.setname(name);
    student.setLastName(lastName);
    student.setClazzId(clazz);
    if(userType== 2){
    	Student currentUser=(Student)request.getSession().getAttribute("user");
    	
    	student.setId(currentUser.getId());
    } 
    studentOpera studentOpera=new studentOpera();
    List<Student> clazzList=studentOpera.getStudentList(student,new Page(currentPage, pageSize));
    int total=studentOpera.getStudentListTotal(student);
    studentOpera.closeCon();
    response.setCharacterEncoding("UTF-8");
    Map<String,Object> ret=new HashMap<String,Object>();
    ret.put("total",total);
    ret.put("rows",clazzList);
    try{
    	String from=request.getParameter("from");
    	if("combox".equals(from)){
    		response.getWriter().write(JSONArray.fromObject(clazzList).toString());
    		
    	}else{
    		response.getWriter().write(JSONObject.fromObject(ret).toString());
    	}}catch(IOException e){
    		e.printStackTrace();
    	
    }
}
private void addStudent(HttpServletRequest request, HttpServletResponse response) {
	// TODO Auto-generated method stub
	String name=request.getParameter("name");
	String lastName=request.getParameter("lastName");
	String password=request.getParameter("password");
	String gender=request.getParameter("gender");
	int clazzId=Integer.parseInt(request.getParameter("clazzid"));
    Student student =new Student();
    student.setClazzId(clazzId);
    student.setname(name);
    student.setGender(gender);
    student.setLastName(lastName);
    student.setPassword(password);
    student.setSn(SnGenerateUtil.generateSn(clazzId));
    studentOpera studentOpera=new studentOpera();
    if(studentOpera.addStudent(student)){
    	try {
			response.getWriter().write("success");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			studentOpera.closeCon();
		}
    }
}
private void studentList(HttpServletRequest request,
		HttpServletResponse response) throws IOException {
	// TODO Auto-generated method stub
     try {
		request.getRequestDispatcher("view/studentList.jsp").forward(request, response);
	} catch (ServletException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	};
}
    
}

