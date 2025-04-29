/**
 * 安全配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置认证机制</li>
 *   <li>配置授权策略</li>
 *   <li>配置加密算法</li>
 *   <li>配置会话管理</li>
 *   <li>配置安全防护</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以SecurityConfig结尾</li>
 *   <li>使用@Configuration和@EnableWebSecurity注解标注</li>
 *   <li>应该实现CSRF防护</li>
 *   <li>应该实现XSS防护</li>
 *   <li>应该实现SQL注入防护</li>
 *   <li>应该使用安全的加密算法</li>
 *   <li>应该实现会话超时机制</li>
 * </ul>
 */
package com.example.demo.config.security;
