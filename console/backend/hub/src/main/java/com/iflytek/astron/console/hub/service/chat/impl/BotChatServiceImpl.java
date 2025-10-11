package com.iflytek.astron.console.hub.service.chat.impl;

import cn.hutool.core.collection.CollectionUtil;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.iflytek.astron.console.commons.constant.ResponseEnum;
import com.iflytek.astron.console.commons.entity.bot.ChatBotMarket;
import com.iflytek.astron.console.commons.entity.chat.ChatList;
import com.iflytek.astron.console.commons.entity.chat.ChatListCreateResponse;
import com.iflytek.astron.console.commons.exception.BusinessException;
import com.iflytek.astron.console.commons.service.bot.BotService;
import com.iflytek.astron.console.commons.service.bot.ChatBotDataService;
import com.iflytek.astron.console.commons.service.data.ChatDataService;
import com.iflytek.astron.console.commons.entity.bot.ChatBotReqDto;
import com.iflytek.astron.console.commons.dto.llm.SparkChatRequest;
import com.iflytek.astron.console.commons.entity.bot.ChatBotBase;
import com.iflytek.astron.console.commons.entity.chat.ChatReqRecords;
import com.iflytek.astron.console.commons.enums.bot.BotTypeEnum;
import com.iflytek.astron.console.commons.enums.ShelfStatusEnum;
import com.iflytek.astron.console.commons.service.data.ChatListDataService;
import com.iflytek.astron.console.commons.util.SseEmitterUtil;
import com.iflytek.astron.console.hub.data.ReqKnowledgeRecordsDataService;
import com.iflytek.astron.console.hub.entity.ReqKnowledgeRecords;
import com.iflytek.astron.console.hub.service.PromptChatService;
import com.iflytek.astron.console.hub.service.SparkChatService;
import com.iflytek.astron.console.hub.service.chat.BotChatService;
import com.iflytek.astron.console.commons.service.data.ChatHistoryService;
import com.iflytek.astron.console.commons.service.workflow.WorkflowBotChatService;
import com.iflytek.astron.console.hub.service.chat.ChatListService;
import com.iflytek.astron.console.hub.service.knowledge.KnowledgeService;
import com.iflytek.astron.console.toolkit.entity.vo.CategoryTreeVO;
import com.iflytek.astron.console.toolkit.entity.vo.LLMInfoVo;
import com.iflytek.astron.console.toolkit.service.model.ModelService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
public class BotChatServiceImpl implements BotChatService {

    @Autowired
    private ChatBotDataService chatBotDataService;

    @Autowired
    private ChatDataService chatDataService;

    @Autowired
    private SparkChatService sparkChatService;

    @Autowired
    private ChatHistoryService chatHistoryService;

    @Autowired
    private WorkflowBotChatService workflowBotChatService;

    @Autowired
    private KnowledgeService knowledgeService;

    @Value("${spark.chat.max.input.tokens:8000}")
    private int maxInputTokens;

    public static final String LOOSE_PREFIX_PROMPT = """
            Please use the following document fragments as known information: []
            Please answer questions accurately based on the original text of the above passages and your knowledge
            When answering user questions, please respond in the language the user asked the question
            If the above content cannot answer user information, combine the information you know to answer user questions
            Answer user questions concisely and professionally, and do not allow fabricated components to be added to the answer.
            """;

    @Autowired
    private ChatListDataService chatListDataService;

    @Autowired
    private ChatListService chatListService;

    @Autowired
    private BotService botService;

    @Autowired
    private ModelService modelService;

    @Autowired
    private PromptChatService promptChatService;

    @Autowired
    private ReqKnowledgeRecordsDataService reqKnowledgeRecordsDataService;

