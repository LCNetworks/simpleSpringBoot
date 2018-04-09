<#import "function.ftl" as func>
<#assign class=model.variables.class>
<#assign tabcomment=model.tabComment>
<#assign classVar=model.variables.classVar>
<#assign system=vars.system>
<#assign package=model.variables.package>
<#assign commonList=model.commonList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >
<#assign subtables=model.subTableList>
<%--
	time:${date?string("yyyy-MM-dd HH:mm:ss")}
	desc:edit the ${tabcomment}
--%>
<%@page language="java" pageEncoding="UTF-8"%>
<%@include file="/commons/include/html_doctype.html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="f" uri="http://www.jee-soft.cn/functions" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="<#noparse>${pageContext.request.contextPath}</#noparse>" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<%@ include file="/commons/include/getUserInfo.jsp"%>
<html>
<head>
	<title>编辑 ${tabcomment}</title>
<script type="text/javascript" >
	//设置ContextPath	
	var __ctx='<%=request.getContextPath()%>';
	var __jsessionId='<%=session.getId() %>';
</script>
<#noparse>
<style type='text/css'>
	.mainLoading{
		color:white;		
		position: absolute;
		top: 0%;
		left: 0%;
		width: 100%;
		height: 100%;
		background-color: #f9f9f9;
		z-index: 9997;
		-moz-opacity: 0.99;
		opacity: .99;
		filter: alpha(opacity = 99);
	}
	.mainLoading img{
		width: 32px;
		height: 32px;
		z-index: 9998;
		top: 30%;
		left: 40%;
		position: absolute;
		-moz-opacity: 0.9;
		opacity: .9;
		filter: alpha(opacity = 9);
	}
	.mainLoading span{
		color:black;
		font-style:normal;
		 font-weight:bolder ;
		font-size:1.2em;
		width: 180px;
		height: 30px;
		z-index: 9999;
		top: 30%;
		left: 10%;
		position: absolute;
		-moz-opacity: 0.99;
		opacity: .99;
		filter: alpha(opacity = 99);
		color:#666666;
	}
	
	.input_loading{
		background: #fff url(${ctx}/js/easyui/themes/loading/20141023034812548.gif) repeat-x left;
		cursor: pointer;
		border: 1px solid #d3d3d3;
		
		height: 19px;
	}
	div.panel-body{
		margin: 0px;
	}
	.actTr{
		display:none;
	}
	.actTrShow{
		display:table-row;
	}
	</style>

	<f:link href="web.css" ></f:link>
	<script type="text/javascript" src="${ctx}/js/jquery/jquery1_7_2.js"></script>
	<script type="text/javascript" src="${ctx}/js/hotent/formdata.js"></script>
	<script type="text/javascript" src="${ctx}/js/hotent/subform.js"></script>
	<script type="text/javascript" src="${ctx}/js/jquery/jquery.form.js"></script>
	<script type="text/javascript" src="${ctx}/js/jquery/jquery.validate.min.js"></script>
	<script type="text/javascript" src="${ctx}/js/isunlandBLL/comm/ajaxExt.js"></script>
	<script type="text/javascript" src="${ctx}/js/isunlandBLL/comm/pageUtil.js"></script>
	<script type="text/javascript" src="${ctx}/js/util/util.js"></script>
	<script type="text/javascript" src="${ctx}/js/hotent/platform/bpm/FlowDetailWindow.js"></script>
	<!--baseEasyUi引入-->
	<link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/gray/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/js/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/js/isunlandBLL/comm/css/isunlandcommon.css" >
	<script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.min.js" ></script>
	<script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.patch.js" ></script>
	<script type="text/javascript" src="${ctx}/js/easyui/jquery.easyui.ext.js" ></script>
	<script type="text/javascript" src="${ctx}/js/util/json2.js"></script>
	<script type="text/javascript" src="${ctx}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script language="javascript" type="text/javascript" src="${ctx}/js/calendar/My97DatePicker/WdatePicker.js"></script>		
	<!--以上内容不用改动-->
