package com.iflytek.astron.console.hub.dto.workflow;

import lombok.Data;

/**
 * 工作流发布响应DTO
 */
@Data
public class WorkflowReleaseResponseDto {

    /**
     * 工作流版本ID
     */
    private Long workflowVersionId;

    /**
     * 工作流版本名称
     */
    private String workflowVersionName;

    /**
     * 发布是否成功
     */
    private Boolean success;

    /**
     * 错误消息
     */
    private String errorMessage;
}
