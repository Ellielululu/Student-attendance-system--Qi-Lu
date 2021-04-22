package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Page;
import model.SelectedCourse;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import baseOpera.CourseOpera;
import baseOpera.SelectedCourseOpera;

public class SelectedCourseServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8485894314154366083L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
	       doPost(request,response);
	   }
	   public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
	      
	     String method=request.getParameter("method");
	    if("toSelectedCourseListView".equals(method)){
	    	try {
				request.getRequestDispatcher("view/selectedCourseList.jsp").forward(request,response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }else if("AddSelectedCourse".equals(method)){
	    	addSelectedCourse(request,response);
	    }else if("SelectedCourseList".equals(method)){
	    	getSelectedCourseList(request,response);
	    }
	 }

	private void addSelectedCourse(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// TODO Auto-generated method stub
		int studentId=request.getParameter("studentid")==null ? 0:Integer.parseInt(request.getParameter("studentid").toString());
		int courseId=request.getParameter("courseid")==null ? 0:Integer.parseInt(request.getParameter("courseid").toString());
	    CourseOpera courseOpera= new CourseOpera();
	    String msg="success";
	    if(courseOpera.isFull(courseId)){
	    	msg="courseFull";
	    	response.getWriter().write(msg);
	    	courseOpera.closeCon();
	    	return;
	    }
	    SelectedCourseOpera selectedCourseOpera=new SelectedCourseOpera();
	    if(selectedCourseOpera.isSelected(studentId, courseId)){
	    	msg="courseSelected";
	    	response.getWriter().write(msg);
	    	selectedCourseOpera.closeCon();
	    	return;
	    }
	    SelectedCourse selectedCourse=new SelectedCourse();
	    selectedCourse.setStudentId(studentId);
	    selectedCourse.setCourseId(courseId);
	    if(selectedCourseOpera.addSelectedCourse(selectedCourse)){
	    	msg="success";
	    }
	    courseOpera.updateCourseSelectedNum(courseId, 1);
	    courseOpera.closeCon();
	    selectedCourseOpera.closeCon();
	    response.getWriter().write(msg); 
	   
	}
	private void getSelectedCourseList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId=request.getParameter("studentid")==null ? 0:Integer.parseInt(request.getParameter("studentid").toString());
		int courseId=request.getParameter("courseid")==null ? 0:Integer.parseInt(request.getParameter("courseid").toString());
		Integer currentPage=request.getParameter("page") == null ? 1:Integer.parseInt(request.getParameter("page"));
		Integer pageSize=request.getParameter("rows")==null ? 999:Integer.parseInt(request.getParameter("rows"));
		SelectedCourse selectedCourse=new SelectedCourse();
		selectedCourse.setCourseId(courseId);
		selectedCourse.setStudentId(studentId);
		SelectedCourseOpera selectedCourseOpera=new SelectedCourseOpera();
		List<SelectedCourse> courseList=selectedCourseOpera.getSelectedCourseList(selectedCourse, new Page(currentPage,pageSize));
		int total=selectedCourseOpera.getSelectedCourseListTotal(selectedCourse);
		selectedCourseOpera.closeCon();
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
}
