package com.simple.utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public abstract class MD5Util {
	
	//可自定义MD5
	public static String encryp(String source) {
		char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(source.getBytes());
			byte[] tmp = md.digest();

			char[] str = new char[32];
			int k = 0;
			for (int i = 0; i < 16; i++) {
				byte byte0 = tmp[i];
				str[(k++)] = hexDigits[(byte0 >>> 4 & 0xF)];

				str[(k++)] = hexDigits[(byte0 & 0xF)];
			}
			return new String(str);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * MD5加密
	 * @param str
	 * @return
	 */
	public static String toMD5(String str) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			try {
				md.update(str.getBytes("UTF-8"));
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			byte[] encryContext = md.digest();
			int i;
			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < encryContext.length; offset++) {
				i = encryContext[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			return buf.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return str;
	}
	
	
	public static void main(String[] args) {
		String string = toMD5("111111");
		System.out.println(string);
		
	}
	
}