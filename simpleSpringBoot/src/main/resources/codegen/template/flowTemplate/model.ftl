<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign subtables=model.subTableList>


<#-- 信普达 wzh 2014-01-20 BEGIN-->
 package isunlandSrc.${vars.projectName}.${system}.model.${package}; 
<#-- 信普达 wzh 2014-01-20 END-->

<#--
 平台默认 wzh 2014-01-20
 package com.hotent.${system}.model.${package};
 -->
  
 
import java.util.ArrayList;
import java.util.List;
import com.hotent.core.model.BaseModel;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
import isunlandSrc.comm.util.FullDateDeserializer;
import isunlandSrc.comm.util.FullDateSeriallizer;
import org.codehaus.jackson.map.annotate.JsonDeserialize;
import org.codehaus.jackson.map.annotate.JsonSerialize;
/**
 * 对象功能:${model.tabComment} Model对象
 <#if vars.company?exists>
 * 开发公司:${vars.company}
 </#if>
 <#if vars.developer?exists>
 * 开发人员:${vars.developer}
 </#if>
 * 创建时间:${date?string("yyyy-MM-dd HH:mm:ss")}
 */
public class ${class} extends BaseModel
{
<#list model.columnList as col>
	// ${col.comment}
	<#if (col.colType=="Integer")>
	protected Long  ${func.convertUnderLine(col.columnName)};
	<#else>
	protected ${col.colType}  ${func.convertUnderLine(col.columnName)};
	</#if>
</#list>
<#if subtables?exists && subtables?size!=0>
	<#list subtables as table>
	<#assign vars=table.variables>
	//${table.tabComment}列表
	protected List<${vars.class}> ${vars.classVar}List=new ArrayList<${vars.class}>();
	</#list>
</#if>
<#if model.variables.flowKey?exists>
	protected Long runId=0L;
	protected Long defId=0L;
</#if>
<#list model.columnList as col>
	<#assign colName=func.convertUnderLine(col.columnName)>
	
	<#if (col.colType="java.util.Date")>
	@JsonSerialize(using = FullDateSeriallizer.class)
	@JsonDeserialize(using = FullDateDeserializer.class)
	</#if>
	public void set${colName?cap_first}(<#if (col.colType="Integer")>Long<#else>${col.colType}</#if> ${colName}) 
	{
		this.${colName} = ${colName};
	}
	/**
	 * 返回 ${col.comment}
	 * @return
	 */
	public <#if (col.colType="Integer")>Long<#else>${col.colType}</#if> get${colName?cap_first}() 
	{
		return this.${colName};
	}
</#list>
<#if subtables?exists && subtables?size!=0>
<#list subtables as table>
<#assign vars=table.variables>
	public void set${vars.classVar?cap_first}List(List<${vars.class}> ${vars.classVar}List) 
	{
		this.${vars.classVar}List = ${vars.classVar}List;
	}
	/**
	 * 返回 ${table.tabComment}列表
	 * @return
	 */
	public List<${vars.class}> get${vars.classVar?cap_first}List() 
	{
		return this.${vars.classVar}List;
	}
</#list>
</#if>
	<#if model.variables.flowKey?exists>
	public Long getRunId() {
		return runId;
	}
	public void setRunId(Long runId) {
		this.runId = runId;
	}
	public Long getDefId() {
		return defId;
	}
	public void setDefId(Long defId) {
		this.defId = defId;
	}
	</#if>

   	/**
	 * @see java.lang.Object#equals(Object)
	 */
	public boolean equals(Object object) 
	{
		if (!(object instanceof ${class})) 
		{
			return false;
		}
		${class} rhs = (${class}) object;
		return new EqualsBuilder()
		<#list model.columnList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		.append(this.${colName}, rhs.${colName})
		</#list>
		.isEquals();
	}

	/**
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() 
	{
		return new HashCodeBuilder(-82280557, -700257973)
		<#list model.columnList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		.append(this.${colName}) 
		</#list>
		.toHashCode();
	}

	/**
	 * @see java.lang.Object#toString()
	 */
	public String toString() 
	{
		return new ToStringBuilder(this)
		<#list model.columnList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		.append("${colName}", this.${colName}) 
		</#list>
		.toString();
	}
   
  

}