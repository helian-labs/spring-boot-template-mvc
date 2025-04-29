/**
 * 缓存配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置缓存管理器（如Caffeine, Redis等）</li>
 *   <li>定义缓存策略（如过期时间、大小限制）</li>
 *   <li>启用或禁用缓存</li>
 *   <li>配置缓存注解（如@EnableCaching, @Cacheable）</li>
 *   <li>提供缓存监控和统计配置</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>缓存配置类应使用@Configuration注解</li>
 *   <li>明确定义缓存名称和键生成策略</li>
 *   <li>根据业务需求选择合适的缓存实现</li>
 *   <li>考虑缓存穿透、击穿、雪崩等问题并配置相应策略</li>
 *   <li>提供必要的注释说明配置项</li>
 * </ul>
 */
package com.example.demo.config.cache;
