package com.simple.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.simple.entity.Menu;

@Mapper
public interface MenuMapper {

	List<Map<String, Object>> getMenuAll(Map<String, Object> paramMap);

	Map<String, Object> getMenuByid(Map<String, Object> paramMap);

	int addMenu(Menu menu);

	int updateMenu(Map<String, Object> paramMap);

	int deleteMenus(List<String> idlist);
}