</#noparse>
	<script type="text/javascript">
		var res = {type:0,message:""};
	 	window.returnValue=res;
		var configFromDb='<%=si.getFlowTaskEditableConfig("${model.variables.flowKey}")%>';
		var json_configFromDb=$.parseJSON(configFromDb);
		var  ifDetail = <#noparse>${ifDetail}</#noparse>;//是否是详情页面
		var isPop=<#noparse>'${isPop}'</#noparse>;
		
		//定义全局页面可编辑配置(用于从数据库中读取页面字段可编辑配置信息) 和按钮的显示
		//TODO:自己按照页面字段可编辑需要控制
		var editConfig = {
			undefined:{//第一次点添加时,当前节点为空,未定义 不用改
				canEditAll:true,//canEditAll为true代表全部可输入框可编辑,为false代表全部不可以编辑。
				editorOpen:[],//可编辑字段数组
				buttonHideCls:[]//需要隐藏的按钮
			}
			//TODO:流程图中的环节
			/*,
			applyWrite:{
				canEditAll:true,//canEditAll为true代表全部可输入框可编辑,为false代表全部不可以编辑。
				editorOpen:[],//可编辑字段数组 'panHolyNum','planHolyDays','actHolyNum','actHolyDays','accessoryName'
				buttonHideCls:['run','start','detail','back']//需要隐藏的按钮
			},
			checkDept:{
				canEditAll:false,
				editorOpen:[],
				buttonHideCls:['run','start','save','detail','back']//需要隐藏的按钮
			},
			checkSecondDept:{
				canEditAll:false,
				editorOpen:[],
				buttonHideCls:['run','start','save','detail','back']//需要隐藏的按钮
			},
			applyDestory:{
				canEditAll:false,
				editorOpen:['AWStart','AWEnd'],
				buttonHideCls:['run','start','detail','back']//需要隐藏的按钮
			},
			approveDept:{
				canEditAll:false,
				editorOpen:[],
				buttonHideCls:['run','start','save','detail','back']//需要隐藏的按钮
			}*/
		};
		editConfig = $.extend({},editConfig,json_configFromDb);
		//获取父页面tasktostart.jsp中当前打开节点流程
		var curTask = window.parent.taskDefinitionKey;
		if(!curTask){
			curTask='undefined';
		}
		var disableAll = window.parent.disableAll;
		if(<#noparse>${ifDetail}</#noparse>){
			disableAll = <#noparse>${ifDetail}</#noparse>
		}
		//如果是processinfo页面,根据传的变量disableAll禁用所有
		if(disableAll){
			if(editConfig){
				for(var item in editConfig){
					if(editConfig[item]){
						editConfig[item].canEditAll = false;
						if(editConfig[item].editorOpen){
							editConfig[item].editorOpen.length=0;
						}
					}
				}
			}
		}
		
		
		var memberCode = '<%=si.getCurrentMemberCode()%>';
		var memberName = '<%=si.getCurrentMemberName()%>';
		var jobNo = '<%=si.getCurrentJobNo()%>';
		var userName = '<%=si.getCurrentName()%>';
		var deptCode='<%=si.getCurrentDeptCode()%>';
		var deptName='<%=si.getCurrentDeptName()%>';
		var taskStatus = <%=si.getTaskStatus(0)%>;
		
		$(function() {
			$("a.save").click(function() {
				$("#${classVar}Form").attr("action","save.ht");
				submitForm();
			});
			$("a.run").click(function() {
					//TODO:做一些提交前表单数据验证
							
				
					if($(this).hasClass("start")){
						var param = $("#${classVar}Form").serializeArray();
						param.push({name:'isList',value:1});
						$("#excMask").show();
						$.post("run.ht",param,function(response){
							$("#excMask").hide();
							var obj = response;
							if (obj.result==1) {
								showSuccess("启动流程成功！");
								res.message="启动流程成功！";
								res.type=1;
								window.close();
							} else {
								showAlertMsg(obj.message);
							}
						},'json');
						
					}else{
						$("#${classVar}Form").attr("action","run.ht");
						submitForm();
					}
			});
			
			//数据初始化
			initBasedata();
			
			//字段是否可编辑初始化
			initCanEdit();
		})
		
		//TODO:做一些combox等需要的初始化
		function initBasedata(){
		
		}
		
		//字段是否可编辑初始化
		function initCanEdit(){
			if(!curTask){
				alert("无法确定当前执行task节点！");
				return;
			}
			if(editConfig&&editConfig[curTask]){
				//先禁掉全部可编辑
				//TODO:类似与下方 自己根据页面字段,禁用掉所有编辑框的可编辑性 包括去掉事件
			/*	if(!(editConfig[curTask].canEditAll)){//所有字段不可编辑
					
					//$("#holidayKindCode").combo('disable');  //尽量不要用disable,会导致form表单提交数据时,disable数据丢失
					$('#holidayKindCode').combo('readonly', true); //用readonly
					$("#overtimeReason").attr('readonly','readonly');
					$("#ifLaterWrite").removeAttr('onclick');
					$("#ifLaterWrite").unbind('click').bind('click',function(){return false;});//对于有点击事件的,把点击事件去掉
					$("#ifUserCheck").unbind('click').bind('click',function(){return false;});
					$("#WStart").attr('disabled','disabled');
					$("#WEnd").attr('disabled','disabled');	
					$("#AWStart").attr('disabled','disabled');
					$("#AWEnd").attr('disabled','disabled');	
					
					$("#actHolyNum").attr('readonly','readonly');
					$("#actHolyDays").attr('readonly','readonly');
					$("#panHolyNum").attr('readonly','readonly');
					$("#planHolyDays").attr('readonly','readonly');
				}*/
				
				//再根据配置开启可编辑
				if(editConfig[curTask]&&editConfig[curTask].editorOpen){//可编辑字段
					for(var i=0;i<editConfig[curTask].editorOpen.length;i++){
						switch(editConfig[curTask].editorOpen[i]){
							//TODO:自己把页面上所有输入控件变成可编辑
							/*case 'holidayKindCode':
								//$("#holidayKindCode").combo('enable');
								$('#holidayKindCode').combo('readonly', false);
								break;
							case 'overtimeReason':
								$("#overtimeReason").removeAttr('readonly');
								break;
							case 'ifLaterWrite':
								$("#ifLaterWrite").unbind('click');
								$("#ifLaterWrite").attr('onclick','ifLaterWrite_click();');
								break;
							case 'ifUserCheck':
								$("#ifUserCheck").unbind('click');
								break;
							case 'WStart':
								$("#WStart").removeAttr('disabled');
								break;
							case 'WEnd':
								$("#WEnd").removeAttr('disabled');
								break;
							case 'AWStart':
								$("#AWStart").removeAttr('disabled');
								break;
							case 'AWEnd':
								$("#AWEnd").removeAttr('disabled');
								break;
							case 'panHolyNum':
								$("#panHolyNum").removeAttr('readonly');
								break;
							case 'planHolyDays':
								$("#planHolyDays").removeAttr('readonly');
								break;	
							case 'actHolyNum':
								$("#actHolyNum").removeAttr('readonly');
								break;	
							case 'actHolyDays':
								$("#actHolyDays").removeAttr('readonly');
								break;	
							case 'accessoryName':
								$("#attachFile").html("<a style='margin-left:10px;' href='#' onclick=\"downFileHandler()\">"+"重新上传"+"</a>");
								break;*/
						}
					}	
				}
			}
			
			var  btnHideCls = ['run','start','save','detail','back'];
			if(editConfig[curTask]){
				btnHideCls = editConfig[curTask].buttonHideCls;
			}
			
			if((btnHideCls&&btnHideCls.length>0)){
				for(var i=0;i<btnHideCls.length;i++){
					if($("."+btnHideCls[i])){
						$("."+btnHideCls[i]).hide();
					}
				}				
			}
			
			if(disableAll){
				$(".link").not($(".hide-panel").find(".link")).hide();
				if(ifDetail){
						if(isPop&&isPop!=''){
						}else{
							$(".back").show();//如果是详情界面,并且不是弹出模式  显示返回
						}
				}
			}
			
			//如果没有按钮,则直接全部隐藏panel-top
			if($(".panel-top").find("a.link:visible").length==0){
				$(".panel-top").hide();
			}
		}
		
		
		
		
		//提交表单
		function submitForm(){
			//做一些提交前验证
			
			var param = $("#${classVar}Form").serializeArray();
			$("#excMask").show();
			var action = $("#${classVar}Form").attr("action");
			$.post("<#noparse>${ctx}</#noparse>/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/"+action,
				param,
				   function(obj){
				    	if(obj){
				    		if(obj.result==1){
				    			showSuccess("保存成功!");
			    				if(curTask=='undefined'){//如果是添加,那么要返回到list界面.如果是其他追回的,则不返回
									res.message="操作成功！";
		    						res.type=1;
									window.close();
								}
				    		}else if(obj.result==0){
				    			showAlertMsg(obj.message);
				    		}
				    	}
				    	$("#excMask").hide();
				   }, "json");	
		}
		
		
	//回调函数,提交按钮事件 用于配置按钮事件进行验证
	function callBackHandler(){
		/*if($("input.input_loading")&&$("input.input_loading").length>0){
			alert("请等待时间计算完成后再提交!");return false;
		}
		var submitData = {
			id:'<#noparse>${</#noparse>${classVar}.id<#noparse>}</#noparse>',
			actSTime:$("#actSTime").val(),
			actETime:$("#actETime").val(),
			actHolyNum:$("#actHolyNum").val(),
			actHolyDays:$("#actHolyDays").val()
		};
		
		if(!(submitData.actSTime)||!(submitData.actETime)){
			alert("实际时间不能为空!");
			return false;
		}
		var url = "<#noparse>${ctx}</#noparse>/isunlandUI/hrManagement/standard/flowManage/rAttendHolyApp/updateActTimeConfirm.ht";
		//更新数据状态 同步
		var flag=false;//是否更新成功
 		var newOption={
 			data:submitData,
 			async:false,//是否异步,true异步|false同步
            type: "POST",//请求类型"POST"|"GET"
            dataType:'json',//返回数据类型
            url:url,//Url地址
            success:function(data, textStatus, jqXHR){
            	flag=true;	
            },//回调函数
            complete:function(data, textStatus, jqXHR){
            }
 		};
 		
		 $.ajax(newOption);
		 if(!flag){
		 	alert("提交实际时间失败!");
		 }
		return flag;*/
	}
	</script>

