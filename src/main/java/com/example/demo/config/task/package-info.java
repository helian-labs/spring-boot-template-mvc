/**
 * 定时任务配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置定时任务调度器</li>
 *   <li>配置任务执行器</li>
 *   <li>配置任务触发器</li>
 *   <li>配置任务监控</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以TaskConfig结尾</li>
 *   <li>使用@Configuration和@EnableScheduling注解标注</li>
 *   <li>任务方法应该使用@Scheduled注解标注</li>
 *   <li>应该考虑任务的并发执行</li>
 *   <li>应该考虑任务的异常处理</li>
 * </ul>
 */
package com.example.demo.config.task;
