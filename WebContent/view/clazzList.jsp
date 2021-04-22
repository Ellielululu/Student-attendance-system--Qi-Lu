<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
	<meta charset="UTF-8">
	<title>Class List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">

	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
	
	    $('#dataList').datagrid({ 
	        title:'Class List', 
	       
	        border: true, 
	        collapsible: false,
	        fit: true,
	        method: "post",
	        url:"ClazzServlet?method=getClazzList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,
	        pagination: true,
	        rownumbers: true,
	        sortName: 'id',
	        sortOrder: 'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'name',title:'Class',width:200},
 		        {field:'info',title:'Information',width:100, 
 		        	
 		        },
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,
	        pageList: [10,20,30,50,100],
	        beforePageText: 'No.',
	        afterPageText: 'Page     {pages} pages', 
	        displayMsg: 'Now {from} - {to} data    {total} data', 
	    });

	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        
	    	if(selectRow == null){
            	$.messager.alert("Message notification: ", "Please choose data to delete!", "warning");
            } else{
            	var clazzid = selectRow.id;
            	$.messager.confirm("Message notification: ", "This action will delete the class information(include student and lecture), continue？", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "ClazzServlet?method=DeleteClazz",
							data: {clazzid: clazzid},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("Message notification: ","Delete succeeded!","info");
								
									$("#dataList").datagrid("reload");
								} else{
									$.messager.alert("Message notificication: ","Delete failed!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	   
	    
	  
	 
	    $("#addDialog").dialog({
	    	title: "Add class",
	    	width: 500,
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
							$.messager.alert("Message notification: ","Please check the data you entered!","warning");
							return;
						} else{
						
							$.ajax({
								type: "post",
								url: "ClazzServlet?method=AddClazz",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("Message notifivation","Data added!","info");
								
										$("#addDialog").dialog("close");
										
										$("#add_name").textbox('setValue', "");
										$("#info").val("");
									
							  			
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("Message notification","Data insert failed!","warning");
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
		
						$("#info").val("");
					}
				},
			]
	    });
	  	
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			clazzName:$('#clazzName').val()
	  		
	  		});
	  	});
	  	
	});
	</script>
</head>
<body>

	<table id="dataList" cellspacing="0" cellpadding="0"> 
	</table> 
	

	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" >Add</a></div>
			<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" >Delete</a></div>
        <div style="margin: 0 10px 0 10px">Class name：<input id="clazzName" class="easyui-textbox" name="className" />
        <a id="search-btn" href="javascript:;" class="easyui-linkbutton" >Search</a>
        </div>
	    
	</div>
	

	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Class:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name"   data-options="required:true, missingMessage:'Cannot be empty'" /></td>
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