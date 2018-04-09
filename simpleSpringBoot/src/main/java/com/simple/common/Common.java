package com.simple.common;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

public class Common {
	public static String getFileInfo(String FileName,String url) {
		Resource rs = new ClassPathResource(FileName);
		Properties properties = new Properties();
		try {
			properties.load(rs.getInputStream());
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return properties.getProperty(url);
	}
}
