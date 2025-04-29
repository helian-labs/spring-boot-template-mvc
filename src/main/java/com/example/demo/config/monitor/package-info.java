/**
 * 监控配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置系统监控组件</li>
 *   <li>配置性能监控</li>
 *   <li>配置健康检查</li>
 *   <li>配置资源监控</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以MonitorConfig结尾</li>
 *   <li>使用@Configuration注解标注</li>
 *   <li>监控配置应该是无状态的</li>
 *   <li>监控指标应该有明确的命名</li>
 *   <li>监控配置应该考虑性能影响</li>
 * </ul>
 */
package com.example.demo.config.monitor;
