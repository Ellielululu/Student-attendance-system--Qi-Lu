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
import model.Page;
import model.Student;
import model.Teacher;
import util.SnGenerateUtil;
import baseOpera.TeacherOpera;


public class TeacherServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7237458321424824609L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
	      doPost(request,response);
	  }
	  public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
	     String method=request.getParameter("method");
	     if("toTeacherListView".equals(method)){
	    	 teacherList(request,response);
	     }else if("AddTeacher".equals(method)){
	    	 addTeacher(request,response);
	     }else if("TeacherList".equals(method)){
	    	 getTeacherList(request,response);
	     }else if("EditTeacher".equals(method)){
	    	 editTeacher(request,response);
	     }else if("DeleteTeacher".equals(method)){
	    	 deleteTeacher(request,response);
	     }
}
	private void deleteTeacher(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		
		
	}
	private void editTeacher(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		
	}
	private void getTeacherList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name=request.getParameter("name");
		String lastName=request.getParameter("lastName");
		Integer currentPage=request.getParameter("page") == null ? 1:Integer.parseInt(request.getParameter("page"));
		Integer pageSize=request.getParameter("rows")==null ? 999:Integer.parseInt(request.getParameter("rows"));
		Integer clazz=request.getParameter("clazzid")==null ? 0:Integer.parseInt(request.getParameter("clazzid"));
		int userType=Integer.parseInt(request.getSession().getAttribute("userType").toString());
	    
		Teacher teacher=new Teacher();
	    teacher.setname(name);
	    teacher.setLastName(lastName);
	    teacher.setClazzId(clazz);
	    if(userType== 3){
	    	Teacher currentUser=(Teacher)request.getSession().getAttribute("user");
	    	
	    	teacher.setId(currentUser.getId());
	    } 
	   
	    
	    TeacherOpera teacherOpera=new TeacherOpera();
	    List<Teacher> teacherList=teacherOpera.getTeacherList(teacher,new Page(currentPage, pageSize));
	    int total=teacherOpera.getTeacherListTotal(teacher);
	    teacherOpera.closeCon();
	    response.setCharacterEncoding("UTF-8");
	    Map<String,Object> ret=new HashMap<String,Object>();
	    ret.put("total",total);
	    ret.put("rows",teacherList);
	    try{
	    	String from=request.getParameter("from");
	    	if("combox".equals(from)){
	    		response.getWriter().write(JSONArray.fromObject(teacherList).toString());
	    		
	    	}else{
	    		response.getWriter().write(JSONObject.fromObject(ret).toString());
	    	}}catch(IOException e){
	    		e.printStackTrace();
	    	
	    }
	}
	private void addTeacher(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		String name=request.getParameter("name");
		String lastName=request.getParameter("lastName");
		String password=request.getParameter("password");
		String gender=request.getParameter("gender");
		int clazzId=Integer.parseInt(request.getParameter("clazzid"));
	    Teacher teacher =new Teacher();
	    teacher.setClazzId(clazzId);
	    teacher.setname(name);
	    teacher.setGender(gender);
	    teacher.setLastName(lastName);
	    teacher.setPassword(password);
	    teacher.setSn(SnGenerateUtil.generateTeacherSn(clazzId));
	    TeacherOpera teacherOpera=new TeacherOpera();
	    if(teacherOpera.addTeacher(teacher)){
	    	try {
				response.getWriter().write("success");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				teacherOpera.closeCon();
			}
	    }
	}
	private void teacherList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		try {
			request.getRequestDispatcher("view/teacherList.jsp").forward(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
