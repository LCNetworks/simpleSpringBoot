package com.simple.utils;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;




/**
 * 读取配置文件类
 * @Author: XUCHENG 2017-3-14
 * @Description: 
 */
public class PropUtils {
	private static Properties props = new Properties();
	static {
		try {
			props.load(Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("Configuration.properties"));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String get(String key) {
		return props.getProperty(key);
	}

	public static void set(String key, String value) {
		props.setProperty(key, value);
	}
}

