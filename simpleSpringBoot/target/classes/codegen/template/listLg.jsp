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
<%@include file="/js/lg/getLg.jsp"%>
<script type="text/javascript">
$(function(){
	//动态添加 columns
	var columns=[
		<#list commonList as field>
		{
			display : '${field.comment}',
			<#assign colName=func.convertUnderLine(field.columnName)>
			<#assign colDbType=func.getJdbcType(field.colDbType)>
			name : '${colName}',
			<#if (colDbType=="NUMERIC")>
			type : 'int',
			isSort : true,
			editor: {
	            type: 'int'
	        } 
			<#elseif (colDbType=="VARCHAR")>
			type : 'text',
			isSort : true,
			editor: {
	            type: 'text'
	        } 
			<#elseif (colDbType=="CLOB")>
			type : 'text',
			isSort : true,
			editor: {
	            type: 'textarea',
	            height:100
	        }
			<#elseif (colDbType=="DATE")>
			type : 'date',
			isSort : true,
			format : "yyyy-MM-dd",
			editor: {
	            type: 'date'
	        }
			<#elseif (colDbType=="TIMESTAMP")>
			type : 'date',
			isSort : true,
			format : "yyyy-MM-dd hh:mm:ss",
			editor: {
	            type: 'date',
	            ext:{showTime:true}
	        }
	        <#else>
	         type : 'text',
	         isSort : true,
			 editor: {
	            type: 'text'
	         } 
	         </#if>
		}<#if field_has_next>,</#if>
		</#list>
	];
	LigerGridPlugin.initData({"columns":columns,"innerEdit":false,"needToolbar":true});

});
</script>
<#if model.variables.flowKey?exists>
<script type="text/javascript">
	function startFlow(id){
		$.post("run.ht?isList=1&${pkVar}="+id,function(responseText){
			var obj = new com.hotent.form.ResultMessage(responseText);
			if (obj.isSuccess()) {
				$.ligerDialog.success("启动流程成功！", "成功", function(rtn) {
					if(rtn){
						this.close();
					}
					window.location.href = "<#noparse>${ctx}</#noparse>/${system}/${package}/${classVar}/list.ht";
				});
			} else {
				$.ligerDialog.error(obj.getMessage(),"提示信息");
			}
		});
	}
</script>
</#if>
</head>
<body>
	<div class="panel">
		<div class="panel-top">
			<div class="tbar-title">
				<span class="tbar-label">${comment }管理列表</span>
			</div>
			<div class="panel-toolbar">
				<div class="toolBar">
					<div class="groupUI"><a class="link search" id="btnSearch"><span></span>查询</a></div>
					<div class="l-bar-separator"></div>
					<div class="groupUI"><a class="link add" action="edit.ht"><span></span>添加</a></div>
					<div class="l-bar-separator"></div>
					<div class="groupUI"><a class="link update" id="btnUpd" action="edit.ht"><span></span>修改</a></div>
					<#if !model.variables.flowKey?exists>
					<div class="l-bar-separator"></div>
					<div class="groupUI"><a class="link del"  action="del.ht"><span></span>删除</a></div>
					</#if>
					<div class="l-bar-separator"></div>
					<div class="groupUI"><a class="link saveAll" title="批量保存"><span></span>保存</a></div>
				</div>	
			</div>
			<div class="panel-search">
				<form id="searchForm" method="post" action="getList.ht">
					<div class="row">
						<#list commonList as col>
						<#assign colName=func.convertUnderLine(col.columnName)>
						<#if (col.colType=="java.util.Date")>
						<span class="label">${col.comment} 从:</span> <input  name="Q_begin${colName}_${func.getDataType("Date","1")}"  class="inputText date" />
						<span class="label">至: </span><input  name="Q_end${colName}_${func.getDataType("Date","0")}" class="inputText date" />
						<#else>
						<span class="label">${col.comment}:</span><input type="text" name="Q_${colName}_${func.getDataType("${col.colType}","0")}"  class="inputText" />
						</#if>
						</#list>
					</div>
				</form>
			</div>
		</div>
		<div class="panel-body">
	    	<div id="grid" style="PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; PADDING-TOP: 0px"></div>
		</div><!-- end of panel-body -->	
	</div>
</body>
</html>