    /**
     * Function to handle chat messages
     *
     * @param chatBotReqDto Chat bot request data object
     * @param sseEmitter Server-sent events emitter
     * @param sseId Server-sent events ID
     * @param workflowOperation Workflow operation
     * @param workflowVersion Workflow version
     */
    @Override
    public void chatMessageBot(ChatBotReqDto chatBotReqDto, SseEmitter sseEmitter, String sseId, String workflowOperation, String workflowVersion) {
        try {
            log.info("Processing chat request, sseId: {}, chatId: {}, uid: {}", sseId, chatBotReqDto.getChatId(), chatBotReqDto.getUid());

            BotConfiguration botConfig = getBotConfiguration(chatBotReqDto.getBotId());
            if (botConfig.version.equals(BotTypeEnum.WORKFLOW_BOT.getType())) {
                workflowBotChatService.chatWorkflowBot(chatBotReqDto, sseEmitter, sseId, workflowOperation, workflowVersion);
            } else {
                ChatReqRecords chatReqRecords = createChatRequest(chatBotReqDto);
                int maxInputTokens = this.maxInputTokens;
                if (botConfig.modelId == null) {
                    List<SparkChatRequest.MessageDto> messages = buildMessageList(chatBotReqDto, botConfig.supportContext, botConfig.prompt, maxInputTokens, chatReqRecords.getId());
                    SparkChatRequest sparkChatRequest = buildSparkChatRequest(chatBotReqDto, botConfig, messages);
                    sparkChatService.chatStream(sparkChatRequest, sseEmitter, sseId, chatReqRecords, false, false);
                } else {
                    ModelConfigResult modelConfig = getModelConfiguration(botConfig.modelId, sseEmitter);
                    if (modelConfig == null) {
                        return;
                    }
                    List<SparkChatRequest.MessageDto> messages = buildMessageList(chatBotReqDto, botConfig.supportContext, botConfig.prompt, modelConfig.maxInputTokens(), chatReqRecords.getId());
                    JSONObject jsonObject = buildPromptChatRequest(modelConfig.llmInfoVo(), messages);
                    promptChatService.chatStream(jsonObject, sseEmitter, sseId, chatReqRecords, false, false);
                }
            }
        } catch (Exception e) {
            log.error("Bot chat error for sseId: {}, chatId: {}, uid: {}", sseId, chatBotReqDto.getChatId(), chatBotReqDto.getUid(), e);
            SseEmitterUtil.completeWithError(sseEmitter, "Failed to process chat request: " + e.getMessage());
        }
    }

    @Override
    public void reAnswerMessageBot(Long requestId, Integer botId, SseEmitter sseEmitter, String sseId) {
        try {
            log.info("Processing re-answer request, sseId: {}, requestId: {}", sseId, requestId);

            ChatReqRecords chatReqRecords = chatDataService.findRequestById(requestId);
            BotConfiguration botConfig = getBotConfiguration(botId);
            ChatBotReqDto chatBotReqDto = new ChatBotReqDto();
            chatBotReqDto.setBotId(botId);
            chatBotReqDto.setChatId(chatReqRecords.getChatId());
            chatBotReqDto.setUid(chatReqRecords.getUid());
            chatBotReqDto.setAsk(chatReqRecords.getMessage());
            chatBotReqDto.setEdit(true);
            int maxInputTokens = this.maxInputTokens;
            if (botConfig.modelId == null) {
                List<SparkChatRequest.MessageDto> messages = buildMessageList(chatBotReqDto, botConfig.supportContext, botConfig.prompt, maxInputTokens, chatReqRecords.getId());
                SparkChatRequest sparkChatRequest = buildSparkChatRequest(chatBotReqDto, botConfig, messages);
                sparkChatService.chatStream(sparkChatRequest, sseEmitter, sseId, chatReqRecords, false, false);
            } else {
                ModelConfigResult modelConfig = getModelConfiguration(botConfig.modelId, sseEmitter);
                if (modelConfig == null) {
                    return;
                }
                List<SparkChatRequest.MessageDto> messages = buildMessageList(chatBotReqDto, botConfig.supportContext, botConfig.prompt, modelConfig.maxInputTokens(), chatReqRecords.getId());
                JSONObject jsonObject = buildPromptChatRequest(modelConfig.llmInfoVo, messages);
                promptChatService.chatStream(jsonObject, sseEmitter, sseId, chatReqRecords, false, false);
            }
        } catch (Exception e) {
            log.error("Bot reAnswer error for sseId: {}, requestId: {}", sseId, requestId, e);
            SseEmitterUtil.completeWithError(sseEmitter, "Failed to process re-answer request: " + e.getMessage());
        }
    }

