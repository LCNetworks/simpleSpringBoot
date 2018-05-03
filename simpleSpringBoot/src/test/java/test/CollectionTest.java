package test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.function.Consumer;

import org.junit.Test;

import junit.framework.TestCase;

public class CollectionTest extends TestCase{
	
	/**
	 * set,map
	 */
	@Test
	public void test1(){
		Map<String,Object> map = new HashMap<String,Object>();
		Set<String> set = new HashSet<String>();
		for (int i = 0; i < 10; i++) {
			set.add(String.valueOf(i));
		}
		for (String string : set) {
			map.put(string, string);
		}
		for (Entry<String, Object> entry : map.entrySet()) {
			System.out.println(entry.getKey()+"||"+entry.getKey());
		}
	}
	
	/**
	 * map
	 */
	@Test
	public void test2(){
		
	}
	
	@Test
	public void test3(){
		//原始数据list
		List<String> list = new ArrayList<String>(Arrays.asList("abc","acb","bca","woi","owi","lol"));
		//大list
		List<List<String>> bigList = new ArrayList<List<String>>();
		Map<String,Integer> eqMap = new HashMap<String,Integer>();
		for (int i = 0; i < list.size(); i++) {
			//获取字符串所有字符
			char[] ch = list.get(i).toCharArray();
			//字符重新排序 并组成新字符串
			Arrays.sort(ch);
			String s = String.valueOf(ch);
			int n = bigList.size();
			//如果重新排序的字符 在map中不存在 则在大list中添加一个小list 并把元素记录插入到小list中 并记录下大list的下标 添加一次n累加
			//否则 找到map中该字符串在大list中的下标 通过下标找到小list并插入元素字符串
			if(eqMap.get(s)==null){
				//map中放的是字符串为key,下标为value
				eqMap.put(s,n);
				bigList.add(n, new ArrayList<String>());
				bigList.get(n).add(list.get(i));
			}else{
				bigList.get(eqMap.get(s)).add(list.get(i));
			}
		}
		System.out.println(bigList);
	}
	
	@Test
	public void test4(){
		//原始数据list
		List<String> list = new ArrayList<String>(Arrays.asList("abc","acb","bca","woi","owi","lol"));
		//大list
		List<List<String>> bigList = new ArrayList<List<String>>();
		Map<String,Integer> eqMap = new HashMap<String,Integer>();
		list.forEach((x)->{
			char[] ch = x.toCharArray();
			Arrays.sort(ch);
			String s = String.valueOf(ch);
			//如果重新排序的字符 在map中不存在 则在大list中添加一个小list 并把元素记录插入到小list中 并记录下大list的下标 添加一次n累加
			//否则 找到map中该字符串在大list中的下标 通过下标找到小list并插入元素字符串
			int n = bigList.size();
			if(eqMap.get(s)==null){
				//map中放的是字符串为key,下标为value
				eqMap.put(s,n);
				bigList.add(n, new ArrayList<String>());
				bigList.get(n).add(x);
			}else{
				bigList.get(eqMap.get(s)).add(x);
			}
		});
		System.out.println(bigList);
	}
}
