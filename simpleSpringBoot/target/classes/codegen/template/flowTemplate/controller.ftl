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
<#-- 信普达  wzh 2014-01-20 end  package com.hotent.${system}.controller.${package}; -->

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.io.IOException;
import java.util.Map;
import java.util.Date;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.stereotype.Controller;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import com.hotent.core.annotion.Action;
import org.springframework.web.servlet.ModelAndView;
import com.hotent.core.util.AppUtil;
import com.hotent.core.util.BeanUtils;
import com.hotent.core.util.UniqueIdUtil;
import com.hotent.core.util.StringPool;
import com.hotent.core.util.ContextUtil;
import com.hotent.core.web.util.RequestUtil;
import com.hotent.core.web.controller.BaseController;
import com.hotent.core.web.query.QueryFilter;
import com.hotent.core.util.StringUtil;
import com.hotent.core.util.StringUtil;

import isunlandSrc.${vars.projectName}.${system}.model.${package}.${class};
import isunlandSrc.${vars.projectName}.${system}.service.${package}.${class}Service;
import com.hotent.core.web.ResultMessage;
<#if model.variables.flowKey?exists>
import com.hotent.core.bpm.model.NodeCache;
import com.hotent.platform.model.bpm.ProcessRun;
import com.hotent.platform.model.bpm.BpmDefinition;
import com.hotent.platform.service.bpm.ProcessRunService;
import com.hotent.platform.service.bpm.BpmDefinitionService;
import com.hotent.core.bpm.model.ProcessCmd;
import com.hotent.platform.service.bpm.impl.ScriptImpl;
import isunlandSrc.flowInterfaces.IFlowControllerInterface;
</#if>
/**
 *<pre>
 * 对象功能:${vars.comment} 控制器类
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
@RequestMapping("/isunlandUI/${vars.projectName}/${system}/${package}/${classVar}/")
public class ${class}Controller extends BaseController implements IFlowControllerInterface<${class}>
{
	@Resource
	private ${class}Service ${classVar}Service;
	<#if model.variables.flowKey?exists>
	@Resource
	private ProcessRunService processRunService;
	@Resource 
	private BpmDefinitionService bpmDefinitionService;
	</#if>
	
	<#--直接绑定工作流生成-->
	<#if model.variables.flowKey?exists>
	private  String flowKey = "${model.variables.flowKey}";	//绑定流程定义
	</#if>
	
	
	 @ModelAttribute 
	  public void changeFlowKey() {  
		  flowKey = "${model.variables.flowKey}";
		  ScriptImpl sc  = (ScriptImpl) AppUtil.getBean(ScriptImpl.class);
		  String memberCode = sc.getCurrentMemberCode();
		  if(!memberCode.equals("000000")){//超级管理员用原来不加会员编码的
			  //保证流程标识后只有一个会员编码(admin新建流程时流程标识中不能带下划线)
			  	Pattern pt = Pattern.compile("[^_]+_\\d{6}");
				Matcher mt = null;
				mt = pt.matcher(flowKey);
				if(!mt.matches()){
					flowKey=flowKey+"_"+memberCode;
				}
		  }
	  }
	@InitBinder
	protected void initBinder(HttpServletRequest request,ServletRequestDataBinder binder) {
		logger.debug("init rPlanExcSub binder ....");
		binder.registerCustomEditor(Integer.class, null,new CustomNumberEditor(Integer.class, null, true));
		binder.registerCustomEditor(Long.class, null, new CustomNumberEditor(Long.class, null, true));
		binder.registerCustomEditor(byte[].class,new ByteArrayMultipartFileEditor());
		SimpleDateFormat dateFormat = new SimpleDateFormat(StringPool.DATE_FORMAT_DATETIME_NOSECOND);
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, null, new CustomDateEditor(dateFormat, true));
	}
	
	
	
	
	
	/**
	 * 添加或更新${comment}。
	 * @param request
	 * @param response
	 * @param ${classVar} 添加或更新的实体
	 * @param bindResult
	 * @param viewName
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("save")
	@Action(description="添加或更新${comment}")
	public void save(HttpServletRequest request, HttpServletResponse response,${class} ${classVar}) throws Exception
	{
		String resultMsg="失败";		
		try{
			if(${classVar}.get${pkVar?cap_first}()==null||${classVar}.get${pkVar?cap_first}().equals("0")||StringUtil.isEmpty(${classVar}.get${pkVar?cap_first}())){
				${classVar}.set${pkVar?cap_first}(UniqueIdUtil.getGuidRan());
				${classVar}Service.add(${classVar});
				//TODO:此次自己添加其他一些附加字段的信息 做一些添加记录前的校验判断								
				resultMsg=getText("添加","${comment}");
			}else{
				${class} ${classVar}Temp = ${classVar}Service.getById(${classVar}.get${pkVar?cap_first}());
				if(${classVar}Temp==null){//如果查不到,则还是添加
					//TODO:此次自己添加其他一些附加字段的信息 做一些添加记录前的校验判断(抛异常的方式中断添加)		
					resultMsg=getText("添加","请假申请表");
				}else{
					setDefault(${classVar});
					${classVar}Service.update(${classVar});
					resultMsg=getText("更新","${comment}");
				}
			}
			writeResultMessage(response.getWriter(),resultMsg,ResultMessage.Success);
		}catch(Exception e){
			e.printStackTrace();
			writeResultMessage(response.getWriter(),resultMsg+","+e.getMessage(),ResultMessage.Fail);
		}
	}
	
	private void setDefault(${class}  ${classVar}){
		 ${classVar}.setRegDate(new Date());
		ScriptImpl sc = (ScriptImpl)AppUtil.getBean(ScriptImpl.class);
		 ${classVar}.setRegStaffId(sc.getCurrentJobNo());
		 ${classVar}.setRegStaffName(sc.getCurrentName());
		 ${classVar}.setDeptCode(sc.getCurrentDeptCode());
		 ${classVar}.setDeptName(sc.getCurrentDeptName());
		 ${classVar}.setMemberCode(sc.getCurrentMemberCode());
		if(StringUtil.isEmpty( ${classVar}.getDataStatus())){
			 ${classVar}.setDataStatus("new");
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
	@RequestMapping("list")
	@Action(description="查看${comment}分页列表")
	public ModelAndView list(HttpServletRequest request,HttpServletResponse response) throws Exception
	{	
		List<${class}> list=${classVar}Service.getAll(new QueryFilter(request,"${classVar}Item"),flowKey);
		ModelAndView mv=this.getAutoView();
		<#if model.variables.flowKey?exists>
		BpmDefinition bpmDefinition = bpmDefinitionService.getMainByDefKey(flowKey);
		if(BeanUtils.isNotEmpty(bpmDefinition)){
			mv.addObject("defId", bpmDefinition.getDefId());
		}
		</#if>
		mv.addObject("${classVar}List",list);
		return mv;
	}
	
	
	/**
	 * 取得${comment}分页列表
	 * @param request
	 * @param response
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getDatagridList")
	@Action(description="取得${comment}分页列表")
	public void getDatagridList(HttpServletRequest request,HttpServletResponse response) throws Exception
	{	
		
		QueryFilter queryFilter = new QueryFilter(request, true,
				"${classVar}Table", true);
		List<${class}> list=${classVar}Service.getAll(queryFilter,flowKey);
		sendGridJsonToWebJackson(list, response, queryFilter);
	}
	
	
	/**
	 * 删除${comment}及相关流程实例
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("delWithProcessRunById")
	@Action(description="删除${comment}及相关流程实例")
	public void delWithProcessRunId(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		try{
			boolean deleteFormRecord = RequestUtil.getBoolean(request, "deleteFormRecord");//是否删除表单记录,如果不删除，则只修改状态为草稿
			String id =RequestUtil.getString(request, "id");//要删除记录的id
			if(deleteFormRecord){//删除表单记录
				${classVar}Service.delById(id);
			}else{//不删除表单记录,只把数据状态改为草稿
				${class}  ${classVar} = ${classVar}Service.getById(id);
				if(${classVar}!=null){
					${classVar}.setDataStatus("new");
					${classVar}Service.update(${classVar});
				}
			}
			ProcessRun processRun=processRunService.getByBusinessKey(id);
			if(BeanUtils.isNotEmpty(processRun)){
				Long[] runIds =new Long[]{processRun.getRunId()};
				processRunService.delByIds(runIds);
				//TODO:如果有向中间表中插入数据的流程,删除流程后要同时根据当前id删除中间表中插入的记录
				
			}
			writeResultMessage(response.getWriter(), new ResultMessage(ResultMessage.Success, "删除${comment}成功!"));
		}catch(Exception ex){
			writeResultMessage(response.getWriter(), new ResultMessage(ResultMessage.Fail, "删除${comment}失败!"+ex.getMessage()));
		}
		
	}
	
	
	
	/**
	 * 	编辑${comment}
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("edit")
	@Action(description="编辑${comment}")
	public ModelAndView edit(HttpServletRequest request) throws Exception
	{
		String ${pkVar}=RequestUtil.getString(request,"${pkVar}",<#if model.variables.flowDefKey?exists>RequestUtil.getString(request,"id")<#else>"0"</#if>);
		String returnUrl=RequestUtil.getPrePage(request);
		boolean ifDetail=RequestUtil.getBoolean(request, "ifDetail");
		String isPop=RequestUtil.getString(request, "isPop","");
		<#if model.variables.flowKey?exists>
		Long defId=RequestUtil.getLong(request,"defId", 0L);
		Long runId=0L;
		ProcessRun processRun=processRunService.getByBusinessKey(${pkVar}.toString());
		if(BeanUtils.isNotEmpty(processRun)){
			runId=processRun.getRunId();
		}
		</#if>
		${class} ${classVar}=${classVar}Service.getById(${pkVar});
		//TODO:查询其他一些需要显示到edit页面上的变量内容,用addObject附加到下面
		
		return getAutoView().addObject("${classVar}",${classVar})
							.addObject("runId",runId)
							.addObject("defId", defId)
							.addObject("returnUrl",returnUrl)
							.addObject("ifDetail", ifDetail)
							.addObject("isPop", isPop)
							;
	}

	/**
	 * 取得${comment}明细
	 * @param request   
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("get")
	@Action(description="查看${comment}明细")
	public ModelAndView get(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String ${pkVar}=RequestUtil.getString(request,"${pkVar}");
		${class} ${classVar} = ${classVar}Service.getById(${pkVar});	
		Long runId=0L;
		ProcessRun processRun=processRunService.getByBusinessKey(${pkVar});
		if(BeanUtils.isNotEmpty(processRun)){
			runId=processRun.getRunId();
		}
		return getAutoView().addObject("${classVar}", ${classVar}).addObject("runId",runId);
	}
	
	
	/**
	 * 启动流程
	 * @param request   
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("run")
	@Action(description="启动流程")
	public void run(HttpServletRequest request, HttpServletResponse response,${class} ${classVar}) throws Exception
	{
		String ${pkVar}=RequestUtil.getString(request,"${pkVar}");
		Integer isList=RequestUtil.getInt(request, "isList",0);
		ProcessCmd processCmd=new ProcessCmd();
		processCmd.setFlowKey(flowKey);
		processCmd.setUserAccount(ContextUtil.getCurrentUser().getAccount());
		try {
			${class} ${classVar}Temp = ${classVar}Service.getBy${pkVar?cap_first}(${pkVar});
			if(!(${pkVar}.equals("0")||${pkVar}.trim().isEmpty())&&${classVar}Temp!=null){
				processCmd.setBusinessKey(${pkVar});
				
				if(isList==0){
					//TODO:类似于save方法里面的更新,做一些校验
					
					${classVar}Service.update(${classVar});
				}
				//针对终止状态的流程,如果已经有流程实例,则先删除流程实例
				ProcessRun processRun=processRunService.getByBusinessKey(${pkVar});
				if(BeanUtils.isNotEmpty(processRun)){
					Long[] runIds =new Long[]{processRun.getRunId()};
					processRunService.delByIds(runIds);
				}
				
				processRunService.startProcess(processCmd);
			}else{
				String genId=null;
				if(!(${pkVar}.equals("0")||${pkVar}.trim().isEmpty())){
					genId=${pkVar};
				}else{
					genId=UniqueIdUtil.getGuidRan();
				}
				processCmd.setBusinessKey(genId);
				${classVar}.setId(genId);
				//TODO:类似于save中的添加,做一些默认值赋值及添加前数据校验
				
				${classVar}Service.add(${classVar});
				processRunService.startProcess(processCmd);
			}
			writeResultMessage(response.getWriter(), new ResultMessage(ResultMessage.Success, "启动流程成功"));
		} catch (Exception e) {
			writeResultMessage(response.getWriter(), new ResultMessage(ResultMessage.Fail, "启动流程失败"));
		}
	}
	
	
	/**
	 * 更新状态
	 * @param request
	 * @param response
	 * @param page
	 * @return
	 * @throws IOException 
	 * @throws Exception
	 */
	@RequestMapping("updateStatueById")
	@Action(description="更新状态")
	public void updateStatueById(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try {
			String id = RequestUtil.getString(request, "id");
			String dataStatus = RequestUtil.getString(request, "dataStatus");
			${classVar}Service.updateStatueById(id, dataStatus);
			writeResultMessage(response.getWriter(), new ResultMessage(ResultMessage.Success, "更新状态成功"));
		} catch (IOException e) {
			writeResultMessage(response.getWriter(), new ResultMessage(ResultMessage.Fail, "更新状态失败"));
			e.printStackTrace();
		}
	}
	
}
