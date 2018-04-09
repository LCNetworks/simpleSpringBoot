package com.simple.utils;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.Properties;

public class BackUpUtil {
	
	/**
	 * 备份单表
	 * @param map (table 表名)
	 */
	public static void backupTable(Map<String,Object> map){
		Properties props = new Properties();
		{
			try {
				props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("jdbc.properties"));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	    Runtime runtime =  Runtime.getRuntime();
	    //命令行头部 判断windos 还是linux
	    String command = "";
	    String os = System.getProperty("os.name");  
	    //格式化当前日期
	  	String curdate =  "$(date +%Y%m%d)";
	  	
	  	if(os.toLowerCase().startsWith("win")){  
	    	command = "cmd /c ";
	    	curdate = "%date:~0,4%%date:~5,2%%date:~8,2%";
	    }
	  	//表名 改为传值
	  	String table = (String) map.get("table");//"F_LOGS"
	  	//项目路径/backup/表名=表备份路径 初始化路径
	  	String table_backup_root =   PropUtils.get("web.root")+"backup/"+table;
	  	if(!new File(table_backup_root).exists()){
	  		new File(table_backup_root).mkdirs();
	  	}
	    //jdbc:dm://172.16.105.21:5236 原样截取成 172.16.105.21:5236 拼接路径
	    String dm_path =  PropUtils.get("dm.path");
	    String oriurl = props.getProperty("dmjdbc.url");
		oriurl = oriurl.substring(oriurl.indexOf("//")+2, oriurl.length());
		String dburl =  props.getProperty("dmjdbc.usernameA")+"/"+props.getProperty("dmjdbc.passwordA")+"@"+oriurl;
		String query = "";
		if(map.get("query")!=null&&!map.get("query").equals("")){
			query = " query="+(String) map.get("query");
		}
		System.out.println(command+dm_path+" USERID="+dburl+" FILE="+curdate+"_"+table+".dmp LOG="+curdate+"_"+table+".log TABLES="+table+" DIRECTORY="+table_backup_root+query);
		try {
			runtime.exec(command+dm_path+" USERID="+dburl+" FILE="+curdate+"_"+table+".dmp LOG="+curdate+"_"+table+".log TABLES="+table+" DIRECTORY="+table_backup_root+query);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
	  }
}
