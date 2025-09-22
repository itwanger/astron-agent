package com.iflytek.astra.console.toolkit.controller.workflow;

import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.iflytek.astra.console.commons.response.ApiResult;
import com.iflytek.astra.console.toolkit.common.anno.ResponseResultBody;
import com.iflytek.astra.console.toolkit.entity.table.workflow.WorkflowVersion;
import com.iflytek.astra.console.toolkit.service.workflow.VersionService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * Controller for managing workflow versions.
 */
@RestController
@RequestMapping("/workflow/version")
@Slf4j
@ResponseResultBody
@Tag(name = "Workflow version management interface")
public class VersionController {

    @Resource
    VersionService versionService;

    /**
     * Query workflow versions with pagination.
     *
     * @param page   pagination parameters
     * @param flowId the workflow ID
     * @return paginated list of workflow versions
     */
    @GetMapping("/list")
    public Object list(Page<WorkflowVersion> page,
                       @RequestParam String flowId) {
        return versionService.listPage(page, flowId);
    }

    /**
     * Query workflow versions by botId with pagination.
     *
     * @param page  pagination parameters
     * @param botId the bot ID
     * @return paginated list of workflow versions by botId
     */
    @GetMapping("/list-botId")
    public Object list_botId(Page<WorkflowVersion> page,
                             @RequestParam String botId) {
        return versionService.list_botId_Page(page, botId);
    }

    /**
     * Create a workflow version.
     * <p>
     * Input parameters in {@link WorkflowVersion}:
     * <ul>
     *   <li>flowId - workflow ID</li>
     *   <li>botId - bot ID</li>
     *   <li>name - version name</li>
     *   <li>publishChannel - workflow publish channel, enum values:
     *       1: WeChat Official Account, 2: Xinghuo Desk, 3: API, 4: MCP</li>
     *   <li>publishResult - workflow publish result, enum values: success, failure, pending</li>
     *   <li>description - description of workflow version</li>
     * </ul>
     *
     * @param createDto workflow version creation object
     * @return result of workflow version creation
     */
    @PostMapping
    public ApiResult<JSONObject> create(@RequestBody WorkflowVersion createDto) {
        return versionService.create(createDto);
    }

    /**
     * Restore a workflow version.
     *
     * @param createDto workflow version object containing restore info
     * @return result of the restore operation
     */
    @PostMapping("/restore")
    public Object restore(@RequestBody WorkflowVersion createDto) {
        return versionService.restore(createDto);
    }

    /**
     * Update workflow version publish result.
     *
     * @param createDto workflow version object containing update info
     *                  (id, publishResult)
     * @return result of the update operation
     */
    @PostMapping("/update-channel-result")
    public Object update_channel_result(@RequestBody WorkflowVersion createDto) {
        return versionService.update_channel_result(createDto);
    }

    /**
     * Get workflow version name.
     *
     * @param createDto workflow version object
     * @return workflow version name
     */
    @PostMapping("/get-version-name")
    public Object getVersionName(@RequestBody WorkflowVersion createDto) {
        return versionService.getVersionName(createDto);
    }

    /**
     * Get the maximum version number for a bot.
     *
     * @param botId the bot ID
     * @return maximum version number
     */
    @GetMapping("/get-max-version")
    public Object getMaxVersion(@RequestParam String botId) {
        return versionService.getMaxVersion(botId);
    }

    /**
     * Get workflow system data for a version.
     *
     * @param createDto workflow version object
     * @return system data of the version
     */
    @PostMapping("/get-version-sys-data")
    public Object getVersionSysData(@RequestBody WorkflowVersion createDto) {
        return versionService.getVersionSysData(createDto);
    }

    /**
     * Check if workflow version has system data.
     *
     * @param createDto workflow version object
     * @return true if system data exists, false otherwise
     */
    @PostMapping("/have-version-sys-data")
    public Object haveVersionSysData(@RequestBody WorkflowVersion createDto) {
        return versionService.haveVersionSysData(createDto);
    }

    /**
     * Query publish result of a workflow version.
     *
     * @param flowId workflow ID
     * @param name   workflow version name
     * @return publish result of the workflow version
     */
    @GetMapping("/publish-result")
    public Object publishResult(@RequestParam String flowId,
                                @RequestParam String name) {
        return versionService.publishResult(flowId, name);
    }
}