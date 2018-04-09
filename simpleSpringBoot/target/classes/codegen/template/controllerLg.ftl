<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign classVar=model.variables.classVar>
<#assign system=vars.system>
<#assign comment=model.tabComment>
<#assign commonList=model.commonList>
<#assign subtables=model.subTableList>
<#assign classVar=model.variables.classVar>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >

<#-- 信普达  wzh 2014-01-20 begin -->
 package isunlandSrc.${vars.projectName}.${system}.controller.${package}; 
<#-- 信普达  wzh 2014-01-20 end   -->

<#--  平台默认  wzh 2014-01-20
 package com.hotent.${system}.controller.${package};  -->
 
 
import java.util.HashMap;
import java.util.Map;
import java.io.PrintWriter;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.hotent.core.annotion.Action;
import org.springframework.web.servlet.ModelAndView;
import com.hotent.core.util.BeanUtils;
import com.hotent.core.util.UniqueIdUtil;
import com.hotent.core.util.ContextUtil;
import com.hotent.core.web.util.RequestUtil;
import com.hotent.core.web.controller.BaseController;
import com.hotent.core.web.query.QueryFilter;
import com.hotent.core.util.StringUtil;

import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONObject;
import net.sf.json.util.JSONUtils;
import com.hotent.core.util.StringUtil;

<#--
  平台默认  wzh 2014-01-20
 import com.hotent.${system}.model.${package}.${class};
 import com.hotent.${system}.service.${package}.${class}Service;
-->
 
 <#-- 信普达  wzh 2014-01-20 BEGIN  -->
	import isunlandSrc.${vars.projectName}.${system}.model.${package}.${class};
	import isunlandSrc.${vars.projectName}.${system}.service.${package}.${class}Service;
 <#-- 信普达  wzh 2014-01-20 END  -->
  
<#if subtables?exists && subtables?size != 0>
	<#list subtables as table>
	 <#--
		 平台默认  wzh 2014-01-20
		 import com.hotent.${system}.model.${table.variables.package}.${table.variables.class};
		 -->
		 
		<#-- 信普达  wzh 2014-01-20 BEGIN -->
			 import isunlandSrc.${vars.projectName}.${system}.model.${table.variables.package}.${table.variables.class};
		<#-- 信普达  wzh 2014-01-20 END -->
	</#list>
</#if>
import com.hotent.core.web.ResultMessage;
<#if model.variables.flowKey?exists>
import com.hotent.platform.model.bpm.ProcessRun;
import com.hotent.platform.service.bpm.ProcessRunService;
import com.hotent.core.bpm.model.ProcessCmd;
</#if>
/**
 *<pre>
 * 对象功能:${comment} 控制器类
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 *</pre>
 */
@Controller
<#-- 信普达  wzh 2014-01-20 BEGIN -->
@RequestMapping("/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/")
<#-- 信普达  wzh 2014-01-20 END -->

public class ${class}Controller extends BaseController
{
	@Resource
	private ${class}Service ${classVar}Service;
	<#if model.variables.flowKey?exists>
	@Resource
	private ProcessRunService processRunService;
	</#if>
	
	<#--直接绑定工作流生成-->
	<#if model.variables.flowKey?exists>
	private final String flowKey = "${model.variables.flowKey}";	//绑定流程定义
	</#if>
	
	/**
	 * 添加或更新${comment}。
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("save")
	@Action(description="添加或更新或删除${comment}")  
	public void save(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String insertedJson = RequestUtil.getString(request, "inserted",false);
	    String updatedJson = RequestUtil.getString(request, "updated",false);
	    String deletedJson = RequestUtil.getString(request, "deleted",false);
	    List<${class}> insertedList=null,updatedList=null,deletedList=null;
		try{
		    if(StringUtil.isNotEmpty(insertedJson)){
		    	insertedList=binder.toBeanList(insertedJson, ${class}.class);
	        }
	        if(StringUtil.isNotEmpty(updatedJson)){
	        	updatedList=binder.toBeanList(updatedJson, ${class}.class);
	        }  
	        if(StringUtil.isNotEmpty(deletedJson)){
	        	deletedList=binder.toBeanList(deletedJson, ${class}.class);
	        }
	       ${classVar}Service.saveBatch(insertedList, updatedList, deletedList);
			writeResultMessage(response.getWriter(),"保存成功！",ResultMessage.Success);
		}catch(Exception e){
			writeResultMessage(response.getWriter(),"保存失败,"+e.getMessage(),ResultMessage.Fail);
		}
		
		
	}
	
	
	/**
	 * 取得${comment}分页列表
	 * @param request
	 * @param response
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getList")
	@Action(description="查看${comment}分页列表")
	public void getList(HttpServletRequest request,HttpServletResponse response) throws Exception
	{	
		QueryFilter  queryFilter=new QueryFilter(request,true);
		List<${class}> list=${classVar}Service.getAll(queryFilter);
		sendGridJsonToWebJackson(list,response,queryFilter);  
	}
	
	
	/**
	 * 取得${comment}列表不分页
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getListNoPaging")
	@Action(description="查看${comment}列表不分页")
	public void getListNoPaging(HttpServletRequest request,HttpServletResponse response) throws Exception
	{	
		QueryFilter  queryFilter=new QueryFilter(request,false);
		List<${class}> list=${classVar}Service.getAll(queryFilter);
		sendGridJsonToWebJackson(list,response);  
	}
	
	
	
}
