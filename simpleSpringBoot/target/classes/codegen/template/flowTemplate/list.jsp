<#import "function.ftl" as func>
<#assign comment=model.tabComment>
<#assign class=model.variables.class>
<#assign package=model.variables.package>
<#assign comment=model.tabComment>
<#assign classVar=model.variables.classVar>
<#assign system=vars.system>
<#assign commonList=model.commonList>
<#assign pkModel=model.pkModel>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html" %>
<html>
<head>
<title>${comment }管理</title>
<%@ include file="/js/easyui/getbaseEasyUI.jsp" %>
<%@ include file="/commons/include/getUserInfo.jsp"%>
<%@ include file="/js/easyui/getExtTipUI.jsp" %>
<#noparse>
<script type="text/javascript" src="${ctx}/js/util/util.js"></script>
<script type="text/javascript" src="${ctx}/js/util/json2.js"></script>
<script type="text/javascript" src="${ctx}/js/hotent/platform/bpm/FlowUtil.js"></script>
<script type="text/javascript" src="${ctx}/js/isunlandBLL/comm/util/jsObjectExtend.js"></script>
<script language="javascript" type="text/javascript" src="${ctx}/js/calendar/My97DatePicker/WdatePicker.js"></script>
</#noparse>
<script type="text/javascript">

	//基本变量区域
	var memberCode='<%=si.getCurrentMemberCode()%>';
	var currentDeptCode='<%=si.getCurrentDeptCode()%>';
	var currentDeptName='<%=si.getCurrentDeptName()%>';
	var userJobno='<%=si.getCurrentJobNo()%>';
	var userName='<%=si.getCurrentName()%>';
	var checkStatus = <%=si.getTaskStatus(0)%>;
	var serverDateStr = getServerTime("yyyy-MM-dd HH:mm:ss");
	var serverDate=strToDateFormatter(serverDateStr);
	var	dataStatus = getDictionaryJson('flow_form_dataStatus',memberCode);
	var dataStatusDic={};//流程状态数据字典
	if(dataStatus){
		for(var i=0;i<dataStatus.length;i++){
			dataStatusDic[dataStatus[i].ID]=dataStatus[i].TEXT;
		}
	}else{
		dataStatusDic={
			'new':'草稿',
			'waitCheck':'审核中',
			'checkPass':'已审核'
		}
	}
	var defId='<#noparse>${defId}</#noparse>';//流程定义id,必须有
	
	
	
	
	
	
	/***页面加载后各种初始化***/	
	$(function(){
		
		loadDatagrid();
	});
	
	
	//申请单主表
	function loadDatagrid(){
		var buttons=[{
			id:"start",
			text:"启动流程",
			iconCls:"icon-submit",
			plain:true,
			handler:startFlow
		},{
			id:"endFlow",
			text:"终止流程",
			iconCls:"icon-arrange",
			plain:true,
			handler:endFlow
		},{
			id:"flowImg",
			text:"流程图",
			iconCls:"icon-lastplay",
			plain:true,
			handler:showFlowImg
		},{
			id:"detail",
			text:"表单明细",
			iconCls:"icon-planinfo",
			plain:true,
			handler:get
		},{
			id:"exportAll",
			text:"导出",
			iconCls:"icon-hmresExport",
			plain:true,
			handler:exportAll}];
			
	var columns=[[
			<#list commonList as field>
			{
				title : '${field.comment}',
				<#assign colName=func.convertUnderLine(field.columnName)>
				<#assign colDbType=func.getJdbcType(field.colDbType)>
				field : '${colName}',
				halign:'center',
				align:'left',
				width:100,
				<#if (colDbType=="NUMERIC")>
				editor:{type:'numberbox',options:{precision:2}}
				<#elseif (colDbType=="VARCHAR")>
				editor:'text'
				<#elseif (colDbType=="CLOB")>
				editor:'blobedit'
				<#elseif (colDbType=="DATE")>
				editor:{
					type:'databoxMy97',
					options:{
		              	dateFmt:'yyyy-MM-dd',
		              	realDateFmt:'yyyy-MM-dd'
	            	}
	            }
		        <#else>
				 editor: {
		            type: 'text'
		         } 
		         </#if>
			}<#if field_has_next>,</#if>
			</#list>
		]];
		//查询条件
		var queryParam={
			
		};
		 //datagrid配置	 
	    var options = {
	             url:"<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/getDatagridList.ht",
	             queryParams:queryParam,
	             title:'',//表格标题
	             height:'auto',
	             rowStyler:setRowStyle,
	             nameArray:{'modify':'编辑'},
	             toolbarCancel:false,
				 toolbarSave:false,
				 appendHandler:add,//新增行函数
				 modifyHandler:edit,//修改行函数
				 deleteHandler:del,//删除行函数
	             checkbox:false,
	             columns:cols,//表格列配置
	             pagination:true,
	             pageSize:10,
	             border:false,
	             fit:true,
	             useDefaultToolbar:true,
	             customButtons:buttons,
	             defaultSelectFirstRow:false,
	             onSelect:onSelect,
	             onLoadSuccess:function(){
	             		//单元格提示
	             		$('#${classVar}Table').datagridTip({fieldArray:["remark"]});
	             		
	             	/*	var rows = $('#rAttendHolyAppTable').datagrid("getRows");
	             		if(rows&&rows.length>0){
	             				$("#rAttendHolyAppTable").datagrid('selectRow',0);
	             		}else{
	             			loadTaskOptions();
	             		}*/
	             	}
	             };
	   		$('#${classVar}Table').datagridPlugin(options);
	}
	
	//TODO:当前数据状态Formatter 自己添加到上面列里面
	function dataStatusFormatter(value, rowData, rowIndex){
		return dataStatusDic[value];
	}
	
	//设置行样式
 	function setRowStyle(index,row){
 		if (row.dataStatus=="new"){
			return 'color:#000000;';
		}else if(row.dataStatus=="waitCheck"){
			return 'color:#336699;';
		}else if(row.dataStatus=="checkPass"){
			return 'color:#999999;';
		}else if(row.dataStatus=="abort"){
			return 'color:#FF9933;';
		}
 	}
 	
 	
	
	//启动流程
	function startFlow(id){
		if(typeof id !='string'){//object类型,说明是菜单handler的event事件
			var row=$("#${classVar}Table").datagrid('getSelected');
			if(row){
				if(row.runId&&row.dataStatus!='abort'){
					showAlertMsg("已经启动的流程不能再次启动!");return;
				}else{
					id=row.id;
				}
			}
		}
		$("#excMask").show();
		$.post("run.ht?isList=1&id="+id,function(response){
			var obj = response;
			if (obj.result==1) {
				showSuccess("启动流程成功！");
				$("#${classVar}Table").datagrid("reload");
			} else {
				showAlertMsg(obj.message);
			}
			$("#excMask").hide();
		},'json');
	}
	
	//TODO:自己根据页面大小修改width和height  改变  弹出对话框大小
	function _showModalDialog(url){
			var width=800;
			var	height=540;
			var obj = new Object();
			var winArgs="dialogWidth:"+width+"px;dialogHeight:"+height+"px;help:0;status:0;scroll:1;center:1;edge:raised;resizable:no;minimize:no;maximize:no;";
			url=url.getNewUrl();
			var rtn=window.showModalDialog(url,obj,winArgs); 
			return rtn;
	}
	//添加
	function add(){
 		var url="";
 		url+="<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/edit.ht?defId="+defId;
		var rtn=_showModalDialog(url); 
		if(rtn&&rtn.type==1){
			showSuccess(rtn.message);
			//刷新主表
			$("#${classVar}Table").datagrid("reload")			
		}
	}
	//修改
	function edit(){
		var rowData=$("#${classVar}Table").datagrid('getSelected');
		if(!rowData){
			showAlertMsg("请选择要修改的行！");return;
		}
		
		if(rowData.runId=='0'||rowData.dataStatus=='abort'){
				//openDialogHandler('edit',id);
				var url="";
		 		url="<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/edit.ht?id="+rowData.id;
			    var rtn=_showModalDialog(url); 
				if(rtn&&rtn.type==1){
					showSuccess(rtn.message);
					//刷新主表
					$("#${classVar}Table").datagrid("reload")			
				}
		}else{
			showAlertMsg("已经启动的不能修改！");
		}
	}
	//查看记录详情
	function get(rowIndex,rowData){
		var rowData=$("#${classVar}Table").datagrid('getSelected');
		if(rowData){
			//openDialogHandler('get',rowData.id);
			var url="<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/edit.ht?id="+rowData.id+"&ifDetail=true";
			var rtn=_showModalDialog(url);
			if(rtn&&rtn.type==1){
				showSuccess(rtn.message);
				//刷新主表
				$("#${classVar}Table").datagrid("reload")			
			}
		}else{
			showAlertMsg("请先选择要查看的记录！");
		}
	}
	//删除验证
	function del(){
		var rowData=$("#${classVar}Table").datagrid('getSelected');
		if(rowData){
			var id=rowData.id;
			if(rowData.runId=='0'){
				$.messager.confirm('确认对话框', '确定要删除吗？', function(r){
					if(r){
						var params = {
									id:id,
									deleteFormRecord:true
								    };
						delWithRun(params);	
					}
				});	
			}else{
					if(rowData.dataStatus=='abort'){//已经终止流程
					$.messager.confirm('确认对话框', '确定要删除吗？', function(r){
					if(r){
						var params = {
									id:id,
									deleteFormRecord:true
								    };
						delWithRun(params);	
					 }
					});
				}else{
					showAlertMsg("已经启动的流程不能删除！请先终止流程!");
				}
			}
		}else{
			showAlertMsg("请先选择要删除的行！");
		}		
	}
	//执行删除请求
	function delWithRun(params){
			$("#excMask").show();
			var url = "<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/delWithProcessRunById.ht";
			$.post(url,params,function(res){
						$("#excMask").hide();
						if(res.result==1){
							showSuccess(res.message);
							//刷新主表
							//loadDatagrid();
							$("#${classVar}Table").datagrid("reload");
						}
						else{
							showAlertMsg("删除失败!"+res.message);
						}
			},'json');
	}
	
	//显示流程图
	function showFlowImg(){
		var rowData=$("#${classVar}Table").datagrid('getSelected');
		if(rowData){
			var url="";
			if(rowData.runId!='0'){
				url ="<#noparse>${ctx}</#noparse>/platform/bpm/processRun/processImage.ht?runId="+rowData.runId+"&r="+Math.random();
				//openDialogHandler('showFlowImg',rowData.runId);
			}else{
				if(rowData.defId!='0'){
					url ="<#noparse>${ctx}</#noparse>/platform/bpm/bpmDefinition/nodeSet.ht?defId="+rowData.defId+"&READONLY=T&r="+Math.random();
				}else{
					showAlertMsg("找不到流程定义!");
				}
				//showAlertMsg("请选择已经启动的流程！");
			}
			var rtn=_showModalDialog(url); 
		}else{
			showAlertMsg("请先选择要查看的记录！");
		}
	}
	//终止流程验证
	function endFlow(){
		var rowData=$("#${classVar}Table").datagrid('getSelected');
		if(rowData){
			var id=rowData.id;
			if(rowData.runId!='0'){
				isTaskEnd(endTask,rowData.runId);
			}else{
				showAlertMsg("请选择已经启动的流程！");
			}
		}else{
			showAlertMsg("请先选择要终止的流程！");
		}		
	}
	//弹出终止流程原因对话框
	 function isTaskEnd(callBack,runIdParam){
			var url="<#noparse>${ctx}</#noparse>/platform/bpm/task/getCurrentActivityTaskByRunId.ht";//获取活动节点id
			var params={runId:runIdParam};
			$("#excMask").show();
			$.post(url,params,function(data){
				if(data&&data.length>0){
						var url="<#noparse>${ctx}</#noparse>/platform/bpm/task/isTaskExsit.ht";
						var params={taskId:data[0]};//只结束一个
						$.post(url,params,function(res){
							$("#excMask").hide();
							if(res.result==1){
								callBack(params["taskId"]);
							}
							else{
								showAlertMsg("这个任务已经完成或被终止了!");
								$("#excMask").hide();
							}
						},'json');
				}else{
					showAlertMsg("该流程不存在活动的任务！");
					$("#excMask").hide();
				}
			},'json');
		}
		
		//发送请求终止流程。
		function endTask(taskId){
			var url=__ctx + "/platform/bpm/task/toStartEnd.ht";
			_showModalDialog(url,function(rtn){
				if(rtn&&rtn["option"]){
					var url=__ctx+"/platform/bpm/task/endProcess.ht?taskId="+taskId;
					var params={taskId:taskId,memo:rtn["option"]};
					$("#excMask").show();
					$.post(url,params,function(obj){
						$("#excMask").hide();
						if(obj.result!=1){
							showAlertMsg("终止任务失败!"+obj.message);
							return;
						}
						showSuccess("终止任务成功!");
						updateDataState();
						handJumpOrClose();
					},'json');	
				}else{
					$("#excMask").hide();
				}
			},480,255); 
		}
		//终止流程后更新表单记录状态
		function updateDataState(){
			var rowData=$("#${classVar}Table").datagrid('getSelected');
			if(rowData){
				var idparam=rowData.id;
				$("#excMask").show();
				$.ajax({
					type:'post',
					url:'<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/updateStatueById.ht',
					data:{id:idparam,dataStatus:'abort'},
					async:false,
					dataType:'json',
					success:function(data){
						$("#excMask").hide();
							if(data&&(data.result==1)){
								showSuccess("终止任务成功!");
							}else{
								showAlertMsg(obj.message);
							}
						}
				});
			}
		}
		//终止后刷新表单
		function handJumpOrClose(){
			if(window.opener){
				try{
					window.opener.location.href=window.opener.location.href.getNewUrl();
				}
				catch(e){}
			}	
			window.close();
			//刷新主表
			$("#${classVar}Table").datagrid("reload");
		}
	
	
		
	function onSelect(){
		var rowData = $('#${classVar}Table').datagrid('getSelected');
		if(rowData==null){
			runId=0;
		}else{
			runId=rowData.runId;
		}
		loadTaskOptions(runId);
	}	
 	/**
 * 审批历史
 */
