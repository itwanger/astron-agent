package com.iflytek.astron.console.hub.service.publish.impl;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.iflytek.astron.console.commons.entity.bot.UserLangChainInfo;
import com.iflytek.astron.console.hub.dto.PageResponse;
import com.iflytek.astron.console.commons.dto.bot.BotListRequestDto;
import com.iflytek.astron.console.hub.dto.publish.BotPublishInfoDto;
import com.iflytek.astron.console.hub.dto.publish.BotDetailResponseDto;
import com.iflytek.astron.console.hub.dto.publish.BotVersionVO;
import com.iflytek.astron.console.hub.dto.publish.BotSummaryStatsVO;
import com.iflytek.astron.console.hub.dto.publish.BotTimeSeriesResponseDto;
import com.iflytek.astron.console.hub.dto.publish.BotTimeSeriesStatsVO;
import com.iflytek.astron.console.hub.dto.publish.WechatAuthUrlResponseDto;
import com.iflytek.astron.console.hub.dto.publish.BotTraceRequestDto;
import com.iflytek.astron.console.commons.dto.workflow.WorkflowInputsResponseDto;
import com.iflytek.astron.console.hub.dto.publish.UnifiedPrepareDto;
import com.iflytek.astron.console.hub.dto.publish.prepare.*;
import com.iflytek.astron.console.hub.dto.publish.prepare.WechatPrepareDto;
import com.iflytek.astron.console.commons.enums.bot.ReleaseTypeEnum;
import com.iflytek.astron.console.commons.entity.model.McpData;
import com.iflytek.astron.console.commons.mapper.model.McpDataMapper;
import com.iflytek.astron.console.hub.service.publish.WorkflowInputService;
import com.iflytek.astron.console.commons.service.data.UserLangChainDataService;
import com.iflytek.astron.console.commons.enums.PublishChannelEnum;
import com.iflytek.astron.console.commons.enums.ShelfStatusEnum;
import com.iflytek.astron.console.commons.mapper.bot.ChatBotMarketMapper;
import com.iflytek.astron.console.hub.mapper.BotConversationStatsMapper;
import com.iflytek.astron.console.commons.mapper.bot.ChatBotBaseMapper;
import com.iflytek.astron.console.hub.converter.BotPublishConverter;
import com.iflytek.astron.console.hub.converter.WorkflowVersionConverter;
import com.iflytek.astron.console.hub.service.publish.PublishChannelService;
import com.iflytek.astron.console.hub.service.wechat.WechatThirdpartyService;
import com.iflytek.astron.console.commons.dto.bot.BotPublishQueryResult;
import com.iflytek.astron.console.hub.entity.BotConversationStats;
import com.iflytek.astron.console.hub.service.publish.BotPublishService;
import com.iflytek.astron.console.commons.exception.BusinessException;
import com.iflytek.astron.console.commons.constant.ResponseEnum;
import com.iflytek.astron.console.commons.util.BotFileParamUtil;
import com.iflytek.astron.console.toolkit.entity.table.workflow.WorkflowVersion;
import com.iflytek.astron.console.toolkit.mapper.workflow.WorkflowVersionMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import com.iflytek.astron.console.commons.dto.bot.BotQueryCondition;
import com.iflytek.astron.console.hub.event.BotPublishStatusChangedEvent;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Value;

