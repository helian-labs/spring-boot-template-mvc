/**
 * WebSocket配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置WebSocket端点</li>
 *   <li>配置消息处理器</li>
 *   <li>配置会话管理</li>
 *   <li>配置心跳检测</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>配置类以WebSocketConfig结尾</li>
 *   <li>使用@Configuration和@EnableWebSocket注解标注</li>
 *   <li>WebSocket处理器应该实现WebSocketHandler接口</li>
 *   <li>应该考虑连接超时和重连机制</li>
 *   <li>应该考虑消息的序列化和反序列化</li>
 * </ul>
 */
package com.example.demo.config.websocket;
