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
import baseOpera.CourseOpera;
import model.Course;
import model.Page;

public class CourseServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2348858394112650147L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
	       doPost(request,response);
	   }
	   public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
	      
	     String method=request.getParameter("method");
	    if("toCourseListView".equals(method)){
	    	try {
				request.getRequestDispatcher("view/courseList.jsp").forward(request,response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }else if("AddCourse".equals(method)){
	    	addCourse(request,response);
	    }else if("CourseList".equals(method)){
	    	getCourseList(request,response);
	    }
	 }
	private void getCourseList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name=request.getParameter("name");
		int teacherId=request.getParameter("teacherid")==null ? 0:Integer.parseInt(request.getParameter("teacherid").toString());
		
		Integer currentPage=request.getParameter("page") == null ? 1:Integer.parseInt(request.getParameter("page"));
		Integer pageSize=request.getParameter("rows")==null ? 999:Integer.parseInt(request.getParameter("rows"));
		Course course=new Course();
		course.setName(name);
		course.setTeacherId(teacherId);
		CourseOpera courseOpera=new CourseOpera();
		List<Course> courseList=courseOpera.getCourseList(course, new Page(currentPage,pageSize));
		int total=courseOpera.getClazzListTotal(course);
		courseOpera.closeCon();
		 Map<String,Object> ret=new HashMap<String,Object>();
		    ret.put("total", total);
		   ret.put("rows", courseList);
		    try {
		    	String from=request.getParameter("from");
		    	if("combox".equals(from)){
		    		response.getWriter().write(JSONArray.fromObject(courseList).toString());
		    		
		    	}else{
		    		
				response.getWriter().write(JSONObject.fromObject(ret).toString());}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	private void addCourse(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		String name=request.getParameter("name");
		int teacherId=Integer.parseInt(request.getParameter("teacherid").toString());
		int maxNum=Integer.parseInt(request.getParameter("maxnum").toString());
		String courseDate=request.getParameter("course_date");
		String info=request.getParameter("info");
		Course course=new Course();
		course.setName(name);
		course.setTeacherId(teacherId);
		course.setMaxNum(maxNum);
		course.setInfo(info);
		course.setCourseDate(courseDate);
		CourseOpera courseOpera=new CourseOpera();
		String msg="error";
		if(courseOpera.addCourse(course)){
			msg="success";
		}
		try {
			response.getWriter().write(msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