<body style="position:absolute;width:100%;height:100%;text-align:center;" align="center">
	<div  style="width:100%;padding-top:20px;margin:0 auto;">
		<div class="panel-top">
			<div class="tbar-title">
			    <c:choose>
				    <c:when test="<#noparse>${</#noparse>${classVar}<#noparse>.id !=null}</#noparse>">
				        <span class="tbar-label"><span></span>编辑${tabcomment}</span>
				    </c:when>
				    <c:otherwise>
				        <span class="tbar-label"><span></span>添加${tabcomment}</span>
				    </c:otherwise>			   
			    </c:choose>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="group"><a class="link save" id="dataFormSave" href="#"><span></span>保存</a></div>
					<div class="l-bar-separator"></div>
					<c:if test="<#noparse>${runId==0}</#noparse>">
					<c:choose>
						<c:when test="<#noparse>${defId==0}</#noparse>">
							<div class="group"><a class="link run"  href="#"><span></span>启动流程</a></div>
							<div class="l-bar-separator"></div>
						</c:when>
						<c:otherwise>
							<div class="group"><a class="link run start"  href="#"><span></span>启动流程</a></div>
							<div class="l-bar-separator"></div>
						</c:otherwise>
					</c:choose>
					</c:if>
					<div class="group"><a class="link back" href="javascript:window.close();"><span></span>关闭</a></div>
				</div>
			</div>
		</div>	
		<div class="panel-body">
			<form id="${classVar}Form" method="post" action="save.ht">
				<table class="table-detail" cellpadding="0" cellspacing="0" type="main">
					<tr  style="height:36px;"><!--TODO:自己根据需要修改表单布局-->
						<td  colspan='2' style='text-align:center;'><span class='caption'>${tabcomment}</span></td>
					</tr>
					<#list commonList as col>
					<#assign colName=func.convertUnderLine(col.columnName)>
					<#if (col.colType=="java.util.Date") >
					<tr>
						<th width="20%">${col.comment}: <#if (col.isNotNull) > <span class="required">*</span></#if></th>
						<td><input type="text" id="${colName}" name="${colName}" value="<fmt:formatDate value='<#noparse>${</#noparse>${classVar}.${colName}}' pattern='yyyy-MM-dd'/>" class="inputText date" validate="{date:true<#if col.isNotNull>,required:true</#if>}" /></td>
					</tr>
					<#else>
					<tr>
						<th width="20%">${col.comment}: <#if (col.isNotNull) > <span class="required">*</span></#if></th>
						<td><input type="text" id="${colName}" name="${colName}" value="<#noparse>${</#noparse>${classVar}.${colName}}"  class="inputText" validate="{<#if col.isNotNull>required:true<#else>required:false</#if><#if col.colType=='String'&& col.length<1000>,maxlength:${col.length}</#if><#if col.colType=='Integer'|| col.colType=='Long'||col.colType=='Float'>,number:true<#if col.scale!=0>,maxDecimalLen:${col.scale}</#if><#if col.precision!=0>,maxIntLen:${col.precision}</#if></#if>}"  /></td>
					</tr>
					</#if>
					</#list>
				</table>
			</form>
		</div>
	</div>
</body>
</html>
