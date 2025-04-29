/**
 * 控制器层包
 *
 * <p>职责：
 * <ul>
 *   <li>处理HTTP请求和响应</li>
 *   <li>参数校验和转换</li>
 *   <li>调用服务层处理业务逻辑</li>
 *   <li>统一响应格式封装</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>类名以Controller结尾</li>
 *   <li>方法名要清晰表达业务含义</li>
 *   <li>使用@Valid注解进行参数校验</li>
 *   <li>统一使用ResponseEntity包装响应（或自定义响应对象）</li>
 *   <li>避免在控制器中编写业务逻辑</li>
 * </ul>
 */
package com.example.demo.controller;
