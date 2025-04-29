/**
 * 服务层包
 *
 * <p>职责：
 * <ul>
 *   <li>实现业务逻辑</li>
 *   <li>事务管理</li>
 *   <li>调用数据访问层</li>
 *   <li>数据转换和组装</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>类名以Service结尾</li>
 *   <li>接口和实现分离，实现类以Impl结尾</li>
 *   <li>使用@Service注解标注实现类</li>
 *   <li>使用@Transactional注解管理事务</li>
 *   <li>避免在服务层直接操作数据库</li>
 * </ul>
 */
package com.example.demo.service;