function loadTaskOptions(runId){
	var params = {runId:runId};
	if(runId==0||runId==''||!runId){
		params["opinionId"]=-1;
	}
	
	var columns=[[
	              {field:'id',hidden:true},
	              {title:'环节名称',field:'taskName',halign:'center',align:'left',width:100},
		 		  {title:'开始时间',field:'startTime',halign:'center',align:'left',width:150},
	              {title:'结束时间',field:'endTime',halign:'center',align:'left',width:150},
	              {title:'处理时长',field:'durTime',halign:'center',align:'left',width:120,formatter:dealTimeFormatter},
	              {title:'执行人',field:'exeFullname',halign:'center',align:'left',width:100},
	              {title:'审批意见',field:'opinion',halign:'center',align:'left',width:250},
	              {title:'审批状态',field:'checkStatus',halign:'center',align:'left',width:120,formatter:function(value,row){
						return checkStatus[value];
					} }
	              ]];
	var options={
			url:'<#noparse>${ctx}</#noparse>/platform/bpm/taskOpinion/getTaskOpinions.ht',
			queryParams:params,
			title:'审批记录',
			useDefaultToolbar:false,
			columns:columns,
			checkbox:false,
			rownumbers : true,
			singleSelect : true,
			checkOnSelect : true,
			selectOnCheck : false,
			pagination : true,
			pageSize :5,
			fit:true
	};
	$('#taskOpinion').datagridPlugin(options);
}

