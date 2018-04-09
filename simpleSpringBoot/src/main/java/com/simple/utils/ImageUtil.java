package com.simple.utils;

import java.io.File;
import java.io.IOException;
import java.util.List;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import com.simple.entity.Image;

public class ImageUtil {
	public static Image getImgGPS(File jpegFile) throws ImageProcessingException, IOException{
		Metadata metadata = ImageMetadataReader.readMetadata(jpegFile); 
		Image img = new Image();
        for (Directory directory : metadata.getDirectories()) { 
            for (Tag tag : directory.getTags()) { 
                String tagName = tag.getTagName();  //标签名
                String desc = tag.getDescription(); //标签信息
                if (tagName.equals("Image Height")) { 
                	img.setHeight(desc);
                    System.out.println("图片高度: "+desc);
                } else if (tagName.equals("Image Width")) { 
                	img.setWidth(desc);
                    System.out.println("图片宽度: "+desc);
                } else if (tagName.equals("Date/Time Original")) { 
                	img.setDate(desc);
                    System.out.println("拍摄时间: "+desc);
                }else if (tagName.equals("GPS Latitude")) { 
                	img.setLatitude(desc);
                    System.err.println("纬度 : "+desc);
//                  System.err.println("纬度(度分秒格式) : "+pointToLatlong(desc));
                } else if (tagName.equals("GPS Longitude")) { 
                	img.setLongitude(desc);
                    System.err.println("经度: "+desc);
//                  System.err.println("经度(度分秒格式): "+pointToLatlong(desc));
                }
            } 
        }  
        return img;
	}
	
	public static void main(String[] args) throws ImageProcessingException, IOException {
		Image img = ImageUtil.getImgGPS(new File("D:/新建文件夹/1513662345631.jpg"));
		Double lat = AddressUtil.convertToGPS(img.getLatitude());
		Double log = AddressUtil.convertToGPS(img.getLongitude());
		if(lat!=null&&log!=null){
			String res = AddressUtil.getposition(lat.toString(), log.toString());
			String addr = AddressUtil.getAddress(res);
			System.out.println(addr);
		}else{
			System.out.println("该图片无gps信息");
		}
	}
}
