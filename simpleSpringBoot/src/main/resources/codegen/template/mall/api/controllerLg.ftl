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

package com.simple.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.simple.entity.${class};
import com.simple.service.${class}Service;

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
@RestController
@RequestMapping("sys/${classVar}")
public class ${class}Controller extends AbstractController{
	
	@Resource
	private ${class}Service ${classVar}Service;
	
	@RequestMapping("get${class}All")
	public List<Map<String,Object>> get${class}All(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		List<Map<String,Object>> list = ${classVar}Service.get${class}All(paramMap);
		return list;
	}
	
	@RequestMapping("get${class}Byid")
	public Map<String,Object> get${class}(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		Map<String,Object> map = ${classVar}Service.get${class}Byid(paramMap);
		return map;
	}
	
	@RequestMapping("add${class}")
	public Map<String,Object> add${class}(${class} ${classVar},HttpServletRequest request,HttpServletResponse response) throws IOException{
		return ${classVar}Service.add${class}(${classVar});
	}
	
	@RequestMapping("update${class}")
	public Map<String,Object> update${class}(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		return ${classVar}Service.update${class}(paramMap);
	}
	
	@RequestMapping("delete${class}s")
	public Map<String,Object> delete${class}s(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		String[] ids = ((String)paramMap.get("ids")).split(",");
		return ${classVar}Service.delete${class}s(ids);
	}
}

