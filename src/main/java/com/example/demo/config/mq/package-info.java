/**
 * 消息队列配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置消息队列连接</li>
 *   <li>配置消息生产者</li>
 *   <li>配置消息消费者</li>
 *   <li>配置消息监听器</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以MqConfig结尾</li>
 *   <li>使用@Configuration注解标注</li>
 *   <li>消息监听器应该实现MessageListener接口</li>
 *   <li>应该考虑消息重试和死信队列</li>
 *   <li>应该考虑消息的序列化和反序列化</li>
 * </ul>
 */
package com.example.demo.config.mq;
