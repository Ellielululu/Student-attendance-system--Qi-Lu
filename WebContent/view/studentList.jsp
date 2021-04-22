<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Student List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
	
	    $('#dataList').datagrid({ 
	        title:'Student List', 

	        border: true, 
	        collapsible:false,
	        fit: true,
	        method: "post",
	        url:"StudentServlet?method=StudentList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false,
	        pagination:true,
	        rownumbers:true,
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:200, sortable: true},
 		       {field:'sn',title:'Student ID',width:200, sortable: true}, 
 		        {field:'name',title:'First Name',width:200},    
 		        {field:'lastName',title:'Last Name',width:200},	
 		       {field:'gender',title:'Gender',width:100},
 		        {field:'clazz_id',title:'Class',width:150, 
 		        	formatter: function(value,row,index){
 						if (row.clazzId){	
 				            var clazzList=$("#clazzList").combobox("getData");
 							for(var i=0; i<clazzList.length; i++){
 								//console.log(clazzList[i]);
 								if(row.clazzId==clazzList[i].id) return clazzList[i].name;
 							}
 							return row.clazzId;
 						} else {
 							return 'not found';
 						}
 					}
				},
 		       
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#clazzList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
	   
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,
	        pageList: [10,20,30,50,100],
	        beforePageText: 'No',
	        afterPageText: 'Pages     /{pages} ', 
	        displayMsg: 'Display {from} - {to} data   total {total} ', 
	    }); 
	  
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	   
	    $("#edit").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("Message Notification", "Please select data to operate.", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("Message Notification", "Please select data to delete", "warning");
            } else{
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.sn;
            	});
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	$.messager.confirm("Message notifiaction", "Will delete the chosen student's information ，continue？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "StudentServlet?method=DeleteStudent",
							data: {sns: numbers, ids: ids},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Message notification","Successfully delete!","info");
								
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
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
	    
	  	
	  
	  	function preLoadClazz(){
	  	 	$("#clazzList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false, 
		  		editable: false, 
		  		method: "post",
		  		url: "ClazzServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
		  		onChange: function(newValue, oldValue){
		  			
		  			$('#dataList').datagrid("options").queryParams = {clazzid: newValue};
		  			$('#dataList').datagrid("reload");
		  		}
		  	});
	  	}
	  	
	
	  	$("#add_clazzList, #edit_clazzList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false, 
	  		editable: false, 
	  		method: "post",
	  	});
	  	
	  	
	  	$("#add_clazzList").combobox({
	  		url: "ClazzServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
		  		
				var data = $(this).combobox("getData");;
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	
	  	
	  	$("#edit_clazzList").combobox({
	  		url: "ClazzServlet?method=getClazzList&t="+new Date().getTime()+"&from=combox",
			onLoadSuccess: function(){
			
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	
	    $("#addDialog").dialog({
	    	title: "Add student",
	    	width: 650,
	    	height: 460,
	    	
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
						
							var clazzid = $("#add_clazzList").combobox("getValue");
							$.ajax({
								type: "post",
								url: "StudentServlet?method=AddStudent",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notification","Successfuly added!","info");
									
										$("#addDialog").dialog("close");
										
										$("#add_number").textbox('setValue', "");
										$("#add_name").textbox('setValue', "");
										$("#add_last_name").textbox('setValue', "");
										$("#add_password").textbox('setValue', "");
										$("#add_sex").textbox('setValue', "Male");
									
									
										$('#dataList').datagrid("options").queryParams = {clazzid: clazzid};
							  			$('#dataList').datagrid("reload");
							  			
							  			setTimeout(function(){
											$("#clazzList").combobox('setValue', clazzid);
										}, 100);
										
									} else{
										$.messager.alert("Message notification","Failed to added!","warning");
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
						$("#add_number").textbox('setValue', "");
						$("#add_name").textbox('setValue', "");
						$("#add_last_name").textbox('setValue', "");
						$("#add_password").textbox('setValue', "");
						
						$("#add_gradeList").combobox("clear");
						$("#add_gradeList").combobox("reload");
					}
				},
			]
	    });
	  	
	  	
	    $("#editDialog").dialog({
	    	title: "Modify information",
	    	width: 650,
	    	height: 460,
	    
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
						var validate = $("#editForm").form("validate");
						
						var clazzid = $("#edit_clazzList").combobox("getValue");
						if(!validate){
							$.messager.alert("Message notification","Please check the data you entered!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "StudentServlet?method=EditStudent&t="+new Date().getTime(),
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notifiaction","Update completed!","info");
								
										$("#editDialog").dialog("close");
								
										$('#dataList').datagrid("options").queryParams = {clazzid: clazzid};
										$("#dataList").datagrid("reload");
										$("#dataList").datagrid("uncheckAll");
									 
							  			setTimeout(function(){
											$("#clazzList").combobox('setValue', clazzid);
										}, 100);
							  			
									} else{
										$.messager.alert("Message notification","Update failed!","warning");
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
					
						$("#edit_name").textbox('setValue', "");
						$("#edit_last_name").textbox('setValue', "");
						$("#edit_gender").textbox('setValue', "Male");
						
					
						$("#edit_gradeList").combobox("clear");
						$("#edit_gradeList").combobox("reload");
					}
				}
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
	
				
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_last_name").textbox('setValue', selectRow.lastName);
				$("#edit_gender").textbox('setValue', selectRow.gender);
				$("#edit_id").val(selectRow.id);
				
				var clazzid = selectRow.clazzId;
				
				setTimeout(function(){
					$("#edit_clazzList").combobox('setValue', clazzid);
				}, 100);
				
			}
	    });
	   
	});
	</script>
</head>
<body>

	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 

	<div id="toolbar">
		<c:if test="${userType==1 ||userType==3 }">	
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
			</c:if>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Modify</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
			
		<c:if test="${userType==1 ||userType==3 }">	
		<div style="float: left;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		</c:if>
		
		<div style="margin-left: 10px;">Class：<input id="clazzList" class="easyui-textbox" name="clazz" /></div>
	
	</div>
	

	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>First Name:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please enter your first name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Last Name:</td>
	    			<td><input id="add_last_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="lastName"  data-options="required:true, missingMessage:'Please enter your last name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Password:</td>
	    			<td>
	    				<input id="add_password"  class="easyui-textbox" style="width: 200px; height: 30px;" type="password" name="password" data-options="required:true, missingMessage:'Please enter your Login password'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>Gender:</td>
	    			<td><select id="add_sex" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="gender"><option value="male">Male</option><option value="Female">Female</option></select></td>
	    		</tr>
	    		
	    		<tr>
	    			<td>Class:</td>
	    			<td><input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	

	<div id="editDialog" style="padding: 10px">
		<div style="float: right; margin: 20px 20px 0 0; width: 200px; border: 1px solid #EBF3FF">
	    	
	    </div>   
    	<form id="editForm" method="post">
    	    <input type="hidden" name="id" id="edit_id">
	    	<table cellpadding="8" >
	    	
	    		<tr>
	    			<td>First Name:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please enter your first name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Last Name:</td>
	    			<td><input id="edit_last_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="lastName" data-options="required:true, missingMessage:'Please enter your last name'" /></td>
	    		</tr>
	    		<tr>
	    		
	    			<td>Gender:</td>
	    			<td><select id="edit_gender" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="Male">Male</option><option value="Female">Female</option></select></td>
	    		</tr>
	    		<tr>
	    			<td>Class:</td>
	    			<td><input id="edit_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" /></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>