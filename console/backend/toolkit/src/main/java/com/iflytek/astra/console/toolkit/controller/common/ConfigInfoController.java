package com.iflytek.astra.console.toolkit.controller.common;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.iflytek.astra.console.commons.response.ApiResult;
import com.iflytek.astra.console.toolkit.entity.table.ConfigInfo;
import com.iflytek.astra.console.toolkit.service.common.ConfigInfoService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * <p>
 * ConfigInfo table front-end controller
 * </p>
 *
 * Provides RESTful APIs for configuration management.
 *
 * @author xy
 * @since 2022-05-05
 */
@RestController
@RequestMapping("/config-info")
@Tag(name = "Config management interface")
public class ConfigInfoController {

    @Resource
    private ConfigInfoService configInfoService;

    /**
     * Get a list of valid configuration entries by category.
     *
     * @param category configuration category
     * @return {@link ApiResult} containing the list of {@link ConfigInfo}
     */
    @GetMapping("/get-list-by-category")
    public ApiResult<List<ConfigInfo>> getListByCategory(@RequestParam("category") String category) {
        // In the professional edition, only CBG is currently used; the slicing strategy also uses CBG.
        /*
         * if (category.equals("DEFAULT_SLICE_RULES") || category.equals("CUSTOM_SLICE_RULES")) {
         *     category = category + "_CBG";
         * }
         */
        return ApiResult.success(configInfoService.list(
                Wrappers.lambdaQuery(ConfigInfo.class)
                        .eq(ConfigInfo::getCategory, category)
                        .eq(ConfigInfo::getIsValid, 1)));
    }

    /**
     * Get a valid configuration entry by category and code.
     *
     * @param category configuration category
     * @param code     configuration code
     * @return {@link ApiResult} containing the matched {@link ConfigInfo}, or null if not found
     */
    @GetMapping("/get-by-category-and-code")
    public ApiResult<ConfigInfo> getByCategoryAndCode(@RequestParam("category") String category,
                                                      @RequestParam("code") String code) {
        return ApiResult.success(configInfoService.getBaseMapper().selectOne(
                Wrappers.lambdaQuery(ConfigInfo.class)
                        .eq(ConfigInfo::getCategory, category)
                        .eq(ConfigInfo::getCode, code)
                        .eq(ConfigInfo::getIsValid, 1)
                        .last("limit 1")));
    }

    /**
     * Get all valid configuration entries matching the given category and code.
     *
     * @param category configuration category
     * @param code     configuration code
     * @return {@link ApiResult} containing the list of {@link ConfigInfo}
     */
    @GetMapping("/list-by-category-and-code")
    public ApiResult<List<ConfigInfo>> listByCategoryAndCode(@RequestParam("category") String category,
                                                             @RequestParam("code") String code) {
        return ApiResult.success(configInfoService.list(
                Wrappers.lambdaQuery(ConfigInfo.class)
                        .eq(ConfigInfo::getCategory, category)
                        .eq(ConfigInfo::getCode, code)
                        .eq(ConfigInfo::getIsValid, 1)));
    }

    /**
     * Get tags by a given flag.
     *
     * @param flag tag flag identifier
     * @return {@link ApiResult} containing the list of {@link ConfigInfo}
     */
    @GetMapping("/tags")
    public ApiResult<List<ConfigInfo>> getTags(@RequestParam(value = "flag") String flag) {
        return ApiResult.success(configInfoService.getTags(flag));
    }

    /**
     * Get workflow categories.
     * <p>Query category "WORKFLOW_CATEGORY" and return its values split by comma.</p>
     *
     * @return {@link ApiResult} containing the list of workflow category names
     */
    @GetMapping("/workflow/categories")
    public ApiResult<List<String>> getTags() {
        ConfigInfo config = configInfoService.getOne(new LambdaQueryWrapper<ConfigInfo>()
                .eq(ConfigInfo::getCategory, "WORKFLOW_CATEGORY")
                .eq(ConfigInfo::getIsValid, 1));
        return ApiResult.success(Arrays.asList(config.getValue().split(",")));
    }
}