    @Override
    public void debugChatMessageBot(String text, String prompt, List<String> messages, String uid, String openedTool, String model, Long modelId, List<String> maasDatasetList, SseEmitter sseEmitter, String sseId) {
        int maxInputTokens = this.maxInputTokens;
        List<SparkChatRequest.MessageDto> messageList;

        if (modelId == null) {
            messageList = buildDebugMessageList(text, prompt, messages, maxInputTokens, maasDatasetList);
            SparkChatRequest sparkChatRequest = new SparkChatRequest();
            sparkChatRequest.setModel(model);
            sparkChatRequest.setMessages(messageList);
            sparkChatRequest.setChatId(null);
            sparkChatRequest.setUserId(uid);
            sparkChatRequest.setEnableWebSearch(enableWebSearch(openedTool));
            sparkChatService.chatStream(sparkChatRequest, sseEmitter, sseId, null, false, true);
        } else {
            ModelConfigResult modelConfig = getModelConfiguration(modelId, sseEmitter);
            if (modelConfig == null) {
                return;
            }
            messageList = buildDebugMessageList(text, prompt, messages, modelConfig.maxInputTokens(), maasDatasetList);
            JSONObject jsonObject = buildPromptChatRequest(modelConfig.llmInfoVo(), messageList);
            promptChatService.chatStream(jsonObject, sseEmitter, sseId, null, false, false);
        }
    }

    @Override
    @Transactional
    public ChatListCreateResponse clear(Long chatId, String uid, Integer botId, ChatBotBase botBase) {
        // Check if this is the user's own assistant chat window
        ChatList chatList = chatListDataService.findByUidAndChatId(uid, chatId);
        if (chatList == null || !Objects.equals(chatList.getBotId(), botId)) {
            return new ChatListCreateResponse();
        }
        // Check if this window has chat history, if not, use this blank window directly
        if (chatDataService.countMessagesByChatId(chatId) == 0) {
            ChatListCreateResponse response = new ChatListCreateResponse();
            response.setId(chatId);
            response.setTitle(chatList.getTitle());
            response.setBotId(botId);
            response.setCreateTime(chatList.getCreateTime());
            return response;
        }
        // Delete window
        chatListService.logicDeleteChatList(chatId, uid);
        // Add new window based on botId
        ChatListCreateResponse chatListCreateResponse = chatListService.createRestartChat(uid, "", botId);
        // Add assistant to user's chat_bot_list
        if (!Objects.equals(botBase.getUid(), uid)) {
            botService.addV2Bot(uid, botId);
        }

        return chatListCreateResponse;
    }

    /**
     * Get model configuration and extract max input tokens
     *
     * @param modelId Model ID
     * @param sseEmitter SSE emitter for error handling
     * @return ModelConfigResult containing LLMInfoVo and maxInputTokens, or null if model doesn't exist
     */
    private ModelConfigResult getModelConfiguration(Long modelId, SseEmitter sseEmitter) {
        LLMInfoVo llmInfoVo = (LLMInfoVo) modelService.getDetail(0, modelId, null).data();
        if (llmInfoVo == null) {
            SseEmitterUtil.completeWithError(sseEmitter, "Model is not exist!");
            return null;
        }

        int maxInputTokens = this.maxInputTokens;
        List<CategoryTreeVO> categoryTree = llmInfoVo.getCategoryTree();
        if (!categoryTree.isEmpty()) {
            for (CategoryTreeVO categoryTreeVO : categoryTree) {
                if ("contextLengthTag".equals(categoryTreeVO.getKey())) {
                    maxInputTokens = Integer.parseInt(categoryTreeVO.getName().replace("k", "")) * 1000;
                    break;
                }
            }
        }

        return new ModelConfigResult(llmInfoVo, maxInputTokens);
    }

