/**
 * 异常处理包
 *
 * <p>职责：
 * <ul>
 *   <li>定义业务异常类</li>
 *   <li>提供全局异常处理</li>
 *   <li>统一异常响应格式</li>
 *   <li>处理系统异常</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>异常类以Exception结尾</li>
 *   <li>继承RuntimeException</li>
 *   <li>提供异常码和消息</li>
 *   <li>使用@ControllerAdvice处理全局异常</li>
 *   <li>统一异常响应格式</li>
 * </ul>
 */
package com.example.demo.exception;
