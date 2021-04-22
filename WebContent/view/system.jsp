<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Student attendance management system Administrator</title>
   

    <link rel="stylesheet" type="text/css" href="easyui/css/default.css" />
    <link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css" />
    
    <script type="text/javascript" src="easyui/jquery.min.js"></script>
    <script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src='easyui/js/outlook2.js'> </script>
    <script type="text/javascript">
	 var _menus = {"menus":[
						
						{"menuid":"1","icon":"","menuname":"Student information",
							"menus":[
									{"menuid":"11","menuname":"Student list","url":"StudentServlet?method=toStudentListView"},
								]
						},
						<c:if test="${userType == 1 ||userType == 3}">
						{"menuid":"2","icon":"","menuname":"Lecturer information",
							"menus":[
									{"menuid":"21","menuname":"Lecturer list","url":"TeacherServlet?method=toTeacherListView"},
								]
						},
						</c:if>
						<c:if test="${userType == 1 || userType == 3}">
						{"menuid":"3","icon":"","menuname":"Basic information",
							"menus":[
									
									{"menuid":"31","menuname":"Class list","url":"ClazzServlet?method=toClazzListView"}
									
								]
						},
						</c:if>
						<c:if test="${userType == 1 ||userType == 3}">
						{"menuid":"4","icon":"","menuname":"Course information",
							"menus":[
									{"menuid":"41","menuname":"Course list","url":"CourseServlet?method=toCourseListView"},
								]
						},
						</c:if>
						
						{"menuid":"5","icon":"","menuname":"Selected Courses",
							"menus":[
									{"menuid":"51","menuname":"Selected Course","url":"SelectedCourseServlet?method=toSelectedCourseListView"},
								]
						},
						{"menuid":"6","icon":"","menuname":"Attendance information",
							"menus":[
									{"menuid":"61","menuname":"Attendance information","url":"AttendanceServlet?method=toAttendanceCourseListView"},
								]
						},
						{"menuid":"7","icon":"","menuname":"AttendanceManagement",
							"menus":[
									{"menuid":"71","menuname":"AttendanceManagement","url":"LeaveServlet?method=toLeaveCourseListView"},
								]
						},
				]};


    </script>

</head>
<body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
	<noscript>
		<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
		    <img  alt='Sorry, please enable script support.' />
		</div>
	</noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        background-color: black;
        line-height: 30px;color: #fff; font-family: Verdana">
        <span style="float:right; padding-right:20px;" class="head"><span style="color:white; font-weight:bold;">${user.name}&nbsp;</span><a href="LoginServlet?method=logout" id="loginOut">Logout</a></span>
        <span style="padding-left:750px; font-size: 16px; color:white; ">Student Attendance System</span>
    </div>
    <div region="south" split="true" style="height: 30px; background: black; ">
        
    </div>
    <div region="west" hide="true" split="true" title="Navigation menu" style="width:180px;" id="west">
	<div id="nav" class="easyui-accordion" fit="true" border="false">
		
	</div>
	
    </div>
    <div id="mainPanle" region="center" style="background-color: black; ">
        <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
		<jsp:include page="welcome.jsp" />
		</div>
    </div>
	
	<iframe width=0 height=0 src="refresh.jsp"></iframe>
	
</body>
</html>