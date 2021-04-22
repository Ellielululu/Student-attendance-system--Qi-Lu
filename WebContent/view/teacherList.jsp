<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Teacher List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">

	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		var table;
		
	
	    $('#dataList').datagrid({ 
	        title:'Teacher List', 
	     
	        border: true, 
	        collapsible:false,
	        fit: true,
	        method: "post",
	        url:"TeacherServlet?method=TeacherList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect:false, 
	        pagination:true,
	        rownumbers:true,
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'sn',title:'Teacher ID',width:150, sortable: true},    
 		        {field:'name',title:'First Name',width:150},
 		       {field:'lastName',title:'Last Name',width:150},
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
	        beforePageText: 'No.',
	        afterPageText: 'Page    All {pages} pages', 
	        displayMsg: 'Display {from} - {to} data   All {total} in total', 
	    }); 
	 
	    $("#add").click(function(){
	    	table = $("#addTable");
	    	$("#addDialog").dialog("open");
	    });
	
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("Message Notification:", "Please choose data to operate!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	 
	    $("#delete").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	var selectLength = selectRows.length;
        	if(selectLength == 0){
            	$.messager.alert("Message Notification:", "Please choose data to delete!", "warning");
            } else{
            	var ids = [];
            	$(selectRows).each(function(i, row){
            		ids[i] = row.id;
            	});
            	var numbers = [];
            	$(selectRows).each(function(i, row){
            		numbers[i] = row.number;
            	});
            	$.messager.confirm("Message Notification: ", "Will delete all data about the chosen teacher, continue？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "TeacherServlet?method=DeleteTeacher",
							data: {ids: ids,numbers:numbers},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Message Notification: ","Delete successfully!","info");
								
									$("#dataList").datagrid("reload");
									$("#dataList").datagrid("uncheckAll");
								} else{
									$.messager.alert("Message Notification: ","Failed to delete!","warning");
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
	    

	    $("#addDialog").dialog({
	    	title: "Add Teacher",
	    	width: 850,
	    	height: 550,
	    
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
							$.messager.alert("Message notification:","Please check the data you entered!","warning");
							return;
						} else{
						
							var clazzid = $("#add_clazzList").combobox("getValue");
						
							var name = $("#add_name").textbox("getText");
							var lastname = $("#add_last_name").textbox("getText");
							var gender = $("#add_gender").textbox("getText");
							var password = $("#add_password").textbox("getText");
							var data = {clazzid:clazzid, name:name,lastname:lastname, gender:gender, password:password};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=AddTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notification: ","Added successfully!","info");
										
										$("#addDialog").dialog("close");
								
										$("#add_number").textbox('setValue', "");
										$("#add_name").textbox('setValue', "");
										$("#add_last_name").textbox('setValue', "");
										$("#add_gender").textbox('setValue', "Male");
										
										$(table).find(".chooseTr").remove();
										
										
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("Message Notification: ","Failed to add!","warning");
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
					
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onClose: function(){
				$("#add_number").textbox('setValue', "");
				$("#add_name").textbox('setValue', "");
				$("#add_last_name").textbox('setValue', "");
				
				
				$(table).find(".chooseTr").remove();
			}
	    });
	  	
	 
	  	

	  	$("#add_gradeList, #add_clazzList").combobox({
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
			
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	 
	  	

	  	$("#editDialog").dialog({
	  		title: "Modify teacher information",
	    	width: 850,
	    	height: 550,

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
						if(!validate){
							$.messager.alert("Message Notification: ","Please check the data you entered!","warning");
							return;
						} else{
							var chooseCourse = [];
							$(table).find(".chooseTr").each(function(){
								var gradeid = $(this).find("input[textboxname='gradeid']").attr("gradeId");
								var clazzid = $(this).find("input[textboxname='clazzid']").attr("clazzId");
								var courseid = $(this).find("input[textboxname='courseid']").attr("courseId");
								var course = gradeid+"_"+clazzid+"_"+courseid;
								chooseCourse.push(course);
							});
							var id = $("#dataList").datagrid("getSelected").id;
							var number = $("#edit_number").textbox("getText");
							var name = $("#edit_name").textbox("getText");
							var lastname = $("#edit_last_name").textbox("getText");
							var gender = $("#edit_gender").textbox("getText");
						
							var data = {id:id, number:number, name:name,lastname:lastname,gender:gender,course:chooseCourse};
							
							$.ajax({
								type: "post",
								url: "TeacherServlet?method=EditTeacher",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message Notification: ","Modified successfully!","info");
									
										$("#editDialog").dialog("close");
								
										$("#edit_number").textbox('setValue', "");
										$("#edit_name").textbox('setValue', "");
										$("#edit_last_name").textbox('setValue', "");
										$("#edit_gender").textbox('setValue', "Male");
									
										$(table).find(".chooseTr").remove();
										
										
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("Message Notification: ","Failed to modify!","warning");
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
						
						$(table).find(".chooseTr").remove();
						
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");

				$("#edit_number").textbox('setValue', selectRow.number);
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_last_name").textbox('setValue', selectRow.lastName);
				$("#edit_gender").textbox('setValue', selectRow.gender);
				
			},
			onClose: function(){
				$("#edit_name").textbox('setValue', "");
				$("#edit_last_name").textbox('setValue', "");
			
				
				$(table).find(".chooseTr").remove();
			}
	    });

	    
	});
	</script>
</head>
<body>

	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	
	<div id="toolbar">
	<c:if test="${userType==1 }">	
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" >Add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
			</c:if>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" >Modify</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<c:if test="${userType==1 }">	
		<div><a id="delete" href="javascript:;" class="easyui-linkbutton" >Delete</a></div>
		</c:if>
        <div style="margin-left: 10px;">Class：<input id="clazzList" class="easyui-textbox" name="clazz" /></div>
	</div>
	

	<div id="addDialog" style="padding: 10px;">  
   		
	  
   		<form id="addForm" method="post">
	    	<table id="addTable" border=0 style="width:100px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:75px">Class:</td>
	    			<td colspan="3">
	    				<input id="add_clazzList" style="width: 200px; height: 30px;" class="easyui-textbox" name="clazzid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>First Name:</td>
	    			<td colspan="4"><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please enter your first name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Last Name:</td>
	    			<td colspan="4"><input id="add_last_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="lastName" data-options="required:true, missingMessage:'Please enter your last name'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Password:</td>
	    			<td colspan="4"><input id="add_password" style="width: 200px; height: 30px;" class="easyui-textbox" type="password" name="password" data-options="required:true, missingMessage:'Please enter your password'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Gender:</td>
	    			<td colspan="4"><select id="add_gender" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="sex"><option value="Male">Male</option><option value="Female">Female</option></select></td>
	    		</tr>
	    		
	    	</table>
	    </form>
	</div>
	
	
	

	<div id="editDialog" style="padding: 10px">
		
    	<form id="editForm" method="post">
	    	<table id="editTable" border=0 style="width:800px; table-layout:fixed;" cellpadding="6" >
	    		<tr>
	    			<td style="width:75px">Number:</td>
	    			<td colspan="3"><input id="edit_number" data-options="readonly: true" class="easyui-textbox" style="width: 200px; height: 30px;" type="text" name="number" data-options="required:true, validType:'repeat', missingMessage:'Please enter your number'" /></td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td>First Name:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name" data-options="required:true, missingMessage:'Please enter your first name!'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Last Name:</td>
	    			<td><input id="edit_last_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="last_name" data-options="required:true, missingMessage:'Please enter your last name!'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Gender:</td>
	    			<td><select id="edit_gender" class="easyui-combobox" data-options="editable: false, panelHeight: 50, width: 60, height: 30" name="gender"><option value="Male">Male</option><option value="Female">Female</option></select></td>
	    		</tr>
	    		
	    	</table>
	    </form>
	</div>
	
	
</body>
</html>