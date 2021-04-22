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
import baseOpera.LeaveOpera;
import model.Leave;
import model.Page;
import model.Student;

public class LeaveServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
	       doPost(request,response);
	   }
	   public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
	      
	     String method=request.getParameter("method");
	    if("toLeaveCourseListView".equals(method)){
	    	try {
				request.getRequestDispatcher("view/LeaveList.jsp").forward(request,response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }else if("AddLeave".equals(method)){
	    	addLeave(request,response);
	    }else if("CheckLeave".equals(method)){
			checkLeave(request,response);
		}else if("LeaveList".equals(method)){
	    	getLeaveList(request,response);
	    }else if("DeleteLeave".equals(method)){
			deleteLeave(request,response);
		}
	 }
	
	private void deleteLeave(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		LeaveOpera leaveOpera = new LeaveOpera();
		String msg = "success";
		if(!leaveOpera.deleteLeave(id)){
			msg = "error";
		}
		try {
			response.getWriter().write(msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void checkLeave(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId = Integer.parseInt(request.getParameter("studentid"));
		int id = Integer.parseInt(request.getParameter("id"));
		int status = Integer.parseInt(request.getParameter("status"));
		String info = request.getParameter("info");
		String remark = request.getParameter("remark");
		Leave leave = new Leave();
		leave.setStudentId(studentId);
		leave.setInfo(info);
		leave.setRemark(remark);
		leave.setStatus(status);
		leave.setId(id);
		LeaveOpera leaveOpera = new LeaveOpera();
		String msg = "error";
		if(leaveOpera.editLeave(leave)){
			msg = "success";
		}
		try {
			response.getWriter().write(msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			leaveOpera.closeCon();
		}
	}
	private void getLeaveList(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId = request.getParameter("studentid") == null ? 0 : Integer.parseInt(request.getParameter("studentid").toString());
		Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
		Integer pageSize = request.getParameter("rows") == null ? 999 : Integer.parseInt(request.getParameter("rows"));
		Leave leave = new Leave();
	
		int userType = Integer.parseInt(request.getSession().getAttribute("userType").toString());
		if(userType == 2){
			
			Student currentUser = (Student)request.getSession().getAttribute("user");
			studentId = currentUser.getId();
		}
		leave.setStudentId(studentId);
		LeaveOpera leaveOpera = new LeaveOpera();
		List<Leave> leaveList = leaveOpera.getLeaveList(leave, new Page(currentPage, pageSize));
		int total = leaveOpera.getLeaveListTotal(leave);
		leaveOpera.closeCon();
	
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("total", total);
		ret.put("rows", leaveList);
		try {
			String from = request.getParameter("from");
			if("combox".equals(from)){
				response.getWriter().write(JSONArray.fromObject(leaveList).toString());
			}else{
				response.getWriter().write(JSONObject.fromObject(ret).toString());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void addLeave(HttpServletRequest request,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		int studentId = Integer.parseInt(request.getParameter("studentid"));
		String info = request.getParameter("info");
		Leave leave = new Leave();
		leave.setStudentId(studentId);
		leave.setInfo(info);
		leave.setRemark("");
		LeaveOpera leaveOpera = new LeaveOpera();
		String msg = "error";
		if(leaveOpera.addLeave(leave)){
			msg = "success";
		}
		try {
			response.getWriter().write(msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			leaveOpera.closeCon();
		}
	
	}
}
