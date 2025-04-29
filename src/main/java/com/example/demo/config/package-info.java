/**
 * 配置类包
 *
 * <p>职责：
 * <ul>
 *   <li>提供系统配置类</li>
 *   <li>配置Spring组件</li>
 *   <li>配置第三方组件</li>
 *   <li>提供环境配置</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以Config结尾</li>
 *   <li>使用@Configuration注解标注</li>
 *   <li>配置类应该是无状态的</li>
 *   <li>配置方法使用@Bean注解</li>
 *   <li>避免在配置类中包含业务逻辑</li>
 * </ul>
 */
package com.example.demo.config;
