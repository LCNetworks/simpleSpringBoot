package com.simple.entity;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.simple.common.SessionUtil;

public class Result{
	private String result = "1";
	private String msg = "成功";
	private Integer count = 0;
	private String sessionstatus = "0";
	private List<Map<String,Object>> data;

	public Result(HttpServletRequest httpServletRequest){
		Map<String, Object> usermap = SessionUtil.getSession(httpServletRequest);
		if (usermap!=null && !usermap.isEmpty()) {
			sessionstatus="1";
		}
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public List<Map<String, Object>> getData() {
		return data;
	}
	public void setData(List<Map<String, Object>> data) {
		this.data = data;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	public String getSessionstatus() {
		return sessionstatus;
	}
	public void setSessionstatus(String sessionstatus) {
		this.sessionstatus = sessionstatus;
	}
	
}
