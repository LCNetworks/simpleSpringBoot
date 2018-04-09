package com.simple.cache;

import java.util.Date;
import java.util.Hashtable;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.simple.entity.UserErrorLogin;

/**
 * 用户登录错误池
 * @author czl
 *
 */
@Component
public class UserErrorLoginCache {
	
	//用户错误登录
	private static Hashtable<String, UserErrorLogin> userErrorLoginPool = new Hashtable<String, UserErrorLogin>();

	public static Hashtable<String, UserErrorLogin> getUserErrorLoginPool() {
		return userErrorLoginPool;
	}

	public static void setUserErrorLoginPool(Hashtable<String, UserErrorLogin> userErrorLoginPool) {
		UserErrorLoginCache.userErrorLoginPool = userErrorLoginPool;
	}
	
	//增加or修改用户
	public static void modifyUserInPool(Map<String, Object> map){
		userErrorLoginPool.put((String) map.get("loginname"), (UserErrorLogin) map.get("userErrorLogin"));
	}
	
	//移除用户
	public static void removeUserInPool(Map<String, Object> map){
		userErrorLoginPool.remove((String) map.get("loginname"));
	}
	
	//获取用户session
	public static UserErrorLogin getSessionInPoll(Map<String, Object> map){
		return userErrorLoginPool.get((String) map.get("loginname"));
	}
	
	//用户是否存在
	public static boolean existUserInPoll(Map<String, Object> map){
		if(userErrorLoginPool.get((String) map.get("loginname"))!=null){
			return true;
		}else{
			return false;
		}
	}
	
	//用户是否超过登录限制
	public static boolean isOverCount(Map<String, Object> map){
		if(userErrorLoginPool.get((String) map.get("loginname"))!=null&&userErrorLoginPool.get((String) map.get("loginname")).getCount()==5){
			return true;
		}else{
			return false;
		}
	}
	
	//用户是否超过登录限制
	public static boolean isOverLimitDate(Map<String, Object> map){
		if(userErrorLoginPool.get((String) map.get("loginname"))!=null){
			Long now = new Date().getTime();
			Long limit = userErrorLoginPool.get((String) map.get("loginname")).getDate().getTime();
			double minutes = (double) ((now - limit)/(1000 * 60)); 
			if(minutes>1){
				return true;
			}else{
				return false;
			}
		}
		return true;
	}
	
	//递增
	public static void addCount(Map<String, Object> map){
		UserErrorLogin userErrorLogin = userErrorLoginPool.get((String) map.get("loginname"));
		userErrorLogin.setCount(userErrorLogin.getCount()+1);
		map.put((String) map.get("loginname"), userErrorLogin);
		UserErrorLoginCache.modifyUserInPool(map);
	}
}
