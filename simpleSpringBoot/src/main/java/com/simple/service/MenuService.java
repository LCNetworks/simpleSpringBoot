package com.simple.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.simple.dao.MenuMapper;
import com.simple.entity.Menu;
import com.simple.entity.ResultMsg;

@Service
public class MenuService {
	
	@Resource
	private MenuMapper menuMapper;

	public List<Map<String, Object>> getMenuAll(Map<String, Object> paramMap) {
		return menuMapper.getMenuAll(paramMap);
	}

	public Map<String, Object> getMenuByid(Map<String, Object> paramMap) {
		return menuMapper.getMenuByid(paramMap);
	}

	public Map<String, Object> addMenu(Menu menu) {
		return ResultMsg.getMsg(menuMapper.addMenu(menu));
	}

	public Map<String, Object> updateMenu(Map<String, Object> paramMap) {
		return ResultMsg.getMsg(menuMapper.updateMenu(paramMap));
	}

	public Map<String, Object> deleteMenus(String[] ids) {
		List<String> idlist = new ArrayList<String>();
		if (StringUtils.isNoneEmpty(ids)) {
			for (String id : ids) {
				idlist.add(id);
			}
		}
		return ResultMsg.getBatchMsg(menuMapper.deleteMenus(idlist));
	}
	
}
