package com.simple.config;

import java.io.IOException;

import org.apache.commons.lang.StringUtils;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.simple.interceptor.LoginInterceptor;

@Configuration
public class WebConfig extends WebMvcConfigurerAdapter {

	@Bean
	public MappingJackson2HttpMessageConverter messageConverter() {
		MappingJackson2HttpMessageConverter messageConverter = new MappingJackson2HttpMessageConverter();

		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(new PropertyNamingStrategy() {
			private static final long serialVersionUID = -9040447651806412079L;

			// 序列化时调用
			@Override
			public String nameForGetterMethod(MapperConfig<?> config, AnnotatedMethod method, String defaultName) {
				Class<?> declaringClass = method.getDeclaringClass();
				String packageName = declaringClass.getPackage().getName();
				return super.nameForGetterMethod(config, method, defaultName);
			}

			// 反序列化时调用
			@Override
			public String nameForSetterMethod(MapperConfig<?> config, AnnotatedMethod method, String defaultName) {
				return super.nameForSetterMethod(config, method, StringUtils.uncapitalize(defaultName));
			}
		});
		// 不输出值为null的属性
		// mapper.setSerializationInclusion(Include.NON_NULL);
		
		mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
		
		// 将输出null的属性转成空字符串
		mapper.getSerializerProvider().setNullValueSerializer(new JsonSerializer<Object>(){
			@Override
			public void serialize(Object value, JsonGenerator jgen, SerializerProvider provider)
					throws IOException, JsonProcessingException {
				jgen.writeString("");
			}
		});
		messageConverter.setObjectMapper(mapper);

		return messageConverter;
	}
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		// registry.addInterceptor(new LoginInterceptor())
		// // 配置不拦截的路径
		// .excludePathPatterns("/user/login");
		// 注册拦截器
		registry.addInterceptor(new LoginInterceptor())
		// 配置拦截的路径
		.addPathPatterns("/**")
		// 配置不拦截的路径
		.excludePathPatterns("/user/login","/css/**","/html/**","/images/**","/js/**","/Lib/**","/plugin/**");
		
	}
	@Bean
	public EmbeddedServletContainerCustomizer containerCustomizer(){
	       return new EmbeddedServletContainerCustomizer() {
	           @Override
	           public void customize(ConfigurableEmbeddedServletContainer container) {
	                container.setSessionTimeout(3600);//单位为S
	          }
	    };
	}
}