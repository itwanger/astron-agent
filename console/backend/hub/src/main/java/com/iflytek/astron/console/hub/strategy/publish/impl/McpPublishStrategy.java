package com.iflytek.astron.console.hub.strategy.publish.impl;

import com.iflytek.astron.console.commons.enums.bot.ReleaseTypeEnum;
import com.iflytek.astron.console.commons.enums.PublishChannelEnum;
import com.iflytek.astron.console.commons.constant.ResponseEnum;
import com.iflytek.astron.console.commons.exception.BusinessException;
import com.iflytek.astron.console.commons.response.ApiResult;
import com.iflytek.astron.console.commons.entity.model.McpData;
import com.iflytek.astron.console.commons.entity.bot.UserLangChainInfo;
import com.iflytek.astron.console.commons.mapper.bot.ChatBotBaseMapper;
import com.iflytek.astron.console.commons.mapper.model.McpDataMapper;
import com.iflytek.astron.console.commons.mapper.UserLangChainInfoMapper;
import com.iflytek.astron.console.commons.service.data.UserLangChainDataService;
import com.iflytek.astron.console.hub.dto.publish.mcp.McpPublishRequestDto;
import com.iflytek.astron.console.hub.service.publish.BotPublishService;
import com.iflytek.astron.console.commons.util.MaasUtil;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Value;
import com.iflytek.astron.console.hub.strategy.publish.PublishStrategy;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import com.iflytek.astron.console.commons.util.MaasUtil;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.stream.Collectors;

