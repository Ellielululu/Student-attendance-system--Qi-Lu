<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />


<link href="h-ui/css/H-ui.min.css" rel="stylesheet" type="text/css" />
<link href="h-ui/css/H-ui.login.css" rel="stylesheet" type="text/css" />
<link href="h-ui/lib/icheck/icheck.css" rel="stylesheet" type="text/css" />


<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">


<script type="text/javascript" src="easyui/jquery.min.js"></script> 
<script type="text/javascript" src="h-ui/js/H-ui.js"></script> 
<script type="text/javascript" src="h-ui/lib/icheck/jquery.icheck.min.js"></script> 

<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>

<script type="text/javascript">
	$(function(){
		
		$("#vcodeImg").click(function(){
			this.src="CapchaServlet?method=loginCapcha&t="+new Date().getTime();
		});
		
		
		$("#submitBtn").click(function(){
			if($("#radio-2").attr("checked") && "${systemInfo.forbidStudent}" == 1){
				$.messager.alert("Message notification", "Students cannot log in to the system temporarily", "warning");
				return;
			}
			if($("#radio-3").attr("checked") && "${systemInfo.forbidTeacher}" == 1){
				$.messager.alert("Message notification", "Teachers cannot log in to the system temporarily", "warning");
				return;
			}
			
			var data = $("#form").serialize();
			$.ajax({
				type: "post",
				url: "LoginServlet?method=Login",
				data: data, 
				dataType: "text", 
				success: function(msg){
					if("vcodeError" == msg){
						$.messager.alert("Message notification", "Verification code error", "warning");
						$("#vcodeImg").click();
						$("input[name='vcode']").val("");
					} else if("loginError" == msg){
						$.messager.alert("Message notification", "Wrong user name or password!", "warning");
						$("#vcodeImg").click();
						$("input[name='vcode']").val("");
					} else if("loginSuccess" == msg){
						window.location.href = "SystemServlet?method=toAdminView";
					} else {
						alert(msg);
					} 
				}
				
			});
		});
		
		
		$(".skin-minimal input").iCheck({
			radioClass: 'iradio-blue',
			increaseArea: '25%'
		});
	})
</script> 
<title>StudentAttendanceSystem</title>
<meta name="keywords" content="StudentAttendanceSystem">
</head>
<body>

<div class="header" style="padding: 0;">
	<h2 style="color: black">Student Attendance System</h2>
</div>
<div class="loginWraper">
  <div id="loginform" class="loginBox">
    <form id="form" class="form form-horizontal" method="post">
      <div class="row cl">
        <label class="form-label col-3"><i class="Hui-iconfont">Account:</i></label>
        <div class="formControls col-8">
          <input id="" name="account" type="text" placeholder="Account" class="input-text size-L">
        </div>
      </div>
      <div class="row cl">
        <label class="form-label col-3"><i class="Hui-iconfont">Password:</i></label>
        <div class="formControls col-8">
          <input id="" name="password" type="password" placeholder="Password" class="input-text size-L">
        </div>
      </div>
      <div class="row cl">
        <div class="formControls col-8 col-offset-3">
          <input class="input-text size-L" name="vcode" type="text" placeholder="Please enter the code" style="width: 200px;">
          <img title="Click the picture to change the verification code" id="vcodeImg" src="CapchaServlet?method=loginCapcha"></div>
      </div>
      
      <div class="mt-20 skin-minimal" style="text-align: center;">
		<div class="radio-box">
			<input type="radio" id="radio-2" name="type" checked value="2" />
			<label for="radio-1">Student</label>
		</div>
		<div class="radio-box">
			<input type="radio" id="radio-3" name="type" value="3" />
			<label for="radio-2">Teacher</label>
		</div>
		<div class="radio-box">
			<input type="radio" id="radio-1" name="type" value="1" />
			<label for="radio-3">Administrator</label>
		</div>
	</div>
      
      <div class="row">
        <div class="formControls col-8 col-offset-3">
          <input id="submitBtn" type="button" class="btn btn-success radius size-L" value="&nbsp;Login&nbsp;">
        </div>
      </div>
    </form>
  </div>
</div>



</body>
</html>