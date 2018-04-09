<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign classVar=model.variables.classVar>
<#assign sub=model.sub>
<#assign foreignKey=func.convertUnderLine(model.foreignKey)>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >

<#-- 信普达 wzh 2014-01-20 BEGIN-->
 package isunlandSrc.${vars.projectName}.${system}.dao.${package}; 
<#-- 信普达 wzh 2014-01-20 END--> 

<#--
    平台默认  wzh 2014-01-20
  package com.hotent.${system}.dao.${package};
-->
  
import java.util.List;
import org.springframework.stereotype.Repository;

<#--  平台默认  wzh 2014-02-18
import com.hotent.core.db.BaseDao; -->

<#--信普达  wzh 2014.02.18  begin -->
import com.hotent.core.db.ISunLandBaseDao;
<#--信普达 wzh 2014.02.18  end  -->

<#if sub?exists && sub>
import com.hotent.core.util.UniqueIdUtil;
import com.hotent.core.util.BeanUtils;
</#if>

<#--
     平台默认  wzh 2014-01-20
  import com.hotent.${system}.model.${package}.${class};
 -->
 
<#-- 信普达  wzh 2014-01-20 BEGIN-->
 import isunlandSrc.${vars.projectName}.${system}.model.${package}.${class};
<#-- 信普达  wzh 2014-01-20 END-->

/**
 *<pre>
 * 对象功能:${model.tabComment} Dao类
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 *</pre>
 */
@Repository
<#--  平台默认  wzh 2014-02-18
public class ${class}Dao extends BaseDao<${class}>-->

<#-- 信普达  wzh 2014-02-18 BEGIN-->
 public class ${class}Dao extends ISunLandBaseDao<${class}>
<#-- 信普达  wzh 2014-02-18 END-->
{
	@Override
	public Class<?> getEntityClass()
	{
		return ${class}.class;
	}

	<#if sub?exists && sub>
	/**
	 * 根据外键获取子表明细列表
	 * @param ${foreignKey}
	 * @return
	 */
	 
	<#--  平台默认  wzh 2014-02-18
	public List<${class}> getByMainId(Long ${foreignKey}) {-->
	
	<#-- 信普达  wzh 2014-02-18 BEGIN-->
 	public List<${class}> getByMainId(String ${foreignKey}) {
	<#-- 信普达  wzh 2014-01-18 END-->
	
		return this.getBySqlKey("get${class}List", ${foreignKey});
	}
	/**
	 * 根据外键删除子表记录
	 * @param ${foreignKey}
	 * @return
	 */
	 <#--  平台默认  wzh 2014-02-18
	public void delByMainId(Long ${foreignKey}) {-->
	
	<#-- 信普达  wzh 2014-02-18 BEGIN-->
 	public void delByMainId(String ${foreignKey}){
	<#-- 信普达  wzh 2014-02-18 END-->
	
		this.delBySqlKey("delByMainId", ${foreignKey});
	}
	</#if>	
	
	@Override
	public void add(${class} entity){
		String dbType = this.getDbType();
		String sqlKey = "add_mysql";
		if("mysql".equals(dbType)){
			this.insert(sqlKey, entity);
		}else{
			super.add(entity);
		}
	}
}