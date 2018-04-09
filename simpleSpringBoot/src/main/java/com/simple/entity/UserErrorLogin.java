package com.simple.entity;

import java.util.Date;

public class UserErrorLogin {
	
	Date date;
	int count;
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	
	public static void main(String[] args) {
		System.out.println(new Date().getTime());
	}
}
