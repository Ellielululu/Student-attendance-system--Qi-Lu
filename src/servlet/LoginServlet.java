package servlet;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Student;
import model.Teacher;
import model.admin;
import util.StringUtil;
import baseOpera.TeacherOpera;
import baseOpera.adminbaseO;
import baseOpera.studentOpera;

public class LoginServlet extends HttpServlet {

	
	private static final long serialVersionUID = -154176561953216931L;

	  public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException{
	        doPost(request,response);
	   }
	   public  void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException{
	       String method= request.getParameter("method");
	       if("logout".equals(method)){
	    	   logOut(request,response);
	    	   return;
	       }
		   String vcode = request.getParameter("vcode");
	       String name=request.getParameter("account");
	       String password=request.getParameter("password");
	       int type=Integer.parseInt(request.getParameter("type"));
	       String loginCpacha = request.getSession().getAttribute("loginCapcha").toString();
		   if(StringUtil.isEmpty(vcode)){
			    response.getWriter().write("vcodeError");
			    return;
		   }
		   if(!vcode.toUpperCase().equals(loginCpacha.toUpperCase())){
			   response.getWriter().write("vcodeError");
			    return;
		   }
		   String loginStatus="loginFailed";
	       switch(type){
	       case 1:{
	    	   adminbaseO adminbaseo=new adminbaseO();
		       admin admin = adminbaseo.login(name,password);
		       adminbaseo.closeCon();
		       if(admin==null){
		    	   response.getWriter().write("loginError");
				    return;
				    }
		       HttpSession session = request.getSession();
		       session.setAttribute("user", admin);
		      
		       session.setAttribute("userType", type);
		       loginStatus="loginSuccess";
		       
		       break;
	    	   }
	       case 2:{
	    	   studentOpera studentOpera=new studentOpera();
		       Student student = studentOpera.login(name,password);
		       studentOpera.closeCon();
		       if(student==null){
		    	   response.getWriter().write("loginError");
				    return;
				    }
		       HttpSession session = request.getSession();
		       session.setAttribute("user", student);
		      
		       session.setAttribute("userType", type);
		       loginStatus="loginSuccess";
		       
		       break;
	    	   }
	       
	       case 3:{
	    	   TeacherOpera teacherOpera=new TeacherOpera();
	    	   Teacher teacher = teacherOpera.login(name,password);
		       teacherOpera.closeCon();
		       if(teacher==null){
		    	   response.getWriter().write("loginError");
				    return;
				    }
		       HttpSession session = request.getSession();
		       session.setAttribute("user", teacher);
		      
		       session.setAttribute("userType", type);
		       loginStatus="loginSuccess";
		       
		       break;
	    	   }
	       default:
	    	   break;
	       }
	       response.getWriter().write(loginStatus);
	     
	       }
	   private void logOut(HttpServletRequest request,HttpServletResponse response) throws IOException{
		   request.getSession().removeAttribute("user");
		   request.getSession().removeAttribute("userType");
		   response.sendRedirect("index.jsp");
	   }
	 }

