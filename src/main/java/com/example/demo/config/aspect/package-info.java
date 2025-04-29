/**
 * 切面配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置AOP切面</li>
 *   <li>定义切点表达式</li>
 *   <li>配置通知类型</li>
 *   <li>配置切面优先级</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>切面类以Aspect结尾</li>
 *   <li>使用@Aspect注解标注</li>
 *   <li>切点表达式应该精确且高效</li>
 *   <li>切面逻辑应该简单且独立</li>
 *   <li>避免在切面中修改业务逻辑</li>
 * </ul>
 */
package com.example.demo.config.aspect;
