package com.iflytek.astron.console.hub.service.publish.impl;

import com.iflytek.astron.console.commons.constant.ResponseEnum;
import com.iflytek.astron.console.commons.dto.bot.ChatBotApi;
import com.iflytek.astron.console.commons.entity.bot.ChatBotBase;
import com.iflytek.astron.console.commons.entity.bot.DatasetInfo;
import com.iflytek.astron.console.commons.entity.bot.UserLangChainInfo;
import com.iflytek.astron.console.commons.entity.user.AppMst;
import com.iflytek.astron.console.commons.exception.BusinessException;
import com.iflytek.astron.console.commons.mapper.bot.BotDatasetMapper;
import com.iflytek.astron.console.commons.service.bot.ChatBotDataService;
import com.iflytek.astron.console.commons.service.data.UserLangChainDataService;
import com.iflytek.astron.console.commons.service.user.AppMstService;
import com.iflytek.astron.console.commons.util.MaasUtil;
import com.iflytek.astron.console.commons.util.RequestContextUtil;
import com.iflytek.astron.console.commons.util.space.SpaceInfoUtil;
import com.iflytek.astron.console.hub.dto.publish.AppListDTO;
import com.iflytek.astron.console.hub.dto.publish.BotApiInfoDTO;
import com.iflytek.astron.console.hub.dto.publish.CreateAppVo;
import com.iflytek.astron.console.hub.dto.publish.CreateBotApiVo;
import com.iflytek.astron.console.hub.dto.user.TenantAuth;
import com.iflytek.astron.console.hub.enums.BotVersionEnum;
import com.iflytek.astron.console.hub.service.chat.ChatBotApiService;
import com.iflytek.astron.console.hub.service.publish.PublishApiService;
import com.iflytek.astron.console.hub.service.publish.ReleaseManageClientService;
import com.iflytek.astron.console.hub.service.publish.TenantService;
import com.iflytek.astron.console.toolkit.util.RedisUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * @author yun-zhi-ztl
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PublishApiServiceImpl implements PublishApiService {

    @Autowired
    private AppMstService appMstService;

    @Autowired
    private TenantService tenantService;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private ChatBotDataService chatBotDataService;

    @Autowired
    private ChatBotApiService chatBotApiService;

    @Autowired
    private BotDatasetMapper botDatasetMapper;

    @Autowired
    private UserLangChainDataService userLangChainDataService;

    @Autowired
    private MaasUtil maasUtil;

    @Autowired
    private ReleaseManageClientService releaseManageClientService;

    private static final String PUBLISH_API = "publish_api";

    private static final String BOT_API_CBM_BASE_URL = "ws(s)://spark-openapi.cn-huabei-1.xf-yun.com";

    private static final String BOT_API_MASS_BASE_URL = "http(s)://xingchen-api.xf-yun.com";

    @Override
    public Boolean createApp(CreateAppVo createAppVo) {
        String uid = RequestContextUtil.getUID();

        if (appMstService.exist(createAppVo.getAppName())) {
            throw new BusinessException(ResponseEnum.USER_APP_NAME_REPEAT);
        }

        String appId = tenantService.createApp(uid, createAppVo.getAppName(), createAppVo.getAppDescribe());
        if (StringUtils.isBlank(appId)) {
            throw new BusinessException(ResponseEnum.USER_APP_ID_CREATE_ERROR);
        }
        TenantAuth tenantAuth = tenantService.getAppDetail(appId);
        if (Objects.isNull(tenantAuth)) {
            throw new BusinessException(ResponseEnum.USER_APP_ID_CREATE_ERROR);
        }
        appMstService.insert(uid, appId, createAppVo.getAppName(), createAppVo.getAppDescribe(), tenantAuth.getApiKey(), tenantAuth.getApiSecret());

        return true;
    }

    @Override
    public List<AppListDTO> getAppList() {
        String uid = RequestContextUtil.getUID();
        return appMstService.getAppListByUid(uid)
                .stream()
                .map(appMst -> new AppListDTO(appMst.getAppId(), appMst.getAppName(), appMst.getAppDescribe(),
                        appMst.getAppKey(), appMst.getAppSecret(), appMst.getCreateTime()))
                .collect(Collectors.toList());
    }

    @Override
    public BotApiInfoDTO createBotApi(CreateBotApiVo createBotApiVo, HttpServletRequest request) {
        String uid = RequestContextUtil.getUID();
        String uuid = UUID.randomUUID().toString();
        // Only the space creator can publish APIs
        if (!uid.equals(SpaceInfoUtil.getUidByCurrentSpaceId())) {
            throw new BusinessException(ResponseEnum.USER_NO_APPROVEL);
        }

        ChatBotBase botBase = chatBotDataService.findOne(uid, createBotApiVo.getBotId());
        AppMst appMst = appMstService.getByAppId(uid, createBotApiVo.getAppId());
        if (Objects.isNull(botBase) || Objects.isNull(appMst)) {
            throw new BusinessException(ResponseEnum.USER_APP_ID_NOT_EXISTE);
        }

        if (!redisUtil.tryLock(PUBLISH_API + uid, 3000, uuid)) {
            throw new BusinessException(ResponseEnum.BOT_API_CREATE_LIMIT_ERROR);
        }
        try {
            if (botBase.getVersion().equals(BotVersionEnum.BASE_BOT.getVersion())) {
                return createBaseBotApi(uid, appMst, botBase);
            } else if (botBase.getVersion().equals(BotVersionEnum.WORKFLOW.getVersion())) {
                return createMaasApi(uid, appMst, botBase, request);
            } else {
                throw new BusinessException(ResponseEnum.BOT_TYPE_NOT_EXISTS);
            }
        } catch (Exception e) {
            log.error("PublishApiServiceImpl.createBotApi : create Bot api error, request: {}", createBotApiVo, e);
            throw new BusinessException(ResponseEnum.BOT_API_CREATE_ERROR);
        } finally {
            redisUtil.unlock(PUBLISH_API + uid, uuid);
        }

    }

    @Override
    public BotApiInfoDTO getApiInfo(Long botId) {
        String uid = RequestContextUtil.getUID();
        // Only the space creator can publish APIs
        if (!uid.equals(SpaceInfoUtil.getUidByCurrentSpaceId())) {
            throw new BusinessException(ResponseEnum.USER_NO_APPROVEL);
        }
        ChatBotBase botBase = chatBotDataService.findOne(uid, botId);
        if (Objects.isNull(botBase)) {
            throw new BusinessException(ResponseEnum.BOT_NOT_EXISTS);
        }
        ChatBotApi botApi = chatBotApiService.getOneByUidAndBotId(uid, botId);
        if (Objects.isNull(botApi)) {
            throw new BusinessException(ResponseEnum.USER_APP_ID_NOT_EXISTE);
        }
        AppMst appMst = appMstService.getByAppId(uid, botApi.getAppId());
        if (Objects.isNull(appMst)) {
            throw new BusinessException(ResponseEnum.USER_APP_ID_NOT_EXISTE);
        }
        String serviceUrlHost = botBase.getVersion() == 1 ? BOT_API_CBM_BASE_URL : BOT_API_MASS_BASE_URL;
        return BotApiInfoDTO.builder()
                .botId(Math.toIntExact(botId))
                .botName(botBase.getBotName())
                .appName(appMst.getAppName())
                .appId(appMst.getAppId())
                .appKey(appMst.getAppKey())
                .appSecret(appMst.getAppSecret())
                .serviceUrl(serviceUrlHost + "/workflow/v1/chat/completions")
                .flowId(botApi.getAssistantId())
                .build();
    }

    private BotApiInfoDTO createMaasApi(String uid, AppMst appMst, ChatBotBase botBase, HttpServletRequest request) {
        Long spaceId = SpaceInfoUtil.getSpaceId();
        Integer botId = botBase.getId();
        List<UserLangChainInfo> userLangChainInfoList = userLangChainDataService.findListByBotId(botId);
        if (Objects.isNull(userLangChainInfoList) || userLangChainInfoList.isEmpty()) {
            log.error("----- No assistant protocol found, uid: {}, botId: {}", uid, botId);
            throw new BusinessException(ResponseEnum.BOT_API_CREATE_ERROR);
        }

        UserLangChainInfo userLangChainInfo = userLangChainInfoList.get(0);
        String flowId = userLangChainInfo.getFlowId();
        // Synchronize with Maas service
        String versionName = releaseManageClientService.getVersionNameByBotId(Long.valueOf(botId), spaceId, request);
        maasUtil.createApi(flowId, appMst.getAppId(), versionName);

        releaseManageClientService.releaseBotApi(botId, flowId, versionName, spaceId, request);

        ChatBotApi chatBotApi = ChatBotApi.builder()
                .uid(uid)
                .botId(botId)
                .assistantId(flowId)
                .appId(appMst.getAppId())
                .apiSecret(appMst.getAppSecret())
                .apiKey(appMst.getAppKey())
                .prompt("")
                .pluginId("")
                .embeddingId("")
                .apiPath("/workflow/v1/chat/completions")
                .description(botBase.getBotName())
                .build();

        chatBotApiService.insertOrUpdate(chatBotApi);

        return BotApiInfoDTO.builder()
                .botId(botId)
                .botName(botBase.getBotName())
                .appName(appMst.getAppName())
                .appId(appMst.getAppId())
                .appKey(appMst.getAppKey())
                .appSecret(appMst.getAppSecret())
                .serviceUrl(BOT_API_MASS_BASE_URL + "/workflow/v1/chat/completions")
                .flowId(flowId)
                .build();
    }

    private BotApiInfoDTO createBaseBotApi(String uid, AppMst appMst, ChatBotBase botBase) throws IOException {
        Integer botId = botBase.getId();
        String prompt = botBase.getPrompt();
        Long count = chatBotApiService.selectCount(botId);
        if (count != null && count.intValue() >= 100) {
            throw new BusinessException(ResponseEnum.BOT_API_CREATE_ERROR);
        }

        List<DatasetInfo> datasetInfos = botDatasetMapper.selectDatasetListByBotId(botId);
        List<Long> datasetIdList = datasetInfos.stream().map(DatasetInfo::getId).toList();
        String embeddingIds = StringUtils.defaultString(datasetIdList.stream().map(Objects::toString).collect(Collectors.joining(",")), "");

        ChatBotApi chatBotApi = ChatBotApi.builder()
                .uid(uid)
                .botId(botId)
                .appId(appMst.getAppId())
                .apiSecret(appMst.getAppSecret())
                .apiKey(appMst.getAppKey())
                .prompt(prompt)
                .pluginId("")
                .embeddingId(embeddingIds)
                .apiPath(null)
                .description(botBase.getBotName())
                .build();

        chatBotApiService.insertOrUpdate(chatBotApi);

        // TODO: capability authorization

        return BotApiInfoDTO.builder()
                .botId(botId)
                .botName(botBase.getBotName())
                .appName(appMst.getAppName())
                .appId(appMst.getAppId())
                .appKey(appMst.getAppKey())
                .appSecret(appMst.getAppSecret())
                .serviceUrl(BOT_API_CBM_BASE_URL)
                .flowId(null)
                .build();
    }
}
