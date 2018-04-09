package com.simple.server.activemq;

import javax.jms.JMSException;

public class TestComsume {
	public static void main(String[] args) {
		getQueueMessage("123");
		getTopicMessage("123");
	}
	
	public static void getQueueMessage(String disname){
		Comsumer c = new Comsumer();
		c.init();
		c.getMessage(disname);
		try {
			c.getSession().close();
		} catch (JMSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void getTopicMessage(String disname){
		Comsumer c = new Comsumer();
		c.init();
		c.getTopicMessage(disname);
		try {
			c.getSession().close();
		} catch (JMSException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
