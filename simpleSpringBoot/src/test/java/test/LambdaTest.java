package test;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import org.junit.Test;

import junit.framework.TestCase;

public class LambdaTest extends TestCase{
	
	@Test
	public void test1(){
		/*new Thread(
				() -> System.out.println("Hello from thread")
		).start();*/
		List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7);
		//list.forEach((n) -> System.out.println(n)); 
		//list.forEach(System.out::println);
		list.stream().map((a)->a*a).forEach(System.out::println);
		int sum = list.stream().map((a)->a*a).reduce((a,y)-> a+y).get();
		System.out.println(sum);
	}
	
	@Test
	public void test2(){
		Comparator<String> comp1 = (first, second) -> Integer.compare(first.length(), second.length());
		Thread r2 = new Thread(
				() -> System.out.println("Hello from thread")
		);
		r2.start();
	}
}
