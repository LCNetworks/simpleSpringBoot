<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign subtables=model.subTableList>
<#assign classVar=model.variables.classVar>
<#assign table=model.subTableList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.convertUnderLine(pk)>

package com.simple.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.simple.dao.${class}Mapper;
import com.simple.entity.${class};
import com.simple.entity.ResultMsg;

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
public class ${class}Service {
	
	@Resource
	private ${class}Mapper ${classVar}Mapper;

	public List<Map<String, Object>> get${class}All(Map<String, Object> paramMap) {
		return ${classVar}Mapper.get${class}All(paramMap);
	}

	public Map<String, Object> get${class}Byid(Map<String, Object> paramMap) {
		return ${classVar}Mapper.get${class}Byid(paramMap);
	}

	public Map<String, Object> add${class}(${class} ${classVar}) {
		return ResultMsg.getMsg(${classVar}Mapper.add${class}(${classVar}));
	}

	public Map<String, Object> update${class}(Map<String, Object> paramMap) {
		return ResultMsg.getMsg(${classVar}Mapper.update${class}(paramMap));
	}

	public Map<String, Object> delete${class}s(String[] ids) {
		List<String> idlist = new ArrayList<String>();
		if (StringUtils.isNoneEmpty(ids)) {
			for (String id : ids) {
				idlist.add(id);
			}
		}
		return ResultMsg.getBatchMsg(${classVar}Mapper.delete${class}s(idlist));
	}
	
}

