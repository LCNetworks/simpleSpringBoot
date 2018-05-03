package simpleSpringBoot;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.junit.Test;

public class ActivityInitor {
	 @Test  
    public void createTableTest(){  
        //表不存在的话创建表  
        ProcessEngine processEngine = ProcessEngineConfiguration  
                .createProcessEngineConfigurationFromResource("activiti.cfg.xml")  
                .buildProcessEngine();  
        System.out.println("------processEngine:" + processEngine);  
        
    }  
}
