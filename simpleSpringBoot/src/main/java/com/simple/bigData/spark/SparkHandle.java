package com.simple.bigData.spark;

import java.util.regex.Pattern;

import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function;
import org.springframework.beans.factory.annotation.Autowired;

public class SparkHandle {
	
	private static final Pattern SPACE = Pattern.compile(" ");
	
	@Autowired
    private transient static JavaSparkContext sc;
	
	public static void sc(){
		JavaRDD<String> lines = sc.textFile("D:/123.xml");
		lines.map(new Function<String, String>() {
            @Override
            public String call(String s) throws Exception {
                System.out.println(s);
                return s;
            }
        });
	}
	public static void main(String[] args) {
		sc();
	}
}
