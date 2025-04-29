/**
 * 过滤器配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置请求过滤器</li>
 *   <li>配置响应过滤器</li>
 *   <li>配置跨域过滤器</li>
 *   <li>配置安全过滤器</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>过滤器类以Filter结尾</li>
 *   <li>实现Filter接口或继承OncePerRequestFilter</li>
 *   <li>过滤器应该是无状态的</li>
 *   <li>过滤器应该考虑性能影响</li>
 *   <li>过滤器应该正确处理异常</li>
 * </ul>
 */
package com.example.demo.config.filter;
