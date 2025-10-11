package com.iflytek.astron.console.hub.service.space.impl;

import com.iflytek.astron.console.commons.constant.ResponseEnum;
import com.iflytek.astron.console.commons.data.UserInfoDataService;
import com.iflytek.astron.console.commons.entity.space.ApplyRecord;
import com.iflytek.astron.console.commons.entity.space.EnterpriseUser;
import com.iflytek.astron.console.commons.entity.space.SpaceUser;
import com.iflytek.astron.console.commons.entity.user.UserInfo;
import com.iflytek.astron.console.commons.enums.space.EnterpriseRoleEnum;
import com.iflytek.astron.console.commons.enums.space.SpaceRoleEnum;
import com.iflytek.astron.console.commons.exception.BusinessException;
import com.iflytek.astron.console.commons.response.ApiResult;
import com.iflytek.astron.console.commons.service.space.ApplyRecordService;
import com.iflytek.astron.console.commons.service.space.EnterpriseUserService;
import com.iflytek.astron.console.commons.service.space.SpaceUserService;
import com.iflytek.astron.console.commons.util.RequestContextUtil;
import com.iflytek.astron.console.commons.util.space.EnterpriseInfoUtil;
import com.iflytek.astron.console.commons.util.space.SpaceInfoUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * ApplyRecordBizServiceImpl 单元测试类
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("申请记录业务服务测试")
class ApplyRecordBizServiceImplTest {

    @Mock
    private SpaceUserService spaceUserService;

    @Mock
    private UserInfoDataService userInfoDataService;

    @Mock
    private EnterpriseUserService enterpriseUserService;

    @Mock
    private ApplyRecordService applyRecordService;

    @InjectMocks
    private ApplyRecordBizServiceImpl applyRecordBizService;

    private static final String TEST_UID = "test_uid_123";
    private static final Long TEST_SPACE_ID = 1L;
    private static final Long TEST_ENTERPRISE_ID = 100L;
    private static final Long TEST_APPLY_ID = 200L;
    private static final String TEST_NICKNAME = "测试用户";

    private UserInfo testUserInfo;
    private EnterpriseUser testEnterpriseUser;
    private ApplyRecord testApplyRecord;

    @BeforeEach
    void setUp() {
        // 初始化测试数据
        testUserInfo = new UserInfo();
        testUserInfo.setUid(TEST_UID);
        testUserInfo.setNickname(TEST_NICKNAME);

        testEnterpriseUser = EnterpriseUser.builder()
                .id(1L)
                .enterpriseId(TEST_ENTERPRISE_ID)
                .uid(TEST_UID)
                .nickname(TEST_NICKNAME)
                .role(EnterpriseRoleEnum.STAFF.getCode())
                .createTime(LocalDateTime.now())
                .build();

        testApplyRecord = new ApplyRecord();
        testApplyRecord.setId(TEST_APPLY_ID);
        testApplyRecord.setEnterpriseId(TEST_ENTERPRISE_ID);
        testApplyRecord.setSpaceId(TEST_SPACE_ID);
        testApplyRecord.setApplyUid(TEST_UID);
        testApplyRecord.setApplyNickname(TEST_NICKNAME);
        testApplyRecord.setApplyTime(LocalDateTime.now());
        testApplyRecord.setStatus(ApplyRecord.Status.APPLYING.getCode());
    }

    @Test
    @DisplayName("申请加入企业空间 - 成功申请（普通用户）")
    void testJoinEnterpriseSpace_Success_NormalUser() {
        // 准备测试数据
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(TEST_ENTERPRISE_ID);

            // Mock服务方法
            when(applyRecordService.getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID)).thenReturn(null);
            when(spaceUserService.getSpaceUserByUid(TEST_SPACE_ID, TEST_UID)).thenReturn(null);
            when(enterpriseUserService.getEnterpriseUserByUid(TEST_ENTERPRISE_ID, TEST_UID))
                    .thenReturn(testEnterpriseUser);
            when(userInfoDataService.findByUid(TEST_UID)).thenReturn(Optional.of(testUserInfo));
            when(applyRecordService.save(any(ApplyRecord.class))).thenReturn(true);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertEquals(ResponseEnum.SUCCESS.getCode(), result.code());
            assertNull(result.data());

