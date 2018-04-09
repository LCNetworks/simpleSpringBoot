package com.simple.utils;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.lowagie.text.DocumentException;
import com.lowagie.text.PageSize;
import com.lowagie.text.html.simpleparser.HTMLWorker;
import com.lowagie.text.html.simpleparser.StyleSheet;
import com.lowagie.text.rtf.RtfWriter2;

public class WordPdfUtil {
	
public static String generatePdf(String text,String name,HttpServletResponse response){
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss@");
	String path = PropUtils.get("web.root")+"pdf/"+sdf.format(new Date())+name+".pdf";
	if(!new File(PropUtils.get("web.root")+"pdf/").exists()){
		new File(PropUtils.get("web.root")+"pdf/").mkdirs();
	}
	Document document = new Document(); 
	String style = "<style>"
    		
    		+"</style>";
    text = text.substring(0, text.indexOf("<!-- 页面终止 -->"));
    text = "<!DOCTYPE html>"
    +"<html>"  
    +"<head>"  
    +style
    +"<meta charset=\"UTF-8\"></meta></head><body>"+text
    +"</body></html>";
    text = text.replaceAll("<table","<table border=\"1\"");
    try {  
        PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(path));
        document.open();
        InputStream inputStream=null;
        XMLWorkerHelper.getInstance().parseXHtml(writer, document,new ByteArrayInputStream(text.getBytes("UTF-8")),inputStream,Charset.forName("UTF-8"),new AsianFontProvider());
        document.close();
        System.out.println("文档创建成功");  
    }catch(Exception e) {  
        e.printStackTrace();  
    } 
    return path;
}

public static String generateWord(String text,String name,HttpServletResponse response){
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss@");
	String path = PropUtils.get("web.root")+"doc/"+sdf.format(new Date())+name+".doc";
	if(!new File(PropUtils.get("web.root")+"doc/").exists()){
		new File(PropUtils.get("web.root")+"doc/").mkdirs();
	}
	OutputStream out = null;
	try {
		out = new FileOutputStream(path);
	} catch (FileNotFoundException e3) {
		// TODO Auto-generated catch block
		e3.printStackTrace();
	}  
    com.lowagie.text.Document document = new com.lowagie.text.Document(PageSize.A4);
    RtfWriter2.getInstance(document, out);  
    document.open();  
    com.lowagie.text.Paragraph context = new com.lowagie.text.Paragraph();  
    String style = "<style>"
    		
    		+"</style>";
    text = text.substring(0, text.indexOf("<!-- 页面终止 -->"));
    text = "<!DOCTYPE html>"
    +"<html>"  
    +"<head>"  
    +style
    +"<meta charset=\"UTF-8\"></meta></head><body>"+text
    +"</body></html>";
    text = text.replaceAll("<table","<table border=\"1\"");
    StyleSheet ss = new StyleSheet();  
    List htmlList = null;
	try {
		htmlList = HTMLWorker.parseToList(new StringReader(text), ss);
	} catch (IOException e2) {
		// TODO Auto-generated catch block
		e2.printStackTrace();
	}  
    for (int i =0 ; i < htmlList.size(); i++){  
        com.lowagie.text.Element e = (com.lowagie.text.Element) htmlList.get(i);  
        context.add(e);  
    }  
    try {
		document.add(context);
	} catch (DocumentException e1) {
		// TODO Auto-generated catch block
		e1.printStackTrace();
	}  
    document.close();  
    System.out.println("文档创建成功");
    return path;
}
}
