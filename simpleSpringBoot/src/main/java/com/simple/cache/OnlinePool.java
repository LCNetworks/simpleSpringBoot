package com.simple.cache;

import java.util.Hashtable;
import java.util.Map;

import org.springframework.stereotype.Component;

/**
 * 在线用户池
 * @author czl
 *
 */
@Component
public class OnlinePool {
	
	//在线用户
	private static Hashtable<String, Object> userPool = new Hashtable<String, Object>();
	
	
	
	public static Hashtable<String, Object> getUserPool() {
		return userPool;
	}

	public static void setUserPool(Hashtable<String, Object> userPool) {
		OnlinePool.userPool = userPool;
	}

	//增加or修改用户
	public static void modifyUserInPool(Map<String, Object> map){
		Hashtable<String, Object> userPool = OnlinePool.getUserPool();
		userPool.put((String) map.get("userid"), map.get("session"));
	}
	
	//移除用户
	public static void removeUserInPool(Map<String, Object> map){
		Hashtable<String, Object> userPool = OnlinePool.getUserPool();
		userPool.remove((String) map.get("userid"));
	}
	
	//获取用户session
	public static Object getSessionInPoll(Map<String, Object> map){
		Hashtable<String, Object> userPool = OnlinePool.getUserPool();
		return userPool.get((String) map.get("userid"));
	}
	
	//用户是否存在
	public static boolean existUserInPoll(Map<String, Object> map){
		Hashtable<String, Object> userPool = OnlinePool.getUserPool();
		if(userPool.get((String) map.get("userid"))!=null){
			return true;
		}else{
			return false;
		}
	}
	
	//用户及session是否存在
	public static boolean existUserInPollBySession(Map<String, Object> map){
		Hashtable<String, Object> userPool = OnlinePool.getUserPool();
		//存在并且为当前sessionid
		if(userPool.get((String) map.get("userid"))!=null&&userPool.get((String) map.get("userid"))==(map.get("session"))){
			return true;
		}else{
			return false;
		}
	}
}
