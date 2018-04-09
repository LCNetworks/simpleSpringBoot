<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign subtables=model.subTableList>
<#assign classVar=model.variables.classVar>
<#assign table=model.subTableList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk)>

<#-- 信普达 wzh 2014-01-20 BEGIN-->
package isunlandSrc.${vars.projectName}.${system}.service.${package}; 
<#-- 信普达 wzh 2014-01-20 END-->

<#--
  平台默认 wzh 2014-01-20
 package com.hotent.${system}.service.${package};
 -->
 
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import isunlandSrc.flowInterfaces.IFlowServiceInterface;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.hotent.core.db.IEntityDao;
<#--  平台默认 wzh 2014-02-18
import com.hotent.core.service.BaseService;-->

<#-- 信普达 wzh 2014-02-18 BEGIN-->
import com.hotent.core.service.ISunLandBaseService;
import com.hotent.platform.dao.bpm.BpmDefinitionDao;
<#-- 信普达 wzh 2014-02-18 END-->

import com.hotent.core.util.BeanUtils;
import com.hotent.core.util.UniqueIdUtil;
import com.hotent.platform.model.bpm.BpmDefinition;
import com.hotent.platform.service.bpm.impl.ScriptImpl;
import com.hotent.core.util.AppUtil;
<#-- 
 平台默认  wzh 2014-01-20
 import com.hotent.${system}.model.${package}.${class}; 
 import com.hotent.${system}.dao.${package}.${class}Dao;
-->
 
<#-- 信普达 wzh 2014-01-20 BEGIN-->
import isunlandSrc.${vars.projectName}.${system}.model.${package}.${class};
import isunlandSrc.${vars.projectName}.${system}.dao.${package}.${class}Dao;
 <#-- 信普达 wzh 2014-01-20 END-->

<#if subtables?exists && subtables?size != 0>
	<#list subtables as table>
   <#--
	    平台默认 wzh 2014-01-20
	 import com.hotent.${system}.model.${table.variables.package}.${table.variables.class};
     import com.hotent.${system}.dao.${table.variables.package}.${table.variables.class}Dao;
     -->
      
	<#-- 信普达 wzh 2014-01-20 BEGIN-->
      import isunlandSrc.${vars.projectName}.${system}.model.${table.variables.package}.${table.variables.class};
      import isunlandSrc.${vars.projectName}.${system}.dao.${table.variables.package}.${table.variables.class}Dao;
    <#-- 信普达 wzh 2014-01-20 END-->  
    
	</#list>
</#if>
<#if model.variables.flowKey?exists >
import com.hotent.core.web.query.QueryFilter;
import com.hotent.platform.model.bpm.ProcessRun;
import com.hotent.platform.service.bpm.ProcessRunService;
import com.hotent.core.util.StringUtil;
import com.hotent.core.bpm.model.ProcessCmd;
import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONObject;
import net.sf.json.util.JSONUtils;
</#if>

/**
 *<pre>
 * 对象功能:${model.tabComment} Service类
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 *</pre>
 */
@Service
 <#--平台默认  wzh 2014-02-18
public class ${class}Service extends BaseService<${class}>-->

 <#-- 信普达 wzh 2014-01-20 BEGIN-->
public class ${class}Service extends ISunLandBaseService<${class}> implements IFlowServiceInterface<${class}>
 <#-- 信普达 wzh 2014-01-20 END-->  

{
	@Resource
	private ${class}Dao dao;
	@Resource
	private ProcessRunService processRunService;
	@Resource
	private BpmDefinitionDao bpmDefDao;
	public ${class}Service()
	{
	}
	
	@Override
	protected IEntityDao<${class}, String> getEntityDao()
	{
		return dao;
	}
	
	
	/**
	 * 重写getAll方法绑定流程runId
	 * @param queryFilter
	 */
	public List<${class}> getAll(QueryFilter queryFilter, String flowKey) {
		List<${class}> ${classVar}List=super.getAll(queryFilter);
		List<${class}> ${classVar}s=new ArrayList<${class}>();
		BpmDefinition bpmDef = bpmDefDao.getByActDefKeyIsMain(flowKey);
		for(${class} ${classVar}:${classVar}List){
			ProcessRun processRun=processRunService.getByBusinessKey(${classVar}.get${pkVar?cap_first}().toString());
			if(BeanUtils.isNotEmpty(processRun)){
				${classVar}.setRunId(processRun.getRunId());
			}
			
			if (bpmDef != null) {
				${classVar}.setDefId(bpmDef.getDefId());
			}
			${classVar}s.add(${classVar});
		}
		return ${classVar}s;
	}
	
	/**
	 * 流程处理器方法 用于处理业务数据
	 * @param cmd
	 * @throws Exception
	 */
	public void processHandler(ProcessCmd cmd)throws Exception{
		Map data=cmd.getFormDataMap();
		${class} ${classVar} = null;
		if(BeanUtils.isNotEmpty(data)){
			Object json=data.get("json");
			if (json != null) {
				${classVar}=get${class}(json.toString());
			}else{
				String flowId = data.get("businessKey")!= null?data.get("businessKey").toString() : "";
				${classVar} = dao.getById(flowId);
			}
			
			if (StringUtil.isEmpty(cmd.getBusinessKey())) {
				String genId = UniqueIdUtil.getGuidRan();
				${classVar}.setId(genId);
				this.add(${classVar});
			} else {
				${classVar}.setId(cmd.getBusinessKey());
				this.update(${classVar});
			}
			cmd.setBusinessKey(${classVar}.getId().toString());
		}else{
			String businessKey = cmd.getBusinessKey();
			${classVar} = dao.getById(businessKey);
		}
		// 添加流程变量
		ScriptImpl sc = (ScriptImpl) AppUtil.getBean(ScriptImpl.class);
		sc.addVariablesToProcessCmd(${classVar}, cmd);
	}
	
	/**
	 * 根据json字符串获取${class}对象
	 * @param json
	 * @return
	 */
	public ${class} get${class}(String json){
		JSONUtils.getMorpherRegistry().registerMorpher(new DateMorpher((new String[] { "yyyy-MM-dd HH:mm:ss" })));
		if(StringUtil.isEmpty(json))return null;
		JSONObject obj = JSONObject.fromObject(json);
		${class} ${classVar} = (${class})JSONObject.toBean(obj, ${class}.class);
		return ${classVar};
	}
	
	/**
	 * 流程中节点后事件调用,可以更新数据状态 根据id和状态更新dataStatus
	 * 
	 * @param id
	 *            要更新的记录id
	 * @param dataStatus
	 *            要更新成的状态
	 * @return
	 */
	public int updateStatueById(String id, String dataStatus) {
		${class} entity = dao.getById(id);
		if (entity != null) {
			entity.setDataStatus(dataStatus);
			return dao.update(entity);
		} else {
			return 0;
		}
	}
}
