package com.simple.task;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class FoldTask {
	
	private static Timer timer; //纬度 
	// 第一种方法：设定指定任务task在指定时间time执行 schedule(TimerTask task, Date time)  
    public static void timer1() throws InterruptedException {  
        timer = new Timer();  
        timer.schedule(new TimerTask() {  
            public void run() {  
            	File file=new File("D:/upload");
            	deleteFolder(file); 
            }  
        }, 2000);// 设定指定的时间time,此处为2000毫秒  
        Thread.sleep(2000);  
        timer.cancel();
    } 
    
    public static void deleteFolder(File file){
        File[] files=file.listFiles();
        for(File f:files){
        	Calendar cal = Calendar.getInstance();
        	SimpleDateFormat format = new SimpleDateFormat("yyyy:MM:dd HH:mm");
        	cal.add(Calendar.DATE, -30);
        	Date limDate = cal.getTime();
        	Date lastDate = new Date(f.lastModified());
        	System.out.println(limDate.getTime());
        	System.out.println(lastDate.getTime());
        	if(lastDate.getTime()<limDate.getTime()){
        		if(f.isDirectory()){
                    //使用递归
                    deleteFolder(f);
                }else{
                    f.delete();
                }
        	}
        }
        //不删除根目录
        //file.delete();
    }
    
    public static void main(String[] args) throws InterruptedException {
    	/*Calendar cal = Calendar.getInstance();
    	SimpleDateFormat format = new SimpleDateFormat("yyyy:MM:dd HH:mm");
    	cal.add(Calendar.DATE, -30);
    	Date date = cal.getTime();
    	System.out.println(format.format(date));*/
    	FoldTask.timer1();
	}
}
