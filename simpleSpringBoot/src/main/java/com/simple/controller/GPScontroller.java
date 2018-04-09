package com.simple.controller;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.drew.imaging.ImageProcessingException;
import com.simple.common.Common;
import com.simple.entity.Image;
import com.simple.utils.AddressUtil;
import com.simple.utils.ExcelUtil;
import com.simple.utils.ImageUtil;

@RestController
@RequestMapping("simple/gps")
public class GPScontroller extends AbstractController{
	
	@RequestMapping("getAddress")
	@ResponseBody
	public String getAddress(@RequestParam("files") MultipartFile[] files,HttpServletRequest request,HttpServletResponse response) throws IOException, ImageProcessingException{
		JSONArray resultArr = new JSONArray();
		JSONObject result = new JSONObject();
		String filePath ="";
		for (MultipartFile file : files) {
			result = new JSONObject();
			result.put("file", file.getOriginalFilename());
			// 判断文件是否为空  
	        if (!file.isEmpty()) {  
	            try {  
	                // 文件保存路径  
	            	String systemUpPath =Common.getFileInfo("Configuration.properties","upload.url");
	            	filePath= systemUpPath  
	                        +System.currentTimeMillis()+"_"+ file.getOriginalFilename();  
	            	if(!new File(systemUpPath).exists()){
	            		new File(systemUpPath).mkdirs();
	                }
	            	// 转存文件  
	            	System.out.println(file.getOriginalFilename());
	                file.transferTo(new File(filePath));  
	            } catch (Exception e) {  
	                e.printStackTrace();  
	            } 
	            Image img = ImageUtil.getImgGPS(new File(filePath));
	    		Double lat = AddressUtil.convertToGPS(img.getLatitude());
	    		Double log = AddressUtil.convertToGPS(img.getLongitude());
	    		if(lat!=null&&log!=null){
	    			String res = AddressUtil.getposition(lat.toString(), log.toString());
	    			String addr = AddressUtil.getAddress(res);
	    			result.put("addr", addr);
	    		}else{
	    			result.put("error", "该图片无gps信息!");
	    		}
	        }else{
	        	result.put("error", "文件上传失败!");
	        }
	        resultArr.add(result);
		}
        return resultArr.toJSONString(); 
	}
	
	@RequestMapping("downloadHistory")
	public void downloadHistory(String msg , HttpServletRequest request,HttpServletResponse response){
		String[] arr = msg.split(",");
		List<Map<String,String>> l = new ArrayList<Map<String,String>>();
		for (int i = 0; i < arr.length; i++) {
			String string = arr[i];
			Map<String,String> map = new HashMap<String,String>();
			String name = string.substring(0,string.indexOf(" -- "));
			String value = string.substring(string.indexOf(" -- ")+4,string.length()-1);
			map.put("name", name);
			map.put("value", value);
			l.add(map);
		}
		 HSSFWorkbook wb = new HSSFWorkbook();  
         //创建一个sheet  
         HSSFSheet sheet = wb.createSheet("历史记录");
         
         //表头
         HSSFRow r = sheet.createRow(0);
         HSSFCellStyle cellStyleTitle= ExcelUtil.cellStyleTitle(wb);
         for (int i = 0; i < 3; i++) {
        	 HSSFCell c = r.createCell(i);
        	 c.setCellStyle(cellStyleTitle);
		 }
         r.getCell(0).setCellValue("序号");
         r.getCell(1).setCellValue("图片");
         r.getCell(2).setCellValue("地址");
         
         for (int row = 0; row < l.size(); row++)
         {
        	 Map<String,String> map = l.get(row);
        	 HSSFRow rows = sheet.createRow(row+1);
        	 HSSFCellStyle cellStyle= ExcelUtil.cellStyle(wb);
        	 for (int i = 0; i < 3; i++) {
            	 HSSFCell c = rows.createCell(i);
            	 c.setCellStyle(cellStyle);
    		 }
        	 rows.getCell(0).setCellValue(row+1);
        	 rows.getCell(1).setCellValue(map.get("name"));
        	 rows.getCell(2).setCellValue(map.get("value"));
        	 
         }
         OutputStream output = null;
		try {
			output = response.getOutputStream();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
         response.reset();
         try {
			response.setHeader("Content-disposition", "attachment; filename="+ new String(new String("历史记录").getBytes("utf-8"), "ISO-8859-1"));
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
         response.setContentType("application/msexcel");        
         try {
			wb.write(output);
			output.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(l);
	}
	
	@RequestMapping("hello")
	public void Hello(HttpServletRequest request,HttpServletResponse response) throws IOException{
		response.getWriter().print("1");
	}
}