/**
 * Bot Publishing Management Service Implementation
 *
 * Unified bot publishing management service implementation, including: - Bot list query and detail
 * retrieval - Publishing status management (publish/take offline) - Version management - Statistics
 * data query
 *
 * @author Omuigix
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class BotPublishServiceImpl implements BotPublishService {

    private final ChatBotMarketMapper chatBotMarketMapper;
    private final ChatBotBaseMapper chatBotBaseMapper;
    private final BotPublishConverter botPublishConverter;
    private final PublishChannelService publishChannelService;
    private final WechatThirdpartyService wechatThirdpartyService;
    private final ApplicationEventPublisher eventPublisher;
    private final WorkflowInputService workflowInputService;
    private final McpDataMapper mcpDataMapper;

    @Value("${maas.mcpHost}")
    private String mcpHost;
    private final UserLangChainDataService userLangChainDataService;

    // Version management related
    private final WorkflowVersionMapper workflowVersionMapper;
    private final WorkflowVersionConverter workflowVersionConverter;

    // Statistics data related
    private final BotConversationStatsMapper botConversationStatsMapper;

    @Override
    public PageResponse<BotPublishInfoDto> getBotList(
            BotListRequestDto requestDto,
            String currentUid,
            Long spaceId) {

        log.info("Query bot list: uid={}, spaceId={}, request={}", currentUid, spaceId, requestDto);

        // 1. Build type-safe query condition
        BotQueryCondition condition = BotQueryCondition.from(requestDto, currentUid, spaceId);
        condition.validate();

        // 2. Execute multi-table join pagination query (using entity class to receive results)
        Page<BotPublishQueryResult> page = new Page<>(requestDto.getPage(), requestDto.getSize());
        Page<BotPublishQueryResult> queryResult = chatBotMarketMapper.selectBotListByConditions(page, condition);

        // 3. Use MapStruct for type-safe object mapping
        List<BotPublishInfoDto> botList = botPublishConverter.queryResultsToDtoList(queryResult.getRecords());

        // 4. Build response result
        return PageResponse.of(
                requestDto.getPage(),
                requestDto.getSize(),
                queryResult.getTotal(),
                botList);
    }


    @Override
    public BotDetailResponseDto getBotDetail(Integer botId, String currentUid, Long spaceId) {
        log.info("Query bot details: botId={}, uid={}, spaceId={}", botId, currentUid, spaceId);

        // 1. Permission validation and query bot basic information
        BotPublishQueryResult queryResult = chatBotMarketMapper.selectBotDetail(botId, currentUid, spaceId);
        if (queryResult == null) {
            throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
        }

        // 2. Basic information conversion (including publish channel parsing)
        BotDetailResponseDto detailDto = botPublishConverter.queryResultToDetailDto(queryResult);

        // 3. Get WeChat binding information (only query when published to WeChat)
        if (detailDto.getPublishChannels().contains(PublishChannelEnum.WECHAT.getCode())) {
            String[] wechatInfo = publishChannelService.getWechatInfo(currentUid, botId);
            detailDto.setWechatRelease(Integer.valueOf(wechatInfo[0]));
            detailDto.setWechatAppid(wechatInfo[1]);
        } else {
            detailDto.setWechatRelease(0);
            detailDto.setWechatAppid(null);
        }

        log.info("Bot details query completed: botId={}, channels={}", botId, detailDto.getPublishChannels());
        return detailDto;
    }



    // ==================== Version Management ====================

    @Override
    public PageResponse<BotVersionVO> getBotVersions(Integer botId, Integer page, Integer size, String uid, Long spaceId) {
        log.info("Query workflow version list: botId={}, page={}, size={}, uid={}, spaceId={}",
                botId, page, size, uid, spaceId);

        // 1. Permission validation - ensure user has permission to access the bot
        validateBotPermission(botId, uid, spaceId);

        // 2. Get flowId from botId
        String flowId = userLangChainDataService.findFlowIdByBotId(botId);
        if (flowId == null || flowId.trim().isEmpty()) {
            log.warn("No flowId found for botId={}", botId);
            return PageResponse.of(page, size, 0L, new ArrayList<>());
        }

        // 3. Pagination query version list - query workflow_version table using flowId
        Page<WorkflowVersion> pageParam = new Page<>(page, size);
        Page<WorkflowVersion> resultPage = workflowVersionMapper.selectPageByCondition(pageParam, flowId);

        // 4. Use MapStruct batch conversion to VO
        List<WorkflowVersion> versions = resultPage.getRecords();
        List<BotVersionVO> versionList = workflowVersionConverter.toVersionVOList(versions);

        log.info("Query workflow version list successful: botId={}, flowId={}, total={}", botId, flowId, resultPage.getTotal());
        return PageResponse.of(page, size, resultPage.getTotal(), versionList);
    }

    // ==================== Statistics Data ====================

    @Override
    public BotSummaryStatsVO getBotSummaryStats(Integer botId, String currentUid, Long currentSpaceId) {
        log.info("Get bot summary statistics: botId={}, uid={}, spaceId={}",
                botId, currentUid, currentSpaceId);

        // 1. Permission validation
        int hasPermission = chatBotBaseMapper.checkBotPermission(botId, currentUid, currentSpaceId);
        if (hasPermission == 0) {
            throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
        }

        // 2. Query summary statistics data
        BotSummaryStatsVO summaryStats = botConversationStatsMapper.selectSummaryStats(botId, null, null);
        if (summaryStats == null) {
            // If no statistics data, return default values (using primitive type long, will be 0 automatically)
            summaryStats = new BotSummaryStatsVO();
        }

        log.info("Bot summary statistics query completed: botId={}, totalChats={}, totalUsers={}",
                botId, summaryStats.getTotalChats(), summaryStats.getTotalUsers());

        return summaryStats;
    }

    @Override
    public BotTimeSeriesResponseDto getBotTimeSeriesStats(Integer botId, Integer overviewDays,
            String currentUid, Long currentSpaceId) {
        log.info("Get bot time series statistics: botId={}, overviewDays={}, uid={}, spaceId={}",
                botId, overviewDays, currentUid, currentSpaceId);

        // 1. Permission validation
        int hasPermission = chatBotBaseMapper.checkBotPermission(botId, currentUid, currentSpaceId);
        if (hasPermission == 0) {
            throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
        }

        // 2. Query time series statistics data
        LocalDate startDate = LocalDate.now().minusDays(overviewDays);
        List<BotTimeSeriesStatsVO> timeSeriesStats = botConversationStatsMapper.selectTimeSeriesStats(
                botId, startDate, null, null);

        // 3. Build time series data response
        BotTimeSeriesResponseDto timeSeries = new BotTimeSeriesResponseDto();
        timeSeries.setActivityUser(convertToTimeSeriesItems(timeSeriesStats, "user"));
        timeSeries.setTokenUsed(convertToTimeSeriesItems(timeSeriesStats, "token"));
        timeSeries.setChatMessages(convertToTimeSeriesItems(timeSeriesStats, "message"));
        timeSeries.setAvgChatMessages(calculateAvgMessages(timeSeriesStats));

        log.info("Bot time series statistics query completed: botId={}, data points count={}",
                botId, timeSeriesStats.size());

        return timeSeries;
    }

    @Override
    public void recordConversationStats(String uid, Long spaceId, Integer botId, Long chatId,
            String sid, Integer tokenConsumed, Integer messageRounds) {
        log.info("Record conversation statistics: uid={}, spaceId={}, botId={}, chatId={}, tokenConsumed={}, messageRounds={}",
                uid, spaceId, botId, chatId, tokenConsumed, messageRounds);

        try {
            BotConversationStats stats = BotConversationStats.createBuilder()
                    .uid(uid)
                    .spaceId(spaceId)
                    .botId(botId)
                    .chatId(chatId)
                    .sid(sid)
                    .tokenConsumed(tokenConsumed)
                    .messageRounds(messageRounds)
                    .build();
            int result = botConversationStatsMapper.insert(stats);

            if (result > 0) {
                log.info("Conversation statistics recorded successfully: chatId={}, statsId={}", chatId, stats.getId());

            } else {
                log.warn("Conversation statistics record failed: chatId={}", chatId);
            }
        } catch (Exception e) {
            log.error("Record conversation statistics exception: chatId={}", chatId, e);
            // Do not throw exception to avoid affecting main business flow
        }
    }

    // ==================== Private Helper Methods ====================

    /**
     * Validate bot permission
     */
    private void validateBotPermission(Integer botId, String uid, Long spaceId) {
        Integer count = chatBotBaseMapper.checkBotPermission(botId, uid, spaceId);
        if (count == null || count == 0) {
            throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
        }
    }


    /**
     * Get current publish channel
     */
    private String getCurrentPublishChannels(Integer botId, String uid, Long spaceId) {
        try {
            var queryResult = chatBotMarketMapper.selectBotDetail(botId, uid, spaceId);
            return queryResult != null ? queryResult.getPublishChannels() : null;
        } catch (Exception e) {
            log.warn("Query current publish channel failed: botId={}, uid={}, spaceId={}", botId, uid, spaceId, e);
            return null;
        }
    }

    /**
     * Create market record (for publish channel) Note: This method now delegates to event-driven
     * architecture
     */
    private void createMarketRecordForChannel(Integer botId, String uid, Long spaceId, String channels) {
        // Publish event to create market record - handled by InstructionalBotPublishListener
        eventPublisher.publishEvent(new BotPublishStatusChangedEvent(
                this, botId, uid, spaceId, "PUBLISH",
                null, ShelfStatusEnum.OFF_SHELF.getCode(), channels));
        log.info("Create market record event published: botId={}, uid={}, spaceId={}, channels={}",
                botId, uid, spaceId, channels);
    }

    /**
     * Update market record publish channel
     */
    private void updateMarketRecordChannels(Integer botId, String uid, Long spaceId, String channels) {
        try {
            int updateCount = chatBotMarketMapper.updatePublishStatus(botId, uid, spaceId, null, channels);
            if (updateCount > 0) {
                log.info("Update market record publish channel successfully: botId={}, channels={}", botId, channels);
            } else {
                log.warn("Update market record publish channel failed, record not found: botId={}, uid={}, spaceId={}",
                        botId, uid, spaceId);
            }
        } catch (Exception e) {
            log.error("Update market record publish channel exception: botId={}, uid={}, spaceId={}, channels={}",
                    botId, uid, spaceId, channels, e);
        }
    }

    /**
     * Convert time series data items
     */
    private List<BotTimeSeriesResponseDto.TimeSeriesItem> convertToTimeSeriesItems(
            List<BotTimeSeriesStatsVO> timeSeriesStats, String type) {
        return timeSeriesStats.stream()
                .map(stats -> {
                    Integer count = switch (type) {
                        case "user" -> stats.getUserCount();
                        case "token" -> stats.getTokenCount();
                        case "message" -> stats.getMessageCount();
                        case "chat" -> stats.getChatCount();
                        default -> 0;
                    };
                    return new BotTimeSeriesResponseDto.TimeSeriesItem(
                            stats.getDate().toString(), count);
                })
                .collect(Collectors.toList());
    }

    /**
     * Calculate average messages per conversation
     */
    private List<BotTimeSeriesResponseDto.TimeSeriesItem> calculateAvgMessages(
            List<BotTimeSeriesStatsVO> timeSeriesStats) {
        return timeSeriesStats.stream()
                .map(stats -> {
                    Integer avgCount = stats.getChatCount() > 0
                            ? stats.getMessageCount() / stats.getChatCount()
                            : 0;
                    return new BotTimeSeriesResponseDto.TimeSeriesItem(
                            stats.getDate().toString(), avgCount);
                })
                .collect(Collectors.toList());
    }

    // ==================== publishchannelmanagement ====================

    @Override
    public void updatePublishChannel(Integer botId, String uid, Long spaceId, PublishChannelEnum channel, boolean isAdd) {
        log.info("Update bot publish channel: botId={}, uid={}, spaceId={}, channel={}, isAdd={}",
                botId, uid, spaceId, channel.getCode(), isAdd);

        try {
            // 1. Permission validation
            int hasPermission = chatBotBaseMapper.checkBotPermission(botId, uid, spaceId);
            if (hasPermission == 0) {
                log.warn("Bot permission validation failed: botId={}, uid={}, spaceId={}", botId, uid, spaceId);
                return;
            }

            // 2. Query current publish channel
            String currentChannels = getCurrentPublishChannels(botId, uid, spaceId);

            // 3. Update publish channel
            String newChannels = publishChannelService.updatePublishChannels(currentChannels, channel.getCode(), isAdd);

            // 4. Update database
            if (!Objects.equals(currentChannels, newChannels)) {
                if (currentChannels == null) {
                    // If no market record exists, need to create first
                    createMarketRecordForChannel(botId, uid, spaceId, newChannels);
                } else {
                    // Update existing record
                    updateMarketRecordChannels(botId, uid, spaceId, newChannels);
                }

                log.info("Bot publish channel updated successfully: botId={}, {} -> {}", botId, currentChannels, newChannels);
            } else {
                log.debug("Bot publish channel unchanged: botId={}, channels={}", botId, currentChannels);
            }
        } catch (Exception e) {
            log.error("Update bot publish channel failed: botId={}, uid={}, spaceId={}, channel={}, isAdd={}",
                    botId, uid, spaceId, channel.getCode(), isAdd, e);
            // Do not throw exception to avoid affecting main business flow
        }
    }

    // ==================== WeChat Publish Management ====================

    @Override
    public WechatAuthUrlResponseDto getWechatAuthUrl(Integer botId, String appid, String redirectUrl,
            String uid, Long spaceId) {
        log.info("Get WeChat authorization URL: botId={}, appid={}, redirectUrl={}, uid={}, spaceId={}",
                botId, appid, redirectUrl, uid, spaceId);

        // 1. Permission validation
        int hasPermission = chatBotBaseMapper.checkBotPermission(botId, uid, spaceId);
        if (hasPermission == 0) {
            throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
        }

        // 2. Get pre-authorization code
        String preAuthCode = wechatThirdpartyService.getPreAuthCode(botId, appid, uid);

        // 3. Generate authorization URL
        String authUrl = wechatThirdpartyService.buildAuthUrl(preAuthCode, appid, redirectUrl);

        // 4. Build response
        WechatAuthUrlResponseDto response = WechatAuthUrlResponseDto.of(authUrl);
        response.setPreAuthCode(preAuthCode);

        log.info("WeChat authorization URL generated successfully: botId={}, authUrl={}", botId, authUrl);
        return response;
    }

    // ==================== Trace Log Management ====================

    @Override
    public PageResponse<Object> getBotTrace(String uid, Integer botId, BotTraceRequestDto requestDto, Long spaceId) {
        log.info("Getting trace logs for bot: botId={}, uid={}, spaceId={}, request={}",
                botId, uid, spaceId, requestDto);

        // TODO: Implement actual trace log retrieval logic when ElasticSearch is available
        // This is a placeholder implementation until ES integration is ready
        //
        // When implementing:
        // 1. Validate bot permissions (check if user has access to this bot)
        // 2. Get bot flow ID from bot configuration
        // 3. Query trace logs from ElasticSearch with time range and filters
        // 4. Apply additional filters (logLevel, keyword, traceId, sessionId)
        // 5. Return paginated results

        log.warn("Trace log functionality not yet implemented - ElasticSearch integration pending");

        // Return empty result for now
        return PageResponse.of(requestDto.getPage(), requestDto.getPageSize(), 0L, new ArrayList<>());
    }

    // ==================== Workflow Input Management ====================

    @Override
    public WorkflowInputsResponseDto getInputsType(Integer botId, String uid, Long spaceId) {
        log.info("Getting workflow input parameters: botId={}, uid={}, spaceId={}", botId, uid, spaceId);

        // Delegate to WorkflowInputService
        WorkflowInputsResponseDto result = workflowInputService.getInputsType(botId, uid, spaceId);

        log.info("Workflow input parameters retrieved successfully: botId={}, paramCount={}",
                botId, result.getParameters().size());

        return result;
    }

    // ==================== Publish Prepare Data Management ====================

    @Override
    public UnifiedPrepareDto getPrepareData(Integer botId, String type, String currentUid, Long spaceId) {
        log.info("Getting prepare data: botId={}, type={}, uid={}, spaceId={}", botId, type, currentUid, spaceId);

        try {
            // Validate publish type
            ReleaseTypeEnum publishTypeEnum = ReleaseTypeEnum.getByName(type);
            if (publishTypeEnum == null) {
                return createErrorPrepareResponse("Invalid publish type: " + type);
            }

            // Get bot basic info first
            BotDetailResponseDto botDetail = getBotDetail(botId, currentUid, spaceId);
            if (botDetail == null) {
                return createErrorPrepareResponse("Bot not found");
            }

            BasePrepareDto prepareData;
            switch (publishTypeEnum) {
                case MARKET:
                    prepareData = getMarketPrepareData(botId, botDetail, currentUid, spaceId);
                    break;
                case MCP:
                    prepareData = getMcpPrepareData(botId, botDetail, currentUid, spaceId);
                    break;
                case FEISHU:
                    prepareData = getFeishuPrepareData(botId, botDetail, currentUid, spaceId);
                    break;
                case BOT_API:
                    prepareData = getApiPrepareData(botId, botDetail, currentUid, spaceId);
                    break;
                case WECHAT:
                    prepareData = getWechatPrepareData(botId, botDetail, currentUid, spaceId);
                    break;
                default:
                    return createErrorPrepareResponse("Unsupported publish type: " + type);
            }

            if (prepareData == null) {
                return createErrorPrepareResponse("Failed to prepare data for type: " + type);
            }

            UnifiedPrepareDto response = new UnifiedPrepareDto();
            response.setSuccess(true);
            response.setData(prepareData);

            log.info("Prepare data retrieved successfully: botId={}, type={}", botId, type);
            return response;

        } catch (Exception e) {
            log.error("Failed to get prepare data: botId={}, type={}, uid={}, spaceId={}",
                    botId, type, currentUid, spaceId, e);
            return createErrorPrepareResponse("Failed to get prepare data: " + e.getMessage());
        }
    }

    private MarketPrepareDto getMarketPrepareData(Integer botId, BotDetailResponseDto botDetail, String currentUid, Long spaceId) {
        log.info("Getting market prepare data: botId={}", botId);

        MarketPrepareDto marketData = new MarketPrepareDto();
        marketData.setPublishType(ReleaseTypeEnum.MARKET.name());

        // Get workflow configuration JSON
        try {
            String flowId = userLangChainDataService.findFlowIdByBotId(botId);
            if (flowId != null) {
                // TODO: Get complete workflow configuration JSON
                // This should call the workflow service to get the full configuration
                marketData.setWorkflowConfigJson("{}"); // Placeholder
            }
        } catch (Exception e) {
            log.warn("Failed to get workflow config for market prepare: botId={}", botId, e);
        }

        // Set bot basic info
        marketData.setBotName(botDetail.getBotName());
        marketData.setBotDescription(botDetail.getBotDesc());
        marketData.setBotAvatar(null); // TODO: Get bot avatar from appropriate source

        // Set multi-file parameter support based on extraInputsConfig
        boolean isMultiFileParam = false;
        try {
            UserLangChainInfo chainInfo = userLangChainDataService.findOneByBotId(botId);
            if (chainInfo != null && chainInfo.getExtraInputsConfig() != null) {
                List<JSONObject> extraInputsConfig = JSONArray.parseArray(chainInfo.getExtraInputsConfig(), JSONObject.class);
                isMultiFileParam = BotFileParamUtil.isMultiFileParam(botId, extraInputsConfig);
            }
        } catch (Exception e) {
            log.warn("Failed to determine multi-file parameter support: botId={}", botId, e);
        }
        marketData.setBotMultiFileParam(isMultiFileParam);

        // Set suggested tags and categories
        marketData.setSuggestedTags(List.of("智能助手", "效率工具"));
        marketData.setCategoryOptions(List.of("教育", "金融", "医疗", "客服"));

        return marketData;
    }

    private McpPrepareDto getMcpPrepareData(Integer botId, BotDetailResponseDto botDetail, String currentUid, Long spaceId) {
        log.info("Getting MCP prepare data: botId={}", botId);

        McpPrepareDto result = new McpPrepareDto();
        result.setPublishType(ReleaseTypeEnum.MCP.name());

        // 1. Set workflow input types
        result.setInputTypes(getWorkflowInputTypes(botId, currentUid, spaceId));

        // 2. Set suggested configuration
        result.setSuggestedConfig(buildMcpSuggestedConfig(botId, botDetail));

        // 3. Set MCP content (existing or default)
        result.setContentInfo(getMcpContentInfo(botId, botDetail));

        return result;
    }

    private List<McpPrepareDto.InputTypeDto> getWorkflowInputTypes(Integer botId, String currentUid, Long spaceId) {
        try {
            WorkflowInputsResponseDto inputsResponse = getInputsType(botId, currentUid, spaceId);
            if (inputsResponse != null && inputsResponse.getParameters() != null) {
                return inputsResponse.getParameters()
                        .stream()
                        .map(param -> {
                            McpPrepareDto.InputTypeDto inputType = new McpPrepareDto.InputTypeDto();
                            inputType.setName(param.getName());
                            inputType.setType(param.getType());
                            inputType.setDescription(param.getDescription());
                            inputType.setRequired(param.getRequired());
                            return inputType;
                        })
                        .collect(Collectors.toList());
            }
        } catch (Exception e) {
            log.warn("Failed to get input types for MCP prepare: botId={}", botId, e);
        }
        return new ArrayList<>();
    }

    private McpPrepareDto.SuggestedConfig buildMcpSuggestedConfig(Integer botId, BotDetailResponseDto botDetail) {
        String botName = botDetail.getBotName();
        String botDesc = botDetail.getBotDesc();

        McpPrepareDto.SuggestedConfig suggestedConfig = new McpPrepareDto.SuggestedConfig();
        suggestedConfig.setServiceName(botName != null ? botName : "bot-" + botId);
        suggestedConfig.setOverview("基于工作流的智能助手");
        suggestedConfig.setContent(botDesc != null ? botDesc : "提供智能对话和任务处理能力");
        return suggestedConfig;
    }

    private McpPrepareDto.McpContentInfo getMcpContentInfo(Integer botId, BotDetailResponseDto botDetail) {
        // Try to get existing MCP data from database
        McpPrepareDto.McpContentInfo contentInfo = loadExistingMcpContent(botId);

        if (contentInfo != null) {
            log.info("Using existing MCP content: botId={}, released={}", botId, contentInfo.getReleased());
            return contentInfo;
        }

        // Generate default MCP content for new setup
        log.info("Generating default MCP content: botId={}", botId);
        return generateDefaultMcpContent(botId, botDetail);
    }

    private McpPrepareDto.McpContentInfo loadExistingMcpContent(Integer botId) {
        try {
            McpData mcpData = mcpDataMapper.selectLatestByBotId(botId);
            if (mcpData != null) {
                McpPrepareDto.McpContentInfo contentInfo = new McpPrepareDto.McpContentInfo();
                contentInfo.setServerName(mcpData.getServerName());
                contentInfo.setDescription(mcpData.getDescription());
                contentInfo.setContent(mcpData.getContent());
                contentInfo.setIcon(mcpData.getIcon());
                contentInfo.setServerUrl(mcpData.getServerUrl());
                contentInfo.setArgs(mcpData.getArgs());
                contentInfo.setVersionName(mcpData.getVersionName());
                contentInfo.setReleased(mcpData.getReleased() != null && mcpData.getReleased() == 1 ? "1" : "0");
                return contentInfo;
            }
        } catch (Exception e) {
            log.warn("Failed to load existing MCP content: botId={}", botId, e);
        }
        return null;
    }

    private McpPrepareDto.McpContentInfo generateDefaultMcpContent(Integer botId, BotDetailResponseDto botDetail) {
        String botName = botDetail.getBotName();
        String botDesc = botDetail.getBotDesc();

        McpPrepareDto.McpContentInfo contentInfo = new McpPrepareDto.McpContentInfo();
        contentInfo.setServerName(botName != null ? botName : "bot-" + botId);
        contentInfo.setDescription("基于工作流的智能助手");
        contentInfo.setContent(botDesc != null ? botDesc : "提供智能对话和任务处理能力");
        contentInfo.setReleased("0"); // Not published yet

        // Generate MCP server URL using mcpHost configuration
        try {
            String flowId = userLangChainDataService.findFlowIdByBotId(botId);
            if (flowId != null && mcpHost != null) {
                String serverUrl = String.format(mcpHost, flowId);
                contentInfo.setServerUrl(serverUrl);
                log.info("Generated MCP server URL: botId={}, flowId={}, serverUrl={}", botId, flowId, serverUrl);
            }
        } catch (Exception e) {
            log.warn("Failed to generate MCP server URL: botId={}", botId, e);
        }

        return contentInfo;
    }

    private FeishuPrepareDto getFeishuPrepareData(Integer botId, BotDetailResponseDto botDetail, String currentUid, Long spaceId) {
        log.info("Getting Feishu prepare data: botId={}", botId);

        FeishuPrepareDto feishuData = new FeishuPrepareDto();
        feishuData.setPublishType(ReleaseTypeEnum.FEISHU.name());

        // TODO: Get actual Feishu app configuration
        feishuData.setAppId("cli_xxx");
        feishuData.setAppSecret("xxx");

        // Set bot info
        feishuData.setBotName(botDetail.getBotName());
        feishuData.setBotDescription(botDetail.getBotDesc());
        feishuData.setBotAvatar(null); // TODO: Get bot avatar from appropriate source

        // Set suggested configuration
        FeishuPrepareDto.SuggestedConfig suggestedConfig = new FeishuPrepareDto.SuggestedConfig();
        suggestedConfig.setDisplayName("智能助手");
        suggestedConfig.setDescription("基于工作流的智能助手");
        feishuData.setSuggestedConfig(suggestedConfig);

        return feishuData;
    }

    private ApiPrepareDto getApiPrepareData(Integer botId, BotDetailResponseDto botDetail, String currentUid, Long spaceId) {
        log.info("Getting API prepare data: botId={}", botId);

        ApiPrepareDto apiData = new ApiPrepareDto();
        apiData.setPublishType(ReleaseTypeEnum.BOT_API.name());

        // Set API endpoint
        apiData.setApiEndpoint("/api/v1/chat/" + botId);
        apiData.setDocumentation("API文档URL");
        apiData.setApiKey("生成的API Key"); // TODO: Generate actual API key
        apiData.setAuthType("Bearer");

        // Set suggested configuration
        ApiPrepareDto.SuggestedConfig suggestedConfig = new ApiPrepareDto.SuggestedConfig();
        suggestedConfig.setRateLimitPerMinute(100);
        suggestedConfig.setEnableAuth(true);
        apiData.setSuggestedConfig(suggestedConfig);

        return apiData;
    }

    private WechatPrepareDto getWechatPrepareData(Integer botId, BotDetailResponseDto botDetail, String currentUid, Long spaceId) {
        log.info("Getting WeChat prepare data: botId={}", botId);

        WechatPrepareDto wechatData = new WechatPrepareDto();
        wechatData.setPublishType(ReleaseTypeEnum.WECHAT.name());

        // TODO: Get actual WeChat configuration
        wechatData.setAppId("wx_xxx");
        wechatData.setAppSecret("xxx");
        wechatData.setToken("xxx");
        wechatData.setEncodingAESKey("xxx");

        return wechatData;
    }

    private UnifiedPrepareDto createErrorPrepareResponse(String errorMessage) {
        UnifiedPrepareDto response = new UnifiedPrepareDto();
        response.setSuccess(false);
        response.setErrorMessage(errorMessage);
        return response;
    }
}
