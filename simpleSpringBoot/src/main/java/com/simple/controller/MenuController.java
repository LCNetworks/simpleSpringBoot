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

import com.simple.entity.Menu;
import com.simple.service.MenuService;

@RestController
@RequestMapping("sys/menu")
public class MenuController extends AbstractController{
	
	@Resource
	private MenuService menuService;
	
	@RequestMapping("getMenuAll")
	public List<Map<String,Object>> getMenuAll(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		List<Map<String,Object>> list = menuService.getMenuAll(paramMap);
		return list;
	}
	
	@RequestMapping("getMenuByid")
	public Map<String,Object> getMenu(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		Map<String,Object> map = menuService.getMenuByid(paramMap);
		return map;
	}
	
	@RequestMapping("addMenu")
	public Map<String,Object> addMenu(Menu menu,HttpServletRequest request,HttpServletResponse response) throws IOException{
		return menuService.addMenu(menu);
	}
	
	@RequestMapping("updateMenu")
	public Map<String,Object> updateMenu(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		return menuService.updateMenu(paramMap);
	}
	
	@RequestMapping("deleteMenus")
	public Map<String,Object> deleteMenus(HttpServletRequest request,HttpServletResponse response) throws IOException{
		Map<String,Object> paramMap = parseRequestParam(request);
		String[] ids = ((String)paramMap.get("ids")).split(",");
		return menuService.deleteMenus(ids);
	}
}
