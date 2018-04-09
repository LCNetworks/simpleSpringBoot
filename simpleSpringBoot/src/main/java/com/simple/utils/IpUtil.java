package com.simple.utils;

import javax.servlet.http.HttpServletRequest;

/**
 * ip 工具类
 * @author czl
 *
 */
public class IpUtil {
	
	//获取客户端ip
	public static String getClientIp (HttpServletRequest request){
		String ip = request.getHeader("x-forwarded-for");
		if(ip== null || ip.length() ==0 || "unknown".equalsIgnoreCase(ip)){
			ip = request.getHeader("Proxy-Client-IP");
		}
		if(ip ==null || ip.length() ==0 || "unknown".equalsIgnoreCase(ip)){
			ip =  request.getHeader("WL-Proxy-Client-IP");
		}
		if(ip ==null || ip.length() ==0 || "unknown".equalsIgnoreCase(ip)){
			ip =  request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if(ip ==null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){       
			ip = request.getRemoteAddr();      
		}
		if("0:0:0:0:0:0:0:1".equals(ip)){
			ip="127.0.0.1";
		}
		return ip;
	}
}
