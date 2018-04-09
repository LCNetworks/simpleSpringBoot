package com.simple.server;

import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import com.simple.utils.WebSocketUtils;

/**
 * webSocket服务池
 * @author czl
 *
 */

@ServerEndpoint(value="/webSocket/{userId}")
public class WebSocketServer {
	
    @OnOpen
    public void onOpen(@PathParam("userId") String userId ,Session session,EndpointConfig config){
    	//userId = getOrgUserid(userId);
    	//System.out.println("ws:启动用户为:"+userId);
        WebSocketUtils.add(userId , session);
    }

    /*
    Send Message
     */
    @OnMessage
    public String onMessage(@PathParam("userId") String userId,String message) {
    	//userId = getOrgUserid(userId);
        if (message.equals("&")){
            return "&";
        }else{
            WebSocketUtils.receive(userId , message);
            return "Got your message ("+ message +").";
        }
    }

    /*
    Errot
     */
    @OnError
    public void onError(@PathParam("userId") String userId,Throwable throwable,Session session) {
    	//userId = getOrgUserid(userId);
        WebSocketUtils.remove(userId);
    }

    /*
    Close Connection
     */
    @OnClose
    public void onClose(@PathParam("userId") String userId,Session session) {
    	//userId = getOrgUserid(userId);
        WebSocketUtils.remove(userId);
    }
    
    public static String getOrgUserid(String userId){
    	return userId.substring(userId.indexOf("user")+4, userId.length());
    }
}