    /**
     * Get bot configuration
     *
     * @param botId Bot ID
     * @return Returns BotConfiguration object
     */
    private BotConfiguration getBotConfiguration(Integer botId) {
        ChatBotMarket chatBotMarket = chatBotDataService.findMarketBotByBotId(botId);

        if (chatBotMarket != null && ShelfStatusEnum.isOnShelf(chatBotMarket.getBotStatus())) {
            return new BotConfiguration(
                    chatBotMarket.getPrompt(),
                    chatBotMarket.getSupportContext() == 1,
                    chatBotMarket.getModel(),
                    chatBotMarket.getOpenedTool(),
                    chatBotMarket.getVersion(),
                    chatBotMarket.getModelId());
        } else {
            ChatBotBase chatBotBase = chatBotDataService.findById(botId)
                    .orElseThrow(() -> new BusinessException(ResponseEnum.BOT_NOT_EXISTS));
            return new BotConfiguration(
                    chatBotBase.getPrompt(),
                    chatBotBase.getSupportContext() == 1,
                    chatBotBase.getModel(),
                    chatBotBase.getOpenedTool(),
                    chatBotBase.getVersion(),
                    chatBotBase.getModelId());
        }
    }

    /**
     * Create chat request record
     *
     * @param chatBotReqDto Chat bot request data transfer object
     * @return Generated chat request record
     */
    private ChatReqRecords createChatRequest(ChatBotReqDto chatBotReqDto) {
        ChatReqRecords chatReqRecords = new ChatReqRecords();
        chatReqRecords.setChatId(chatBotReqDto.getChatId());
        chatReqRecords.setUid(chatBotReqDto.getUid());
        chatReqRecords.setMessage(chatBotReqDto.getAsk());
        chatReqRecords.setClientType(0);
        chatReqRecords.setCreateTime(LocalDateTime.now());
        chatReqRecords.setUpdateTime(LocalDateTime.now());
        chatReqRecords.setNewContext(1);
        chatDataService.createRequest(chatReqRecords);
        return chatReqRecords;
    }

    /**
     * Get historical conversation messages
     *
     * @param chatBotReqDto Chat bot request data transfer object
     * @param supportContext Whether to support context
     * @param availableTokens Available token count for history messages
     * @return List of historical message data transfer objects
     */
    private List<SparkChatRequest.MessageDto> getHistoryMessages(ChatBotReqDto chatBotReqDto, boolean supportContext, int availableTokens) {
        if (!supportContext || availableTokens <= 0) {
            return new ArrayList<>();
        }

        List<SparkChatRequest.MessageDto> historyMessages = chatHistoryService.getSystemBotHistory(chatBotReqDto.getUid(), chatBotReqDto.getChatId());

        // If it's a re-answer request, need to remove the last Q&A pair
        if (chatBotReqDto.getEdit() && !historyMessages.isEmpty()) {
            historyMessages.removeLast();
            if (!historyMessages.isEmpty()) {
                historyMessages.removeLast();
            }
        }

        if (historyMessages.isEmpty()) {
            return historyMessages;
        }

        List<SparkChatRequest.MessageDto> truncatedHistory = truncateHistoryByTokens(historyMessages, availableTokens);
        log.debug("History message truncation completed - Original count: {}, After truncation: {}",
                historyMessages.size(), truncatedHistory.size());

        return truncatedHistory;
    }

    /**
     * Calculate token statistics for system and user messages
     *
     * @param prompt System prompt text
     * @param userMessage User message text
     * @return TokenStatistics object containing token counts
     */
    private TokenStatistics calculateTokenStatistics(String prompt, String userMessage, int maxInputTokens) {
        int systemTokens = estimateTokenCount(prompt);
        int currentUserTokens = estimateTokenCount(userMessage);
        int reservedTokens = systemTokens + currentUserTokens;
        int availableTokens = Math.max(0, maxInputTokens - reservedTokens);

        log.debug("Token statistics - System message: {}, Current user message: {}, Reserved total: {}, Available for history: {}, Maximum limit: {}",
                systemTokens, currentUserTokens, reservedTokens, availableTokens, maxInputTokens);

        return new TokenStatistics(systemTokens, currentUserTokens, reservedTokens, availableTokens);
    }

