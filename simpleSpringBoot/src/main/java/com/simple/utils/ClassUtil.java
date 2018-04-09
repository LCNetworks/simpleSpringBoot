package com.simple.utils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;

/**
 * class工具类
 * @author czl
 *
 */
public class ClassUtil {
	
	//反射调用某个类方法
	public Object runMethod(String className,String methodName,Class<?> returnType,Object o,Map<String ,Object> paramMap){
		Object returnObj = null;
		Class<?> c;
		Method method;
		//里面写自己的类名及路径
		try {
			c = Class.forName(className);
			//第一个参数写的是方法名,第二个\第三个\...写的是方法参数列表中参数的类型
			method=c.getMethod(methodName, returnType.getClass());
			if(o==null){
				o = c.newInstance();
			}
			returnObj = method.invoke(c.newInstance(), new Object[]{paramMap});
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return returnObj;
	}
}