function dealTimeFormatter(value,row,index){
		if(value==null){
			return "";
		}
		var day=Math.floor(value/(24*60*60*1000));
		var ho='';
		var mi='';
		if(day>0){
			ho=Math.floor((value-(24*60*60*1000*day))/(60*60*1000));
			if(ho>0){
				mi=Math.floor((value-(24*60*60*1000*day)-(60*60*1000*ho))/(60*1000));
			}else{
				mi=Math.floor((value-(24*60*60*1000*day))/(60*1000));
			}
		}else{
			ho=Math.floor(value/(60*60*1000));
			if(ho>0){
				mi=Math.floor((value-(60*60*1000*ho))/(60*1000));
			}else{
				mi=Math.floor(value/(60*1000));
			}
		}
		if(day>0){
			day+='天';
		}else{
			day='';
		}
		if(ho>0){
			ho+='小时';
		}else{
			ho='';
		}
		if(mi>0){
			mi+='分钟';
		}else{
			mi='0分钟';
		}
		return day+ho+mi;
		}
		
	//TODO:流程信息导出统一找赵敏添加
	//导出  
	/*function exportAll(){
		$("#divExportAll").show();	
		$('#divExportAll').dialog({ 
			iconCls:'icon-tip',
			title:"导出数据",
			top:20,
			width: 280,    
			height: 100,    
			closed: false,    
			cache: false,    
			modal: true
		});	
	}
	function exportInfo(){
		var path = "<#noparse>${ctx}</#noparse>/isunlandUI/orgAndAuthority/standard/FlowWordApp/cExpAppTemplate/";
		var tname="exportWord.ht";
			
		var value="";
		$("input[name='radioType']").each(function(i){
			var obj=$("#"+this.id);
			if (obj.attr("checked")=="checked"){
				value=this.value;
			}
		});	
		switch(value){
			case "1":
				// tname="downloadExcel.ht";
				break;
			case "2":
				tname="exportWord.ht";
				break;
			case "3":
				tname="exportPdf.ht";
				break;
		}
		var rowData=$('#rAttendHolyAppTable').datagrid('getSelected');
		if(rowData){
			var url = path+tname;
			$("#form_id").val(rowData.id);
			$("#form_runId").val(rowData.runId);
			//$("#form_defkey").val('holiday_'+memberCode);
			$("#form_serviceId").val('imshr_holiday_endNode');
			var form = document.getElementById("iconForm");
			form.action=url;
			form.submit();
		}else{
			showAlertMsg("请先选择需要导出的记录！");
		}
	}*/
