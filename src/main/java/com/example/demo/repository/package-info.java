/**
 * 数据访问层包
 *
 * <p>职责：
 * <ul>
 *   <li>提供数据访问接口</li>
 *   <li>封装数据库操作</li>
 *   <li>实现数据持久化</li>
 *   <li>提供数据查询方法</li>
 * </ul>
 *
 * <p>规范：
 * <ul>
 *   <li>接口名以Repository结尾</li>
 *   <li>继承JpaRepository或自定义Repository接口</li>
 *   <li>方法名要符合Spring Data命名规范</li>
 *   <li>使用@Repository注解标注接口</li>
 *   <li>避免在Repository中包含业务逻辑</li>
 * </ul>
 */
package com.example.demo.repository;
