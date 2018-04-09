package com.simple.common;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

public class SortUtil {
	public static List<Map<String, Object>> SortList(List<Map<String, Object>> list) {
		Collections.sort(list, new Comparator<Map<String, Object>>() {
			@Override
			public int compare(Map<String, Object> o1, Map<String, Object> o2) {
				// TODO Auto-generated method stub
				Integer Count1 = (Integer) o1.get("count");
				Integer Count2 = (Integer) o2.get("count");
				return Count2.compareTo(Count1);

			}
		});
		if (list.size() > 5) {
			list = list.subList(0, 5);
		}
		return list;
	}
}
