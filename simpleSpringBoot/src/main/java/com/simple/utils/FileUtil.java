package com.simple.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.stream.Stream;

/**
 * 文件工具类
 * @author czl
 *
 */
public class FileUtil {
	
	/**
	 * 创建文件并创建文件路径
	 * @param path
	 * @return
	 */
	public static File newFile(String path){
		FileUtil.mkdirs(path);
		return new File(path);
	}
	
	/**
	 * 文件复制
	 * @param fromFile
	 * @param toFile
	 */
	public static void copyFile(File fromFile,File toFile) {
        FileInputStream fis = null;
        FileOutputStream fos = null;
        byte[] b = null;
        int n=0;
		try {
			fis = new FileInputStream(fromFile);
			fos = new FileOutputStream(toFile);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
        	b = new byte[fis.available()];
			while((n=fis.read(b))!=-1){
				fos.write(b, 0, n);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        finally {
        	closeIo(fis, fos);
		}
    }
	
	/**
	 * 文件复制
	 * @param fromFile
	 * @param toFile
	 * @param size
	 * @throws IOException
	 */
	public static void copyFile(File fromFile,File toFile,int size) throws IOException{
		FileInputStream fis = null;
        FileOutputStream fos = null;
        byte[] b = null;
        int n=0;
		try {
			fis = new FileInputStream(fromFile);
			fos = new FileOutputStream(toFile);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
        	b = new byte[size];
			while((n=fis.read(b))!=-1){
				fos.write(b, 0, n);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        finally {
        	closeIo(fis, fos);
		}
    }
	
	/**
	 * 创建目录
	 * @param path
	 */
	public static void mkdirs(String path){
		File file = new File(path);
		while(!file.isDirectory()){
			if(file.getParentFile().isDirectory()){
				file = file.getParentFile();
			}
		}
		while(file.isDirectory()&&!file.exists()){
			file.mkdirs();
		}
	}
	
	/**
	 * 文件是否存在
	 * @param path
	 * @return
	 */
	public static boolean isExist(String path){
		return new File(path).exists();
	}
	
	/**
	 * 关闭流
	 * @param is
	 */
	public static void closeIo(InputStream is){
		try {
			is.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 关闭流
	 * @param os
	 */
	public static void closeIo(OutputStream os){
		try {
			os.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 关闭流
	 * @param is
	 * @param os
	 */
	public static void closeIo(InputStream is,OutputStream os){
		try {
			is.close();
			os.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
