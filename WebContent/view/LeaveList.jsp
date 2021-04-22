<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Attendance management</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
	
	    $('#dataList').datagrid({ 
	        title:'Leave application List', 
	       
	        border: true, 
	        collapsible: false,
	        fit: true,
	        method: "post",
	        url:"LeaveServlet?method=LeaveList&t="+new Date().getTime(),
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
 		      
 		        {field:'studentId',title:'Student',width:200
 		        },
 		      
 		        {field:'info',title:'Reason for leave',width:200},
 		       {field:'status',title:'Status',width:200,
 		        	 formatter: function(value,row,index){
					switch(row.status){
					case 0: {
						return 'Pending';
					}
					case 1: {
						return 'Pass';
					}
					case -1: {
						return 'Denied';
					}
					}
					} 	
 		       },
 		      {field:'remark',title:'Review result',width:200},
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	   	
	  
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	    
	    $("#check").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("Message notification", "Please select data to operate!", "warning");
            } else{
            	if(selectRows[0].status != 0){
            		$.messager.alert("Message notification", "This application has been reviewed, cannot be reviewed again!", "warning");
            		return;
            	}
		    	$("#checkDialog").dialog("open");
            }
	    });
	    
	    
		$("#checkDialog").dialog({
	  		title: "Review application",
	    	width: 450,
	    	height: 350,

	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Submit',
					plain: true,
		
					handler:function(){
						var validate = $("#checkForm").form("validate");
						if(!validate){
							$.messager.alert("Message notification","Please check the data you entered!","warning");
							return;
						} else{
							
							var studentid = $("#dataList").datagrid("getSelected").studentId;
							var id = $("#dataList").datagrid("getSelected").id;
							var info = $("#dataList").datagrid("getSelected").info;
							var remark = $("#check_remark").textbox("getValue");
							var status = $("#check_statusList").combobox("getValue");
							var data = {id:id, studentid:studentid, info:info,remark:remark,status:status};
							
							$.ajax({
								type: "post",
								url: "LeaveServlet?method=CheckLeave",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notification","Successful review!","info");
										
										$("#checkDialog").dialog("close");
										
										$("#check_remark").textbox('setValue',"");
										
									
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("Message notification","Fail to review!","warning");
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
						$("#check_remark").val("");
						$("#check_statusList").combox('clear');
					}
				},
			],
			onBeforeOpen: function(){
				
			},
			onClose: function(){
				$("#edit_info").val("");
				
			}
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
							url: "LeaveServlet?method=DeleteLeave",
							data: {id: selectRow.id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Message notification","Delete successfully!","info");
									
									$("#dataList").datagrid("reload");
								} else{
									$.messager.alert("Message notification","Fail to delete!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	  	

	    $("#addDialog").dialog({
	    	title: "Add Leave application",
	    	width: 450,
	    	height: 350,
	    	
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
								url: "LeaveServlet?method=AddLeave",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notification","Added successfully!","info");
										
										$("#addDialog").dialog("close");
									
									
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
	  	
		$("#add_studentList, #edit_studentList,#studentList").combobox({
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
			<c:if test="${userType == 1 || userType == 3}">
			<div style="float: left;"><a id="check" href="javascript:;" class="easyui-linkbutton" data-options="plain:true">Review</a></div>
			</c:if>
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="plain:true">Delete</a></div>
	</div>
	
	
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    	
	    		<tr>
	    			<td style="width:60px">Student:</td>
	    			<td colspan="3">
	    				<input id="add_studentList" style="width: 300px; height: 30px;" class="easyui-textbox" name="studentid" data-options="multiline:true,required:true, missingMessage:'Please select one'" />
	    			</td>
	    			
	    		
	    		</tr>
	    		
	    		<tr>
	    			<td>Leave reason:</td>
	    			<td>
	    		<textarea id="info" name="info" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true,required:true, missingMessage:'Cannot be empty'" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<div id="checkDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:60px">Studant:</td>
	    			<td colspan="3">
	    				<select id="check_statusList" style="width: 300px; height: 30px;" class="easyui-combobox" name="status" data-options="required:true, missingMessage:'Please select status'" >
	    					<option value="1">Pass</option>
	    					<option value="-1">Denied</option>
	    				</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>Review content:</td>
	    			<td>
	    				<textarea id="check_remark" name="remark" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>