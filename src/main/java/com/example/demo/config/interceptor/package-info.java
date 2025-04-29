/**
 * 拦截器配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置请求拦截器</li>
 *   <li>配置响应拦截器</li>
 *   <li>配置权限拦截器</li>
 *   <li>配置日志拦截器</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>拦截器类以Interceptor结尾</li>
 *   <li>实现HandlerInterceptor接口</li>
 *   <li>拦截器应该是无状态的</li>
 *   <li>拦截器应该考虑性能影响</li>
 *   <li>拦截器应该正确处理异常</li>
 * </ul>
 */
package com.example.demo.config.interceptor;
