<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Course List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	

	    $('#dataList').datagrid({ 
	        title:'Course List', 
	       
	        border: true, 
	        collapsible: false,
	        fit: true,
	        method: "post",
	        url:"CourseServlet?method=CourseList&t="+new Date().getTime(),
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
 		        {field:'name',title:'Name',width:200},
 		        {field:'teacherId',title:'Teacher',width:200},
 		        {field:'courseDate',title:'Time',width:200},
 		       {field:'selectedNum',title:'Number of people selected',width:200},
 		      {field:'maxNum',title:'Maximum number of people selected',width:200},
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
							url: "CourseServlet?method=DeleteCourse",
							data: {courseid: courseid},
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
	    	height: 400,
	    	
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
								url: "CourseServlet?method=AddCourse",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notification","Added successfully!","info");
								
										$("#addDialog").dialog("close");
									
										$("#add_name").textbox('setValue', "");
									
										$('#dataList').datagrid("reload");
									} else{
										$.messager.alert("Message notification","Failed to add!","warning");
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
	  	
		$("#add_teacherList, #edit_teacherList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  	});
	  	
	    $("#add_teacherList").combobox({
	  		url: "TeacherServlet?method=TeacherList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
		  		
				var data = $(this).combobox("getData");;
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
	    			<td>Course name:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Cannot be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td style="width:75px">Teacher:</td>
	    			<td colspan="3">
	    				<input id="add_teacherList" style="width: 200px; height: 30px;" class="easyui-textbox" name="teacherid" />
	    			</td>
	    			
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>Time:</td>
	    			<td><input id="add_course_date" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="course_date" data-options="required:true, missingMessage:'Cannot be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Maximum number of people selected:</td>
	    			<td><input id="add_max_num" style="width: 200px; height: 30px;" class="easyui-numberbox" type="text" name="maxnum" data-options="min:0,precision:0,required:true, missingMessage:'Cannot be empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Information:</td>
	    			<td>
	    			 <textarea id="info" name="info" style="width: 200px; height: 60px;"></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
</body>
</html>