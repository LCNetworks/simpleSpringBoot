package com.simple.utils;

import com.artofsolving.jodconverter.DocumentConverter;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;

/**
 * Created by Administrator on 2017-07-21.
 */
public class OpenOfficeUtil {

	/**
	 * 转换
	 * @param file
	 * @param outputFile
	 * @throws IOException
	 */
	public static void converter(File file, File outputFile) throws IOException {
		
		Process p = null;
		
		if(StringUtils.isNotEmpty(PropUtils.get("soffice"))){
			// 调用openoffice服务线程
			String command = PropUtils.get("soffice") + " -headless -accept=\"socket,host=127.0.0.1,port=8100;urp;\"";
			p = Runtime.getRuntime().exec(command);
		}

		// 连接openoffice服务
		OpenOfficeConnection connection = new SocketOpenOfficeConnection("127.0.0.1", 8100);
		connection.connect();
		
		// 转换word到pdf
		DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
		converter.convert(file, outputFile);
		
		// 关闭连接
		connection.disconnect();

		if(StringUtils.isNotEmpty(PropUtils.get("soffice"))){
			// 关闭进程
			p.destroy();
		}
		
	}

	/**
	 * 预览
	 * @param filepath
	 * @param filename
	 * @param response
	 * @return
	 */
	public static int preview(String filepath, String filename, HttpServletResponse response) {
		try {
			response.setCharacterEncoding("utf-8");
			URL u = new URL("file:///" + filepath);
			String contentType = u.openConnection().getContentType();
			response.setContentType(contentType);

			File file = new File(filepath);
			if (file.exists() == false) {
				response.getWriter().print("<script>alert('文件不存在了');history.go(-1)</script>");
				return -1;
			}

			String suffix = file.getName().substring(file.getName().lastIndexOf("."));
			response.setHeader("Content-Disposition", "inline;fileName=" + new String(filename.getBytes("gbk"), "iso-8859-1") + suffix);
			InputStream inputStream = inputStream = new FileInputStream(filepath);

			int fileLength = (int) file.length();
			response.setContentLength(fileLength);

			OutputStream os = response.getOutputStream();

			byte[] b = new byte[2048];
			int length;
			response.reset();
			while ((length = inputStream.read(b)) > 0) {
				os.write(b, 0, length);
			}
			os.close();
			inputStream.close();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.gc();
		return 0;
	}
}
