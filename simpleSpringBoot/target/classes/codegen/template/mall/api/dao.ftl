<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign classVar=model.variables.classVar>
<#assign sub=model.sub>
<#assign foreignKey=func.convertUnderLine(model.foreignKey)>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk) >

package com.simple.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.simple.entity.${class};

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
@Mapper
public interface ${class}Mapper {

	List<Map<String, Object>> get${class}All(Map<String, Object> paramMap);

	Map<String, Object> get${class}Byid(Map<String, Object> paramMap);

	int add${class}(${class} ${classVar});

	int update${class}(Map<String, Object> paramMap);

	int delete${class}s(List<String> idlist);
}