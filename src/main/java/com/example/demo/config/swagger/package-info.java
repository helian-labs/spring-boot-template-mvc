/**
 * Swagger API文档配置包
 *
 * <p>职责：
 * <ul>
 *   <li>配置Swagger/OpenAPI的基本信息（标题、描述、版本等）</li>
 *   <li>启用或禁用Swagger UI</li>
 *   <li>配置API分组和扫描路径</li>
 *   <li>配置全局参数、响应消息等</li>
 *   <li>集成安全认证（如JWT）到Swagger文档</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>Swagger配置类应使用@Configuration注解</li>
 *   <li>API文档信息应准确、完整</li>
 *   <li>根据需要进行API分组管理</li>
 *   <li>考虑API版本控制的展示</li>
 *   <li>确保API安全性配置在文档中正确反映</li>
 *   <li>提供必要的注释说明配置项</li>
 * </ul>
 */
package com.example.demo.config.swagger;
