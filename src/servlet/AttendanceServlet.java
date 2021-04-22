package servlet;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DateFormatUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import baseOpera.AttendanceOpera;
import baseOpera.CourseOpera;
import baseOpera.SelectedCourseOpera;
import model.Attendance;
import model.Course;
import model.Page;
import model.SelectedCourse;
import model.Student;

public class AttendanceServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
	       doPost(request,response);
	   }
	   public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
	      
	     String method=request.getParameter("method");
	    if("toAttendanceCourseListView".equals(method)){
	    	try {
				request.getRequestDispatcher("view/attendanceList.jsp").forward(request,response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }else if("AddAttendance".equals(method)){
	    	AddAttendance(request,response);
	    }else if("AttendanceList".equals(method)){
	    	attendanceList(request,response);
	    }else if("DeleteAttendance".equals(method)){
	    	deleteAttendance(request,response);
	    }else if("getStudentSelectedCourseList".equals(method)){
	    	getStudentSelectedCourseList(request,response);
	    }
	 }
	private void deleteAttendance(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		AttendanceOpera attendanceOpera = new AttendanceOpera();
		String msg = "success";
		if(!attendanceOpera.deleteAttendance(id)){
			msg = "error";
		}
		attendanceOpera.closeCon();
		response.getWriter().write(msg);
	}
	private void attendanceList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId=request.getParameter("studentid")==null ? 0:Integer.parseInt(request.getParameter("studentid").toString());
		int courseId=request.getParameter("courseid")==null ? 0:Integer.parseInt(request.getParameter("courseid").toString());
		Integer currentPage=request.getParameter("page") == null ? 1:Integer.parseInt(request.getParameter("page"));
		Integer pageSize=request.getParameter("rows")==null ? 999:Integer.parseInt(request.getParameter("rows"));
		Attendance attendance=new Attendance();
		int userType = Integer.parseInt(request.getSession().getAttribute("userType").toString());
		if(userType == 2){
			
			Student currentUser = (Student)request.getSession().getAttribute("user");
			studentId = currentUser.getId();
		}
		attendance.setCourseId(courseId);
		attendance.setStudentId(studentId);
		AttendanceOpera attendanceOpera=new AttendanceOpera();
		List<Attendance> attendanceList=attendanceOpera.getSelectedCourseList(attendance, new Page(currentPage,pageSize));
		int total=attendanceOpera.getAttendanceListTotal(attendance);
		attendanceOpera.closeCon();
		 Map<String,Object> ret=new HashMap<String,Object>();
		    ret.put("total", total);
		   ret.put("rows", attendanceList);
		    try {
		    	String from=request.getParameter("from");
		    	if("combox".equals(from)){
		    		response.getWriter().write(JSONArray.fromObject(attendanceList).toString());
		    		
		    	}else{
		    		
				response.getWriter().write(JSONObject.fromObject(ret).toString());}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	private void AddAttendance(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId=request.getParameter("studentid")==null ? 0:Integer.parseInt(request.getParameter("studentid").toString());
		int courseId=request.getParameter("courseid")==null ? 0:Integer.parseInt(request.getParameter("courseid").toString());
		String type=request.getParameter("type").toString();
		AttendanceOpera attendanceOpera=new AttendanceOpera();
		Attendance attendance=new Attendance();
		attendance.setCourseId(courseId);
		attendance.setStudentId(studentId);
		attendance.setType(type);
		attendance.setDate(DateFormatUtil.getFormatDate(new Date(), "dd-MM-yyyy"));
		String msg="success";
		if(attendanceOpera.isAttended(studentId, courseId, type,DateFormatUtil.getFormatDate(new Date(), "dd-MM-yyyy"))){
			msg="Already signed in, please do not repeat";
		}else if(!attendanceOpera.addAttendance(attendance)){
			msg="Internal system error";
		}
		try {
			response.getWriter().write(msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void getStudentSelectedCourseList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId=request.getParameter("student_id")==null ? 0:Integer.parseInt(request.getParameter("student_id").toString());
		SelectedCourse selectedCourse=new SelectedCourse();
		selectedCourse.setStudentId(studentId);
		SelectedCourseOpera selectedCourseOpera=new SelectedCourseOpera();
		List<SelectedCourse> selectedCourseList=selectedCourseOpera.getSelectedCourseList(selectedCourse, new Page(1,999));
		int total=selectedCourseOpera.getSelectedCourseListTotal(selectedCourse);
		selectedCourseOpera.closeCon();
		String courseId="";
		for(SelectedCourse sc: selectedCourseList){
			courseId+=sc.getCourseId()+",";
		}
		courseId=courseId.substring(0,courseId.length()-1);
		CourseOpera courseOpera=new CourseOpera();
		List<Course> courseList=courseOpera.getCourse(courseId);
		courseOpera.closeCon();	
		try {
			response.getWriter().write(JSONArray.fromObject(courseList).toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