    /**
     * Build message list, truncate historical conversation data based on maximum input tokens
     *
     * @param chatBotReqDto Chat bot request data transfer object
     * @param supportContext Whether to support context
     * @param prompt Prompt text
     * @return List of message data transfer objects
     */
    private List<SparkChatRequest.MessageDto> buildMessageList(ChatBotReqDto chatBotReqDto, boolean supportContext, String prompt, int maxInputTokens, Long reqId) {
        List<SparkChatRequest.MessageDto> messageDtoList = new ArrayList<>();

        SparkChatRequest.MessageDto systemMessage = new SparkChatRequest.MessageDto();
        systemMessage.setRole("system");
        systemMessage.setContent(prompt);

        // Finally concatenate the current question
        StringBuilder promptBuilder = new StringBuilder();
        promptBuilder.append(LOOSE_PREFIX_PROMPT);
        promptBuilder.append(prompt);
        List<String> knowledgeList = knowledgeService.getChuncksByBotId(chatBotReqDto.getBotId(), chatBotReqDto.getAsk(), 3);
        // Store retrieved knowledge entries in the database for next round of conversation
        String knowledgeStr = knowledgeList.toString();
        ReqKnowledgeRecords reqKnowledgeRecords = ReqKnowledgeRecords.builder()
                .uid(chatBotReqDto.getUid())
                .chatId(chatBotReqDto.getChatId())
                .reqId(reqId)
                .reqMessage(chatBotReqDto.getAsk())
                .knowledge(knowledgeStr.substring(0, Math.min(3900, knowledgeStr.length())))
                .build();
        reqKnowledgeRecordsDataService.create(reqKnowledgeRecords);
        promptBuilder.insert(promptBuilder.indexOf("[") + 1, knowledgeList);
        promptBuilder.append("\nNext, my input is: {{}}");
        promptBuilder.insert(promptBuilder.indexOf("{{") + 2, chatBotReqDto.getAsk());
        // Need document Q&A, concatenate prompt and dataset to become the real ask
        String ask = promptBuilder.toString();
        SparkChatRequest.MessageDto queryMessage = new SparkChatRequest.MessageDto();
        queryMessage.setRole("user");
        queryMessage.setContent(ask);

        TokenStatistics tokenStats = calculateTokenStatistics(prompt, chatBotReqDto.getAsk(), maxInputTokens);

        messageDtoList.add(systemMessage);

        List<SparkChatRequest.MessageDto> historyMessages = getHistoryMessages(chatBotReqDto, supportContext, tokenStats.availableTokens());
        messageDtoList.addAll(historyMessages);

        messageDtoList.add(queryMessage);

        int totalTokens = messageDtoList.stream()
                .mapToInt(msg -> estimateTokenCount(msg.getContent()))
                .sum();

        log.info("Message list build completed - Total messages: {}, Estimated total tokens: {}, Maximum limit: {}",
                messageDtoList.size(), totalTokens, maxInputTokens);

        return messageDtoList;
    }

