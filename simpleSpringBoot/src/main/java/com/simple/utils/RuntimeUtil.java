package com.simple.utils;

import java.io.IOException;

/**
 * 运行时工具类
 * @author czl
 *
 */
public class RuntimeUtil {
	
	private static Runtime rt;
	
	static{
		rt = Runtime.getRuntime();
	}
	
	
	public static Runtime getRt() {
		return rt;
	}


	public static void setRt(Runtime rt) {
		RuntimeUtil.rt = rt;
	}


	public static void exec(String command){
		try {
			rt.exec(command);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
