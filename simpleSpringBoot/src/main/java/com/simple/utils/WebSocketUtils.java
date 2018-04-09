package com.simple.utils;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.Session;

/**
 * websocket 工具类
 * @author czl
 *
 */

public class WebSocketUtils {
	private static Map<String, Session> clients = new ConcurrentHashMap<String, Session>(); 
	

    public static Map<String, Session> getClients() {
		return clients;
	}

	public static void setClients(Map<String, Session> clients) {
		WebSocketUtils.clients = clients;
	}

	public static void add(String userId, Session session) {
		Map<String, Session> clients = WebSocketUtils.getClients();
		if(WebSocketUtils.existUser(userId)){
			clients.remove(userId);
		}
    	clients.put(userId,session);
    }

    public static void receive(String userId, String message) {
    }

    public static void remove(String userId) {
    	Map<String, Session> clients = WebSocketUtils.getClients();
        clients.remove(userId);
    }

    public static boolean sendMessage(String userId , String message) {
    	Map<String, Session> clients = WebSocketUtils.getClients();
        if(clients.get(userId) == null){
            return false;
        }else{
            clients.get(userId).getAsyncRemote().sendText(message);
            return true;
        }
    }
    
    public static Session getSession(String userId){
    	if(clients.get(userId)!=null){
    		return clients.get(userId);
    	}
    	return null;
    }
    
    public static boolean existUser(String userId){
    	if(clients.get(userId)!=null){
    		return true;
    	}
    	return false;
    }
    
    public static void closeSession(Session session){
    	try {
			session.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