    /**
     * Build debug message list with token-based truncation
     *
     * @param text Current user message text
     * @param prompt System prompt text
     * @param messages List of history message strings
     * @param maxInputTokens Maximum input token limit
     * @return List of message data transfer objects with truncation applied
     */
    private List<SparkChatRequest.MessageDto> buildDebugMessageList(String text, String prompt, List<String> messages, int maxInputTokens, List<String> maasDatasetList) {
        List<SparkChatRequest.MessageDto> messageDtoList = new ArrayList<>();

        SparkChatRequest.MessageDto systemMessage = new SparkChatRequest.MessageDto();
        systemMessage.setRole("system");
        systemMessage.setContent(prompt);

        SparkChatRequest.MessageDto queryMessage = new SparkChatRequest.MessageDto();
        queryMessage.setRole("user");
        // Concatenate current question
        StringBuilder askBuilder = new StringBuilder();
        askBuilder.append(LOOSE_PREFIX_PROMPT);
        List<String> askKnowledgeList = knowledgeService.getChuncks(maasDatasetList, text, 3, true);
        askBuilder.insert(askBuilder.indexOf("[") + 1, askKnowledgeList);
        askBuilder.append("\nNext, my input is: {{}}");
        askBuilder.insert(askBuilder.indexOf("{{") + 2, text);
        queryMessage.setContent(askBuilder.toString());

        TokenStatistics tokenStats = calculateTokenStatistics(prompt, text, maxInputTokens);

        messageDtoList.add(systemMessage);

        if (tokenStats.availableTokens() > 0 && !messages.isEmpty()) {
            List<SparkChatRequest.MessageDto> historyMessages = convertStringMessagesToDto(messages);
            // MaaS dataset processing
            for (SparkChatRequest.MessageDto messageDto : historyMessages) {
                // Only concatenate user questions, do not process answers
                if ("user".equals(messageDto.getRole())) {
                    String ask = messageDto.getContent();
                    StringBuilder builder = new StringBuilder();
                    builder.append(LOOSE_PREFIX_PROMPT);
                    List<String> knowledgeList = knowledgeService.getChuncks(maasDatasetList, ask, 3, true);
                    builder.insert(builder.indexOf("[") + 1, knowledgeList);
                    builder.append("\nNext, my input is: {{}}");
                    builder.insert(builder.indexOf("{{") + 2, ask);
                    messageDto.setContent(builder.toString());
                }
            }
            List<SparkChatRequest.MessageDto> truncatedHistory = truncateHistoryByTokens(historyMessages, tokenStats.availableTokens());
            messageDtoList.addAll(truncatedHistory);

            log.debug("Debug history message truncation completed - Original count: {}, After truncation: {}",
                    historyMessages.size(), truncatedHistory.size());
        }

        messageDtoList.add(queryMessage);

        int totalTokens = messageDtoList.stream()
                .mapToInt(msg -> estimateTokenCount(msg.getContent()))
                .sum();

        log.info("Debug message list build completed - Total messages: {}, Estimated total tokens: {}, Maximum limit: {}",
                messageDtoList.size(), totalTokens, maxInputTokens);

        return messageDtoList;
    }

    /**
     * Convert string messages to MessageDto objects with alternating roles
     *
     * @param messages List of message strings
     * @return List of MessageDto objects
     */
    private List<SparkChatRequest.MessageDto> convertStringMessagesToDto(List<String> messages) {
        List<SparkChatRequest.MessageDto> historyMessages = new ArrayList<>();
        for (int i = 0; i < messages.size(); i++) {
            SparkChatRequest.MessageDto messageDto = new SparkChatRequest.MessageDto();
            messageDto.setRole(i % 2 == 0 ? "user" : "assistant");
            messageDto.setContent(messages.get(i));
            historyMessages.add(messageDto);
        }
        return historyMessages;
    }

    /**
     * Truncate history messages based on token limit, trim from front to back
     *
     * @param historyMessages History message list
     * @param maxHistoryTokens Maximum token count for history messages
     * @return Truncated history message list
     */
    private List<SparkChatRequest.MessageDto> truncateHistoryByTokens(List<SparkChatRequest.MessageDto> historyMessages, int maxHistoryTokens) {
        List<SparkChatRequest.MessageDto> result = new ArrayList<>();
        int currentTokens = 0;

        // Traverse from back to front (keep the newest conversations)
        for (int i = historyMessages.size() - 1; i >= 0; i--) {
            SparkChatRequest.MessageDto message = historyMessages.get(i);
            int messageTokens = estimateTokenCount(message.getContent());

            // Check if token limit is exceeded
            if (currentTokens + messageTokens > maxHistoryTokens) {
                log.debug("History message truncation - Stopped at index {}, current tokens: {}, message tokens: {}, limit: {}",
                        i, currentTokens, messageTokens, maxHistoryTokens);
                break;
            }

            currentTokens += messageTokens;
            result.addFirst(message); // Add to the beginning of the list, maintain time order
        }

        return result;
    }

