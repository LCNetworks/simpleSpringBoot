<#assign package=model.variables.package>
<#assign class=model.variables.class>
<#assign system=vars.system>
<#assign foreignKey=model.foreignKey>
<#assign sub=model.sub>
<#assign colList=model.columnList>
<#assign commonList=model.commonList>
<#assign pk=func.getPk(model) >
<#assign pkVar=func.getPkVar(model) >
<#assign tableName=model.tableName>

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.simple.dao.${class}Mapper">

  <sql id="Base_Column_List">
    <#list colList as col>${col.columnName}<#if col_has_next>,</#if></#list>
  </sql>
  
  <select id="get${class}All" parameterType="java.util.Map" resultType="java.util.Map">
    select 
    <include refid="Base_Column_List" />
    from ${tableName}
  </select>
  
  <select id="get${class}Byid" parameterType="java.util.Map" resultType="java.util.Map">
    select 
    <include refid="Base_Column_List" />
    from ${tableName}
    where {pk} = #{pk}
  </select>
  
  <delete id="delete${class}s" parameterType="java.util.List">
    delete from ${tableName}
    where {pk} in
    <foreach collection="list" item="id" index="index" open="(" close=")" separator=",">
		<#noparse>#{</#noparse>${id}}
	</foreach>
  </delete>
  
  <insert id="add${class}" parameterType="com.simple.entity.${class}">
    insert into ${tableName}
    <trim prefix="(" suffix=")" suffixOverrides=",">
    	<#list colList as col>
			<if test="${col.columnName} != null and ${col.columnName} != ''">
	        	${col.columnName},
   		 	</if>
    	</#list>
    </trim>
    <trim prefix="values (" suffix=")" suffixOverrides=",">
      <#list colList as col>
     	  <#assign colName=func.convertUnderLine(col.columnName)>
	      <if test="${colName} != null" and ${colName} != ''>
	        <#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>},
	      </if>
      </#list>
    </trim>
  </insert>
  
  <update id="update${class}" parameterType="java.util.Map">
    update ${tableName}
    <set>
      <#list colList as col>
     	  <#assign colName=func.convertUnderLine(col.columnName)>
	      <if test="${colName} != null" and ${colName} != ''>
	        <#noparse>#{</#noparse>${colName},jdbcType=${func.getJdbcType(col.colDbType)}<#noparse>},
	      </if>
      </#list>
    </set>
    where 
    ${pk}=<#noparse>#{</#noparse>${func.convertUnderLine(pk)}}
  </update>
</mapper>