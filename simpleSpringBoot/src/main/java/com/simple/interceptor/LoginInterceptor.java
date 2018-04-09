package com.simple.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.simple.common.ResultCode;
import com.simple.common.SessionUtil;
import com.simple.entity.Result;

import net.sf.json.JSONObject;

public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("URL:"+request.getRequestURI());
		boolean temp = true;
		String requestURI = request.getRequestURI();
		if(requestURI.indexOf("/subscribeapply") > -1||requestURI.indexOf("/sourceinfo/getInfoForApplybyid") > -1
				||requestURI.indexOf("/sourceinfo/getDataexcel") > -1||requestURI.indexOf("/sourceinfo/downloadFile") > -1||
				requestURI.indexOf("/sourceinfo/getDockingFileData") > -1||requestURI.indexOf("/sourceinfo/getDockingAPIData") > -1||
				requestURI.indexOf("/sourceinfo/getDockingData") > -1||requestURI.indexOf("/sourceinfo/getDockingOtherData") > -1){
			Map<String, Object> usermap = SessionUtil.getSession(request);
			if (usermap!=null && !usermap.isEmpty()) {
				// 校验用户
				if (usermap.get("loginname")!=null && !"".equals(usermap.get("loginname").toString())) {
					System.out.println("LOGINNAME:"+usermap.get("loginname"));
					temp = true;
				} else {
					temp = false;
				}
			} else {
				temp = false;
			}
			if (!temp) {
				Result result = new Result(request);
				result.setResult("1101");
				result.setMsg(ResultCode.Result_Code_1101);
				response.setCharacterEncoding("UTF-8");
				response.setContentType("application/json;charset=UTF-8");
				response.getWriter().write(JSONObject.fromObject(result).toString());
			}
		}
		return temp;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
	}

}
