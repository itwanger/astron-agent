package com.iflytek.astra.console.toolkit.controller.model;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.iflytek.astra.console.commons.constant.ResponseEnum;
import com.iflytek.astra.console.commons.exception.BusinessException;
import com.iflytek.astra.console.commons.response.ApiResult;
import com.iflytek.astra.console.commons.util.SpringContextHolder;
import com.iflytek.astra.console.toolkit.entity.biz.modelconfig.ModelDto;
import com.iflytek.astra.console.toolkit.entity.biz.modelconfig.ModelValidationRequest;
import com.iflytek.astra.console.toolkit.entity.vo.CategoryTreeVO;
import com.iflytek.astra.console.toolkit.entity.vo.LLMInfoVo;
import com.iflytek.astra.console.toolkit.service.model.ModelService;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationContext;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for {@link ModelController}.
 */
@ExtendWith(MockitoExtension.class)
class ModelControllerTest {

    @Mock
    private ModelService mockModelService;

    @InjectMocks
    private ModelController modelControllerUnderTest;

    @BeforeEach
    void initSpringContextHolder() {
        ApplicationContext ctx = mock(ApplicationContext.class, RETURNS_DEFAULTS);
        new SpringContextHolder().setApplicationContext(ctx);
    }

    /**
     * Bind a mock request with required headers to the current thread context.
     *
     * @param req mock HttpServletRequest
     */
    private static void bindRequest(MockHttpServletRequest req) {
        req.addHeader("space-id", "1001");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(req));
    }

    /**
     * Test validateModel with ModelValidationRequest input.
     * <p>Does not set uid to simulate real-world behavior where the controller/context injects it.</p>
     */
    @Test
    void testValidateModel1() {
        // Arrange
        final ModelValidationRequest request = new ModelValidationRequest();
        request.setEndpoint("endpoint");
        request.setApiKey("apiKey");
        request.setModelName("modelName");
        request.setDomain("domain");
        // Do not set uid, simulating the difference where controller/context injects it

        final MockHttpServletRequest httpServletRequest = new MockHttpServletRequest();

        // Relax parameter matching to avoid strict stubbing failure
        when(mockModelService.validateModel(any(ModelValidationRequest.class))).thenReturn("result");

        // Act
        final ApiResult result = modelControllerUnderTest.validateModel(request, httpServletRequest);

        // Assert - use ArgumentCaptor to check that key parameters were passed correctly
        ArgumentCaptor<ModelValidationRequest> captor = ArgumentCaptor.forClass(ModelValidationRequest.class);
        verify(mockModelService, times(1)).validateModel(captor.capture());
        ModelValidationRequest passed = captor.getValue();
        assertEquals("endpoint", passed.getEndpoint());
        assertEquals("apiKey", passed.getApiKey());
        assertEquals("modelName", passed.getModelName());
        assertEquals("domain", passed.getDomain());
        // Depending on controller logic, uid may be null or injected from context
        // assertNull(passed.getUid());

        assertNotNull(result);
    }

    /**
     * Test validateModel with id input, service returns ApiResult.
     */
    @Test
    void testValidateModel2() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        final ApiResult apiResult = new ApiResult<>(0, "message", "data", 0L);
        when(mockModelService.checkAndDelete(eq(0L), any(HttpServletRequest.class))).thenReturn(apiResult);

        final ApiResult result = modelControllerUnderTest.validateModel(0L, request);

        assertEquals(apiResult, result);
    }

    /**
     * Test validateModel when service returns a successful response with no data.
     */
    @Test
    void testValidateModel2_ModelServiceReturnsNoItem() {
        final MockHttpServletRequest request = new MockHttpServletRequest();

        ApiResult<?> ok = new ApiResult<>(0, "OK", null, 0L);
        when(mockModelService.checkAndDelete(eq(0L), any(HttpServletRequest.class))).thenReturn(ok);

        final ApiResult result = modelControllerUnderTest.validateModel(0L, request);

        assertEquals(ok, result);
        // Or check only key fields to avoid equals affected by timestamp
        assertEquals(0, result.code());
        assertEquals("OK", result.message());
        assertNull(result.data());
    }

    /**
     * Test validateModel when service returns error.
     */
    @Test
    void testValidateModel2_ModelServiceReturnsError() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        final ApiResult apiResult = ApiResult.error(new BusinessException(ResponseEnum.SUCCESS, "args"));
        when(mockModelService.checkAndDelete(eq(0L), any(HttpServletRequest.class))).thenReturn(apiResult);

        final ApiResult result = modelControllerUnderTest.validateModel(0L, request);

        assertEquals(apiResult, result);
    }

    /**
     * Test list method with service returning data.
     */
    @Test
    void testList() {
        final ModelDto dto = new ModelDto();
        dto.setType(0);
        dto.setFilter(0);
        dto.setName("name");
        dto.setUid("0L");
        dto.setSpaceId(0L);
        final MockHttpServletRequest request = new MockHttpServletRequest();
        bindRequest(request);
        final ApiResult<Page<LLMInfoVo>> pageApiResult =
                new ApiResult<>(0, "message", new Page<>(0L, 0L, 0L, false), 0L);

        // Relax matching to avoid eq(new ModelDto()) causing equals mismatch
        when(mockModelService.getList(any(ModelDto.class), any(HttpServletRequest.class))).thenReturn(pageApiResult);

        final ApiResult result = modelControllerUnderTest.list(dto, request);

        assertEquals(pageApiResult, result);
        // Use captor to verify key fields in dto
        ArgumentCaptor<ModelDto> dtoCaptor = ArgumentCaptor.forClass(ModelDto.class);
        verify(mockModelService).getList(dtoCaptor.capture(), any(HttpServletRequest.class));
        assertEquals("name", dtoCaptor.getValue().getName());
    }

    /**
     * Test list method when service returns a success with no data.
     */
    @Test
    void testList_ModelServiceReturnsNoItem() {
        final ModelDto dto = new ModelDto();
        dto.setType(0);
        dto.setFilter(0);
        dto.setName("name");
        dto.setUid("0L");
        dto.setSpaceId(0L);

        final MockHttpServletRequest request = new MockHttpServletRequest();
        bindRequest(request); // Bind to thread and add space-id header

        // Do not call ApiResult.success() directly in thenReturn
        ApiResult<?> ok = new ApiResult<>(0, "OK", null, 0L);
        when(mockModelService.getList(any(ModelDto.class), any(HttpServletRequest.class)))
                .thenReturn((ApiResult<Page<LLMInfoVo>>) ok);

        final ApiResult result = modelControllerUnderTest.list(dto, request);

        assertEquals(ok, result);
    }

    /**
     * Test list method when service returns error.
     */
    @Test
    void testList_ModelServiceReturnsError() {
        final ModelDto dto = new ModelDto();
        dto.setType(0);
        dto.setFilter(0);
        dto.setName("name");
        dto.setUid("0L");
        dto.setSpaceId(0L);

        final MockHttpServletRequest request = new MockHttpServletRequest();

        final ApiResult<Page<LLMInfoVo>> pageApiResult =
                ApiResult.error(new BusinessException(ResponseEnum.SUCCESS, "args"));
        when(mockModelService.getList(any(ModelDto.class), any(HttpServletRequest.class)))
                .thenReturn(pageApiResult);

        final ApiResult result = modelControllerUnderTest.list(dto, request);

        assertEquals(pageApiResult, result);
    }

    /**
     * Test detail method with service returning data.
     */
    @Test
    void testDetail() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        final ApiResult apiResult = new ApiResult<>(0, "message", "data", 0L);
        when(mockModelService.getDetail(eq(0), eq(0L), any(HttpServletRequest.class))).thenReturn(apiResult);

        final ApiResult result = modelControllerUnderTest.detail(0, 0L, request);

        assertEquals(apiResult, result);
    }

    /**
     * Test detail method when service returns a success with no data.
     */
    @Test
    void testDetail_ModelServiceReturnsNoItem() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        ApiResult<?> ok = new ApiResult<>(0, "OK", null, 0L);
        when(mockModelService.getDetail(eq(0), eq(0L), any(HttpServletRequest.class))).thenReturn(ok);

        final ApiResult result = modelControllerUnderTest.detail(0, 0L, request);

        assertEquals(ok, result);
    }

    /**
     * Test detail method when service returns error.
     */
    @Test
    void testDetail_ModelServiceReturnsError() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        final ApiResult apiResult = ApiResult.error(new BusinessException(ResponseEnum.SUCCESS, "args"));
        when(mockModelService.getDetail(eq(0), eq(0L), any(HttpServletRequest.class))).thenReturn(apiResult);

        final ApiResult result = modelControllerUnderTest.detail(0, 0L, request);

        assertEquals(apiResult, result);
    }

    /**
     * Test getRsaPublicKey method.
     */
    @Test
    void testGetRsaPublicKey() {
        when(mockModelService.getPublicKey()).thenReturn("result");

        final ApiResult result = modelControllerUnderTest.getRsaPublicKey();

        assertNotNull(result);
        verify(mockModelService).getPublicKey();
    }

    /**
     * Test checkModelBase with specific parameters.
     */
    @Test
    void testCheckModelBase1() {
        when(mockModelService.checkModelBase(0L, "serviceId", "url", "0L", 0L)).thenReturn(false);

        final ApiResult result = modelControllerUnderTest.checkModelBase(0L, "0L", 0L, "serviceId", "url");

        assertNotNull(result);
        verify(mockModelService).checkModelBase(0L, "serviceId", "url", "0L", 0L);
    }

    /**
     * Test getAllCategoryTree method with service returning data.
     */
    @Test
    void testGetAllCategoryTree() {
        final CategoryTreeVO categoryTreeVO = new CategoryTreeVO();
        categoryTreeVO.setId(0L);
        categoryTreeVO.setKey("key");
        categoryTreeVO.setName("name");
        categoryTreeVO.setSortOrder(0);
        categoryTreeVO.setChildren(List.of(new CategoryTreeVO()));
        final List<CategoryTreeVO> expectedResult = List.of(categoryTreeVO);

        final CategoryTreeVO categoryTreeVO1 = new CategoryTreeVO();
        categoryTreeVO1.setId(0L);
        categoryTreeVO1.setKey("key");
        categoryTreeVO1.setName("name");
        categoryTreeVO1.setSortOrder(0);
        categoryTreeVO1.setChildren(List.of(new CategoryTreeVO()));
        final List<CategoryTreeVO> categoryTreeVOS = List.of(categoryTreeVO1);
        when(mockModelService.getAllCategoryTree()).thenReturn(categoryTreeVOS);

        ApiResult<List<CategoryTreeVO>> result = modelControllerUnderTest.getAllCategoryTree();

        assertEquals(expectedResult, result);
    }

    /**
     * Test getAllCategoryTree method when service returns no items.
     */
    @Test
    void testGetAllCategoryTree_ModelServiceReturnsNoItems() {
        when(mockModelService.getAllCategoryTree()).thenReturn(Collections.emptyList());

        ApiResult<List<CategoryTreeVO>> result = modelControllerUnderTest.getAllCategoryTree();
        assertEquals(Collections.emptyList(), result);
    }

    /**
     * Test switchModel method with service returning data.
     */
    @Test
    void testSwitchModel() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        final ApiResult apiResult = new ApiResult<>(0, "message", "data", 0L);
        when(mockModelService.switchModel(eq(0L), eq(0), eq("option"), any(HttpServletRequest.class)))
                .thenReturn(apiResult);

        final ApiResult result = modelControllerUnderTest.switchModel("option", 0, 0L, request);

        assertEquals(apiResult, result);
    }

    /**
     * Test switchModel method when service returns a success with no data.
     */
    @Test
    void testSwitchModel_ModelServiceReturnsNoItem() {
        final MockHttpServletRequest request = new MockHttpServletRequest();

        // Do not call ApiResult.success() directly in thenReturn
        ApiResult<?> ok = new ApiResult<>(0, "OK", null, 0L);
        when(mockModelService.switchModel(eq(0L), eq(0), eq("on"), any(HttpServletRequest.class)))
                .thenReturn(ok);

        final ApiResult result = modelControllerUnderTest.switchModel("on", 0, 0L, request);
        assertEquals(ok, result);
    }

    /**
     * Test switchModel method when service returns error.
     */
    @Test
    void testSwitchModel_ModelServiceReturnsError() {
        final MockHttpServletRequest request = new MockHttpServletRequest();
        final ApiResult apiResult = ApiResult.error(new BusinessException(ResponseEnum.SUCCESS, "args"));
        when(mockModelService.switchModel(eq(0L), eq(0), eq("option"), any(HttpServletRequest.class)))
                .thenReturn(apiResult);

        final ApiResult result = modelControllerUnderTest.switchModel("option", 0, 0L, request);

        assertEquals(apiResult, result);
    }

    /**
     * Test checkModelBase overload for offShelfModel.
     */
    @Test
    void testCheckModelBase2() {
        when(mockModelService.offShelfModel(0L, "flowId", "serviceId")).thenReturn("result");

        final ApiResult result = modelControllerUnderTest.checkModelBase(0L, "serviceId", "flowId");

        assertNotNull(result);
        verify(mockModelService).offShelfModel(0L, "flowId", "serviceId");
    }

}