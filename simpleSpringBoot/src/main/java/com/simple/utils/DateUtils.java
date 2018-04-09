package com.simple.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 日期工具类
 * @author czl
 *
 */
public class DateUtils {
	
	/**
	 * 格式化日期
	 * @param date
	 * @param pattern
	 * @return
	 */
	public static String formatDate(Date date,String pattern){
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		return sdf.format(date);
	}
	
	/**
	 * 格式化字符串
	 * @param date
	 * @param pattern
	 * @return
	 */
	public static Date parseDate(String date,String pattern){
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		Date d = null;
		try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return d;
	}
	
	/**
	 * 两个日期时间差
	 * @param begin
	 * @param end
	 * @param type second/minute/hour/day/month/year
	 * @return
	 */
	public static int getTimeDifference(Date begin,Date end,String type){
		return calculateTimeDifference(begin, end, type);
	}
	
	public static int calculateTimeDifference(Date begin,Date end,String type){
		//1000毫秒=1秒
		long time;
		int i = 1;
		switch (type) {
		case "second":
			i = i*1000;
			break;
		case "minute":
			i = i*1000*60;
			break;
		case "hour":
			i = i*1000*60*60;
			break;
		case "day":
			i = i*1000*60*60*24;
			break;
		case "month":
			return getSpecialTimeDifference(begin, end, "month");
		case "year":
			return getSpecialTimeDifference(begin, end, "year");
		default:
			break;
		}
		time = (end.getTime()-begin.getTime())/i;
		return new Long(time).intValue();
	}
	
	public static int getSpecialTimeDifference(Date begin,Date end,String type){
		int i = 0;
        Calendar c1 = Calendar.getInstance();
        Calendar c2 = Calendar.getInstance();
        c1.setTime(begin);
        c2.setTime(end);
        if(type.equals("month")){
        	i = c2.get(Calendar.MONTH) - c1.get(Calendar.MONTH);
        }else if(type.equals("year")){
        	i = c2.get(Calendar.YEAR) - c1.get(Calendar.YEAR);
        }
        return i == 0 ? 1 : Math.abs(i);
	}
}
