package com.simple.server;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Timer;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * socketServer 工具类
 * @author admin
 *
 */
public class SocketServer {
	
	/**
	 * socket使用于c/s架构 或者说适用于 程序之间通讯
	 * 如果需要在web端(浏览器端) 应选用websocket 相当于浏览器承担客户端的作用 因此需要浏览器支持websocket通讯
	 */
	
	/**
	 * 创建socketServer
	 * @param port
	 * @param maxPool
	 * @param available
	 * @throws IOException
	 */
	@Deprecated
	public static void createServer(int port,int maxPool,Integer available) throws IOException{
		ServerSocket server = new ServerSocket(port);
	    //如果使用多线程，那就需要线程池，防止并发过高时创建过多线程耗尽资源
	    ExecutorService threadPool = Executors.newFixedThreadPool(maxPool);
	    while (true) {
	    	System.out.println("连接");
			Socket socket = server.accept();
			Runnable runnable=()->{
	        try {
	          // 建立好连接后，从socket中获取输入流，并建立缓冲区进行读取
	          InputStream inputStream = socket.getInputStream();
	          byte[] bytes = new byte[inputStream.available()];
	          if(available!=null){
	        	  bytes = new byte[available];
	          }
	          int len;
	          StringBuilder sb = new StringBuilder();
	          while ((len = inputStream.read(bytes)) != -1) {
	            // 注意指定编码格式，发送方和接收方一定要统一，建议使用UTF-8
	            sb.append(new String(bytes, 0, len, "UTF-8"));
	          }
	          System.out.println("get message from client: " + sb);
	          OutputStream outputStream = socket.getOutputStream();
	          outputStream.write("Hello Client,I get the message.".getBytes("UTF-8"));
	          inputStream.close();
	          socket.close();
	        } catch (Exception e) {
	          e.printStackTrace();
	        }
	      };
	      threadPool.submit(runnable);
	    }
	}
	
	/**
	 * 创建socketClient
	 * @param host
	 * @param port
	 * @throws UnknownHostException
	 * @throws IOException
	 */
	@Deprecated
	public static void createClient(String host , int port) throws UnknownHostException, IOException{
		// 要连接的服务端IP地址和端口
	    // 与服务端建立连接
	    Socket socket = new Socket(host, port);
	    // 建立连接后获得输出流
	    OutputStream outputStream = socket.getOutputStream();
	    String message = "你好";
	    //首先需要计算得知消息的长度
	    byte[] sendBytes = message.getBytes("UTF-8");
	    //然后将消息的长度优先发送出去
	    outputStream.write(sendBytes.length >>8);
	    outputStream.write(sendBytes.length);
	    //然后将消息再次发送出去
	    outputStream.write(sendBytes);
	    outputStream.flush();
	    //==========此处重复发送一次，实际项目中为多个命名，此处只为展示用法
	    message = "第二条消息";
	    sendBytes = message.getBytes("UTF-8");
	    outputStream.write(sendBytes.length >>8);
	    outputStream.write(sendBytes.length);
	    outputStream.write(sendBytes);
	    outputStream.flush();
	    //==========此处重复发送一次，实际项目中为多个命名，此处只为展示用法
	    message = "the third message!";
	    sendBytes = message.getBytes("UTF-8");
	    outputStream.write(sendBytes.length >>8);
	    outputStream.write(sendBytes.length);
	    outputStream.write(sendBytes);    
	    
	    outputStream.close();
	    socket.close();
	}
}
