package com.simple.common;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


public class SessionUtil {
	public static Map<String, Object> getSession(HttpServletRequest request) {
//		Map<String,Object> map=new HashMap<>();
//		map.put("dept_id", 4);
//		map.put("id", 5);
//		map.put("gov_id", 4);
//		map.put("deptname", "公安部");
//		map.put("loginname", "gab");
		Map<String,Object> map =(Map<String, Object>)request.getSession().getAttribute("userinfo");
		return map;
	}
}
