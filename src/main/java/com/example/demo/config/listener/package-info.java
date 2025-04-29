/**
 * 监听器配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置系统事件监听器</li>
 *   <li>配置应用生命周期监听器</li>
 *   <li>配置自定义事件监听器</li>
 *   <li>处理系统事件</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>监听器类以Listener结尾</li>
 *   <li>使用@Component注解标注</li>
 *   <li>实现相应的监听器接口</li>
 *   <li>监听器方法应该是轻量级的</li>
 *   <li>避免在监听器中执行耗时操作</li>
 * </ul>
 */
package com.example.demo.config.listener;
