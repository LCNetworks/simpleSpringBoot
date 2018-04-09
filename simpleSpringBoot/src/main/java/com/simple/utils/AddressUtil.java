package com.simple.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;



public class AddressUtil {
	/**
     * 输入地址返回经纬度坐标 
     * key lng(经度),lat(纬度) 
     */
    public static String getposition(String latitude, String longitude){
    	//lat 小  log  大  
	    //参数解释: 纬度,经度 type 001 (100代表道路，010代表POI，001代表门址，111可以同时显示前三项)  
    	if(latitude==null&&longitude==null){
    		return "";
    	}
	    String urlString = "http://gc.ditu.aliyun.com/regeocoding?l="+latitude+","+longitude+"&type=111";  
	    String res = "";     
	    try {     
	        URL url = new URL(urlString);    
	        java.net.HttpURLConnection conn = (java.net.HttpURLConnection)url.openConnection();    
	        conn.setDoOutput(true);    
	        conn.setRequestMethod("POST");    
	        java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(),"UTF-8"));    
	        String line;    
	       while ((line = in.readLine()) != null) {    
	           res += line+"\n";    
	     }    
	        in.close();    
	    } catch (Exception e) {    
	        System.out.println("error in wapaction,and e is " + e.getMessage());    
	    }   
	    return res;    
    }
    
  //照片的度分秒转gps
    public static Double convertToDegree(String stringDMS){
        Float result = null;
        String[] DMS = stringDMS.split(",", 3);

        String[] stringD = DMS[0].split("/", 2);
        Double D0 = new Double(stringD[0]);
        Double D1 = new Double(stringD[1]);
        Double FloatD = D0/D1;

        String[] stringM = DMS[1].split("/", 2);
        Double M0 = new Double(stringM[0]);
        Double M1 = new Double(stringM[1]);
        Double FloatM = M0/M1;

        String[] stringS = DMS[2].split("/", 2);
        Double S0 = new Double(stringS[0]);
        Double S1 = new Double(stringS[1]);
        Double FloatS = S0/S1;

        result = new Float(FloatD + (FloatM/60) + (FloatS/3600));

        return (double) result;
    }
    
   //照片的度分秒转gps
    public static Double convertToGPS(String stringDMS){
        Float result = null;
        if(stringDMS==null || stringDMS.length()==0){
        	return null;
        }
        String[] DMS = stringDMS.split(" ", 3);

        String stringD = DMS[0].replace("°", "");
        String stringM = DMS[1].replace("'", "");
        String stringS = DMS[2].replace("\"", "");
        
        Double S0 = new Double(stringD);
        Double S1 = new Double(stringM);
        Double S2 = new Double(stringS);

        result = new Float(S0 + (S1/60) + (S2/3600));

        return (double) result;
    }
    
    //StringJson地址转地址
    public static String getAddress(String res){
    	if(res==null||res.length()==0)return null;
    	JSONObject obj = JSON.parseObject(res);
		JSONArray addr =  (JSONArray) obj.get("addrList");
		StringBuilder finalAddr = new StringBuilder();
		String admName = "";
		StringBuilder name = new StringBuilder();
		for (Object object : addr) {
			JSONObject o = (JSONObject) object;
			if(o.get("admName")!=null&&!o.get("admName").equals(""))admName = (String) o.get("admName");
			name.append(o.get("name"));
		}
		finalAddr.append(admName);
		finalAddr.append(name);
		return finalAddr.toString().replaceAll(",", "");
    }
}
