package com.simple.server.activemq;

import javax.jms.JMSException;

public class TestProducter {
    public static void main(String[] args){
    	sentQuequMessage("123","你好呀12332!");
    	sentTopicMessage("123","aaa212!");
    }

    public static void sentQuequMessage(String disname,String text){
    	Producter producter = new Producter();
        producter.init();
        producter.sendMessage(disname, text);
    }
    
    public static void sentTopicMessage(String disname,String text){
    	Producter producter = new Producter();
        producter.init();
        producter.sendTopicMessage(disname, text);
    }
}
