package com.iflytek.astron.console.commons.event;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * 简单的事件测试，验证事件对象的创建和属性访问
 */
public class UserNicknameEventSimpleTest {

    @Test
    public void testUserNicknameUpdatedEventCreation() {
        // 准备测试数据
        String testUid = "test-uid-123";
        String oldNickname = "旧昵称";
        String newNickname = "新昵称";
        Object source = new Object();

        // 创建事件
        UserNicknameUpdatedEvent event = new UserNicknameUpdatedEvent(source, testUid, oldNickname, newNickname);

        // 验证事件属性
        assertNotNull(event);
        assertEquals(source, event.getSource());
        assertEquals(testUid, event.getUid());
        assertEquals(oldNickname, event.getOldNickname());
        assertEquals(newNickname, event.getNewNickname());
    }

    @Test
    public void testUserNicknameUpdatedEventWithNullValues() {
        // 测试null值
        String testUid = null;
        String oldNickname = null;
        String newNickname = "新昵称";
        Object source = new Object();

        // 创建事件
        UserNicknameUpdatedEvent event = new UserNicknameUpdatedEvent(source, testUid, oldNickname, newNickname);

        // 验证事件属性
        assertNotNull(event);
        assertEquals(source, event.getSource());
        assertEquals(testUid, event.getUid());
        assertEquals(oldNickname, event.getOldNickname());
        assertEquals(newNickname, event.getNewNickname());
    }

    @Test
    public void testUserNicknameUpdatedEventWithEmptyStrings() {
        // 测试空字符串
        String testUid = "";
        String oldNickname = "";
        String newNickname = "";
        Object source = new Object();

        // 创建事件
        UserNicknameUpdatedEvent event = new UserNicknameUpdatedEvent(source, testUid, oldNickname, newNickname);

        // 验证事件属性
        assertNotNull(event);
        assertEquals(source, event.getSource());
        assertEquals(testUid, event.getUid());
        assertEquals(oldNickname, event.getOldNickname());
        assertEquals(newNickname, event.getNewNickname());
    }
}
