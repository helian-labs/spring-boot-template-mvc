package com.example.demo;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.env.Environment;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
@DisplayName("应用程序启动测试")
class DemoApplicationTests {

  @Autowired private Environment environment;

  @Test
  @DisplayName("测试上下文加载")
  void contextLoads() {
    assertThat(environment).isNotNull();
  }

  @Test
  @DisplayName("测试应用配置")
  void testApplicationProperties() {
    assertThat(environment.getProperty("spring.application.name")).isEqualTo("demo");
    assertThat(environment.getProperty("server.port")).isEqualTo("18080");
  }

  @Test
  @DisplayName("测试时区配置")
  void testTimeZoneConfig() {
    assertThat(environment.getProperty("spring.jackson.time-zone")).isEqualTo("Asia/Shanghai");
    assertThat(environment.getProperty("spring.jackson.date-format"))
        .isEqualTo("yyyy-MM-dd HH:mm:ss");
  }

  @Test
  @DisplayName("测试文件上传配置")
  void testFileUploadConfig() {
    assertThat(environment.getProperty("spring.servlet.multipart.max-file-size")).isEqualTo("10MB");
    assertThat(environment.getProperty("spring.servlet.multipart.max-request-size"))
        .isEqualTo("10MB");
  }
}
