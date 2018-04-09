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
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.html.simpleparser.HTMLWorker;
import com.lowagie.text.html.simpleparser.StyleSheet;
import com.lowagie.text.rtf.RtfWriter2;
import com.mysql.jdbc.util.Base64Decoder;

import sun.misc.BASE64Decoder;

public class ScreenshotUtil {
    public String generatePdf(String data, String name,
        HttpServletResponse response) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyymmdd");
        String path = PropUtils.get("web.root") + "pdf/" +
            sdf.format(new Date()) + name + ".pdf";

        if (!new File(PropUtils.get("web.root") + "pdf/").exists()) {
            new File(PropUtils.get("web.root") + "pdf/").mkdirs();
        }

        String docpath = generateWord(data, name, response);

        try {
            OpenOfficeUtil.converter(new File(docpath), new File(path));
        } catch (IOException e) {
            // TODO 自动生成的 catch 块
            e.printStackTrace();
        }

        return path;
    }

    public String generateWord(String data, String name,
        HttpServletResponse response) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyymmdd");
        String path = PropUtils.get("web.root") + "doc/" +
            sdf.format(new Date()) + name + ".doc";

        if (!new File(PropUtils.get("web.root") + "doc/").exists()) {
            new File(PropUtils.get("web.root") + "doc/").mkdirs();
        }

        try {
            // 通过base64来转化图片
            String imageFile = data.replaceAll("data:image/png;base64,", "");
            BASE64Decoder decoder = new BASE64Decoder();

            // Base64解码      
            byte[] imageByte = null;

            try {
                imageByte = decoder.decodeBuffer(imageFile);

                for (int i = 0; i < imageByte.length; ++i) {
                    if (imageByte[i] < 0) { // 调整异常数据      
                        imageByte[i] += 256;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            String imgFilePath = PropUtils.get("web.root") + "jpg/" +
                new Date().getTime() + ".png";

            if (!new File(PropUtils.get("web.root") + "jpg/").exists()) {
                new File(PropUtils.get("web.root") + "jpg/").mkdirs();
            }

            OutputStream imageStream = new FileOutputStream(imgFilePath);
            imageStream.write(imageByte);
            imageStream.flush();
            imageStream.close();

            com.lowagie.text.Document doc = null;

            try {
                doc = new com.lowagie.text.Document(PageSize.A3);
                RtfWriter2.getInstance(doc, new FileOutputStream(new File(path)));
                doc.open(); //打开E盘中的word文档  

                Image img = Image.getInstance(imgFilePath);
                img.setAbsolutePosition(0, 0);
                img.scaleAbsolute(PageSize.A3.getWidth(),
                    PageSize.A3.getHeight() - 50); // 直接设定显示尺寸
                img.setAlignment(Image.LEFT); // 设置图片显示位置
                doc.add(img);
                doc.close();
            } catch (Exception e) {
                // TODO Auto-generated catch block  
                e.printStackTrace();
            }
        } catch (Exception e) {
        }

        return path;
    }
}
