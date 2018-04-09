<#import "function.ftl" as func>
<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>

<#-- 信普达  wzh 2014-01-20 BEGIN-->
	<#assign type="isunlandSrc.${vars.projectName}"+"."+system+".model"+"."+package+"." +class>
<#-- 信普达  wzh 2014-01-20 END-->

<#--加入用户  信普达  wzh 2014-01-20 BEGIN -->
<#assign tableUser=model.variables.tableUser>
<#--加入用户  信普达  wzh 2014-01-20 END -->

<#--
   表名由 用户名.表名构成
   信普达  wzh 2014-01-20 BEGIN -->
<#assign tableName=tableUser+"."+model.tableName>
<#--信普达  wzh 2014-01-20 END -->

<#assign system=vars.system>
<#assign foreignKey=model.foreignKey>
<#assign sub=model.sub>
<#assign colList=model.columnList>
<#assign commonList=model.commonList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.getPkVar(model) >

<#-- 模板开始  -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd"> 
<mapper namespace="${type}">
	<resultMap id="${class}" type="${type}">
		<#list colList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		<#if (col.isPK) >
		<id property="${colName}" column="${col.columnName}" jdbcType="${func.getJdbcType(col.colDbType)}"/>
		<#else>
		<result property="${colName}" column="${col.columnName}" jdbcType="${func.getJdbcType(col.colDbType)}"/>
		</#if>
		</#list>
	</resultMap>

	<sql id="columns">
		<#list colList as col>${col.columnName}<#if col_has_next>,</#if></#list>
	</sql>
	
	<sql id="dynamicWhere">
		<where>
			<#list colList as col>
			<#assign colName=func.convertUnderLine(col.columnName)>
			<#if (col.colType=="String")>
			<if test="@Ognl@isNotEmpty(${colName})"> AND ${col.columnName}  = <#noparse>#{</#noparse>${colName}}  </if>
			<#else>
			<#if (col.colType=="java.util.Date")>
			<if test="@Ognl@isNotEmpty(${colName})"> AND ${col.columnName}  =<#noparse>#{</#noparse>${colName}} </if>
			<if test="@Ognl@isNotEmpty(begin${colName})"> AND ${col.columnName}  >=<#noparse>#{</#noparse>begin${colName},jdbcType=DATE} </if>
			<if test="@Ognl@isNotEmpty(end${colName})"> AND ${col.columnName} <![CDATA[ <=<#noparse>#{</#noparse>end${colName},jdbcType=DATE}]]> </if>
			<#else>
			<if test="@Ognl@isNotEmpty(${colName})"> AND ${col.columnName}  =<#noparse>#{</#noparse>${colName}} </if>
			</#if>
			</#if>
			</#list>
		</where>
	</sql>

	<insert id="add" parameterType="${type}">
		INSERT INTO ${tableName}
		(<#list colList as col>${col.columnName}<#if col_has_next>,</#if></#list>)
		VALUES
		(<#list colList as col><#assign colName=func.convertUnderLine(col.columnName)><#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>}</#noparse><#if col_has_next>, </#if></#list>)
	</insert>
	
	<insert id="add_mysql" parameterType="${type}">
		INSERT INTO ${tableName}
		(<#list colList as col>${col.columnName}<#if col_has_next>,</#if></#list>)
		VALUES
		(<#list colList as col><#assign colName=func.convertUnderLine(col.columnName)><#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>}</#noparse><#if col_has_next>, </#if></#list>)
	</insert>
	
	<#-- 信普达  wzh 2014-02-18 BEGIN-->
	<delete id="delById" parameterType="java.lang.String">
	<#--信普达  wzh 2014-02-18 END -->
	
		DELETE FROM ${tableName} 
		WHERE
		${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}}
	</delete>
	
	<update id="update" parameterType="${type}">
		UPDATE ${tableName} SET
		<#list commonList as col>
		<#assign colName=func.convertUnderLine(col.columnName)>
		<#if colName!='orderNo'> ${col.columnName}=<#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>}</#noparse><#if col_has_next>,</#if></#if>
		</#list>
		WHERE
		${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}}
	</update>
	<#if sub?exists && sub==true>
	<#assign foreignKeyVar=func.convertUnderLine(foreignKey)>
	<delete id="delByMainId">
	    DELETE FROM ${tableName}
	    WHERE
	    ${foreignKey}=<#noparse>#{</#noparse>${foreignKeyVar}}
	</delete>    
	
	<select id="get${class}List" resultMap="${class}">
	    SELECT <include refid="columns"/>
	    FROM ${tableName} 
	    WHERE ${foreignKey}=<#noparse>#{</#noparse>${foreignKeyVar}}
	</select>
	</#if>
	
	<#-- 信普达  wzh 2014-02-18 BEGIN-->	    
	<select id="getById" parameterType="java.lang.String" resultMap="${class}">
	<#-- 信普达  wzh 2014-02-18 END-->
	
		SELECT <include refid="columns"/>
		FROM ${tableName}
		WHERE
		${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}}
	</select>
	
	<select id="getAll" resultMap="${class}">
		SELECT <include refid="columns"/>
		FROM ${tableName}   
		<include refid="dynamicWhere" />
		<if test="@Ognl@isNotEmpty(orderField)">
		order by <#noparse>${orderField}</#noparse> <#noparse>${orderSeq}</#noparse>
		</if>
		<if test="@Ognl@isEmpty(orderField)">
		order by ${pk}  desc
		</if>
	</select>
</mapper>
