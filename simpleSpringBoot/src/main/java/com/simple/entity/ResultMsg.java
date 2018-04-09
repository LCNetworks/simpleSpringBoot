package com.simple.entity;

import java.util.HashMap;
import java.util.Map;

public class ResultMsg {
	
	private static Map<Integer,String> rs = new HashMap<Integer,String>();
	
	static{
		rs.put(1, "成功");
		rs.put(-1, "失败");
	}
	
	public static Map<String,Object> getMsg(int status){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("status",status);
		map.put("msg", rs.get(status));
		return map;
	}
	
	public static Map<String,Object> getBatchMsg(int status){
		Map<String,Object> map = new HashMap<String,Object>();
		if(status>0){
			map.put("status",status);
			map.put("msg", "成功");
		}else{
			map.put("status",-1);
			map.put("msg", "失败");
		}
		return map;
	}
}