    /**
     * Estimate token count for text (simple estimation: Chinese characters * 1.5, English words * 1.3)
     *
     * @param text Text content
     * @return Estimated token count
     */
    private int estimateTokenCount(String text) {
        if (StringUtils.isBlank(text)) {
            return 0;
        }

        // Simple estimation method:
        // - Chinese characters calculated as 1.5 tokens
        // - English characters calculated as 1.3 tokens (considering word segmentation)
        int chineseChars = 0;
        int englishChars = 0;

        for (char c : text.toCharArray()) {
            if (c >= 0x4e00 && c <= 0x9fff) {
                // Chinese character range
                chineseChars++;
            } else if (Character.isLetterOrDigit(c)) {
                // English characters and numbers
                englishChars++;
            }
        }

        int estimatedTokens = (int) (chineseChars * 1.5 + englishChars * 1.3);

        log.trace("Token estimation - Chinese characters: {}, English characters: {}, Estimated tokens: {}",
                chineseChars, englishChars, estimatedTokens);

        return Math.max(estimatedTokens, 1); // At least 1 token
    }

    /**
     * Utility method to build SparkChatRequest object
     *
     * @param chatBotReqDto Chat bot request data transfer object
     * @param botConfig Bot configuration
     * @param messages List of message data transfer objects
     * @return Built SparkChatRequest object
     */
    private SparkChatRequest buildSparkChatRequest(ChatBotReqDto chatBotReqDto, BotConfiguration botConfig, List<SparkChatRequest.MessageDto> messages) {
        SparkChatRequest sparkChatRequest = new SparkChatRequest();
        sparkChatRequest.setModel(botConfig.model);
        sparkChatRequest.setMessages(messages);
        sparkChatRequest.setChatId(chatBotReqDto.getChatId().toString());
        sparkChatRequest.setUserId(chatBotReqDto.getUid().toString());
        sparkChatRequest.setEnableWebSearch(enableWebSearch(botConfig.openedTool));
        return sparkChatRequest;
    }

    private JSONObject buildPromptChatRequest(LLMInfoVo llmInfoVo, List<SparkChatRequest.MessageDto> messages) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("url", llmInfoVo.getUrl());
        jsonObject.put("apiKey", llmInfoVo.getApiKey());
        jsonObject.put("model", llmInfoVo.getDomain());
        jsonObject.put("messages", messages);
        // Convert Object to JSONArray type
        Object configObj = llmInfoVo.getConfig();
        JSONArray config = null;
        if (configObj instanceof JSONArray) {
            config = (JSONArray) configObj;
        } else if (configObj instanceof String) {
            try {
                config = JSON.parseArray((String) configObj);
            } catch (Exception e) {
                log.warn("Failed to parse config string to JSONArray: {}", configObj, e);
                config = new JSONArray();
            }
        } else if (configObj != null) {
            try {
                config = (JSONArray) JSON.toJSON(configObj);
            } catch (Exception e) {
                log.warn("Failed to convert config object to JSONArray: {}", configObj, e);
                config = new JSONArray();
            }
        } else {
            config = new JSONArray();
        }
        for (Object o : config) {
            if (o instanceof JSONObject configItem) {
                String key = configItem.getString("key");
                Object defaultValue = configItem.get("default");
                if (key != null) {
                    jsonObject.put(key, defaultValue);
                }
            }
        }
        jsonObject.put("config", config);
        return jsonObject;
    }

    private record BotConfiguration(String prompt, boolean supportContext, String model, String openedTool, Integer version, Long modelId) {}

    private record TokenStatistics(int systemTokens, int currentUserTokens, int reservedTokens, int availableTokens) {}

    private record ModelConfigResult(LLMInfoVo llmInfoVo, int maxInputTokens) {}

    /**
     * Determine whether to enable web search
     */
    private boolean enableWebSearch(String tool) {
        if (StringUtils.isBlank(tool)) {
            return false;
        }
        List<String> tools = CollectionUtil.newArrayList(Objects.requireNonNull(tool).split(","));
        return tools.contains("ifly_search");
    }
}
