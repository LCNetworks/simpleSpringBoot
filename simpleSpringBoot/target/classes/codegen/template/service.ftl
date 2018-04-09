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

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.hotent.core.db.IEntityDao;
<#--  平台默认 wzh 2014-02-18
import com.hotent.core.service.BaseService;-->

<#-- 信普达 wzh 2014-02-18 BEGIN-->
import com.hotent.core.service.ISunLandBaseService;
<#-- 信普达 wzh 2014-02-18 END-->

import com.hotent.core.util.BeanUtils;
import com.hotent.core.util.UniqueIdUtil;

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
public class ${class}Service extends ISunLandBaseService<${class}>
 <#-- 信普达 wzh 2014-01-20 END-->  

{
	@Resource
	private ${class}Dao dao;
	
	<#if subtables?exists && subtables?size != 0>
		<#list subtables as table>
	@Resource
	private ${table.variables.class}Dao ${table.variables.classVar}Dao;
		</#list>
	</#if>
	
	<#--直接绑定工作流生成-->
	<#if model.variables.flowKey?exists>
	@Resource
	private ProcessRunService processRunService;
	</#if>
	
	public ${class}Service()
	{
	}
	
	@Override
	<#--平台默认  wzh 2014-02-18
	protected IEntityDao<${class}, Long> getEntityDao() -->
	
	<#-- 信普达 wzh 2014-02-18 BEGIN-->
	protected IEntityDao<${class}, String> getEntityDao()
 	<#-- 信普达 wzh 2014-02-18 END-->  
	{
		return dao;
	}
	
	<#if subtables?exists && subtables?size != 0>
	/**
	 * 根据外键删除子表记录
	 * @param ${pkVar}
	 */
	 
	 <#--平台默认  wzh 2014-02-18
	private void delByPk(Long ${pkVar}){-->
	
	 <#-- 信普达 wzh 2014-02-18 BEGIN-->
  	private void delByPk(String ${pkVar}){
     <#-- 信普达 wzh 2014-02-18 END-->  
	    <#list model.subTableList as table>
		${table.variables.classVar}Dao.delByMainId(${pkVar});
	    </#list>
	}
	
	/**
	 * 删除数据 包含相应子表记录
	 * @param lAryId
	 */
	 <#-- 
  <#--平台默认  wzh 2014-02-18
	public void delAll(Long[] lAryId) {-->
	
  <#-- 信普达 wzh 2014-02-18 BEGIN-->
    public void delAll(String[] lAryId) {	
  <#-- 信普达 wzh 2014-01-18 END-->  
	
	 <#--平台默认  wzh 2014-02-18
		for(Long id:lAryId){-->
		
		<#-- 信普达 wzh 2014-01-20 BEGIN-->
   			for(String id:lAryId){
   		<#-- 信普达 wzh 2014-01-20 END-->  
		
			delByPk(id);
			dao.delById(id);	
		}	
	}
	
	/**
	 * 添加数据 
	 * @param ${classVar}
	 * @throws Exception
	 */
	public void addAll(${class} ${classVar}) throws Exception{
		add(${classVar});
		addSubList(${classVar});
	}
	
	/**
	 * 更新数据
	 * @param ${classVar}
	 * @throws Exception
	 */
	public void updateAll(${class} ${classVar}) throws Exception{
		update(${classVar});
		delByPk(${classVar}.get${pkVar?cap_first}());
		addSubList(${classVar});
	}
	
	/**
	 * 添加子表记录
	 * @param ${classVar}
	 * @throws Exception
	 */
	public void addSubList(${class} ${classVar}) throws Exception{
	<#list subtables as table>
	<#assign vars=table.variables>
	<#assign foreignKey=func.convertUnderLine(table.foreignKey) >
	<#assign subPk=func.getPk(table)>
	<#assign subPkVar=func.convertUnderLine(subPk)>
		List<${vars.class}> ${vars.classVar}List=${classVar}.get${vars.classVar?cap_first}List();
		if(BeanUtils.isNotEmpty(${vars.classVar}List)){
			for(${vars.class} ${vars.classVar}:${vars.classVar}List){
				${vars.classVar}.set${foreignKey?cap_first}(${classVar}.get${pkVar?cap_first}());
				
				<#--平台默认  wzh 2014-02-18
				${vars.classVar}.set${subPkVar?cap_first}(UniqueIdUtil.genId());-->
				
				<#-- 信普达 wzh 2014-02-18 BEGIN-->
   					${vars.classVar}.set${subPkVar?cap_first}(UniqueIdUtil.getGuid());
   				<#-- 信普达 wzh 2014-02-18 END--> 
   				
				${vars.classVar}Dao.add(${vars.classVar});
			}
		}
	</#list>
	}
	
	<#list subtables as table>
	<#assign vars=table.variables>
	/**
	 * 根据外键获得${table.tabComment}列表
	 * @param ${pkVar}
	 * @return
	 */
	<#--平台默认  wzh 2014-02-18
	public List<${vars.class}> get${vars.classVar?cap_first}List(Long ${pkVar}) {-->
	
	<#-- 信普达 wzh 2014-02-18 BEGIN-->
   	public List<${vars.class}> get${vars.classVar?cap_first}List(String ${pkVar}) {
   	<#-- 信普达 wzh 2014-02-18 END--> 
	
		return ${vars.classVar}Dao.getByMainId(${pkVar});
	}
	</#list>
	
	</#if>
	
	<#--直接绑定工作流生成-->
	<#if model.variables.flowKey?exists>
	/**
	 * 重写getAll方法绑定流程runId
	 * @param queryFilter
	 */
	public List<${class}> getAll(QueryFilter queryFilter){
		List<${class}> ${classVar}List=super.getAll(queryFilter);
		List<${class}> ${classVar}s=new ArrayList<${class}>();
		for(${class} ${classVar}:${classVar}List){
			ProcessRun processRun=processRunService.getByBusinessKey(${classVar}.get${pkVar?cap_first}().toString());
			if(BeanUtils.isNotEmpty(processRun)){
				${classVar}.setRunId(processRun.getRunId());
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
		if(BeanUtils.isNotEmpty(data)){
			String json=data.get("json").toString();
			${class} ${classVar}=get${class}(json);
			if(StringUtil.isEmpty(cmd.getBusinessKey())){
				String genId=UniqueIdUtil.getGuidRan();
				${classVar}.set${pkVar?cap_first}(genId);
				<#if subtables?exists && subtables?size != 0>
				this.addAll(${classVar});
				<#else>
				this.add(${classVar});
				</#if>
			}else{
				${classVar}.set${pkVar?cap_first}(Long.parseLong(cmd.getBusinessKey()));
				<#if subtables?exists && subtables?size != 0>
				this.updateAll(${classVar});
				<#else>
				this.update(${classVar});
				</#if>
			}
			cmd.setBusinessKey(${classVar}.get${pkVar?cap_first}().toString());
		}
	}
	
	/**
	 * 根据json字符串获取${class}对象
	 * @param json
	 * @return
	 */
	public ${class} get${class}(String json){
		JSONUtils.getMorpherRegistry().registerMorpher(new DateMorpher((new String[] { "yyyy-MM-dd" })));
		if(StringUtil.isEmpty(json))return null;
		JSONObject obj = JSONObject.fromObject(json);
		<#if subtables?exists && subtables?size != 0>
		Map<String,  Class> map=new HashMap<String,  Class>();
		<#list subtables as subtable>
		<#assign vars=subtable.variables>
		map.put("${vars.classVar}List", ${vars.class}.class);
		</#list>
		${class} ${classVar} = (${class})JSONObject.toBean(obj, ${class}.class,map);
		<#else>
		${class} ${classVar} = (${class})JSONObject.toBean(obj, ${class}.class);
		</#if>
		return ${classVar};
	}
	
	</#if>
	 /**
    * 批量保存数据
    * @param insertedList 新增的数据
    * @param updatedList 修改的数据
    * @param deletedList 删除的数据
    */
   public void saveBatch(List<${class}> insertedList,List<${class}> updatedList,List<${class}> deletedList){
   		this.saveBatch(insertedList, updatedList, deletedList, "get${pkVar?cap_first}");
   }
}