</script>
</head>
	<body>
		<div class="easyui-layout" data-options="fit:true,border:false">
			<div data-options="region:'north',split:false,border:true" style="background-color:#f2f5fc;width:100%;height:36px">
				<table style="padding-top:3px;padding-bottom:1px;">
					<!--TODO:查询条件区域 自己写查询条件-->
					<tr><td>查询条件区域 自己写查询条件</td>
						<td class="column-text" style="width:auto;">
							登记日期:
						</td>
						<td class="column-input" style="width:auto;">
							<input id="txtPlanBeginTime" class="easyui-datebox" style="width:100px" data-options="editable:false" /> 至 <input id="txtPlanEndTime" class="easyui-datebox" style="width:100px" data-options="editable:false,onSelect:onQueryEndSelect" />
						</td>
						<td class="column-text" style=" width: auto;">
							<input  style='display:none;' type=checkbox checked='checked'  id="dataStatusCheckbox">
							数据状态:
						</td>
						<td class="column-input" style="width: auto;">
							<input  id="dataStatusCombox" style="width: 100px">
						</td>
						<td class="column-text" style=" width: auto;">
							<input style='display:none;'  type=checkbox checked='checked'  id="ifLaterWriteCheckbox">
							是否补填:
						</td>
						<td class="column-input" style="width: 30px;">
							<input  id="ifLaterWriteCombox" style="width: 30px">
						</td>
						<td style='display:none;' class="column-text" style=" width: auto;">
							<input type=checkbox   id="deptCheckBox" >
							所属部门:
						</td>
						<td style='display:none;' class="column-input" style="width: auto;">
							<input id="dept_searchbox" class="selectfdj input_text_readOnly" onclick="">
							<input type="hidden" id="deptCode">
						</td>
						<td class="column-text" style="width: auto;">
							<input type="button"  onclick="loadDatagrid()" value="查 询" class="btn_cls_common" data-options="iconCls:'icon-search',plain:true"/>
						</td>
					</tr>
				</table>
			</div>
		  	<div data-options="region:'center',border:false,split:true" style="background-color:#f2f5fc;width:100%;">
				<table id="${classVar}Table"></table>
			</div>
			<div data-options="region:'south',border:false,split:true" style="height:200px;background-color:#f2f5fc;width:100%;">
				<table id="taskOpinion"></table>
			</div>
			<div id='excMask' style="display:none;" class='mainLoading'><span style="top:30%; left:40%;"></span><img src='<#noparse>${ctx}</#noparse>/styles/default/images/loading.gif'></div>
		</div>
		<div>
			<form id="iconForm" name="iconForm" method="post" enctype="multipart/form-data">
				<input type="hidden" id="form_id" name="appId" />	
				<input type="hidden" id="form_runId" name="runId" />
				<input type="hidden" id="form_title" name="title" value="${comment}" />
				<input type="hidden" id="form_serviceId" name="serviceId" />	
			</form>	
		</div>
		<div id="divExportAll" style="display: none">
			<table border="0" width="100%" style="text-align:left; margin-top:20px;">
				<tr>
					<td class="column-text" noWrap=true style="width:60px;">
						导出方式:
					</td>
					<td class="column-input" style="width:150px;">
						<!-- <input type="radio" id="radioType1" name="radioType" value="1" checked="checked" /><span id="spanKind1" style="vertical-align:middle; width:80px;">excel</span> -->
						<input type="radio" id="radioType2" name="radioType" value="2" checked="checked" /><span id="spanKind2" style="vertical-align:middle; width:80px;">word</span>
						<input type="radio" id="radioType3" name="radioType" value="3" /><span id="spanKind3" style="vertical-align:middle; width:80px;">pdf</span>
					</td>
					<td noWrap=true style="text-align:left;">
						<input type="button"  onclick="exportInfo()" value="导 出" class="btn_cls_common"/>	
					</td>
				</tr>
			</table>	
		</div>
	</body>

</html>


