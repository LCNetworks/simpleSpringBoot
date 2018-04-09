package com.simple.server.activemq;

import java.util.concurrent.atomic.AtomicInteger;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.JMSException;
import javax.jms.MessageConsumer;
import javax.jms.Queue;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.jms.Topic;

import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

/**
 * 消费者
 * @author czl
 *
 */
public class Comsumer {

    private static final String USERNAME = ActiveMQConnection.DEFAULT_USER;

    private static final String PASSWORD = ActiveMQConnection.DEFAULT_PASSWORD;

    private static final String BROKEN_URL = ActiveMQConnection.DEFAULT_BROKER_URL;

    ConnectionFactory connectionFactory;

    Connection connection;

    Session session;

    ThreadLocal<MessageConsumer> threadLocal = new ThreadLocal<>();
    AtomicInteger count = new AtomicInteger();

    public void init(){
        try {
            connectionFactory = new ActiveMQConnectionFactory(USERNAME,PASSWORD,BROKEN_URL);
            connection  = connectionFactory.createConnection();
            connection.start();
            session = connection.createSession(false,Session.AUTO_ACKNOWLEDGE);
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }

    //普通文本消息
    public void getMessage(String disname){
        try {
            Queue queue = session.createQueue(disname);
            MessageConsumer consumer = null;

            if(threadLocal.get()!=null){
                consumer = threadLocal.get();
            }else{
                consumer = session.createConsumer(queue);
                threadLocal.set(consumer);
            }
            while(true){
                TextMessage msg = (TextMessage) consumer.receive();
                if(msg!=null) {
                    msg.acknowledge();
                    System.out.println(Thread.currentThread().getName()+": Consumer:我是消费者，我正在消费Msg"+msg.getText()+"--->"+count.getAndIncrement());
                }else {
                    break;
                }
            }
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }
    
    //广播普通文本信息
    public void getTopicMessage(String disname){
        try {
        	Topic topic = session.createTopic(disname);
            MessageConsumer consumer = null;

            if(threadLocal.get()!=null){
                consumer = threadLocal.get();
            }else{
                consumer = session.createConsumer(topic);
                threadLocal.set(consumer);
            }
            while(true){
                TextMessage msg = (TextMessage) consumer.receive();
                if(msg!=null) {
                    msg.acknowledge();
                    System.out.println(Thread.currentThread().getName()+": Consumer:我是消费者，我正在消费Msg"+msg.getText()+"--->"+count.getAndIncrement());
                }else {
                    break;
                }
            }
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }
    
    public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}
}
