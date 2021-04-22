<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>List of Selected Courses</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
	
	    $('#dataList').datagrid({ 
	        title:'Attendance information', 
	       
	        border: true, 
	        collapsible: false,
	        fit: true,
	        method: "post",
	        url:"AttendanceServlet?method=AttendanceList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,
	        pagination: false,
	        rownumbers: true,
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'studentId',title:'Student Name',width:200},
 		        {field:'courseId',title:'Course',width:200},
 		       {field:'type',title:'Sign-in type',width:200, sortable: false},    
 		      {field:'date',title:'Sign-in time',width:200, sortable: true},    
 		        
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	   	
	  
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("Message notification", "Please choose data to delete!", "warning");
            } else{
            	var courseid = selectRow.id;
            	$.messager.confirm("Message notification", "Will delete all the data related to the course, continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "AttendanceServlet?method=DeleteAttendance",
							data: {id: id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Message notification","Delete successfully!","info");
									
									$("#dataList").datagrid("reload");
								} else{
									$.messager.alert("Message notification","Failed to delete!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	  	
	
	    $("#addDialog").dialog({
	    	title: "Add course",
	    	width: 450,
	    	height: 300,
	    	
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Add',
					plain: true,
					
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("Message notification","Please check the data you entered!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "AttendanceServlet?method=AddAttendance",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notification","Added successfully!","info");
										
										$("#addDialog").dialog("close");
									
										$("#add_name").textbox('setValue', "");
								
										$('#dataList').datagrid("reload");
									} else{
										$.messager.alert("Message notification",msg,"warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					
					handler:function(){
						$("#add_name").textbox('setValue', "");
					}
				},
			]
	    });
	  	
		$("#add_studentList, #add_courseList,#add_typeList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  	});
		
	
		
	  	
	    $("#add_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
		  	
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
				getStudentSelectedCourseList(data[0].id);
	  		}
	  	});
	    function getStudentSelectedCourseList(studentId){
	    	$("#add_courseList").combobox({
		  		url: "AttendanceServlet?method=getStudentSelectedCourseList&t="+new Date().getTime()+"&student_id="+studentId,
		  		onLoadSuccess: function(){
		
					var data = $(this).combobox("getData");;
					$(this).combobox("setValue", data[0].id);
		  		}
		  	});
	    }
	    var typeData=[{id:"a.m",text:"a.m"  },{id:"p.m",text:"p.m"  }];
	    $("#add_typeList").combobox({
	    	data:typeData,
	    	valueField:'id',
	    	textField:'text',
	        onLoadSuccess:function(){
	        	var data=$(this).combobox("getData");
	        	$(this).combobox("setValue", data[0].id);
				
	        }	
	    }); 
	 
	  	
	});
	</script>
</head>
<body>

	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="plain:true">Add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="plain:true">Delete</a></div>
	</div>
	
	
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    <tr>
	    			<td style="width:75px">Student:</td>
	    			<td colspan="3">
	    				<input id="add_studentList" style="width: 200px; height: 30px;" class="easyui-textbox" name="studentid" data-options="required:true, missingMessage:'Please select a student'" />
	    			</td>
	    			
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:75px">Course:</td>
	    			<td colspan="3">
	    				<input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" data-options="required:true, missingMessage:'Please select a course'"/>
	    			</td>
	    			
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td style="width:75px">Type:</td>
	    			<td colspan="3">
	    				<input id="add_typeList" style="width: 200px; height: 30px;" class="easyui-textbox" name="type" data-options="required:true, missingMessage:'Please choose a type'"/>
	    			</td>
	    			
	    			<td style="width:80px"></td>
	    		</tr>

	    	</table>
	    </form>
	</div>
</body>
</html>