            // 验证方法调用
            verify(applyRecordService).getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID);
            verify(spaceUserService).getSpaceUserByUid(TEST_SPACE_ID, TEST_UID);
            verify(enterpriseUserService).getEnterpriseUserByUid(TEST_ENTERPRISE_ID, TEST_UID);
            verify(userInfoDataService).findByUid(TEST_UID);
            verify(applyRecordService).save(any(ApplyRecord.class));
        }
    }

    @Test
    @DisplayName("申请加入企业空间 - 成功加入（超级管理员）")
    void testJoinEnterpriseSpace_Success_SuperAdmin() {
        // 准备测试数据 - 超级管理员
        testEnterpriseUser.setRole(EnterpriseRoleEnum.OFFICER.getCode());

        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(TEST_ENTERPRISE_ID);

            // Mock服务方法
            when(applyRecordService.getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID)).thenReturn(null);
            when(spaceUserService.getSpaceUserByUid(TEST_SPACE_ID, TEST_UID)).thenReturn(null);
            when(enterpriseUserService.getEnterpriseUserByUid(TEST_ENTERPRISE_ID, TEST_UID))
                    .thenReturn(testEnterpriseUser);
            when(spaceUserService.addSpaceUser(TEST_SPACE_ID, TEST_UID, SpaceRoleEnum.ADMIN))
                    .thenReturn(true);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertEquals(ResponseEnum.SUCCESS.getCode(), result.code());
            assertNull(result.data());

            // 验证方法调用
            verify(spaceUserService).addSpaceUser(TEST_SPACE_ID, TEST_UID, SpaceRoleEnum.ADMIN);
            verify(applyRecordService, never()).save(any(ApplyRecord.class));
        }
    }

    @Test
    @DisplayName("申请加入企业空间 - 失败：未加入企业")
    void testJoinEnterpriseSpace_Fail_NotInEnterprise() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(null);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_PLEASE_JOIN_ENTERPRISE_FIRST.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("申请加入企业空间 - 失败：重复申请")
    void testJoinEnterpriseSpace_Fail_DuplicateApplication() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(TEST_ENTERPRISE_ID);

            // Mock服务方法 - 已存在申请记录
            when(applyRecordService.getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID))
                    .thenReturn(testApplyRecord);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_DUPLICATE_NOT_ALLOWED.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("申请加入企业空间 - 失败：用户已在空间中")
    void testJoinEnterpriseSpace_Fail_UserAlreadyInSpace() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(TEST_ENTERPRISE_ID);

            // Mock服务方法
            when(applyRecordService.getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID)).thenReturn(null);
            SpaceUser existingSpaceUser = new SpaceUser();
            existingSpaceUser.setId(1L);
            when(spaceUserService.getSpaceUserByUid(TEST_SPACE_ID, TEST_UID))
                    .thenReturn(existingSpaceUser); // 用户已在空间中

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_USER_ALREADY_IN_SPACE.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("申请加入企业空间 - 失败：超级管理员加入失败")
    void testJoinEnterpriseSpace_Fail_SuperAdminJoinFailed() {
        // 准备测试数据 - 超级管理员
        testEnterpriseUser.setRole(EnterpriseRoleEnum.OFFICER.getCode());

        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(TEST_ENTERPRISE_ID);

            // Mock服务方法
            when(applyRecordService.getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID)).thenReturn(null);
            when(spaceUserService.getSpaceUserByUid(TEST_SPACE_ID, TEST_UID)).thenReturn(null);
            when(enterpriseUserService.getEnterpriseUserByUid(TEST_ENTERPRISE_ID, TEST_UID))
                    .thenReturn(testEnterpriseUser);
            when(spaceUserService.addSpaceUser(TEST_SPACE_ID, TEST_UID, SpaceRoleEnum.ADMIN))
                    .thenReturn(false); // 加入失败

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_JOIN_FAILED.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("申请加入企业空间 - 失败：申请保存失败")
    void testJoinEnterpriseSpace_Fail_SaveApplicationFailed() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<EnterpriseInfoUtil> enterpriseInfoMock = mockStatic(EnterpriseInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn(TEST_UID);
            enterpriseInfoMock.when(EnterpriseInfoUtil::getEnterpriseId).thenReturn(TEST_ENTERPRISE_ID);

            // Mock服务方法
            when(applyRecordService.getByUidAndSpaceId(TEST_UID, TEST_SPACE_ID)).thenReturn(null);
            when(spaceUserService.getSpaceUserByUid(TEST_SPACE_ID, TEST_UID)).thenReturn(null);
            when(enterpriseUserService.getEnterpriseUserByUid(TEST_ENTERPRISE_ID, TEST_UID))
                    .thenReturn(testEnterpriseUser);
            when(userInfoDataService.findByUid(TEST_UID)).thenReturn(Optional.of(testUserInfo));
            when(applyRecordService.save(any(ApplyRecord.class))).thenReturn(false); // 保存失败

            // 执行测试
            ApiResult<String> result = applyRecordBizService.joinEnterpriseSpace(TEST_SPACE_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_FAILED.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("同意加入企业空间 - 成功")
    void testAgreeEnterpriseSpace_Success() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn("admin_uid");
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);
            when(applyRecordService.updateById(any(ApplyRecord.class))).thenReturn(true);
            when(spaceUserService.addSpaceUser(TEST_SPACE_ID, TEST_UID, SpaceRoleEnum.MEMBER))
                    .thenReturn(true);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.agreeEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertEquals(ResponseEnum.SUCCESS.getCode(), result.code());
            assertNull(result.data());

            // 验证申请记录状态更新
            verify(applyRecordService).updateById(argThat(record -> record.getStatus().equals(ApplyRecord.Status.APPROVED.getCode()) &&
                    record.getAuditUid().equals("admin_uid") &&
                    record.getAuditTime() != null));

            // 验证添加空间用户
            verify(spaceUserService).addSpaceUser(TEST_SPACE_ID, TEST_UID, SpaceRoleEnum.MEMBER);
        }
    }

    @Test
    @DisplayName("同意加入企业空间 - 失败：申请记录不存在")
    void testAgreeEnterpriseSpace_Fail_RecordNotFound() {
        // Mock服务方法
        when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(null);

        // 执行测试
        ApiResult<String> result = applyRecordBizService.agreeEnterpriseSpace(TEST_APPLY_ID);

        // 验证结果
        assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
        assertEquals(ResponseEnum.SPACE_APPLICATION_RECORD_NOT_FOUND.getCode(), result.code());
    }

    @Test
    @DisplayName("同意加入企业空间 - 失败：空间不一致")
    void testAgreeEnterpriseSpace_Fail_SpaceInconsistent() {
        try (MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法 - 返回不同的空间ID
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(999L);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.agreeEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_CURRENT_SPACE_INCONSISTENT.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("同意加入企业空间 - 失败：申请状态不正确")
    void testAgreeEnterpriseSpace_Fail_StatusIncorrect() {
        try (MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // 修改申请记录状态为已审批
            testApplyRecord.setStatus(ApplyRecord.Status.APPROVED.getCode());

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.agreeEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_STATUS_INCORRECT.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("同意加入企业空间 - 失败：更新申请记录失败")
    void testAgreeEnterpriseSpace_Fail_UpdateRecordFailed() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn("admin_uid");
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);
            when(applyRecordService.updateById(any(ApplyRecord.class))).thenReturn(false); // 更新失败

            // 执行测试
            ApiResult<String> result = applyRecordBizService.agreeEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_APPROVAL_FAILED.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("同意加入企业空间 - 失败：添加空间用户失败")
    void testAgreeEnterpriseSpace_Fail_AddSpaceUserFailed() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn("admin_uid");
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);
            when(applyRecordService.updateById(any(ApplyRecord.class))).thenReturn(true);
            when(spaceUserService.addSpaceUser(TEST_SPACE_ID, TEST_UID, SpaceRoleEnum.MEMBER))
                    .thenReturn(false); // 添加用户失败

            // 执行测试并验证异常
            BusinessException exception = assertThrows(BusinessException.class, () -> {
                applyRecordBizService.agreeEnterpriseSpace(TEST_APPLY_ID);
            });

            assertEquals(ResponseEnum.SPACE_USER_ADD_FAILED.getCode(), exception.getCode());
        }
    }

    @Test
    @DisplayName("拒绝加入企业空间 - 成功")
    void testRefuseEnterpriseSpace_Success() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn("admin_uid");
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);
            when(applyRecordService.updateById(any(ApplyRecord.class))).thenReturn(true);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.refuseEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertEquals(ResponseEnum.SUCCESS.getCode(), result.code());
            assertNull(result.data());

            // 验证申请记录状态更新
            verify(applyRecordService).updateById(argThat(record -> record.getStatus().equals(ApplyRecord.Status.REJECTED.getCode()) &&
                    record.getAuditUid().equals("admin_uid") &&
                    record.getAuditTime() != null));
        }
    }

    @Test
    @DisplayName("拒绝加入企业空间 - 失败：申请记录不存在")
    void testRefuseEnterpriseSpace_Fail_RecordNotFound() {
        // Mock服务方法
        when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(null);

        // 执行测试
        ApiResult<String> result = applyRecordBizService.refuseEnterpriseSpace(TEST_APPLY_ID);

        // 验证结果
        assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
        assertEquals(ResponseEnum.SPACE_APPLICATION_RECORD_NOT_FOUND.getCode(), result.code());
    }

    @Test
    @DisplayName("拒绝加入企业空间 - 失败：空间不一致")
    void testRefuseEnterpriseSpace_Fail_SpaceInconsistent() {
        try (MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法 - 返回不同的空间ID
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(999L);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.refuseEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_CURRENT_SPACE_INCONSISTENT.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("拒绝加入企业空间 - 失败：申请状态不正确")
    void testRefuseEnterpriseSpace_Fail_StatusIncorrect() {
        try (MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // 修改申请记录状态为已拒绝
            testApplyRecord.setStatus(ApplyRecord.Status.REJECTED.getCode());

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);

            // 执行测试
            ApiResult<String> result = applyRecordBizService.refuseEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_STATUS_INCORRECT.getCode(), result.code());
        }
    }

    @Test
    @DisplayName("拒绝加入企业空间 - 失败：更新申请记录失败")
    void testRefuseEnterpriseSpace_Fail_UpdateRecordFailed() {
        try (MockedStatic<RequestContextUtil> requestContextMock = mockStatic(RequestContextUtil.class);
                MockedStatic<SpaceInfoUtil> spaceInfoMock = mockStatic(SpaceInfoUtil.class)) {

            // Mock静态方法
            requestContextMock.when(RequestContextUtil::getUID).thenReturn("admin_uid");
            spaceInfoMock.when(SpaceInfoUtil::getSpaceId).thenReturn(TEST_SPACE_ID);

            // Mock服务方法
            when(applyRecordService.getById(TEST_APPLY_ID)).thenReturn(testApplyRecord);
            when(applyRecordService.updateById(any(ApplyRecord.class))).thenReturn(false); // 更新失败

            // 执行测试
            ApiResult<String> result = applyRecordBizService.refuseEnterpriseSpace(TEST_APPLY_ID);

            // 验证结果
            assertFalse(result.code() == ResponseEnum.SUCCESS.getCode());
            assertEquals(ResponseEnum.SPACE_APPLICATION_APPROVAL_FAILED.getCode(), result.code());
        }
    }
}
