package com.simple.utils;

/**
 * 字符串工具类
 * @author czl
 *
 */
public class StringUtils {
	
	public static boolean isEmpty(String s){
		if(s==null||s.equals("")){
			return true;
		}
		return false;
	}
	
	public static boolean isNotEmpty(String s){
		if(s!=null&&!s.equals("")){
			return true;
		}
		return false;
	}
	
	public static boolean contain(String target,String e){
		char[] ch = target.toCharArray();
		for (char c : ch) {
			if(e.equals(c)){
				return true;
			}
		}
		return false;
	}
	
	public static int charAt(String target,String e){
		char[] ch = target.toCharArray();
		for (int i = 0; i < ch.length; i++) {
			char c = ch[i];
			if(e.equals(c)){
				return i;
			}
		}
		return -1;
	}
	
}
