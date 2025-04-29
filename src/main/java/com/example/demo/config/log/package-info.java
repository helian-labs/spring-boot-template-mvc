/**
 * 日志配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置日志级别</li>
 *   <li>配置日志格式</li>
 *   <li>配置日志输出目标</li>
 *   <li>配置日志轮转策略</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以LogConfig结尾</li>
 *   <li>使用@Configuration注解标注</li>
 *   <li>日志配置应该考虑性能影响</li>
 *   <li>日志格式应该包含时间、级别、类名、方法名</li>
 *   <li>日志轮转应该考虑存储空间</li>
 * </ul>
 */
package com.example.demo.config.log;