/**
 * MCP publish strategy implementation Handles bot publishing to MCP server channel Based on
 * original MCPController#publishMCP logic
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class McpPublishStrategy implements PublishStrategy {

    private final ChatBotBaseMapper chatBotBaseMapper;
    private final UserLangChainInfoMapper userLangChainInfoMapper;
    private final UserLangChainDataService userLangChainDataService;
    private final McpDataMapper mcpDataMapper;
    private final BotPublishService botPublishService;

    @Value("${maas.workflowVersion}")
    private String baseUrl;

    private final OkHttpClient okHttpClient = new OkHttpClient.Builder()
            .connectTimeout(30, java.util.concurrent.TimeUnit.SECONDS)
            .readTimeout(60, java.util.concurrent.TimeUnit.SECONDS)
            .writeTimeout(60, java.util.concurrent.TimeUnit.SECONDS)
            .build();

    private static final MediaType JSON_MEDIA_TYPE = MediaType.get("application/json; charset=utf-8");
    private static final String GET_VERSION_NAME_URL = "/get-version-name";

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ApiResult<Object> publish(Integer botId, Object publishData, String currentUid, Long spaceId) {
        log.info("Publishing bot to MCP: botId={}, currentUid={}, spaceId={}", botId, currentUid, spaceId);

        try {
            // Parse MCP publish data
            McpPublishRequestDto mcpRequest = parsePublishData(publishData, botId);
            log.debug("MCP publish request: {}", JSON.toJSONString(mcpRequest));

            // 1. Permission check (corresponds to botPermissionUtil.checkBot)
            int hasPermission = chatBotBaseMapper.checkBotPermission(botId, currentUid, spaceId);
            if (hasPermission == 0) {
                throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
            }

            // 2. Check if workflow protocol exists (corresponds to userLangChainInfoDao.findListByBotId)
            UserLangChainInfo chainInfo = userLangChainInfoMapper.selectOne(
                    new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<UserLangChainInfo>()
                            .eq("bot_id", botId)
                            .orderByDesc("create_time")
                            .last("LIMIT 1"));
            if (chainInfo == null) {
                log.info("Bot workflow protocol not found: uid={}, botId={}", currentUid, botId);
                throw new BusinessException(ResponseEnum.BOT_CHAIN_SUBMIT_ERROR);
            }


            // 4. Get version name (corresponds to releaseManageClientService.getVersionNameByBotId)
            String versionName = getVersionName(botId, currentUid, spaceId);
            log.info("Got version name for MCP publish: botId={}, versionName={}", botId, versionName);

            // 5. Get cookies (corresponds to MassUtil.getRequestCookies(request))
            // Use RequestContextHolder to get current request context
            String cookie = getCurrentRequestCookies();

            // 6. Register MCP (corresponds to massUtil.registerMcp)
            JSONObject mcpResult = MaasUtil.registerMcp(cookie, chainInfo, mcpRequest, versionName);
            log.info("MCP registration result: {}", mcpResult);

            // 7. Save MCP data (corresponds to mcpDataDao.insert(mcp) in original project)
            // Original project: mcp.set("createTime", LocalDateTime.now()); mcp.set("uid", uid);
            // mcpDataDao.insert(mcp);
            mcpResult.put("createTime", LocalDateTime.now());
            mcpResult.put("uid", currentUid);
            mcpResult.put("spaceId", spaceId);
            mcpResult.put("botId", botId);
            mcpResult.put("versionName", versionName);
            mcpResult.put("released", 1);
            mcpResult.put("isDelete", 0);

            // Insert MCP data using the JSONObject result (similar to original project)
            int insertResult = insertMcpData(mcpResult);
            if (insertResult == 0) {
                throw new BusinessException(ResponseEnum.SYSTEM_ERROR);
            }

            // 7. Record the release (corresponds to releaseManageClientService.releaseMCP)
            recordMcpRelease(botId, versionName, currentUid, spaceId);

            // 8. Update publish channel
            botPublishService.updatePublishChannel(botId, currentUid, spaceId, PublishChannelEnum.MCP, true);

            log.info("MCP publish completed successfully: botId={}, versionName={}",
                    botId, versionName);

            return ApiResult.success(null); // No specific data needed for MCP publish

        } catch (Exception e) {
            log.error("MCP publish failed: botId={}, error={}", botId, e.getMessage(), e);
            throw e; // Let the controller handle the exception and convert to ApiResult
        }
    }

    @Override
    public ApiResult<Object> offline(Integer botId, Object publishData, String currentUid, Long spaceId) {
        log.info("Offlining bot from MCP: botId={}, currentUid={}, spaceId={}", botId, currentUid, spaceId);

        try {
            // TODO: Implement MCP offline logic
            // This would involve removing MCP server registration and updating database
            log.warn("MCP offline not fully implemented yet: botId={}", botId);

            // Update publish channel to remove MCP
            botPublishService.updatePublishChannel(botId, currentUid, spaceId, PublishChannelEnum.MCP, false);

            return ApiResult.success(null); // No specific data needed for MCP offline

        } catch (Exception e) {
            log.error("MCP offline failed: botId={}, error={}", botId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public String getPublishType() {
        return ReleaseTypeEnum.MCP.name();
    }

    /**
     * Get version name for MCP publishing Corresponds to
     * releaseManageClientService.getVersionNameByBotId -> getVersionName in original project Sends HTTP
     * request to BASE_URL + GET_VERSION_NAME_URL (/get-version-name)
     */
    private String getVersionName(Integer botId, String currentUid, Long spaceId) {
        try {
            // 1. Get flowId from botId
            String flowId = userLangChainDataService.findFlowIdByBotId(botId);
            if (flowId == null || flowId.trim().isEmpty()) {
                log.error("getVersionName - Failed to get flowId by botId, botId={}", botId);
                return generateDefaultVersion();
            }

            // 2. Send HTTP request to get version name
            log.info("Getting version name for MCP publish: botId={}, flowId={}", botId, flowId);

            // Build request body
            JSONObject requestBody = new JSONObject();
            requestBody.put("flowId", flowId);
            String jsonBody = requestBody.toJSONString();

            // Build HTTP request
            String authHeader = getCurrentAuthorizationHeader();
            Request.Builder requestBuilder = new Request.Builder()
                    .url(baseUrl + GET_VERSION_NAME_URL)
                    .post(RequestBody.create(jsonBody, JSON_MEDIA_TYPE))
                    .addHeader("Content-Type", "application/json")
                    .addHeader("Authorization", authHeader);

            // Add spaceId to header
            if (spaceId != null) {
                requestBuilder.addHeader("space-id", spaceId.toString());
            }

            // Execute request
            try (Response response = okHttpClient.newCall(requestBuilder.build()).execute()) {
                ResponseBody body = response.body();
                if (!response.isSuccessful() || body == null) {
                    log.error("getVersionName - HTTP request failed: flowId={}, responseCode={}", flowId, response.code());
                    return generateDefaultVersion();
                }

                String responseBody = body.string();
                if (responseBody == null) {
                    log.error("getVersionName - Response body is null: flowId={}", flowId);
                    return generateDefaultVersion();
                }
                log.debug("getVersionName response: {}", responseBody);

                // Parse response
                JSONObject responseJson = JSON.parseObject(responseBody);
                JSONObject data = responseJson.getJSONObject("data");

                if (data != null && data.containsKey("workflowVersionName")) {
                    String versionName = data.getString("workflowVersionName");
                    log.info("Successfully got version name for MCP: botId={}, versionName={}", botId, versionName);
                    return versionName;
                }

                log.warn("getVersionName - workflowVersionName not found in response: flowId={}", flowId);
                return generateDefaultVersion();
            }

        } catch (Exception e) {
            log.error("getVersionName - Exception occurred: botId={}, flowId={}", botId,
                    userLangChainDataService.findFlowIdByBotId(botId), e);
            return generateDefaultVersion();
        }
    }


    /**
     * Insert MCP data to database Corresponds to mcpDataDao.insert(mcp) in original project
     */
    private int insertMcpData(JSONObject mcpResult) {
        try {
            // Convert JSONObject to McpData entity for database insertion
            McpData mcpData = McpData.builder()
                    .botId(mcpResult.getInteger("botId"))
                    .uid(mcpResult.getString("uid"))
                    .spaceId(mcpResult.getLong("spaceId"))
                    .serverName(mcpResult.getString("serverName"))
                    .description(mcpResult.getString("description"))
                    .content(mcpResult.getString("content"))
                    .icon(mcpResult.getString("icon"))
                    .serverUrl(mcpResult.getString("serverUrl"))
                    .args(mcpResult.getString("args"))
                    .versionName(mcpResult.getString("versionName"))
                    .released(mcpResult.getInteger("released"))
                    .isDelete(mcpResult.getInteger("isDelete"))
                    .createTime(mcpResult.getObject("createTime", LocalDateTime.class))
                    .updateTime(LocalDateTime.now())
                    .build();

            log.info("Inserting MCP data: botId={}, serverName={}, versionName={}",
                    mcpData.getBotId(), mcpData.getServerName(), mcpData.getVersionName());

            return mcpDataMapper.insert(mcpData);

        } catch (Exception e) {
            log.error("Failed to insert MCP data: {}", mcpResult, e);
            throw new BusinessException(ResponseEnum.SYSTEM_ERROR, "Failed to save MCP data");
        }
    }

    /**
     * Record MCP release Corresponds to releaseManageClientService.releaseMCP -> releaseBot in original
     * project Sends HTTP request to BASE_URL + ADD_VERSION_URL (empty string, so just BASE_URL)
     */
    private void recordMcpRelease(Integer botId, String versionName, String currentUid, Long spaceId) {
        try {
            // Get flowId
            String flowId = userLangChainDataService.findFlowIdByBotId(botId);
            if (flowId == null || flowId.trim().isEmpty()) {
                log.error("recordMcpRelease - Failed to get flowId by botId, botId={}", botId);
                return;
            }

            log.info("Recording MCP release: botId={}, flowId={}, versionName={}", botId, flowId, versionName);

            // Build release bot request
            JSONObject releaseBotDto = new JSONObject();
            releaseBotDto.put("botId", botId.toString());
            releaseBotDto.put("flowId", flowId);
            releaseBotDto.put("publishChannel", 3); // ReleaseTypeEnum.MCP.getCode() = 3
            releaseBotDto.put("publishResult", "成功"); // RELEASE_SUCCESS = "成功"
            releaseBotDto.put("description", "");
            releaseBotDto.put("name", versionName);

            String jsonParams = releaseBotDto.toJSONString();

            // Build HTTP request
            String authHeader = getCurrentAuthorizationHeader();
            Request.Builder requestBuilder = new Request.Builder()
                    .url(baseUrl) // ADD_VERSION_URL is empty string, so just use baseUrl
                    .post(RequestBody.create(jsonParams, JSON_MEDIA_TYPE))
                    .addHeader("Content-Type", "application/json")
                    .addHeader("Authorization", authHeader);

            // Add spaceId to header
            if (spaceId != null) {
                requestBuilder.addHeader("space-id", spaceId.toString());
            }

            // Execute request
            try (Response response = okHttpClient.newCall(requestBuilder.build()).execute()) {
                ResponseBody body = response.body();
                if (!response.isSuccessful() || body == null) {
                    log.error("recordMcpRelease - HTTP request failed: botId={}, responseCode={}", botId, response.code());
                    return;
                }

                String responseBody = body.string();
                if (responseBody == null) {
                    log.error("recordMcpRelease - Response body is null: botId={}", botId);
                    return;
                }
                log.debug("recordMcpRelease response: {}", responseBody);

                // Parse response
                JSONObject responseJson = JSON.parseObject(responseBody);
                JSONObject data = responseJson.getJSONObject("data");

                if (data != null) {
                    log.info("MCP release recorded successfully: botId={}, versionName={}, workflowVersionId={}",
                            botId, versionName, data.get("workflowVersionId"));
                } else {
                    log.warn("recordMcpRelease - No data in response: botId={}", botId);
                }
            }

        } catch (Exception e) {
            log.error("recordMcpRelease - Exception occurred: botId={}, versionName={}", botId, versionName, e);
            // Don't throw exception here as the main MCP data has already been saved
        }
    }


    /**
     * Generate default version name as fallback
     */
    private String generateDefaultVersion() {
        return "v" + System.currentTimeMillis();
    }

    /**
     * Get cookies from current HTTP request context This is a better practice than passing
     * HttpServletRequest directly to strategy
     */
    private String getCurrentRequestCookies() {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) {
                log.warn("No request context available, using empty cookies");
                return "";
            }

            HttpServletRequest request = attributes.getRequest();
            Cookie[] cookies = request.getCookies();

            if (cookies == null || cookies.length == 0) {
                return "";
            }

            return Arrays.stream(cookies)
                    .map(cookie -> cookie.getName() + "=" + cookie.getValue())
                    .collect(Collectors.joining("; "));

        } catch (Exception e) {
            log.error("Failed to get request cookies", e);
            return "";
        }
    }

    /**
     * Get Authorization header from current request context
     */
    private String getCurrentAuthorizationHeader() {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) {
                log.warn("No request context available for Authorization header");
                return "";
            }

            HttpServletRequest request = attributes.getRequest();
            return MaasUtil.getAuthorizationHeader(request);
        } catch (Exception e) {
            log.error("Failed to get Authorization header from request context", e);
            return "";
        }
    }

    /**
     * Parse publish data to McpPublishRequestDto
     */
    private McpPublishRequestDto parsePublishData(Object publishData, Integer botId) {
        if (publishData == null) {
            throw new IllegalArgumentException("MCP publish data cannot be null");
        }

        try {
            McpPublishRequestDto mcpRequest;

            if (publishData instanceof McpPublishRequestDto) {
                mcpRequest = (McpPublishRequestDto) publishData;
            } else {
                // Try to parse from JSON
                String jsonData = JSON.toJSONString(publishData);
                mcpRequest = JSON.parseObject(jsonData, McpPublishRequestDto.class);
            }

            // Ensure botId is set
            if (mcpRequest.getBotId() == null) {
                mcpRequest.setBotId(botId);
            }

            // Validate required fields
            if (mcpRequest.getServerName() == null || mcpRequest.getServerName().trim().isEmpty()) {
                throw new IllegalArgumentException("MCP server name is required");
            }

            return mcpRequest;

        } catch (Exception e) {
            log.error("Failed to parse MCP publish data: botId={}, data={}", botId, publishData, e);
            throw new IllegalArgumentException("Invalid MCP publish data format", e);
        }
    }
}
