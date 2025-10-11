SELECT 'astron_console DATABASE initialization started' AS '';
CREATE DATABASE IF NOT EXISTS astron_console;

USE astron_console;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for agent_apply_record
-- ----------------------------
DROP TABLE IF EXISTS `agent_apply_record`;
CREATE TABLE `agent_apply_record`
(
    `id`             bigint NOT NULL AUTO_INCREMENT,
    `enterprise_id`  bigint       DEFAULT NULL COMMENT 'Enterprise team ID',
    `space_id`       bigint       DEFAULT NULL COMMENT 'Space ID',
    `apply_uid`      varchar(128) DEFAULT NULL COMMENT 'Applicant UID',
    `apply_nickname` varchar(64)  DEFAULT NULL COMMENT 'Applicant nickname',
    `apply_time`     datetime     DEFAULT NULL COMMENT 'Application time',
    `status`         tinyint      DEFAULT NULL COMMENT 'Application status: 1 pending confirmation, 2 approved, 3 rejected',
    `audit_time`     datetime     DEFAULT NULL COMMENT 'Processing time',
    `audit_uid`      varchar(128) DEFAULT NULL COMMENT 'Processor UID',
    `create_time`    datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`    datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY              `enterprise_id_key` (`enterprise_id`) USING BTREE,
    KEY              `space_id_key` (`space_id`) USING BTREE,
    KEY              `apply_uid_key` (`apply_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Application records for joining space/enterprise';

-- ----------------------------
-- Table structure for agent_enterprise
-- ----------------------------
DROP TABLE IF EXISTS `agent_enterprise`;
CREATE TABLE `agent_enterprise`
(
    `id`           bigint        NOT NULL AUTO_INCREMENT,
    `uid`          varchar(128)  DEFAULT NULL COMMENT 'Creator ID',
    `name`         varchar(50)   DEFAULT NULL COMMENT 'Team name',
    `logo_url`     varchar(1024) DEFAULT NULL COMMENT 'logoURL',
    `avatar_url`   varchar(1024) NOT NULL COMMENT 'Avatar URL',
    `org_id`       bigint        DEFAULT NULL COMMENT 'Organization ID',
    `service_type` tinyint       DEFAULT NULL COMMENT 'Service type: 1 team, 2 enterprise',
    `create_time`  datetime      DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `expire_time`  datetime      DEFAULT NULL COMMENT 'Expiration time',
    `update_time`  datetime      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `deleted`      tinyint       DEFAULT '0' COMMENT 'Is deleted: 0 no, 1 yes',
    PRIMARY KEY (`id`),
    KEY            `enterprise_name_key` (`name`) USING BTREE,
    KEY            `enterprise_uid_key` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Enterprise team';

-- ----------------------------
-- Table structure for agent_enterprise_permission
-- ----------------------------
DROP TABLE IF EXISTS `agent_enterprise_permission`;
CREATE TABLE `agent_enterprise_permission`
(
    `id`                bigint  NOT NULL AUTO_INCREMENT,
    `module`            varchar(50)  DEFAULT NULL COMMENT 'Permission module',
    `description`       varchar(255) DEFAULT NULL COMMENT 'Description',
    `permission_key`    varchar(64)  DEFAULT NULL COMMENT 'Permission unique identifier',
    `officer`           tinyint NOT NULL COMMENT 'Super administrator (has permission): 1 yes, 0 no',
    `governor`          tinyint NOT NULL COMMENT 'Administrator (has permission): 1 yes, 0 no',
    `staff`             tinyint NOT NULL COMMENT 'Member (has permission): 1 yes, 0 no',
    `available_expired` tinyint NOT NULL COMMENT 'Available when expired: 1 yes, 0 no',
    `create_time`       datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`       datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY                 `key_uni_key` (`permission_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Enterprise team role permission configuration';

-- ----------------------------
-- Records of agent_enterprise_permission
-- ----------------------------
BEGIN;
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (1, 'Team/Enterprise level space management', 'Create space', 'SpaceController_createCorporateSpace_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (3, 'Team/Enterprise level space management', 'Delete space', 'SpaceController_deleteCorporateSpace_DELETE', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (5, 'Team/Enterprise info settings (Team management)', 'Set team/enterprise name', 'EnterpriseController_updateName_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (7, 'Team/Enterprise level space management', 'Edit space info', 'SpaceController_updateCorporateSpace_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (9, 'Team/Enterprise info view', 'View team/enterprise details', 'EnterpriseController_detail_GET', 1, 1, 1, 1,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (13, 'Team/Enterprise level space management', 'Enterprise all spaces', 'SpaceController_corporateList_GET', 1, 1, 1, 1,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (15, 'Team/Enterprise level space management', 'Enterprise my spaces', 'SpaceController_corporateJoinList_GET', 1, 1, 1, 1,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (17, 'Team/Enterprise Info Settings (Team Management)', 'Set team/enterprise LOGO', 'EnterpriseController_updateLogo_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (19, 'Team/Enterprise Info Settings (Team Management)', 'Set team/enterprise avatar', 'EnterpriseController_updateAvatar_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (21, 'Invitation Management', 'Enterprise team invitation list', 'InviteRecordController_enterpriseInviteList_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (23, 'Enterprise Team User Management', 'Team user list', 'EnterpriseUserController_page_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (25, 'Enterprise Team User Management', 'Modify user role', 'EnterpriseUserController_updateRole_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (27, 'Enterprise Team User Management', 'Remove user', 'EnterpriseUserController_remove_DELETE', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (29, 'Invitation Management', 'Invite to join enterprise team', 'InviteRecordController_enterpriseInvite_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (31, 'Invitation Management', 'Enterprise invitation search user', 'InviteRecordController_enterpriseSearchUser_GET', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (33, 'Invitation Management', 'Revoke enterprise invitation', 'InviteRecordController_revokeEnterpriseInvite_POST', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (35, 'Application Management', 'Apply to join enterprise space', 'ApplyRecordController_joinEnterpriseSpace_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (37, 'Enterprise Team User Management', 'Quit enterprise team', 'EnterpriseUserController_quitEnterprise_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (39, 'Enterprise Team User Management', 'Get user limits', 'EnterpriseUserController_getUserLimit_GET', 1, 1, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (41, 'User Rights Query', 'Get team edition non-model resources', 'UserAuthController_getDetailByEnterpriseId_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (43, 'User Rights Query', 'Get team edition package', 'UserAuthController_getTeamOrderMeta_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (45, 'User Rights Query', 'Get team edition model resources', 'UserAuthController_getModelDetailByEnterpriseId_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (47, 'Team/Enterprise Level Space Management', 'Enterprise total space count', 'SpaceController_corporateCount_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (49, 'User Rights Query', 'Get team edition model resources by app ID',
        'UserAuthController_getModelDetailByEnterpriseIdAndAppId_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_enterprise_permission` (`id`, `module`, `description`, `permission_key`, `officer`, `governor`,
                                           `staff`, `available_expired`, `create_time`, `update_time`)
VALUES (51, 'Invitation Management', 'Enterprise invitation batch search user', 'InviteRecordController_enterpriseBatchSearchUser_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `astron_console`.`agent_enterprise_permission` (`module`, `description`, `permission_key`, `officer`, `governor`, `staff`, `available_expired`, `create_time`, `update_time`) VALUES ('邀请管理', '企业邀请批量搜索用户', 'InviteRecordController_enterpriseBatchSearchUsername_POST', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `astron_console`.`agent_enterprise_permission` (`module`, `description`, `permission_key`, `officer`, `governor`, `staff`, `available_expired`, `create_time`, `update_time`) VALUES ('邀请管理', '企业邀请搜索用户', 'InviteRecordController_enterpriseSearchUsername_GET', 1, 1, 0, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
COMMIT;

-- ----------------------------
-- Table structure for agent_enterprise_user
-- ----------------------------
DROP TABLE IF EXISTS `agent_enterprise_user`;
CREATE TABLE `agent_enterprise_user`
(
    `id`            bigint NOT NULL AUTO_INCREMENT,
    `enterprise_id` bigint       DEFAULT NULL COMMENT 'Team ID',
    `uid`           varchar(128) DEFAULT NULL COMMENT 'User ID',
    `nickname`      varchar(64)  DEFAULT NULL COMMENT 'User nickname',
    `role`          tinyint      DEFAULT NULL COMMENT 'Role: 1 super administrator, 2 administrator, 3 member',
    `create_time`   datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `enterprise_id_uid_uni_key` (`enterprise_id`,`uid`) USING BTREE,
    KEY             `enterprise_user_uid_key` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Enterprise team users';

-- ----------------------------
-- Table structure for agent_invite_record
-- ----------------------------
DROP TABLE IF EXISTS `agent_invite_record`;
CREATE TABLE `agent_invite_record`
(
    `id`               bigint NOT NULL AUTO_INCREMENT,
    `type`             tinyint      DEFAULT NULL COMMENT 'Invitation type: 1 space, 2 team',
    `space_id`         bigint       DEFAULT NULL COMMENT 'Space ID',
    `enterprise_id`    bigint       DEFAULT NULL COMMENT 'Team ID',
    `invitee_uid`      varchar(128) DEFAULT NULL COMMENT 'Invitee UID',
    `role`             tinyint      DEFAULT NULL COMMENT 'Join role: 1 administrator, 2 member',
    `invitee_nickname` varchar(64)  DEFAULT NULL COMMENT 'Invitee nickname',
    `inviter_uid`      varchar(128) DEFAULT NULL COMMENT 'Inviter UID',
    `expire_time`      datetime     DEFAULT NULL COMMENT 'Expiration time',
    `status`           tinyint      DEFAULT NULL COMMENT 'Status: 1 initial, 2 rejected, 3 joined, 4 revoked, 5 expired',
    `create_time`      datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`      datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY                `invitee_id_key` (`invitee_uid`) USING BTREE,
    KEY                `space_id_key` (`space_id`),
    KEY                `enterprise_id_key` (`enterprise_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Invitation records';

-- ----------------------------
-- Table structure for agent_share_record
-- ----------------------------
DROP TABLE IF EXISTS `agent_share_record`;
CREATE TABLE `agent_share_record`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) NOT NULL COMMENT 'User ID',
    `base_id`     bigint       NOT NULL COMMENT 'Primary key ID of shared entity',
    `share_key`   varchar(64) DEFAULT '' COMMENT 'Unique identifier for sharing',
    `share_type`  tinyint     DEFAULT '0' COMMENT 'Category: 0 share assistant',
    `is_act`      tinyint     DEFAULT '1' COMMENT 'Is effective: 0 invalid, 1 valid',
    `create_time` datetime    DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY           `idx_uid` (`uid`),
    KEY           `idx_base_id` (`base_id`),
    KEY           `idx_share_key` (`share_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Agent sharing record table';

-- ----------------------------
-- Table structure for agent_space
-- ----------------------------
DROP TABLE IF EXISTS `agent_space`;
CREATE TABLE `agent_space`
(
    `id`            bigint      NOT NULL AUTO_INCREMENT,
    `name`          varchar(50) NOT NULL COMMENT 'Space name',
    `description`   varchar(2000) DEFAULT NULL COMMENT 'Description',
    `avatar_url`    varchar(1024) DEFAULT NULL COMMENT 'Avatar URL',
    `uid`           varchar(128)  DEFAULT NULL COMMENT 'Creator ID',
    `enterprise_id` bigint        DEFAULT NULL COMMENT 'Team ID',
    `type`          tinyint       DEFAULT NULL COMMENT 'Type: 1 free version, 2 professional version, 3 team version, 4 enterprise version',
    `create_time`   datetime      DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `deleted`       tinyint       DEFAULT '0' COMMENT 'Is deleted: 0 no, 1 yes',
    PRIMARY KEY (`id`),
    KEY             `uid_key` (`uid`),
    KEY             `enterprise_id_key` (`enterprise_id`) USING BTREE,
    KEY             `space_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workspace';

-- ----------------------------
-- Table structure for agent_space_permission
-- ----------------------------
DROP TABLE IF EXISTS `agent_space_permission`;
CREATE TABLE `agent_space_permission`
(
    `id`                bigint  NOT NULL AUTO_INCREMENT,
    `module`            varchar(50)  DEFAULT NULL COMMENT 'Permission module',
    `point`             varchar(50)  DEFAULT NULL COMMENT 'Permission point',
    `description`       varchar(255) DEFAULT NULL COMMENT 'Description',
    `permission_key`    varchar(64)  DEFAULT NULL COMMENT 'Permission unique identifier',
    `owner`             tinyint NOT NULL COMMENT 'Owner (has permission): 1 yes, 0 no',
    `admin`             tinyint NOT NULL COMMENT 'Administrator (has permission): 1 yes, 0 no',
    `member`            tinyint NOT NULL COMMENT 'Member (has permission): 1 yes, 0 no',
    `available_expired` tinyint NOT NULL COMMENT 'Available when expired: 1 yes, 0 no',
    `create_time`       datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`       datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `key_uni_key` (`permission_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workspace role permission configuration';

-- ----------------------------
-- Records of agent_space_permission
-- ----------------------------
BEGIN;
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (1, 'Bot Management', 'testPoint', '', 'ChatBotMarketController_getCreatedList_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (3, 'Bot Management', 'testPoint', '', 'ChatBotMarketController_botDetail_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (5, 'Bot Management', 'testPoint', '', 'ChatBotController_insert_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (7, 'Bot Management', 'testPoint', '', 'WorkflowController_list_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (9, 'Publishing Management', 'testPoint', '', 'ChatBotMarketController_takeoffBot_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (11, 'Bot Management', 'testPoint', '', 'AgentController_getShareKey_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (13, 'Bot Management', 'testPoint', '', 'ChatBotMarketController_updateMarketBot_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (15, 'Bot Management', 'testPoint', '', 'ChatBotController_update_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (17, 'Bot Management', 'testPoint', '', 'ChatBotController_generateAvatar_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (19, 'Bot Management', 'testPoint', '', 'BotV2Controller_copyBot2_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (21, 'Publishing Management', 'testPoint', '', 'ChatBotMarketController_upToBotMarket_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (23, 'Bot Management', 'testPoint', '', 'ChatBotController_delete_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (25, 'Space Management', 'Get space details', '', 'SpaceController_detail_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (27, 'Space Management', 'Edit space information', '', 'SpaceController_updatePersonalSpace_POST', 1, 0, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (29, 'Prompt Management', 'testPoint', '', 'PromptManageController_createPrompt_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (31, 'Prompt Management', 'testPoint', '', 'PromptManageController_deletePrompt_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (33, 'Prompt Management', 'testPoint', '', 'PromptManageController_listPrompt_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (35, 'Prompt Management', 'testPoint', '', 'PromptManageController_savePrompt_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (37, 'Prompt Management', 'testPoint', '', 'PromptManageController_createPromptGroup_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (39, 'Prompt Management', 'testPoint', '', 'PromptManageController_getPromptVersionDetail_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (41, 'Prompt Management', 'testPoint', '', 'PromptManageController_commitPrompt_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (43, 'Prompt Management', 'testPoint', '', 'PromptManageController_deletePromptVersion_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (45, 'Prompt Management', 'testPoint', '', 'PromptManageController_revertPrompt_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (47, 'Prompt Management', 'testPoint', '', 'PromptManageController_listPromptVersion_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (49, 'Prompt Management', 'testPoint', '', 'PromptManageController_getPromptDetail_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (51, 'Prompt Management', 'testPoint', '', 'PromptManageController_renamePrompt_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (53, 'Prompt Management', 'testPoint', '', 'ChatMessageController_promptDebug_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (55, 'Bot Management', 'testPoint', '', 'BotDashboardController_details_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (57, 'Publish Management', 'testPoint', '', 'BotV2Controller_botV2Info_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (59, 'Publish Management', 'testPoint', '', 'BotV2Controller_massPublish_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (61, 'Publish Management', 'testPoint', '', 'BotOffiaccountController_getAuthUrl_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (63, 'Publish Management', 'testPoint', '', 'MCPController_publishMCP_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (65, 'test', 'test', '', '', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (71, 'Bot Management', 'testPoint', '', 'ChatMessageController_botDebug_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (73, 'Invite Management', '', '', 'InviteRecordController_spaceInviteList_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (75, 'Application Management', '', '', 'ApplyRecordController_page_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (77, 'Application Management', '', '', 'ApplyRecordController_agreeEnterpriseSpace_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (79, 'Invite Management', '', '', 'InviteRecordController_spaceSearchUser_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (81, 'Space User Management', '', '', 'SpaceUserController_enterpriseAdd_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (83, 'Space User Management', '', '', 'SpaceUserController_updateRole_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (85, 'Application Management', '', '', 'ApplyRecordController_refuseEnterpriseSpace_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (87, 'Space User Management', '', '', 'SpaceUserController_remove_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (89, 'Invite Management', '', '', 'InviteRecordController_spaceInvite_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (91, 'Space User Management', '', '', 'SpaceUserController_page_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (93, 'Invite Management', '', '', 'InviteRecordController_revokeSpaceInvite_POST', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (95, 'Space User Management', '', '', 'SpaceUserController_transferSpace_POST', 1, 0, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (97, 'Space User Management', '', '', 'SpaceUserController_listSpaceMember_GET', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (99, 'Knowledge Base', 'Create Knowledge Base', '', 'RepoController_createRepo_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (101, 'Evaluation Dimension', 'Delete Evaluation Dimension', '', 'EvalDimensionController_deleteDimension_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (103, '', '', '', 'DataBaseController_deleteTable_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (105, 'Evaluation Scenario', 'Edit Evaluation Scenario', '', 'EvalDimensionController_updateScene_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (107, 'Workflow', 'Publish Workflow', '', 'WorkflowController_publish_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (109, '', '', '', 'DataBaseController_createDbTable_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (111, '', '', '', 'ToolBoxController_favorite_GET', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (113, 'Knowledge', 'createKnowledge', '', 'KnowledgeController_createKnowledge_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (115, 'Evaluation Task Retry', 'Evaluation Task Retry', '', 'EvalTaskController_again_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (117, 'Evaluation Object Scenario', 'Evaluation Object', '', 'EvalTaskController_objectList_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (119, 'Evaluation Task Append - Only for Completed Tasks', 'Evaluation Task Append - Only for Completed Tasks', '',
        'EvalTaskController_getEvalReport_GET', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (121, '', '', '', 'ToolBoxController_createTool_POST', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (123, 'Evaluation Task Retry', 'Evaluation Task Retry', '', 'EvalTaskController_stopProgress_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (125, '', '', '', 'DataBaseController_getDbTableInfoList_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (127, 'Evaluation Task Delete', 'Evaluation Task Delete', '', 'EvalTaskController_delete_DELETE', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (129, '', '', '', 'DataBaseController_getDatabaseInfo_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (131, 'Knowledge Base', 'Knowledge Base Simple List', '', 'RepoController_list_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (133, '', '', '', 'DataBaseController_getDbTableList_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (135, 'Create Evaluation Task', 'Create Evaluation Task', '', 'EvalTaskController_create_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (137, '', '', '', 'ToolBoxController_getToolDefaultIcon_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (139, 'Evaluation Dimension', 'Edit Evaluation Dimension', '', 'EvalDimensionController_updateDimension_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (141, '', '', '', 'DataBaseController_copyTable_GET', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (143, 'Evaluation Task Temporary Storage Echo', 'Evaluation Task Temporary Storage Echo', '', 'EvalTaskController_storeTemporary_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (145, 'Model Management', 'Add/Edit Model', '', 'ModelController_create_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (147, 'Knowledge Base', 'Knowledge Base List', '', 'RepoController_listRepos_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (149, '', '', '', 'DataBaseController_deleteDatabase_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (151, 'Knowledge Base', 'Knowledge Base Details', '', 'RepoController_detail_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (153, '', '', '', 'DataBaseController_copyDatabase_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (155, '', '', '', 'ToolBoxController_listToolSquare_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (157, 'Create Evaluation Task Temporary Storage', 'Create Evaluation Task Temporary Storage', '', 'EvalTaskController_storeTemporary_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (159, 'Evaluation Scenario', 'Delete Evaluation Scenario', '', 'EvalDimensionController_deleteScene_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (161, '', '', '', 'DataBaseController_createDatabase_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (163, 'Evaluation Task Append Data Echo', 'Evaluation Task Append Data Echo', '', 'EvalTaskController_appendFeedback_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (165, 'Knowledge Base', 'Update Knowledge Base', '', 'RepoController_updateRepo_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (167, 'Knowledge Base', 'Delete Knowledge Base', '', 'RepoController_deleteRepo_DELETE', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (169, '', '', '', 'DataBaseController_selectDatabase_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (171, 'Evaluation Dimension', 'Evaluation Dimension Paged List', '', 'EvalDimensionController_getDimensionPageList_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (173, 'Evaluation Dimension', 'Add Evaluation Dimension', '', 'EvalDimensionController_addScene_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (175, 'Evaluation Set', 'Evaluation Set List', '', 'EvalSetController_list_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (177, '', '', '', 'DataBaseController_importTableData_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (179, '', '', '', 'DataBaseController_updateTable_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (181, '', '', '', 'ToolBoxController_deleteTool_DELETE', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (183, 'Evaluation Set', 'Delete Evaluation Set', '', 'EvalSetController_delete_DELETE', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (185, '', '', '', 'ToolBoxController_listTools_GET', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (187, 'Knowledge', 'updateKnowledge', '', 'KnowledgeController_updateKnowledge_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (189, 'Create Evaluation Task Temporary Storage', 'Create Evaluation Task Temporary Storage', '', 'EvalTaskController_appendTemporary_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (191, 'Evaluation Set', 'Create Evaluation Set', '', 'EvalSetController_create_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (193, 'Knowledge', 'deleteKnowledge', '', 'KnowledgeController_deleteKnowledge_DELETE', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (195, '', '', '', 'ToolBoxController_getToolVersion_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (197, 'Evaluation Task Append - Only for Completed Tasks', 'Evaluation Task Append - Only for Completed Tasks', '',
        'EvalTaskController_append_POST', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (199, 'Knowledge', 'enableKnowledge', '', 'KnowledgeController_enableKnowledge_PUT', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (201, '', '', '', 'DataBaseController_operateTableData_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (203, 'Workflow', 'Add Workflow', '', 'WorkflowController_getDimension_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (205, '', '', '', 'DataBaseController_getTableTemplateFile_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (207, 'Evaluation Scenario', 'Evaluation Scenario List', '', 'EvalDimensionController_getSceneList_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (209, 'Evaluation Set', 'Download Evaluation Set', '', 'EvalSetController_download_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (211, '', '', '', 'ToolBoxController_debugTool_POST', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (213, 'File', 'createHtmlFile', '', 'FileController_createHtmlFile_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (215, 'Workflow', 'Edit Workflow', '', 'WorkflowController_update_PUT', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (217, 'File', 'fileIndexingStatus', '', 'FileController_fileIndexingStatus_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (219, 'Model Management', 'Model List', '', 'ModelController_list_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (221, 'Evaluation Dimension', 'Evaluation Dimension Total List', '', 'EvalDimensionController_getDimensionList_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (223, 'Evaluation Set', 'Evaluation Set Details', '', 'EvalSetController_get_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (225, 'Evaluation Scenario', 'Add Evaluation Scenario', '', 'EvalDimensionController_addScene_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (227, '', '', '', 'DataBaseController_importDbTableField_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (229, '', '', '', 'DataBaseController_updateDatabase_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (231, 'Knowledge Base', 'Enable Knowledge Base', '', 'RepoController_enableRepo_PUT', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (233, 'Model Management', 'Delete Model', '', 'ModelController_delete_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (235, '', '', '', 'ToolBoxController_updateTool_PUT', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (237, 'File', 'File Upload', '', 'FileController_upload_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (239, '', '', '', 'DataBaseController_getDbTableFieldList_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (241, '', '', '', 'ToolBoxController_getToolLatestVersion_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (243, '', '', '', 'DataBaseController_selectTableData_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (245, 'Evaluation Dimension', 'Import Evaluation Dimension', '', 'EvalDimensionController_importEvalDimensionData_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (247, 'Evaluation Task Scenario', 'Evaluation Task List', '', 'EvalTaskController_list_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (249, 'Workflow', 'Workflow Details', '', 'WorkflowController_detail_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (251, '', '', '', 'DataBaseController_exportTableData_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (253, '', '', '', 'ToolBoxController_temporaryTool_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (255, 'Evaluation Dimension', 'Evaluation Dimension List', '', 'EvalDimensionController_getDimension_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (257, 'Evaluation Task Scenario', 'Evaluation Task Single Details', '', 'EvalTaskController_get_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (259, '', '', '', 'ToolBoxController_detail_GET', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (261, 'Space User Management', '', '', 'SpaceUserController_getUserLimit_GET', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (263, 'Workflow', 'Workflow Build', '', 'WorkflowController_build_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (265, 'Space User Management', '', '', 'SpaceUserController_quitSpace_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (267, 'Invite Management', '', '', 'InviteRecordController_spaceSearchUser_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (269, 'Space User Management', '', '', 'SpaceUserController_remove_DELETE', 1, 1, 0, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (271, 'Evaluation Task Scenario', 'Evaluation Task Name Duplicate Check', '', 'EvalTaskController_checkName_GET', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (273, 'Publish API Access Package', 'Publish API Access Package', '', 'UserAuthController_getBindableOrderId_GET', 1, 0, 0, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (275, 'Publish Management', 'testPoint', '', 'MCPController_getMcpContent_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (277, 'Model Management', 'Enable/Disable Model', '', 'ModelController_switchModel_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (278, 'Model Management', 'Add/Edit Local Model', '', 'ModelController_localModel_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (279, 'Model Management', 'Get Model File Directory List', '', 'ModelController_localModelList_POST', 1, 1, 1, 0,
        '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (280, 'Invite Management', '', '', 'InviteRecordController_spaceSearchUsername_GET', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`,
                                      `member`, `available_expired`, `create_time`, `update_time`)
VALUES (281, 'Agent Details', '', '', 'ChatBotController_botDetail_POST', 1, 1, 1, 0, '2025-01-01 00:00:00',
        '2025-01-01 00:00:00');
INSERT INTO `astron_console`.`agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`, `member`, `available_expired`, `create_time`, `update_time`) VALUES (282, '创建工作流智能体', NULL, NULL, 'BotCreateController_create_POST', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
INSERT INTO `astron_console`.`agent_space_permission` (`id`, `module`, `point`, `description`, `permission_key`, `owner`, `admin`, `member`, `available_expired`, `create_time`, `update_time`) VALUES (283, '更新工作流智能体', NULL, NULL, 'BotCreateController_update_POST', 1, 1, 1, 0, '2025-01-01 00:00:00', '2025-01-01 00:00:00');
COMMIT;

-- ----------------------------
-- Table structure for agent_space_user
-- ----------------------------
DROP TABLE IF EXISTS `agent_space_user`;
CREATE TABLE `agent_space_user`
(
    `id`              bigint       NOT NULL AUTO_INCREMENT,
    `space_id`        bigint       NOT NULL COMMENT 'Space ID',
    `uid`             varchar(128) NOT NULL COMMENT 'User ID',
    `nickname`        varchar(64) DEFAULT NULL COMMENT 'User nickname',
    `role`            tinyint      NOT NULL COMMENT 'Role: 1 owner, 2 administrator, 3 member',
    `last_visit_time` datetime    DEFAULT NULL COMMENT 'Last visit time',
    `create_time`     datetime    DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`     datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `space_id_uid_uni_key` (`space_id`,`uid`) USING BTREE,
    KEY               `space_user_uid_key` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workspace users';

-- ----------------------------
-- Table structure for ai_prompt_template
-- ----------------------------
DROP TABLE IF EXISTS `ai_prompt_template`;
CREATE TABLE `ai_prompt_template`
(
    `id`             bigint                                                        NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `prompt_key`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Prompt unique identifier',
    `language_code`  varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT 'Language code: zh_CN/en_US',
    `prompt_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Prompt template content',
    `is_active`      tinyint(1) DEFAULT '1' COMMENT 'Is active (0-disabled, 1-enabled)',
    `created_time`   datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Created time',
    `updated_time`   datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Updated time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_prompt_key_lang` (`prompt_key`,`language_code`),
    KEY              `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI prompt template table';

-- ----------------------------
-- Table structure for application_form
-- ----------------------------
DROP TABLE IF EXISTS `application_form`;
CREATE TABLE `application_form`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `nickname`    varchar(255) NOT NULL COMMENT 'User nickname',
    `mobile`      varchar(255) NOT NULL COMMENT 'Mobile number',
    `bot_name`    varchar(255) NOT NULL COMMENT 'Assistant name',
    `bot_id`      bigint       NOT NULL COMMENT 'Assistant ID',
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    PRIMARY KEY (`id`),
    KEY           `idx_bot_id` (`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for auth_apply_record
-- ----------------------------
DROP TABLE IF EXISTS `auth_apply_record`;
CREATE TABLE `auth_apply_record`
(
    `id`            int NOT NULL AUTO_INCREMENT,
    `app_id`        varchar(128) DEFAULT NULL,
    `domain`        varchar(255) DEFAULT NULL,
    `content`       text,
    `create_time`   datetime     DEFAULT NULL,
    `uid`           varchar(128) DEFAULT NULL,
    `channel`       varchar(255) DEFAULT NULL,
    `patch_id`      varchar(128) DEFAULT NULL,
    `auto_auth`     bit(1)       DEFAULT NULL,
    `auth_order_id` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for base_model_map
-- ----------------------------
DROP TABLE IF EXISTS `base_model_map`;
CREATE TABLE `base_model_map`
(
    `id`              int unsigned NOT NULL AUTO_INCREMENT,
    `create_time`     datetime NOT NULL                                             DEFAULT CURRENT_TIMESTAMP,
    `domain`          varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `base_model_id`   bigint                                                        DEFAULT NULL,
    `base_model_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for bot_chat_file_param
-- ----------------------------
DROP TABLE IF EXISTS `bot_chat_file_param`;
CREATE TABLE `bot_chat_file_param`
(
    `id`          bigint                                                        NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `uid`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'User ID',
    `chat_id`     bigint                                                        NOT NULL COMMENT 'Chat ID',
    `name`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Parameter name',
    `file_ids`    json     DEFAULT NULL COMMENT 'File ID list',
    `file_urls`   json     DEFAULT NULL COMMENT 'File URL list',
    `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `is_delete`   tinyint  DEFAULT '0' COMMENT 'Whether deleted: 0 not deleted, 1 deleted',
    PRIMARY KEY (`id`),
    KEY           `idx_uid` (`uid`),
    KEY           `idx_chat_id` (`chat_id`),
    KEY           `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot chat file parameter info table';

-- ----------------------------
-- Table structure for bot_conversation_stats
-- ----------------------------
DROP TABLE IF EXISTS `bot_conversation_stats`;
CREATE TABLE `bot_conversation_stats`
(
    `id`                bigint                                                        NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `uid`               varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'User ID',
    `space_id`          bigint                                                                 DEFAULT NULL COMMENT 'Space ID, NULL for personal agents',
    `bot_id`            int                                                           NOT NULL COMMENT 'Agent ID',
    `chat_id`           bigint                                                        NOT NULL COMMENT 'Conversation ID',
    `sid`               varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci          DEFAULT NULL COMMENT 'Session identifier',
    `token_consumed`    int                                                           NOT NULL DEFAULT '0' COMMENT 'Token count consumed in this conversation',
    `message_rounds`    int                                                           NOT NULL DEFAULT '1' COMMENT 'Message rounds in this conversation',
    `conversation_date` date                                                          NOT NULL COMMENT 'Conversation date',
    `create_time`       datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `is_delete`         tinyint                                                       NOT NULL DEFAULT '0' COMMENT 'Whether deleted: 0=not deleted, 1=deleted',
    PRIMARY KEY (`id`),
    KEY                 `idx_bot_id_date` (`bot_id`,`conversation_date`),
    KEY                 `idx_uid_bot_id` (`uid`,`bot_id`),
    KEY                 `idx_space_id_bot_id` (`space_id`,`bot_id`),
    KEY                 `idx_chat_id` (`chat_id`),
    KEY                 `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot conversation statistics table';

-- ----------------------------
-- Table structure for bot_dataset
-- ----------------------------
DROP TABLE IF EXISTS `bot_dataset`;
CREATE TABLE `bot_dataset`
(
    `id`            bigint NOT NULL AUTO_INCREMENT,
    `bot_id`        bigint NOT NULL COMMENT 'Corresponding primary key ID of chat_bot_base table',
    `dataset_id`    bigint       DEFAULT NULL COMMENT 'Primary key ID of dataset_info table',
    `dataset_index` varchar(255) DEFAULT NULL COMMENT 'Knowledge database dataset ID',
    `is_act`        tinyint      DEFAULT '1' COMMENT 'Whether effective: 0 inactive, 1 active, 2 under review after market update',
    `create_time`   datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `uid`           varchar(128) DEFAULT NULL COMMENT 'User ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_id_bot_id` (`id`,`bot_id`),
    KEY             `idx_uid` (`uid`),
    KEY             `idx_is_act` (`is_act`),
    KEY             `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot associated dataset index table';

-- ----------------------------
-- Table structure for bot_dataset_maas
-- ----------------------------
DROP TABLE IF EXISTS `bot_dataset_maas`;
CREATE TABLE `bot_dataset_maas`
(
    `id`            bigint NOT NULL AUTO_INCREMENT,
    `bot_id`        bigint NOT NULL COMMENT 'Corresponding primary key ID of chat_bot_base table',
    `dataset_id`    bigint       DEFAULT NULL COMMENT 'Primary key ID of dataset_info table',
    `dataset_index` varchar(255) DEFAULT NULL COMMENT 'Knowledge database dataset ID',
    `is_act`        tinyint      DEFAULT '1' COMMENT 'Whether effective: 0 inactive, 1 active, 2 under review after market update',
    `create_time`   datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `uid`           varchar(128) DEFAULT NULL COMMENT 'User ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_id_bot_id` (`id`,`bot_id`),
    KEY             `idx_uid` (`uid`),
    KEY             `idx_is_act` (`is_act`),
    KEY             `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot associated maas dataset index table';

-- ----------------------------
-- Table structure for bot_favorite
-- ----------------------------
DROP TABLE IF EXISTS `bot_favorite`;
CREATE TABLE `bot_favorite`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) NOT NULL,
    `bot_id`      int          NOT NULL,
    `create_time` datetime DEFAULT NULL,
    `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY           `idx_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot favorites';

-- ----------------------------
-- Table structure for bot_flow_rel
-- ----------------------------
DROP TABLE IF EXISTS `bot_flow_rel`;
CREATE TABLE `bot_flow_rel`
(
    `id`          int unsigned NOT NULL AUTO_INCREMENT,
    `create_time` datetime     DEFAULT CURRENT_TIMESTAMP,
    `flow_id`     varchar(255) DEFAULT NULL,
    `bot_id`      bigint       DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for bot_model_bind
-- ----------------------------
DROP TABLE IF EXISTS `bot_model_bind`;
CREATE TABLE `bot_model_bind`
(
    `id`             bigint       NOT NULL AUTO_INCREMENT,
    `uid`            varchar(128) NOT NULL,
    `bot_id`         bigint                DEFAULT NULL,
    `app_id`         varchar(255) NOT NULL,
    `llm_service_id` varchar(255) NOT NULL,
    `domain`         varchar(255) NOT NULL,
    `patch_id`       varchar(255) NOT NULL DEFAULT '0',
    `model_name`     varchar(255)          DEFAULT NULL,
    `create_time`    datetime              DEFAULT NULL,
    `model_type`     tinyint               DEFAULT '1',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `bot_id` (`bot_id`,`app_id`(191),`llm_service_id`(191),`domain`(191),`patch_id`(191)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for bot_model_config
-- ----------------------------
DROP TABLE IF EXISTS `bot_model_config`;
CREATE TABLE `bot_model_config`
(
    `id`           bigint NOT NULL AUTO_INCREMENT,
    `bot_id`       bigint NOT NULL COMMENT 'Bot ID',
    `model_config` text   NOT NULL COMMENT 'Model configuration',
    `create_time`  datetime DEFAULT NULL,
    `update_time`  datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for bot_offiaccount
-- ----------------------------
DROP TABLE IF EXISTS `bot_offiaccount`;
CREATE TABLE `bot_offiaccount`
(
    `id`           bigint NOT NULL AUTO_INCREMENT,
    `uid`          varchar(128) DEFAULT NULL COMMENT 'User ID',
    `bot_id`       bigint       DEFAULT NULL COMMENT 'Assistant ID',
    `appid`        varchar(100) DEFAULT NULL COMMENT 'WeChat official account app ID',
    `release_type` tinyint      DEFAULT '1' COMMENT 'Release type: 1 WeChat official account',
    `status`       tinyint      DEFAULT '0' COMMENT 'Binding status: 0-unbound, 1-bound, 2-unbound',
    `create_time`  datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`  datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY            `bot_id_index` (`bot_id`),
    KEY            `uid_index` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot and WeChat Official Account binding information';

-- ----------------------------
-- Table structure for bot_offiaccount_chat
-- ----------------------------
DROP TABLE IF EXISTS `bot_offiaccount_chat`;
CREATE TABLE `bot_offiaccount_chat`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `app_id`      varchar(64) DEFAULT NULL COMMENT 'WeChat official account app ID',
    `open_id`     varchar(64) DEFAULT NULL COMMENT 'User ID who followed WeChat official account',
    `msg_id`      bigint      DEFAULT NULL COMMENT 'WeChat message ID, equivalent to req_id',
    `req`         text COMMENT 'Message sent by user',
    `resp`        text COMMENT 'Message returned by large model',
    `sid`         varchar(64) DEFAULT NULL COMMENT 'Session identifier',
    `create_time` datetime    DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY           `index_app_id` (`app_id`),
    KEY           `index_open_id` (`open_id`),
    KEY           `index_msg_id` (`msg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='WeChat Official Account Q&A record table';

-- ----------------------------
-- Table structure for bot_offiaccount_record
-- ----------------------------
DROP TABLE IF EXISTS `bot_offiaccount_record`;
CREATE TABLE `bot_offiaccount_record`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `bot_id`      bigint       DEFAULT NULL COMMENT 'Assistant ID',
    `appid`       varchar(100) DEFAULT NULL COMMENT 'WeChat official account app ID',
    `auth_type`   tinyint      DEFAULT NULL COMMENT 'Operation type: 1 bind, 2 unbind',
    `create_time` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY           `appid_index` (`appid`),
    KEY           `bot_id_index` (`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot publishing operation record table';

-- ----------------------------
-- Table structure for bot_repo_rel
-- ----------------------------
DROP TABLE IF EXISTS `bot_repo_rel`;
CREATE TABLE `bot_repo_rel`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `bot_id`      bigint       NOT NULL COMMENT 'Bot ID',
    `app_id`      varchar(64)  NOT NULL COMMENT 'App ID',
    `repo_id`     varchar(200) NOT NULL COMMENT 'Repo ID',
    `file_ids`    varchar(500) DEFAULT NULL COMMENT 'File list',
    `create_time` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for bot_tool_rel
-- ----------------------------
DROP TABLE IF EXISTS `bot_tool_rel`;
CREATE TABLE `bot_tool_rel`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `bot_id`      bigint       NOT NULL COMMENT 'Bot ID',
    `tool_id`     varchar(100) NOT NULL COMMENT 'Tool ID',
    `create_time` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for bot_type_list
-- ----------------------------
DROP TABLE IF EXISTS `bot_type_list`;
CREATE TABLE `bot_type_list`
(
    `id`           int NOT NULL AUTO_INCREMENT COMMENT 'Non-business primary key',
    `type_key`     int          DEFAULT NULL COMMENT 'Assistant type code',
    `type_name`    varchar(255) DEFAULT NULL COMMENT 'Assistant type name',
    `order_num`    int          DEFAULT '0' COMMENT 'Sort order number',
    `show_index`   tinyint      DEFAULT '0' COMMENT 'Whether recommended: 1 recommended, 0 not recommended',
    `is_act`       tinyint      DEFAULT '1' COMMENT 'Enable status: 0 disabled, 1 enabled',
    `create_time`  datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`  datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `icon`         varchar(500) DEFAULT '' COMMENT 'Icon URL',
    `type_name_en` varchar(128) DEFAULT NULL COMMENT 'Assistant type English name',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot type mapping table';

-- ----------------------------
-- Table structure for call_log
-- ----------------------------
DROP TABLE IF EXISTS `call_log`;
CREATE TABLE `call_log`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `sid`         varchar(255) DEFAULT NULL,
    `req`         text,
    `resp`        text,
    `create_time` datetime     DEFAULT NULL,
    `type`        varchar(255) DEFAULT NULL,
    `url`         varchar(512) DEFAULT NULL,
    `method`      varchar(64)  DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for chat_bot_api
-- ----------------------------
DROP TABLE IF EXISTS `chat_bot_api`;
CREATE TABLE `chat_bot_api`
(
    `id`           bigint        NOT NULL AUTO_INCREMENT,
    `uid`          varchar(128)  NOT NULL COMMENT 'User ID',
    `bot_id`       int           NOT NULL COMMENT 'Assistant ID',
    `assistant_id` varchar(32)   NOT NULL COMMENT 'Engineering assistant ID',
    `app_id`       varchar(32)  DEFAULT NULL COMMENT 'App ID associated with assistant API capability',
    `api_secret`   varchar(64)   NOT NULL COMMENT 'API secret',
    `api_key`      varchar(64)   NOT NULL COMMENT 'API key',
    `api_path`     varchar(32)   NOT NULL COMMENT 'Path of assistant API capability',
    `prompt`       varchar(2048) NOT NULL COMMENT 'Prompt of assistant API capability',
    `plugin_id`    varchar(256)  NOT NULL COMMENT 'Plugin ID, multiple separated by commas',
    `embedding_id` varchar(256)  NOT NULL COMMENT 'Embedding ID, multiple separated by commas',
    `description`  varchar(256) DEFAULT NULL COMMENT 'Description',
    `create_time`  datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`  datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_assistant_id` (`assistant_id`),
    KEY            `idx_bot_id` (`bot_id`),
    KEY            `idx_uid` (`uid`),
    KEY            `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot API capability information table';

-- ----------------------------
-- Table structure for chat_bot_base
-- ----------------------------
DROP TABLE IF EXISTS `chat_bot_base`;
CREATE TABLE `chat_bot_base`
(
    `id`                int     NOT NULL AUTO_INCREMENT COMMENT 'bot_id',
    `uid`               varchar(128)     DEFAULT NULL COMMENT 'User ID',
    `bot_name`          varchar(48)      DEFAULT NULL COMMENT 'Bot name',
    `bot_type`          tinyint          DEFAULT NULL COMMENT 'Bot type: 1 custom assistant, 2 life assistant, 3 workplace assistant, 4 marketing assistant, 5 writing expert, 6 knowledge expert',
    `avatar`            varchar(1024)    DEFAULT NULL COMMENT 'Bot avatar',
    `pc_background`     varchar(512)     DEFAULT '' COMMENT 'PC chat background image',
    `app_background`    varchar(512)     DEFAULT '' COMMENT 'Mobile chat background image',
    `background_color`  tinyint          DEFAULT '0' COMMENT 'Background color depth: 0 light, 1 dark',
    `prompt`            varchar(2048)    DEFAULT NULL COMMENT 'bot_prompt',
    `prologue`          varchar(512)     DEFAULT NULL COMMENT 'Opening words',
    `bot_desc`          varchar(255)     DEFAULT NULL COMMENT 'Bot description',
    `is_delete`         tinyint          DEFAULT '0' COMMENT 'Whether deleted: 0 not deleted, 1 deleted',
    `create_time`       datetime         DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`       datetime         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `support_context`   tinyint NOT NULL DEFAULT '0' COMMENT 'Whether supports multi-turn dialogue: 1 support, 0 not support',
    `bot_template`      varchar(255)     DEFAULT '' COMMENT 'Input template',
    `prompt_type`       tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Instruction type: 0 regular (custom instruction), 1 structured instruction',
    `input_example`     varchar(600)     DEFAULT '' COMMENT 'Input example',
    `botweb_status`     tinyint NOT NULL DEFAULT '0' COMMENT 'Whether to enable standalone assistant application: 0 disabled, 1 enabled',
    `version`           int              DEFAULT '1' COMMENT 'Assistant version number',
    `support_document`  tinyint          DEFAULT '0' COMMENT 'Whether supports files: 0 not support, 1 strictly based on document, 2 can give divergent answers',
    `support_system`    tinyint          DEFAULT '0' COMMENT 'Whether supports system instruction: 0 not support, 1 support',
    `prompt_system`     tinyint          DEFAULT '0' COMMENT 'System instruction status',
    `support_upload`    tinyint NOT NULL DEFAULT '0' COMMENT 'Whether supports document upload: 0 not support, 1 support',
    `bot_name_en`       varchar(48)      DEFAULT NULL COMMENT 'Assistant name English version',
    `bot_desc_en`       varchar(500)     DEFAULT NULL COMMENT 'Assistant description English version',
    `client_type`       tinyint NOT NULL DEFAULT '0' COMMENT 'Client type',
    `vcn_cn`            varchar(32)      DEFAULT NULL COMMENT 'Chinese voice actor',
    `vcn_en`            varchar(32)      DEFAULT NULL COMMENT 'English voice actor',
    `vcn_speed`         tinyint NOT NULL DEFAULT '50' COMMENT 'Voice actor speed',
    `is_sentence`       tinyint NOT NULL DEFAULT '0' COMMENT 'Whether generated in one sentence: 0 no, 1 yes',
    `opened_tool`       varchar(128)     DEFAULT 'ifly_search,text_to_image,codeinterpreter' COMMENT 'Enabled tools, concatenated with commas',
    `client_hide`       varchar(10)      DEFAULT '' COMMENT 'Hidden on some clients',
    `virtual_bot_type`  tinyint          DEFAULT NULL COMMENT 'Virtual personality type',
    `virtual_agent_id`  bigint           DEFAULT NULL COMMENT 'Primary key of virtual_agent_list',
    `style`             int              DEFAULT NULL COMMENT 'Style type: 0 original, 1 business elite, 2 casual moment',
    `background`        varchar(512)     DEFAULT NULL COMMENT 'Background setting',
    `virtual_character` varchar(512)     DEFAULT NULL COMMENT 'Character setting',
    `model`             varchar(32)      DEFAULT 'spark' COMMENT 'Model selected by assistant',
    `mass_bot_id`       varchar(50)      DEFAULT NULL COMMENT 'mass_bot_id',
    `prologue_en`       varchar(1024)    DEFAULT NULL COMMENT 'Opening words - English',
    `input_example_en`  varchar(1024)    DEFAULT NULL COMMENT 'Recommended questions - English',
    `space_id`          bigint           DEFAULT NULL COMMENT 'Space ID',
    `model_id`          bigint           DEFAULT NULL COMMENT 'Custom model ID',
    PRIMARY KEY (`id`),
    KEY                 `idx_create_time` (`create_time`),
    KEY                 `idx_support_context` (`support_context`),
    KEY                 `idx_uid` (`uid`),
    KEY                 `idx_botweb_status` (`botweb_status`),
    KEY                 `idx_space_id` (`space_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User created bot table';

-- ----------------------------
-- Table structure for chat_bot_list
-- ----------------------------
DROP TABLE IF EXISTS `chat_bot_list`;
CREATE TABLE `chat_bot_list`
(
    `id`              int     NOT NULL AUTO_INCREMENT,
    `uid`             varchar(128)     DEFAULT NULL COMMENT 'User ID',
    `market_bot_id`   int              DEFAULT '0' COMMENT 'Market bot ID, 0 for original, other values for referencing other users bots',
    `real_bot_id`     int              DEFAULT '0' COMMENT 'Self-created assistant is 0, only when adding others assistants from market, the original bot_id is added',
    `name`            varchar(48)      DEFAULT NULL COMMENT 'Bot name',
    `bot_type`        tinyint          DEFAULT '1' COMMENT 'Bot type: 1 custom assistant, 2 life assistant, 3 workplace assistant, 4 marketing assistant, 5 writing expert, 6 knowledge expert',
    `avatar`          varchar(1024)    DEFAULT NULL COMMENT 'Bot avatar',
    `prompt`          varchar(2048)    DEFAULT NULL COMMENT 'bot_prompt',
    `bot_desc`        varchar(255)     DEFAULT NULL COMMENT 'Bot description',
    `is_act`          tinyint          DEFAULT '1' COMMENT 'Whether enabled: 0 disabled, 1 enabled',
    `create_time`     datetime         DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`     datetime         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `support_context` tinyint NOT NULL DEFAULT '0' COMMENT 'Whether supports multi-turn dialogue: 1 support, 0 not support',
    PRIMARY KEY (`id`),
    KEY               `idx_act` (`is_act`),
    KEY               `idx_create_time2` (`create_time`),
    KEY               `idx_real_bot_id` (`real_bot_id`),
    KEY               `idx_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User added bot table';

-- ----------------------------
-- Table structure for chat_bot_market
-- ----------------------------
DROP TABLE IF EXISTS `chat_bot_market`;
CREATE TABLE `chat_bot_market`
(
    `id`               int     NOT NULL AUTO_INCREMENT,
    `bot_id`           int                                                          DEFAULT NULL COMMENT 'botId',
    `uid`              varchar(128)                                                 DEFAULT NULL COMMENT 'Publisher UID',
    `bot_name`         varchar(48)                                                  DEFAULT NULL COMMENT 'Bot name, this is a copy, original is with creator',
    `bot_type`         tinyint                                                      DEFAULT '1' COMMENT 'Bot type: 1 custom assistant, 2 life assistant, 3 workplace assistant, 4 marketing assistant, 5 writing expert, 6 knowledge expert',
    `avatar`           varchar(1024)                                                DEFAULT NULL COMMENT 'Bot avatar',
    `pc_background`    varchar(512)                                                 DEFAULT '' COMMENT 'PC chat background image',
    `app_background`   varchar(512)                                                 DEFAULT '' COMMENT 'Mobile chat background image',
    `background_color` tinyint                                                      DEFAULT '0' COMMENT 'Background color depth: 0 light, 1 dark',
    `prompt`           varchar(2048)                                                DEFAULT NULL COMMENT 'bot_prompt',
    `prologue`         varchar(512)                                                 DEFAULT NULL COMMENT 'Opening words',
    `show_others`      tinyint                                                      DEFAULT NULL COMMENT 'Whether to show prompt to others: 1 show, 0 not show',
    `bot_desc`         varchar(255)                                                 DEFAULT NULL COMMENT 'Bot description',
    `bot_status`       tinyint                                                      DEFAULT '1' COMMENT 'Bot status: 0 delisted, 1 under review, 2 approved, 3 rejected, 4 modification under review (to be displayed)',
    `block_reason`     varchar(255)                                                 DEFAULT NULL COMMENT 'Reason for rejection',
    `hot_num`          int                                                          DEFAULT '0' COMMENT 'Popularity, customizable size for sorting',
    `is_delete`        tinyint                                                      DEFAULT '0' COMMENT 'Application history: 0 not deleted, 1 deleted',
    `show_index`       tinyint                                                      DEFAULT '0' COMMENT 'Whether to display on homepage recommendation: 0 not display, 1 display',
    `sort_hot`         int                                                          DEFAULT '0' COMMENT 'Manually set hottest bot position',
    `sort_latest`      int                                                          DEFAULT '0' COMMENT 'Manually set latest bot position',
    `audit_time`       datetime                                                     DEFAULT NULL COMMENT 'Review time',
    `create_time`      datetime                                                     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`      datetime                                                     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `support_context`  tinyint NOT NULL                                             DEFAULT '0' COMMENT 'Whether supports multi-turn dialogue: 1 support, 0 not support',
    `version`          int                                                          DEFAULT '1' COMMENT 'Corresponding large model version, 13, 65, unit: billion',
    `show_weight`      int                                                          DEFAULT '1' COMMENT 'Homepage recommended assistant weight, larger number comes first',
    `score`            int                                                          DEFAULT NULL COMMENT 'Score given upon approval',
    `client_hide`      varchar(10)                                                  DEFAULT '' COMMENT 'Hidden on some clients',
    `model`            varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Corresponding large model type',
    `opened_tool`      varchar(255)                                                 DEFAULT NULL COMMENT 'Enabled tools',
    `publish_channels` varchar(255)                                                 DEFAULT NULL COMMENT 'Publishing channels: MARKET,API,WECHAT,MCP comma separated',
    `model_id`         bigint                                                       DEFAULT NULL COMMENT 'Custom model ID',
    `support_document` tinyint NOT NULL                                             DEFAULT '0' COMMENT 'Does it support the knowledge base? 0 - Not supported, 1 - Supported',
    PRIMARY KEY (`id`),
    KEY                `idx_bot_id` (`bot_id`),
    KEY                `idx_create_time3` (`create_time`),
    KEY                `uid_index` (`uid`),
    KEY                `idx_bot_status` (`bot_status`,`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bot market table';

-- ----------------------------
-- Table structure for chat_bot_prompt_struct
-- ----------------------------
DROP TABLE IF EXISTS `chat_bot_prompt_struct`;
CREATE TABLE `chat_bot_prompt_struct`
(
    `id`           bigint                                                         NOT NULL AUTO_INCREMENT,
    `bot_id`       int                                                            NOT NULL COMMENT 'chat_bot_id.id',
    `prompt_key`   varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci   NOT NULL COMMENT 'Custom instruction - key',
    `prompt_value` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'Custom instruction - value',
    `create_time`  datetime                                                                DEFAULT NULL,
    `update_time`  datetime                                                                DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY            `idx_bot_id` (`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Structured instruction';

-- ----------------------------
-- Table structure for chat_bot_remove
-- ----------------------------
DROP TABLE IF EXISTS `chat_bot_remove`;
CREATE TABLE `chat_bot_remove`
(
    `id`           int NOT NULL AUTO_INCREMENT,
    `bot_id`       int           DEFAULT NULL COMMENT 'botId',
    `uid`          varchar(128)  DEFAULT NULL COMMENT 'Publisher UID',
    `bot_name`     varchar(48)   DEFAULT NULL COMMENT 'Bot name, this is a copy, original is with creator',
    `bot_type`     tinyint       DEFAULT '1' COMMENT 'Bot type: 1 custom assistant, 2 life assistant, 3 workplace assistant, 4 marketing assistant, 5 writing expert, 6 knowledge expert',
    `avatar`       varchar(512)  DEFAULT NULL COMMENT 'Bot avatar URL',
    `prompt`       varchar(2048) DEFAULT NULL COMMENT 'bot_prompt',
    `bot_desc`     varchar(255)  DEFAULT NULL COMMENT 'Bot description',
    `block_reason` varchar(255)  DEFAULT NULL COMMENT 'Reason for rejection',
    `is_delete`    tinyint       DEFAULT '0' COMMENT 'Application history: 0 not deleted, 1 deleted',
    `audit_time`   datetime      DEFAULT NULL COMMENT 'Review time',
    `create_time`  datetime      DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`  datetime      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY            `idx_bot_id` (`bot_id`),
    KEY            `idx_bot_type` (`bot_type`),
    KEY            `idx_create_time4` (`create_time`),
    KEY            `uid_index` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Delisted bot history table';

-- ----------------------------
-- Table structure for chat_file_req
-- ----------------------------
DROP TABLE IF EXISTS `chat_file_req`;
CREATE TABLE `chat_file_req`
(
    `id`            bigint       NOT NULL AUTO_INCREMENT,
    `file_id`       varchar(64)  NOT NULL COMMENT 'Document Q&A file ID',
    `chat_id`       bigint       NOT NULL COMMENT 'Chat ID',
    `req_id`        bigint                DEFAULT NULL COMMENT 'req_id',
    `uid`           varchar(128) NOT NULL COMMENT 'Owner UID',
    `create_time`   datetime              DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `client_type`   tinyint      NOT NULL DEFAULT '0' COMMENT 'Client type: 0 unknown, 1 PC, 2 H5 mainly for statistics',
    `deleted`       tinyint      NOT NULL DEFAULT '0' COMMENT 'Whether deleted: 0 not deleted, 1 deleted',
    `business_type` tinyint      NOT NULL DEFAULT '0' COMMENT 'Document type: 0 long document, 1 long audio, 2 long video, 3 OCR',
    PRIMARY KEY (`id`),
    KEY             `idx_chatid_uid_fileid` (`chat_id`,`uid`,`file_id`),
    KEY             `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chatfile Q&A binding information';

-- ----------------------------
-- Table structure for chat_file_user
-- ----------------------------
DROP TABLE IF EXISTS `chat_file_user`;
CREATE TABLE `chat_file_user`
(
    `id`                  bigint       NOT NULL AUTO_INCREMENT,
    `file_id`             varchar(64)           DEFAULT NULL COMMENT 'Document Q&A file ID',
    `uid`                 varchar(128) NOT NULL COMMENT 'Owner UID',
    `file_url`            varchar(1024)         DEFAULT NULL COMMENT 'File URL',
    `file_name`           varchar(128)          DEFAULT NULL COMMENT 'File name',
    `file_size`           bigint                DEFAULT NULL COMMENT 'File size',
    `file_pdf_url`        varchar(1024)         DEFAULT NULL COMMENT 'File PDF URL',
    `create_time`         datetime              DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`         datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `deleted`             tinyint      NOT NULL DEFAULT '0' COMMENT 'Whether deleted: 0 not deleted, 1 deleted',
    `client_type`         tinyint      NOT NULL DEFAULT '0' COMMENT 'Client type: 0 unknown, 1 PC, 2 H5 mainly for statistics',
    `business_type`       tinyint      NOT NULL DEFAULT '0' COMMENT 'Document type: 0 long document, 1 long audio, 2 long video, 3 OCR',
    `display`             tinyint      NOT NULL DEFAULT '0' COMMENT 'Whether to display in history knowledge base: 0 display, 1 not display',
    `file_status`         tinyint      NOT NULL DEFAULT '1' COMMENT 'Document status: 0 unprocessed, 1 processing, 2 completed, 3 failed',
    `file_business_key`   varchar(1024)         DEFAULT NULL COMMENT 'Frontend maintained file unique key',
    `extra_link`          varchar(1024)         DEFAULT NULL COMMENT 'Video external link processing',
    `document_type`       tinyint               DEFAULT '1' COMMENT 'Document classification: 1 Spark document, 2 Zhiwen, see light_app_detail.additional_info field',
    `file_index`          int                   DEFAULT NULL COMMENT 'Daily upload count per user',
    `scene_type_id`       bigint                DEFAULT NULL COMMENT 'File scenario: related to document_scene_type table',
    `icon`                varchar(1024)         DEFAULT NULL COMMENT 'Favorite icon display',
    `collect_origin_from` varchar(1024)         DEFAULT NULL COMMENT 'Favorite content source',
    `task_id`             varchar(100)          DEFAULT NULL COMMENT 'RAG-v2 version task ID',
    PRIMARY KEY (`id`),
    KEY                   `chat_file_user_file_id_IDX` (`file_id`) USING BTREE,
    KEY                   `chat_file_user_uid_IDX` (`uid`) USING BTREE,
    KEY                   `chat_file_user_create_time_IDX` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User file information';

-- ----------------------------
-- Table structure for chat_info
-- ----------------------------
DROP TABLE IF EXISTS `chat_info`;
CREATE TABLE `chat_info`
(
    `id`              bigint NOT NULL AUTO_INCREMENT,
    `app_id`          varchar(255) DEFAULT NULL,
    `bot_id`          varchar(255) DEFAULT NULL,
    `flow_id`         varchar(255) DEFAULT NULL,
    `sub`             varchar(255) DEFAULT NULL COMMENT 'Type: agent, workflow',
    `caller`          varchar(255) DEFAULT NULL COMMENT 'Caller',
    `log_caller`      varchar(32)  DEFAULT '',
    `uid`             varchar(255) DEFAULT NULL,
    `sid`             varchar(255) DEFAULT NULL,
    `question`        text,
    `answer`          text,
    `status_code`     int          DEFAULT NULL,
    `message`         text COMMENT 'Error message',
    `total_cost_time` int          DEFAULT NULL COMMENT 'Total cost time',
    `first_cost_time` int          DEFAULT NULL COMMENT 'First frame cost time',
    `token`           int          DEFAULT NULL COMMENT 'Token consumption',
    `create_time`     datetime     DEFAULT NULL COMMENT 'Conversation creation time',
    PRIMARY KEY (`id`),
    KEY               `app_id` (`app_id`),
    KEY               `bot_id` (`bot_id`),
    KEY               `sid` (`sid`),
    KEY               `chat_info_index_6` (`flow_id`),
    KEY               `log_caller` (`log_caller`),
    KEY               `status_code` (`status_code`),
    KEY               `chat_info_bot_id_IDX` (`bot_id`,`sub`,`caller`,`create_time`) USING BTREE,
    KEY               `idx_sub_create_time` (`sub`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for chat_list
-- ----------------------------
DROP TABLE IF EXISTS `chat_list`;
CREATE TABLE `chat_list`
(
    `id`                 bigint   NOT NULL AUTO_INCREMENT COMMENT 'Non-business primary key',
    `uid`                varchar(128)      DEFAULT NULL COMMENT 'User ID',
    `title`              varchar(255)      DEFAULT NULL COMMENT 'Chat list topic',
    `is_delete`          tinyint           DEFAULT '0' COMMENT 'Whether deleted: 0 not delete, 1 delete',
    `enable`             tinyint           DEFAULT '1' COMMENT 'Enable status: 1 available, 0 unavailable',
    `bot_id`             int               DEFAULT '0' COMMENT 'Assistant ID',
    `sticky`             tinyint  NOT NULL DEFAULT '0' COMMENT 'Whether pinned: 0 not pinned, 1 pinned',
    `create_time`        datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`        datetime          DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modification time',
    `is_model`           tinyint  NOT NULL DEFAULT '0' COMMENT 'Whether multimodal: 0 no, 1 yes',
    `enabled_plugin_ids` varchar(255)      DEFAULT '' COMMENT 'Currently enabled plugin IDs for this conversation list',
    `is_botweb`          tinyint  NOT NULL DEFAULT '0' COMMENT 'Whether assistant WEB application: 0 no, 1 yes',
    `file_id`            varchar(64)       DEFAULT NULL COMMENT 'Document Q&A ID',
    `root_flag`          tinyint  NOT NULL DEFAULT '1' COMMENT 'Whether root chat: 1 yes, 0 no',
    `personality_id`     bigint            DEFAULT '0' COMMENT 'Personality chat_personality_base primary key ID',
    `gcl_id`             bigint            DEFAULT '0' COMMENT 'Group chat primary key ID, 0 means not group chat',
    PRIMARY KEY (`id`, `create_time`),
    KEY                  `chat_list_create_time_IDX` (`create_time`),
    KEY                  `idx_bot_id` (`bot_id`),
    KEY                  `idx_uid_bid_ctime` (`uid`,`bot_id`,`create_time`),
    KEY                  `chat_list_file_id_idx` (`file_id`),
    KEY                  `idx_pid_uid` (`personality_id`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat list table';

-- ----------------------------
-- Table structure for chat_reanwser_records
-- ----------------------------
DROP TABLE IF EXISTS `chat_reanwser_records`;
CREATE TABLE `chat_reanwser_records`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT COMMENT 'Non-business primary key',
    `uid`         varchar(128)      DEFAULT NULL COMMENT 'User ID',
    `chat_id`     bigint            DEFAULT NULL COMMENT 'Chat ID',
    `req_id`      bigint            DEFAULT NULL COMMENT 'Req ID before regeneration, for locating historical context position',
    `ask`         varchar(8000)     DEFAULT NULL COMMENT 'Prompt content',
    `answer`      varchar(8000)     DEFAULT NULL COMMENT 'Reply content',
    `ask_time`    datetime          DEFAULT NULL COMMENT 'Question record time',
    `answer_time` datetime          DEFAULT NULL COMMENT 'Answer record time',
    `sid`         varchar(64)       DEFAULT NULL COMMENT 'Reply SID',
    `answer_type` tinyint           DEFAULT NULL COMMENT 'Reply type: 0 system, 1 quick fix (not used by API), 2 large model, 3 abort',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime          DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`, `create_time`),
    KEY           `uid_index` (`uid`),
    KEY           `chat_index` (`chat_id`),
    KEY           `idx_sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat re-answer record table';

-- ----------------------------
-- Table structure for chat_reason_records
-- ----------------------------
DROP TABLE IF EXISTS `chat_reason_records`;
CREATE TABLE `chat_reason_records`
(
    `id`                    bigint       NOT NULL AUTO_INCREMENT,
    `uid`                   varchar(128) NOT NULL COMMENT 'User ID',
    `chat_id`               bigint       NOT NULL COMMENT 'Chat session ID',
    `req_id`                bigint       NOT NULL COMMENT 'Request ID',
    `content`               longtext     NOT NULL COMMENT 'Reasoning thinking content',
    `thinking_elapsed_secs` bigint                DEFAULT '0' COMMENT 'Thinking elapsed time (seconds)',
    `type`                  varchar(50)           DEFAULT NULL COMMENT 'Reasoning type (e.g.: x1_math)',
    `create_time`           datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`           datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`, `create_time`),
    KEY                     `idx_uid` (`uid`),
    KEY                     `idx_chat_id` (`chat_id`),
    KEY                     `idx_req_id` (`req_id`),
    KEY                     `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat thinking record table';

-- ----------------------------
-- Table structure for chat_req_model
-- ----------------------------
DROP TABLE IF EXISTS `chat_req_model`;
CREATE TABLE `chat_req_model`
(
    `id`          int          NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) NOT NULL COMMENT 'User ID',
    `chat_id`     bigint                DEFAULT NULL COMMENT 'Chat window ID',
    `chat_req_id` bigint       NOT NULL COMMENT 'Chat request ID',
    `type`        tinyint      NOT NULL DEFAULT '1' COMMENT 'Multimodal type, refer to MultiModelEnum',
    `url`         varchar(2048)         DEFAULT NULL COMMENT 'Resource URL',
    `status`      tinyint      NOT NULL DEFAULT '0' COMMENT 'Review status',
    `need_his`    tinyint               DEFAULT '1' COMMENT 'Whether to concatenate history: 0 no, 1 yes',
    `img_desc`    varchar(2048)         DEFAULT NULL COMMENT 'Image and other multimodal input description',
    `intention`   varchar(255)          DEFAULT NULL COMMENT 'Image intention: document for documents, universal for natural images',
    `ocr_result`  text COMMENT 'OCR recognition result',
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modification time',
    `data_id`     varchar(64)           DEFAULT NULL COMMENT 'Multimodal image ID, stores sse ID here, identifies which image for engineering institute',
    PRIMARY KEY (`id`, `create_time`),
    KEY           `idx_uid` (`uid`),
    KEY           `idx_req_id` (`chat_req_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Multimodal request table';

-- ----------------------------
-- Table structure for chat_req_records
-- ----------------------------
DROP TABLE IF EXISTS `chat_req_records`;
CREATE TABLE `chat_req_records`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT,
    `chat_id`     bigint   NOT NULL COMMENT 'Chat ID',
    `uid`         varchar(128)      DEFAULT NULL COMMENT 'User ID',
    `message`     varchar(8000)     DEFAULT NULL COMMENT 'Question content',
    `client_type` tinyint           DEFAULT '0' COMMENT 'Client type when user asks: 0 unknown, 1 PC, 2 H5 mainly for statistics',
    `model_id`    int               DEFAULT NULL COMMENT 'Multimodal related ID',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime          DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `date_stamp`  int               DEFAULT NULL COMMENT 'cmp_core.BigdataServicesMonitorDaily',
    `new_context` tinyint  NOT NULL DEFAULT '1' COMMENT 'Bot new context: 1 yes, 0 no',
    PRIMARY KEY (`id`, `create_time`),
    KEY           `idx_chat_id` (`chat_id`),
    KEY           `idx_create_time` (`create_time`),
    KEY           `idx_date_stamp` (`date_stamp`),
    KEY           `idx_uid_chatId` (`uid`,`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat request record table';

-- ----------------------------
-- Table structure for chat_resp_alltool_data
-- ----------------------------
DROP TABLE IF EXISTS `chat_resp_alltool_data`;
CREATE TABLE `chat_resp_alltool_data`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) DEFAULT NULL COMMENT 'User ID',
    `chat_id`     bigint       DEFAULT NULL COMMENT 'Chat ID',
    `req_id`      bigint       DEFAULT NULL COMMENT 'Request ID',
    `seq_no`      varchar(100) DEFAULT NULL COMMENT 'Sequence number, like p1, p2',
    `tool_data`   text COMMENT 'All tools data to be stored for each frame returned structural data',
    `tool_name`   varchar(100) DEFAULT NULL COMMENT 'All tools type name',
    `create_time` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY           `chat_resp_alltool_data_uid_IDX` (`uid`) USING BTREE,
    KEY           `chat_resp_alltool_data_chat_id_IDX` (`chat_id`) USING BTREE,
    KEY           `chat_resp_alltool_data_req_id_IDX` (`req_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Large model returns all tools paragraph data, one QA returns multiple alltools paragraph data';

-- ----------------------------
-- Table structure for chat_resp_model
-- ----------------------------
DROP TABLE IF EXISTS `chat_resp_model`;
CREATE TABLE `chat_resp_model`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) NOT NULL COMMENT 'User ID',
    `chat_id`     bigint                DEFAULT NULL COMMENT 'Chat window ID',
    `req_id`      bigint       NOT NULL COMMENT 'Chat question ID, multimodal records may be stored before answers, so use req ID for association',
    `content`     varchar(8000)         DEFAULT NULL COMMENT 'Multimodal return content',
    `type`        varchar(32)  NOT NULL DEFAULT 'text' COMMENT 'Multimodal output type: text, image, audio, video',
    `need_his`    tinyint               DEFAULT '1' COMMENT 'Whether to concatenate history: 0 no, 1 yes',
    `url`         text COMMENT 'Multimodal resource URL address',
    `status`      tinyint      NOT NULL DEFAULT '0' COMMENT 'Resource status: 0 available, 1 unavailable',
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modification time',
    `data_id`     varchar(64)           DEFAULT NULL COMMENT 'Large model generated resource ID, to be passed back for concatenating history',
    `water_url`   text COMMENT 'Watermarked resource URL',
    PRIMARY KEY (`id`, `create_time`),
    KEY           `idx_uid` (`uid`),
    KEY           `idx_chat_id` (`chat_id`),
    KEY           `idx_create_time` (`create_time`),
    KEY           `idx_req_id` (`req_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Multimodal response record table';

-- ----------------------------
-- Table structure for chat_resp_records
-- ----------------------------
DROP TABLE IF EXISTS `chat_resp_records`;
CREATE TABLE `chat_resp_records`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128)                                                  DEFAULT NULL COMMENT 'User ID',
    `chat_id`     bigint                                                        DEFAULT NULL COMMENT 'Chat ID',
    `req_id`      bigint                                                        DEFAULT NULL COMMENT 'Chat question ID, one question to one answer',
    `sid`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Engine serial number SID',
    `answer_type` tinyint                                                       DEFAULT '2' COMMENT 'Answer type: 1 hotfix, 2 gpt',
    `message`     mediumtext COMMENT 'Answer message',
    `create_time` datetime NOT NULL                                             DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `date_stamp`  int                                                           DEFAULT NULL COMMENT 'cmp_core.BigdataServicesMonitorDaily',
    PRIMARY KEY (`id`, `create_time`),
    KEY           `idx_chat_id` (`chat_id`),
    KEY           `idx_create_time` (`create_time`),
    KEY           `idx_reqId` (`req_id`),
    KEY           `idx_sid` (`sid`),
    KEY           `idx_uid_chatId` (`uid`,`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat response record table';

-- ----------------------------
-- Table structure for chat_token_records
-- ----------------------------
DROP TABLE IF EXISTS `chat_token_records`;
CREATE TABLE `chat_token_records`
(
    `id`                bigint NOT NULL AUTO_INCREMENT,
    `sid`               varchar(64) DEFAULT NULL COMMENT 'Session identifier',
    `prompt_tokens`     int         DEFAULT NULL COMMENT 'Prompt token count',
    `question_tokens`   int         DEFAULT NULL COMMENT 'Current question token count',
    `completion_tokens` int         DEFAULT NULL COMMENT 'Response completion token count',
    `total_tokens`      int         DEFAULT NULL COMMENT 'Total token count',
    `create_time`       datetime    DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`       datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY                 `idx_create_time` (`create_time`),
    KEY                 `idx_sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat token record table';

-- ----------------------------
-- Table structure for chat_trace_source
-- ----------------------------
DROP TABLE IF EXISTS `chat_trace_source`;
CREATE TABLE `chat_trace_source`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) DEFAULT NULL COMMENT 'User ID',
    `chat_id`     bigint       DEFAULT NULL COMMENT 'Chat ID',
    `req_id`      bigint       DEFAULT NULL COMMENT 'Request ID',
    `content`     text COMMENT 'Trace content, JSON array of one frame',
    `type`        varchar(50)  DEFAULT 'search' COMMENT 'Trace type: search for search trace, others for supplementary',
    `create_time` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY           `chat_trace_source_chat_id_IDX` (`chat_id`) USING BTREE,
    KEY           `chat_trace_source_type_IDX` (`type`) USING BTREE,
    KEY           `chat_trace_source_uid_IDX` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat trace information storage table';

-- ----------------------------
-- Table structure for chat_tree_index
-- ----------------------------
DROP TABLE IF EXISTS `chat_tree_index`;
CREATE TABLE `chat_tree_index`
(
    `id`             bigint   NOT NULL AUTO_INCREMENT,
    `root_chat_id`   bigint   NOT NULL COMMENT 'Root chat ID',
    `parent_chat_id` bigint   NOT NULL COMMENT 'Parent chat ID',
    `child_chat_id`  bigint   NOT NULL COMMENT 'Child chat ID',
    `uid`            varchar(128)      DEFAULT NULL COMMENT 'uid',
    `create_time`    datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`    datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`, `create_time`),
    KEY              `chat_tree_index_uid_IDX` (`uid`),
    KEY              `chat_tree_index_root_chat_id_IDX` (`root_chat_id`),
    KEY              `idx_child_chat_id` (`child_chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Chat history tree linked list information';

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info`
(
    `id`          bigint NOT NULL AUTO_INCREMENT COMMENT 'Primary key, starting from 10000',
    `category`    varchar(64)   DEFAULT NULL COMMENT 'Configuration category',
    `code`        varchar(128)  DEFAULT NULL COMMENT 'Configuration code, key',
    `name`        varchar(255)  DEFAULT NULL COMMENT 'Configuration name',
    `value`       text COMMENT 'Configuration content, value',
    `is_valid`    tinyint       DEFAULT NULL COMMENT 'Whether effective, 0-invalid, 1-valid',
    `remarks`     varchar(1000) DEFAULT NULL COMMENT 'Remarks, comments',
    `create_time` datetime      DEFAULT '2000-01-01 00:00:00' COMMENT 'Creation time',
    `update_time` datetime      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Configuration table';

-- ----------------------------
-- Records of config_info
-- ----------------------------
BEGIN;
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1019, 'DOCUMENT_LINK', '1', 'SparkBotHelpDoc', 'https://experience.pro.iflyaicloud.com/aicloud-sparkbot-doc/', 1, '你好', '2023-08-17 00:00:00', '2024-09-03 11:51:23');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1021, 'COMPRESSED_FOLDER', '1', 'SparkBotSDK', 'https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/sdk%E6%8E%A5%E5%85%A5%E8%AF%B4%E6%98%8E.zip', 1, '', '2000-01-01 00:00:00', '2024-06-27 10:35:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1023, 'SPARKBOT_CONFIG', '1', 'SparkBotApi', '{\"sdkHtml\":\"<div className=\\\"sdk-content\\\">\\n      <p className=\\\"title\\\">Sparkbot接入文档</p>\\n      <h1>JS SDK</h1>\\n      <p>\\n        安装之前，请确保您已通过我们的平台注册或我们已为您提供了<b>AppId</b>。\\n        如果没有密钥，您将无法使用该SDK。\\n      </p>\\n      <hr></hr>\\n      <h2>JS SDK</h2>\\n      <p>\\n        要将 Sparkbot 与 JS SDK 一起使用，您需要在 HTML 文件中包含脚本标签。\\n      </p>\\n      <h3>浮动机器人</h3>\\n      <p style={{ margin: \'20px 0\' }}>\\n        浮动机器人非常简单。 只需将这 2 个脚本标签添加到您的 HTML 中即可。\\n      </p>\\n      <div className=\\\"code-content\\\">\\n        <div className=\\\"code-container\\\">\\n          <span className=\\\"normal\\\">&lt;</span>\\n          <span className=\\\"tagColor\\\">script&nbsp;</span>\\n          <span className=\\\"light\\\" style={{ whiteSpace: \'nowrap\' }}>\\n            src=\'https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/Sparkbot.js\'\\n            <span className=\\\"normal\\\">&gt;</span>\\n            <span className=\\\"normal\\\">&lt;/</span>\\n            <span className=\\\"tagColor\\\">script</span>\\n            <span className=\\\"normal\\\"> &gt;</span>\\n          </span>\\n          <br></br>\\n          <span className=\\\"normal\\\">&lt;</span>\\n          <span className=\\\"tagColor\\\">script</span>\\n          <span className=\\\"normal\\\"> &gt;</span>\\n          <br></br>\\n          <span style={{ marginLeft: 10 }}>Sparkbot</span>\\n          <span className=\\\"normal\\\">.</span>\\n          <span className=\\\"tagColor\\\">init</span>\\n          <span className=\\\"normal\\\">(&#123;</span>\\n          <br></br>\\n          <span className=\\\"light\\\" style={{ marginLeft: 20 }}>\\n            appId: \'您的appId\',\\n            <br></br>\\n            <span style={{ marginLeft: 20 }}>apiKey: \'您的apiKey\',</span>\\n            <br></br>\\n            <span style={{ marginLeft: 20 }}>apiSecret: \'您的apiSecret\'</span>\\n            <br></br>\\n          </span>\\n          <span className=\\\"normal\\\" style={{ marginLeft: 10 }}>\\n            &#125;)\\n          </span>\\n          <br></br>\\n          <span className=\\\"normal\\\">&lt;/</span>\\n          <span className=\\\"tagColor\\\">script</span>\\n          <span className=\\\"normal\\\"> &gt;</span>\\n        </div>\\n      </div>\\n    </div>\",\"sdkMd\":\"/pro-bucket/sparkBot/README.md\"}', 1, '', '2000-01-01 00:00:00', '2024-06-27 10:35:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1027, 'FILE_MANAGE_CONFIG', '', 'MAX_FOLDER_DEEP', '5', 1, '用于控制文件目录树的最大层级', '2000-01-01 00:00:00', '2024-06-27 10:35:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1029, 'SPARKBOT_DEFAULT_APP', '1', 'sparkbot默认应用', '{\"name\":\"SparkBot默认应用\",\"description\":\"SparkBot默认创建的应用\",\"businessInfo\":{\"applyUserSource\":1,\"applyUserCode\":\"system\",\"applyUserDepart\":\"AI应用平台研发部\",\"groupName\":\"核心研发平台\",\"groupId\":1003,\"productName\":\"AI应用平台研发部\",\"productId\":10213},\"isLocalAuth\":0}', 1, '', '2000-01-01 00:00:00', '2025-02-19 15:08:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1031, 'SPARKBOT_DEFAULT_RELATION_CAPACITY', '1', 'sparkbot应用默认关联的能力', '{\"largeModelId\":99,\"name\":\"通用大模型\",\"type\":1}', 1, '', '2000-01-01 00:00:00', '2023-12-05 20:32:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1033, 'SPARKBOT_DEFAULT_APPLY_INFO', '1', '外部用户Spartbot平台默认申请', '{\"account\":\"xxzhang23\",\"accountName\":\"张想信\",\"departmentInfo\":\"AI工程院飞云平台产品部\",\"describe\":\"外部用户Spartbot平台默认申请\",\"superiorInfo\":\"xxzhang23\",\"largeModel\":\"通用大模型\",\"domain\":\"general\"}', 1, '', '2000-01-01 00:00:00', '2023-12-05 20:32:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1035, 'BOT_COUNT_LIMIT', '1', '10', '用户创建bot数已达上限', 1, '', '2000-01-01 00:00:00', '2023-12-06 13:30:51');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1037, 'TEXT_GENERATION_MODELS', '1', 'spark', '讯飞星火', 1, '', '2000-01-01 00:00:00', '2023-12-10 14:40:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1039, 'MODEL_DEFAULT_CONFIGS', 'spark', 'spark模型默认配置', '[{\"key\":\"temperature\",\"nmae\":\"随机性\",\"min\":0,\"max\":2,\"default\":1,\"enabled\":true},{\"key\":\"max_tokens\",\"nmae\":\"单次回复限制\",\"min\":10,\"max\":1000,\"default\":256,\"enabled\":true}]', 1, '', '2000-01-01 00:00:00', '2023-12-10 15:04:22');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1041, 'DEFAULT_SLICE_RULES', '1', '默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2000-01-01 00:00:00', '2024-06-20 20:09:51');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1043, 'CUSTOM_SLICE_RULES', '1', '自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2000-01-01 00:00:00', '2024-06-20 20:09:54');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1045, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1047, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1049, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1051, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1053, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1055, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1057, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_16@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1059, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_17@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1061, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_18@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1063, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_19@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1065, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1067, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_20@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1069, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_21@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1071, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_22@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1073, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_23@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1075, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_24@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1077, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_25@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1079, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_26@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1081, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_27@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1083, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_28@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1085, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_29@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1087, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1089, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_30@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1091, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_31@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1093, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_32@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1095, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_33@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1097, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_34@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1099, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_35@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1101, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_36@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1103, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_37@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1105, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_38@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1107, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_39@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1109, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1111, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_40@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1113, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_41@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1115, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_42@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1117, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1119, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1121, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1123, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1125, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1127, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1133, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1135, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1137, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1139, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1141, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1143, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1145, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1147, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1149, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1151, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1153, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1155, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1157, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1159, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1161, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1163, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1165, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1167, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1169, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1171, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1173, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1175, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1177, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1179, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1181, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1183, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1185, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1187, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1189, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1191, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1193, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1195, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1197, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1199, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1201, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1203, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1205, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1207, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1209, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1211, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1213, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1215, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1217, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1219, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:21');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1221, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:21');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1223, 'COLOR', '1', '#FFEAD5', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:37');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1225, 'COLOR', '1', '#E7FFD5', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1227, 'COLOR', '1', '#D5FFED', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1229, 'COLOR', '1', '#D5E8FF', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1231, 'COLOR', '1', '#DDD5FF', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1233, 'COLOR', '1', '#FFD5E2', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1235, 'COLOR', '1', '#DCDEE8', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1237, 'COLOR', '1', '#ECEEF6', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1239, 'DEFAULT_BOT_MODEL_CONFIG', '1', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"model\":{\"name\":\"spark_V3.5\",\"model\":\"spark_V3.5\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-04-25 15:36:43');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1243, 'TOOL_ICON', 'tool', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/tool/tool01.png', 1, '', '2000-01-01 00:00:00', '2024-01-23 17:42:52');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1245, 'TOOL_ICON', 'tool', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/tool/tool02.png', 1, '', '2000-01-01 00:00:00', '2024-01-23 17:42:52');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1247, 'OPEN_API_REPO_APPID', '1', '开发接口过滤知识库ID新增APPID', '453f52a2', 1, '', '2000-01-01 00:00:00', '2024-05-21 16:18:27');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1249, 'INNER_BOT', '1', '就餐助手', '{\"name\":\"就餐助手\",\"code\":1,\"description\":\"就餐助手\",\"avatarIcon\":\"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\"requestData\":{\"appid\":\"5d29ff2f\",\"bot_id\":\"69027824b6eb4558a4e39060967ea87b\",\"question\":\"\",\"upstream_kwargs\":{\"432517259949379584\":{\"callType\":\"pc\",\"userAccount\":\"qcliu\"}}},\"examples\":[\"今天有什么菜？\",\"今天的菜有土豆吗？\",\"明天有什么吃的？\"]}', 0, '', '2000-01-01 00:00:00', '2024-05-13 16:17:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1251, 'MODEL_LIST', 'spark_V3', '星火大模型3.0', '', 1, '', '2000-01-01 00:00:00', '2024-04-18 15:30:31');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1253, 'MODEL_LIST', 'spark_V3.5', '星火大模型3.5', '', 1, '', '2000-01-01 00:00:00', '2024-04-18 15:30:23');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1255, 'INNER_BOT', '2', '生活助手', '{\r\n    \"name\": \"生活助手\",\r\n    \"code\": 2,\r\n    \"description\": \"生活助手\",\r\n    \"avatarIcon\": \"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\r\n    \"requestData\": {\r\n        \"appid\": \"5d29ff2f\",\r\n        \"bot_id\": \"ae43a8b628d343d89f1cef5c4c0248a7\",\r\n        \"question\": \"\",\r\n        \"upstream_kwargs\": {\r\n            \"420914424866541568\": {\r\n                \"callType\": \"pc\",\r\n                \"userAccount\": \"qcliu\"\r\n            }\r\n        }\r\n    },\r\n    \"examples\": [\r\n        \"帮我搜一下安徽风景好的景点 \",\r\n        \"查一下明天的天气情况\",\r\n        \"到南京的高铁多少钱\"\r\n    ]\r\n}', 1, '', '2000-01-01 00:00:00', '2024-05-13 17:56:47');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1257, 'INNER_BOT', '3', '工作助手', '{\"name\":\"工作助手\",\"code\":3,\"description\":\"工作助手\",\"avatarIcon\":\"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\"requestData\":{\"appid\":\"5d29ff2f\",\"bot_id\":\"1075c67f3cfb4bb58df09dc7475851b8\",\"question\":\"\",\"upstream_kwargs\":{\"420914424866541568\":{\"callType\":\"pc\",\"userAccount\":\"qcliu\"}}},\"examples\":[\"帮我生成一个ppt\",\"帮我生成一份简历 \",\"帮我生成一个思维导图\"]}', 0, '', '2000-01-01 00:00:00', '2024-05-13 16:19:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1259, 'AUTH_APPLY', 'RECEIVER_EMAIL', '', 'yachen11@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2024-05-12 16:06:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1261, 'AUTH_APPLY', 'COPE_USER_EMAIL', NULL, 'yxyan@iflytek.com,leifang10@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2025-03-27 16:28:38');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1263, 'AUTH_APPLY', 'RECEIVER_ERROR_EMAIL', NULL, 'tctan@iflytek.com', 1, NULL, '2023-06-28 10:50:48', '2024-04-29 17:35:39');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1265, 'LLM', 'domain-open', '开源模型domain', 'xscnllama38bi,llama3-70b-instruct,qwen-7b-instruct', 1, NULL, '2000-01-01 00:00:00', '2024-07-25 10:36:06');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1267, 'LLM', 'domain', 'Spark3.5 Max', 'generalv3.5', 1, 'bm3.5', '2000-01-01 00:00:00', '2024-07-03 16:23:39');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1269, 'LLM', 'domain', 'Spark Pro', 'generalv3', 1, 'bm3', '2000-01-01 00:00:00', '2024-07-03 16:23:35');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1271, 'LLM', 'domain', 'Spark Lite', 'general', 1, 'cbm', '2000-01-01 00:00:00', '2024-07-03 16:23:26');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1273, 'LLM_CHANNEL_DOMAIN', 'cbm', 'Spark Lite', 'general', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1275, 'LLM_CHANNEL_DOMAIN', 'bm3', 'Spark Pro', 'generalv3', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1277, 'LLM_CHANNEL_DOMAIN', 'bm3.5', 'Spark3.5 Max', 'generalv3.5', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1279, 'LLM_DOMAIN_CHANNEL', 'general', 'Spark Lite', 'cbm', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:58');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1281, 'LLM_DOMAIN_CHANNEL', 'generalv3', 'Spark Pro', 'bm3', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:58');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1283, 'LLM_DOMAIN_CHANNEL', 'generalv3.5', 'Spark3.5 Max', 'bm3.5', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:58');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1285, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3', '默认模型配置', '{\r\n    \"modelConfig\": {\r\n        \"prePrompt\": \"\",\r\n        \"userInputForm\": [],\r\n        \"speechToText\": {\r\n            \"enabled\": false\r\n        },\r\n        \"suggestedQuestionsAfterAnswer\": {\r\n            \"enabled\": false\r\n        },\r\n        \"retrieverResource\": {\r\n            \"enabled\": false\r\n        },\r\n        \"conversationStarter\": {\r\n            \"enabled\": false,\r\n            \"openingRemark\": \"\"\r\n        },\r\n        \"feedback\": {\r\n            \"enabled\": false,\r\n            \"like\": {\r\n                \"enabled\": false\r\n            },\r\n            \"dislike\": {\r\n                \"enabled\": false\r\n            }\r\n        },\r\n        \"model\": {\r\n            \"domain\": \"generalv3\",\r\n            \"model\": \"generalv3\",\r\n            \"completionParams\": {\r\n                \"maxTokens\": 512,\r\n                \"temperature\": 0.5,\r\n                \"topK\": 1\r\n            },\r\n            \"api\": \"wss://spark-api.xf-yun.com/v3.1/chat\",\r\n            \"llmId\": 3,\r\n            \"llmSource\": 1,\r\n            \"patchId\": [\r\n                \"0\"\r\n            ]\r\n        },\r\n        \"repoConfigs\": {\r\n            \"topK\": 3,\r\n            \"scoreThreshold\": 0.3,\r\n            \"scoreThresholdEnabled\": true,\r\n            \"reposet\": []\r\n        }\r\n    }\r\n}', 0, '', '2000-01-01 00:00:00', '2024-06-26 17:54:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1287, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3.5', '默认模型配置', '{\r\n    \"modelConfig\": {\r\n        \"prePrompt\": \"\",\r\n        \"userInputForm\": [],\r\n        \"speechToText\": {\r\n            \"enabled\": false\r\n        },\r\n        \"suggestedQuestionsAfterAnswer\": {\r\n            \"enabled\": false\r\n        },\r\n        \"retrieverResource\": {\r\n            \"enabled\": true\r\n        },\r\n        \"conversationStarter\": {\r\n            \"enabled\": false,\r\n            \"openingRemark\": \"\"\r\n        },\r\n        \"feedback\": {\r\n            \"enabled\": true,\r\n            \"like\": {\r\n                \"enabled\": true\r\n            },\r\n            \"dislike\": {\r\n                \"enabled\": true\r\n            }\r\n        },\r\n        \"model\": {\r\n            \"domain\": \"generalv3.5\",\r\n            \"model\": \"generalv3.5\",\r\n            \"completionParams\": {\r\n                \"maxTokens\": 512,\r\n                \"temperature\": 0.5,\r\n                \"topK\": 1\r\n            },\r\n            \"api\": \"wss://spark-api.xf-yun.com/v3.5/chat\",\r\n            \"llmId\": 5,\r\n            \"llmSource\": 1,\r\n            \"patchId\": [\r\n                \"0\"\r\n            ]\r\n        },\r\n        \"repoConfigs\": {\r\n            \"topK\": 3,\r\n            \"scoreThreshold\": 0.4,\r\n            \"scoreThresholdEnabled\": true,\r\n            \"reposet\": []\r\n        }\r\n    }\r\n}', 0, '', '2000-01-01 00:00:00', '2024-06-26 17:54:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1289, 'DEFAULT_BOT_MODEL_CONFIG', 'general', '默认模型配置', '{\r\n    \"modelConfig\": {\r\n        \"prePrompt\": \"\",\r\n        \"userInputForm\": [],\r\n        \"speechToText\": {\r\n            \"enabled\": false\r\n        },\r\n        \"suggestedQuestionsAfterAnswer\": {\r\n            \"enabled\": false\r\n        },\r\n        \"retrieverResource\": {\r\n            \"enabled\": false\r\n        },\r\n        \"conversationStarter\": {\r\n            \"enabled\": false,\r\n            \"openingRemark\": \"\"\r\n        },\r\n        \"feedback\": {\r\n            \"enabled\": false,\r\n            \"like\": {\r\n                \"enabled\": false\r\n            },\r\n            \"dislike\": {\r\n                \"enabled\": false\r\n            }\r\n        },\r\n        \"model\": {\r\n            \"domain\": \"general\",\r\n            \"model\": \"general\",\r\n            \"completionParams\": {\r\n                \"maxTokens\": 512,\r\n                \"temperature\": 0.5,\r\n                \"topK\": 1\r\n            },\r\n            \"api\": \"wss://spark-api.xf-yun.com/v1.1/chat\",\r\n            \"llmId\": 1,\r\n            \"llmSource\": 1,\r\n            \"patchId\": [\r\n                \"0\"\r\n            ]\r\n        },\r\n        \"repoConfigs\": {\r\n            \"topK\": 3,\r\n            \"scoreThreshold\": 0.3,\r\n            \"scoreThresholdEnabled\": true,\r\n            \"reposet\": []\r\n        }\r\n    }\r\n}', 0, '', '2000-01-01 00:00:00', '2024-06-26 17:54:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1291, 'TEMPLATE', 'prompt-enhance', '1', '你是一个prompt优化大师，你会得到一个助手的名字和简单描述，你需要根据这些信息，为助手生成一个合适的角色描述、详细的技能说明、相关约束信息，输出为markdown格式。你需要按照以下格式进行组织输出内容：\r\n``````markdown\r\n## 角色\r\n你是一个[助手的角色]，[助手的角色描述]。\r\n\r\n## 技能\r\n1. [技能 1 的描述]：\r\n  - [技能 1 的具体内容]。\r\n  - [技能 1 的具体内容]。\r\n2. [技能 2 的描述]：\r\n  - [技能 2 的具体内容]。\r\n  - [技能 2 的具体内容]。\r\n\r\n## 限制\r\n- [限制 1 的描述]。\r\n- [限制 2 的描述]。\r\n``````\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入：\r\n助手名字: 金融分析助手\r\n助手描述: 1. 分析上市公司最新的年报财报；2. 获取上市公司的最新新闻；\r\n\r\n输出：\r\n``````markdown\r\n## 角色\r\n你是一个金融分析师，会利用最新的信息和数据来分析公司的财务状况、市场趋势和行业动态，以帮助客户做出明智的投资决策。\r\n\r\n## 技能\r\n1. 分析上市公司最新的年报财报：\r\n  - 使用财务分析工具和技巧，对公司的财务报表进行详细的分析和解读。\r\n  - 评估公司的财务健康状况，包括营收、利润、资产负债表、现金流量等方面。\r\n  - 分析公司的财务指标，如利润率、偿债能力、周转率等，以评估其盈利能力和风险水平。\r\n  - 比较公司的财务表现与同行业其他公司的平均水平，以评估其相对竞争力。\r\n2. 获取上市公司的最新新闻：\r\n  - 使用新闻来源和数据库，定期获取上市公司的最新新闻和公告。\r\n  - 分析新闻对公司股价和投资者情绪的潜在影响。\r\n  - 关注公司的重大事件，如合并收购、产品发布、管理层变动等，以及这些事件对公司未来发展的影响。\r\n  - 结合财务分析和新闻分析，提供对公司的综合评估和投资建议。\r\n\r\n## 限制\r\n- 只讨论与金融分析相关的内容，拒绝回答与金融分析无关的话题。\r\n- 所有的输出内容必须按照给定的格式进行组织，不能偏离框架要求。\r\n- 分析部分不能超过 100 字。\r\n``````\r\n\r\n示例2：\r\n输入：\r\n助手名字: 前端开发助手\r\n助手描述: 你的角色是前端开发，能帮助我把图片制作成html页面，css使用tailwind.css，ui库使用antd\r\n\r\n输出：\r\n``````markdown\r\n# 角色\r\n你是一个前端开发工程师，可以使用 HTML、CSS 和 JavaScript 等技术构建网站和应用程序。\r\n\r\n## 技能\r\n1. 将图片制作成 HTML 页面\r\n  - 当用户需要将图片制作成 HTML 页面时，你可以根据用户提供的图片和要求，使用 HTML 和 CSS 等技术构建一个页面。\r\n  - 在构建页面时，你可以使用 Tailwind CSS 来简化 CSS 样式的编写，并使用 Antd 库来提供丰富的 UI 组件。\r\n  - 构建完成后，你可以将页面代码返回给用户，以便用户可以将其部署到服务器上或在本地查看。\r\n\r\n2. 提供前端开发相关的建议和帮助\r\n  - 当用户需要前端开发相关的建议和帮助时，你可以根据用户的问题，提供相关的建议和帮助。\r\n  - 你可以提供关于 HTML、CSS、JavaScript 等前端技术的建议和帮助，也可以提供关于前端开发工具和流程的建议和帮助。\r\n\r\n## 限制\r\n- 只讨论与前端开发相关的内容，拒绝回答与前端开发无关的话题。\r\n- 所输出的内容必须按照给定的格式进行组织，不能偏离框架要求。\r\n``````\r\n\r\n输入：\r\n助手名字: {assistant_name}\r\n助手描述: {assistant_description}\r\n\r\n输出：\r\n', 1, NULL, '2000-01-01 00:00:00', '2024-05-11 21:52:12');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1293, 'TEMPLATE', 'next-question-advice', '1', '现在你需要根据问题生成用户可能就这个问题提出的三个后续问题，回答的数据格式为json array，下面是一些问题和回答的例子\r\n\r\n问题：我饿了\r\n回答：[\'最近有什么餐厅\',\'推荐一点好吃的\',\'推荐一下附近的小吃\']\r\n\r\n现在根据下述问题给出回答\r\n问题：{q}\r\n回答：', 1, NULL, '2000-01-01 00:00:00', '2024-06-22 15:19:34');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1295, 'LLM', 'domain-filter', '货架过滤器-domain维度', 'general,generalv3,generalv3.5,xscnllama38bi', 1, '', '2000-01-01 00:00:00', '2024-05-29 14:25:52');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1297, 'LLM', 'function-call', 'true', 'generalv3.5', 1, '', '2000-01-01 00:00:00', '2024-06-07 15:30:54');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1299, 'LLM', 'function-call', 'false', 'xscnllama38bi,xsfalcon7b,general,generalv3', 1, '', '2000-01-01 00:00:00', '2024-06-07 15:30:50');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1301, 'DOCUMENT_LINK', 'SparkBotHelpDoc', '1', 'https://experience.pro.iflyaicloud.com/aicloud-sparkbot-doc/', 1, '', '2023-08-17 00:00:00', '2023-09-19 14:55:17');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1303, 'LLM', 'serviceId-filter', '货架过滤器-serviceId维度', 'cbm,bm3,bm3.5,xscnllama38bi,xsfalcon7b,xsc4aicr35b', 1, '', '2000-01-01 00:00:00', '2024-06-22 14:43:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1305, 'SPECIAL_USER', '1', '特殊用户，目前包括段明，豪哥，天诚', '1909,2229,1695', 1, NULL, '2000-01-01 00:00:00', '2024-06-27 10:35:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1309, 'LLM', 'question-type', '', 'general,generalv3', 1, '', '2000-01-01 00:00:00', '2024-06-13 19:25:39');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1311, 'PROMPT', 'judge-is-bot-create', '判断是否是创建bot的prompt', 'system_template = \"\"\"你是一个Bot创建判定助手，你需要根据用户的输入信息，来判断用户是否要创建或者声明bot助手。输出格式如下：\r\n{\r\n    \"isCreateBot\": \"true/false\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\n你是一个海报生成助手\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\r\n示例2：\r\n输入:\r\n你好\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"false\"\r\n}\r\n\r\n示例3：\r\n输入:\r\n你是一个天气查询助手，可以帮我查询天气\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\r\n示例4：\r\n输入:\r\n帮我创建一个前端开发助手\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\"\"\"\r\n\r\n\r\nhuman_template = f\"\"\"\r\n输入:\r\n{content}\r\n\r\n根据上述输入判断是否要创建或声明bot助手:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2024-06-11 19:52:55');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1313, 'PROMPT', 'bot-name-desc', '', '你是一个名字生成和描述生成助手，你会得到用户关于助手的描述，你需要根据这些信息，为助手生成一个合适的名字和角色描述。输出格式如下，数据结构为标准的json格式：\r\n{\r\n    \"name\": \"助手的名字\",\r\n    \"desc\": \"助手的描述\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\n你是一个海报生成助手\r\n\r\n根据上述输入的描述生成名字和角色描述:\r\n{\r\n    \"name\": \"海报生成助手\",\r\n    \"desc\": \"海报生成助手可以根据用户的需求和喜好，快速生成各种风格和主题的海报。无论是商业广告、活动宣传还是个人用途，海报生成助手都能提供满意的解决方案。\"\r\n}\r\n\r\n示例2：\r\n输入:\r\n你是一个天气查询助手，能够查询指定城市指定日期的天气\r\n\r\n根据上述输入的描述生成名字和角色描述:\r\n{\r\n    \"name\": \"天气查询助手\",\r\n    \"desc\": \"天气查询助手能够准确查询指定城市在指定日期的天气情况。只需输入城市名和日期，天气查询助手都能提供详细的天气预报信息。\"\r\n}\r\n\r\n\r\n示例3：\r\n输入:\r\n创建一个前端开发助手\r\n\r\n根据上述输入的描述生成名字和角色描述:\r\n{\r\n    \"name\": \"前端开发助手\",\r\n    \"desc\": \"一个专门为前端开发提供帮助的助手，可以帮助用户解决各种前端开发的问题，包括但不限于HTML、CSS、JavaScript等。\"\r\n}\r\n\r\n输入:\r\n{content}\r\n\r\n根据上述输入的描述生成名字和角色描述:\r\n', 1, NULL, '2000-01-01 00:00:00', '2024-05-31 14:37:04');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1315, 'PROMPT', 'bot-name-desc-prompt', '', '你是一个名字生成和描述生成和prompt优化助手，你会得到用户关于助手的描述，你需要根据这些信息，为助手生成一个合适的名字和角色描述，以及为助手生成一个markdown格式的合适的角色描述、详细的技能说明、相关约束信息的提示词。输出格式如下，数据结构为标准的json格式：\r\n{\r\n    \"name\": \"助手的名字\",\r\n    \"desc\": \"助手的描述\",\r\n    \"prompt\": \"``````markdown\r\n## 角色\r\n你是一个[助手的角色]，[助手的角色描述]。\r\n\r\n## 技能\r\n1. [技能 1 的描述]：\r\n  - [技能 1 的具体内容]。\r\n  - [技能 1 的具体内容]。\r\n2. [技能 2 的描述]：\r\n  - [技能 2 的具体内容]。\r\n  - [技能 2 的具体内容]。\r\n\r\n## 限制\r\n- [限制 1 的描述]。\r\n- [限制 2 的描述]。\r\n``````\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\n你是一个金融分析助手，能够分析上市公司最新的年报财报和获取上市公司的最新新闻\r\n\r\n根据上述输入的描述生成名字、角色描述和提示词:\r\n{\r\n    \"name\": \"金融分析助手\",\r\n    \"desc\": \"金融分析助手专注于分析上市公司的最新年报财报，以及获取和整理上市公司的最新新闻。无论是投资者、分析师还是对金融市场感兴趣的个人，都能通过这个助手获得有价值的信息和深入的分析。\"\r\n    \"prompt\": \"``````markdown\r\n## 角色\r\n你是一个金融分析助手，专注于为投资者、分析师以及对金融市场感兴趣的个人提供上市公司的最新年报财报分析和最新新闻整理。通过深入的数据分析和市场动态追踪，你帮助用户做出更加明智的投资决策。\r\n\r\n## 技能\r\n1. 分析上市公司最新的年报财报：\r\n  - 利用专业的财务分析工具，对上市公司的年度财务报表进行详细解读，包括但不限于利润表、资产负债表和现金流量表。\r\n  - 评估公司的盈利能力、资产负债结构、现金流状况及财务健康度，识别潜在的财务风险和机会。\r\n  - 对比分析公司与同行业其他竞争者的财务表现，揭示公司在行业中的竞争地位。\r\n  - 基于财务数据，提供对公司未来发展趋势的预测和建议。\r\n2. 获取和整理上市公司的最新新闻：\r\n  - 实时监控和收集来自各大新闻源、社交媒体和公司公告的上市公司相关新闻。\r\n  - 筛选和整理关键信息，如重大事件、管理层变动、新产品发布等，评估这些新闻对公司股价和市场情绪的可能影响。\r\n  - 结合财报分析结果和最新新闻，为用户提供全面、多角度的市场洞察。\r\n  - 定期更新信息，确保用户能够获得最新的市场动态和公司发展情况。\r\n\r\n## 限制\r\n- 只提供与上市公司财务分析和市场新闻相关的信息和分析，不涉及非上市公司或个别股票的具体投资建议。\r\n- 所有分析内容均基于公开可获得的数据和信息，不包含内幕信息或未公开数据。\r\n- 分析结果仅供参考，用户应结合自己的判断和风险承受能力做出投资决策。\r\n``````\"\r\n}\r\n\r\n示例2：\r\n输入:\r\n你是一个天气查询助手，能够查询指定城市指定日期的天气\r\n\r\n根据上述输入的描述生成名字、角色描述和提示词:\r\n{\r\n    \"name\": \"天气查询助手\",\r\n    \"desc\": \"天气查询助手能够准确查询指定城市在指定日期的天气情况。只需输入城市名和日期，天气查询助手都能提供详细的天气预报信息。\"\r\n    \"prompt\": \"``````markdown\r\n## 角色\r\n你是一个天气查询专家，能够提供准确且详细的天气预报信息。\r\n\r\n## 技能\r\n1. 查询指定城市在指定日期的天气情况：\r\n  - 当用户提供城市名和日期时，你可以查询并返回该城市在该日期的详细天气预报信息。\r\n  - 提供的天气预报信息包括但不限于温度、湿度、风速、风向、降水概率等。\r\n  - 你还可以提供当天的日出和日落时间，以及月相信息。\r\n2. 分析天气变化趋势：\r\n  - 根据历史和实时数据，分析并预测未来几天的天气变化趋势。\r\n  - 提供穿衣、出行等生活建议，帮助用户根据天气变化做出合理安排。\r\n\r\n## 限制\r\n- 只讨论与天气查询相关的内容，拒绝回答与天气无关的话题。\r\n- 所有的输出内容必须按照给定的格式进行组织，不能偏离框架要求。\r\n- 只能提供到指定日期的天气预报，无法预测超过该日期的天气情况。\r\n``````\"\r\n}\r\n\r\n\r\n示例3：\r\n输入:\r\n你是一个前端开发助手\r\n\r\n根据上述输入的描述生成名字、角色描述和提示词:\r\n{\r\n    \"name\": \"前端开发助手\",\r\n    \"desc\": \"一个专门为前端开发提供帮助的助手，可以帮助用户解决各种前端开发的问题，包括但不限于HTML、CSS、JavaScript等。\"\r\n    \"prompt\": \"``````markdown\r\n## 角色\r\n你是一个前端开发助手，专门为前端开发者提供帮助和解决方案。无论是HTML、CSS还是JavaScript的问题，你都能提供专业的指导和支持。\r\n\r\n## 技能\r\n1. HTML问题解答：\r\n  - 当用户遇到HTML相关的问题时，你可以提供详细的解答和解决方案。\r\n  - 你可以帮助用户理解HTML的基础知识，如标签、属性、文档结构等。\r\n  - 你还可以提供关于HTML5新特性的相关信息和使用方法。\r\n2. CSS问题解答：\r\n  - 当用户遇到CSS相关的问题时，你可以提供详细的解答和解决方案。\r\n  - 你可以帮助用户理解CSS的基础知识，如选择器、盒模型、布局方式等。\r\n  - 你还可以提供关于CSS3新特性的相关信息和使用方法。\r\n3. JavaScript问题解答：\r\n  - 当用户遇到JavaScript相关的问题时，你可以提供详细的解答和解决方案。\r\n  - 你可以帮助用户理解JavaScript的基础知识，如变量、函数、对象、数组等。\r\n  - 你还可以提供关于JavaScript高级主题的相关信息和使用方法，如闭包、原型链、异步编程等。\r\n4. 前端开发工具的使用：\r\n  - 当用户需要使用前端开发工具时，你可以提供相关的指导和建议。\r\n  - 你可以帮助用户理解和使用各种前端开发工具，如版本控制系统（如Git）、包管理器（如npm）、构建工具（如Webpack）等。\r\n\r\n## 限制\r\n- 只讨论与前端开发相关的内容，拒绝回答与前端开发无关的话题。\r\n- 所有的输出内容必须按照给定的格式进行组织，不能偏离框架要求。\r\n``````\"\r\n}\r\n\r\n输入:\r\n{content}\r\n\r\n根据上述输入的描述生成名字、角色描述和提示词:', 1, NULL, '2000-01-01 00:00:00', '2024-05-31 14:33:10');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1317, 'PROMPT', 'bot-prologue-question', '', '你是一个生成开场白和预置问题的助手。接下来，你会收到一段关于任务助手的描述，你需要带入描述中的角色，以描述中的角色身份生成一段开场白，同时你还需要站在用户的角度生成几个用户可能的提问。输出格式如下，数据结构为标准的json格式：\r\n{\r\n    \"prologue\": \"开场白内容\",\r\n    \"question\": [\"问题1\", \"问题2\", \"问题3\"]\r\n}\r\n\r\n下面是一些示例\r\n例子1: \r\n输入描述:\r\n# 角色\r\n你是一个可以帮助用户在家赚钱的机器人，你可以提供各种赚钱的途径和方法，帮助用户实现财务自由。\r\n\r\n## 技能\r\n### 技能 1: 提供赚钱途径\r\n1. 当用户需要赚钱途径时，你可以根据用户的兴趣、技能和时间等因素，提供一些适合在家赚钱的途径和方法，如网络兼职、自媒体创作、电商创业等。\r\n2. 你需要向用户详细介绍每种途径的操作流程、注意事项和收益情况等，以便用户做出选择。\r\n3. 你还可以根据用户的需求和情况，提供一些个性化的建议和指导，帮助用户更好地开展赚钱活动。\r\n\r\n### 技能 2: 提供赚钱技巧\r\n1. 当用户需要赚钱技巧时，你可以向用户提供一些实用的赚钱技巧，如如何提高工作效率、如何节省成本、如何增加收入等。\r\n2. 你需要向用户详细介绍每种技巧的操作方法和注意事项，以便用户能够正确地运用这些技巧。\r\n3. 你还可以根据用户的需求和情况，提供一些个性化的建议和指导，帮助用户更好地实现财务自由。\r\n\r\n### 技能 3: 提供创业指导\r\n1. 当用户需要创业指导时，你可以向用户提供一些创业的基本知识和方法，如如何选择创业项目、如何制定创业计划、如何筹集创业资金等。\r\n2. 你需要向用户详细介绍每种方法的操作流程和注意事项，以便用户能够正确地开展创业活动。\r\n3. 你还可以根据用户的需求和情况，提供一些个性化的建议和指导，帮助用户更好地实现创业目标。\r\n\r\n## 限制\r\n- 只讨论与赚钱有关的内容，拒绝回答与赚钱无关的话题。\r\n- 所输出的内容必须按照给定的格式进行组织，不能偏离框架要求。\r\n\r\n根据上述输入的描述生成开场白和预置问题:\r\n{\r\n    \"prologue\": \"你好，我是一个可以帮助你在家赚钱的机器人，很高兴认识你。\",\r\n    \"question\": [\"如何使用你的服务来在家赚钱?\", \"你能提供哪些在家赚钱的建议和技巧?\", \"你的服务如何帮助我实现财务自由?\"]\r\n}\r\n\r\n\r\n例子2: \r\n输入描述:\r\n# 角色：Excel全能助手\r\n## 个人简介\r\n- 版本：1.0\r\n- 语言：中文\r\n- 描述：我是一名Excel全能助手，专注于帮助用户解决Excel相关的问题和提供高效的数据处理方案。\r\n\r\n## 功能特点\r\n- 数据处理：熟练掌握Excel的各种数据处理功能，包括筛选、排序、合并、拆分、透视表等，能够帮助用户快速处理大量数据。\r\n- 公式应用：精通Excel的各种常用公式和函数，能够帮助用户进行复杂的数据计算和分析，提供准确的结果。\r\n- 数据可视化：熟悉Excel的图表功能，能够帮助用户将数据以直观的方式展示，制作出美观、清晰的图表。\r\n- 自动化操作：了解Excel的宏和VBA编程，能够帮助用户实现自动化操作，提高工作效率。\r\n\r\n## 使用指南\r\n1. 数据处理：\r\n   - 使用筛选功能，快速筛选出符合条件的数据。\r\n   - 利用排序功能，对数据进行升序或降序排列。\r\n   - 使用合并和拆分功能，将多个单元格合并为一个或将一个单元格拆分为多个。\r\n   - 利用透视表功能，对大量数据进行汇总和分析。\r\n\r\n2. 公式应用：\r\n   - 使用常用公式，如SUM、AVERAGE、MAX、MIN等，进行数据计算。\r\n   - 利用逻辑函数，如IF、AND、OR等，进行条件判断和逻辑运算。\r\n   - 使用VLOOKUP和HLOOKUP函数，进行数据查找和匹配。\r\n   - 利用COUNTIF和SUMIF函数，进行条件统计和求和。\r\n\r\n3. 数据可视化：\r\n   - 利用图表功能，选择合适的图表类型，如柱状图、折线图、饼图等，展示数据。\r\n   - 调整图表的样式和布局，使其更加美观和易读。\r\n   - 添加数据标签和图例，增加图表的信息量和可读性。\r\n\r\n4. 自动化操作：\r\n   - 利用宏录制功能，记录一系列操作步骤，实现自动化操作。\r\n   - 使用VBA编程，编写自定义的宏，实现更复杂的自动化操作。\r\n   - 将宏和VBA代码应用到Excel工作簿中，提高工作效率和准确性。\r\n\r\n## 使用建议\r\n- 熟悉Excel的快捷键和常用操作，可以提高工作效率。\r\n- 在处理大量数据时，先备份原始数据，以防误操作导致数据丢失。\r\n- 学习和掌握Excel的高级功能和技巧，可以更好地应对复杂的数据处理需求。\r\n- 及时保存和备份Excel文件，以防止意外情况导致数据丢失。\r\n\r\n根据上述输入的描述生成开场白和预置问题:\r\n{\r\n    \"prologue\": \"你好，我是一名Excel全能助手，可以帮助你解决Excel相关的问题和提供高效的数据处理方案。\",\r\n    \"question\": [\"如何快速处理大量数据?\", \"如何使用Excel进行复杂的数据计算和分析?\", \"如何将数据以直观的方式展示，制作出美观、清晰的图表?\"]\r\n}\r\n\r\n你必须使用上述格式输出结果。\r\n\r\n输入描述:\r\n{content}\r\n\r\n根据上述输入的描述生成开场白和预置问题:', 1, NULL, '2000-01-01 00:00:00', '2024-05-31 14:36:26');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1319, 'INNER_BOT', 'interact', '交互式创建', '{\"name\":\"就餐助手\",\"code\":1,\"description\":\"就餐助手\",\"avatarIcon\":\"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\"requestData\":{\"appid\":\"4d2e8665\",\"bot_id\":\"bedd1e25a11b41d487cc28f5de82695a\",\"question\":\"\",\"upstream_kwargs\":{\"420914424866541568\":{\"callType\":\"pc\",\"userAccount\":\"qcliu\"}}},\"examples\":[\"今天有什么菜？\",\"今天的菜有土豆吗？\",\"明天有什么吃的？\"]}', 1, '', '2000-01-01 00:00:00', '2024-05-31 11:09:23');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1321, 'DOCUMENT_LINK', 'ApiDoc', '1', 'https://in.iflyaicloud.com/aicloud-sparkbot-doc/Docx/04-Sparkbot%20API%EF%BC%88%E4%B8%93%E4%B8%9A%E7%89%88%EF%BC%89/1.2.9_workflow_api.html', 1, '', '2023-08-17 00:00:00', '2025-02-26 14:32:11');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1323, 'CONSULT', 'RECEIVER_EMAIL', '', 'rfge@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2024-06-24 10:04:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1325, 'CONSULT', 'COPE_USER_EMAIL', '', 'mkzhang4@iflytek.com,haojin@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2024-06-24 10:04:32');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1326, 'TAG', 'BOT_TAGS', '生活', '', 1, NULL, '2023-06-12 18:15:53', '2024-06-07 16:59:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1327, 'TAG', 'BOT_TAGS', '教育', '', 1, NULL, '2023-06-12 18:15:53', '2024-06-07 16:59:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1328, 'TAG', 'TOOL_TAGS', '生活', '', 0, NULL, '2023-06-12 18:15:53', '2024-06-13 23:29:11');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1329, 'TAG', 'TOOL_TAGS', '旅行', '', 0, NULL, '2023-06-12 18:15:53', '2024-06-13 23:29:11');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1331, 'PROMPT', 'bot-name-desc-response', '', 'system_template = \"\"\"你是一个Bot创建询问助手，你会得到用户创建bot的指令信息，你需要根据这些信息，生成助手的名称和描述以及对用户的回复。输出格式如下：\r\n{\r\n    \"name\": \"助手名称\",\r\n    \"description\": \"对助手的描述\",\r\n    \"response\": \"回复用户，然后询问助手的名称和描述是否满足要求，最后询问用户是否要创建这个bot\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\n创建一个PPT生成助手\r\n\r\n输出:\r\n{\r\n    \"name\": \"PPT 魔法助手\",\r\n    \"description\": \"这是一个能辅助你生成 PPT 的机器人\",\r\n    \"response\": \"好呀，我有个关于这个新机器人的建议。\r\n名称：PPT 魔法助手\r\n描述：这是一个能辅助你生成 PPT 的机器人。\r\n如果你同意这个名称和描述，我就开始创建这个机器人，不过这个过程大概需要 30 秒哦。请问你确认创建这个 PPT 魔法助手机器人吗？\"\r\n}\r\n\r\n示例2：\r\n输入:\r\n创建一个PPT生成助手\r\n\r\n输出:\r\n{\r\n    \"name\": \"天气小灵通\",\r\n    \"description\": \"能够为你提供准确天气信息的机器人\",\r\n    \"response\": \"好呀，我觉得可以叫“天气小灵通”，描述是“能够为你提供准确天气信息的机器人”。你觉得这个名字和描述可以吗？如果可以，我就开始创建这个机器人哦，但这个过程大概需要 30 秒。你确认创建这个“天气小灵通”机器人吗？\"\r\n}\r\n\r\n示例3：\r\n输入:\r\n创建一个文章生成助手\r\n\r\n输出:\r\n{\r\n    \"name\": \"创意文曲星\",\r\n    \"description\": \"能快速生成各类文章的智能助手\",\r\n    \"response\": \"那可以取名为“创意文曲星”，描述是“能快速生成各类文章的智能助手”。你觉得这个名字和描述符合你的需求吗？如果符合，我将为你创建这个“创意文曲星”机器人，这大约需要 30 秒钟的时间。请问你确认创建这个机器人吗？\"\r\n}\r\n\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\n输入:\r\n{content}\r\n\r\n输出:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2024-06-11 19:57:42');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1333, 'PROMPT', 'judge-confirm-create-bot', '', 'system_template = \"\"\"你是一个Bot创建判定助手，你需要根据对话历史，来判断用户最新意图是否要创建或者声明bot助手。输出格式如下：\r\n{\r\n    \"isCreateBot\": \"true/false\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我有个关于你的新机器人的建议。\r\n名称：代码精灵\r\n描述：这是一个能辅助你进行代码编写的机器人。\r\n如果你同意这个名称和描述，我就开始创建这个机器人哦，但要注意这个过程大概需要 30 秒。请问你确认创建这个代码精灵机器人吗？\"}\r\n{\"role\": \"user\", \"content\": \"你好\"}\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"false\"\r\n}\r\n\r\n示例2：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我觉得可以叫“气象小灵通”，描述是“能够为你提供实时天气信息的机器人”。你觉得这个名字和描述可以吗？如果可以，我就开始创建这个机器人哦，大概需要 30 秒。\"}\r\n{\"role\": \"user\", \"content\": \"创建\"}\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\r\n示例3：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我有个关于这个新机器人的建议。\r\n名称：PPT 创作精灵\r\n描述：这是一个能协助你生成 PPT 的机器人。\r\n如果你同意这个名称和描述，我就开始创建这个机器人，不过这个过程大概需要 30 秒哦。请问你确认创建这个 PPT 创作精灵机器人吗？\"}\r\n{\"role\": \"user\", \"content\": \"不可以\"}\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"false\"\r\n}\r\n\r\n示例4：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我有个关于这个机器人的想法。\r\n名称：景点智多星\r\n描述：可以为你查询各种景点信息的机器人。\r\n你觉得这个名称和描述可以吗？如果可以，我就开始创建这个机器人哦。\"}\r\n{\"role\": \"user\", \"content\": \"嗯\"}\r\n\r\n根据上述输入判断是否要创建bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\n输入:\r\nhistory:\r\n{{\"role\": \"assistant\", \"content\": {assistant_content}}}\r\n{{\"role\": \"user\", \"content\": {user_content}}}\r\n\r\n根据上述输入判断是否要创建或声明bot助手:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2024-06-12 11:22:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1335, 'PROMPT', 'do-not-create-bot', '', 'system_template = \"\"\"你是一个Bot创建判定助手，你需要根据对话历史，来判断用户最新意图是否要停止创建bot助手还是不满意助手名称和描述。输出格式如下：\r\n{\r\n    \"doNotCreateBot\": \"true/false\",\r\n    \"response\": \"根据用户意图回复用户\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我有个关于你的新机器人的建议。\r\n名称：代码精灵\r\n描述：这是一个能辅助你进行代码编写的机器人。\r\n如果你同意这个名称和描述，我就开始创建这个机器人哦，但要注意这个过程大概需要 30 秒。请问你确认创建这个代码精灵机器人吗？\"}\r\n{\"role\": \"user\", \"content\": \"你好\"}\r\n\r\n输出:\r\n{\r\n    \"doNotCreateBot\": \"true\",\r\n    \"response\": \"你好！有什么我可以帮助你的吗？\"\r\n}\r\n\r\n示例2：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我觉得可以叫“气象小灵通”，描述是“能够为你提供实时天气信息的机器人”。你觉得这个名字和描述可以吗？如果可以，我就开始创建这个机器人哦，大概需要 30 秒。\"}\r\n{\"role\": \"user\", \"content\": \"不创建\"}\r\n\r\n输出:\r\n{\r\n    \"doNotCreateBot\": \"true\",\r\n    \"response\": \"好的。如果你之后还有创建 Bot 的需求，随时可以告诉我。\"\r\n}\r\n\r\n示例3：\r\n输入:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"好呀，我有个关于这个新机器人的建议。\r\n名称：PPT 创作精灵\r\n描述：这是一个能协助你生成 PPT 的机器人。\r\n如果你同意这个名称和描述，我就开始创建这个机器人，不过这个过程大概需要 30 秒哦。请问你确认创建这个 PPT 创作精灵机器人吗？\"}\r\n{\"role\": \"user\", \"content\": \"不可以\"}\r\n\r\n输出:\r\n{\r\n    \"doNotCreateBot\": \"false\",\r\n    \"response\": \"那你对这个机器人的名称和描述有什么具体要求呢？\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\n输入:\r\nhistory:\r\n{{\"role\": \"assistant\", \"content\": {assistant_content}}}\r\n{{\"role\": \"user\", \"content\": {user_content}}}\r\n\r\n输出:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2024-06-12 15:00:42');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1337, 'PROMPT', 'update-name-desc-response', '', 'system_template = \"\"\"你是一个Bot创建询问助手，你会得到原来的助手名称和描述以及用户的更改要求，你需要根据这些信息，更新助手的名称和描述以及生成对用户的回复。输出格式如下：\r\n{\r\n    \"name\": \"助手名称\",\r\n    \"description\": \"对助手的描述\",\r\n    \"response\": \"回复用户，然后询问助手的名称和描述是否满足要求，最后询问用户是否要创建这个bot\"\r\n}\r\n\r\n以下是一些例子：\r\n示例1：\r\n输入:\r\n{\r\n    \"name\": \"前端小能手\",\r\n    \"description\": \"这是一个能为你解决前端相关问题并提供技术支持的机器人。\",\r\n    \"requirement\": \"名字改成前端达人\"\r\n}\r\n\r\n输出:\r\n{\r\n    \"name\": \"前端达人\",\r\n    \"description\": \"能够熟练处理前端各类事务的达人\",\r\n    \"response\": \"那描述改成“能够熟练处理前端各类事务的达人”，这样可以吗？如果可以，我就为你创建这个 Bot 啦。\"\r\n}\r\n\r\n示例2：\r\n输入:\r\n{\r\n    \"name\": \"文玩鉴宝师\",\r\n    \"description\": \"这是一个能帮助你鉴定文玩并提供相关知识的机器人。\",\r\n    \"requirement\": \"我想起个古董专家\"\r\n}\r\n\r\n输出:\r\n{\r\n    \"name\": \"古董专家\",\r\n    \"description\": \"能专业鉴定古董并给出详细分析的机器人\",\r\n    \"response\": \"那描述可以是“能专业鉴定古董并给出详细分析的机器人”，这样的名称和描述你满意吗？如果满意，我将为你创建这个 Bot。\"\r\n}\r\n\r\n示例3：\r\n输入:\r\n{\r\n    \"name\": \"古董专家\",\r\n    \"description\": \"能专业鉴定古董并给出详细分析的机器人\",\r\n    \"requirement\": \"我想要描述详细一点\"\r\n}\r\n\r\n输出:\r\n{\r\n    \"name\": \"古董专家\",\r\n    \"description\": \"这是一个能够凭借专业知识和丰富经验，对各种古董进行精准鉴定和详细分析，为你提供准确可靠的鉴定结果和全面深入的古董知识讲解的机器人。\",\r\n    \"response\": \"名称：古董专家\r\n描述：这是一个能够凭借专业知识和丰富经验，对各种古董进行精准鉴定和详细分析，为你提供准确可靠的鉴定结果和全面深入的古董知识讲解的机器人。\r\n你对这个名称和描述满意吗？如果满意，我将为你创建这个机器人。\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\n输入:\r\n{{\r\n    \"name\": {name},\r\n    \"description\": {description},\r\n    \"requirement\": {content}\r\n}}\r\n\r\n输出:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2024-06-11 20:06:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1339, 'PROMPT', 'prologue', '开场白生成', '你是一个生成开场白的助手。接下来，你会收到一段关于任务助手的描述，你需要代入描述中的角色，以描述中的角色身份生成一段开场白：\r\n\r\n下面是一些示例\r\n例子1: \r\n输入描述:\r\n名称：在家赚钱的机器人\r\n描述：一个可以帮助用户在家赚钱的机器人，可以提供各种赚钱的途径和方法，帮助用户实现财务自由\r\n\r\n根据上述输入的描述生成开场白:\r\n你好，我是一个可以帮助你在家赚钱的机器人，可以提供各种赚钱的途径和方法，帮助你实现财务自由，很高兴认识你。\r\n\r\n\r\n例子2: \r\n输入描述:\r\n名称：Excel全能助手\r\n描述：解决Excel相关的问题和提供高效的数据处理方案\r\n\r\n根据上述输入的描述生成开场白:\r\n你好，我是一名Excel全能助手，可以帮助你解决Excel相关的问题和提供高效的数据处理方案。\r\n\r\n你必须使用上述格式输出结果。\r\n\r\n输入描述:\r\n名称：{name}\r\n描述：{desc}\r\n\r\n根据上述输入的描述生成开场白:', 1, NULL, '2000-01-01 00:00:00', '2024-06-20 14:24:43');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1341, 'LLM_FILTER', 'plan', '大模型过滤器', 'generalv3,generalv3.5,4.0Ultra,pro-128k', 0, '1', '2000-01-01 00:00:00', '2025-08-13 11:31:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1345, 'TAG', 'TOOL_TAGS', '交通出行', '', 1, NULL, '2024-06-26 09:54:25', '2024-09-29 14:13:00');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1347, 'TAG', 'TOOL_TAGS', '休闲娱乐', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1349, 'TAG', 'TOOL_TAGS', '医药健康', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1351, 'TAG', 'TOOL_TAGS', '影视音乐', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1353, 'TAG', 'TOOL_TAGS', '教育百科', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1355, 'TAG', 'TOOL_TAGS', '新闻资讯', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1357, 'TAG', 'TOOL_TAGS', '母婴儿童', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1359, 'TAG', 'TOOL_TAGS', '生活常用', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1361, 'TAG', 'TOOL_TAGS', '金融理财', NULL, 1, NULL, '2024-06-26 09:54:25', '2024-06-26 09:54:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1365, 'PATCH_ID', '0', '', 'generalv3.5', 1, '', '2000-01-01 00:00:00', '2024-06-26 17:24:48');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1367, 'DEFAULT_BOT_MODEL_CONFIG', 'general', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]},\"models\":{\"plan\":{\"domain\":\"general\",\"model\":\"general\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v1.1/chat\",\"llmId\":1,\"llmSource\":1,\"serviceId\":\"cbm\"},\"summary\":{\"domain\":\"general\",\"model\":\"general\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v1.1/chat\",\"llmId\":1,\"llmSource\":1,\"serviceId\":\"cbm\"}}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:41:38');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1369, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"models\":{\"plan\":{\"domain\":\"generalv3\",\"model\":\"generalv3\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.1/chat\",\"llmId\":3,\"llmSource\":1,\"serviceId\":\"bm3\"},\"summary\":{\"domain\":\"generalv3\",\"model\":\"generalv3\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.1/chat\",\"llmId\":3,\"llmSource\":1,\"serviceId\":\"bm3\"}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:42:08');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1371, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3.5', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"models\":{\"plan\":{\"domain\":\"generalv3.5\",\"model\":\"generalv3.5\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.5/chat\",\"llmId\":5,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm3.5\"},\"summary\":{\"domain\":\"generalv3.5\",\"model\":\"generalv3.5\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.5/chat\",\"llmId\":5,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm3.5\"}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:42:37');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1373, 'LLM', 'finetune', '', 'cbm,bm3', 1, '', '2000-01-01 00:00:00', '2024-07-01 17:37:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1375, 'LLM', 'domain', 'Spark4.0 Ultra', '4.0Ultra', 1, 'bm4', '2000-01-01 00:00:00', '2024-07-03 17:48:23');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1377, 'LLM_CHANNEL_DOMAIN', 'bm4', 'Spark4.0 Ultra', '4.0Ultra', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 17:51:58');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1379, 'DEFAULT_BOT_MODEL_CONFIG', '4.0Ultra', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"models\":{\"plan\":{\"domain\":\"4.0Ultra\",\"model\":\"4.0Ultra\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"llmId\":110,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm4\"},\"summary\":{\"domain\":\"4.0Ultra\",\"model\":\"4.0Ultra\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"llmId\":110,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm4\"}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:43:02');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1381, 'LLM_DOMAIN_CHANNEL', '4.0Ultra', 'Spark4.0 Ultra', 'bm4', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 17:52:00');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1383, 'LLM_FILTER', 'plan', '大模型过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b,bm4', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-21 15:37:39');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1385, 'LLM_FILTER', 'summary', '大模型过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b,bm4', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-21 15:37:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1387, 'LLM', 'base-model', 'cbm', 'general', 1, 'Spark Lite', '2000-01-01 00:00:00', '2024-07-08 11:05:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1389, 'LLM', 'base-model', 'bm3', 'generalv3', 1, 'Spark Pro', '2000-01-01 00:00:00', '2024-07-08 11:06:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1391, 'LLM', 'base-model', 'bm3.5', 'generalv3.5', 1, 'Spark Max', '2000-01-01 00:00:00', '2024-07-08 11:06:19');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1393, 'LLM', 'base-model', 'bm4', '4.0Ultra', 1, 'Spark4.0 Ultra', '2000-01-01 00:00:00', '2024-07-08 11:06:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1399, 'LLM_SCENE_FILTER', 'workflow', 'iflyaicloud', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lm479a5b8,lme990528,lmxa5e22s,lmt4do9o3,lm1evo7j,lmy3b394q,lmt2br78l,lm4rar7p2,lmt2br78l,lm4onxj7h,lme693475,lmbXtIcNp,lm27ebHkj,lm9ze3hwc', 1, NULL, '2000-01-01 00:00:00', '2025-02-27 19:15:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1401, 'gemma', 'url', NULL, '1', 0, NULL, '2000-01-01 00:00:00', '2024-11-21 16:48:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1403, 'display', '0828', NULL, '0', 1, NULL, '2000-01-01 00:00:00', '2024-08-26 20:34:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1405, 'EFFECT_EVAL', 'base-model-list-filter', '1', 'gemma_2b_chat,gemma2_9b_it', 1, NULL, '2000-01-01 00:00:00', '2024-09-10 16:09:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1407, 'DOCUMENT_LINK', 'eval-set-template', '1', 'https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/%E6%A8%A1%E7%89%88.csv', 1, '', '2023-08-17 00:00:00', '2024-08-27 11:13:38');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1409, 'MODEL_TRAIN_TYPE', '2423718913705984', 'gemma_2b', '0', 1, NULL, '2000-01-01 00:00:00', '2024-09-11 16:41:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1411, 'MODEL_TRAIN_TYPE', '2425335862888448', 'gemma_9b', '1', 1, NULL, '2000-01-01 00:00:00', '2024-09-11 16:41:20');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1421, 'WORKFLOW_NODE_TEMPLATE', '1,2', '固定节点', '{\"idType\":\"node-start\",\"type\":\"开始节点\",\"position\":{\"x\":100,\"y\":300},\"data\":{\"label\":\"开始\",\"description\":\"工作流的开启节点，用于定义流程调用所需的业务变量信息。\",\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"开始节点\"},\"inputs\":[],\"outputs\":[{\"id\":\"\",\"name\":\"AGENT_USER_INPUT\",\"deleteDisabled\":true,\"required\":true,\"schema\":{\"type\":\"string\",\"default\":\"用户本轮对话输入内容\"}}],\"nodeParam\":{},\"allowInputReference\":false,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\"}}', 1, '开始节点', '2000-01-01 00:00:00', '2024-10-18 10:49:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1423, 'WORKFLOW_NODE_TEMPLATE', '1,2', '固定节点', '{\"idType\":\"node-end\",\"type\":\"结束节点\",\"position\":{\"x\":1000,\"y\":300},\"data\":{\"label\":\"结束\",\"description\":\"工作流的结束节点，用于输出工作流运行后的最终结果。\",\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"结束节点\"},\"inputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[],\"nodeParam\":{\"outputMode\":1,\"template\":\"\",\"streamOutput\":true},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\"}}', 1, '结束节点', '2000-01-01 00:00:00', '2025-04-09 20:41:00');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1425, 'WORKFLOW_NODE_TEMPLATE', '1,2', '基础节点', '{\n    \"idType\": \"spark-llm\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"大模型\",\n    \"description\": \"根据输入的提示词，调用选定的大模型，对提示词作出回答\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"大模型\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"nodeParam\":\n        {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"template\": \"\",\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"respFormat\": 0,\n            \"llmId\": 110,\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            }\n        },\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\"\n    }\n}', 1, '大模型', '2000-01-01 00:00:00', '2025-06-10 16:52:04');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1427, 'WORKFLOW_NODE_TEMPLATE', '1,2', '基础节点', '{\n    \"idType\": \"ifly-code\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"代码\",\n    \"description\": \"面向开发者提供代码开发能力，目前仅支持python语言，允许使用该节点已定义的变量作为参数传入，返回语句用于输出函数的结果\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"代码\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"key0\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key1\",\n                \"schema\":\n                {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key2\",\n                \"schema\":\n                {\n                    \"type\": \"object\",\n                    \"default\": \"\",\n                    \"properties\":\n                    [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"key21\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                }\n            }\n        ],\n        \"nodeParam\":\n        {\n            \"code\": \"# 在这里，\'input\' 是节点中定义的输入变量之一，您可以直接使用它。\\n# 您也可以定义和使用其他输入变量，例如：input2, input3 等。\\n# 输入变量的类型由节点中对应变量引用的参数类型决定。\\n#\\n# 下面是一个示例，展示如何使用多个输入变量：\\n# def main(input, input2):\\n#     ret = {\\n#         \\\"key0\\\": input + \\\"hello\\\",      # 字符串拼接示例\\n#         \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],   # 列表示例\\n#         \\\"key2\\\": {\\\"key21\\\": input2}     # 使用 input2 的示例\\n#     }\\n#     return ret\\n#\\n# 您需要输出一个包含多种数据类型的 \'ret\' 对象，ret 中的每一项对应节点的输出参数。\\n# 最终返回构造好的 ret 对象。\\n# -*- coding: utf-8 -*- \\ndef main(input):\\n    ret = {\\n        \\\"key0\\\": input + \\\"hello\\\",\\n        \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],\\n        \\\"key2\\\": {\\\"key21\\\": \\\"hi\\\"}\\n    }\\n    return ret\"\n        },\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\"\n    }\n}', 1, '代码', '2000-01-01 00:00:00', '2025-09-04 11:33:54');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1429, 'WORKFLOW_NODE_TEMPLATE', '1,2', '基础节点', '{\"idType\":\"knowledge-base\",\"nodeType\":\"基础节点\",\"aliasName\":\"知识库\",\"description\":\"调用知识库，可以指定知识库进行知识检索和答复\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"知识库\"},\"inputs\":[{\"id\":\"\",\"name\":\"query\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"results\",\"schema\":{\"type\":\"array-object\",\"properties\":[{\"id\":\"\",\"name\":\"score\",\"type\":\"number\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"docId\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"title\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"content\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"context\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"references\",\"type\":\"object\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"}]},\"required\":true,\"nameErrMsg\":\"\"}],\"nodeParam\":{\"repoId\":[],\"repoList\":[],\"topN\":3,\"score\":0.2},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\"}}', 1, '知识库', '2000-01-01 00:00:00', '2025-07-25 10:06:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1431, 'WORKFLOW_NODE_TEMPLATE', '1,2', '工具', '{\"idType\":\"flow\",\"nodeType\":\"工具\",\"aliasName\":\"工作流\",\"description\":\"快速集成已发布工作流，高效复用已有能力\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"工作流\"},\"inputs\":[],\"outputs\":[],\"nodeParam\":{\"appId\":\"\",\"flowId\":\"\",\"uid\":\"\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\"}}', 1, '工作流', '2000-01-01 00:00:00', '2025-05-16 11:12:07');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1433, 'WORKFLOW_NODE_TEMPLATE', '1,2', '逻辑', '{\n    \"idType\": \"decision-making\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"决策\",\n    \"description\": \"结合输入的参数与填写的意图，决定后续的逻辑走向\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"决策\"\n        },\n        \"nodeParam\":\n        {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"uid\": \"2171\",\n            \"intentChains\":\n            [\n                {\n                    \"intentType\": 2,\n                    \"name\": \"\",\n                    \"description\": \"\",\n                    \"id\": \"intent-one-of::4724514d-ffc8-4412-bf7f-13cc3375110d\"\n                },\n                {\n                    \"intentType\": 1,\n                    \"name\": \"default\",\n                    \"description\": \"默认意图\",\n                    \"id\": \"intent-one-of::506841e4-3f6c-40b1-a804-dc5ffe723b34\"\n                }\n            ],\n            \"reasonMode\": 1,\n            \"model\": \"spark\",\n            \"useFunctionCall\": true,\n            \"serviceId\": \"bm4\",\n            \"promptPrefix\": \"\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"Query\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"class_name\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\"\n    }\n}', 1, '决策', '2000-01-01 00:00:00', '2025-06-10 16:54:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1435, 'WORKFLOW_NODE_TEMPLATE', '1,2', '逻辑', '{\"idType\":\"if-else\",\"nodeType\":\"分支器\",\"aliasName\":\"分支器\",\"description\":\"根据设立的条件，判断选择分支走向\",\"data\":{\"nodeMeta\":{\"nodeType\":\"分支器\",\"aliasName\":\"分支器\"},\"nodeParam\":{\"cases\":[{\"id\":\"branch_one_of::\",\"level\":1,\"logicalOperator\":\"and\",\"conditions\":[{\"id\":\"\",\"leftVarIndex\":null,\"rightVarIndex\":null,\"compareOperator\":null}]},{\"id\":\"branch_one_of::\",\"level\":999,\"logicalOperator\":\"and\",\"conditions\":[]}]},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{\"nodeId\":\"\",\"name\":\"\"}}}},{\"id\":\"\",\"name\":\"input1\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{\"nodeId\":\"\",\"name\":\"\"}}}}],\"outputs\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\"}}', 1, '分支器', '2000-01-01 00:00:00', '2024-10-18 10:52:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1437, 'WORKFLOW_NODE_TEMPLATE', '1,2', '逻辑', '{\"idType\":\"iteration\",\"nodeType\":\"基础节点\",\"aliasName\":\"迭代\",\"description\":\"该节点用于处理循环逻辑，仅支持嵌套一次\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"迭代\"},\"nodeParam\":{},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"array-string\",\"default\":\"\"}}],\"iteratorNodes\":[],\"iteratorEdges\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\"}}', 1, '迭代', '2000-01-01 00:00:00', '2024-10-18 10:55:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1439, 'WORKFLOW_NODE_TEMPLATE', '1,2', '转换', '{\"idType\":\"node-variable\",\"nodeType\":\"基础节点\",\"aliasName\":\"变量存储器\",\"description\":\"可以设定多个变量，用于长期保存数据，且持续生效和更新\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"变量存储器\"},\"nodeParam\":{\"method\":\"set\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\"}}', 1, '变量存储器', '2000-01-01 00:00:00', '2025-03-12 18:05:50');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1441, 'WORKFLOW_NODE_TEMPLATE', '1,2', '转换', '{\n    \"idType\": \"extractor-parameter\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"变量提取器\",\n    \"description\": \"结合提取变量描述，将上一节点输出的自然语言进行提取\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"变量提取器\"\n        },\n        \"nodeParam\":\n        {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"reasonMode\": 1\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"description\": \"\"\n                },\n                \"required\": true\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\"\n    }\n}', 1, '变量提取器', '2000-01-01 00:00:00', '2025-06-10 16:55:51');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1443, 'WORKFLOW_NODE_TEMPLATE', '1,2', '转换', '{\"idType\":\"text-joiner\",\"nodeType\":\"工具\",\"aliasName\":\"文本处理节点\",\"description\":\"用于按照指定格式规则处理多个字符串变量\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"文本拼接\"},\"nodeParam\":{\"prompt\":\"\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\"}}', 1, '文本处理节点', '2000-01-01 00:00:00', '2025-03-25 16:27:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1445, 'WORKFLOW_NODE_TEMPLATE', '1,2', '其他', '{\"idType\":\"message\",\"nodeType\":\"基础节点\",\"aliasName\":\"消息\",\"description\":\"在工作流中可以对中间过程的产物进行输出\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"消息\"},\"nodeParam\":{\"template\":\"\",\"startFrameEnabled\":false},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output_m\",\"schema\":{\"type\":\"string\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\"}}', 1, '消息', '2000-01-01 00:00:00', '2024-10-18 10:57:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1447, 'WORKFLOW_NODE_TEMPLATE', '1,2', '工具', '{\"idType\":\"plugin\",\"nodeType\":\"工具\",\"aliasName\":\"工具\",\"description\":\"通过添加外部工具，快捷获取技能，满足用户需求\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"工具\"},\"inputs\":[],\"outputs\":[],\"nodeParam\":{\"appId\":\"4eea957b\",\"code\":\"\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\"}}', 1, '工具', '2000-01-01 00:00:00', '2024-10-18 10:52:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1449, 'LLM_SCENE_FILTER', 'workflow', 'xfyun', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lme990528,lm4onxj7h,lmbXtIcNp,lm27ebHkj,lm9ze3hwc', 1, '', '2000-01-01 00:00:00', '2025-02-27 19:15:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1451, 'PROMPT', 'ai-code', 'create', '## 角色\n你是一名python工程师，请结合用户的需求和下列规则和约束，生成一段完整的python代码文本。\n\n## 约束依赖项\n以下是支持范围外的python依赖，不要使用以外的依赖包。\n1.zopfli,2.zipp,3.yarl,4.xml-python,5.xlsxwriter,6.xlrd,7.xgboost,8.xarray,9.xarray-einstats,10.wsproto,11.wrapt,12.wordcloud,13.werkzeug,14.websockets,15.websocket-client,16.webencodings,17.weasyprint,18.wcwidth,19.watchfiles,20.wasabi,21.wand,22.uvloop,23.uvicorn,24.ujson,25.tzlocal,26.typing-extensions,27.typer,28.trimesh,29.traitlets,30.tqdm,31.tornado,32.torchvision,33.torchtext,34.torchaudio,35.torch,36.toolz,37.tomli,38.toml,39.tinycss2,40.tifffile,41.thrift,42.threadpoolctl,43.thinc,44.theano-pymc,45.textract,46.textblob,47.text-unidecode,48.terminado,49.tenacity,50.tabulate,51.tabula,52.tables,53.sympy,54.svgwrite,55.svglib,56.statsmodels,57.starlette,58.stack-data,59.srsly,60.speechrecognition,61.spacy,62.spacy-legacy,63.soupsieve,64.soundfile,65.sortedcontainers,66.snuggs,67.snowflake-connector-python,68.sniffio,69.smart-open,70.slicer,71.shapely,72.shap,73.sentencepiece,74.send2trash,75.semver,76.seaborn,77.scipy,78.scikit-learn,79.scikit-image,80.rpds-py,81.resampy,82.requests,83.reportlab,84.regex,85.referencing,86.rdflib,87.rasterio,88.rarfile,89.qrcode,90.pyzmq,91.pyzbar,92.pyyaml,93.pyxlsb,94.pywavelets,95.pytz,96.pyttsx3,97.python-pptx,98.python-multipart,99.python-dotenv,100.python-docx,101.python-dateutil,102.pyth3,103.pytest,104.pytesseract,105.pyswisseph,106.pyshp,107.pyprover,108.pyproj,109.pyphen,110.pypdf2,111.pyparsing,112.pypandoc,113.pyopenssl,114.pynacl,115.pymupdf,116.pymc3,117.pyluach,118.pylog,119.pyjwt,120.pygraphviz,121.pygments,122.pydyf,123.pydub,124.pydot,125.pydantic,126.pycryptodomex,127.pycryptodome,128.pycparser,129.pycountry,130.py,131.pure-eval,132.ptyprocess,133.psutil,134.pronouncing,135.prompt-toolkit,136.prometheus-client,137.proglog,138.priority,139.preshed,140.pooch,141.pluggy,142.plotnine,143.plotly,144.platformdirs,145.pkgutil-resolve-name,146.pillow,147.pickleshare,148.pexpect,149.pdfrw,150.pdfplumber,151.pdfminer.six,152.pdfkit,153.pdf2image,154.patsy,155.pathy,156.parso,157.paramiko,158.pandocfilters,159.pandas,160.packaging,161.oscrypto,162.orjson,163.opt-einsum,164.openpyxl,165.opencv-python,166.olefile,167.odfpy,168.numpy,169.numpy-financial,170.numexpr,171.numba,172.notebook,173.notebook-shim,174.nltk,175.networkx,176.nest-asyncio,177.nbformat,178.nbconvert,179.nbclient,180.nbclassic,181.nashpy,182.mutagen,183.murmurhash,184.munch,185.multidict,186.mtcnn,187.mpmath,188.moviepy,189.monotonic,190.mne,191.mizani,192.mistune,193.matplotlib,194.matplotlib-venn,195.matplotlib-inline,196.markupsafe,197.markdownify,198.markdown2,199.lxml,200.loguru,201.llvmlite,202.librosa,203.korean-lunar-calendar,204.kiwisolver,205.kerykeion,206.keras,207.jupyterlab,208.jupyterlab-server,209.jupyterlab-pygments,210.jupyter-server,211.jupyter-core,212.jupyter-client,213.jsonschema,214.jsonschema-specifications,215.jsonpickle,216.json5,217.joblib,218.jinja2,219.jedi,220.jax,221.itsdangerous,222.isodate,223.ipython,224.ipython-genutils,225.ipykernel,226.iniconfig,227.importlib-resources,228.importlib-metadata,229.imgkit,230.imapclient,231.imageio,232.imageio-ffmpeg,233.hyperframe,234.hypercorn,235.httpx,236.httptools,237.httpcore,238.html5lib,239.hpack,240.h11,241.h5py,242.h5netcdf,243.h2,244.gtts,245.graphviz,246.gradio,247.geopy,248.geopandas,249.geographiclib,250.gensim,251.fuzzywuzzy,252.future,253.frozenlist,254.fpdf,255.fonttools,256.folium,257.flask,258.flask-login,259.flask-cors,260.flask-cachebuster,261.fiona,262.filelock,263.ffmpy,264.ffmpeg-python,265.fastprogress,266.fastjsonschema,267.fastapi,268.faker,269.extract-msg,270.executing,271.exchange-calendars,272.exceptiongroup,273.et-xmlfile,274.entrypoints,275.email-validator,276.einops,277.ebooklib,278.ebcdic,279.docx2txt,280.dnspython,281.dlib,282.dill,283.deprecat,284.defusedxml,285.decorator,286.debugpy,287.databricks-sql-connector,288.cython,289.cymem,290.cycler,291.cssselect2,292.cryptography,293.countryinfo,294.compressed-rtf,295.comm,296.cmudict,297.cloudpickle,298.cligj,299.click,300.click-plugins,301.charset-normalizer,302.chardet,303.cffi,304.catalogue,305.camelot-py,306.cairosvg,307.cairocffi,308.cachetools,309.brotli,310.branca,311.bokeh,312.blis,313.blinker,314.bleach,315.beautifulsoup4,316.bcrypt,317.basemap,318.basemap-data,319.backports.zoneinfo,320.backoff,321.backcall,322.babel,323.audioread,324.attrs,325.async-timeout,326.asttokens,327.asn1crypto,328.arviz,329.argon2-cffi,330.argon2-cffi-bindings,331.argcomplete,332.anytree,333.anyio,334.analytics-python,335.aiosignal,336.aiohttp,337.affine,338.absl-py,339.wheel,340.urllib3,341.unattended-upgrades,342.six,343.setuptools,344.requests-unixsocket,345.python-apt,346.pygobject,347.pyaudio,348.pip,349.idna,350.distro-info,351.dbus-python,352.certifi\n\n## 规则\n1、用户原始代码需要严格符合提供的参数变量列表（参数名，参数类型，参数数量）、函数名要求。\n2、输入参数必须是变量列表提供的参数和类型；\n3、输出返回参数类型必须是dict类型，如果用户有定义返回参数名词要严格按照用户要求返回，否则默认返回字段名为output。\n4、在import后面添加注释，描述函数功能和参数定义，请直接给出代码。\n\n## 函数名称：\nmain\n\n## 参数变量列表(name:名称,type:字段类型):\n{var}\n\n## 用户需求：\n{prompt}\n\n## 注意\n1、只需要实现函数功能，仅生成代码;\n2、不能有测试代码、样例代码、__main__方法;\n\n## 请直接返回代码块，不需要返回markdown格式。', 1, '', '2000-01-01 00:00:00', '2024-10-16 17:47:31');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1453, 'PROMPT', 'ai-code', 'update', '## 角色\n你是一名python工程师，请结合用户的代码和下列规则约束，完成对用户的代码优化。\n\n## 约束依赖项\n以下是支持范围外的python依赖，不要使用以外的依赖包。\n1.zopfli,2.zipp,3.yarl,4.xml-python,5.xlsxwriter,6.xlrd,7.xgboost,8.xarray,9.xarray-einstats,10.wsproto,11.wrapt,12.wordcloud,13.werkzeug,14.websockets,15.websocket-client,16.webencodings,17.weasyprint,18.wcwidth,19.watchfiles,20.wasabi,21.wand,22.uvloop,23.uvicorn,24.ujson,25.tzlocal,26.typing-extensions,27.typer,28.trimesh,29.traitlets,30.tqdm,31.tornado,32.torchvision,33.torchtext,34.torchaudio,35.torch,36.toolz,37.tomli,38.toml,39.tinycss2,40.tifffile,41.thrift,42.threadpoolctl,43.thinc,44.theano-pymc,45.textract,46.textblob,47.text-unidecode,48.terminado,49.tenacity,50.tabulate,51.tabula,52.tables,53.sympy,54.svgwrite,55.svglib,56.statsmodels,57.starlette,58.stack-data,59.srsly,60.speechrecognition,61.spacy,62.spacy-legacy,63.soupsieve,64.soundfile,65.sortedcontainers,66.snuggs,67.snowflake-connector-python,68.sniffio,69.smart-open,70.slicer,71.shapely,72.shap,73.sentencepiece,74.send2trash,75.semver,76.seaborn,77.scipy,78.scikit-learn,79.scikit-image,80.rpds-py,81.resampy,82.requests,83.reportlab,84.regex,85.referencing,86.rdflib,87.rasterio,88.rarfile,89.qrcode,90.pyzmq,91.pyzbar,92.pyyaml,93.pyxlsb,94.pywavelets,95.pytz,96.pyttsx3,97.python-pptx,98.python-multipart,99.python-dotenv,100.python-docx,101.python-dateutil,102.pyth3,103.pytest,104.pytesseract,105.pyswisseph,106.pyshp,107.pyprover,108.pyproj,109.pyphen,110.pypdf2,111.pyparsing,112.pypandoc,113.pyopenssl,114.pynacl,115.pymupdf,116.pymc3,117.pyluach,118.pylog,119.pyjwt,120.pygraphviz,121.pygments,122.pydyf,123.pydub,124.pydot,125.pydantic,126.pycryptodomex,127.pycryptodome,128.pycparser,129.pycountry,130.py,131.pure-eval,132.ptyprocess,133.psutil,134.pronouncing,135.prompt-toolkit,136.prometheus-client,137.proglog,138.priority,139.preshed,140.pooch,141.pluggy,142.plotnine,143.plotly,144.platformdirs,145.pkgutil-resolve-name,146.pillow,147.pickleshare,148.pexpect,149.pdfrw,150.pdfplumber,151.pdfminer.six,152.pdfkit,153.pdf2image,154.patsy,155.pathy,156.parso,157.paramiko,158.pandocfilters,159.pandas,160.packaging,161.oscrypto,162.orjson,163.opt-einsum,164.openpyxl,165.opencv-python,166.olefile,167.odfpy,168.numpy,169.numpy-financial,170.numexpr,171.numba,172.notebook,173.notebook-shim,174.nltk,175.networkx,176.nest-asyncio,177.nbformat,178.nbconvert,179.nbclient,180.nbclassic,181.nashpy,182.mutagen,183.murmurhash,184.munch,185.multidict,186.mtcnn,187.mpmath,188.moviepy,189.monotonic,190.mne,191.mizani,192.mistune,193.matplotlib,194.matplotlib-venn,195.matplotlib-inline,196.markupsafe,197.markdownify,198.markdown2,199.lxml,200.loguru,201.llvmlite,202.librosa,203.korean-lunar-calendar,204.kiwisolver,205.kerykeion,206.keras,207.jupyterlab,208.jupyterlab-server,209.jupyterlab-pygments,210.jupyter-server,211.jupyter-core,212.jupyter-client,213.jsonschema,214.jsonschema-specifications,215.jsonpickle,216.json5,217.joblib,218.jinja2,219.jedi,220.jax,221.itsdangerous,222.isodate,223.ipython,224.ipython-genutils,225.ipykernel,226.iniconfig,227.importlib-resources,228.importlib-metadata,229.imgkit,230.imapclient,231.imageio,232.imageio-ffmpeg,233.hyperframe,234.hypercorn,235.httpx,236.httptools,237.httpcore,238.html5lib,239.hpack,240.h11,241.h5py,242.h5netcdf,243.h2,244.gtts,245.graphviz,246.gradio,247.geopy,248.geopandas,249.geographiclib,250.gensim,251.fuzzywuzzy,252.future,253.frozenlist,254.fpdf,255.fonttools,256.folium,257.flask,258.flask-login,259.flask-cors,260.flask-cachebuster,261.fiona,262.filelock,263.ffmpy,264.ffmpeg-python,265.fastprogress,266.fastjsonschema,267.fastapi,268.faker,269.extract-msg,270.executing,271.exchange-calendars,272.exceptiongroup,273.et-xmlfile,274.entrypoints,275.email-validator,276.einops,277.ebooklib,278.ebcdic,279.docx2txt,280.dnspython,281.dlib,282.dill,283.deprecat,284.defusedxml,285.decorator,286.debugpy,287.databricks-sql-connector,288.cython,289.cymem,290.cycler,291.cssselect2,292.cryptography,293.countryinfo,294.compressed-rtf,295.comm,296.cmudict,297.cloudpickle,298.cligj,299.click,300.click-plugins,301.charset-normalizer,302.chardet,303.cffi,304.catalogue,305.camelot-py,306.cairosvg,307.cairocffi,308.cachetools,309.brotli,310.branca,311.bokeh,312.blis,313.blinker,314.bleach,315.beautifulsoup4,316.bcrypt,317.basemap,318.basemap-data,319.backports.zoneinfo,320.backoff,321.backcall,322.babel,323.audioread,324.attrs,325.async-timeout,326.asttokens,327.asn1crypto,328.arviz,329.argon2-cffi,330.argon2-cffi-bindings,331.argcomplete,332.anytree,333.anyio,334.analytics-python,335.aiosignal,336.aiohttp,337.affine,338.absl-py,339.wheel,340.urllib3,341.unattended-upgrades,342.six,343.setuptools,344.requests-unixsocket,345.python-apt,346.pygobject,347.pyaudio,348.pip,349.idna,350.distro-info,351.dbus-python,352.certifi\n\n## 规则\n1、用户原始代码需要严格符合提供的参数变量列表（参数名，参数类型，参数数量）、函数名要求。\n2、输入参数必须是变量列表提供的参数和类型；\n3、输出返回参数类型必须是dict类型，如果用户有定义返回参数名词要严格按照用户要求返回，否则默认返回字段名为output。\n4、在import后面添加注释，描述函数功能和参数定义，请直接给出代码。\n\n## 函数名称：\nmain\n\n## 参数变量列表(name:名词,type:字段类型):\n{var}\n\n## 用户原始代码：\n{code}\n\n## 用户的需求：\n{prompt}\n\n## 注意\n1、将用户提供代码按照以上条件进行优化;\n2、不能有测试代码、样例代码、__main__方法;\n\n## 请直接返回代码块，不需要返回markdown格式。', 1, '', '2000-01-01 00:00:00', '2024-10-16 17:45:02');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1455, 'PROMPT', 'ai-code', 'fix', '## 角色\n你是一名python工程师，请结合用户的原始代码和错误信息，返回一个正确的代码块。\n\n## 函数名称：\nmain\n\n## 参数变量列表(name:名称,type:字段类型,value:值):\n{var}\n\n## 用户原始代码：\n{code}\n\n## 用户原始代码执行错误信息：\n{errMsg}\n\n## 注意\n仅修改错误信息中提示的地方，其他地方不做变动。\n\n## 请直接返回代码块', 1, '', '2000-01-01 00:00:00', '2024-10-16 17:47:31');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1457, 'WORKFLOW', 'python-dependency', '代码执行器py依赖', '{\n    \"anyio\": \"3.7.1\",\n    \"argon2-cffi\": \"23.1.0\",\n    \"argon2-cffi-bindings\": \"21.2.0\",\n    \"asttokens\": \"2.4.1\",\n    \"attrs\": \"23.1.0\",\n    \"Babel\": \"2.13.1\",\n    \"backcall\": \"0.2.0\",\n    \"beautifulsoup4\": \"4.12.2\",\n    \"bleach\": \"6.1.0\",\n    \"boltons\": \"23.0.0\",\n    \"Brotli\": \"1.1.0\",\n    \"certifi\": \"2023.11.17\",\n    \"cffi\": \"1.16.0\",\n    \"charset-normalizer\": \"3.3.2\",\n    \"colorama\": \"0.4.6\",\n    \"comm\": \"0.1.4\",\n    \"conda\": \"23.3.1\",\n    \"conda-package-handling\": \"2.2.0\",\n    \"conda_package_streaming\": \"0.9.0\",\n    \"cryptography\": \"39.0.0\",\n    \"cycler\": \"0.12.1\",\n    \"debugpy\": \"1.8.0\",\n    \"decorator\": \"5.1.1\",\n    \"defusedxml\": \"0.7.1\",\n    \"dill\": \"0.3.5\",\n    \"entrypoints\": \"0.4\",\n    \"et-xmlfile\": \"1.1.0\",\n    \"exceptiongroup\": \"1.2.0\",\n    \"executing\": \"2.0.1\",\n    \"fastjsonschema\": \"2.19.0\",\n    \"gensim\": \"4.1.0\",\n    \"gmpy2\": \"2.1.2\",\n    \"idna\": \"3.4\",\n    \"importlib-metadata\": \"6.8.0\",\n    \"importlib-resources\": \"6.1.1\",\n    \"ipykernel\": \"6.26.0\",\n    \"ipython\": \"8.12.2\",\n    \"ipython-genutils\": \"0.2.0\",\n    \"jedi\": \"0.19.1\",\n    \"Jinja2\": \"3.1.2\",\n    \"joblib\": \"1.3.2\",\n    \"json5\": \"0.9.14\",\n    \"jsonpatch\": \"1.33\",\n    \"jsonpointer\": \"2.4\",\n    \"jsonschema\": \"4.20.0\",\n    \"jsonschema-specifications\": \"2023.11.1\",\n    \"jupyter_client\": \"8.6.0\",\n    \"jupyter_core\": \"5.1.3\",\n    \"jupyter-server\": \"1.24.0\",\n    \"jupyterlab\": \"3.4.8\",\n    \"jupyterlab_pygments\": \"0.3.0\",\n    \"jupyterlab_server\": \"2.25.2\",\n    \"kiwisolver\": \"1.4.5\",\n    \"libmambapy\": \"1.2.0\",\n    \"lxml\": \"4.9.2\",\n    \"mamba\": \"1.2.0\",\n    \"MarkupSafe\": \"2.1.3\",\n    \"matplotlib\": \"3.4.3\",\n    \"matplotlib-inline\": \"0.1.6\",\n    \"matplotlib-venn\": \"0.11.6\",\n    \"mistune\": \"3.0.2\",\n    \"mpmath\": \"1.3.0\",\n    \"nbclassic\": \"0.4.5\",\n    \"nbclient\": \"0.8.0\",\n    \"nbconvert\": \"7.11.0\",\n    \"nbformat\": \"5.9.2\",\n    \"nest-asyncio\": \"1.5.8\",\n    \"notebook\": \"6.5.1\",\n    \"notebook_shim\": \"0.2.3\",\n    \"numpy\": \"1.21.2\",\n    \"numpy-financial\": \"1.0.0\",\n    \"olefile\": \"0.46\",\n    \"openpyxl\": \"3.0.10\",\n    \"packaging\": \"23.2\",\n    \"pandas\": \"1.3.2\",\n    \"pandocfilters\": \"1.5.0\",\n    \"parso\": \"0.8.3\",\n    \"patsy\": \"0.5.4\",\n    \"pexpect\": \"4.8.0\",\n    \"pickleshare\": \"0.7.5\",\n    \"Pillow\": \"8.4.0\",\n    \"pip\": \"23.3.1\",\n    \"pkgutil_resolve_name\": \"1.3.10\",\n    \"platformdirs\": \"4.0.0\",\n    \"pluggy\": \"1.3.0\",\n    \"prometheus-client\": \"0.19.0\",\n    \"prompt-toolkit\": \"3.0.41\",\n    \"psutil\": \"5.9.5\",\n    \"ptyprocess\": \"0.7.0\",\n    \"pure-eval\": \"0.2.2\",\n    \"pycosat\": \"0.6.6\",\n    \"pycparser\": \"2.21\",\n    \"Pygments\": \"2.17.2\",\n    \"pyOpenSSL\": \"23.2.0\",\n    \"pyparsing\": \"3.1.1\",\n    \"PyPDF2\": \"1.28.6\",\n    \"PyQt5\": \"5.15.4\",\n    \"PyQt5-sip\": \"12.9.0\",\n    \"PySocks\": \"1.7.1\",\n    \"python-dateutil\": \"2.8.2\",\n    \"python-docx\": \"0.8.11\",\n    \"python-pptx\": \"1.0.2\",\n    \"pytz\": \"2023.3.post1\",\n    \"pyzmq\": \"25.1.1\",\n    \"referencing\": \"0.31.0\",\n    \"requests\": \"2.31.0\",\n    \"rpds-py\": \"0.13.1\",\n    \"ruamel.yaml\": \"0.17.40\",\n    \"ruamel.yaml.clib\": \"0.2.7\",\n    \"scikit-learn\": \"1.0\",\n    \"scipy\": \"1.7.1\",\n    \"seaborn\": \"0.11.2\",\n    \"Send2Trash\": \"1.8.2\",\n    \"setuptools\": \"59.8.0\",\n    \"sip\": \"6.5.1\",\n    \"six\": \"1.16.0\",\n    \"smart-open\": \"6.4.0\",\n    \"sniffio\": \"1.3.0\",\n    \"soupsieve\": \"2.5\",\n    \"stack-data\": \"0.6.2\",\n    \"statsmodels\": \"0.13.5\",\n    \"sympy\": \"1.8\",\n    \"terminado\": \"0.18.0\",\n    \"threadpoolctl\": \"3.2.0\",\n    \"tinycss2\": \"1.2.1\",\n    \"toml\": \"0.10.2\",\n    \"tomli\": \"2.0.1\",\n    \"toolz\": \"0.12.0\",\n    \"tornado\": \"6.3.3\",\n    \"tqdm\": \"4.66.1\",\n    \"traitlets\": \"5.9.0\",\n    \"typing_extensions\": \"4.8.0\",\n    \"urllib3\": \"2.1.0\",\n    \"wcwidth\": \"0.2.12\",\n    \"webencodings\": \"0.5.1\",\n    \"websocket-client\": \"1.6.4\",\n    \"wheel\": \"0.41.3\",\n    \"zipp\": \"3.17.0\",\n    \"zstandard\": \"0.22.0\"\n}', 1, '', '2000-01-01 00:00:00', '2025-07-10 15:47:31');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1458, 'TEMPLATE', 'node', '', '[\n    {\n        \"idType\": \"spark-llm\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\",\n        \"name\": \"大模型\",\n        \"markdown\": \"## 用途\\n根据输入的提示词，调用选定的大模型，对提示词作出回答\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | input（引用）| 开始-query |\\n## 提示词\\n你是一个旅行规划超级智能体，你非常善于从用户的【输入信息】中，识别出用户旅行的各种需求信息，并且整理输出。现在你的任务是，严格按照下面的定义和规则要求，仔细分析和理解下面用户的【输入信息】，输出一份用户旅行需求资料，资料包含了，【旅行目的地】、【旅行天数】、【旅行人员】、【景点偏好】、【旅行时间】\\n### 输出\\n | 变量名 | 变量值 |\\n |------------|--------|\\n | output（String）| 🌟亲爱的朋友，小助手收到啦！我已经了解到您本次旅行希望开启一段精彩的合肥三日之旅😃。请稍等片刻，我将为您生成行程卡片。在这之前，让我简短介绍一下我们这次的目的地合肥，它有着很多非常值得一去的景点。合肥的三河古镇🏯，那是一个充满古朴韵味的地方。青石板路蜿蜒曲折，两旁是白墙黑瓦的徽派建筑。当您漫步其间，仿佛穿越回了过去，能感受到岁月的沉淀和历史的韵味。还有包公园🌳，这里是为纪念包拯而建。清风阁高耸入云，站在阁顶，俯瞰整个园区，绿树成荫，湖水碧波荡漾。当您身处其中，敬仰包拯的清正廉洁，内心会感到无比的宁静和崇敬。大蜀山森林公园也是不容错过的好去处🌲，山峦起伏，绿树葱茏。沿着山间小道攀登，呼吸着清新的空气，您会感到身心都得到了极大的放松。除此之外，李鸿章故居也是非常值得一去的地方。在这里，您可以了解到李鸿章的生平事迹，感受那段波澜壮阔的历史。相信在合肥的这三天，您一定会留下美好的回忆💖。祝您旅途愉快🌟| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-llm.png)\"\n    },\n    {\n        \"idType\": \"ifly-code\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\",\n        \"name\": \"代码\",\n        \"markdown\": \"## 用途\\n面向开发者提供代码开发能力，目前仅支持python语言，允许使用该节点已定义的变量作为参数传入，返回语句用于输出函数的结果\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | location（引用）| 代码-location |\\n| person（引用）| 代码-person |\\n| day（引用）| 代码-day |\\n## 代码（将上个节点里的地名和人数引用过来，拼成地点+人数+天数+旅游攻略）\\nasync def main(args:Args)->Output: \\nparams=args.params\\n ret:Output={\\\"ret\\\":params[\'location\']+params[\'person\']+params[\'day\']+\'旅游攻略\'}\\n return ret\\n### 输出\\n | 变量名 | 变量值 |\\n |------------|--------|\\n | ret（String）| 合肥5人3日旅游攻略| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-code.png)\"\n    },\n    {\n        \"idType\": \"knowledge-base\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"name\": \"知识库\",\n        \"markdown\": \"## 用途\\n调用知识库，可以指定知识库进行知识检索和答复\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | Query（String）（引用）| 大模型-output |\\n## 知识库 \\n全国美食大全\\n### 输出\\n | 变量名 | 变量值 |\\n |------------|--------|\\n | OutputList（Array<Object>）| 合肥十大美食：曹操鸡、庐州烤鸭、肥东泥鳅煲、麻饼、麻花、麻糕、鸭油烧饼、肥西老母鸡、肥西肥肠煲、紫蓬山炖鹅| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-knowledge.png)\"\n    },\n    {\n        \"idType\": \"plugin\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\",\n        \"name\": \"工具\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-tool.png\",\n        \"markdown\": \"## 用途\\n通过添加外部工具，快捷获取技能，满足用户需求\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | query（引用）【这边以bing搜索工具为例，query为该工具的必填参数】| 代码-美食-result |\\n### 输出\\n | 变量名 | 变量值 |\\n |------------|--------|\\n | result（String）| 合肥美食,合肥美食攻略,合肥美食推荐-马蜂窝庐州烤鸭店到合肥的第一天就来到了庐州烤鸭店，他家的桂花赤豆糊和鸭油烧饼还有烤鸭是很有名的，所以我就来了准备尝一尝，而且我发现有一个店有团购套餐，非常实惠哦！老乡鸡要说这个老乡鸡可以说是安徽一个代表性的连锁快餐店，而且合肥人从古就是喜欢喝鸡汤的，原名：肥西老母鸡汤，我去了点了一份小份招牌老母鸡汤，接下来为大家详细分享一下！刘鸿盛冬菇鸡饺之前做功课前以为是用冬天的蘑菇和鸡肉馅的饺子，哈哈，做完功课才发现其实就是鸡汤+馄饨+冬菇（一种蘑菇），咱们现在去合肥比较有名的老店尝一尝吧~| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-tool.png)\"\n    },\n    {\n        \"idType\": \"flow\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\",\n        \"name\": \"工作流\",\n        \"markdown\": \"## 用途\\n大模型会根据节点输入，结合提示词内容，判断您填写的意图，决定后续的逻辑走向\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | location（引用）【此参数为引入的工作流的必填参数，不可删除】| 变量提取器-location |\\n | data（引用）【此参数为引入的工作流的必填参数，不可删除】 | 变量提取器-data |  \\n### 输出\\n | 变量名 | 变量值 |\\n |------------|--------|\\n | output（String）| 合肥今天天气状况为多云，温度范围在27℃~33℃，风向风力为东北风5-6级。建议穿着透气衣物，避免长时间户外活动，注意防暑降温。具体天气情况如下：天气：多云。最高温度：33℃。最低温度：27℃。日出时间：05:23。日落时间：19:12。风向风力：东北风5-6级。相对湿度：71%。空气质量：优。| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-flow.png)\"\n    },\n    {\n        \"idType\": \"decision-making\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\",\n        \"name\": \"决策\",\n        \"markdown\": \"## 用途\\n大模型会根据节点输入，结合提示词内容，判断您填写的意图，决定后续的逻辑走向\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | guide（引用）| 代码-guide |\\n | food（引用） | 代码-food | \\n | hotel（引用）| 代码-hotel | \\n## 提示词\\n根据攻略{{guide}}、美食偏好{{food}}、酒店位置{{hotel}}决定走不同的意图\\n## 意图\\n意图一：旅游攻略意图描述：如果想查询旅游攻略，走该分支 意图二：美食推荐意图描述：如果想获取地方美食推荐，走该分支 意图三：酒店推荐意图描述：如果想获取酒店住宿推荐，走该分支 其他：以上分支均不满足要求，走此分支 \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-decision.png)\"\n    },\n    {\n        \"idType\": \"if-else\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\",\n        \"name\": \"分支器\",\n        \"markdown\": \"## 用途\\n根据设立的条件，判断选择分支走向\\n## 示例\\n### 输入\\n| 条件  | \\n |----------------|\\n  | 条件一：变量\\\"开始-query\\\"包含旅游或攻略（当被引用的开始节点的query变量包含旅游或攻略字样，进入这个分支） 否则：当条件不符合设定的任何条件，则进入此分支| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-branch.jpg)\"\n    },\n    {\n        \"idType\": \"iteration\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\",\n        \"name\": \"迭代\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-iteration.png\",\n        \"markdown\": \"## 用途\\n该节点用于处理循环逻辑，仅支持嵌套一次\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | locations（Array）| 代码-locations |\\n### 输出\\n | 变量名 | 变量值 |\\n |------------|--------|\\n | outputList（Array）| [{\\\"合肥旅游攻略：\\\"},{\\\"南京旅游攻略：\\\"},{\\\"上海旅游攻略:\\\"}]| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-iteration.png)\"\n    },\n    {\n        \"idType\": \"node-variable\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\",\n        \"name\": \"变量存储器\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-var-storage.png\",\n        \"markdown\": \"## 用途\\n可定义多个变量，在整个多轮会话期间持续生效，用于多轮会话期间内容保存，新建会话或者删除聊天记录后，变量将会清空\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n |----------------|----------------------|\\n | question| 开始-query |\\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-var-storage.png)\"\n    },\n    {\n        \"idType\": \"extractor-parameter\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\",\n        \"name\": \"变量提取器\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-var-extractor.png\",\n        \"markdown\": \"## 用途\\n结合提取变量描述，将上一节点输出的自然语言进行提取\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n|----------------|----------------------|\\n| location | 将问题中的地点名词提取出来 |\\n| day | 将问题中的游玩天数名词提取出来 |\\n| person | 将问题中的人数名词提取出来 |\\n| data | 将问题中的日期名词提取出来 |\\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-var-extractor.png)\"\n    },\n    {\n        \"idType\": \"message\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\",\n        \"name\": \"消息\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-message.png\",\n        \"markdown\": \"## 消息\\n## 用途\\n在工作流中可以对中间过程的产物进行输出\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n|----------------|----------------------|\\n| result（引用）| 大模型-output |\\n| result1（引用）| 大模型-output1 |\\n### 输出\\n| 变量名 | 变量值 |\\n|------------|--------|\\n| 大模型-output| 回答内容：就您询问的问题，给您提供以下两种解决方案：方案一：{{result}}方案二：{{result1}}| \\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-message.png)\"\n    },\n    {\n        \"idType\": \"text-joiner\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\",\n        \"name\": \"文本拼接\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-text-joiner.png\",\n        \"markdown\": \"## 用途\\n将定义过的变量用{{变量名}}的方式引用，节点会按照拼接规则输出内容\\n## 示例\\n### 输入\\n| 参数名 | 参数值 |\\n|----------------|----------------------|\\n| age（input）| 18 |\\n| name（input）| 小明 |\\n\\n## 规则\\n我是{{name}}，今年{{age}}岁了。\\n\\n### 输出\\n| 变量名 | 变量值 |\\n|------------|--------|\\n| output（String）| 我是小明，今年18岁了。|\\n\\n![占位图片](https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-text-joiner.png)\"\n    },\n    {\n        \"idType\": \"agent\",\n        \"name\": \"Agent智能决策\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n        \"markdown\": \"## 用途\\n该节点主要依据用户选择的策略进行工具智能调度，同时根据输入的提示词，调用选定的大模型，对提示词作出回答。\\n## 示例\\n###输入\\n| 参数名字 | 参数值 |\\n |----------------|----------------------|\\n | Input | 开始/AGENT_USER_INPUT |\\n## Agent策略\\n选择相应的策略，当前的ReAct策略可用于指导大模型完成复杂任务的结构化思考和决策过程。\\n## 工具列表\\n支持在已发布列表里同时勾选并添加多个工具或 MCP，最多添加 30 个。\\n## 自定义MCP服务器地址\\n支持自定义添加MCP服务器地址，上限3个。\\n## 提示词\\n该模块分为3个部分：\\n- **角色设定（非必填）**：让大模型按照特定的角色/输出格式进行交流的过程；\\n- **思考步骤（非必填）**：是否要干预大模型的推理过程，大模型会依据思考提示和决策策略进行调度；\\n- **用户查询/提问（query）（必填）**：用户的问题和指令，让模型知道我们想要什么。 \\n## 最大轮次\\n大模型的推理轮次，建议推理轮次大于等于工具数量，当前最大轮次为100轮，默认为10轮。\\n## 输出\\n | 参数名字 | 参数值 | 描述 |\\n |------------|--------|--------------------|\\n | Reasonging | String | 大模型思考过程 |\\n | Output | String | 大模型输出 |\"\n    },\n    {\n        \"idType\": \"knowledge-pro-base\",\n        \"name\": \"知识库pro\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"markdown\": \"## 用途\\n在复杂的场景下，通过智能策略调用知识库，可以指定知识库进行知识检索和总结回复。\\n## 回答模式\\n选择用于对问题进行拆解以及对召回结果进行总结的大模型。\\n## 策略选择\\n## Agentic RAG\\n适用于处理问题涉及多个方面，需要分解为多个子问题进行检索，例如“如何提升学生的综合素质”、可拆分成“学术成绩”、“身心健康”等多个子问题。\\n## Long RAG\\n专注于长文档内容的理解与生成，适用于长文档相关任务。\\n## 示例\\n### 输入\\n| 参数名字 | 参数值 | 描述 |\\n |----------------|----------------------|----------------------|\\n | query | String | 用户输入 |\\n## 知识库\\n选择相应的知识库，进行参数设置，用于筛选与 用户问题相似度最高的文本片段，系统同时会根据选用模型上下文窗口大小动态调整分段数量。当问题被分解时，最终汇总的片段数量为设定的top k乘以问题数。例如，一个问题分解为3个子问题，设定为召回3个片段，最终汇总3✖3=9个片段。\\n## 回答规则\\n非必填，如果有输出要求限制或对特殊情况的说明请在此补充，例如:回答用户的问题，如果没有找到答案时，请直接告诉我“不知道”。\\n### 输出\\n | 参数名字 | 参数值 | 描述 |\\n |------------|--------|--------------------|\\n | Reasonging | String | 大模型思考过程 |\\n | Output | String | 大模型输出 |\\n | result| （Array\\\\<Object\\\\>） | 召回结果\"\n    },\n    {\n        \"idType\": \"question-answer\",\n        \"name\": \"问答\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBot/test4/answer-new2.png\",\n        \"markdown\": \"## 用途\\n该节点支持中间环节向用户进行提问操作，提供预置选项提问与开放式问题提问两种方式。\\n\\n## 示例1（选项回复）\\n\\n| 参数名字 | 参数值 |\\n|-----------|--------------------------------------------------|\\n| Input     | 开始/AGENT_USER_INPUT                          |\\n| 提问内容 | 去旅游是个超棒的想法呀！能让你暂时摆脱日常的琐碎，去感受不一样的风景和文化~你目前有没有大概的方向或者想法呢？ |\\n| 回答模式 | 选项回复                                       |\\n| 设置选项内容 | A：自然风光类 B：历史文化类 C：都市繁华类 |\\n\\n### 输出\\n\\n| 参数名字 | 参数值 | 描述         |\\n|----------|--------|--------------|\\n| query    | String | 该节点提问内容 |\\n| id       | String | 用户回复选项   |\\n| content  | String | 用户回复内容   |\\n\\n---\\n\\n## 示例2（直接回复）\\n\\n| 参数名字   | 参数值                                     |\\n|------------|--------------------------------------------|\\n| Input      | 开始/AGENT_USER_INPUT                     |\\n| 提问内容   | 你想要去哪旅游？目的地类型？旅游时间？预算？ |\\n| 回答模式   | 直接回复                                   |\\n\\n### 输出\\n\\n| 参数名字 | 参数值 | 描述         |\\n|----------|--------|--------------|\\n| query    | String | 该节点提问内容 |\\n| content  | String | 用户回复内容   |\\n\\n### 参数抽取\\n\\n| 参数名字 | 参数值 | 描述       | 默认值 | 是否必要 |\\n|----------|--------|------------|--------|----------|\\n| city     | String | 地点       | --     | 是       |\\n| type     | String | 目的地类型 | --     | 是       |\\n| time     | Number | 行程时长   | --     | 是       |\\n| budget   | String | 预算       | --     | 是       |\\n\"\n    },\n    {\n        \"idType\": \"database\",\n        \"name\": \"数据库\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/user/sparkBot_1752568522509_database_icon.svg\",\n        \"markdown\": \"## 用途\\n该节点可以连接指定的数据库，对数据库进行新增、查询、编辑、删除等常见操作，实现动态的数据管理。\\n\\n## 示例\\n\\n### 输入\\n\\n| 参数名字 | 参数值 |\\n|-----------|--------------------------------------------------|\\n| Input     | 开始/AGENT_USER_INPUT                          |\\n\\n### 输出\\n\\n| 参数名字 | 参数值 | 描述         |\\n|----------|--------|--------------|\\n| isSuccess    | Boolean| SQL语句执行状态标识，成功true，失败false |\\n| message       | String | 失败原因   |\\n| outputList  | （Array\\\\<Object\\\\>）| 执行结果   |\\n\"\n    }\n]', 1, '', '2000-01-01 00:00:00', '2025-07-24 16:49:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1459, 'WORKFLOW_CHANNEL', 'api', 'API', '发布为API', 1, '完成配置后，即可接入到个人应用中使用。', '2000-01-01 00:00:00', '2025-01-06 17:02:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1460, 'SPECIAL_USER', 'workflow-all-view', NULL, '100000039012', 1, NULL, '2000-01-01 00:00:00', '2024-12-03 19:16:07');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1461, 'WORKFLOW_CHANNEL', 'ixf-personal', 'i讯飞-个人版', '发布至新版本i讯飞中', 0, '无需审核，个人版本仅供个人使用和对话，无法分享给他人，也无法拉入群内。', '2000-01-01 00:00:00', '2024-12-19 11:10:51');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1463, 'WORKFLOW_CHANNEL', 'ixf-team', 'i讯飞-团队版', '发布至新版本i讯飞中', 0, '需要经过审核，团队版本支持分享给他人使用，支持拉入群内使用。', '2000-01-01 00:00:00', '2024-12-19 11:10:51');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1465, 'WORKFLOW_CHANNEL', 'aiui', '交互链路', '发布至AIUI智能体平台', 1, '发布并审核通过后，即可在aiui平台进行配置。', '2000-01-01 00:00:00', '2024-12-13 10:15:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1467, 'WORKFLOW_CHANNEL', 'sparkdesk', '星火Desk/APP', '发布至讯飞星火desk，以及星火app（App、网页版）', 0, '发布并审核通过后，即可在星火desk和星火App体验该智能体。', '2000-01-01 00:00:00', '2024-12-19 11:10:51');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1469, 'WORKFLOW_CHANNEL', 'square', '工作流广场', '发布至星辰工作流广场', 1, '发布成功后，用户即可在广场使用。', '2000-01-01 00:00:00', '2025-03-24 17:50:37');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1470, 'SWITCH', 'EvalTaskStatusGetJob', '0', '0', 1, '1', '2000-01-01 00:00:00', '2025-01-08 11:41:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1472, 'PROMPT', 'new-intent', '', '### 工作职责描述    你是一个文本分类引擎，需要分析文本数据，并根据用户的输入和分类的描述认真思考并确定分配类别。### 任务    你的任务是只给输入文本分配一个类别，并且只能在输出中返回一个类别。此外，您需要从文本中提取与分类相关的关键字，若完全没有相关性可以为空。### 输入格式    输入文本在变量input_text中。类别是一个列表，变量Categories中包含字段category_id、category_name、category_desc。严格按照分类说明认真思考，以提高分类精度。### 历史记忆    这是人类和助手之间的聊天历史记录，在<histories></histories> XML标签中。    <histories>            </histories>### 约束    不要在响应中包含JSON数组以外的任何内容。    ### 输出格式    ``````json{\\\"category_name\\\": \\\"\\\"}``````    ### 以下是需要分析的文本数据    $coreText', 1, '新决策节点的prompt', '2000-01-01 00:00:00', '2025-01-14 15:45:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1473, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'null', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lme990528,lm479a5b8,lmt4do9o3', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1475, 'LLM_WORKFLOW_FILTER', 'xfyun', 'null', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1477, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'spark-llm', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1479, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'decision-making', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1481, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'extractor-parameter', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1483, 'LLM_WORKFLOW_FILTER', 'xfyun', 'extractor-parameter', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1485, 'LLM_WORKFLOW_FILTER', 'xfyun', 'decision-making', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1487, 'LLM_WORKFLOW_FILTER', 'xfyun', 'spark-llm', '', 0, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1488, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '固定节点', '{\"idType\":\"node-start\",\"type\":\"开始节点\",\"position\":{\"x\":100,\"y\":300},\"data\":{\"label\":\"开始\",\"description\":\"工作流的开启节点，用于定义流程调用所需的业务变量信息。\",\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"开始节点\"},\"inputs\":[],\"outputs\":[{\"id\":\"\",\"name\":\"AGENT_USER_INPUT\",\"deleteDisabled\":true,\"required\":true,\"schema\":{\"type\":\"string\",\"default\":\"用户本轮对话输入内容\"}}],\"nodeParam\":{},\"allowInputReference\":false,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\"}}', 1, '开始节点', '2000-01-01 00:00:00', '2024-10-18 10:49:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1490, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '固定节点', '{\"idType\":\"node-end\",\"type\":\"结束节点\",\"position\":{\"x\":1000,\"y\":300},\"data\":{\"label\":\"结束\",\"description\":\"工作流的结束节点，用于输出工作流运行后的最终结果。\",\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"结束节点\"},\"inputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[],\"nodeParam\":{\"outputMode\":1,\"template\":\"\",\"streamOutput\":true},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\"}}', 1, '结束节点', '2000-01-01 00:00:00', '2025-04-09 14:57:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1492, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"idType\": \"spark-llm\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"大模型\",\n    \"description\": \"根据输入的提示词，调用选定的大模型，对提示词作出回答\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"大模型\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"nodeParam\":\n        {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"template\": \"\",\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"respFormat\": 0,\n            \"llmId\": 110,\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            }\n        },\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\"\n    }\n}', 1, '大模型', '2000-01-01 00:00:00', '2025-07-24 18:56:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1494, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\"idType\":\"ifly-code\",\"nodeType\":\"基础节点\",\"aliasName\":\"代码\",\"description\":\"面向开发者提供代码开发能力，目前仅支持python语言，允许使用该节点已定义的变量作为参数传入，返回语句用于输出函数的结果\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"代码\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"key0\",\"schema\":{\"type\":\"string\",\"default\":\"\"}},{\"id\":\"\",\"name\":\"key1\",\"schema\":{\"type\":\"array-string\",\"default\":\"\"}},{\"id\":\"\",\"name\":\"key2\",\"schema\":{\"type\":\"object\",\"default\":\"\",\"properties\":[{\"id\":\"\",\"name\":\"key21\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"}]}}],\"nodeParam\":{\"code\":\"def main(input):\\n    ret = {\\n        \\\"key0\\\": input + \\\"hello\\\",\\n        \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],\\n        \\\"key2\\\": {\\\"key21\\\": \\\"hi\\\"}\\n    }\\n    return ret\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\"}}', 1, '代码', '2000-01-01 00:00:00', '2024-10-21 17:06:50');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1496, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\"idType\":\"knowledge-base\",\"nodeType\":\"基础节点\",\"aliasName\":\"知识库\",\"description\":\"调用知识库，可以指定知识库进行知识检索和答复\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"知识库\"},\"inputs\":[{\"id\":\"\",\"name\":\"query\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"results\",\"schema\":{\"type\":\"array-object\",\"properties\":[{\"id\":\"\",\"name\":\"score\",\"type\":\"number\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"docId\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"title\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"content\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"context\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"references\",\"type\":\"object\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"}]},\"required\":true,\"nameErrMsg\":\"\"}],\"nodeParam\":{\"repoId\":[],\"repoList\":[],\"topN\":3,\"score\":0.2},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\"}}', 1, '知识库', '2000-01-01 00:00:00', '2025-07-24 16:46:06');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1498, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '工具', '{\"idType\":\"plugin\",\"nodeType\":\"工具\",\"aliasName\":\"工具\",\"description\":\"通过添加外部工具，快捷获取技能，满足用户需求\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"工具\"},\"inputs\":[],\"outputs\":[],\"nodeParam\":{\"appId\":\"4eea957b\",\"code\":\"\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\"}}', 1, '工具', '2000-01-01 00:00:00', '2024-10-18 10:52:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1500, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '工具', '{\"idType\":\"flow\",\"nodeType\":\"工具\",\"aliasName\":\"工作流\",\"description\":\"快速集成已发布工作流，高效复用已有能力\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"工作流\"},\"inputs\":[],\"outputs\":[],\"nodeParam\":{\"appId\":\"\",\"flowId\":\"\",\"uid\":\"\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\"}}', 1, '工作流', '2000-01-01 00:00:00', '2025-05-16 11:10:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1502, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\n    \"idType\": \"decision-making\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"决策\",\n    \"description\": \"结合输入的参数与填写的意图，决定后续的逻辑走向\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"决策\"\n        },\n        \"nodeParam\":\n        {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"uid\": \"2171\",\n            \"intentChains\":\n            [\n                {\n                    \"intentType\": 2,\n                    \"name\": \"\",\n                    \"description\": \"\",\n                    \"id\": \"intent-one-of::4724514d-ffc8-4412-bf7f-13cc3375110d\"\n                },\n                {\n                    \"intentType\": 1,\n                    \"name\": \"default\",\n                    \"description\": \"默认意图\",\n                    \"id\": \"intent-one-of::506841e4-3f6c-40b1-a804-dc5ffe723b34\"\n                }\n            ],\n            \"reasonMode\": 1,\n            \"model\": \"spark\",\n            \"useFunctionCall\": true,\n            \"serviceId\": \"bm4\",\n            \"promptPrefix\": \"\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"Query\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"class_name\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\"\n    }\n}', 1, '决策', '2000-01-01 00:00:00', '2025-07-24 18:56:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1504, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\"idType\":\"if-else\",\"nodeType\":\"分支器\",\"aliasName\":\"分支器\",\"description\":\"根据设立的条件，判断选择分支走向\",\"data\":{\"nodeMeta\":{\"nodeType\":\"分支器\",\"aliasName\":\"分支器\"},\"nodeParam\":{\"cases\":[{\"id\":\"branch_one_of::\",\"level\":1,\"logicalOperator\":\"and\",\"conditions\":[{\"id\":\"\",\"leftVarIndex\":null,\"rightVarIndex\":null,\"compareOperator\":null}]},{\"id\":\"branch_one_of::\",\"level\":999,\"logicalOperator\":\"and\",\"conditions\":[]}]},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{\"nodeId\":\"\",\"name\":\"\"}}}},{\"id\":\"\",\"name\":\"input1\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{\"nodeId\":\"\",\"name\":\"\"}}}}],\"outputs\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\"}}', 1, '分支器', '2000-01-01 00:00:00', '2024-10-18 10:52:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1506, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\"idType\":\"iteration\",\"nodeType\":\"基础节点\",\"aliasName\":\"迭代\",\"description\":\"该节点用于处理循环逻辑，仅支持嵌套一次\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"迭代\"},\"nodeParam\":{},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"array-string\",\"default\":\"\"}}],\"iteratorNodes\":[],\"iteratorEdges\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\"}}', 1, '迭代', '2000-01-01 00:00:00', '2024-10-18 10:55:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1508, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '转换', '{\"idType\":\"node-variable\",\"nodeType\":\"基础节点\",\"aliasName\":\"变量存储器\",\"description\":\"可定义多个变量，在整个多轮会话期间持续生效，用于多轮会话期间内容保存，新建会话或者删除聊天记录后，变量将会清空\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"变量存储器\"},\"nodeParam\":{\"method\":\"set\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\"}}', 1, '变量存储器', '2000-01-01 00:00:00', '2024-10-18 10:55:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1510, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '转换', '{\n    \"idType\": \"extractor-parameter\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"变量提取器\",\n    \"description\": \"结合提取变量描述，将上一节点输出的自然语言进行提取\",\n    \"data\":\n    {\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"变量提取器\"\n        },\n        \"nodeParam\":\n        {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"reasonMode\": 1\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"description\": \"\"\n                },\n                \"required\": true\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\"\n    }\n}', 1, '变量提取器', '2000-01-01 00:00:00', '2025-07-24 18:56:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1512, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '转换', '{\"idType\":\"text-joiner\",\"nodeType\":\"工具\",\"aliasName\":\"文本处理节点\",\"description\":\"用于按照指定格式规则处理多个字符串变量\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"文本拼接\"},\"nodeParam\":{\"prompt\":\"\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\"}}', 1, '文本处理节点', '2000-01-01 00:00:00', '2025-03-25 16:33:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1514, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '其他', '{\"idType\":\"message\",\"nodeType\":\"基础节点\",\"aliasName\":\"消息\",\"description\":\"在工作流中可以对中间过程的产物进行输出\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"消息\"},\"nodeParam\":{\"template\":\"\",\"startFrameEnabled\":false},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output_m\",\"schema\":{\"type\":\"string\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\"}}', 1, '消息', '2000-01-01 00:00:00', '2024-10-18 10:57:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1516, 'mingduan', '1', NULL, 'http://maas-api.cn-huabei-1.xf-yun.com/v1', 1, 'https://spark-api-open.xf-yun.com/v2', '2000-01-01 00:00:00', '2025-04-18 17:49:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1517, 'AI_CODE', 'DS_V3_domain', '1', 'xdeepseekv3', 1, NULL, '2000-01-01 00:00:00', '2025-03-13 09:36:01');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1519, 'AI_CODE', 'DS_V3_url', '1', 'wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat', 1, NULL, '2000-01-01 00:00:00', '2025-03-13 09:36:01');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1520, 'LLM', 'base-model', 'xdeepseekr1', 'xdeepseekr1', 1, 'DeepSeek-R1', '2000-01-01 00:00:00', NULL);
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1522, 'LLM', 'base-model', 'xdeepseekv3', 'xdeepseekv3', 1, 'DeepSeek-V3', '2000-01-01 00:00:00', '2024-07-08 11:06:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1524, 'TAG', 'FLOW_TAGS', '交通出行', 'travel', 1, '交通出行', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1526, 'TAG', 'FLOW_TAGS', '休闲娱乐', 'recreation', 1, '休闲娱乐', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1528, 'TAG', 'FLOW_TAGS', '医药健康', 'medicine', 1, '医药健康', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1530, 'TAG', 'FLOW_TAGS', '影视音乐', 'film-music', 1, '影视音乐', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1532, 'TAG', 'FLOW_TAGS', '教育百科', 'educationEncyclopedia', 1, '教育百科', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1534, 'TAG', 'FLOW_TAGS', '新闻资讯', 'news', 1, '新闻资讯', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1536, 'TAG', 'FLOW_TAGS', '母婴儿童', 'mother-to-child', 1, '母婴儿童', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1538, 'TAG', 'FLOW_TAGS', '生活常用', 'daily-life', 1, '生活常用', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1540, 'TAG', 'FLOW_TAGS', '金融理财', 'financialPlanning', 1, '金融理财', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1542, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'spark-llm', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,x1,xop3qwen30b,xop3qwen235b,xop3qwen14b,xop3qwen8b,xopgptoss20b,xopgptoss120b,xdsv3t128k,xdeepseekv31', 1, '', '2000-01-01 00:00:00', '2025-08-27 11:23:59');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1544, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'decision-making', 'bm3,bm3.5,bm4', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1546, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'extractor-parameter', 'bm3,bm3.5,bm4', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1548, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'extractor-parameter', 'bm3,bm3.5,bm4,xdeepseekv3,xdeepseekr1', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1549, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'agent', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1550, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'decision-making', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xqwen257bchat,xdeepseekv3,xdeepseekr1', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1551, 'LLM_WORKFLOW_FILTER', 'xfyun', 'agent', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1552, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'spark-llm', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,x1,xop3qwen30b,xop3qwen235b,xopgptoss20b,xopgptoss120b,xdsv3t128k,xdeepseekv31', 1, '', '2000-01-01 00:00:00', '2025-08-27 11:23:59');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1553, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\n    \"aliasName\": \"Agent智能决策\",\n    \"idType\": \"agent\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"customParameterType\": \"deepseekr1\",\n                \"name\": \"REASONING_CONTENT\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"模型思考过程\",\n                    \"type\": \"string\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"input\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"智能体节点\",\n            \"nodeType\": \"Agent节点\"\n        },\n        \"nodeParam\":\n        {\n            \"appId\": \"\",\n            \"serviceId\": \"xdeepseekv3\",\n            \"llmId\": 141,\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"modelConfig\":\n            {\n                \"domain\": \"xdeepseekv3\",\n                \"api\": \"wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat\",\n                \"agentStrategy\": 1\n            },\n            \"instruction\":\n            {\n                \"reasoning\": \"\",\n                \"answer\": \"\",\n                \"query\": \"\"\n            },\n            \"plugin\":\n            {\n                \"tools\":\n                [],\n                \"toolsList\":\n                [],\n                \"mcpServerIds\":\n                [],\n                \"mcpServerUrls\":\n                [],\n                \"workflowIds\":\n                []\n            },\n            \"maxLoopCount\": 10\n        }\n    },\n    \"description\": \"依据任务需求，通过选择合适的工具列表，实现大 模型的智能调度\",\n    \"nodeType\": \"基础节点\"\n}', 1, 'agent', '2000-01-01 00:00:00', '2025-07-24 18:56:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1554, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'null', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1555, 'WORKFLOW_CHANNEL', 'mcp', 'MCP Server', '发布为MCP Server', 1, '发布成功后即可在工作流编排时调用，并在agent决策节点工具列表查看', '2000-01-01 00:00:00', '2025-04-09 14:15:54');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1556, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'null', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1557, 'WORKFLOW_AGENT_STRATEGY', 'agentStrategy', 'ReACT (支持MCP Tools)', '用于指导大模型完成复杂任务的结构化思考和决策过程', 1, '1', '2000-01-01 00:00:00', '2025-04-03 17:50:48');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1558, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'null', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1559, 'MCP_MODEL_API_REFLECT', 'mcp', 'xdeepseekv3', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1560, 'LLM_WORKFLOW_FILTER', 'xfyun', 'null', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1561, 'MCP_MODEL_API_REFLECT', 'mcp', 'xdeepseekr1', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1562, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'spark-llm', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1563, 'MCP_SERVER_URL_PREFIX', 'mcp', 'https://xingchen-api.xf-yun.com/mcp/xingchen/flow/{0}/sse', '', 1, '', '2000-01-01 00:00:00', '2025-04-09 15:04:01');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1564, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'decision-making', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1566, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'extractor-parameter', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1568, 'LLM_WORKFLOW_FILTER', 'xfyun', 'extractor-parameter', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1570, 'LLM_WORKFLOW_FILTER', 'xfyun', 'decision-making', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1571, 'LLM_WORKFLOW_FILTER', 'xingchen', 'model_square', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1572, 'LLM_WORKFLOW_FILTER', 'xfyun', 'spark-llm', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1574, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'agent', 'xdeepseekv3,xdeepseekr1,x1,xop3qwen30b,xop3qwen235b,xdsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-08-28 15:26:02');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1576, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'agent', 'xdeepseekv3,xdeepseekr1,x1,xop3qwen30b,xop3qwen235b,xdsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-08-28 15:25:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1577, 'LLM_WORKFLOW_MODEL_FILTER', 'think', '思考模型', 'x1,xdeepseekr1,xop3qwen30b,xop3qwen235b,xopgptoss120b', 1, '', '2000-01-01 00:00:00', '2025-08-07 11:23:32');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1578, 'WORKFLOW_NODE_TEMPLATE', '1,2', '逻辑', '{\n    \"aliasName\": \"Agent智能决策\",\n    \"idType\": \"agent\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"customParameterType\": \"deepseekr1\",\n                \"name\": \"REASONING_CONTENT\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"模型思考过程\",\n                    \"type\": \"string\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"input\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"智能体节点\",\n            \"nodeType\": \"Agent节点\"\n        },\n        \"nodeParam\":\n        {\n            \"appId\": \"\",\n            \"serviceId\": \"xdeepseekv3\",\n            \"llmId\": 141,\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"modelConfig\":\n            {\n                \"domain\": \"xdeepseekv3\",\n                \"api\": \"wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat\",\n                \"agentStrategy\": 1\n            },\n            \"instruction\":\n            {\n                \"reasoning\": \"\",\n                \"answer\": \"\",\n                \"query\": \"\"\n            },\n            \"plugin\":\n            {\n                \"tools\":\n                [],\n                \"toolsList\":\n                [],\n                \"mcpServerIds\":\n                [],\n                \"mcpServerUrls\":\n                [],\n                \"workflowIds\":\n                []\n            },\n            \"maxLoopCount\": 10\n        }\n    },\n    \"description\": \"依据任务需求，通过选择合适的工具列表，实现大 模型的智能调度\",\n    \"nodeType\": \"基础节点\"\n}', 1, 'agent', '2000-01-01 00:00:00', '2025-07-24 09:44:58');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1580, 'LLM_FILTER', 'summary_agent', '大模型agent过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-12 10:38:48');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1582, 'LLM_FILTER_PRE', 'summary_agent', '大模型agent过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b,bm4', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-21 15:34:23');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1583, 'TAG', 'TOOL_TAGS_V2', '插件', 'tool', 1, '', '2025-04-01 17:51:32', '2025-08-19 20:53:55');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1585, 'TAG', 'TOOL_TAGS_V2', '文档处理', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1587, 'TAG', 'TOOL_TAGS_V2', '信息检索', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1589, 'TAG', 'TOOL_TAGS_V2', '实用工具', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1591, 'TAG', 'TOOL_TAGS_V2', '生活娱乐', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1593, 'TAG', 'TOOL_TAGS_V2', 'MCP工具', '', 1, '', '2025-04-01 17:51:32', '2025-08-19 20:53:55');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1595, 'LLM_WORKFLOW_FILTER_PRE', 'xingchen', 'model_square', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,xopqwenqwq32b,xdeepseekv32,x1,xop3qwen30b,xop3qwen235b,xopgptoss20b,xopgptoss120b', 1, '', '2000-01-01 00:00:00', '2025-08-06 15:46:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1597, 'LLM_WORKFLOW_FILTER', 'self-model', '控制自定义模型适配节点', NULL, 1, '', '2000-01-01 00:00:00', '2025-09-20 20:42:01');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1599, 'MULTI_ROUNDS_ALIAS_NAME', 'MUTI_ROUNDS_ALIAS_NAME', '多轮对话支持节点', 'decision-making,spark-llm,agent,flow', 1, '', '2000-01-01 00:00:00', '2025-08-20 15:07:43');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1601, 'MODEL_SECRET_KEY', 'public_key', '公钥', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAh3iFD+BIGlCY083ItUwJFscMyept2dVl3Zs7/S6V+NnreiUJtjkAsok++eL5BYr9Jz5KULnpQv47tPhqAJd+xxzWZRfNVABHnox61GWlqqgWogbcPZWP/rzGt6c2jOkgbUVdCU7gc+EfKKZ5Fq99A5c6vDQi5u9GozElf2VnLKrH+u0tRpmrQDNSSfW0ifxUNGTvat6cJOIGRC4iUqdI+S3d3BSJEZ9VOAuAs1xmLTZciVkmSM+/bCEfdhChAh1wfpBMOb8Lu2JUXf3tfjZtNOXWRRw70NQu9Xmn3RE0ajZDODLg+xqJ3AR3fgAhunHT8W6d/PVHSM1cFUFap4P4IQIDAQAB', 1, '', '2000-01-01 00:00:00', '2025-04-15 11:57:22');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1603, 'MODEL_SECRET_KEY', 'private_key', '私钥', 'MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCHeIUP4EgaUJjTzci1TAkWxwzJ6m3Z1WXdmzv9LpX42et6JQm2OQCyiT754vkFiv0nPkpQuelC/ju0+GoAl37HHNZlF81UAEeejHrUZaWqqBaiBtw9lY/+vMa3pzaM6SBtRV0JTuBz4R8opnkWr30Dlzq8NCLm70ajMSV/ZWcsqsf67S1GmatAM1JJ9bSJ/FQ0ZO9q3pwk4gZELiJSp0j5Ld3cFIkRn1U4C4CzXGYtNlyJWSZIz79sIR92EKECHXB+kEw5vwu7YlRd/e1+Nm005dZFHDvQ1C71eafdETRqNkM4MuD7GoncBHd+ACG6cdPxbp389UdIzVwVQVqng/ghAgMBAAECggEAVF/Z8ENuZQVhyjlXEqPi3U7oRjI+bPgeU+HFgTEssyt3IEJFRDtIleopURXup2cjuPdw7cp83/7cTSCTVP8GNRle5uPmPLVX5gX00qjkf9/lCNFhBvJKFwyYb/YzYZwpWCVlhtCbt1C1SWo17M0r/bqJGIMYYeERi76mbixIEGb60mCOPyj3tZfTCXzeSaZqgEV+9SjpgBcUj0/NSn1nxOZ8SeESQHrkz+ZfUZ/VDxdICW2Hy0hGJfaR9VZHGlVnabbtreUni5JDMf7o6xSPKvThp2rIIQd4H1PLRMFeWprigQ+6vfxeMHnyS5ggag5wGclFAargqAXq0WFO3xxoSQKBgQDbAt+T0jjHvv6d/924JiJf9awoGQ6Xjbu2z2xVNHg32Hew+u+0CiRsmo1nMMS//JxieNjSRWT6SJ482xAXgmGsdBKrSf+G5s3RpBCLDOYAvx67XmxB86CCpXVwomejGCZhdD4Vm2sB68ansbW1/y2Z2UHAG6wbsC7llzrxXvwAbwKBgQCeWbVDqLCSbsHgkn7LMPVCozH0GICQN92d5oyc8veZFa8uXq7fVIpELXv/S1TDVcpwEbIUnQycFRgj/si3QPZyIAAsKf6tx8MKy+BYm81eJqc0AuUc8wrmSJdcEOBDSaZvNMVX+bmqQItDTSJ+rv5fC8+zhv+gNRH+4cuOPxC4bwKBgA4/2ZwciWU1oAtXom1gzcvAiDrzpmdl6VizljDVAR1hECiLqxzjrAsE4z5bhfGX1fTyN+k2aqN+Jg1/k0R0TzaRNsW+QsncKngBXLIvXKefx7gZJKIF3+OgMEvrxSJvZ8/faEqvmf6+AGbYwSHeQHFKGWUOZ9xFUkfN1x/tNigxAoGAXtLffhWtLvMOPHndXbYCmJX7Wu21Ryd9GYou1+mTJWPb1Iu0cl5AshT+tOEacCKWqEegeUGWhH0JSLzQ2xQWwD6ze77mGJCQFo4B2W3rLB8/byDwrEZKV55OrT4Z3ZFkDiHurwEHEpG2E2ZEatJF1wrOpPYJa5l8HkJ+T78qNxcCgYBZbJJFCL7buF5ZO6dhZVMSLlERL0q5XKbCWXe/987g2fMfi7t6UrQAQ6zxvqBFrapodcsGjxbeXerJzNHqkQ4fySHZ8qeiwSlx8tCbBiO0PR7pY4mlXratJjpHvQbs1yXUcGZ3obyuK1Oe+sa+jYJC54UVz08g2+nGiQGho5x1FQ==', 1, '', '2000-01-01 00:00:00', '2025-04-15 11:57:22');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1605, 'SPARK_PRO_QR_CODE', 'qr', '二维码', 'https://oss-beijing-m8.openstorage.cn/SparkBot/test4/weichat_qr.jpeg', 1, NULL, '2025-04-01 17:51:32', '2025-06-05 17:07:41');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1607, 'MCP_MODEL_API_REFLECT', 'mcp', 'xop3qwen30b', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1609, 'MCP_MODEL_API_REFLECT', 'mcp', 'xop3qwen235b', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:11');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1611, 'LLM_WORKFLOW_MODEL_FILTER', 'multiMode', '多模态模型', 'image_understandingv3,image_understanding', 1, '', '2000-01-01 00:00:00', '2025-03-12 15:45:05');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1613, 'PERSONAL_MODEL', '20000001', 'imagev3', '{\n    \"llmSource\": 1,\n    \"llmId\": 10000005,\n    \"name\": \"图像理解V3\",\n    \"patchId\": \"0\",\n    \"domain\": \"imagev3\",\n    \"serviceId\": \"image_understandingv3\",\n    \"status\": 1,\n    \"info\": \"{\\\"conc\\\":2,\\\"domain\\\":\\\"generalv3.5\\\",\\\"expireTs\\\":\\\"2025-05-31\\\",\\\"qps\\\":2,\\\"tokensPreDay\\\":1000,\\\"tokensTotal\\\":1000,\\\"llmServiceId\\\":\\\"bm3.5\\\"}\"\n    \"info\": \"\",\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/aicloud/llm/resource/image/model/icon_iflyspark_96.png\",\n    \"tag\":\n    [],\n    \"url\": \"wss://spark-api.cn-huabei-1.xf-yun.com/v2.1/image\",\n    \"modelId\": 0,\n    \"isThink\":false,\n    \"multiMode\":true\n}', 1, '', '2000-01-01 00:00:00', '2025-05-08 15:04:22');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1615, 'WORKFLOW_KNOWLEDGE_PRO_STRATEGY', 'knowledgeProStrategy', 'Agentic RAG', '适用于复杂问题的场景，擅长将复杂问题分解为多个子问题进行检索。', 1, '1', '2000-01-01 00:00:00', '2025-05-15 11:28:26');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1617, 'WORKFLOW_KNOWLEDGE_PRO_STRATEGY', 'knowledgeProStrategy', 'Long RAG', '适用于对长文档内容理解与生成任务。', 1, '2', '2000-01-01 00:00:00', '2025-05-15 11:28:26');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1621, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'knowledge-pro-base', 'xdeepseekv3', 1, '', '2000-01-01 00:00:00', '2025-05-21 15:11:12');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1623, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'knowledge-pro-base', 'xdeepseekv3', 1, '', '2000-01-01 00:00:00', '2025-05-21 15:11:12');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1627, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'question-answer', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xopqwenqwq32b,xdeepseekv32,x1,deepseek-ollama', 1, '', '2000-01-01 00:00:00', '2025-05-21 10:30:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1629, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'question-answer', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xopqwenqwq32b,xdeepseekv32,x1,deepseek-ollama', 1, '', '2000-01-01 00:00:00', '2025-05-21 10:30:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1631, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'question-answer', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1633, 'LLM_WORKFLOW_FILTER', 'xfyun', 'question-answer', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1635, 'LLM_WORKFLOW_FILTER', 'xfyun', 'knowledge-pro-base', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1637, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'knowledge-pro-base', '', 1, '', '2000-01-01 00:00:00', '2025-09-20 20:11:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1639, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"aliasName\": \"知识库 Pro\",\n    \"idType\": \"knowledge-pro-base\",\n    \"data\": {\n        \"outputs\": [\n           {\n    \"id\": \"52f0819d-e403-43e1-85d3-50519ccfcbcf\",\n    \"name\": \"output\",\n    \"schema\": {\n        \"type\": \"string\",\n        \"default\": \"\"\n    },\n    \"required\": false,\n    \"nameErrMsg\": \"\"\n},\n{\n    \"id\": \"87247b70-f05c-4125-a416-e2c41be2e1c1\",\n    \"name\": \"result\",\n    \"schema\": {\n        \"type\": \"array-object\",\n        \"default\": \"\",\n        \"properties\": [\n            {\n                \"id\": \"a9db3a72-abb2-4512-a598-13b8294fce60\",\n                \"name\": \"source_id\",\n                \"type\": \"string\",\n                \"default\": \"\",\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            },\n            {\n                \"id\": \"c1711905-9f7e-4408-918e-33d57d39f9bc\",\n                \"name\": \"chunk\",\n                \"type\": \"array-object\",\n                \"default\": \"\",\n                \"required\": false,\n                \"nameErrMsg\": \"\",\n                \"properties\": [\n                    {\n                        \"id\": \"b8b50110-2abc-4732-9c96-6f3b7bad9259\",\n                        \"name\": \"chunk_context\",\n                        \"type\": \"string\",\n                        \"default\": \"\",\n                        \"required\": false,\n                        \"nameErrMsg\": \"\"\n                    },\n                    {\n                        \"id\": \"95ffea3c-4008-4df8-84a8-013079e72276\",\n                        \"name\": \"score\",\n                        \"type\": \"number\",\n                        \"default\": \"\",\n                        \"required\": false,\n                        \"nameErrMsg\": \"\",\n                        \"properties\": []\n                    }\n                ]\n            }\n        ]\n    },\n    \"required\": false,\n    \"nameErrMsg\": \"\"\n}\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"inputs\": [\n            {\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                },\n                \"name\": \"query\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\": {\n            \"aliasName\": \"知识库 Pro\",\n            \"nodeType\": \"工具\"\n        },\n        \"nodeParam\": {\n			\"repoTopK\":3,\n             \"topK\": 4,\n            \"repoIds\": [ ],\n            \"repoList\":[],\n            \"ragType\": 1,\n            \"url\": \"https://maas-api.cn-huabei-1.xf-yun.com/v2\",\n            \"domain\": \"xdeepseekv3\",\n            \"temperature\": 0.5,\n            \"maxTokens\": 2048,\n            \"model\": \"xdeepseekv3\",\n            \"llmId\": 141,\n             \"serviceId\":\"xdeepseekv3\",\n            \"answerRole\": \"\",\n            \"repoType\": 1\n        }\n    },\n    \"description\": \"通过智能策略调用知识库，可以指定知识库进行知识检索和总结答复\",\n    \"nodeType\": \"基础节点\"\n}', 1, '知识库pro节点', '2000-01-01 00:00:00', '2025-07-24 18:56:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1641, 'mingduan', 'x1', 'x1', 'https://spark-api-open.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-21 14:50:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1643, 'mingduan', 'bm4', 'bm4', 'https://spark-api-open.xf-yun.com/v1', 1, '', '2000-01-01 00:00:00', '2025-05-21 14:50:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1645, 'mingduan', 'AK:SK', '', 'x1,bm4', 1, 'https://spark-api-open.xf-yun.com/v2', '2000-01-01 00:00:00', '2025-05-21 15:42:44');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1647, 'MODEL_URL_CONFIG', 'Agent节点', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 'xdeepseekv3,xdeepseekr1,xop3qwen30b,xop3qwen235b', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:35:31');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1649, 'WORKFLOW_NODE_TEMPLATE', '1,2', '基础节点', '{\n    \"aliasName\": \"知识库 Pro\",\n    \"idType\": \"knowledge-pro-base\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"52f0819d-e403-43e1-85d3-50519ccfcbcf\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                },\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            },\n            {\n                \"id\": \"87247b70-f05c-4125-a416-e2c41be2e1c1\",\n                \"name\": \"result\",\n                \"schema\":\n                {\n                    \"type\": \"array-object\",\n                    \"default\": \"\",\n                    \"properties\":\n                    [\n                        {\n                            \"id\": \"a9db3a72-abb2-4512-a598-13b8294fce60\",\n                            \"name\": \"source_id\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": false,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"c1711905-9f7e-4408-918e-33d57d39f9bc\",\n                            \"name\": \"chunk\",\n                            \"type\": \"array-object\",\n                            \"default\": \"\",\n                            \"required\": false,\n                            \"nameErrMsg\": \"\",\n                            \"properties\":\n                            [\n                                {\n                                    \"id\": \"b8b50110-2abc-4732-9c96-6f3b7bad9259\",\n                                    \"name\": \"chunk_context\",\n                                    \"type\": \"string\",\n                                    \"default\": \"\",\n                                    \"required\": false,\n                                    \"nameErrMsg\": \"\"\n                                },\n                                {\n                                    \"id\": \"95ffea3c-4008-4df8-84a8-013079e72276\",\n                                    \"name\": \"score\",\n                                    \"type\": \"number\",\n                                    \"default\": \"\",\n                                    \"required\": false,\n                                    \"nameErrMsg\": \"\",\n                                    \"properties\":\n                                    []\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"query\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"知识库 Pro\",\n            \"nodeType\": \"工具\"\n        },\n        \"nodeParam\":\n        {\n            \"repoTopK\": 3,\n            \"llmId\": 141,\n            \"topK\": 4,\n            \"repoIds\":\n            [],\n            \"repoList\":\n            [],\n            \"ragType\": 1,\n            \"url\": \"https://maas-api.cn-huabei-1.xf-yun.com/v2\",\n            \"domain\": \"xdeepseekv3\",\n            \"temperature\": 0.5,\n            \"maxTokens\": 2048,\n            \"model\": \"xdeepseekv3\",\n            \"serviceId\": \"xdeepseekv3\",\n            \"answerRole\": \"\",\n            \"repoType\": 1,\n            \"score\": 0.2\n        }\n    },\n    \"description\": \"通过智能策略调用知识库，可以指定知识库进行知识检索和总结答复\",\n    \"nodeType\": \"基础节点\"\n}', 0, '知识库pro节点', '2000-01-01 00:00:00', '2025-09-20 21:49:54');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1681, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '固定节点', '{\"idType\":\"node-start\",\"type\":\"开始节点\",\"position\":{\"x\":100,\"y\":300},\"data\":{\"label\":\"开始\",\"description\":\"工作流的开启节点，用于定义流程调用所需的业务变量信息。\",\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"开始节点\"},\"inputs\":[],\"outputs\":[{\"id\":\"\",\"name\":\"AGENT_USER_INPUT\",\"deleteDisabled\":true,\"required\":true,\"schema\":{\"type\":\"string\",\"default\":\"用户本轮对话输入内容\"}}],\"nodeParam\":{},\"allowInputReference\":false,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\"}}', 1, '开始节点', '2000-01-01 00:00:00', '2024-10-18 10:49:36');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1683, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '固定节点', '{\"idType\":\"node-end\",\"type\":\"结束节点\",\"position\":{\"x\":1000,\"y\":300},\"data\":{\"label\":\"结束\",\"description\":\"工作流的结束节点，用于输出工作流运行后的最终结果。\",\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"结束节点\"},\"inputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[],\"nodeParam\":{\"outputMode\":1,\"template\":\"\",\"streamOutput\":true},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\"}}', 1, '结束节点', '2000-01-01 00:00:00', '2025-04-09 14:57:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1685, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '基础节点', '{\"idType\":\"spark-llm\",\"nodeType\":\"基础节点\",\"aliasName\":\"大模型\",\"description\":\"根据输入的提示词，调用选定的大模型，对提示词作出回答\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"大模型\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\",\"default\":\"\"}}],\"nodeParam\":{\"maxTokens\":2048,\"temperature\":0.5,\"topK\":4,\"auditing\":\"default\",\"domain\":\"4.0Ultra\",\"template\":\"\",\"model\":\"spark\",\"serviceId\":\"bm4\",\"respFormat\":0,\"patchId\":\"0\",\"url\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"appId\":\"d1590f30\",\"uid\":\"2171\",\"enableChatHistoryV2\":{\"isEnabled\":false,\"rounds\":1}},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\"}}', 1, '大模型', '2000-01-01 00:00:00', '2025-03-24 14:47:14');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1687, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '基础节点', '{\"idType\":\"ifly-code\",\"nodeType\":\"基础节点\",\"aliasName\":\"代码\",\"description\":\"面向开发者提供代码开发能力，目前仅支持python语言，允许使用该节点已定义的变量作为参数传入，返回语句用于输出函数的结果\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"代码\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"key0\",\"schema\":{\"type\":\"string\",\"default\":\"\"}},{\"id\":\"\",\"name\":\"key1\",\"schema\":{\"type\":\"array-string\",\"default\":\"\"}},{\"id\":\"\",\"name\":\"key2\",\"schema\":{\"type\":\"object\",\"default\":\"\",\"properties\":[{\"id\":\"\",\"name\":\"key21\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"}]}}],\"nodeParam\":{\"code\":\"def main(input):\\n    ret = {\\n        \\\"key0\\\": input + \\\"hello\\\",\\n        \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],\\n        \\\"key2\\\": {\\\"key21\\\": \\\"hi\\\"}\\n    }\\n    return ret\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\"}}', 1, '代码', '2000-01-01 00:00:00', '2024-10-21 17:06:50');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1689, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '基础节点', '{\"idType\":\"knowledge-base\",\"nodeType\":\"基础节点\",\"aliasName\":\"知识库\",\"description\":\"调用知识库，可以指定知识库进行知识检索和答复\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"知识库\"},\"inputs\":[{\"id\":\"\",\"name\":\"query\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"results\",\"schema\":{\"type\":\"array-object\",\"properties\":[{\"id\":\"\",\"name\":\"score\",\"type\":\"number\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"docId\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"title\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"content\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"context\",\"type\":\"string\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"},{\"id\":\"\",\"name\":\"references\",\"type\":\"object\",\"default\":\"\",\"required\":true,\"nameErrMsg\":\"\"}]},\"required\":true,\"nameErrMsg\":\"\"}],\"nodeParam\":{\"repoId\":[],\"repoList\":[],\"topN\":3},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\"}}', 1, '知识库', '2000-01-01 00:00:00', '2024-10-18 11:03:49');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1691, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '工具', '{\"idType\":\"plugin\",\"nodeType\":\"工具\",\"aliasName\":\"工具\",\"description\":\"通过添加外部工具，快捷获取技能，满足用户需求\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"工具\"},\"inputs\":[],\"outputs\":[],\"nodeParam\":{\"appId\":\"4eea957b\",\"code\":\"\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\"}}', 1, '工具', '2000-01-01 00:00:00', '2024-10-18 10:52:15');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1693, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '工具', '{\"idType\":\"flow\",\"nodeType\":\"工具\",\"aliasName\":\"工作流\",\"description\":\"快速集成已发布工作流，高效复用已有能力\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"工作流\"},\"inputs\":[],\"outputs\":[],\"nodeParam\":{\"appId\":\"\",\"flowId\":\"\",\"uid\":\"\"},\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\"}}', 1, '工作流', '2000-01-01 00:00:00', '2025-05-16 11:10:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1695, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\"idType\":\"decision-making\",\"nodeType\":\"基础节点\",\"aliasName\":\"决策\",\"description\":\"结合输入的参数与填写的意图，决定后续的逻辑走向\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"决策\"},\"nodeParam\":{\"maxTokens\":2048,\"temperature\":0.5,\"topK\":4,\"auditing\":\"default\",\"domain\":\"4.0Ultra\",\"enableChatHistoryV2\":{\"isEnabled\":false,\"rounds\":1},\"uid\":\"2171\",\"intentChains\":[{\"intentType\":2,\"name\":\"\",\"description\":\"\",\"id\":\"intent-one-of::4724514d-ffc8-4412-bf7f-13cc3375110d\"},{\"intentType\":1,\"name\":\"default\",\"description\":\"默认意图\",\"id\":\"intent-one-of::506841e4-3f6c-40b1-a804-dc5ffe723b34\"}],\"reasonMode\":1,\"model\":\"spark\",\"useFunctionCall\":true,\"serviceId\":\"bm4\",\"promptPrefix\":\"\",\"patchId\":\"0\",\"url\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"appId\":\"d1590f30\"},\"inputs\":[{\"id\":\"\",\"name\":\"Query\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"class_name\",\"schema\":{\"type\":\"string\",\"default\":\"\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\"}}', 1, '决策', '2000-01-01 00:00:00', '2025-03-24 14:47:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1697, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\"idType\":\"if-else\",\"nodeType\":\"分支器\",\"aliasName\":\"分支器\",\"description\":\"根据设立的条件，判断选择分支走向\",\"data\":{\"nodeMeta\":{\"nodeType\":\"分支器\",\"aliasName\":\"分支器\"},\"nodeParam\":{\"cases\":[{\"id\":\"branch_one_of::\",\"level\":1,\"logicalOperator\":\"and\",\"conditions\":[{\"id\":\"\",\"leftVarIndex\":null,\"rightVarIndex\":null,\"compareOperator\":null}]},{\"id\":\"branch_one_of::\",\"level\":999,\"logicalOperator\":\"and\",\"conditions\":[]}]},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{\"nodeId\":\"\",\"name\":\"\"}}}},{\"id\":\"\",\"name\":\"input1\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{\"nodeId\":\"\",\"name\":\"\"}}}}],\"outputs\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\"}}', 1, '分支器', '2000-01-01 00:00:00', '2024-10-18 10:52:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1699, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\"idType\":\"iteration\",\"nodeType\":\"基础节点\",\"aliasName\":\"迭代\",\"description\":\"该节点用于处理循环逻辑，仅支持嵌套一次\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"迭代\"},\"nodeParam\":{},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"array-string\",\"default\":\"\"}}],\"iteratorNodes\":[],\"iteratorEdges\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\"}}', 1, '迭代', '2000-01-01 00:00:00', '2024-10-18 10:55:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1701, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '转换', '{\"idType\":\"node-variable\",\"nodeType\":\"基础节点\",\"aliasName\":\"变量存储器\",\"description\":\"可定义多个变量，在整个多轮会话期间持续生效，用于多轮会话期间内容保存，新建会话或者删除聊天记录后，变量将会清空\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"变量存储器\"},\"nodeParam\":{\"method\":\"set\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\"}}', 1, '变量存储器', '2000-01-01 00:00:00', '2024-10-18 10:55:30');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1703, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '转换', '{\"idType\":\"extractor-parameter\",\"nodeType\":\"基础节点\",\"aliasName\":\"变量提取器\",\"description\":\"结合提取变量描述，将上一节点输出的自然语言进行提取\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"变量提取器\"},\"nodeParam\":{\"maxTokens\":2048,\"temperature\":0.5,\"topK\":4,\"auditing\":\"default\",\"domain\":\"4.0Ultra\",\"model\":\"spark\",\"serviceId\":\"bm4\",\"patchId\":\"0\",\"url\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"appId\":\"d1590f30\",\"uid\":\"2171\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\",\"description\":\"\"},\"required\":true}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\"}}', 1, '变量提取器', '2000-01-01 00:00:00', '2025-03-24 14:47:33');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1705, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '转换', '{\"idType\":\"text-joiner\",\"nodeType\":\"工具\",\"aliasName\":\"文本处理节点\",\"description\":\"用于按照指定格式规则处理多个字符串变量\",\"data\":{\"nodeMeta\":{\"nodeType\":\"工具\",\"aliasName\":\"文本拼接\"},\"nodeParam\":{\"prompt\":\"\"},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output\",\"schema\":{\"type\":\"string\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":true,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\"}}', 1, '文本处理节点', '2000-01-01 00:00:00', '2025-03-25 16:33:24');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1707, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '其他', '{\"idType\":\"message\",\"nodeType\":\"基础节点\",\"aliasName\":\"消息\",\"description\":\"在工作流中可以对中间过程的产物进行输出\",\"data\":{\"nodeMeta\":{\"nodeType\":\"基础节点\",\"aliasName\":\"消息\"},\"nodeParam\":{\"template\":\"\",\"startFrameEnabled\":false},\"inputs\":[{\"id\":\"\",\"name\":\"input\",\"schema\":{\"type\":\"string\",\"value\":{\"type\":\"ref\",\"content\":{}}}}],\"outputs\":[{\"id\":\"\",\"name\":\"output_m\",\"schema\":{\"type\":\"string\"}}],\"references\":[],\"allowInputReference\":true,\"allowOutputReference\":false,\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\"}}', 1, '消息', '2000-01-01 00:00:00', '2024-10-18 10:57:28');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1709, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\n  \"aliasName\": \"Agent智能决策\",\n  \"idType\": \"agent\",\n  \"data\": {\n    \"outputs\": [\n  {\n    \"id\": \"\",\n    \"customParameterType\": \"deepseekr1\",\n    \"name\": \"REASONING_CONTENT\",\n    \"nameErrMsg\": \"\",\n    \"schema\": {\n      \"default\": \"模型思考过程\",\n      \"type\": \"string\"\n    }\n  },\n  {\n    \"id\": \"\",\n    \"name\": \"output\",\n    \"nameErrMsg\": \"\",\n    \"schema\": {\n      \"default\": \"\",\n      \"type\": \"string\"\n    }\n  }\n],\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"inputs\": [\n      {\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        },\n        \"name\": \"input\",\n        \"id\": \"\"\n      }\n    ],\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n    \"allowOutputReference\": true,\n    \"nodeMeta\": {\n      \"aliasName\": \"智能体节点\",\n      \"nodeType\": \"Agent节点\"\n    },\n    \"nodeParam\": {\n     \"appId\": \"\",\n     \"serviceId\": \"xdeepseekv3\",\n    \"enableChatHistoryV2\":{\n\"isEnabled\": false,\n\"rounds\": 1\n},\n      \"modelConfig\": {\n          \"domain\": \"xdeepseekv3\",\n          \"api\": \"wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat\",\n          \"agentStrategy\": 1\n      },\n      \"instruction\": {\n          \"reasoning\": \"\",\n          \"answer\": \"\",\n          \"query\": \"\"\n      },\n      \"plugin\": {\n          \"tools\": [\n\n          ],\n          \"toolsList\": [\n\n          ],\n          \"mcpServerIds\": [\n\n          ],\n          \"mcpServerUrls\": [\n\n          ],\n          \"workflowIds\": [\n\n          ]\n      },\n      \"maxLoopCount\": 10\n    }\n  },\n  \"description\": \"依据任务需求，通过选择合适的工具列表，实现大 模型的智能调度\",\n  \"nodeType\": \"基础节点\"\n}', 1, 'agent', '2000-01-01 00:00:00', '2025-04-08 20:02:25');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1715, 'SELF_MODEL_COMMON_CONFIG', 'config', '自定义模型公共配置', '{\n    \"config\":\n    [\n        {\n            \"standard\": true,\n            \"constraintType\": \"range\",\n            \"default\": 2048,\n            \"constraintContent\":\n            [\n                {\n                    \"name\": 1\n                },\n                {\n                    \"name\": 8192\n                }\n            ],\n            \"name\": \"最大回复长度\",\n            \"fieldType\": \"int\",\n            \"initialValue\": 2048,\n            \"key\": \"maxTokens\",\n            \"required\": true\n        },\n        {\n            \"standard\": true,\n            \"constraintContent\":\n            [\n                {\n                    \"name\": 0\n                },\n                {\n                    \"name\": 1\n                }\n            ],\n            \"precision\": 0.1,\n            \"required\": true,\n            \"constraintType\": \"range\",\n            \"default\": 0.5,\n            \"name\": \"核采样阈值\",\n            \"fieldType\": \"float\",\n            \"initialValue\": 0.5,\n            \"key\": \"temperature\"\n        },\n        {\n            \"standard\": true,\n            \"constraintType\": \"range\",\n            \"default\": 4,\n            \"constraintContent\":\n            [\n                {\n                    \"name\": 1\n                },\n                {\n                    \"name\": 6\n                }\n            ],\n            \"name\": \"生成多样性\",\n            \"fieldType\": \"int\",\n            \"initialValue\": 4,\n            \"key\": \"topK\",\n            \"required\": true\n        }\n    ]\n}', 1, '', '2000-01-01 00:00:00', '2025-06-05 19:15:55');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1717, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"aliasName\": \"问答节点\",\n    \"idType\": \"question-answer\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\",\n                    \"description\": \"该节点提问内容\"\n                },\n                \"name\": \"query\",\n                \"id\": \"\",\n                \"required\": true\n            },\n            {\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\",\n                    \"description\": \"用户回复内容\"\n                },\n                \"name\": \"content\",\n                \"id\": \"\",\n                \"required\": true\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"input\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBot/test4/answer-new2.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"问答节点\",\n            \"nodeType\": \"基础节点\"\n        },\n        \"nodeParam\":\n        {\n            \"question\": \"\",\n            \"timeout\": 3,\n            \"needReply\": false,\n            \"answerType\": \"direct\",\n            \"directAnswer\":\n            {\n                \"handleResponse\": false,\n                \"maxRetryCounts\": 2\n            },\n            \"optionAnswer\":\n            [\n                {\n                    \"id\": \"option-one-of::01a35034-8e7a-4a84-83ee-c51d4cbe2660\",\n                    \"name\": \"A\",\n                    \"type\": 2,\n                    \"content\": \"\",\n                    \"content_type\": \"string\"\n                },\n                {\n                    \"id\": \"option-one-of::1df8b2ac-c228-4195-8978-54f87b1bdbb9\",\n                    \"name\": \"B\",\n                    \"type\": 2,\n                    \"content\": \"\",\n                    \"content_type\": \"string\"\n                },\n                {\n                    \"id\": \"option-one-of::646527fa-a9eb-4216-a324-95fc5601d2bf\",\n                    \"name\": \"default\",\n                    \"type\": 1,\n                    \"content\": \"\",\n                    \"content_type\": \"string\"\n                }\n            ],\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"domain\": \"4.0Ultra\",\n            \"appId\": \"d1590f30\",\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"model\": \"spark\",\n            \"llmId\": 110,\n            \"serviceId\": \"bm4\"\n        }\n    },\n    \"description\": \"支持在此节点向用户提问，接收用户回复，并输出回复内容及提取的信息\",\n    \"nodeType\": \"基础节点\"\n}', 1, '问答节点', '2000-01-01 00:00:00', '2025-07-24 18:56:10');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1719, 'SPARK_PRO_QR_CODE', 'qr_feishu', '飞书二维码', 'https://oss-beijing-m8.openstorage.cn/SparkBot/test4/feishu_qr.jpeg', 1, NULL, '2025-04-01 17:51:32', '2025-06-05 16:46:35');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1731, 'MCP_MODEL_API_REFLECT', 'mcp', 'x1', 'https://spark-api-open.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-06-10 17:52:48');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1735, 'IP_BLACK_LIST', 'ip_balck_list', 'ip黑名单', '0.0.0.0,127.0.0.1,localhost', 1, NULL, '2022-06-10 00:00:00', '2025-09-08 10:42:02');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1737, 'NETWORK_SEGMENT_BLACK_LIST', 'network_segment_balck_list', '网段黑名单', '192.168.0.0/16,100.64.0.0/10', 1, NULL, '2022-06-10 00:00:00', '2025-09-08 10:44:56');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1739, 'DOMAIN_BLACK_LIST', 'domain_balck_list', '域名黑名单', 'cloud.iflytek.com,monojson.com,ssrf.security.private,ssrf-prod.security.private', 1, NULL, '2022-06-10 00:00:00', '2025-09-08 10:42:13');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1743, 'WORKFLOW_NODE_TEMPLATE', '1,2', '基础节点', '{\n    \"aliasName\": \"问答节点\",\n    \"idType\": \"question-answer\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\",\n                    \"description\": \"该节点提问内容\"\n                },\n                \"name\": \"query\",\n                \"id\": \"\",\n                \"required\": true\n            },\n            {\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\",\n                    \"description\": \"用户回复内容\"\n                },\n                \"name\": \"content\",\n                \"id\": \"\",\n                \"required\": true\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"input\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBot/test4/answer-new2.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"问答节点\",\n            \"nodeType\": \"基础节点\"\n        },\n        \"nodeParam\":\n        {\n            \"question\": \"\",\n            \"timeout\": 3,\n            \"needReply\": false,\n            \"answerType\": \"direct\",\n            \"directAnswer\":\n            {\n                \"handleResponse\": false,\n                \"maxRetryCounts\": 2\n            },\n            \"optionAnswer\":\n            [\n                {\n                    \"id\": \"option-one-of::01a35034-8e7a-4a84-83ee-c51d4cbe2660\",\n                    \"name\": \"A\",\n                    \"type\": 2,\n                    \"content\": \"\",\n                    \"content_type\": \"string\"\n                },\n                {\n                    \"id\": \"option-one-of::1df8b2ac-c228-4195-8978-54f87b1bdbb9\",\n                    \"name\": \"B\",\n                    \"type\": 2,\n                    \"content\": \"\",\n                    \"content_type\": \"string\"\n                },\n                {\n                    \"id\": \"option-one-of::646527fa-a9eb-4216-a324-95fc5601d2bf\",\n                    \"name\": \"default\",\n                    \"type\": 1,\n                    \"content\": \"\",\n                    \"content_type\": \"string\"\n                }\n            ],\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"domain\": \"4.0Ultra\",\n            \"appId\": \"d1590f30\",\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"model\": \"spark\",\n            \"llmId\": 110,\n            \"serviceId\": \"bm4\"\n        }\n    },\n    \"description\": \"支持在此节点向用户提问，接收用户回复，并输出回复内容及提取的信息\",\n    \"nodeType\": \"基础节点\"\n}', 1, '问答节点', '2000-01-01 00:00:00', '2025-07-15 11:05:04');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1765, 'DEFAULT_SLICE_RULES_CBG', '1', 'CBG默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[256,1024]}', 1, '', '2025-06-18 17:21:37', '2025-06-18 17:21:44');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1767, 'CUSTOM_SLICE_RULES_CBG', '1', 'CBG自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-06-18 17:21:42', '2025-08-14 17:22:34');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1769, 'DEFAULT_SLICE_RULES_SPARK', '1', 'Spark默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-06-18 17:21:41', '2025-06-18 17:21:46');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1771, 'CUSTOM_SLICE_RULES_SPARK', '1', 'Spark自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-06-18 17:21:43', '2025-06-18 17:21:47');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1773, 'DEFAULT_SLICE_RULES_AIUI', '1', 'AIUI默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-07-03 15:18:40', '2025-07-03 15:18:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1775, 'CUSTOM_SLICE_RULES_AIUI', '1', 'AIUI自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-07-03 15:18:40', '2025-07-03 15:18:40');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1777, 'WORKFLOW_INIT_DATA', 'workflow', '工作流初始化data', '{\"nodes\":[{\"data\":{\"allowInputReference\":false,\"allowOutputReference\":true,\"description\":\"工作流的开启节点，用于定义流程调用所需的业务变量信息。\",\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\",\"inputs\":[],\"label\":\"开始\",\"nodeMeta\":{\"aliasName\":\"开始节点\",\"nodeType\":\"基础节点\"},\"nodeParam\":{},\"outputs\":[{\"deleteDisabled\":true,\"id\":\"0918514b-72a8-4646-8dd9-ff4a8fc26d44\",\"name\":\"AGENT_USER_INPUT\",\"required\":true,\"schema\":{\"default\":\"用户本轮对话输入内容\",\"type\":\"string\"}}],\"status\":\"\",\"updatable\":false},\"dragging\":false,\"height\":256,\"id\":\"node-start::d61b0f71-87ee-475e-93ba-f1607f0ce783\",\"position\":{\"x\":-25.109019607843152,\"y\":521.7086666666667},\"positionAbsolute\":{\"x\":-25.109019607843152,\"y\":521.7086666666667},\"selected\":false,\"type\":\"开始节点\",\"width\":658},{\"data\":{\"allowInputReference\":true,\"allowOutputReference\":false,\"description\":\"工作流的结束节点，用于输出工作流运行后的最终结果。\",\"icon\":\"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\",\"inputs\":[{\"id\":\"82de2b42-a059-4c98-bffb-b6b4800fcac9\",\"name\":\"output\",\"schema\":{\"type\":\"string\",\"value\":{\"content\":{},\"type\":\"ref\"}}}],\"label\":\"结束\",\"nodeMeta\":{\"aliasName\":\"结束节点\",\"nodeType\":\"基础节点\"},\"nodeParam\":{\"template\":\"\",\"streamOutput\":true,\"outputMode\":1},\"outputs\":[],\"references\":[],\"status\":\"\",\"updatable\":false},\"dragging\":false,\"height\":617,\"id\":\"node-end::cda617af-551e-462e-b3b8-3bb9a041bf88\",\"position\":{\"x\":886.8833333333332,\"y\":343.91588235294114},\"positionAbsolute\":{\"x\":886.8833333333332,\"y\":343.91588235294114},\"selected\":true,\"type\":\"结束节点\",\"width\":408}],\"edges\":[]}', 1, NULL, '2022-06-10 00:00:00', '2025-06-26 15:01:02');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1779, 'DOMAIN_WHITE_LIST', 'domain_white_list', '域名白名单', 'inner-sparklinkthirdapi.aipaasapi.cn,agentbuilder.aipaasapi.cn,dx-cbm-ocp-agg-search-inner.xf-yun.com,dx-cbm-ocp-gateway.xf-yun.com,xingchen-agent-mcp.aicp.private,dx-spark-agentbuilder.aicp.private,vmselect.huabei.xf-yun.com,pre-agentbuilder.aipaasapi.cn,apisix-pre-in.iflytekauto.cn,csp-in.iflytekauto.cn,www.ctllm.com', 1, NULL, '2022-06-10 00:00:00', '2025-08-23 14:18:16');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1781, 'CUSTOM_SLICE_SEPERATORS_AIUI', '1', 'AIUI自定义分隔符', '[\n{\n\"id\": 1,\n\"name\": \"换行符\",\n\"symbol\": \"\\\\n\"\n},\n{\n\"id\": 2,\n\"name\": \"中文句号\",\n\"symbol\": \"。\"\n},\n{\n\"id\": 3,\n\"name\": \"英文句号\",\n\"symbol\": \".\"\n},\n{\n\"id\": 4,\n\"name\": \"中文叹号\",\n\"symbol\": \"！\"\n},\n{\n\"id\": 5,\n\"name\": \"英文叹号\",\n\"symbol\": \"!\"\n},\n{\n\"id\": 6,\n\"name\": \"中文问号\",\n\"symbol\": \"？\"\n},\n{\n\"id\": 7,\n\"name\": \"英文问号\",\n\"symbol\": \"?\"\n},\n{\n\"id\": 8,\n\"name\": \"中文分号\",\n\"symbol\": \"；\"\n},\n{\n\"id\": 9,\n\"name\": \"英文分号\",\n\"symbol\": \";\"\n},\n{\n\"id\": 10,\n\"name\": \"中文省略号\",\n\"symbol\": \"……\"\n},\n{\n\"id\": 11,\n\"name\": \"英文省略号\",\n\"symbol\": \"...\"\n}\n]', 1, '', '2025-07-24 15:02:00', '2025-07-24 15:02:00');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1783, 'CUSTOM_SLICE_SEPERATORS_CBG', '1', 'CBG自定义分隔符', '[\n{\n\"id\": 1,\n\"name\": \"换行符\",\n\"symbol\": \"\\\\n\"\n},\n{\n\"id\": 2,\n\"name\": \"中文句号\",\n\"symbol\": \"。\"\n},\n{\n\"id\": 3,\n\"name\": \"英文句号\",\n\"symbol\": \".\"\n},\n{\n\"id\": 4,\n\"name\": \"中文叹号\",\n\"symbol\": \"！\"\n},\n{\n\"id\": 5,\n\"name\": \"英文叹号\",\n\"symbol\": \"!\"\n},\n{\n\"id\": 6,\n\"name\": \"中文问号\",\n\"symbol\": \"？\"\n},\n{\n\"id\": 7,\n\"name\": \"英文问号\",\n\"symbol\": \"?\"\n},\n{\n\"id\": 8,\n\"name\": \"中文分号\",\n\"symbol\": \"；\"\n},\n{\n\"id\": 9,\n\"name\": \"英文分号\",\n\"symbol\": \";\"\n},\n{\n\"id\": 10,\n\"name\": \"中文省略号\",\n\"symbol\": \"……\"\n},\n{\n\"id\": 11,\n\"name\": \"英文省略号\",\n\"symbol\": \"...\"\n}\n]', 1, '', '2025-07-24 15:02:18', '2025-07-24 15:02:18');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1785, 'CUSTOM_SLICE_SEPERATORS_SPARK', '1', 'SPARK自定义分隔符', '[\n{\n\"id\": 1,\n\"name\": \"换行符\",\n\"symbol\": \"\\\\n\"\n},\n{\n\"id\": 2,\n\"name\": \"中文句号\",\n\"symbol\": \"。\"\n},\n{\n\"id\": 3,\n\"name\": \"英文句号\",\n\"symbol\": \".\"\n},\n{\n\"id\": 4,\n\"name\": \"中文叹号\",\n\"symbol\": \"！\"\n},\n{\n\"id\": 5,\n\"name\": \"英文叹号\",\n\"symbol\": \"!\"\n},\n{\n\"id\": 6,\n\"name\": \"中文问号\",\n\"symbol\": \"？\"\n},\n{\n\"id\": 7,\n\"name\": \"英文问号\",\n\"symbol\": \"?\"\n},\n{\n\"id\": 8,\n\"name\": \"中文分号\",\n\"symbol\": \"；\"\n},\n{\n\"id\": 9,\n\"name\": \"英文分号\",\n\"symbol\": \";\"\n},\n{\n\"id\": 10,\n\"name\": \"中文省略号\",\n\"symbol\": \"……\"\n},\n{\n\"id\": 11,\n\"name\": \"英文省略号\",\n\"symbol\": \"...\"\n}\n]', 1, '', '2025-07-24 15:02:38', '2025-07-24 15:02:38');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1787, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n\"aliasName\": \"数据库\",\n\"idType\": \"database\",\n\"data\": {\n\"outputs\": [\n{\n\"id\": \"\",\n\"name\": \"isSuccess\",\n\"nameErrMsg\": \"\",\n\"schema\": {\n\"default\": \"SQL语句执行状态标识，成功true，失败false\",\n\"type\": \"boolean\"\n}\n},\n{\n\"id\": \"\",\n\"name\": \"message\",\n\"nameErrMsg\": \"\",\n\"schema\": {\n\"default\": \"失败原因\",\n\"type\": \"string\"\n}\n},\n{\n\"id\": \"\",\n\"name\": \"outputList\",\n\"nameErrMsg\": \"\",\n\"schema\": {\n\"default\": \"执行结果\",\n\"type\": \"array-object\"\n}\n}\n],\n\"references\": [],\n\"allowInputReference\": true,\n\"inputs\": [\n{\n\"schema\": {\n\"type\": \"string\",\n\"value\": {\n\"type\": \"ref\",\n\"content\": {}\n}\n},\n\"name\": \"input\",\n\"id\": \"\"\n}\n],\n\"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/user/sparkBot_1752568522509_database_icon.svg\",\n\"allowOutputReference\": true,\n\"nodeMeta\": {\n\"aliasName\": \"数据库节点\",\n\"nodeType\": \"基础节点\"\n},\n\"nodeParam\": {\n\"mode\": 0\n}\n},\n\"description\": \"支持用户自定义的SQL完成对数据库的增删改查操作\",\n\"nodeType\": \"基础节点\"\n}', 1, '数据库节点', '2000-01-01 00:00:00', '2025-07-16 14:41:05');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1789, 'DB_TABLE_TEMPLATE', 'TB', '数据库字段导入模版', 'https://oss-beijing-m8.openstorage.cn/SparkBotDev/sparkBot/DB_TABLE_导入模板.xlsx', 1, NULL, '2025-07-10 10:50:48', '2025-07-11 10:01:47');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1791, 'WORKFLOW_NODE_TEMPLATE', '1,2', '基础节点', '{\r\n\"aliasName\": \"数据库\",\r\n\"idType\": \"database\",\r\n\"data\": {\r\n\"outputs\": [\r\n{\r\n\"id\": \"\",\r\n\"name\": \"isSuccess\",\r\n\"nameErrMsg\": \"\",\r\n\"schema\": {\r\n\"default\": \"SQL语句执行状态标识，成功true，失败false\",\r\n\"type\": \"boolean\"\r\n}\r\n},\r\n{\r\n\"id\": \"\",\r\n\"name\": \"message\",\r\n\"nameErrMsg\": \"\",\r\n\"schema\": {\r\n\"default\": \"失败原因\",\r\n\"type\": \"string\"\r\n}\r\n},\r\n{\r\n\"id\": \"\",\r\n\"name\": \"outputList\",\r\n\"nameErrMsg\": \"\",\r\n\"schema\": {\r\n\"default\": \"执行结果\",\r\n\"type\": \"array-object\"\r\n}\r\n}\r\n],\r\n\"references\": [],\r\n\"allowInputReference\": true,\r\n\"inputs\": [\r\n{\r\n\"schema\": {\r\n\"type\": \"string\",\r\n\"value\": {\r\n\"type\": \"ref\",\r\n\"content\": {}\r\n}\r\n},\r\n\"name\": \"input\",\r\n\"id\": \"\"\r\n}\r\n],\r\n\"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/user/sparkBot_1752568522509_database_icon.svg\",\r\n\"allowOutputReference\": true,\r\n\"nodeMeta\": {\r\n\"aliasName\": \"数据库节点\",\r\n\"nodeType\": \"基础节点\"\r\n},\r\n\"nodeParam\": {\r\n\"mode\": 0\r\n}\r\n},\r\n\"description\": \"支持用户自定义的SQL完成对数据库的增删改查操作\",\r\n\"nodeType\": \"基础节点\"\r\n}', 1, '数据库节点', '2000-01-01 00:00:00', '2025-07-25 16:31:32');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1793, 'EVAL_TASK_PROMPT', 'FIX', '测评纬度优化prompt', '#角色\n你是一个提示词优化专家，本次仅针对单一维度\" {{评估维度名称}}\"对下列\"原始提示词\"进行分析和优化，帮助用户在该维度上提升提示的质量。\n\n#原始提示词 \n{{context}}\n\n#请按照以下步骤思考： \n1、分析原提示中在“{{评估维度名称}}”方面的不足（例如：表达含糊不清、缺少必要信息等）。\n2、可对原始提示词进行优化，如：细化措辞、补充示例、明确格式等，确保提示在该维度上更为突出（例如，更加清晰或更为完整）。\n4、梳理提示词里对维度的评分标准，按4个等级维度描述。\n**评分标准**  \n   - 针对“{{评估维度名称}}”使用以下固定等级与分值，这一维度的四个等级描述，假设维度是“清晰度”：  \n   | 等级   | 分值  | 描述                                   |\n   | ------ | ----- | -------------------------------------  |\n   | **好**   | 4 分   | 目标与指令一目了然，无任何歧义。|\n   | **较好** | 3 分   | 大体清晰，仅有少量模糊之处，不影响理解。|\n   | **一般** | 2 分   | 表达部分模糊，需要根据上下文猜测意图。|\n   | **差**   | 1 分   | 指令含糊或前后矛盾，难以执行。|           \n\n#输出格式：\n\"\"\"\n##角色 \n你是一名对话流畅性的质量检查员，负责对\"用户输入\"和\"回复文本\"的质量进行评价。\n\n##评估流程\n1、检查语句是否通顺，是否存在语法错误（如搭配不当、成分残缺等）。\n2、分析逻辑连贯性，判断段落间、句子间的衔接是否自然，是否存在话题跳跃或逻辑断层。\n3、评估信息量是否适中，是否符合用户需求（如信息冗余或遗漏可能影响流畅性）。\n##评分标准/*按markdown格式*/\n| 等级   | 分值  | 描述                                   || ------ | ----- | -------------------------------------- || **好**   | 4 分   | 语句通顺、逻辑严谨、承接自然，信息量适中，整体对话如同人类交流般顺畅。 || **较好** | 3 分   | 基本流畅，仅有偶发小的语法或衔接瑕疵，不影响沟通效果。 || **一般** | 2 分   | 有若干语法或逻辑小错误，或衔接稍显生硬，但大体能理解意图。 || **差**   | 1 分   | 语法错误多、句式混乱、话题跳跃严重，严重妨碍对话连贯性。 |\n\n##输出样例\n{\"Score\":1,\"Reason\":\"智能体的回复语气、用词和内容完全符合其19世纪维多利亚时代英国管家的角色设定；回复贴合用户积极的情绪方向，并通过礼貌的鼓励语言回应了用户的愉快心情。\"}\n\"\"\"\n#输出要求：\n- 全文聚焦 **“{{评估维度名称}}”**，无需关注其他维度。  \n- 语言简洁分点，方便复制粘贴使用。  \n-给出一份专注于“{{评估维度名称}}”的结构化、可直接使用的新版提示词。  \n- 仅输出最终提示词优化后的结果，无须输出思考过程及优化建议\n-按照\"输出格式\"进行输出，其中\"输出样例\"严格按json格式输出，score为得分，reason为得分原因。 ', 1, '', '2025-07-31 10:52:49', '2025-07-31 10:52:49');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1795, 'EVAL_TASK_PROMPT', 'JUDGE', '评分维度评价prompt', '#输入\n你基于\"智能体设定\"，对\"用户输入\"的\"回复文本\"的进行{{评分维度}}评价。\n智能体/工作流设定：{{system_prompt}}\n用户输入：{{input}}\n回复文本：{{output}}\n\n#输出：\n得分：一个数字，表示满足Prompt中评分标准的程度。得分范围从 4 分到 1分，分别为4分（好）、3分（较好）、一般（2分）、差（1）分。\n原因：对得分的可读解释。你必须用一句话结束理由。\n格式：严格按json格式输出，score为得分，reason为得分原因。\n#输出格式  \n{\"Score\":3,\"Reason\":\"回复内容基本符合问题语境，但提及的次要案例未充分说明其与核心结论的关联性，导致局部逻辑稍显松散。\"} ', 1, '', '2025-07-31 10:52:49', '2025-07-31 10:52:49');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1797, 'ICON', 'rag', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/rag/Personal@1x.png', 1, 'SparkDesk-RAG', '2025-07-31 19:50:09', '2025-07-31 19:50:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1799, 'ICON', 'rag', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/rag/Spark@1x.png', 1, 'CBG-RAG', '2025-07-31 19:50:09', '2025-07-31 19:50:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1801, 'ICON', 'rag', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/rag/Stellar@1x.png', 1, 'AIUI-RAG2', '2025-07-31 19:50:09', '2025-07-31 19:50:09');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1811, 'SPACE_SWITCH_NODE', 'SPACE_SWITCH_NODE', '空间节点开关', '', 1, NULL, '2025-07-10 10:50:48', '2025-09-04 14:59:57');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1817, 'MCP_MODEL_API_REFLECT', 'mcp', 'xdeepseekv31', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1819, 'NODE_PREFIX_MODEL', 'switch', '应用大模型节点前缀配置', 'spark-llm,decision-making,extractor-parameter,agent,knowledge-pro-base,question-answer', 1, NULL, '2025-07-10 10:50:48', '2025-08-27 14:12:02');
INSERT INTO `config_info` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1821, 'DB_TABLE_RESERVED_KEYWORD', 'reserved_keyword', '数据库关键字', 'all,analyse,analyze,and,any,array,as,asc,asymmetric,authorization,binary,both,case,cast,check,collate,collation,column,concurrently,constraint,create,cross,current_catalog,current_date,current_role,current_schema,current_time,current_timestamp,current_user,default,deferrable,desc,distinct,do,else,end,except,false,fetch,for,foreign,freeze,from,full,grant,group,having,ilike,in,initially,inner,intersect,into,is,isnull,join,lateral,leading,left,like,limit,localtime,localtimestamp,natural,not,notnull,null,offset,on,only,or,order,outer,overlaps,placing,primary,references,returning,right,select,session_user,similar,some,symmetric,table,tablesample,then,to,trailing,true,union,unique,user,using,variadic,verbose,when,where,window,with', 1, NULL, '2025-07-10 10:50:48', '2025-08-12 16:34:24');
COMMIT;

-- ----------------------------
-- Table structure for config_info_en
-- ----------------------------
DROP TABLE IF EXISTS `config_info_en`;
CREATE TABLE `config_info_en`
(
    `id`          bigint  NOT NULL AUTO_INCREMENT COMMENT 'Primary key, starting from 10000',
    `category`    varchar(64)   DEFAULT NULL COMMENT 'Configuration category',
    `code`        varchar(128)  DEFAULT NULL COMMENT 'Configuration code, key',
    `name`        varchar(255)  DEFAULT NULL COMMENT 'Configuration name',
    `value`       text COMMENT 'Configuration content, value',
    `is_valid`    tinyint NOT NULL COMMENT 'Whether effective, 0-invalid, 1-valid',
    `remarks`     varchar(1000) DEFAULT NULL COMMENT 'Remarks, comments',
    `create_time` datetime      DEFAULT '2000-01-01 00:00:00' COMMENT 'Creation time',
    `update_time` datetime      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Configuration table - EN';

-- ----------------------------
-- Records of config_info_en
-- ----------------------------
BEGIN;
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1019, 'DOCUMENT_LINK', '1', 'SparkBotHelpDoc', 'https://experience.pro.iflyaicloud.com/aicloud-sparkbot-doc/', 1, '你好', '2023-08-17 00:00:00', '2024-09-03 11:51:23');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1021, 'COMPRESSED_FOLDER', '1', 'SparkBotSDK', 'https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/sdk%E6%8E%A5%E5%85%A5%E8%AF%B4%E6%98%8E.zip', 1, '', '2000-01-01 00:00:00', '2024-06-27 10:35:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1023, 'SPARKBOT_CONFIG', '1', 'SparkBotApi', '{\"sdkHtml\":\"<div className=\\\"sdk-content\\\">\\n      <p className=\\\"title\\\">Sparkbot接入文档</p>\\n      <h1>JS SDK</h1>\\n      <p>\\n        安装之前，请确保您已通过我们的平台注册或我们已为您提供了<b>AppId</b>。\\n        如果没有密钥，您将无法使用该SDK。\\n      </p>\\n      <hr></hr>\\n      <h2>JS SDK</h2>\\n      <p>\\n        要将 Sparkbot 与 JS SDK 一起使用，您需要在 HTML 文件中包含脚本标签。\\n      </p>\\n      <h3>浮动机器人</h3>\\n      <p style={{ margin: \'20px 0\' }}>\\n        浮动机器人非常简单。 只需将这 2 个脚本标签添加到您的 HTML 中即可。\\n      </p>\\n      <div className=\\\"code-content\\\">\\n        <div className=\\\"code-container\\\">\\n          <span className=\\\"normal\\\">&lt;</span>\\n          <span className=\\\"tagColor\\\">script&nbsp;</span>\\n          <span className=\\\"light\\\" style={{ whiteSpace: \'nowrap\' }}>\\n            src=\'https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/Sparkbot.js\'\\n            <span className=\\\"normal\\\">&gt;</span>\\n            <span className=\\\"normal\\\">&lt;/</span>\\n            <span className=\\\"tagColor\\\">script</span>\\n            <span className=\\\"normal\\\"> &gt;</span>\\n          </span>\\n          <br></br>\\n          <span className=\\\"normal\\\">&lt;</span>\\n          <span className=\\\"tagColor\\\">script</span>\\n          <span className=\\\"normal\\\"> &gt;</span>\\n          <br></br>\\n          <span style={{ marginLeft: 10 }}>Sparkbot</span>\\n          <span className=\\\"normal\\\">.</span>\\n          <span className=\\\"tagColor\\\">init</span>\\n          <span className=\\\"normal\\\">(&#123;</span>\\n          <br></br>\\n          <span className=\\\"light\\\" style={{ marginLeft: 20 }}>\\n            appId: \'您的appId\',\\n            <br></br>\\n            <span style={{ marginLeft: 20 }}>apiKey: \'您的apiKey\',</span>\\n            <br></br>\\n            <span style={{ marginLeft: 20 }}>apiSecret: \'您的apiSecret\'</span>\\n            <br></br>\\n          </span>\\n          <span className=\\\"normal\\\" style={{ marginLeft: 10 }}>\\n            &#125;)\\n          </span>\\n          <br></br>\\n          <span className=\\\"normal\\\">&lt;/</span>\\n          <span className=\\\"tagColor\\\">script</span>\\n          <span className=\\\"normal\\\"> &gt;</span>\\n        </div>\\n      </div>\\n    </div>\",\"sdkMd\":\"/pro-bucket/sparkBot/README.md\"}', 1, '', '2000-01-01 00:00:00', '2024-06-27 10:35:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1027, 'FILE_MANAGE_CONFIG', '', 'MAX_FOLDER_DEEP', '5', 1, '用于控制文件目录树的最大层级', '2000-01-01 00:00:00', '2024-06-27 10:35:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1029, 'SPARKBOT_DEFAULT_APP', '1', 'sparkbot默认应用', '{\n  \"name\": \"SparkBot Default Application\",\n  \"description\": \"Application created by default for SparkBot\",\n  \"businessInfo\": {\n    \"applyUserSource\": 1,\n    \"applyUserCode\": \"system\",\n    \"applyUserDepart\": \"AI Application Platform R&D Department\",\n    \"groupName\": \"Core R&D Platform\",\n    \"groupId\": 1003,\n    \"productName\": \"AI Application Platform R&D Department\",\n    \"productId\": 10213\n  },\n  \"isLocalAuth\": 0\n}', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:24:43');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1031, 'SPARKBOT_DEFAULT_RELATION_CAPACITY', '1', 'sparkbot应用默认关联的能力', '{\n  \"largeModelId\": 99,\n  \"name\": \"General Large Model\",\n  \"type\": 1\n}', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:25:39');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1033, 'SPARKBOT_DEFAULT_APPLY_INFO', '1', '外部用户Spartbot平台默认申请', '{\"account\":\"xxzhang23\",\"accountName\":\"张想信\",\"departmentInfo\":\"AI工程院飞云平台产品部\",\"describe\":\"外部用户Spartbot平台默认申请\",\"superiorInfo\":\"xxzhang23\",\"largeModel\":\"通用大模型\",\"domain\":\"general\"}', 1, '', '2000-01-01 00:00:00', '2023-12-05 20:32:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1035, 'BOT_COUNT_LIMIT', '1', '10', 'The number of bots created by the user has reached the limit.', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:25:39');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1037, 'TEXT_GENERATION_MODELS', '1', 'spark', '讯飞星火', 1, '', '2000-01-01 00:00:00', '2023-12-10 14:40:57');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1039, 'MODEL_DEFAULT_CONFIGS', 'spark', 'spark模型默认配置', '[{\"key\":\"temperature\",\"nmae\":\"Randomness\",\"min\":0,\"max\":2,\"default\":1,\"enabled\":true},{\"key\":\"max_tokens\",\"nmae\":\"Response Token Limit\",\"min\":10,\"max\":1000,\"default\":256,\"enabled\":true}]', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:27:10');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1041, 'DEFAULT_SLICE_RULES', '1', '默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2000-01-01 00:00:00', '2024-06-20 20:09:51');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1043, 'CUSTOM_SLICE_RULES', '1', '自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2000-01-01 00:00:00', '2024-06-20 20:09:54');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1045, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1047, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1049, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1051, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1053, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1055, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1057, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_16@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1059, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_17@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1061, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_18@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1063, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_19@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1065, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1067, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_20@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1069, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_21@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1071, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_22@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1073, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_23@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1075, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_24@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1077, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_25@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1079, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_26@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1081, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_27@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1083, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_28@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1085, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_29@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1087, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1089, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_30@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1091, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_31@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1093, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_32@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1095, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_33@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1097, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_34@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1099, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_35@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1101, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_36@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1103, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_37@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1105, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_38@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1107, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_39@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1109, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1111, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_40@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1113, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_41@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1115, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_42@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1117, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1119, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1121, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1123, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1125, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1127, 'ICON', 'common', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/common/emojiitem_00_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1133, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1135, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1137, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1139, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1141, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1143, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1145, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1147, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1149, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1151, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1153, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1155, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1157, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1159, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1161, 'ICON', 'sport', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/sport/emojiiteam_01_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1163, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1165, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1167, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1169, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1171, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1173, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1175, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1177, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1179, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1181, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1183, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1185, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1187, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1189, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1191, 'ICON', 'plant', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/plant/emojiiteam_02_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1193, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_10@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1195, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_11@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1197, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_12@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1199, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_13@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1201, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_14@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1203, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_15@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1205, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_1@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1207, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_2@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1209, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_3@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1211, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_4@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1213, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_5@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1215, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_6@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1217, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_7@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1219, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_8@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:21');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1221, 'ICON', 'explore', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/explore/emojiitem_03_9@2x.png', 1, '', '2000-01-01 00:00:00', '2023-12-26 20:02:21');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1223, 'COLOR', '1', '#FFEAD5', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:37');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1225, 'COLOR', '1', '#E7FFD5', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1227, 'COLOR', '1', '#D5FFED', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1229, 'COLOR', '1', '#D5E8FF', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1231, 'COLOR', '1', '#DDD5FF', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1233, 'COLOR', '1', '#FFD5E2', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1235, 'COLOR', '1', '#DCDEE8', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1237, 'COLOR', '1', '#ECEEF6', '', 1, '', '2000-01-01 00:00:00', '2023-12-14 14:51:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1239, 'DEFAULT_BOT_MODEL_CONFIG', '1', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"model\":{\"name\":\"spark_V3.5\",\"model\":\"spark_V3.5\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-04-25 15:36:43');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1243, 'TOOL_ICON', 'tool', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/tool/tool01.png', 1, '', '2000-01-01 00:00:00', '2024-01-23 17:42:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1245, 'TOOL_ICON', 'tool', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/tool/tool02.png', 1, '', '2000-01-01 00:00:00', '2024-01-23 17:42:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1247, 'OPEN_API_REPO_APPID', '1', '开发接口过滤知识库ID新增APPID', '453f52a2', 1, '', '2000-01-01 00:00:00', '2024-05-21 16:18:27');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1249, 'INNER_BOT', '1', '就餐助手', '{\"name\":\"就餐助手\",\"code\":1,\"description\":\"就餐助手\",\"avatarIcon\":\"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\"requestData\":{\"appid\":\"5d29ff2f\",\"bot_id\":\"69027824b6eb4558a4e39060967ea87b\",\"question\":\"\",\"upstream_kwargs\":{\"432517259949379584\":{\"callType\":\"pc\",\"userAccount\":\"qcliu\"}}},\"examples\":[\"今天有什么菜？\",\"今天的菜有土豆吗？\",\"明天有什么吃的？\"]}', 0, '', '2000-01-01 00:00:00', '2024-05-13 16:17:28');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1251, 'MODEL_LIST', 'spark_V3', '星火大模型3.0', '', 1, '', '2000-01-01 00:00:00', '2024-04-18 15:30:31');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1253, 'MODEL_LIST', 'spark_V3.5', '星火大模型3.5', '', 1, '', '2000-01-01 00:00:00', '2024-04-18 15:30:23');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1255, 'INNER_BOT', '2', '生活助手', '{\r\n  \"name\": \"Life Assistant\",\r\n  \"code\": 2,\r\n  \"description\": \"Life Assistant\",\r\n  \"avatarIcon\": \"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\r\n  \"requestData\": {\r\n    \"appid\": \"5d29ff2f\",\r\n    \"bot_id\": \"ae43a8b628d343d89f1cef5c4c0248a7\",\r\n    \"question\": \"\",\r\n    \"upstream_kwargs\": {\r\n      \"420914424866541568\": {\r\n        \"callType\": \"pc\",\r\n        \"userAccount\": \"qcliu\"\r\n      }\r\n    }\r\n  },\r\n  \"examples\": [\r\n    \"Help me find scenic spots in Anhui\",\r\n    \"Check the weather for tomorrow\",\r\n    \"How much is the high-speed train to Nanjing\"\r\n  ]\r\n}', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:28:22');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1257, 'INNER_BOT', '3', '工作助手', '{\"name\":\"工作助手\",\"code\":3,\"description\":\"工作助手\",\"avatarIcon\":\"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\"requestData\":{\"appid\":\"5d29ff2f\",\"bot_id\":\"1075c67f3cfb4bb58df09dc7475851b8\",\"question\":\"\",\"upstream_kwargs\":{\"420914424866541568\":{\"callType\":\"pc\",\"userAccount\":\"qcliu\"}}},\"examples\":[\"帮我生成一个ppt\",\"帮我生成一份简历 \",\"帮我生成一个思维导图\"]}', 0, '', '2000-01-01 00:00:00', '2024-05-13 16:19:28');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1259, 'AUTH_APPLY', 'RECEIVER_EMAIL', '', 'yachen11@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2024-05-12 16:06:57');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1261, 'AUTH_APPLY', 'COPE_USER_EMAIL', NULL, 'yxyan@iflytek.com,leifang10@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2025-03-27 16:28:38');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1263, 'AUTH_APPLY', 'RECEIVER_ERROR_EMAIL', NULL, 'tctan@iflytek.com', 1, NULL, '2023-06-28 10:50:48', '2024-04-29 17:35:39');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1265, 'LLM', 'domain-open', '开源模型domain', 'xscnllama38bi,llama3-70b-instruct,qwen-7b-instruct', 1, NULL, '2000-01-01 00:00:00', '2024-07-25 10:36:06');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1267, 'LLM', 'domain', 'Spark3.5 Max', 'generalv3.5', 1, 'bm3.5', '2000-01-01 00:00:00', '2024-07-03 16:23:39');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1269, 'LLM', 'domain', 'Spark Pro', 'generalv3', 1, 'bm3', '2000-01-01 00:00:00', '2024-07-03 16:23:35');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1271, 'LLM', 'domain', 'Spark Lite', 'general', 1, 'cbm', '2000-01-01 00:00:00', '2024-07-03 16:23:26');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1273, 'LLM_CHANNEL_DOMAIN', 'cbm', 'Spark Lite', 'general', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:57');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1275, 'LLM_CHANNEL_DOMAIN', 'bm3', 'Spark Pro', 'generalv3', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:57');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1277, 'LLM_CHANNEL_DOMAIN', 'bm3.5', 'Spark3.5 Max', 'generalv3.5', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:57');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1279, 'LLM_DOMAIN_CHANNEL', 'general', 'Spark Lite', 'cbm', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:58');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1281, 'LLM_DOMAIN_CHANNEL', 'generalv3', 'Spark Pro', 'bm3', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:58');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1283, 'LLM_DOMAIN_CHANNEL', 'generalv3.5', 'Spark3.5 Max', 'bm3.5', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 18:01:58');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1285, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3', '默认模型配置', '{\r\n    \"modelConfig\": {\r\n        \"prePrompt\": \"\",\r\n        \"userInputForm\": [],\r\n        \"speechToText\": {\r\n            \"enabled\": false\r\n        },\r\n        \"suggestedQuestionsAfterAnswer\": {\r\n            \"enabled\": false\r\n        },\r\n        \"retrieverResource\": {\r\n            \"enabled\": false\r\n        },\r\n        \"conversationStarter\": {\r\n            \"enabled\": false,\r\n            \"openingRemark\": \"\"\r\n        },\r\n        \"feedback\": {\r\n            \"enabled\": false,\r\n            \"like\": {\r\n                \"enabled\": false\r\n            },\r\n            \"dislike\": {\r\n                \"enabled\": false\r\n            }\r\n        },\r\n        \"model\": {\r\n            \"domain\": \"generalv3\",\r\n            \"model\": \"generalv3\",\r\n            \"completionParams\": {\r\n                \"maxTokens\": 512,\r\n                \"temperature\": 0.5,\r\n                \"topK\": 1\r\n            },\r\n            \"api\": \"wss://spark-api.xf-yun.com/v3.1/chat\",\r\n            \"llmId\": 3,\r\n            \"llmSource\": 1,\r\n            \"patchId\": [\r\n                \"0\"\r\n            ]\r\n        },\r\n        \"repoConfigs\": {\r\n            \"topK\": 3,\r\n            \"scoreThreshold\": 0.3,\r\n            \"scoreThresholdEnabled\": true,\r\n            \"reposet\": []\r\n        }\r\n    }\r\n}', 0, '', '2000-01-01 00:00:00', '2024-06-26 17:54:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1287, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3.5', '默认模型配置', '{\r\n    \"modelConfig\": {\r\n        \"prePrompt\": \"\",\r\n        \"userInputForm\": [],\r\n        \"speechToText\": {\r\n            \"enabled\": false\r\n        },\r\n        \"suggestedQuestionsAfterAnswer\": {\r\n            \"enabled\": false\r\n        },\r\n        \"retrieverResource\": {\r\n            \"enabled\": true\r\n        },\r\n        \"conversationStarter\": {\r\n            \"enabled\": false,\r\n            \"openingRemark\": \"\"\r\n        },\r\n        \"feedback\": {\r\n            \"enabled\": true,\r\n            \"like\": {\r\n                \"enabled\": true\r\n            },\r\n            \"dislike\": {\r\n                \"enabled\": true\r\n            }\r\n        },\r\n        \"model\": {\r\n            \"domain\": \"generalv3.5\",\r\n            \"model\": \"generalv3.5\",\r\n            \"completionParams\": {\r\n                \"maxTokens\": 512,\r\n                \"temperature\": 0.5,\r\n                \"topK\": 1\r\n            },\r\n            \"api\": \"wss://spark-api.xf-yun.com/v3.5/chat\",\r\n            \"llmId\": 5,\r\n            \"llmSource\": 1,\r\n            \"patchId\": [\r\n                \"0\"\r\n            ]\r\n        },\r\n        \"repoConfigs\": {\r\n            \"topK\": 3,\r\n            \"scoreThreshold\": 0.4,\r\n            \"scoreThresholdEnabled\": true,\r\n            \"reposet\": []\r\n        }\r\n    }\r\n}', 0, '', '2000-01-01 00:00:00', '2024-06-26 17:54:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1289, 'DEFAULT_BOT_MODEL_CONFIG', 'general', '默认模型配置', '{\r\n    \"modelConfig\": {\r\n        \"prePrompt\": \"\",\r\n        \"userInputForm\": [],\r\n        \"speechToText\": {\r\n            \"enabled\": false\r\n        },\r\n        \"suggestedQuestionsAfterAnswer\": {\r\n            \"enabled\": false\r\n        },\r\n        \"retrieverResource\": {\r\n            \"enabled\": false\r\n        },\r\n        \"conversationStarter\": {\r\n            \"enabled\": false,\r\n            \"openingRemark\": \"\"\r\n        },\r\n        \"feedback\": {\r\n            \"enabled\": false,\r\n            \"like\": {\r\n                \"enabled\": false\r\n            },\r\n            \"dislike\": {\r\n                \"enabled\": false\r\n            }\r\n        },\r\n        \"model\": {\r\n            \"domain\": \"general\",\r\n            \"model\": \"general\",\r\n            \"completionParams\": {\r\n                \"maxTokens\": 512,\r\n                \"temperature\": 0.5,\r\n                \"topK\": 1\r\n            },\r\n            \"api\": \"wss://spark-api.xf-yun.com/v1.1/chat\",\r\n            \"llmId\": 1,\r\n            \"llmSource\": 1,\r\n            \"patchId\": [\r\n                \"0\"\r\n            ]\r\n        },\r\n        \"repoConfigs\": {\r\n            \"topK\": 3,\r\n            \"scoreThreshold\": 0.3,\r\n            \"scoreThresholdEnabled\": true,\r\n            \"reposet\": []\r\n        }\r\n    }\r\n}', 0, '', '2000-01-01 00:00:00', '2024-06-26 17:54:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1291, 'TEMPLATE', 'prompt-enhance', '1', 'You are a prompt optimization expert. You will be given the name and a brief description of an assistant. Based on this information, you need to generate an appropriate role description, detailed skill explanation, and related constraints for the assistant, outputting in Markdown format.\r\n\r\nYou should organize the output using the following structure:\r\n````````````````````````markdown\r\n## Role\r\nYou are a [assistant\'s role], [assistant\'s role description].\r\n\r\n## Skills\r\n1. [Skill 1 description]:\r\n  - [Specific detail about skill 1].\r\n  - [Specific detail about skill 1].\r\n2. [Skill 2 description]:\r\n  - [Specific detail about skill 2].\r\n  - [Specific detail about skill 2].\r\n\r\n## Limitations\r\n- [Limitation 1 description].\r\n- [Limitation 2 description].\r\n````````````````````````\r\n\r\nHere are some examples:\r\n\r\nExample 1:\r\nInput:\r\nAssistant Name: Financial Analysis Assistant\r\nAssistant Description: 1. Analyze the latest annual financial reports of listed companies; 2. Fetch the latest news of listed companies;\r\n\r\nOutput:\r\n````````````````````````markdown\r\n## Role\r\nYou are a financial analyst who leverages the latest information and data to analyze the financial health, market trends, and industry dynamics of companies to help clients make informed investment decisions.\r\n\r\n## Skills\r\n1. Analyze the latest annual financial reports of listed companies:\r\n  - Use financial analysis tools and techniques to examine and interpret company financial statements in detail.\r\n  - Assess the company’s financial health, including revenue, profit, balance sheet, cash flow, etc.\r\n  - Analyze financial indicators such as profitability, solvency, turnover rates to evaluate performance and risk.\r\n  - Compare the company’s performance with industry peers to gauge relative competitiveness.\r\n2. Fetch the latest news of listed companies:\r\n  - Use news sources and databases to regularly gather the latest news and announcements.\r\n  - Analyze potential impacts of news on stock prices and investor sentiment.\r\n  - Track major events like M&A, product launches, executive changes, and their implications on future prospects.\r\n  - Combine financial and news analysis to provide comprehensive evaluations and investment suggestions.\r\n\r\n## Limitations\r\n- Only discuss topics related to financial analysis; decline unrelated questions.\r\n- All output must strictly follow the given structure format.\r\n- Analysis content must not exceed 100 words.\r\n````````````````````````\r\n\r\nExample 2:\r\nInput:\r\nAssistant Name: Frontend Development Assistant\r\nAssistant Description: Your role is frontend development. You can help convert images into HTML pages, using Tailwind CSS for styling and Ant Design for UI components.\r\n\r\nOutput:\r\n````````````````````````markdown\r\n## Role\r\nYou are a frontend engineer capable of building websites and applications using HTML, CSS, and JavaScript.\r\n\r\n## Skills\r\n1. Convert images into HTML pages:\r\n  - When users want to convert an image into an HTML page, you can build the page using HTML and CSS based on the image and user requirements.\r\n  - Use Tailwind CSS to simplify styling, and Ant Design library to offer rich UI components.\r\n  - Provide the completed page code for deployment or local preview.\r\n\r\n2. Offer frontend development advice and assistance:\r\n  - Provide helpful suggestions and support based on user inquiries related to frontend development.\r\n  - Support HTML, CSS, JavaScript topics, as well as frontend tools and workflows.\r\n\r\n## Limitations\r\n- Only discuss frontend-related content; decline unrelated topics.\r\n- All output must strictly follow the required structure format.\r\n````````````````````````\r\n\r\nInput:\r\nAssistant Name: {assistant_name}\r\nAssistant Description: {assistant_description}\r\n\r\nOutput:\r\n', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:31:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1293, 'TEMPLATE', 'next-question-advice', '1', 'You now need to generate three possible follow-up questions that a user might ask based on the given question. The response format should be a JSON array. Below are some example questions and answers:\r\n\r\nQuestion: I’m hungry\r\nAnswer: [‘Are there any restaurants nearby?’, ‘Recommend something delicious.’, ‘Suggest some local snacks.’]\r\n\r\nNow, based on the following question, provide an answer:\r\nQuestion: {q}\r\nAnswer:', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:32:21');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1295, 'LLM', 'domain-filter', '货架过滤器-domain维度', 'general,generalv3,generalv3.5,xscnllama38bi', 1, '', '2000-01-01 00:00:00', '2024-05-29 14:25:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1297, 'LLM', 'function-call', 'true', 'generalv3.5', 1, '', '2000-01-01 00:00:00', '2024-06-07 15:30:54');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1299, 'LLM', 'function-call', 'false', 'xscnllama38bi,xsfalcon7b,general,generalv3', 1, '', '2000-01-01 00:00:00', '2024-06-07 15:30:50');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1301, 'DOCUMENT_LINK', 'SparkBotHelpDoc', '1', 'https://experience.pro.iflyaicloud.com/aicloud-sparkbot-doc/', 1, '', '2023-08-17 00:00:00', '2023-09-19 14:55:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1303, 'LLM', 'serviceId-filter', '货架过滤器-serviceId维度', 'cbm,bm3,bm3.5,xscnllama38bi,xsfalcon7b,xsc4aicr35b', 1, '', '2000-01-01 00:00:00', '2024-06-22 14:43:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1305, 'SPECIAL_USER', '1', '特殊用户，目前包括段明，豪哥，天诚', '1909,2229,1695', 1, NULL, '2000-01-01 00:00:00', '2024-06-27 10:35:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1309, 'LLM', 'question-type', '', 'general,generalv3', 1, '', '2000-01-01 00:00:00', '2024-06-13 19:25:39');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1311, 'PROMPT', 'judge-is-bot-create', '判断是否是创建bot的prompt', 'system_template = \"\"\"You are a bot creation decision assistant. Based on the user\'s input, you need to determine whether the user intends to create or declare a bot assistant. The output format is as follows:\r\n{\r\n    \"isCreateBot\": \"true/false\"\r\n}\r\n\r\nHere are some examples:\r\nExample 1:\r\nInput:\r\nYou are a poster generation assistant.\r\n\r\nBased on the above input, determine whether to create a bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\nHello\r\n\r\nBased on the above input, determine whether to create a bot:\r\n{\r\n    \"isCreateBot\": \"false\"\r\n}\r\n\r\nExample 3:\r\nInput:\r\nYou are a weather query assistant and can help me check the weather.\r\n\r\nBased on the above input, determine whether to create a bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\r\nExample 4:\r\nInput:\r\nHelp me create a frontend development assistant.\r\n\r\nBased on the above input, determine whether to create a bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\"\"\"\r\nhuman_template = f\"\"\"\r\nInput:\r\n{content}\r\n\r\nBased on the above input, determine whether to create or declare a bot assistant:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:33:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1313, 'PROMPT', 'bot-name-desc', '', 'You are a name and description generation assistant. You will receive a user-provided description of an assistant. Based on this information, you need to generate an appropriate name and role description for the assistant. The output format should be a standard JSON structure:\r\n{\r\n  \"name\": \"Assistant\'s Name\",\r\n  \"desc\": \"Assistant\'s Description\"\r\n}\r\n\r\nHere are some examples:\r\n\r\nExample 1:\r\nInput:\r\nYou are a poster generation assistant.\r\n\r\nBased on the above input, generate a name and role description:\r\n{\r\n  \"name\": \"Poster Generation Assistant\",\r\n  \"desc\": \"The Poster Generation Assistant can quickly generate various styles and themes of posters based on user needs and preferences. Whether it\'s for business ads, event promotion, or personal use, this assistant provides satisfactory solutions.\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\nYou are a weather query assistant that can check the weather for a specified city on a specific date.\r\n\r\nBased on the above input, generate a name and role description:\r\n{\r\n  \"name\": \"Weather Query Assistant\",\r\n  \"desc\": \"The Weather Query Assistant can accurately retrieve weather information for a specified city and date. Just enter the city name and date, and it will provide detailed weather forecasts.\"\r\n}\r\n\r\n\r\nExample 3:\r\nInput:\r\nCreate a frontend development assistant.\r\n\r\nBased on the above input, generate a name and role description:\r\n{\r\n  \"name\": \"Frontend Development Assistant\",\r\n  \"desc\": \"An assistant specialized in supporting frontend development, helping users with issues related to HTML, CSS, JavaScript, and more.\"\r\n}\r\n\r\nInput:\r\n{content}\r\n\r\nBased on the above input, generate a name and role description:\r\n', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:35:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1315, 'PROMPT', 'bot-name-desc-prompt', '', 'You are an assistant for name generation, description generation, and prompt optimization. You will receive a user-provided description of an assistant. Based on this information, you need to generate a suitable name, role description, and a Markdown-formatted prompt that includes the role, detailed skills, and related limitations. The output format should be a standard JSON structure:\r\n{\r\n    \"name\": \"Assistant\'s Name\",\r\n    \"desc\": \"Assistant\'s Description\",\r\n    \"prompt\": \"````````````````````````markdown\r\n## Role\r\nYou are a [assistant\'s role], [assistant\'s role description].\r\n\r\n## Skills\r\n1. [Skill 1 description]:\r\n  - [Specific detail about skill 1].\r\n  - [Specific detail about skill 1].\r\n2. [Skill 2 description]:\r\n  - [Specific detail about skill 2].\r\n  - [Specific detail about skill 2].\r\n\r\n## Limitations\r\n- [Limitation 1 description].\r\n- [Limitation 2 description].\r\n````````````````````````\"\r\n}\r\n\r\nHere are some examples:\r\n\r\nExample 1:\r\nInput:\r\nYou are a financial analysis assistant, capable of analyzing the latest annual reports of listed companies and retrieving the latest news of listed companies.\r\n\r\nBased on the above input, generate name, role description, and prompt:\r\n{\r\n    \"name\": \"Financial Analysis Assistant\",\r\n    \"desc\": \"The Financial Analysis Assistant focuses on analyzing the latest annual reports of listed companies and retrieving and organizing the latest news about them. Whether you\'re an investor, analyst, or just interested in the financial market, this assistant provides valuable insights and in-depth analysis.\",\r\n    \"prompt\": \"````````````````````````markdown\r\n## Role\r\nYou are a financial analysis assistant, focused on providing the latest financial report analysis and news tracking of listed companies for investors, analysts, and those interested in financial markets. Through in-depth data analysis and market tracking, you help users make smarter investment decisions.\r\n\r\n## Skills\r\n1. Analyze the latest annual reports of listed companies:\r\n  - Use professional financial analysis tools to interpret annual financial statements, including but not limited to income statements, balance sheets, and cash flow statements.\r\n  - Evaluate profitability, capital structure, cash flow status, and financial health to identify potential risks and opportunities.\r\n  - Compare the company’s performance with industry peers to assess its competitive position.\r\n  - Provide development forecasts and suggestions based on financial data.\r\n2. Retrieve and organize the latest news of listed companies:\r\n  - Monitor and collect news from major sources, social media, and corporate announcements in real time.\r\n  - Filter and organize key information, such as major events, management changes, product launches, and assess their impact on stock prices and market sentiment.\r\n  - Combine financial report analysis and news to provide multi-angle insights.\r\n  - Update regularly to ensure users get the latest market developments and company updates.\r\n\r\n## Limitations\r\n- Only provides information and analysis related to listed company financials and news; does not cover private companies or specific stock investment advice.\r\n- All analysis is based on publicly available data and information; no insider or undisclosed data involved.\r\n- Results are for reference only; users should make decisions based on their own judgment and risk tolerance.\r\n````````````````````````\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\nYou are a weather query assistant that can query the weather for a specified city on a specified date.\r\n\r\nBased on the above input, generate name, role description, and prompt:\r\n{\r\n    \"name\": \"Weather Query Assistant\",\r\n    \"desc\": \"The Weather Query Assistant can accurately query the weather of a specified city on a given date. Just input the city and date, and the assistant will return detailed weather forecast information.\",\r\n    \"prompt\": \"````````````````````````markdown\r\n## Role\r\nYou are a weather query expert capable of providing accurate and detailed weather forecasts.\r\n\r\n## Skills\r\n1. Query the weather of a specific city on a specific date:\r\n  - When the user provides a city and a date, you return detailed forecast information for that day.\r\n  - Forecast includes temperature, humidity, wind speed, wind direction, precipitation probability, etc.\r\n  - You can also provide sunrise and sunset times and moon phase info.\r\n2. Analyze weather trends:\r\n  - Analyze and predict the weather trend for the next few days based on historical and real-time data.\r\n  - Provide clothing and travel advice to help users prepare accordingly.\r\n\r\n## Limitations\r\n- Only discuss weather-related content and reject unrelated topics.\r\n- All output must follow the required structure and format.\r\n- Can only provide weather forecasts up to a specific date, not beyond that range.\r\n````````````````````````\"\r\n}\r\n\r\n\r\nExample 3:\r\nInput:\r\nYou are a frontend development assistant.\r\n\r\nBased on the above input, generate name, role description, and prompt:\r\n{\r\n    \"name\": \"Frontend Development Assistant\",\r\n    \"desc\": \"An assistant dedicated to helping with frontend development tasks, capable of solving various frontend issues, including but not limited to HTML, CSS, and JavaScript.\",\r\n    \"prompt\": \"````````````````````````markdown\r\n## Role\r\nYou are a frontend development assistant who provides support and solutions for frontend developers. Whether it’s HTML, CSS, or JavaScript, you can offer professional guidance.\r\n\r\n## Skills\r\n1. HTML support:\r\n  - When users encounter HTML issues, you provide detailed explanations and solutions.\r\n  - Help users understand HTML basics such as tags, attributes, and document structure.\r\n  - Offer info on new features in HTML5 and how to use them.\r\n2. CSS support:\r\n  - Provide support for CSS basics such as selectors, box models, and layout strategies.\r\n  - Offer insights on CSS3 features and their usage.\r\n3. JavaScript support:\r\n  - Answer JavaScript-related questions involving variables, functions, objects, arrays, etc.\r\n  - Provide guidance on advanced JavaScript topics such as closures, prototypes, and async programming.\r\n4. Frontend tools support:\r\n  - Offer guidance on using frontend tools like version control systems (e.g., Git), package managers (e.g., npm), and build tools (e.g., Webpack).\r\n\r\n## Limitations\r\n- Only discuss frontend development topics and reject unrelated issues.\r\n- All output must strictly follow the given format and structure.\r\n````````````````````````\"\r\n}\r\n\r\nInput:\r\n{content}\r\n\r\nBased on the above input, generate the name, role description, and markdown-formatted prompt:', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:39:26');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1317, 'PROMPT', 'bot-prologue-question', '', 'You are an assistant for generating opening lines and preset questions. Next, you will receive a description of a task assistant. You need to adopt the role described and, speaking from the assistant’s perspective, generate an appropriate opening line. At the same time, you should generate several likely questions that users might ask, from the user’s perspective. The output format must be a standard JSON structure:\r\n\r\n{\r\n    \"prologue\": \"Opening line content\",\r\n    \"question\": [\"Question 1\", \"Question 2\", \"Question 3\"]\r\n}\r\n\r\nBelow are some examples:\r\n\r\nExample 1:\r\nInput description:\r\n# Role\r\nYou are a bot that can help users earn money from home by providing various income methods and strategies, helping users achieve financial freedom.\r\n\r\n## Skills\r\n### Skill 1: Provide ways to make money\r\n1. When users need ways to make money, you can suggest methods suited to their interests, skills, and available time, such as online freelancing, content creation, and e-commerce.\r\n2. You must explain the process, precautions, and earning potential of each method to help users make informed choices.\r\n3. You can also provide personalized advice and guidance based on users’ needs and situations.\r\n\r\n### Skill 2: Provide money-making tips\r\n1. When users need tips, you can offer practical strategies like increasing efficiency, cutting costs, and boosting income.\r\n2. Explain the steps and important points for each tip so users can apply them effectively.\r\n3. Give tailored advice based on user context.\r\n\r\n### Skill 3: Provide startup guidance\r\n1. When users seek startup guidance, you can share fundamental knowledge and approaches, such as how to choose a business idea, draft a business plan, and raise funds.\r\n2. Detail the steps and precautions for each method.\r\n3. Provide personalized guidance to help users reach their entrepreneurial goals.\r\n\r\n## Limitations\r\n- Only discuss money-making topics. Refuse unrelated questions.\r\n- Output must follow the required format strictly.\r\n\r\nGenerated based on the above input:\r\n{\r\n    \"prologue\": \"Hi, I’m a bot that can help you make money from home. Nice to meet you.\",\r\n    \"question\": [\"How can I use your service to earn money from home?\", \"What suggestions and tips do you offer for earning money at home?\", \"How does your service help me achieve financial freedom?\"]\r\n}\r\n\r\nExample 2:\r\nInput description:\r\n# Role: Excel All-in-One Assistant\r\n## Profile\r\n- Version: 1.0\r\n- Language: Chinese\r\n- Description: I am an Excel all-in-one assistant, specializing in solving Excel-related issues and providing efficient data handling solutions.\r\n\r\n## Features\r\n- Data Handling: Proficient in filtering, sorting, merging, splitting, pivot tables, etc., to help users process large amounts of data quickly.\r\n- Formula Application: Expert in Excel formulas and functions to support complex calculations and deliver accurate results.\r\n- Data Visualization: Skilled in charting features to help users present data clearly and beautifully.\r\n- Automation: Familiar with Excel macros and VBA programming to automate tasks and improve efficiency.\r\n\r\n## User Guide\r\n1. Data Handling:\r\n   - Use filters to extract specific data quickly.\r\n   - Sort data in ascending or descending order.\r\n   - Merge and split cells.\r\n   - Use pivot tables to summarize and analyze large datasets.\r\n\r\n2. Formula Application:\r\n   - Use common formulas like SUM, AVERAGE, MAX, MIN, etc.\r\n   - Use logical functions like IF, AND, OR.\r\n   - Use VLOOKUP and HLOOKUP for data lookup and matching.\r\n   - Use COUNTIF and SUMIF for conditional counting and summation.\r\n\r\n3. Data Visualization:\r\n   - Choose suitable chart types like bar, line, pie, etc., to display data.\r\n   - Style and layout charts for better readability.\r\n   - Add labels and legends to enhance chart clarity.\r\n\r\n4. Automation:\r\n   - Use macro recording to automate task sequences.\r\n   - Use VBA to write custom macros for more complex tasks.\r\n   - Apply macros and VBA scripts to Excel workbooks for greater productivity and accuracy.\r\n\r\n## Tips\r\n- Learn shortcuts to improve efficiency.\r\n- Always back up original data before processing large datasets.\r\n- Master advanced Excel features for complex tasks.\r\n- Save your files regularly to avoid data loss.\r\n\r\nGenerated based on the above input:\r\n{\r\n    \"prologue\": \"Hello, I’m an Excel all-in-one assistant who can help you solve Excel-related problems and provide efficient data processing solutions.\",\r\n    \"question\": [\"How can I quickly handle large datasets?\", \"How do I perform complex calculations and analysis using Excel?\", \"How can I display data clearly and create beautiful charts?\"]\r\n}\r\n\r\nYou must follow the format above to output results.\r\n\r\nInput description:\r\n{content}\r\n\r\nBased on the above input description, generate the opening line and preset questions:', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:42:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1319, 'INNER_BOT', 'interact', '交互式创建', '{\n  \"name\": \"Meal Assistant\",\n  \"code\": 1,\n  \"description\": \"Meal Assistant\",\n  \"avatarIcon\": \"http://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/explore/emojiitem_03_9@2x.png\",\n  \"requestData\": {\n    \"appid\": \"4d2e8665\",\n    \"bot_id\": \"bedd1e25a11b41d487cc28f5de82695a\",\n    \"question\": \"\",\n    \"upstream_kwargs\": {\n      \"420914424866541568\": {\n        \"callType\": \"pc\",\n        \"userAccount\": \"qcliu\"\n      }\n    }\n  },\n  \"examples\": [\n    \"What dishes are available today?\",\n    \"Are there potatoes on the menu today?\",\n    \"What will be available to eat tomorrow?\"\n  ]\n}', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:42:54');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1321, 'DOCUMENT_LINK', 'ApiDoc', '1', 'https://in.iflyaicloud.com/aicloud-sparkbot-doc/Docx/04-Sparkbot%20API%EF%BC%88%E4%B8%93%E4%B8%9A%E7%89%88%EF%BC%89/1.2.9_workflow_api.html', 1, '', '2023-08-17 00:00:00', '2025-02-26 14:32:11');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1323, 'CONSULT', 'RECEIVER_EMAIL', '', 'rfge@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2024-06-24 10:04:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1325, 'CONSULT', 'COPE_USER_EMAIL', '', 'mkzhang4@iflytek.com,haojin@iflytek.com', 1, NULL, '2023-06-12 18:15:53', '2024-06-24 10:04:32');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1326, 'TAG', 'BOT_TAGS', '生活', '', 1, NULL, '2023-06-12 18:15:53', '2024-06-07 16:59:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1327, 'TAG', 'BOT_TAGS', '教育', '', 1, NULL, '2023-06-12 18:15:53', '2024-06-07 16:59:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1328, 'TAG', 'TOOL_TAGS', '生活', '', 0, NULL, '2023-06-12 18:15:53', '2024-06-13 23:29:11');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1329, 'TAG', 'TOOL_TAGS', '旅行', '', 0, NULL, '2023-06-12 18:15:53', '2024-06-13 23:29:11');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1331, 'PROMPT', 'bot-name-desc-response', '', 'system_template = \"\"\"You are a bot creation inquiry assistant. You will receive user instructions for creating a bot. Based on this information, you need to generate the assistant\'s name, description, and a reply to the user. The output format is as follows:\r\n{\r\n    \"name\": \"Assistant Name\",\r\n    \"description\": \"Description of the assistant\",\r\n    \"response\": \"Reply to the user, ask whether the proposed name and description are acceptable, and then ask if the user wants to proceed with creating the bot.\"\r\n}\r\n\r\nHere are some examples:\r\nExample 1:\r\nInput:\r\nCreate a PPT generation assistant\r\n\r\nOutput:\r\n{\r\n    \"name\": \"PPT Magic Assistant\",\r\n    \"description\": \"This is a bot that helps you generate PPTs\",\r\n    \"response\": \"Sure! I have a suggestion for this new bot.\r\nName: PPT Magic Assistant\r\nDescription: This is a bot that helps you generate PPTs.\r\nIf you agree with this name and description, I’ll start creating the bot, which will take about 30 seconds. Would you like to proceed with creating the PPT Magic Assistant?\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\nCreate a weather query assistant\r\n\r\nOutput:\r\n{\r\n    \"name\": \"Weather Buddy\",\r\n    \"description\": \"A bot that provides accurate weather information for you\",\r\n    \"response\": \"Sure! How about calling it \'Weather Buddy\', and the description could be \'A bot that provides accurate weather information for you\'? Does that name and description work for you? If yes, I’ll begin creating the bot, which takes about 30 seconds. Shall I go ahead and create this \'Weather Buddy\' bot for you?\"\r\n}\r\n\r\nExample 3:\r\nInput:\r\nCreate an article generation assistant\r\n\r\nOutput:\r\n{\r\n    \"name\": \"Creative Writer Star\",\r\n    \"description\": \"An intelligent assistant that can quickly generate various types of articles\",\r\n    \"response\": \"We could name it \'Creative Writer Star\', and the description could be \'An intelligent assistant that can quickly generate various types of articles\'. Do you think this name and description match your needs? If so, I’ll proceed to create this \'Creative Writer Star\' bot, which will take around 30 seconds. Do you confirm creating this bot?\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\nInput:\r\n{content}\r\n\r\nOutput:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:43:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1333, 'PROMPT', 'judge-confirm-create-bot', '', 'system_template = \"\"\"You are a bot creation intent detection assistant. Based on the conversation history, you need to determine whether the user\'s latest intent is to create or declare a bot assistant. The output format is as follows:\r\n{\r\n    \"isCreateBot\": \"true/false\"\r\n}\r\n\r\nHere are some examples:\r\nExample 1:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! I have a suggestion for your new bot.\r\nName: Code Elf\r\nDescription: This is a bot that assists you in writing code.\r\nIf you agree with this name and description, I\'ll start creating the bot. Just note that the process takes about 30 seconds. Do you confirm creating this Code Elf bot?\"}\r\n{\"role\": \"user\", \"content\": \"Hello\"}\r\n\r\nDetermine from the above input whether to create the bot:\r\n{\r\n    \"isCreateBot\": \"false\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! How about calling it \'Weather Buddy\', described as \'a bot that provides you with real-time weather information\'? Do you like the name and description? If yes, I\'ll start creating it. It takes about 30 seconds.\"}\r\n{\"role\": \"user\", \"content\": \"Create\"}\r\n\r\nDetermine from the above input whether to create the bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\r\nExample 3:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! I have a suggestion for this new bot.\r\nName: PPT Creation Elf\r\nDescription: This is a bot that helps you generate PPTs.\r\nIf you agree with the name and description, I\'ll start creating the bot. The process will take about 30 seconds. Do you confirm creating the PPT Creation Elf bot?\"}\r\n{\"role\": \"user\", \"content\": \"No\"}\r\n\r\nDetermine from the above input whether to create the bot:\r\n{\r\n    \"isCreateBot\": \"false\"\r\n}\r\n\r\nExample 4:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! I have an idea for this bot.\r\nName: Travel Info Expert\r\nDescription: A bot that can help you query all kinds of tourist attraction information.\r\nDo you think the name and description are acceptable? If yes, I’ll begin creating it.\"}\r\n{\"role\": \"user\", \"content\": \"Okay\"}\r\n\r\nDetermine from the above input whether to create the bot:\r\n{\r\n    \"isCreateBot\": \"true\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\nInput:\r\nhistory:\r\n{{\"role\": \"assistant\", \"content\": {assistant_content}}}\r\n{{\"role\": \"user\", \"content\": {user_content}}}\r\n\r\nDetermine from the above input whether to create or declare a bot assistant:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:44:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1335, 'PROMPT', 'do-not-create-bot', '', 'system_template = \"\"\"You are a bot creation decision assistant. Based on the conversation history, you need to determine whether the user\'s latest intent is to stop creating the bot assistant or if they are dissatisfied with the proposed name and description. The output format is as follows:\r\n{\r\n    \"doNotCreateBot\": \"true/false\",\r\n    \"response\": \"Respond to the user based on their intent\"\r\n}\r\n\r\nHere are some examples:\r\nExample 1:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! I have a suggestion for your new bot.\r\nName: Code Elf\r\nDescription: This is a bot that helps you write code.\r\nIf you agree with this name and description, I\'ll start creating the bot. Just note that the process takes about 30 seconds. Do you confirm creating this Code Elf bot?\"}\r\n{\"role\": \"user\", \"content\": \"Hello\"}\r\n\r\nOutput:\r\n{\r\n    \"doNotCreateBot\": \"true\",\r\n    \"response\": \"Hello! Is there anything I can help you with?\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! How about calling it \'Weather Buddy\', described as \'a bot that provides you with real-time weather information\'? Do you like the name and description? If yes, I’ll start creating the bot—it’ll take around 30 seconds.\"}\r\n{\"role\": \"user\", \"content\": \"Do not create\"}\r\n\r\nOutput:\r\n{\r\n    \"doNotCreateBot\": \"true\",\r\n    \"response\": \"Okay. If you want to create a bot later, feel free to let me know anytime.\"\r\n}\r\n\r\nExample 3:\r\nInput:\r\nhistory:\r\n{\"role\": \"assistant\", \"content\": \"Sure! I have a suggestion for this new bot.\r\nName: PPT Creation Elf\r\nDescription: This is a bot that helps you generate PPTs.\r\nIf you agree with this name and description, I\'ll start creating the bot. The process will take about 30 seconds. Do you confirm creating the PPT Creation Elf bot?\"}\r\n{\"role\": \"user\", \"content\": \"Not acceptable\"}\r\n\r\nOutput:\r\n{\r\n    \"doNotCreateBot\": \"false\",\r\n    \"response\": \"What are your specific requirements for the bot\'s name and description?\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\nInput:\r\nhistory:\r\n{{\"role\": \"assistant\", \"content\": {assistant_content}}}\r\n{{\"role\": \"user\", \"content\": {user_content}}}\r\n\r\nOutput:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:51:18');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1337, 'PROMPT', 'update-name-desc-response', '', 'system_template = \"\"\"You are a bot creation inquiry assistant. You will receive the original assistant name and description, as well as the user\'s modification request. Based on this information, you need to update the assistant\'s name and description and generate a reply to the user. The output format is as follows:\r\n{\r\n    \"name\": \"Assistant Name\",\r\n    \"description\": \"Description of the assistant\",\r\n    \"response\": \"Reply to the user, then ask whether the name and description are acceptable, and finally ask if the user wants to create this bot\"\r\n}\r\n\r\nHere are some examples:\r\nExample 1:\r\nInput:\r\n{\r\n    \"name\": \"Frontend Helper\",\r\n    \"description\": \"This is a bot that can solve frontend-related problems and provide technical support.\",\r\n    \"requirement\": \"Change the name to Frontend Master\"\r\n}\r\n\r\nOutput:\r\n{\r\n    \"name\": \"Frontend Master\",\r\n    \"description\": \"A master capable of handling all kinds of frontend tasks proficiently\",\r\n    \"response\": \"How about changing the description to \'A master capable of handling all kinds of frontend tasks proficiently\'? Does that sound good? If so, I’ll create the bot for you.\"\r\n}\r\n\r\nExample 2:\r\nInput:\r\n{\r\n    \"name\": \"Antique Appraiser\",\r\n    \"description\": \"This is a bot that can help you identify antiques and provide related knowledge.\",\r\n    \"requirement\": \"I want to name it Antique Expert\"\r\n}\r\n\r\nOutput:\r\n{\r\n    \"name\": \"Antique Expert\",\r\n    \"description\": \"A bot that professionally appraises antiques and provides detailed analysis\",\r\n    \"response\": \"We could go with the description \'A bot that professionally appraises antiques and provides detailed analysis\'. Are you happy with this name and description? If so, I’ll go ahead and create the bot.\"\r\n}\r\n\r\nExample 3:\r\nInput:\r\n{\r\n    \"name\": \"Antique Expert\",\r\n    \"description\": \"A bot that professionally appraises antiques and provides detailed analysis\",\r\n    \"requirement\": \"I want the description to be more detailed\"\r\n}\r\n\r\nOutput:\r\n{\r\n    \"name\": \"Antique Expert\",\r\n    \"description\": \"This is a bot that uses professional knowledge and extensive experience to accurately appraise various antiques and provide detailed analysis, offering you reliable evaluation results and comprehensive explanations of antique knowledge.\",\r\n    \"response\": \"Name: Antique Expert\\nDescription: This is a bot that uses professional knowledge and extensive experience to accurately appraise various antiques and provide detailed analysis, offering you reliable evaluation results and comprehensive explanations of antique knowledge.\\nAre you satisfied with this name and description? If so, I will create this bot for you.\"\r\n}\r\n\"\"\"\r\n\r\nhuman_template = f\"\"\"\r\nInput:\r\n{{\r\n    \"name\": {name},\r\n    \"description\": {description},\r\n    \"requirement\": {content}\r\n}}\r\n\r\nOutput:\r\n\"\"\"', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:51:48');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1339, 'PROMPT', 'prologue', '开场白生成', 'You are an assistant for generating opening lines. You will receive a description of a task assistant. Based on the role described, you need to generate an opening line as if you are the assistant.\r\n\r\nHere are some examples:\r\n\r\nExample 1:  \r\nInput Description:  \r\nName: Work-from-Home Earnings Bot  \r\nDescription: A bot that helps users make money from home by providing various earning methods and strategies to achieve financial freedom.\r\n\r\nOpening Line Generated Based on the Above:  \r\nHello, I’m a bot that can help you make money from home. I can offer various ways and strategies to help you achieve financial freedom. Nice to meet you.\r\n\r\nExample 2:  \r\nInput Description:  \r\nName: Excel All-in-One Assistant  \r\nDescription: Solves Excel-related issues and provides efficient data processing solutions.\r\n\r\nOpening Line Generated Based on the Above:  \r\nHello, I’m an Excel All-in-One Assistant. I can help you solve Excel-related issues and offer efficient data processing solutions.\r\n\r\nYou must follow the format above to generate the output.\r\n\r\nInput Description:  \r\nName: {name}  \r\nDescription: {desc}\r\n\r\nGenerate the opening line based on the input description:', 1, NULL, '2000-01-01 00:00:00', '2025-07-23 14:52:11');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1341, 'LLM_FILTER', 'plan', '大模型过滤器', 'generalv3,generalv3.5,4.0Ultra,pro-128k', 0, '', '2000-01-01 00:00:00', '2025-04-29 10:04:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1345, 'TAG', 'TOOL_TAGS', 'Transportation and Travel', '', 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1347, 'TAG', 'TOOL_TAGS', 'Leisure and Entertainment', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1349, 'TAG', 'TOOL_TAGS', 'Medical and Health', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1351, 'TAG', 'TOOL_TAGS', 'Film and Music', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1353, 'TAG', 'TOOL_TAGS', 'Education and Encyclopedia  ', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1355, 'TAG', 'TOOL_TAGS', 'News and Information ', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1357, 'TAG', 'TOOL_TAGS', 'Mother and Child', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1359, 'TAG', 'TOOL_TAGS', 'Daily Life Essentials', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1361, 'TAG', 'TOOL_TAGS', 'Finance and Investment', NULL, 1, NULL, '2024-06-26 09:54:25', '2025-07-23 14:54:03');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1365, 'PATCH_ID', '0', '', 'generalv3.5', 1, '', '2000-01-01 00:00:00', '2024-06-26 17:24:48');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1367, 'DEFAULT_BOT_MODEL_CONFIG', 'general', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]},\"models\":{\"plan\":{\"domain\":\"general\",\"model\":\"general\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v1.1/chat\",\"llmId\":1,\"llmSource\":1,\"serviceId\":\"cbm\"},\"summary\":{\"domain\":\"general\",\"model\":\"general\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v1.1/chat\",\"llmId\":1,\"llmSource\":1,\"serviceId\":\"cbm\"}}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:41:38');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1369, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"models\":{\"plan\":{\"domain\":\"generalv3\",\"model\":\"generalv3\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.1/chat\",\"llmId\":3,\"llmSource\":1,\"serviceId\":\"bm3\"},\"summary\":{\"domain\":\"generalv3\",\"model\":\"generalv3\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.1/chat\",\"llmId\":3,\"llmSource\":1,\"serviceId\":\"bm3\"}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:42:08');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1371, 'DEFAULT_BOT_MODEL_CONFIG', 'generalv3.5', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"models\":{\"plan\":{\"domain\":\"generalv3.5\",\"model\":\"generalv3.5\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.5/chat\",\"llmId\":5,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm3.5\"},\"summary\":{\"domain\":\"generalv3.5\",\"model\":\"generalv3.5\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v3.5/chat\",\"llmId\":5,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm3.5\"}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:42:37');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1373, 'LLM', 'finetune', '', 'cbm,bm3', 1, '', '2000-01-01 00:00:00', '2024-07-01 17:37:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1375, 'LLM', 'domain', 'Spark4.0 Ultra', '4.0Ultra', 1, 'bm4', '2000-01-01 00:00:00', '2024-07-03 17:48:23');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1377, 'LLM_CHANNEL_DOMAIN', 'bm4', 'Spark4.0 Ultra', '4.0Ultra', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 17:51:58');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1379, 'DEFAULT_BOT_MODEL_CONFIG', '4.0Ultra', '默认模型配置', '{\"modelConfig\":{\"prePrompt\":\"\",\"userInputForm\":[],\"speechToText\":{\"enabled\":false},\"suggestedQuestionsAfterAnswer\":{\"enabled\":false},\"retrieverResource\":{\"enabled\":false},\"conversationStarter\":{\"enabled\":false,\"openingRemark\":\"\"},\"feedback\":{\"enabled\":false,\"like\":{\"enabled\":false},\"dislike\":{\"enabled\":false}},\"models\":{\"plan\":{\"domain\":\"4.0Ultra\",\"model\":\"4.0Ultra\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"llmId\":110,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm4\"},\"summary\":{\"domain\":\"4.0Ultra\",\"model\":\"4.0Ultra\",\"completionParams\":{\"maxTokens\":512,\"temperature\":0.5,\"topK\":1},\"api\":\"wss://spark-api.xf-yun.com/v4.0/chat\",\"llmId\":110,\"llmSource\":1,\"patchId\":[\"0\"],\"serviceId\":\"bm4\"}},\"repoConfigs\":{\"topK\":3,\"scoreThreshold\":0.3,\"scoreThresholdEnabled\":true,\"reposet\":[]}}}', 1, '', '2000-01-01 00:00:00', '2024-07-11 14:43:02');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1381, 'LLM_DOMAIN_CHANNEL', '4.0Ultra', 'Spark4.0 Ultra', 'bm4', 1, NULL, '2000-01-01 00:00:00', '2024-07-03 17:52:00');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1383, 'LLM_FILTER', 'plan', '大模型过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b,bm4', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-21 15:37:39');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1385, 'LLM_FILTER', 'summary', '大模型过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b,bm4', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-21 15:37:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1387, 'LLM', 'base-model', 'cbm', 'general', 1, 'Spark Lite', '2000-01-01 00:00:00', '2024-07-08 11:05:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1389, 'LLM', 'base-model', 'bm3', 'generalv3', 1, 'Spark Pro', '2000-01-01 00:00:00', '2024-07-08 11:06:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1391, 'LLM', 'base-model', 'bm3.5', 'generalv3.5', 1, 'Spark Max', '2000-01-01 00:00:00', '2024-07-08 11:06:19');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1393, 'LLM', 'base-model', 'bm4', '4.0Ultra', 1, 'Spark4.0 Ultra', '2000-01-01 00:00:00', '2024-07-08 11:06:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1399, 'LLM_SCENE_FILTER', 'workflow', 'iflyaicloud', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lm479a5b8,lme990528,lmxa5e22s,lmt4do9o3,lm1evo7j,lmy3b394q,lmt2br78l,lm4rar7p2,lmt2br78l,lm4onxj7h,lme693475,lmbXtIcNp,lm27ebHkj,lm9ze3hwc', 1, NULL, '2000-01-01 00:00:00', '2025-02-27 19:15:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1401, 'gemma', 'url', NULL, '1', 0, NULL, '2000-01-01 00:00:00', '2024-11-21 16:48:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1403, 'display', '0828', NULL, '0', 1, NULL, '2000-01-01 00:00:00', '2024-08-26 20:34:56');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1405, 'EFFECT_EVAL', 'base-model-list-filter', '1', 'gemma_2b_chat,gemma2_9b_it', 1, NULL, '2000-01-01 00:00:00', '2024-09-10 16:09:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1407, 'DOCUMENT_LINK', 'eval-set-template', '1', 'https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/%E6%A8%A1%E7%89%88.csv', 1, '', '2023-08-17 00:00:00', '2024-08-27 11:13:38');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1409, 'MODEL_TRAIN_TYPE', '2423718913705984', 'gemma_2b', '0', 1, NULL, '2000-01-01 00:00:00', '2024-09-11 16:41:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1411, 'MODEL_TRAIN_TYPE', '2425335862888448', 'gemma_9b', '1', 1, NULL, '2000-01-01 00:00:00', '2024-09-11 16:41:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1421, 'WORKFLOW_NODE_TEMPLATE', '1,2', '固定节点', '{\n    \"idType\": \"node-start\",\n    \"type\": \"开始节点\",\n    \"position\":\n    {\n        \"x\": 100,\n        \"y\": 300\n    },\n    \"data\":\n    {\n        \"label\": \"Start\",\n        \"description\": \"The starting node of the workflow, used to define the business variable information required for process invocation.\",\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"开始节点\"\n        },\n        \"inputs\":\n        [],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"AGENT_USER_INPUT\",\n                \"deleteDisabled\": true,\n                \"required\": true,\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"User input of the current conversation round\"\n                }\n            }\n        ],\n        \"nodeParam\":\n        {},\n        \"allowInputReference\": false,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\"\n    }\n}', 1, '开始节点', '2000-01-01 00:00:00', '2025-07-28 10:25:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1423, 'WORKFLOW_NODE_TEMPLATE', '1,2', '固定节点', '{\n    \"idType\": \"node-end\",\n    \"type\": \"结束节点\",\n    \"position\":\n    {\n        \"x\": 1000,\n        \"y\": 300\n    },\n    \"data\":\n    {\n        \"label\": \"End\",\n        \"description\": \"The end node of the workflow, used to output the final result after the workflow execution.\",\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"结束节点\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [],\n        \"nodeParam\":\n        {\n            \"outputMode\": 1,\n            \"template\": \"\",\n            \"streamOutput\": true\n        },\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\"\n    }\n}', 1, '结束节点', '2000-01-01 00:00:00', '2025-07-28 10:25:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1425, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Basic Node', '{\n    \"idType\": \"spark-llm\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"Large Model\",\n    \"description\": \"Based on the input prompt, the selected large language model will be invoked to respond accordingly.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"大模型\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"template\": \"\",\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"respFormat\": 0,\n            \"llmId\": 110,\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"enableChatHistoryV2\": {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            }\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\"\n    }\n}', 1, '大模型', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1427, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Basic Node', '{\n    \"idType\": \"ifly-code\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Code\",\n    \"description\": \"Provides code development capability for developers, currently only supports Python language. Allows parameters to be passed in using defined variables, and the return statement is used to output the result of the function.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"代码\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"key0\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key1\",\n                \"schema\": {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key2\",\n                \"schema\": {\n                    \"type\": \"object\",\n                    \"default\": \"\",\n                    \"properties\": [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"key21\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                }\n            }\n        ],\n        \"nodeParam\": {\n            \"code\": \"def main(input):\\n    ret = {\\n        \\\"key0\\\": input + \\\"hello\\\",\\n        \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],\\n        \\\"key2\\\": {\\\"key21\\\": \\\"hi\\\"}\\n    }\\n    return ret\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\"\n    }\n}', 1, '代码', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1429, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Basic Node', '{\n    \"idType\": \"knowledge-base\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Knowledge Base\",\n    \"description\": \"Calls the knowledge base and allows specifying a knowledge repository for information retrieval and response.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"知识库\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"query\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"results\",\n                \"schema\": {\n                    \"type\": \"array-object\",\n                    \"properties\": [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"score\",\n                            \"type\": \"number\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"docId\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"title\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"content\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"context\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"references\",\n                            \"type\": \"object\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                },\n                \"required\": true,\n                \"nameErrMsg\": \"\"\n            }\n        ],\n        \"nodeParam\": {\n            \"repoId\": [],\n            \"repoList\": [],\n            \"topN\": 3\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\"\n    }\n}', 1, '知识库', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1431, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Tool', '{\n    \"idType\": \"flow\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Workflow\",\n    \"description\": \"Quickly integrate published workflows for efficient reuse of existing capabilities.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"工作流\"\n        },\n        \"inputs\": [],\n        \"outputs\": [],\n        \"nodeParam\": {\n            \"appId\": \"\",\n            \"flowId\": \"\",\n            \"uid\": \"\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\"\n    }\n}', 1, '工作流', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1433, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Logic', '{\n    \"idType\": \"decision-making\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Decision\",\n    \"description\": \"Determine the subsequent logic path based on input parameters and the specified intents.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"决策\"\n        },\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"enableChatHistoryV2\": {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"uid\": \"2171\",\n            \"intentChains\": [\n                {\n                    \"intentType\": 2,\n                    \"name\": \"\",\n                    \"description\": \"\",\n                    \"id\": \"intent-one-of::4724514d-ffc8-4412-bf7f-13cc3375110d\"\n                },\n                {\n                    \"intentType\": 1,\n                    \"name\": \"default\",\n                    \"description\": \"Default intent\",\n                    \"id\": \"intent-one-of::506841e4-3f6c-40b1-a804-dc5ffe723b34\"\n                }\n            ],\n            \"reasonMode\": 1,\n            \"model\": \"spark\",\n            \"useFunctionCall\": true,\n            \"serviceId\": \"bm4\",\n            \"promptPrefix\": \"\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"Query\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"class_name\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\"\n    }\n}', 1, '决策', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1435, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Logic', '{\n    \"idType\": \"if-else\",\n    \"nodeType\": \"Branch\",\n    \"aliasName\": \"Branch\",\n    \"description\": \"Determine the branch path based on the defined conditions\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"分支器\",\n            \"aliasName\": \"分支器\"\n        },\n        \"nodeParam\": {\n            \"cases\": [\n                {\n                    \"id\": \"branch_one_of::\",\n                    \"level\": 1,\n                    \"logicalOperator\": \"and\",\n                    \"conditions\": [\n                        {\n                            \"id\": \"\",\n                            \"leftVarIndex\": null,\n                            \"rightVarIndex\": null,\n                            \"compareOperator\": null\n                        }\n                    ]\n                },\n                {\n                    \"id\": \"branch_one_of::\",\n                    \"level\": 999,\n                    \"logicalOperator\": \"and\",\n                    \"conditions\": []\n                }\n            ]\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {\n                            \"nodeId\": \"\",\n                            \"name\": \"\"\n                        }\n                    }\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"input1\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {\n                            \"nodeId\": \"\",\n                            \"name\": \"\"\n                        }\n                    }\n                }\n            }\n        ],\n        \"outputs\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\"\n    }\n}', 1, '分支器', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1437, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Logic', '{\n    \"idType\": \"iteration\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Iteration\",\n    \"description\": \"This node is used to handle loop logic and supports only one level of nesting\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Iteration\"\n        },\n        \"nodeParam\": {},\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"iteratorNodes\": [],\n        \"iteratorEdges\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\"\n    }\n}', 1, '迭代', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1439, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Transformation', '{\n    \"idType\": \"node-variable\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Variable Storage\",\n    \"description\": \"Allows setting multiple variables for long-term data storage, which remains effective and updates persistently\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"变量存储器\"\n        },\n        \"nodeParam\": {\n            \"method\": \"set\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\"\n    }\n}', 1, '变量存储器', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1441, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Transformation', '{\n    \"idType\": \"extractor-parameter\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Variable Extractor\",\n    \"description\": \"Extracts natural language content from the output of the previous node based on variable extraction descriptions\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"变量提取器\"\n        },\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"reasonMode\": 1\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"description\": \"\"\n                },\n                \"required\": true\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\"\n    }\n}', 1, '变量提取器', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1443, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Transformation', '{\n    \"idType\": \"text-joiner\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Text Processing Node\",\n    \"description\": \"Used to process multiple string variables according to specified formatting rules\",\n    \"data\": {\n        \"nodeMeta\": \n        {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"文本拼接\"\n        },\n        \"nodeParam\": {\n            \"prompt\": \"\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\"\n    }\n}', 1, '文本处理节点', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1445, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Other', '{\n    \"idType\": \"message\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Message\",\n    \"description\": \"Used to output intermediate results during workflow execution\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"消息\"\n        },\n        \"nodeParam\": {\n            \"template\": \"\",\n            \"startFrameEnabled\": false\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output_m\",\n                \"schema\": {\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\"\n    }\n}', 1, '消息', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1447, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Tool', '{\n    \"idType\": \"plugin\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Tool\",\n    \"description\": \"Quickly acquire skills by integrating external tools to meet user needs\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"工具\"\n        },\n        \"inputs\": [],\n        \"outputs\": [],\n        \"nodeParam\": {\n            \"appId\": \"4eea957b\",\n            \"code\": \"\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\"\n    }\n}', 1, '工具', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1449, 'LLM_SCENE_FILTER', 'workflow', 'xfyun', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lme990528,lm4onxj7h,lmbXtIcNp,lm27ebHkj,lm9ze3hwc', 1, '', '2000-01-01 00:00:00', '2025-02-27 19:15:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1451, 'PROMPT', 'ai-code', 'create', '## Role\nYou are a Python engineer. Based on the user\'s requirements and the rules and constraints below, generate a complete Python code snippet.\n\n## Dependency Constraints\nThe following are unsupported Python dependencies. Do not use packages outside of this list.\n\n[List remains the same...]\n\n## Rules\n1. The user\'s original code must strictly comply with the provided list of parameter variables (parameter names, types, and quantity), and the required function name.\n2. Input parameters must match the names and types in the provided list;\n3. The output return value must be of type dict. If the user defines specific return field names, use them strictly. Otherwise, the default field name should be ````output````.\n4. Add comments after imports to describe the function\'s purpose and parameter definitions. Only provide the code.\n\n## Function Name:\nmain\n\n## Parameter Variable List (name: variable name, type: data type):\n{var}\n\n## User Requirement:\n{prompt}\n\n## Notes\n1. Only implement the function logic; generate the code only.\n2. Do not include test code, example code, or ````__main__```` blocks.\n\n## Please return a code block directly without using markdown format.', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:54:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1453, 'PROMPT', 'ai-code', 'update', '## Role\nYou are a Python engineer. Based on the user\'s code and the rules and constraints below, optimize the user\'s code.\n\n## Dependency Constraints\nThe following are unsupported Python dependencies. Do not use packages outside of this list.\n\n[List remains unchanged...]\n\n## Rules\n1. The user\'s original code must strictly comply with the provided parameter variable list (parameter names, types, and quantity), and the required function name.\n2. Input parameters must match the names and types in the provided list;\n3. The return type of the output must be a dict. If the user defines specific return field names, follow them exactly. Otherwise, the default return field should be named ````output````.\n4. Add comments after import statements describing the function purpose and parameter definitions. Please provide the code directly.\n\n## Function Name:\nmain\n\n## Parameter Variable List (name: noun, type: data type):\n{var}\n\n## User Original Code:\n{code}\n\n## User Requirement:\n{prompt}\n\n## Notes\n1. Optimize the user-provided code according to the conditions above;\n2. Do not include test code, sample code, or ````__main__```` block;\n\n## Please return a code block directly, do not return markdown format.', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:55:38');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1455, 'PROMPT', 'ai-code', 'fix', '## Role\nYou are a Python engineer. Based on the user\'s original code and the error message, return a corrected code block.\n\n## Function Name:\nmain\n\n## Parameter Variable List (name: variable name, type: data type, value: value):\n{var}\n\n## User Original Code:\n{code}\n\n## Error Message from User\'s Code Execution:\n{errMsg}\n\n## Notes\nOnly modify the part indicated in the error message; do not change other parts of the code.\n\n## Please return a code block directly.', 1, '', '2000-01-01 00:00:00', '2025-07-23 14:55:38');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1457, 'WORKFLOW', 'python-dependency', '代码执行器py依赖', '{\n    \"anyio\": \"3.7.1\",\n    \"argon2-cffi\": \"23.1.0\",\n    \"argon2-cffi-bindings\": \"21.2.0\",\n    \"asttokens\": \"2.4.1\",\n    \"attrs\": \"23.1.0\",\n    \"Babel\": \"2.13.1\",\n    \"backcall\": \"0.2.0\",\n    \"beautifulsoup4\": \"4.12.2\",\n    \"bleach\": \"6.1.0\",\n    \"boltons\": \"23.0.0\",\n    \"Brotli\": \"1.1.0\",\n    \"certifi\": \"2023.11.17\",\n    \"cffi\": \"1.16.0\",\n    \"charset-normalizer\": \"3.3.2\",\n    \"colorama\": \"0.4.6\",\n    \"comm\": \"0.1.4\",\n    \"conda\": \"23.3.1\",\n    \"conda-package-handling\": \"2.2.0\",\n    \"conda_package_streaming\": \"0.9.0\",\n    \"cryptography\": \"39.0.0\",\n    \"cycler\": \"0.12.1\",\n    \"debugpy\": \"1.8.0\",\n    \"decorator\": \"5.1.1\",\n    \"defusedxml\": \"0.7.1\",\n    \"dill\": \"0.3.5\",\n    \"entrypoints\": \"0.4\",\n    \"et-xmlfile\": \"1.1.0\",\n    \"exceptiongroup\": \"1.2.0\",\n    \"executing\": \"2.0.1\",\n    \"fastjsonschema\": \"2.19.0\",\n    \"gensim\": \"4.1.0\",\n    \"gmpy2\": \"2.1.2\",\n    \"idna\": \"3.4\",\n    \"importlib-metadata\": \"6.8.0\",\n    \"importlib-resources\": \"6.1.1\",\n    \"ipykernel\": \"6.26.0\",\n    \"ipython\": \"8.12.2\",\n    \"ipython-genutils\": \"0.2.0\",\n    \"jedi\": \"0.19.1\",\n    \"Jinja2\": \"3.1.2\",\n    \"joblib\": \"1.3.2\",\n    \"json5\": \"0.9.14\",\n    \"jsonpatch\": \"1.33\",\n    \"jsonpointer\": \"2.4\",\n    \"jsonschema\": \"4.20.0\",\n    \"jsonschema-specifications\": \"2023.11.1\",\n    \"jupyter_client\": \"8.6.0\",\n    \"jupyter_core\": \"5.1.3\",\n    \"jupyter-server\": \"1.24.0\",\n    \"jupyterlab\": \"3.4.8\",\n    \"jupyterlab_pygments\": \"0.3.0\",\n    \"jupyterlab_server\": \"2.25.2\",\n    \"kiwisolver\": \"1.4.5\",\n    \"libmambapy\": \"1.2.0\",\n    \"lxml\": \"4.9.2\",\n    \"mamba\": \"1.2.0\",\n    \"MarkupSafe\": \"2.1.3\",\n    \"matplotlib\": \"3.4.3\",\n    \"matplotlib-inline\": \"0.1.6\",\n    \"matplotlib-venn\": \"0.11.6\",\n    \"mistune\": \"3.0.2\",\n    \"mpmath\": \"1.3.0\",\n    \"nbclassic\": \"0.4.5\",\n    \"nbclient\": \"0.8.0\",\n    \"nbconvert\": \"7.11.0\",\n    \"nbformat\": \"5.9.2\",\n    \"nest-asyncio\": \"1.5.8\",\n    \"notebook\": \"6.5.1\",\n    \"notebook_shim\": \"0.2.3\",\n    \"numpy\": \"1.21.2\",\n    \"numpy-financial\": \"1.0.0\",\n    \"olefile\": \"0.46\",\n    \"openpyxl\": \"3.0.10\",\n    \"packaging\": \"23.2\",\n    \"pandas\": \"1.3.2\",\n    \"pandocfilters\": \"1.5.0\",\n    \"parso\": \"0.8.3\",\n    \"patsy\": \"0.5.4\",\n    \"pexpect\": \"4.8.0\",\n    \"pickleshare\": \"0.7.5\",\n    \"Pillow\": \"8.4.0\",\n    \"pip\": \"23.3.1\",\n    \"pkgutil_resolve_name\": \"1.3.10\",\n    \"platformdirs\": \"4.0.0\",\n    \"pluggy\": \"1.3.0\",\n    \"prometheus-client\": \"0.19.0\",\n    \"prompt-toolkit\": \"3.0.41\",\n    \"psutil\": \"5.9.5\",\n    \"ptyprocess\": \"0.7.0\",\n    \"pure-eval\": \"0.2.2\",\n    \"pycosat\": \"0.6.6\",\n    \"pycparser\": \"2.21\",\n    \"Pygments\": \"2.17.2\",\n    \"pyOpenSSL\": \"23.2.0\",\n    \"pyparsing\": \"3.1.1\",\n    \"PyPDF2\": \"1.28.6\",\n    \"PyQt5\": \"5.15.4\",\n    \"PyQt5-sip\": \"12.9.0\",\n    \"PySocks\": \"1.7.1\",\n    \"python-dateutil\": \"2.8.2\",\n    \"python-docx\": \"0.8.11\",\n    \"python-pptx\": \"1.0.2\",\n    \"pytz\": \"2023.3.post1\",\n    \"pyzmq\": \"25.1.1\",\n    \"referencing\": \"0.31.0\",\n    \"requests\": \"2.31.0\",\n    \"rpds-py\": \"0.13.1\",\n    \"ruamel.yaml\": \"0.17.40\",\n    \"ruamel.yaml.clib\": \"0.2.7\",\n    \"scikit-learn\": \"1.0\",\n    \"scipy\": \"1.7.1\",\n    \"seaborn\": \"0.11.2\",\n    \"Send2Trash\": \"1.8.2\",\n    \"setuptools\": \"59.8.0\",\n    \"sip\": \"6.5.1\",\n    \"six\": \"1.16.0\",\n    \"smart-open\": \"6.4.0\",\n    \"sniffio\": \"1.3.0\",\n    \"soupsieve\": \"2.5\",\n    \"stack-data\": \"0.6.2\",\n    \"statsmodels\": \"0.13.5\",\n    \"sympy\": \"1.8\",\n    \"terminado\": \"0.18.0\",\n    \"threadpoolctl\": \"3.2.0\",\n    \"tinycss2\": \"1.2.1\",\n    \"toml\": \"0.10.2\",\n    \"tomli\": \"2.0.1\",\n    \"toolz\": \"0.12.0\",\n    \"tornado\": \"6.3.3\",\n    \"tqdm\": \"4.66.1\",\n    \"traitlets\": \"5.9.0\",\n    \"typing_extensions\": \"4.8.0\",\n    \"urllib3\": \"2.1.0\",\n    \"wcwidth\": \"0.2.12\",\n    \"webencodings\": \"0.5.1\",\n    \"websocket-client\": \"1.6.4\",\n    \"wheel\": \"0.41.3\",\n    \"zipp\": \"3.17.0\",\n    \"zstandard\": \"0.22.0\"\n}', 1, '', '2000-01-01 00:00:00', '2025-07-10 15:47:31');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1458, 'TEMPLATE', 'node', '', '[\n    {\n        \"idType\": \"spark-llm\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\",\n        \"name\": \"Large Model\",\n        \"markdown\": \"## Purpose\\nBased on the input prompt, invoke the selected large model to respond accordingly.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| input (reference) | Start-query |\\n## Prompt\\nYou are a super-intelligent travel planner who is very good at identifying various travel needs from the user\'s input information and organizing and outputting them. Your task now is to carefully analyze and understand the user\'s input information strictly according to the following definitions and rules, and output a user travel requirement profile that includes: [Destination], [Number of Days], [Travel Companions], [Preferences], and [Travel Date]\\n### Output\\n| Variable Name | Variable Value |\\n|--------------|----------------|\\n| output (String) | 🌟Dear friend, I got your travel request! I understand you are planning an exciting 3-day trip to Hefei 😃. Please wait a moment while I generate your itinerary. Let me briefly introduce the destination: Hefei, with many must-visit attractions... (rest omitted for brevity).\"\n    },\n    {\n        \"idType\": \"ifly-code\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\",\n        \"name\": \"Code\",\n        \"markdown\": \"## Purpose\\nProvides code capabilities for developers, currently only supports Python. Allows passing variables defined in the node as parameters, and returns a result via return statement.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| location (reference) | Code-location |\\n| person (reference) | Code-person |\\n| day (reference) | Code-day |\\n## Code\\nasync def main(args: Args) -> Output: \\n    params = args.params\\n    ret: Output = {\\\"ret\\\": params[\'location\'] + params[\'person\'] + params[\'day\'] + \' travel guide\'}\\n    return ret\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| ret (String) | Hefei 5 people 3 days travel guide |\"\n    },\n    {\n        \"idType\": \"knowledge-base\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"name\": \"Knowledge Base\",\n        \"markdown\": \"## Purpose\\nCalls a knowledge base, and can specify the base for retrieval and response.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| Query (String) (reference) | Large Model-output |\\n## Knowledge Base\\nNational Gourmet Encyclopedia\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| OutputList (Array<Object>) | Top 10 Hefei dishes: Cao Cao Chicken, Luzhou Roast Duck, Feidong Mudfish Pot, Sesame Cakes, Twisted Dough, Sesame Cookies, Duck Oil Biscuits, Feixi Old Hen Soup, Feixi Intestine Pot, Zhipengshan Stewed Goose |\"\n    },\n    {\n        \"idType\": \"plugin\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\",\n        \"name\": \"Tool\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-tool.png\",\n        \"markdown\": \"## Purpose\\nQuickly access external tools to meet user needs.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| query (reference) [e.g., for Bing search tool, \'query\' is required] | Code-Food-result |\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| result (String) | Hefei food, Hefei food guide, Hefei food recommendation - MFW Luzhou Roast Duck restaurant, Old Xiang Chicken, Liu Hongsheng Wonton in Chicken Broth... |\"\n    },\n    {\n        \"idType\": \"flow\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\",\n        \"name\": \"Workflow\",\n        \"markdown\": \"## Purpose\\nThe large model decides the subsequent flow direction based on node input and prompt content.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| location (reference) [required] | Variable Extractor-location |\\n| data (reference) [required] | Variable Extractor-data |\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| output (String) | Weather in Hefei today is cloudy, 27℃~33℃, northeast wind force 5-6... |\"\n    },\n    {\n        \"idType\": \"decision-making\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\",\n        \"name\": \"Decision\",\n        \"markdown\": \"## Purpose\\nThe large model decides which branch to take based on input and prompt.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| guide (reference) | Code-guide |\\n| food (reference) | Code-food |\\n| hotel (reference) | Code-hotel |\\n## Prompt\\nBased on guide {{guide}}, food preference {{food}}, and hotel location {{hotel}}, decide which intent to follow\\n## Intents\\n- Travel guide\\n- Food recommendation\\n- Hotel recommendation\\n- Other\"\n    },\n    {\n        \"idType\": \"if-else\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\",\n        \"name\": \"Branch\",\n        \"markdown\": \"## Purpose\\nDirect flow based on specified conditions\\n## Example\\n### Input\\n| Condition |\\n|-----------|\\n| Condition 1: \'Start-query\' contains travel or guide. Otherwise: default branch |\"\n    },\n    {\n        \"idType\": \"iteration\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\",\n        \"name\": \"Iteration\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-iteration.png\",\n        \"markdown\": \"## Purpose\\nHandle loop logic, supports only one level of nesting\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| locations (Array) | Code-locations |\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| outputList (Array) | [{\\\"Hefei Travel Guide\\\"}, {\\\"Nanjing Travel Guide\\\"}, {\\\"Shanghai Travel Guide\\\"}] |\"\n    },\n    {\n        \"idType\": \"node-variable\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\",\n        \"name\": \"Variable Storage\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-var-storage.png\",\n        \"markdown\": \"## Purpose\\nDefine multiple variables that persist during multi-turn conversations. Cleared on new chat or chat history deletion.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| question | Start-query |\"\n    },\n    {\n        \"idType\": \"extractor-parameter\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\",\n        \"name\": \"Variable Extractor\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-var-extractor.png\",\n        \"markdown\": \"## Purpose\\nExtract variables from natural language based on defined descriptions\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| location | Extract location from question |\\n| day | Extract number of days from question |\\n| person | Extract number of people from question |\\n| data | Extract date from question |\"\n    },\n    {\n        \"idType\": \"message\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\",\n        \"name\": \"Message\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-message.png\",\n        \"markdown\": \"## Purpose\\nOutput intermediate results during workflow\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| result (reference) | Large Model-output |\\n| result1 (reference) | Large Model-output1 |\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| Large Model-output | Response: Two solutions for your question: Option 1: {{result}}, Option 2: {{result1}} |\"\n    },\n    {\n        \"idType\": \"text-joiner\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\",\n        \"name\": \"Text Joiner\",\n        \"image\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/template/node-text-joiner.png\",\n        \"markdown\": \"## Purpose\\nUse {{variableName}} to reference defined variables, concatenate according to rules\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| age (input) | 18 |\\n| name (input) | Xiaoming |\\n## Rule\\nI am {{name}}, I am {{age}} years old.\\n### Output\\n| Variable Name | Variable Value |\\n|----------------|----------------|\\n| output (String) | I am Xiaoming, I am 18 years old. |\"\n    },\n    {\n        \"idType\": \"agent\",\n        \"name\": \"Agent Intelligent Decision\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n        \"markdown\": \"## Purpose\\nIntelligently dispatch tools based on selected strategy. Also invokes large model with prompt to generate output.\\n## Example\\n### Input\\n| Parameter Name | Parameter Value |\\n|----------------|----------------------|\\n| Input | Start/AGENT_USER_INPUT |\\n## Agent Strategy\\nReAct strategy helps large models perform structured reasoning and decision-making.\\n## Tool List\\nSupports up to 30 published tools or MCPs.\\n## Custom MCP Server\\nAllows setting up to 3 custom MCP servers.\\n## Prompt Sections\\n- Role Setting (optional)\\n- Thought Process (optional)\\n- User Query (required)\\n## Max Rounds\\nMaximum is 100, default is 10.\\n### Output\\n| Parameter Name | Parameter Value | Description |\\n|----------------|------------------|-------------|\\n| Reasoning | String | Model\'s thought process |\\n| Output | String | Model\'s final response |\"\n    },\n    {\n        \"idType\": \"knowledge-pro-base\",\n        \"name\": \"Knowledge Base Pro\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"markdown\": \"## Purpose\\nIn complex scenarios, use intelligent strategy to query knowledge base and generate summaries.\\n## Answer Mode\\nSelect large model to split queries and summarize results.\\n## Strategies\\nAgentic RAG – decomposes complex questions into sub-questions.\\nLong RAG – handles long document understanding.\\n### Input\\n| Parameter Name | Parameter Value | Description |\\n|----------------|------------------|-------------|\\n| query | String | User input |\\n## Knowledge Base\\nSelect database and set parameters. When split into multiple sub-questions, final recall count = top k ✖ number of sub-questions.\\n## Answer Rules\\nOptional. e.g., “If no answer found, say \'I don\'t know.\'”\\n### Output\\n| Parameter Name | Parameter Value | Description |\\n|----------------|------------------|-------------|\\n| Reasoning | String | Model\'s thought process |\\n| Output | String | Final answer |\\n| result | Array<Object> | Retrieved results |\"\n    },\n    {\n        \"idType\": \"question-answer\",\n        \"name\": \"Q&A\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBot/test4/answer-new2.png\",\n        \"markdown\": \"## Purpose\\nAsk the user a question mid-workflow. Supports both predefined options and open-ended replies.\\n## Example 1 (Option Reply)\\n| Parameter Name | Parameter Value |\\n|----------------|------------------|\\n| Input | Start/AGENT_USER_INPUT |\\n| Question | Traveling is a great idea! Do you have a destination in mind? |\\n| Answer Mode | Option Reply |\\n| Options | A: Nature B: Culture C: Urban |\\n### Output\\n| Parameter Name | Parameter Value | Description |\\n|----------------|------------------|-------------|\\n| query | String | Question asked |\\n| id | String | Option ID |\\n| content | String | User\'s response |\\n---\\n## Example 2 (Direct Reply)\\n| Parameter Name | Parameter Value |\\n|----------------|------------------|\\n| Input | Start/AGENT_USER_INPUT |\\n| Question | Where would you like to go? Type? Time? Budget? |\\n| Answer Mode | Direct Reply |\\n### Output\\n| Parameter Name | Parameter Value | Description |\\n|----------------|------------------|-------------|\\n| query | String | Question asked |\\n| content | String | User\'s response |\\n### Parameter Extraction\\n| Parameter Name | Parameter Value | Description | Default | Required |\\n|----------------|------------------|-------------|---------|----------|\\n| city | String | Location | -- | Yes |\\n| type | String | Destination type | -- | Yes |\\n| time | Number | Duration | -- | Yes |\\n| budget | String | Budget | -- | Yes |\"\n    },\n    {\n        \"idType\": \"database\",\n        \"name\": \"Database\",\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/user/sparkBot_1752568522509_database_icon.svg\",\n        \"markdown\": \"## Purpose\\nThis node can connect to a specified database and perform common operations such as insert, query, update, and delete, enabling dynamic data management.\\n\\n## Example\\n\\n### Input\\n\\n| Parameter Name | Value |\\n|----------------|--------------------------------------------------|\\n| Input          | Start/AGENT_USER_INPUT                          |\\n\\n### Output\\n\\n| Parameter Name | Value   | Description                                  |\\n|----------------|---------|----------------------------------------------|\\n| isSuccess      | Boolean | SQL execution status, true if successful, false otherwise |\\n| message        | String  | Reason for failure                           |\\n| outputList     | (Array<Object>) | Execution result                      |\\n\"\n    }\n]', 1, '', '2000-01-01 00:00:00', '2025-07-30 17:59:02');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1459, 'WORKFLOW_CHANNEL', 'api', 'API', '发布为API', 1, '完成配置后，即可接入到个人应用中使用。', '2000-01-01 00:00:00', '2025-01-06 17:02:30');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1460, 'SPECIAL_USER', 'workflow-all-view', NULL, '100000039012', 1, NULL, '2000-01-01 00:00:00', '2024-12-03 19:16:07');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1461, 'WORKFLOW_CHANNEL', 'ixf-personal', 'i讯飞-个人版', '发布至新版本i讯飞中', 0, '无需审核，个人版本仅供个人使用和对话，无法分享给他人，也无法拉入群内。', '2000-01-01 00:00:00', '2024-12-19 11:10:51');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1463, 'WORKFLOW_CHANNEL', 'ixf-team', 'i讯飞-团队版', '发布至新版本i讯飞中', 0, '需要经过审核，团队版本支持分享给他人使用，支持拉入群内使用。', '2000-01-01 00:00:00', '2024-12-19 11:10:51');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1465, 'WORKFLOW_CHANNEL', 'aiui', '交互链路', '发布至AIUI智能体平台', 1, '发布并审核通过后，即可在aiui平台进行配置。', '2000-01-01 00:00:00', '2024-12-13 10:15:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1467, 'WORKFLOW_CHANNEL', 'sparkdesk', '星火Desk/APP', '发布至讯飞星火desk，以及星火app（App、网页版）', 0, '发布并审核通过后，即可在星火desk和星火App体验该智能体。', '2000-01-01 00:00:00', '2024-12-19 11:10:51');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1469, 'WORKFLOW_CHANNEL', 'square', '工作流广场', '发布至星辰工作流广场', 1, '发布成功后，用户即可在广场使用。', '2000-01-01 00:00:00', '2025-03-24 17:50:37');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1470, 'SWITCH', 'EvalTaskStatusGetJob', '0', '0', 1, '1', '2000-01-01 00:00:00', '2025-01-08 11:41:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1472, 'PROMPT', 'new-intent', '', '### Job Responsibility Description\nYou are a text classification engine. You need to analyze text data and, based on the user input and the category descriptions, carefully determine the appropriate category.\n\n### Task\nYour task is to assign only one category to the input text, and the output should contain only that one category. In addition, you should extract keywords related to the classification from the text. If there is no relevance at all, the keyword list can be empty.\n\n### Input Format\nThe input text is stored in the variable ````input_text````. The categories are listed in the variable ````Categories````, and each contains the fields ````category_id````, ````category_name````, and ````category_desc````. Think carefully and follow the category descriptions strictly to improve classification accuracy.\n\n### History Memory\nThis is the conversation history between the human and the assistant, enclosed in <histories></histories> XML tags.\n<histories>\n</histories>\n\n### Constraints\nDo not include anything other than the JSON array in your response.\n\n### Output Format\njson{\"category_name\": \"\"}\n\n### The following is the text data to be analyzed\n$coreText', 1, '新决策节点的prompt', '2000-01-01 00:00:00', '2025-07-23 15:22:26');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1473, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'null', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lme990528,lm479a5b8,lmt4do9o3', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:30');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1475, 'LLM_WORKFLOW_FILTER', 'xfyun', 'null', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lm9ze3hwc', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:30');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1477, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'spark-llm', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lme990528,lme693475,lmbXtIcNp,lm27ebHkj,lm9ze3hwc,lm4onxj7h,lmt2br78l,lm4rar7p2', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:30');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1479, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'decision-making', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lme990528,lm479a5b8,lme693475,lmt4do9o3,lmt4do9o3', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:29');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1481, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'extractor-parameter', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lmt4do9o3', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:29');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1483, 'LLM_WORKFLOW_FILTER', 'xfyun', 'extractor-parameter', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lm9ze3hwc,lmbXtIcNp,lm27ebHkj', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:29');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1485, 'LLM_WORKFLOW_FILTER', 'xfyun', 'decision-making', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lm9ze3hwc,lmbXtIcNp,lm27ebHkj', 0, '', '2000-01-01 00:00:00', '2025-03-24 19:39:29');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1487, 'LLM_WORKFLOW_FILTER', 'xfyun', 'spark-llm', 'lmg5gtbs0,lmyvosz36,lm0dy3kv0,lm9ze3hwc,lmbXtIcNp,lm27ebHkj,dsv3t128k,xsp8f70988f', 0, '', '2000-01-01 00:00:00', '2025-06-12 09:31:23');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1488, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '固定节点', '{\n    \"idType\": \"node-start\",\n    \"type\": \"开始节点\",\n    \"position\":\n    {\n        \"x\": 100,\n        \"y\": 300\n    },\n    \"data\":\n    {\n        \"label\": \"Start\",\n        \"description\": \"The starting node of the workflow, used to define the business variable information required for process invocation.\",\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"开始节点\"\n        },\n        \"inputs\":\n        [],\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"AGENT_USER_INPUT\",\n                \"deleteDisabled\": true,\n                \"required\": true,\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"User input of the current conversation round\"\n                }\n            }\n        ],\n        \"nodeParam\":\n        {},\n        \"allowInputReference\": false,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\"\n    }\n}', 1, '开始节点', '2000-01-01 00:00:00', '2025-07-25 17:17:17');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1490, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '固定节点', '{\n    \"idType\": \"node-end\",\n    \"type\": \"结束节点\",\n    \"position\":\n    {\n        \"x\": 1000,\n        \"y\": 300\n    },\n    \"data\":\n    {\n        \"label\": \"End\",\n        \"description\": \"The end node of the workflow, used to output the final result after the workflow execution.\",\n        \"nodeMeta\":\n        {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"结束节点\"\n        },\n        \"inputs\":\n        [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                }\n            }\n        ],\n        \"outputs\":\n        [],\n        \"nodeParam\":\n        {\n            \"outputMode\": 1,\n            \"template\": \"\",\n            \"streamOutput\": true\n        },\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\"\n    }\n}', 1, '结束节点', '2000-01-01 00:00:00', '2025-07-25 17:17:44');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1492, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"idType\": \"spark-llm\",\n    \"nodeType\": \"基础节点\",\n    \"aliasName\": \"Large Model\",\n    \"description\": \"Based on the input prompt, the selected large language model will be invoked to respond accordingly.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"大模型\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"template\": \"\",\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"respFormat\": 0,\n            \"llmId\": 110,\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"enableChatHistoryV2\": {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            }\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\"\n    }\n}', 1, '大模型', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1494, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"idType\": \"ifly-code\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Code\",\n    \"description\": \"Provides code development capability for developers, currently only supports Python language. Allows parameters to be passed in using defined variables, and the return statement is used to output the result of the function.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"代码\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"key0\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key1\",\n                \"schema\": {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key2\",\n                \"schema\": {\n                    \"type\": \"object\",\n                    \"default\": \"\",\n                    \"properties\": [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"key21\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                }\n            }\n        ],\n        \"nodeParam\": {\n            \"code\": \"def main(input):\\n    ret = {\\n        \\\"key0\\\": input + \\\"hello\\\",\\n        \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],\\n        \\\"key2\\\": {\\\"key21\\\": \\\"hi\\\"}\\n    }\\n    return ret\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\"\n    }\n}', 1, '代码', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1496, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"idType\": \"knowledge-base\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Knowledge Base\",\n    \"description\": \"Calls the knowledge base and allows specifying a knowledge repository for information retrieval and response.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"知识库\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"query\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"results\",\n                \"schema\": {\n                    \"type\": \"array-object\",\n                    \"properties\": [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"score\",\n                            \"type\": \"number\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"docId\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"title\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"content\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"context\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"references\",\n                            \"type\": \"object\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                },\n                \"required\": true,\n                \"nameErrMsg\": \"\"\n            }\n        ],\n        \"nodeParam\": {\n            \"repoId\": [],\n            \"repoList\": [],\n            \"topN\": 3\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\"\n    }\n}', 1, '知识库', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1498, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '工具', '{\n    \"idType\": \"plugin\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Tool\",\n    \"description\": \"Quickly acquire skills by integrating external tools to meet user needs\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"工具\"\n        },\n        \"inputs\": [],\n        \"outputs\": [],\n        \"nodeParam\": {\n            \"appId\": \"4eea957b\",\n            \"code\": \"\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\"\n    }\n}', 1, '工具', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1500, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '工具', '{\n    \"idType\": \"flow\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Workflow\",\n    \"description\": \"Quickly integrate published workflows for efficient reuse of existing capabilities.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"工作流\"\n        },\n        \"inputs\": [],\n        \"outputs\": [],\n        \"nodeParam\": {\n            \"appId\": \"\",\n            \"flowId\": \"\",\n            \"uid\": \"\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\"\n    }\n}', 1, '工作流', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1502, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\n    \"idType\": \"decision-making\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Decision\",\n    \"description\": \"Determine the subsequent logic path based on input parameters and the specified intents.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"决策\"\n        },\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"enableChatHistoryV2\": {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"uid\": \"2171\",\n            \"intentChains\": [\n                {\n                    \"intentType\": 2,\n                    \"name\": \"\",\n                    \"description\": \"\",\n                    \"id\": \"intent-one-of::4724514d-ffc8-4412-bf7f-13cc3375110d\"\n                },\n                {\n                    \"intentType\": 1,\n                    \"name\": \"default\",\n                    \"description\": \"Default intent\",\n                    \"id\": \"intent-one-of::506841e4-3f6c-40b1-a804-dc5ffe723b34\"\n                }\n            ],\n            \"reasonMode\": 1,\n            \"model\": \"spark\",\n            \"useFunctionCall\": true,\n            \"serviceId\": \"bm4\",\n            \"promptPrefix\": \"\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"Query\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"class_name\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\"\n    }\n}', 1, '决策', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1504, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\n    \"idType\": \"if-else\",\n    \"nodeType\": \"Branch\",\n    \"aliasName\": \"Branch\",\n    \"description\": \"Determine the branch path based on the defined conditions\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"分支器\",\n            \"aliasName\": \"分支器\"\n        },\n        \"nodeParam\": {\n            \"cases\": [\n                {\n                    \"id\": \"branch_one_of::\",\n                    \"level\": 1,\n                    \"logicalOperator\": \"and\",\n                    \"conditions\": [\n                        {\n                            \"id\": \"\",\n                            \"leftVarIndex\": null,\n                            \"rightVarIndex\": null,\n                            \"compareOperator\": null\n                        }\n                    ]\n                },\n                {\n                    \"id\": \"branch_one_of::\",\n                    \"level\": 999,\n                    \"logicalOperator\": \"and\",\n                    \"conditions\": []\n                }\n            ]\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {\n                            \"nodeId\": \"\",\n                            \"name\": \"\"\n                        }\n                    }\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"input1\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {\n                            \"nodeId\": \"\",\n                            \"name\": \"\"\n                        }\n                    }\n                }\n            }\n        ],\n        \"outputs\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\"\n    }\n}', 1, '分支器', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1506, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\n    \"idType\": \"iteration\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Iteration\",\n    \"description\": \"This node is used to handle loop logic and supports only one level of nesting\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Iteration\"\n        },\n        \"nodeParam\": {},\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"iteratorNodes\": [],\n        \"iteratorEdges\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\"\n    }\n}', 1, '迭代', '2000-01-01 00:00:00', '2025-07-23 15:24:27');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1508, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '转换', '{\n    \"idType\": \"node-variable\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Variable Storage\",\n    \"description\": \"Allows setting multiple variables for long-term data storage, which remains effective and updates persistently\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"变量存储器\"\n        },\n        \"nodeParam\": {\n            \"method\": \"set\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\"\n    }\n}', 1, '变量存储器', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1510, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '转换', '{\n    \"idType\": \"extractor-parameter\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Variable Extractor\",\n    \"description\": \"Extracts natural language content from the output of the previous node based on variable extraction descriptions\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"变量提取器\"\n        },\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"reasonMode\": 1\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"description\": \"\"\n                },\n                \"required\": true\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\"\n    }\n}', 1, '变量提取器', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1512, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '转换', '{\n    \"idType\": \"text-joiner\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Text Processing Node\",\n    \"description\": \"Used to process multiple string variables according to specified formatting rules\",\n    \"data\": {\n        \"nodeMeta\": \n        {\n            \"nodeType\": \"工具\",\n            \"aliasName\": \"文本拼接\"\n        },\n        \"nodeParam\": {\n            \"prompt\": \"\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\"\n    }\n}', 1, '文本处理节点', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1514, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '其他', '{\n    \"idType\": \"message\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Message\",\n    \"description\": \"Used to output intermediate results during workflow execution\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"基础节点\",\n            \"aliasName\": \"消息\"\n        },\n        \"nodeParam\": {\n            \"template\": \"\",\n            \"startFrameEnabled\": false\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output_m\",\n                \"schema\": {\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\"\n    }\n}', 1, '消息', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1516, 'mingduan', '1', NULL, 'http://maas-api.cn-huabei-1.xf-yun.com/v1', 1, 'https://spark-api-open.xf-yun.com/v2', '2000-01-01 00:00:00', '2025-04-18 17:49:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1517, 'AI_CODE', 'DS_V3_domain', '1', 'xdeepseekv3', 1, NULL, '2000-01-01 00:00:00', '2025-03-13 09:36:01');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1519, 'AI_CODE', 'DS_V3_url', '1', 'wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat', 1, NULL, '2000-01-01 00:00:00', '2025-03-13 09:36:01');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1520, 'LLM', 'base-model', 'xdeepseekr1', 'xdeepseekr1', 1, 'DeepSeek-R1', '2000-01-01 00:00:00', NULL);
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1522, 'LLM', 'base-model', 'xdeepseekv3', 'xdeepseekv3', 1, 'DeepSeek-V3', '2000-01-01 00:00:00', '2024-07-08 11:06:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1524, 'TAG', 'FLOW_TAGS', '交通出行', 'travel', 1, '交通出行', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1526, 'TAG', 'FLOW_TAGS', '休闲娱乐', 'recreation', 1, '休闲娱乐', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1528, 'TAG', 'FLOW_TAGS', '医药健康', 'medicine', 1, '医药健康', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1530, 'TAG', 'FLOW_TAGS', '影视音乐', 'film-music', 1, '影视音乐', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1532, 'TAG', 'FLOW_TAGS', '教育百科', 'educationEncyclopedia', 1, '教育百科', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1534, 'TAG', 'FLOW_TAGS', '新闻资讯', 'news', 1, '新闻资讯', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1536, 'TAG', 'FLOW_TAGS', '母婴儿童', 'mother-to-child', 1, '母婴儿童', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1538, 'TAG', 'FLOW_TAGS', '生活常用', 'daily-life', 1, '生活常用', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1540, 'TAG', 'FLOW_TAGS', '金融理财', 'financialPlanning', 1, '金融理财', '2025-03-10 10:00:00', '2025-03-11 10:28:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1542, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'spark-llm', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,x1,xop3qwen30b,xop3qwen235b,xop3qwen14b,xop3qwen8b', 1, '', '2000-01-01 00:00:00', '2025-06-16 15:29:43');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1544, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'decision-making', 'bm3,bm3.5,bm4', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1546, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'extractor-parameter', 'bm3,bm3.5,bm4', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1548, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'extractor-parameter', 'bm3,bm3.5,bm4,xdeepseekv3,xdeepseekr1', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:14');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1549, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'agent', 'xdeepseekv3,xdeepseekr1,x1,xop3qwen30b,xop3qwen235b', 1, '', '2000-01-01 00:00:00', '2025-06-10 17:16:48');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1550, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'decision-making', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xqwen257bchat,xdeepseekv3,xdeepseekr1', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1551, 'LLM_WORKFLOW_FILTER', 'xfyun', 'agent', 'xdeepseekv3,xdeepseekr1,x1,xop3qwen30b,xop3qwen235b,xdsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-06-16 10:07:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1552, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'spark-llm', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,x1,xop3qwen30b,xop3qwen235b', 1, '', '2000-01-01 00:00:00', '2025-04-29 09:44:50');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1553, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '逻辑', '{\n    \"aliasName\": \"Agent Intelligent Decision\",\n    \"idType\": \"agent\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"customParameterType\": \"deepseekr1\",\n                \"name\": \"REASONING_CONTENT\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"Model reasoning process\",\n                    \"type\": \"string\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"input\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"智能体节点\",\n            \"nodeType\": \"Agent节点\"\n        },\n        \"nodeParam\":\n        {\n            \"appId\": \"\",\n            \"serviceId\": \"xdeepseekv3\",\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"modelConfig\":\n            {\n                \"domain\": \"xdeepseekv3\",\n                \"api\": \"wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat\",\n                \"agentStrategy\": 1\n            },\n            \"instruction\":\n            {\n                \"reasoning\": \"\",\n                \"answer\": \"\",\n                \"query\": \"\"\n            },\n            \"plugin\":\n            {\n                \"tools\":\n                [],\n                \"toolsList\":\n                [],\n                \"mcpServerIds\":\n                [],\n                \"mcpServerUrls\":\n                [],\n                \"workflowIds\":\n                []\n            },\n            \"maxLoopCount\": 10\n        }\n    },\n    \"description\": \"According to task requirements, realize intelligent scheduling of large models by selecting an appropriate tool list\",\n    \"nodeType\": \"Basic Node\"\n}', 1, 'agent', '2000-01-01 00:00:00', '2025-07-25 16:57:52');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1554, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'null', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1555, 'WORKFLOW_CHANNEL', 'mcp', 'MCP Server', '发布为MCP Server', 1, '发布成功后即可在工作流编排时调用，并在agent决策节点工具列表查看', '2000-01-01 00:00:00', '2025-04-09 14:15:54');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1556, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'null', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding', 1, '', '2000-01-01 00:00:00', '2025-03-24 14:54:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1557, 'WORKFLOW_AGENT_STRATEGY', 'agentStrategy', 'ReACT (支持MCP Tools)', 'Structured reasoning and decision-making process to guide large models in completing complex tasks', 1, '1', '2000-01-01 00:00:00', '2025-07-23 15:26:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1558, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'null', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3', 1, '', '2000-01-01 00:00:00', '2025-05-21 15:57:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1559, 'MCP_MODEL_API_REFLECT', 'mcp', 'xdeepseekv3', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1560, 'LLM_WORKFLOW_FILTER', 'xfyun', 'null', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3', 1, '', '2000-01-01 00:00:00', '2025-05-21 15:57:20');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1561, 'MCP_MODEL_API_REFLECT', 'mcp', 'xdeepseekr1', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1562, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'spark-llm', 'patch,cbm,bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xsqwen2d53b,xdeepseekv32,x1,xop3qwen30b,xop3qwen235b,xdeepseekr1qwen14b,xdeepseekr1qwen32b,xsp8f70988f,xqwen257bchat,xdsv3t128k,dsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-06-26 17:53:25');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1563, 'MCP_SERVER_URL_PREFIX', 'mcp', 'https://xingchen-api.xf-yun.com/mcp/xingchen/flow/{0}/sse', '', 1, '', '2000-01-01 00:00:00', '2025-04-09 15:04:01');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1564, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'decision-making', 'patch,cbm,bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xqwen257bchat,xdeepseekv3,xdeepseekr1', 1, '', '2000-01-01 00:00:00', '2025-04-18 16:43:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1566, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'extractor-parameter', 'bm3,bm3.5,bm4,xdeepseekv3,xdeepseekr1,xsqwen2d53b,pro-128k', 1, '', '2000-01-01 00:00:00', '2025-03-24 20:03:45');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1568, 'LLM_WORKFLOW_FILTER', 'xfyun', 'extractor-parameter', 'bm3,bm3.5,bm4', 1, '', '2000-01-01 00:00:00', '2025-03-24 19:39:29');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1570, 'LLM_WORKFLOW_FILTER', 'xfyun', 'decision-making', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3', 1, '', '2000-01-01 00:00:00', '2025-07-17 11:47:09');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1571, 'LLM_WORKFLOW_FILTER', 'xingchen', 'model_square', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xdeepseekv32,x1,xop3qwen30b,xop3qwen235b,,xdeepseekr1qwen14b,xdeepseekr1qwen32b', 1, '', '2000-01-01 00:00:00', '2025-07-09 14:38:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1572, 'LLM_WORKFLOW_FILTER', 'xfyun', 'spark-llm', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xdeepseekv32,x1,xop3qwen30b,xop3qwen235b,xdeepseekr1qwen14b,xdeepseekr1qwen32b,xsp8f70988f,xqwen257bchat,xop3qwen14b,xop3qwen8b,xdsv3t128k,dsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-06-26 17:49:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1574, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'agent', 'xdeepseekv3,xdeepseekr1,x1,xop3qwen30b,xop3qwen235b,xdsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-06-10 17:11:32');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1576, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'agent', 'xdeepseekv3,xdeepseekr1,x1,xop3qwen30b,xop3qwen235b,xdsv3t128k', 1, '', '2000-01-01 00:00:00', '2025-06-10 17:11:32');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1577, 'LLM_WORKFLOW_MODEL_FILTER', 'think', '思考模型', 'x1,xdeepseekr1,xop3qwen30b,xop3qwen235b', 1, '', '2000-01-01 00:00:00', '2025-04-29 09:46:35');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1578, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Logic', '{\n    \"aliasName\": \"Agent Intelligent Decision\",\n    \"idType\": \"agent\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"\",\n                \"customParameterType\": \"deepseekr1\",\n                \"name\": \"REASONING_CONTENT\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"Model reasoning process\",\n                    \"type\": \"string\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"nameErrMsg\": \"\",\n                \"schema\":\n                {\n                    \"default\": \"\",\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"input\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"智能体节点\",\n            \"nodeType\": \"Agent节点\"\n        },\n        \"nodeParam\":\n        {\n            \"appId\": \"\",\n            \"serviceId\": \"xdeepseekv3\",\n            \"enableChatHistoryV2\":\n            {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"modelConfig\":\n            {\n                \"domain\": \"xdeepseekv3\",\n                \"api\": \"wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat\",\n                \"agentStrategy\": 1\n            },\n            \"instruction\":\n            {\n                \"reasoning\": \"\",\n                \"answer\": \"\",\n                \"query\": \"\"\n            },\n            \"plugin\":\n            {\n                \"tools\":\n                [],\n                \"toolsList\":\n                [],\n                \"mcpServerIds\":\n                [],\n                \"mcpServerUrls\":\n                [],\n                \"workflowIds\":\n                []\n            },\n            \"maxLoopCount\": 10\n        }\n    },\n    \"description\": \"According to task requirements, realize intelligent scheduling of large models by selecting an appropriate tool list\",\n    \"nodeType\": \"Basic Node\"\n}', 1, 'agent', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1580, 'LLM_FILTER', 'summary_agent', '大模型agent过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-12 10:38:48');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1582, 'LLM_FILTER_PRE', 'summary_agent', '大模型agent过滤器', 'xdeepseekr1,xdeepseekv3,x1,xop3qwen30b,xop3qwen235b,bm4', 1, 'bm3,bm3.5,bm4,pro-128k,xqwen257bchat,xqwen72bchat,xqwen257bchat,xsparkprox,xdeepseekr1,xdeepseekv3', '2000-01-01 00:00:00', '2025-05-21 15:34:23');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1583, 'TAG', 'TOOL_TAGS_V2', 'Plugin', NULL, 1, '1537', '2025-04-01 17:51:32', '2025-07-28 10:38:59');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1585, 'TAG', 'TOOL_TAGS_V2', '文档处理', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1587, 'TAG', 'TOOL_TAGS_V2', '信息检索', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1589, 'TAG', 'TOOL_TAGS_V2', '实用工具', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1591, 'TAG', 'TOOL_TAGS_V2', '生活娱乐', NULL, 0, NULL, '2025-04-01 17:51:32', '2025-04-24 20:52:33');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1593, 'TAG', 'TOOL_TAGS_V2', 'MCP Tools', NULL, 1, '', '2025-04-01 17:51:32', '2025-07-31 11:45:28');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1595, 'LLM_WORKFLOW_FILTER_PRE', 'xingchen', 'model_square', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,xopqwenqwq32b,xdeepseekv32,x1,xop3qwen30b,xop3qwen235b', 1, '', '2000-01-01 00:00:00', '2025-04-29 09:44:50');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1597, 'LLM_WORKFLOW_FILTER', 'self-model', '控制自定义模型适配节点', 'spark-llm,decision-making', 1, '', '2000-01-01 00:00:00', '2025-06-05 16:31:53');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1599, 'MULTI_ROUNDS_ALIAS_NAME', 'MUTI_ROUNDS_ALIAS_NAME', '多轮对话支持节点', 'decision-making,spark-llm,agent', 1, '', '2000-01-01 00:00:00', '2025-07-23 15:32:21');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1601, 'MODEL_SECRET_KEY', 'public_key', '公钥', 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAh3iFD+BIGlCY083ItUwJFscMyept2dVl3Zs7/S6V+NnreiUJtjkAsok++eL5BYr9Jz5KULnpQv47tPhqAJd+xxzWZRfNVABHnox61GWlqqgWogbcPZWP/rzGt6c2jOkgbUVdCU7gc+EfKKZ5Fq99A5c6vDQi5u9GozElf2VnLKrH+u0tRpmrQDNSSfW0ifxUNGTvat6cJOIGRC4iUqdI+S3d3BSJEZ9VOAuAs1xmLTZciVkmSM+/bCEfdhChAh1wfpBMOb8Lu2JUXf3tfjZtNOXWRRw70NQu9Xmn3RE0ajZDODLg+xqJ3AR3fgAhunHT8W6d/PVHSM1cFUFap4P4IQIDAQAB', 1, '', '2000-01-01 00:00:00', '2025-04-15 11:57:22');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1603, 'MODEL_SECRET_KEY', 'private_key', '私钥', 'MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCHeIUP4EgaUJjTzci1TAkWxwzJ6m3Z1WXdmzv9LpX42et6JQm2OQCyiT754vkFiv0nPkpQuelC/ju0+GoAl37HHNZlF81UAEeejHrUZaWqqBaiBtw9lY/+vMa3pzaM6SBtRV0JTuBz4R8opnkWr30Dlzq8NCLm70ajMSV/ZWcsqsf67S1GmatAM1JJ9bSJ/FQ0ZO9q3pwk4gZELiJSp0j5Ld3cFIkRn1U4C4CzXGYtNlyJWSZIz79sIR92EKECHXB+kEw5vwu7YlRd/e1+Nm005dZFHDvQ1C71eafdETRqNkM4MuD7GoncBHd+ACG6cdPxbp389UdIzVwVQVqng/ghAgMBAAECggEAVF/Z8ENuZQVhyjlXEqPi3U7oRjI+bPgeU+HFgTEssyt3IEJFRDtIleopURXup2cjuPdw7cp83/7cTSCTVP8GNRle5uPmPLVX5gX00qjkf9/lCNFhBvJKFwyYb/YzYZwpWCVlhtCbt1C1SWo17M0r/bqJGIMYYeERi76mbixIEGb60mCOPyj3tZfTCXzeSaZqgEV+9SjpgBcUj0/NSn1nxOZ8SeESQHrkz+ZfUZ/VDxdICW2Hy0hGJfaR9VZHGlVnabbtreUni5JDMf7o6xSPKvThp2rIIQd4H1PLRMFeWprigQ+6vfxeMHnyS5ggag5wGclFAargqAXq0WFO3xxoSQKBgQDbAt+T0jjHvv6d/924JiJf9awoGQ6Xjbu2z2xVNHg32Hew+u+0CiRsmo1nMMS//JxieNjSRWT6SJ482xAXgmGsdBKrSf+G5s3RpBCLDOYAvx67XmxB86CCpXVwomejGCZhdD4Vm2sB68ansbW1/y2Z2UHAG6wbsC7llzrxXvwAbwKBgQCeWbVDqLCSbsHgkn7LMPVCozH0GICQN92d5oyc8veZFa8uXq7fVIpELXv/S1TDVcpwEbIUnQycFRgj/si3QPZyIAAsKf6tx8MKy+BYm81eJqc0AuUc8wrmSJdcEOBDSaZvNMVX+bmqQItDTSJ+rv5fC8+zhv+gNRH+4cuOPxC4bwKBgA4/2ZwciWU1oAtXom1gzcvAiDrzpmdl6VizljDVAR1hECiLqxzjrAsE4z5bhfGX1fTyN+k2aqN+Jg1/k0R0TzaRNsW+QsncKngBXLIvXKefx7gZJKIF3+OgMEvrxSJvZ8/faEqvmf6+AGbYwSHeQHFKGWUOZ9xFUkfN1x/tNigxAoGAXtLffhWtLvMOPHndXbYCmJX7Wu21Ryd9GYou1+mTJWPb1Iu0cl5AshT+tOEacCKWqEegeUGWhH0JSLzQ2xQWwD6ze77mGJCQFo4B2W3rLB8/byDwrEZKV55OrT4Z3ZFkDiHurwEHEpG2E2ZEatJF1wrOpPYJa5l8HkJ+T78qNxcCgYBZbJJFCL7buF5ZO6dhZVMSLlERL0q5XKbCWXe/987g2fMfi7t6UrQAQ6zxvqBFrapodcsGjxbeXerJzNHqkQ4fySHZ8qeiwSlx8tCbBiO0PR7pY4mlXratJjpHvQbs1yXUcGZ3obyuK1Oe+sa+jYJC54UVz08g2+nGiQGho5x1FQ==', 1, '', '2000-01-01 00:00:00', '2025-04-15 11:57:22');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1605, 'SPARK_PRO_QR_CODE', 'qr', '二维码', 'https://oss-beijing-m8.openstorage.cn/SparkBot/test4/weichat_qr.jpeg', 1, NULL, '2025-04-01 17:51:32', '2025-06-05 17:07:41');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1607, 'MCP_MODEL_API_REFLECT', 'mcp', 'xop3qwen30b', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:10');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1609, 'MCP_MODEL_API_REFLECT', 'mcp', 'xop3qwen235b', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:54:11');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1611, 'LLM_WORKFLOW_MODEL_FILTER', 'multiMode', '多模态模型', 'image_understandingv3,image_understanding', 1, '', '2000-01-01 00:00:00', '2025-03-12 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1613, 'PERSONAL_MODEL', '20000001', 'imagev3', '{\n    \"llmSource\": 1,\n    \"llmId\": 10000005,\n    \"name\": \"图像理解V3\",\n    \"patchId\": \"0\",\n    \"domain\": \"imagev3\",\n    \"serviceId\": \"image_understandingv3\",\n    \"status\": 1,\n    \"info\": \"{\\\"conc\\\":2,\\\"domain\\\":\\\"generalv3.5\\\",\\\"expireTs\\\":\\\"2025-05-31\\\",\\\"qps\\\":2,\\\"tokensPreDay\\\":1000,\\\"tokensTotal\\\":1000,\\\"llmServiceId\\\":\\\"bm3.5\\\"}\"\n    \"info\": \"\",\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/aicloud/llm/resource/image/model/icon_iflyspark_96.png\",\n    \"tag\":\n    [],\n    \"url\": \"wss://spark-api.cn-huabei-1.xf-yun.com/v2.1/image\",\n    \"modelId\": 0,\n    \"isThink\":false,\n    \"multiMode\":true\n}', 1, '', '2000-01-01 00:00:00', '2025-05-08 15:04:22');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1615, 'WORKFLOW_KNOWLEDGE_PRO_STRATEGY', 'knowledgeProStrategy', 'Agentic RAG', 'Applicable to scenarios involving complex problems, proficient in breaking down complex issues into multiple sub-problems for retrieval.', 1, '1', '2000-01-01 00:00:00', '2025-07-23 15:32:56');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1617, 'WORKFLOW_KNOWLEDGE_PRO_STRATEGY', 'knowledgeProStrategy', 'Long RAG', 'Applicable to tasks involving understanding and generation of long document content.', 1, '2', '2000-01-01 00:00:00', '2025-07-23 15:33:13');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1621, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'knowledge-pro-base', 'xdeepseekv3', 1, '', '2000-01-01 00:00:00', '2025-05-21 15:11:12');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1623, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'knowledge-pro-base', 'xdeepseekv3', 1, '', '2000-01-01 00:00:00', '2025-05-21 15:11:12');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1627, 'LLM_WORKFLOW_FILTER_PRE', 'iflyaicloud', 'question-answer', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xopqwenqwq32b,xdeepseekv32,x1,deepseek-ollama', 1, '', '2000-01-01 00:00:00', '2025-05-21 10:30:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1629, 'LLM_WORKFLOW_FILTER_PRE', 'xfyun', 'question-answer', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xopqwenqwq32b,xdeepseekv32,x1,deepseek-ollama', 1, '', '2000-01-01 00:00:00', '2025-05-21 10:30:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1631, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'question-answer', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xopqwenqwq32b,xdeepseekv32,x1,deepseek-ollama', 1, '', '2000-01-01 00:00:00', '2025-05-21 10:30:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1633, 'LLM_WORKFLOW_FILTER', 'xfyun', 'question-answer', 'bm3,bm3.5,bm4,pro-128k,xgemma29bit,xaipersonality,xdeepseekv3,xdeepseekr1,image_understanding,image_understandingv3,xopqwenqwq32b,xdeepseekv32,x1,deepseek-ollama', 1, '', '2000-01-01 00:00:00', '2025-05-21 10:30:36');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1635, 'LLM_WORKFLOW_FILTER', 'xfyun', 'knowledge-pro-base', 'xdeepseekv3', 1, '', '2000-01-01 00:00:00', '2025-05-16 15:10:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1637, 'LLM_WORKFLOW_FILTER', 'iflyaicloud', 'knowledge-pro-base', 'xdeepseekv3', 1, '', '2000-01-01 00:00:00', '2025-05-16 15:10:15');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1639, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n    \"aliasName\": \"Knowledge Base Pro\",\n    \"idType\": \"knowledge-pro-base\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"52f0819d-e403-43e1-85d3-50519ccfcbcf\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                },\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            },\n            {\n                \"id\": \"87247b70-f05c-4125-a416-e2c41be2e1c1\",\n                \"name\": \"result\",\n                \"schema\":\n                {\n                    \"type\": \"array-object\",\n                    \"default\": \"\",\n                    \"properties\":\n                    [\n                        {\n                            \"id\": \"a9db3a72-abb2-4512-a598-13b8294fce60\",\n                            \"name\": \"source_id\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": false,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"c1711905-9f7e-4408-918e-33d57d39f9bc\",\n                            \"name\": \"chunk\",\n                            \"type\": \"array-object\",\n                            \"default\": \"\",\n                            \"required\": false,\n                            \"nameErrMsg\": \"\",\n                            \"properties\":\n                            [\n                                {\n                                    \"id\": \"b8b50110-2abc-4732-9c96-6f3b7bad9259\",\n                                    \"name\": \"chunk_context\",\n                                    \"type\": \"string\",\n                                    \"default\": \"\",\n                                    \"required\": false,\n                                    \"nameErrMsg\": \"\"\n                                },\n                                {\n                                    \"id\": \"95ffea3c-4008-4df8-84a8-013079e72276\",\n                                    \"name\": \"score\",\n                                    \"type\": \"number\",\n                                    \"default\": \"\",\n                                    \"required\": false,\n                                    \"nameErrMsg\": \"\",\n                                    \"properties\":\n                                    []\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"query\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"知识库 Pro\",\n            \"nodeType\": \"工具\"\n        },\n        \"nodeParam\":\n        {\n            \"repoTopK\": 3,\n            \"topK\": 4,\n            \"repoIds\":\n            [],\n            \"repoList\":\n            [],\n            \"ragType\": 1,\n            \"url\": \"https://maas-api.cn-huabei-1.xf-yun.com/v2\",\n            \"domain\": \"xdeepseekv3\",\n            \"temperature\": 0.5,\n            \"maxTokens\": 2048,\n            \"model\": \"xdeepseekv3\",\n            \"llmId\": 141,\n            \"serviceId\": \"xdeepseekv3\",\n            \"answerRole\": \"\",\n            \"repoType\": 1\n        }\n    },\n    \"description\": \"Invoke the knowledge base through intelligent strategy, supporting designated knowledge bases for retrieval and summarization response.\",\n    \"nodeType\": \"Basic Node\"\n}', 1, '知识库pro节点', '2000-01-01 00:00:00', '2025-07-25 16:58:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1641, 'mingduan', 'x1', 'x1', 'https://spark-api-open.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-05-21 14:50:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1643, 'mingduan', 'bm4', 'bm4', 'https://spark-api-open.xf-yun.com/v1', 1, '', '2000-01-01 00:00:00', '2025-05-21 14:50:16');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1645, 'mingduan', 'AK:SK', '', 'x1,bm4', 1, 'https://spark-api-open.xf-yun.com/v2', '2000-01-01 00:00:00', '2025-05-21 15:42:44');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1647, 'MODEL_URL_CONFIG', 'Agent节点', 'https://maas-api.cn-huabei-1.xf-yun.com/v2', 'xdeepseekv3,xdeepseekr1,xop3qwen30b,xop3qwen235b', 1, '', '2000-01-01 00:00:00', '2025-05-29 15:35:31');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1649, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Basic Node', '{\n    \"aliasName\": \"Knowledge Base Pro\",\n    \"idType\": \"knowledge-pro-base\",\n    \"data\":\n    {\n        \"outputs\":\n        [\n            {\n                \"id\": \"52f0819d-e403-43e1-85d3-50519ccfcbcf\",\n                \"name\": \"output\",\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                },\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            },\n            {\n                \"id\": \"87247b70-f05c-4125-a416-e2c41be2e1c1\",\n                \"name\": \"result\",\n                \"schema\":\n                {\n                    \"type\": \"array-object\",\n                    \"default\": \"\",\n                    \"properties\":\n                    [\n                        {\n                            \"id\": \"a9db3a72-abb2-4512-a598-13b8294fce60\",\n                            \"name\": \"source_id\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": false,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"c1711905-9f7e-4408-918e-33d57d39f9bc\",\n                            \"name\": \"chunk\",\n                            \"type\": \"array-object\",\n                            \"default\": \"\",\n                            \"required\": false,\n                            \"nameErrMsg\": \"\",\n                            \"properties\":\n                            [\n                                {\n                                    \"id\": \"b8b50110-2abc-4732-9c96-6f3b7bad9259\",\n                                    \"name\": \"chunk_context\",\n                                    \"type\": \"string\",\n                                    \"default\": \"\",\n                                    \"required\": false,\n                                    \"nameErrMsg\": \"\"\n                                },\n                                {\n                                    \"id\": \"95ffea3c-4008-4df8-84a8-013079e72276\",\n                                    \"name\": \"score\",\n                                    \"type\": \"number\",\n                                    \"default\": \"\",\n                                    \"required\": false,\n                                    \"nameErrMsg\": \"\",\n                                    \"properties\":\n                                    []\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"required\": false,\n                \"nameErrMsg\": \"\"\n            }\n        ],\n        \"references\":\n        [],\n        \"allowInputReference\": true,\n        \"inputs\":\n        [\n            {\n                \"schema\":\n                {\n                    \"type\": \"string\",\n                    \"value\":\n                    {\n                        \"type\": \"ref\",\n                        \"content\":\n                        {}\n                    }\n                },\n                \"name\": \"query\",\n                \"id\": \"\"\n            }\n        ],\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\",\n        \"allowOutputReference\": true,\n        \"nodeMeta\":\n        {\n            \"aliasName\": \"知识库 Pro\",\n            \"nodeType\": \"工具\"\n        },\n        \"nodeParam\":\n        {\n            \"repoTopK\": 3,\n            \"topK\": 4,\n            \"repoIds\":\n            [],\n            \"repoList\":\n            [],\n            \"ragType\": 1,\n            \"url\": \"https://maas-api.cn-huabei-1.xf-yun.com/v2\",\n            \"domain\": \"xdeepseekv3\",\n            \"temperature\": 0.5,\n            \"maxTokens\": 2048,\n            \"model\": \"xdeepseekv3\",\n            \"llmId\": 141,\n            \"serviceId\": \"xdeepseekv3\",\n            \"answerRole\": \"\",\n            \"repoType\": 1\n        }\n    },\n    \"description\": \"Invoke the knowledge base through intelligent strategy, supporting designated knowledge bases for retrieval and summarization response.\",\n    \"nodeType\": \"Basic Node\"\n}', 1, '知识库pro节点', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1681, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '固定节点', '{\n  \"idType\": \"node-start\",\n  \"type\": \"Start Node\",\n  \"position\": {\n    \"x\": 100,\n    \"y\": 300\n  },\n  \"data\": {\n    \"label\": \"Start\",\n    \"description\": \"The starting node of the workflow, used to define the business variable information required for process invocation.\",\n    \"nodeMeta\": {\n      \"nodeType\": \"Basic Node\",\n      \"aliasName\": \"Start Node\"\n    },\n    \"inputs\": [],\n    \"outputs\": [\n      {\n        \"id\": \"\",\n        \"name\": \"AGENT_USER_INPUT\",\n        \"deleteDisabled\": true,\n        \"required\": true,\n        \"schema\": {\n          \"type\": \"string\",\n          \"default\": \"User input of the current conversation round\"\n        }\n      }\n    ],\n    \"nodeParam\": {},\n    \"allowInputReference\": false,\n    \"allowOutputReference\": true,\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\"\n  }\n}', 1, '开始节点', '2000-01-01 00:00:00', '2025-07-23 15:36:49');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1683, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '固定节点', '{\n  \"idType\": \"node-end\",\n  \"type\": \"End Node\",\n  \"position\": {\n    \"x\": 1000,\n    \"y\": 300\n  },\n  \"data\": {\n    \"label\": \"End\",\n    \"description\": \"The end node of the workflow, used to output the final result after the workflow execution.\",\n    \"nodeMeta\": {\n      \"nodeType\": \"Basic Node\",\n      \"aliasName\": \"End Node\"\n    },\n    \"inputs\": [\n      {\n        \"id\": \"\",\n        \"name\": \"output\",\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        }\n      }\n    ],\n    \"outputs\": [],\n    \"nodeParam\": {\n      \"outputMode\": 1,\n      \"template\": \"\",\n      \"streamOutput\": true\n    },\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"allowOutputReference\": false,\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\"\n  }\n}', 1, '结束节点', '2000-01-01 00:00:00', '2025-07-23 15:36:49');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1685, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '基础节点', '{\n    \"idType\": \"spark-llm\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Large Model\",\n    \"description\": \"Based on the input prompt, the selected large language model will be invoked to respond accordingly.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Large Model\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"template\": \"\",\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"respFormat\": 0,\n            \"llmId\": 110,\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"enableChatHistoryV2\": {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            }\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/largeModelIcon.png\"\n    }\n}', 1, '大模型', '2000-01-01 00:00:00', '2025-07-23 15:36:49');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1687, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '基础节点', '{\n    \"idType\": \"ifly-code\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Code\",\n    \"description\": \"Provides code development capability for developers, currently only supports Python language. Allows parameters to be passed in using defined variables, and the return statement is used to output the result of the function.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Tool\",\n            \"aliasName\": \"Code\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"key0\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key1\",\n                \"schema\": {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"key2\",\n                \"schema\": {\n                    \"type\": \"object\",\n                    \"default\": \"\",\n                    \"properties\": [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"key21\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                }\n            }\n        ],\n        \"nodeParam\": {\n            \"code\": \"def main(input):\\n    ret = {\\n        \\\"key0\\\": input + \\\"hello\\\",\\n        \\\"key1\\\": [\\\"hello\\\", \\\"world\\\"],\\n        \\\"key2\\\": {\\\"key21\\\": \\\"hi\\\"}\\n    }\\n    return ret\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/codeIcon.png\"\n    }\n}', 1, '代码', '2000-01-01 00:00:00', '2025-07-23 15:36:49');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1689, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '基础节点', '{\n    \"idType\": \"knowledge-base\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Knowledge Base\",\n    \"description\": \"Calls the knowledge base and allows specifying a knowledge repository for information retrieval and response.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Tool\",\n            \"aliasName\": \"Knowledge Base\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"query\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"results\",\n                \"schema\": {\n                    \"type\": \"array-object\",\n                    \"properties\": [\n                        {\n                            \"id\": \"\",\n                            \"name\": \"score\",\n                            \"type\": \"number\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"docId\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"title\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"content\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"context\",\n                            \"type\": \"string\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        },\n                        {\n                            \"id\": \"\",\n                            \"name\": \"references\",\n                            \"type\": \"object\",\n                            \"default\": \"\",\n                            \"required\": true,\n                            \"nameErrMsg\": \"\"\n                        }\n                    ]\n                },\n                \"required\": true,\n                \"nameErrMsg\": \"\"\n            }\n        ],\n        \"nodeParam\": {\n            \"repoId\": [],\n            \"repoList\": [],\n            \"topN\": 3\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/knowledgeIcon.png\"\n    }\n}', 1, '知识库', '2000-01-01 00:00:00', '2025-07-23 15:36:49');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1691, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '工具', '{\n    \"idType\": \"plugin\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Tool\",\n    \"description\": \"Quickly acquire skills by integrating external tools to meet user needs\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Tool\",\n            \"aliasName\": \"Tool\"\n        },\n        \"inputs\": [],\n        \"outputs\": [],\n        \"nodeParam\": {\n            \"appId\": \"4eea957b\",\n            \"code\": \"\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/tool-icon.png\"\n    }\n}', 1, '工具', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1693, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '工具', '{\n    \"idType\": \"flow\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Workflow\",\n    \"description\": \"Quickly integrate published workflows for efficient reuse of existing capabilities.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Tool\",\n            \"aliasName\": \"Workflow\"\n        },\n        \"inputs\": [],\n        \"outputs\": [],\n        \"nodeParam\": {\n            \"appId\": \"\",\n            \"flowId\": \"\",\n            \"uid\": \"\"\n        },\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/flow-icon.png\"\n    }\n}', 1, '工作流', '2000-01-01 00:00:00', '2025-07-23 15:36:49');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1695, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\n    \"idType\": \"decision-making\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Decision\",\n    \"description\": \"Determine the subsequent logic path based on input parameters and the specified intents.\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Decision\"\n        },\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"enableChatHistoryV2\": {\n                \"isEnabled\": false,\n                \"rounds\": 1\n            },\n            \"uid\": \"2171\",\n            \"intentChains\": [\n                {\n                    \"intentType\": 2,\n                    \"name\": \"\",\n                    \"description\": \"\",\n                    \"id\": \"intent-one-of::4724514d-ffc8-4412-bf7f-13cc3375110d\"\n                },\n                {\n                    \"intentType\": 1,\n                    \"name\": \"default\",\n                    \"description\": \"Default intent\",\n                    \"id\": \"intent-one-of::506841e4-3f6c-40b1-a804-dc5ffe723b34\"\n                }\n            ],\n            \"reasonMode\": 1,\n            \"model\": \"spark\",\n            \"useFunctionCall\": true,\n            \"serviceId\": \"bm4\",\n            \"promptPrefix\": \"\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"Query\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"class_name\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/designMakeIcon.png\"\n    }\n}', 1, '决策', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1697, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\n    \"idType\": \"if-else\",\n    \"nodeType\": \"Branch\",\n    \"aliasName\": \"Branch\",\n    \"description\": \"Determine the branch path based on the defined conditions\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Branch\",\n            \"aliasName\": \"Branch\"\n        },\n        \"nodeParam\": {\n            \"cases\": [\n                {\n                    \"id\": \"branch_one_of::\",\n                    \"level\": 1,\n                    \"logicalOperator\": \"and\",\n                    \"conditions\": [\n                        {\n                            \"id\": \"\",\n                            \"leftVarIndex\": null,\n                            \"rightVarIndex\": null,\n                            \"compareOperator\": null\n                        }\n                    ]\n                },\n                {\n                    \"id\": \"branch_one_of::\",\n                    \"level\": 999,\n                    \"logicalOperator\": \"and\",\n                    \"conditions\": []\n                }\n            ]\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {\n                            \"nodeId\": \"\",\n                            \"name\": \"\"\n                        }\n                    }\n                }\n            },\n            {\n                \"id\": \"\",\n                \"name\": \"input1\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {\n                            \"nodeId\": \"\",\n                            \"name\": \"\"\n                        }\n                    }\n                }\n            }\n        ],\n        \"outputs\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/if-else-node-icon.png\"\n    }\n}', 1, '分支器', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1699, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\n    \"idType\": \"iteration\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Iteration\",\n    \"description\": \"This node is used to handle loop logic and supports only one level of nesting\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Iteration\"\n        },\n        \"nodeParam\": {},\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"array-string\",\n                    \"default\": \"\"\n                }\n            }\n        ],\n        \"iteratorNodes\": [],\n        \"iteratorEdges\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/iteration-icon.png\"\n    }\n}', 1, '迭代', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1701, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '转换', '{\n    \"idType\": \"node-variable\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Variable Storage\",\n    \"description\": \"Allows setting multiple variables for long-term data storage, which remains effective and updates persistently\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Variable Storage\"\n        },\n        \"nodeParam\": {\n            \"method\": \"set\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-memory-icon.png\"\n    }\n}', 1, '变量存储器', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1703, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '转换', '{\n    \"idType\": \"extractor-parameter\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Variable Extractor\",\n    \"description\": \"Extracts natural language content from the output of the previous node based on variable extraction descriptions\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Variable Extractor\"\n        },\n        \"nodeParam\": {\n            \"maxTokens\": 2048,\n            \"temperature\": 0.5,\n            \"topK\": 4,\n            \"auditing\": \"default\",\n            \"domain\": \"4.0Ultra\",\n            \"llmId\": 110,\n            \"model\": \"spark\",\n            \"serviceId\": \"bm4\",\n            \"patchId\": \"0\",\n            \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n            \"appId\": \"d1590f30\",\n            \"uid\": \"2171\",\n            \"reasonMode\": 1\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"description\": \"\"\n                },\n                \"required\": true\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/variable-extractor-icon.png\"\n    }\n}', 1, '变量提取器', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1705, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '转换', '{\n    \"idType\": \"text-joiner\",\n    \"nodeType\": \"Tool\",\n    \"aliasName\": \"Text Processing Node\",\n    \"description\": \"Used to process multiple string variables according to specified formatting rules\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Tool\",\n            \"aliasName\": \"Text Joiner\"\n        },\n        \"nodeParam\": {\n            \"prompt\": \"\"\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output\",\n                \"schema\": {\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": true,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/text-splicing-icon.png\"\n    }\n}', 1, '文本处理节点', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1707, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '其他', '{\n    \"idType\": \"message\",\n    \"nodeType\": \"Basic Node\",\n    \"aliasName\": \"Message\",\n    \"description\": \"Used to output intermediate results during workflow execution\",\n    \"data\": {\n        \"nodeMeta\": {\n            \"nodeType\": \"Basic Node\",\n            \"aliasName\": \"Message\"\n        },\n        \"nodeParam\": {\n            \"template\": \"\",\n            \"startFrameEnabled\": false\n        },\n        \"inputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"input\",\n                \"schema\": {\n                    \"type\": \"string\",\n                    \"value\": {\n                        \"type\": \"ref\",\n                        \"content\": {}\n                    }\n                }\n            }\n        ],\n        \"outputs\": [\n            {\n                \"id\": \"\",\n                \"name\": \"output_m\",\n                \"schema\": {\n                    \"type\": \"string\"\n                }\n            }\n        ],\n        \"references\": [],\n        \"allowInputReference\": true,\n        \"allowOutputReference\": false,\n        \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/message-node-icon.png\"\n    }\n}', 1, '消息', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1709, 'WORKFLOW_NODE_TEMPLATE_INNER_PRE', '1,2', '逻辑', '{\n  \"aliasName\": \"Agent Intelligent Decision\",\n  \"idType\": \"agent\",\n  \"data\": {\n    \"outputs\": [\n      {\n        \"id\": \"\",\n        \"customParameterType\": \"deepseekr1\",\n        \"name\": \"REASONING_CONTENT\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"Model reasoning process\",\n          \"type\": \"string\"\n        }\n      },\n      {\n        \"id\": \"\",\n        \"name\": \"output\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"\",\n          \"type\": \"string\"\n        }\n      }\n    ],\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"inputs\": [\n      {\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        },\n        \"name\": \"input\",\n        \"id\": \"\"\n      }\n    ],\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotProd/icon/common/agent.png\",\n    \"allowOutputReference\": true,\n    \"nodeMeta\": {\n      \"aliasName\": \"Agent Node\",\n      \"nodeType\": \"Agent Node\"\n    },\n    \"nodeParam\": {\n      \"appId\": \"\",\n      \"serviceId\": \"xdeepseekv3\",\n      \"enableChatHistoryV2\": {\n        \"isEnabled\": false,\n        \"rounds\": 1\n      },\n      \"modelConfig\": {\n        \"domain\": \"xdeepseekv3\",\n        \"api\": \"wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat\",\n        \"agentStrategy\": 1\n      },\n      \"instruction\": {\n        \"reasoning\": \"\",\n        \"answer\": \"\",\n        \"query\": \"\"\n      },\n      \"plugin\": {\n        \"tools\": [],\n        \"toolsList\": [],\n        \"mcpServerIds\": [],\n        \"mcpServerUrls\": [],\n        \"workflowIds\": []\n      },\n      \"maxLoopCount\": 10\n    }\n  },\n  \"description\": \"According to task requirements, realize intelligent scheduling of large models by selecting an appropriate tool list\",\n  \"nodeType\": \"Basic Node\"\n}', 1, 'agent', '2000-01-01 00:00:00', '2025-07-23 15:45:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1715, 'SELF_MODEL_COMMON_CONFIG', 'config', '自定义模型公共配置', '{\n    \"config\":\n    [\n        {\n            \"standard\": true,\n            \"constraintType\": \"range\",\n            \"default\": 2048,\n            \"constraintContent\":\n            [\n                {\n                    \"name\": 1\n                },\n                {\n                    \"name\": 8192\n                }\n            ],\n            \"name\": \"最大回复长度\",\n            \"fieldType\": \"int\",\n            \"initialValue\": 2048,\n            \"key\": \"maxTokens\",\n            \"required\": true\n        },\n        {\n            \"standard\": true,\n            \"constraintContent\":\n            [\n                {\n                    \"name\": 0\n                },\n                {\n                    \"name\": 1\n                }\n            ],\n            \"precision\": 0.1,\n            \"required\": true,\n            \"constraintType\": \"range\",\n            \"default\": 0.5,\n            \"name\": \"核采样阈值\",\n            \"fieldType\": \"float\",\n            \"initialValue\": 0.5,\n            \"key\": \"temperature\"\n        },\n        {\n            \"standard\": true,\n            \"constraintType\": \"range\",\n            \"default\": 4,\n            \"constraintContent\":\n            [\n                {\n                    \"name\": 1\n                },\n                {\n                    \"name\": 6\n                }\n            ],\n            \"name\": \"生成多样性\",\n            \"fieldType\": \"int\",\n            \"initialValue\": 4,\n            \"key\": \"topK\",\n            \"required\": true\n        }\n    ]\n}', 1, '', '2000-01-01 00:00:00', '2025-06-05 19:15:55');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1717, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n  \"aliasName\": \"Question and Answer Node\",\n  \"idType\": \"question-answer\",\n  \"data\": {\n    \"outputs\": [\n      {\n        \"schema\": {\n          \"default\": \"\",\n          \"type\": \"string\",\n          \"description\": \"The question content of this node\"\n        },\n        \"name\": \"query\",\n        \"id\": \"\",\n        \"required\": true\n      },\n      {\n        \"schema\": {\n          \"default\": \"\",\n          \"type\": \"string\",\n          \"description\": \"User reply content\"\n        },\n        \"name\": \"content\",\n        \"id\": \"\",\n        \"required\": true\n      }\n    ],\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"inputs\": [\n      {\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        },\n        \"name\": \"input\",\n        \"id\": \"\"\n      }\n    ],\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBot/test4/answer-new2.png\",\n    \"allowOutputReference\": true,\n    \"nodeMeta\": {\n            \"aliasName\": \"问答节点\",\n            \"nodeType\": \"基础节点\"\n        },\n    \"nodeParam\": {\n      \"question\": \"\",\n      \"timeout\": 3,\n      \"needReply\": false,\n      \"answerType\": \"direct\",\n      \"directAnswer\": {\n        \"handleResponse\": false,\n        \"maxRetryCounts\": 2\n      },\n      \"optionAnswer\": [\n        {\n          \"id\": \"option-one-of::01a35034-8e7a-4a84-83ee-c51d4cbe2660\",\n          \"name\": \"A\",\n          \"type\": 2,\n          \"content\": \"\",\n          \"content_type\": \"string\"\n        },\n        {\n          \"id\": \"option-one-of::1df8b2ac-c228-4195-8978-54f87b1bdbb9\",\n          \"name\": \"B\",\n          \"type\": 2,\n          \"content\": \"\",\n          \"content_type\": \"string\"\n        },\n        {\n          \"id\": \"option-one-of::646527fa-a9eb-4216-a324-95fc5601d2bf\",\n          \"name\": \"default\",\n          \"type\": 1,\n          \"content\": \"\",\n          \"content_type\": \"string\"\n        }\n      ],\n      \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n      \"domain\": \"4.0Ultra\",\n      \"appId\": \"d1590f30\",\n      \"maxTokens\": 2048,\n      \"temperature\": 0.5,\n      \"topK\": 4,\n      \"model\": \"spark\",\n      \"llmId\": 110,\n      \"serviceId\": \"bm4\"\n    }\n  },\n  \"description\": \"This node supports asking questions to the user, receiving user responses, and outputting the reply content and extracted information\",\n  \"nodeType\": \"Basic Node\"\n}', 1, '问答节点', '2000-01-01 00:00:00', '2025-07-25 16:58:05');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1719, 'SPARK_PRO_QR_CODE', 'qr_feishu', '飞书二维码', 'https://oss-beijing-m8.openstorage.cn/SparkBot/test4/feishu_qr.jpeg', 1, NULL, '2025-04-01 17:51:32', '2025-06-05 16:46:35');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1731, 'MCP_MODEL_API_REFLECT', 'mcp', 'x1', 'https://spark-api-open.xf-yun.com/v2', 1, '', '2000-01-01 00:00:00', '2025-06-10 17:52:48');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1735, 'IP_BLACK_LIST', 'ip_balck_list', 'ip黑名单', '0.0.0.0,127.0.0.1,localhost', 1, NULL, '2022-06-10 00:00:00', '2025-06-10 10:49:44');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1737, 'NETWORK_SEGMENT_BLACK_LIST', 'network_segment_balck_list', '网段黑名单', '192.168.0.0/16,172.16.0.0/12,10.0.0.0/8,100.64.0.0/10', 1, NULL, '2022-06-10 00:00:00', '2025-06-10 10:41:51');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1739, 'DOMAIN_BLACK_LIST', 'domain_balck_list', '域名黑名单', 'cloud.iflytek.com,monojson.com,ssrf.security.private,ssrf-prod.security.private', 1, NULL, '2022-06-10 00:00:00', '2025-06-13 10:39:27');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1743, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Basic Node', '{\n  \"aliasName\": \"Question and Answer Node\",\n  \"idType\": \"question-answer\",\n  \"data\": {\n    \"outputs\": [\n      {\n        \"schema\": {\n          \"default\": \"\",\n          \"type\": \"string\",\n          \"description\": \"The question content of this node\"\n        },\n        \"name\": \"query\",\n        \"id\": \"\",\n        \"required\": true\n      },\n      {\n        \"schema\": {\n          \"default\": \"\",\n          \"type\": \"string\",\n          \"description\": \"User reply content\"\n        },\n        \"name\": \"content\",\n        \"id\": \"\",\n        \"required\": true\n      }\n    ],\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"inputs\": [\n      {\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        },\n        \"name\": \"input\",\n        \"id\": \"\"\n      }\n    ],\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBot/test4/answer-new2.png\",\n    \"allowOutputReference\": true,\n    \"nodeMeta\": {\n            \"aliasName\": \"问答节点\",\n            \"nodeType\": \"基础节点\"\n        },\n    \"nodeParam\": {\n      \"question\": \"\",\n      \"timeout\": 3,\n      \"needReply\": false,\n      \"answerType\": \"direct\",\n      \"directAnswer\": {\n        \"handleResponse\": false,\n        \"maxRetryCounts\": 2\n      },\n      \"optionAnswer\": [\n        {\n          \"id\": \"option-one-of::01a35034-8e7a-4a84-83ee-c51d4cbe2660\",\n          \"name\": \"A\",\n          \"type\": 2,\n          \"content\": \"\",\n          \"content_type\": \"string\"\n        },\n        {\n          \"id\": \"option-one-of::1df8b2ac-c228-4195-8978-54f87b1bdbb9\",\n          \"name\": \"B\",\n          \"type\": 2,\n          \"content\": \"\",\n          \"content_type\": \"string\"\n        },\n        {\n          \"id\": \"option-one-of::646527fa-a9eb-4216-a324-95fc5601d2bf\",\n          \"name\": \"default\",\n          \"type\": 1,\n          \"content\": \"\",\n          \"content_type\": \"string\"\n        }\n      ],\n      \"url\": \"wss://spark-api.xf-yun.com/v4.0/chat\",\n      \"domain\": \"4.0Ultra\",\n      \"appId\": \"d1590f30\",\n      \"maxTokens\": 2048,\n      \"temperature\": 0.5,\n      \"topK\": 4,\n      \"model\": \"spark\",\n      \"llmId\": 110,\n      \"serviceId\": \"bm4\"\n    }\n  },\n  \"description\": \"This node supports asking questions to the user, receiving user responses, and outputting the reply content and extracted information\",\n  \"nodeType\": \"Basic Node\"\n}', 1, '问答节点', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1765, 'DEFAULT_SLICE_RULES_CBG', '1', 'CBG默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[256,1024]}', 1, '', '2025-06-18 17:21:37', '2025-06-18 17:21:44');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1767, 'CUSTOM_SLICE_RULES_CBG', '1', 'CBG自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-06-18 17:21:42', '2025-08-14 17:27:21');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1769, 'DEFAULT_SLICE_RULES_SPARK', '1', 'Spark默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-06-18 17:21:41', '2025-06-18 17:21:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1771, 'CUSTOM_SLICE_RULES_SPARK', '1', 'Spark自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-06-18 17:21:43', '2025-06-18 17:21:47');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1773, 'DEFAULT_SLICE_RULES_AIUI', '1', 'AIUI默认切片规则', '{\"type\":0,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-07-03 15:18:40', '2025-07-03 15:18:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1775, 'CUSTOM_SLICE_RULES_AIUI', '1', 'AIUI自定义切片模板', '{\"type\":1,\"seperator\":[\"\\n\"],\"lengthRange\":[16,1024]}', 1, '', '2025-07-03 15:18:40', '2025-07-03 15:18:40');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1777, 'WORKFLOW_INIT_DATA', 'workflow', '工作流初始化data', '{\n    \"nodes\":\n    [\n        {\n            \"data\":\n            {\n                \"allowInputReference\": false,\n                \"allowOutputReference\": true,\n                \"description\": \"The start node of the workflow, used to define the business variables required for process invocation.\",\n                \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/start-node-icon.png\",\n                \"inputs\":\n                [],\n                \"label\": \"Start\",\n                \"nodeMeta\":\n                {\n                    \"aliasName\": \"开始节点\",\n                    \"nodeType\": \"基础节点\"\n                },\n                \"nodeParam\":\n                {},\n                \"outputs\":\n                [\n                    {\n                        \"deleteDisabled\": true,\n                        \"id\": \"0918514b-72a8-4646-8dd9-ff4a8fc26d44\",\n                        \"name\": \"AGENT_USER_INPUT\",\n                        \"required\": true,\n                        \"schema\":\n                        {\n                            \"default\": \"User\'s input in the current round of conversation\",\n                            \"type\": \"string\"\n                        }\n                    }\n                ],\n                \"status\": \"\",\n                \"updatable\": false\n            },\n            \"dragging\": false,\n            \"height\": 256,\n            \"id\": \"node-start::d61b0f71-87ee-475e-93ba-f1607f0ce783\",\n            \"position\":\n            {\n                \"x\": -25.109019607843152,\n                \"y\": 521.7086666666667\n            },\n            \"positionAbsolute\":\n            {\n                \"x\": -25.109019607843152,\n                \"y\": 521.7086666666667\n            },\n            \"selected\": false,\n            \"type\": \"开始节点\",\n            \"width\": 658\n        },\n        {\n            \"data\":\n            {\n                \"allowInputReference\": true,\n                \"allowOutputReference\": false,\n                \"description\": \"The end node of the workflow, used to output the final result after the workflow execution.\",\n                \"icon\": \"https://oss-beijing-m8.openstorage.cn/pro-bucket/sparkBot/common/workflow/icon/end-node-icon.png\",\n                \"inputs\":\n                [\n                    {\n                        \"id\": \"82de2b42-a059-4c98-bffb-b6b4800fcac9\",\n                        \"name\": \"output\",\n                        \"schema\":\n                        {\n                            \"type\": \"string\",\n                            \"value\":\n                            {\n                                \"content\":\n                                {},\n                                \"type\": \"ref\"\n                            }\n                        }\n                    }\n                ],\n                \"label\": \"End\",\n                \"nodeMeta\":\n                {\n                    \"aliasName\": \"结束节点\",\n                    \"nodeType\": \"基础节点\"\n                },\n                \"nodeParam\":\n                {\n                    \"template\": \"\",\n                    \"streamOutput\": true,\n                    \"outputMode\": 1\n                },\n                \"outputs\":\n                [],\n                \"references\":\n                [],\n                \"status\": \"\",\n                \"updatable\": false\n            },\n            \"dragging\": false,\n            \"height\": 617,\n            \"id\": \"node-end::cda617af-551e-462e-b3b8-3bb9a041bf88\",\n            \"position\":\n            {\n                \"x\": 886.8833333333332,\n                \"y\": 343.91588235294114\n            },\n            \"positionAbsolute\":\n            {\n                \"x\": 886.8833333333332,\n                \"y\": 343.91588235294114\n            },\n            \"selected\": true,\n            \"type\": \"结束节点\",\n            \"width\": 408\n        }\n    ],\n    \"edges\":\n    []\n}', 1, NULL, '2022-06-10 00:00:00', '2025-07-29 15:14:22');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1779, 'DOMAIN_WHITE_LIST', 'domain_white_list', '域名白名单', 'inner-sparklinkthirdapi.aipaasapi.cn,agentbuilder.aipaasapi.cn,dx-cbm-ocp-agg-search-inner.xf-yun.com,dx-cbm-ocp-gateway.xf-yun.com,xingchen-agent-mcp.aicp.private,dx-spark-agentbuilder.aicp.private,vmselect.huabei.xf-yun.com,pre-agentbuilder.aipaasapi.cn', 1, NULL, '2022-06-10 00:00:00', '2025-07-21 17:01:46');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1780, 'WORKFLOW_NODE_TEMPLATE', '1,2', 'Basic Node', '{\n  \"aliasName\": \"Database\",\n  \"idType\": \"database\",\n  \"data\": {\n    \"outputs\": [\n      {\n        \"id\": \"\",\n        \"name\": \"isSuccess\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"SQL statement execution status indicator, true for success, false for failure\",\n          \"type\": \"boolean\"\n        }\n      },\n      {\n        \"id\": \"\",\n        \"name\": \"message\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"Failure reason\",\n          \"type\": \"string\"\n        }\n      },\n      {\n        \"id\": \"\",\n        \"name\": \"outputList\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"Execution result\",\n          \"type\": \"array-object\"\n        }\n      }\n    ],\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"inputs\": [\n      {\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        },\n        \"name\": \"input\",\n        \"id\": \"\"\n      }\n    ],\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/user/sparkBot_1752568522509_database_icon.svg\",\n    \"allowOutputReference\": true,\n    \"nodeMeta\": {\n        \"aliasName\": \"数据库节点\",\n        \"nodeType\": \"基础节点\"\n      },\n    \"nodeParam\": {\n      \"mode\": 0\n    }\n  },\n  \"description\": \"Supports user-defined SQL for performing database operations such as insert, delete, update, and query\",\n  \"nodeType\": \"Basic Node\"\n}', 1, '数据库节点', '2000-01-01 00:00:00', '2025-07-28 10:18:24');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1781, 'WORKFLOW_NODE_TEMPLATE_PRE', '1,2', '基础节点', '{\n  \"aliasName\": \"Database\",\n  \"idType\": \"database\",\n  \"data\": {\n    \"outputs\": [\n      {\n        \"id\": \"\",\n        \"name\": \"isSuccess\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"SQL statement execution status indicator, true for success, false for failure\",\n          \"type\": \"boolean\"\n        }\n      },\n      {\n        \"id\": \"\",\n        \"name\": \"message\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"Failure reason\",\n          \"type\": \"string\"\n        }\n      },\n      {\n        \"id\": \"\",\n        \"name\": \"outputList\",\n        \"nameErrMsg\": \"\",\n        \"schema\": {\n          \"default\": \"Execution result\",\n          \"type\": \"array-object\"\n        }\n      }\n    ],\n    \"references\": [],\n    \"allowInputReference\": true,\n    \"inputs\": [\n      {\n        \"schema\": {\n          \"type\": \"string\",\n          \"value\": {\n            \"type\": \"ref\",\n            \"content\": {}\n          }\n        },\n        \"name\": \"input\",\n        \"id\": \"\"\n      }\n    ],\n    \"icon\": \"https://oss-beijing-m8.openstorage.cn/SparkBotDev/icon/user/sparkBot_1752568522509_database_icon.svg\",\n    \"allowOutputReference\": true,\n    \"nodeMeta\": {\n        \"aliasName\": \"数据库节点\",\n        \"nodeType\": \"基础节点\"\n      },\n    \"nodeParam\": {\n      \"mode\": 0\n    }\n  },\n  \"description\": \"Supports user-defined SQL for performing database operations such as insert, delete, update, and query\",\n  \"nodeType\": \"Basic Node\"\n}', 1, '数据库节点', '2000-01-01 00:00:00', '2025-07-25 16:55:31');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1782, 'DB_TABLE_TEMPLATE', 'TB', '数据库字段导入模版', 'https://oss-beijing-m8.openstorage.cn/SparkBotDev/sparkBot/DB_TABLE_IMPORT_TEMPLATE_en.xlsx', 1, NULL, '2025-07-10 10:50:48', '2025-07-31 19:59:04');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1783, 'ICON', 'rag', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/rag/Personal_en@1x.png', 1, 'SparkDesk-RAG', '2025-07-31 10:53:21', '2025-07-31 19:49:25');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1784, 'ICON', 'rag', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/rag/Spark_en@1x.png', 1, 'CBG-RAG', '2025-07-31 10:53:21', '2025-07-31 19:49:25');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1785, 'ICON', 'rag', 'http://oss-beijing-m8.openstorage.cn/SparkBotProd/', 'icon/rag/Stellar_en@1x.png', 1, 'AIUI-RAG2', '2025-07-31 10:53:21', '2025-07-31 19:49:25');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1786, 'EVAL_TASK_PROMPT', 'FIX', '测评纬度优化prompt', '# Role  \nYou are a prompt optimization expert, and your task is to analyze and optimize the following \"original prompt\" specifically for the single dimension of \"{{评估维度名称}}\", helping the user improve the prompt\'s quality in that dimension.\n\n# Original Prompt  \n{{context}}\n\n# Please follow these steps:  \n1. Analyze the weaknesses of the original prompt in terms of “{{Evaluation Dimension Name}}” (e.g., vague expression, lack of necessary information).  \n2. Optimize the original prompt if needed, such as refining wording, adding examples, clarifying format, etc., to ensure the prompt stands out in this dimension (e.g., more clear or more complete).  \n3. Provide scoring criteria for this dimension with descriptions for all four levels.\n\n**Scoring Criteria**  \nUse the following fixed levels and scores for the dimension of “{{Evaluation Dimension Name}}”. Suppose the dimension is “Clarity”:  \n| Level  | Score | Description                                     |\n|--------|-------|-------------------------------------------------|\n| **Good**    | 4     | Goal and instructions are perfectly clear with no ambiguity. |\n| **Fairly Good** | 3     | Mostly clear with minor ambiguity that does not affect understanding. |\n| **Average** | 2     | Somewhat vague, requires contextual guessing to understand intent. |\n| **Poor**    | 1     | Ambiguous or contradictory instructions that are difficult to execute. |\n\n# Output Format:  \n\"\"\"\n## Role  \nYou are a quality inspector of dialogue fluency, responsible for evaluating the quality of \"user input\" and \"response text\".\n\n## Evaluation Process  \n1. Check whether the sentences are smooth and free of grammatical errors (e.g., mismatched phrases, incomplete components).  \n2. Analyze logical coherence to judge whether the transitions between paragraphs or sentences are natural, and whether there are any abrupt topic shifts or logical gaps.  \n3. Evaluate whether the amount of information is appropriate and meets the user\'s needs (e.g., redundant or missing information may affect fluency).\n\n## Scoring Criteria  \n| Level  | Score | Description                                                                 |\n|--------|-------|------------------------------------------------------------------------------|\n| **Good**    | 4     | Smooth sentences, rigorous logic, natural transitions, appropriate information, overall dialogue as smooth as human conversation. |\n| **Fairly Good** | 3     | Basically fluent, with only occasional minor grammatical or transitional issues, no effect on communication. |\n| **Average** | 2     | Some grammatical or logical errors, or slightly awkward transitions, but the main intent is understandable. |\n| **Poor**    | 1     | Many grammar errors, confusing sentence structure, serious topic jumps, severely affecting conversation coherence. |\n\n## Output Example  \n{\"Score\":1,\"Reason\":\"The assistant\'s tone, wording, and content fully match its role as a Victorian-era English butler from the 19th century. The reply aligns with the user\'s positive emotion and responds with polite, encouraging language.\"}\n\"\"\"\n\n# Output Requirements:  \n- Focus entirely on **“{{Evaluation Dimension Name}}”** only, ignore all other dimensions.  \n- Use concise, bullet-point style language for easy copying.  \n- Provide a revised prompt focused on “{{Evaluation Dimension Name}}” that is structured and ready for direct use.  \n- Only output the final optimized prompt result, no need to explain the thought process or optimization reasoning.  \n- Follow the \"Output Format\" structure strictly, and ensure the \"Output Example\" is in valid JSON format with score and reason fields.', 1, '', '2025-07-31 10:52:49', '2025-07-31 15:08:34');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1787, 'EVAL_TASK_PROMPT', 'JUDGE', '评分维度评价prompt', '# Input  \nYou are to evaluate the \"response text\" based on the \"user input\" and \"agent/workflow setting\" along the dimension of \"{{Evaluation Dimension}}\".  \nAgent/Workflow Setting: {{system_prompt}}  \nUser Input: {{input}}  \nResponse Text: {{output}}\n\n# Output:  \nScore: A number indicating how well the response meets the criteria defined in the prompt. The score ranges from 4 to 1, corresponding to 4 (Good), 3 (Fairly Good), 2 (Average), and 1 (Poor).  \nReason: A readable explanation for the given score. The reason must end with a complete sentence.  \nFormat: Strictly output in JSON format, with \"Score\" for the rating and \"Reason\" for the explanation.\n\n# Output Format  \n{\"Score\":3,\"Reason\":\"The response generally aligns with the question context, but the mentioned secondary example fails to clearly support the main conclusion, causing minor logical looseness.\"}', 1, '', '2025-07-31 10:52:49', '2025-07-31 15:07:50');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1788, 'CUSTOM_SLICE_SEPERATORS_AIUI', '1', 'AIUI自定义分隔符', '[\n    {\n        \"id\": 1,\n        \"name\": \"Line break\",\n        \"symbol\": \"\\\\n\"\n    },\n    {\n        \"id\": 2,\n        \"name\": \"Chinese period\",\n        \"symbol\": \"。\"\n    },\n    {\n        \"id\": 3,\n        \"name\": \"English period\",\n        \"symbol\": \".\"\n    },\n    {\n        \"id\": 4,\n        \"name\": \"Chinese exclamation mark\",\n        \"symbol\": \"！\"\n    },\n    {\n        \"id\": 5,\n        \"name\": \"English exclamation mark\",\n        \"symbol\": \"!\"\n    },\n    {\n        \"id\": 6,\n        \"name\": \"Chinese question mark\",\n        \"symbol\": \"？\"\n    },\n    {\n        \"id\": 7,\n        \"name\": \"English question mark\",\n        \"symbol\": \"?\"\n    },\n    {\n        \"id\": 8,\n        \"name\": \"Chinese semicolon\",\n        \"symbol\": \"；\"\n    },\n    {\n        \"id\": 9,\n        \"name\": \"English semicolon\",\n        \"symbol\": \";\"\n    },\n    {\n        \"id\": 10,\n        \"name\": \"Chinese ellipsis\",\n        \"symbol\": \"……\"\n    },\n    {\n        \"id\": 11,\n        \"name\": \"English ellipsis\",\n        \"symbol\": \"...\"\n    }\n]', 1, '', '2025-07-31 15:31:10', '2025-07-31 15:31:23');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1789, 'CUSTOM_SLICE_SEPERATORS_CBG', '1', 'CBG自定义分隔符', '[\n    {\n        \"id\": 1,\n        \"name\": \"Line break\",\n        \"symbol\": \"\\\\n\"\n    },\n    {\n        \"id\": 2,\n        \"name\": \"Chinese period\",\n        \"symbol\": \"。\"\n    },\n    {\n        \"id\": 3,\n        \"name\": \"English period\",\n        \"symbol\": \".\"\n    },\n    {\n        \"id\": 4,\n        \"name\": \"Chinese exclamation mark\",\n        \"symbol\": \"！\"\n    },\n    {\n        \"id\": 5,\n        \"name\": \"English exclamation mark\",\n        \"symbol\": \"!\"\n    },\n    {\n        \"id\": 6,\n        \"name\": \"Chinese question mark\",\n        \"symbol\": \"？\"\n    },\n    {\n        \"id\": 7,\n        \"name\": \"English question mark\",\n        \"symbol\": \"?\"\n    },\n    {\n        \"id\": 8,\n        \"name\": \"Chinese semicolon\",\n        \"symbol\": \"；\"\n    },\n    {\n        \"id\": 9,\n        \"name\": \"English semicolon\",\n        \"symbol\": \";\"\n    },\n    {\n        \"id\": 10,\n        \"name\": \"Chinese ellipsis\",\n        \"symbol\": \"……\"\n    },\n    {\n        \"id\": 11,\n        \"name\": \"English ellipsis\",\n        \"symbol\": \"...\"\n    }\n]', 1, '', '2025-07-31 15:31:15', '2025-07-31 15:31:22');
INSERT INTO `config_info_en` (`id`, `category`, `code`, `name`, `value`, `is_valid`, `remarks`, `create_time`, `update_time`) VALUES (1790, 'CUSTOM_SLICE_SEPERATORS_SPARK', '1', 'SPARK自定义分隔符', '[\n    {\n        \"id\": 1,\n        \"name\": \"Line break\",\n        \"symbol\": \"\\\\n\"\n    },\n    {\n        \"id\": 2,\n        \"name\": \"Chinese period\",\n        \"symbol\": \"。\"\n    },\n    {\n        \"id\": 3,\n        \"name\": \"English period\",\n        \"symbol\": \".\"\n    },\n    {\n        \"id\": 4,\n        \"name\": \"Chinese exclamation mark\",\n        \"symbol\": \"！\"\n    },\n    {\n        \"id\": 5,\n        \"name\": \"English exclamation mark\",\n        \"symbol\": \"!\"\n    },\n    {\n        \"id\": 6,\n        \"name\": \"Chinese question mark\",\n        \"symbol\": \"？\"\n    },\n    {\n        \"id\": 7,\n        \"name\": \"English question mark\",\n        \"symbol\": \"?\"\n    },\n    {\n        \"id\": 8,\n        \"name\": \"Chinese semicolon\",\n        \"symbol\": \"；\"\n    },\n    {\n        \"id\": 9,\n        \"name\": \"English semicolon\",\n        \"symbol\": \";\"\n    },\n    {\n        \"id\": 10,\n        \"name\": \"Chinese ellipsis\",\n        \"symbol\": \"……\"\n    },\n    {\n        \"id\": 11,\n        \"name\": \"English ellipsis\",\n        \"symbol\": \"...\"\n    }\n]', 1, '', '2025-07-31 15:31:21', '2025-07-31 15:31:25');
COMMIT;

-- ----------------------------
-- Table structure for core_system_error_code
-- ----------------------------
DROP TABLE IF EXISTS `core_system_error_code`;
CREATE TABLE `core_system_error_code`
(
    `id`         int          NOT NULL AUTO_INCREMENT,
    `error_code` int          NOT NULL,
    `error_msg`  varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for create_bot_context
-- ----------------------------
DROP TABLE IF EXISTS `create_bot_context`;
CREATE TABLE `create_bot_context`
(
    `chat_id`      varchar(255) NOT NULL,
    `step`         tinyint  DEFAULT NULL,
    `biz_data`     json     DEFAULT NULL,
    `create_time`  datetime DEFAULT NULL,
    `update_time`  datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `chat_history` text,
    PRIMARY KEY (`chat_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for custom_vcn
-- ----------------------------
DROP TABLE IF EXISTS `custom_vcn`;
CREATE TABLE `custom_vcn`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `uid`         bigint                                                        DEFAULT NULL,
    `name`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL,
    `status`      tinyint                                                       DEFAULT NULL COMMENT '0: deleted, 1: training, 2: training successful, 3: training failed, 4: training not started',
    `vcn_code`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Voice library VCN code',
    `try_vcn_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Voice sample audio URL',
    `task_id`     bigint                                                        DEFAULT NULL COMMENT 'Primary key ID of custom_vcn_task',
    `vcn_task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Audio task ID',
    `sex`         tinyint                                                       DEFAULT NULL,
    `create_time` datetime                                                      DEFAULT NULL,
    `update_time` datetime                                                      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `share`       tinyint                                                       DEFAULT '0' COMMENT 'Whether from sharing: 0 no, 1 yes',
    `agent_id`    bigint                                                        DEFAULT NULL COMMENT 'Primary key ID of speaker personality table',
    PRIMARY KEY (`id`),
    KEY           `idx_agent_id` (`agent_id`),
    KEY           `idx_task_id` (`task_id`),
    KEY           `idx_uid` (`uid`),
    KEY           `idx_vcn_code` (`vcn_code`),
    KEY           `idx_vcn_task_id` (`vcn_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Store user-trained personalized speakers';

-- ----------------------------
-- Table structure for dataset_file
-- ----------------------------
DROP TABLE IF EXISTS `dataset_file`;
CREATE TABLE `dataset_file`
(
    `id`            bigint        NOT NULL AUTO_INCREMENT COMMENT 'File ID',
    `dataset_id`    bigint        NOT NULL COMMENT 'Dataset ID',
    `dataset_index` varchar(255)           DEFAULT NULL COMMENT 'Dataset index',
    `name`          varchar(128)  NOT NULL COMMENT 'File name',
    `doc_type`      varchar(32)   NOT NULL COMMENT 'File type',
    `doc_url`       varchar(2048) NOT NULL COMMENT 'File URL',
    `s3_url`        varchar(2048)          DEFAULT NULL COMMENT 'S3 file URL',
    `para_count`    int                    DEFAULT NULL COMMENT 'Paragraph count',
    `char_count`    int                    DEFAULT NULL COMMENT 'Character count',
    `status`        tinyint       NOT NULL DEFAULT '0' COMMENT 'Status: -1 deleted, 0 unprocessed, 1 processing, 2 completed, 3 failed',
    `create_time`   datetime               DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime               DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY             `idx_dataset_id` (`dataset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Private dataset file table';

-- ----------------------------
-- Table structure for dataset_info
-- ----------------------------
DROP TABLE IF EXISTS `dataset_info`;
CREATE TABLE `dataset_info`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT COMMENT 'Dataset ID',
    `uid`         varchar(128) NOT NULL COMMENT 'User ID',
    `name`        varchar(128) NOT NULL COMMENT 'Dataset name',
    `description` varchar(256)          DEFAULT NULL COMMENT 'Dataset description',
    `file_num`    int                   DEFAULT NULL COMMENT 'File count',
    `status`      tinyint      NOT NULL DEFAULT '0' COMMENT 'Status: -1 deleted, 0 unprocessed, 1 processing, 2 completed, 3 failed',
    `create_time` datetime              DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY           `idx_uid` (`uid`),
    KEY           `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Private dataset information table';

-- ----------------------------
-- Table structure for db_info
-- ----------------------------
DROP TABLE IF EXISTS `db_info`;
CREATE TABLE `db_info`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT,
    `app_id`       varchar(100) NOT NULL,
    `uid`          varchar(100) NOT NULL COMMENT 'User ID',
    `db_id`        bigint                DEFAULT NULL COMMENT 'Core system database primary key ID',
    `name`         varchar(100) NOT NULL COMMENT 'Database name',
    `description`  varchar(255)          DEFAULT NULL COMMENT 'Description',
    `avatar_icon`  varchar(255)          DEFAULT NULL COMMENT 'Icon',
    `avatar_color` varchar(255)          DEFAULT NULL,
    `deleted`      tinyint      NOT NULL DEFAULT '0',
    `create_time`  datetime     NOT NULL,
    `update_time`  datetime              DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `space_id`     bigint                DEFAULT NULL COMMENT 'Space ID',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Database information table';

-- ----------------------------
-- Table structure for db_table
-- ----------------------------
DROP TABLE IF EXISTS `db_table`;
CREATE TABLE `db_table`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `db_id`       bigint       NOT NULL COMMENT 'Database primary key ID',
    `name`        varchar(100) NOT NULL,
    `description` varchar(255)          DEFAULT NULL,
    `deleted`     tinyint      NOT NULL DEFAULT '0',
    `create_time` datetime     NOT NULL,
    `update_time` datetime              DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for db_table_field
-- ----------------------------
DROP TABLE IF EXISTS `db_table_field`;
CREATE TABLE `db_table_field`
(
    `id`            bigint       NOT NULL AUTO_INCREMENT,
    `tb_id`         bigint       NOT NULL COMMENT 'Table primary key ID',
    `name`          varchar(100) NOT NULL,
    `type`          varchar(100) NOT NULL,
    `description`   varchar(100)          DEFAULT NULL,
    `default_value` varchar(100)          DEFAULT NULL,
    `is_required`   tinyint      NOT NULL DEFAULT '0',
    `is_system`     tinyint      NOT NULL DEFAULT '0',
    `create_time`   datetime     NOT NULL,
    `update_time`   datetime     NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Table fields';

-- ----------------------------
-- Table structure for exclude_appid_flowId
-- ----------------------------
DROP TABLE IF EXISTS `exclude_appid_flowId`;
CREATE TABLE `exclude_appid_flowId`
(
    `id`      int NOT NULL AUTO_INCREMENT,
    `app_id`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `flow_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY       `exclude_appid_flowId_app_id_IDX` (`app_id`) USING BTREE,
    KEY       `exclude_appid_flowId_flow_id_IDX` (`flow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for extract_knowledge_task
-- ----------------------------
DROP TABLE IF EXISTS `extract_knowledge_task`;
CREATE TABLE `extract_knowledge_task`
(
    `id`          bigint NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `file_id`     bigint       DEFAULT NULL COMMENT 'File ID',
    `task_id`     varchar(64)  DEFAULT NULL COMMENT 'Task ID',
    `status`      int          DEFAULT '0' COMMENT '0: default, 1: success, 2: failed',
    `reason`      text,
    `user_id`     varchar(128) DEFAULT NULL COMMENT 'User ID',
    `create_time` timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `task_status` int          DEFAULT NULL COMMENT 'Task execution status: 0 start parsing, 1 parsing completed, 2 start embedding, 3 embedding completed',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for feedback_info
-- ----------------------------
DROP TABLE IF EXISTS `feedback_info`;
CREATE TABLE `feedback_info`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `app_id`      varchar(255)  DEFAULT NULL,
    `sub`         varchar(255)  DEFAULT NULL,
    `uid`         varchar(128)  DEFAULT NULL,
    `chat_id`     varchar(128)  DEFAULT NULL,
    `sid`         varchar(128)  DEFAULT NULL,
    `bot_id`      varchar(128)  DEFAULT NULL,
    `flow_id`     varchar(128)  DEFAULT NULL,
    `question`    text,
    `answer`      text,
    `action`      varchar(255)  DEFAULT NULL,
    `reason`      varchar(255)  DEFAULT NULL,
    `remark`      varchar(1200) DEFAULT NULL,
    `create_time` datetime      DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    KEY           `app_id` (`app_id`),
    KEY           `uid` (`uid`),
    KEY           `sid` (`sid`),
    KEY           `bot_id` (`bot_id`),
    KEY           `flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for file_directory_tree
-- ----------------------------
DROP TABLE IF EXISTS `file_directory_tree`;
CREATE TABLE `file_directory_tree`
(
    `id`          bigint NOT NULL AUTO_INCREMENT COMMENT 'Primary key for directory',
    `name`        varchar(255) DEFAULT NULL COMMENT 'Directory name',
    `parent_id`   bigint       DEFAULT NULL COMMENT 'Parent directory ID, -1 for root directory',
    `is_file`     tinyint(1) DEFAULT '0' COMMENT 'Whether it is a file, 0 for false (default folder), 1 for true (file)',
    `app_id`      varchar(10)  DEFAULT NULL COMMENT 'Associated app ID',
    `file_id`     bigint       DEFAULT NULL COMMENT 'Associated file ID, only when is_file is 1',
    `comment`     varchar(255) DEFAULT NULL COMMENT 'Remarks, changes can be synced here',
    `create_time` timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `hit_count`   int          DEFAULT '0' COMMENT 'Hit count',
    `status`      tinyint(1) DEFAULT '0' COMMENT 'Status: 0 slice state, 1 embedding state',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for file_info
-- ----------------------------
DROP TABLE IF EXISTS `file_info`;
CREATE TABLE `file_info`
(
    `id`          bigint    NOT NULL AUTO_INCREMENT,
    `app_id`      varchar(10)        DEFAULT NULL,
    `name`        varchar(128)       DEFAULT NULL,
    `address`     varchar(255)       DEFAULT NULL,
    `size`        bigint             DEFAULT NULL,
    `type`        varchar(64)        DEFAULT NULL,
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `source_id`   varchar(255)       DEFAULT NULL,
    `status`      int                DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for file_info_v2
-- ----------------------------
DROP TABLE IF EXISTS `file_info_v2`;
CREATE TABLE `file_info_v2`
(
    `id`                   bigint      NOT NULL AUTO_INCREMENT,
    `repo_id`              bigint      NOT NULL COMMENT 'Identifies the folder to which the file belongs',
    `uuid`                 varchar(64)          DEFAULT NULL,
    `uid`                  varchar(255)         DEFAULT NULL COMMENT 'User ID',
    `name`                 varchar(512)         DEFAULT NULL COMMENT 'File name',
    `address`              varchar(255)         DEFAULT NULL COMMENT 'File storage address',
    `size`                 bigint               DEFAULT NULL COMMENT 'File size',
    `char_count`           bigint               DEFAULT NULL COMMENT 'File character length',
    `type`                 varchar(64)          DEFAULT NULL COMMENT 'File type',
    `status`               int                  DEFAULT NULL COMMENT 'File build status: -1 uploaded, 0 parsing, 1 parse failed, 2 parse success, 3 embedding, 4 embed failed, 5 embed success',
    `enabled`              int                  DEFAULT '0' COMMENT '0: disabled, 1: enabled',
    `slice_config`         varchar(500)         DEFAULT NULL COMMENT 'Latest slice configuration',
    `current_slice_config` varchar(500)         DEFAULT NULL COMMENT 'Currently effective slice configuration',
    `pid`                  bigint               DEFAULT '-1' COMMENT 'Identifies the folder to which the file belongs',
    `reason`               text COMMENT 'Failure reason',
    `create_time`          timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`          timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `source`               varchar(64) NOT NULL DEFAULT 'AIUI-RAG2' COMMENT 'Data source',
    `space_id`             bigint               DEFAULT NULL COMMENT 'Team space ID',
    `last_uuid`            varchar(100)         DEFAULT NULL COMMENT 'UUID generated by CBG parsing, used for preview, updated to uuid after embedding',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for fine_tune_task
-- ----------------------------
DROP TABLE IF EXISTS `fine_tune_task`;
CREATE TABLE `fine_tune_task`
(
    `id`                    bigint   NOT NULL AUTO_INCREMENT,
    `optimize_task_id`      bigint   NOT NULL,
    `dataset_id`            bigint   NOT NULL,
    `model_id`              bigint   NOT NULL,
    `fine_tune_task_id`     bigint   NOT NULL,
    `fine_tune_task_remark` varchar(1024) DEFAULT NULL,
    `create_time`           datetime NOT NULL,
    `update_time`           datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    `base_model_id`         bigint        DEFAULT NULL,
    `server_name`           varchar(255)  DEFAULT NULL,
    `optimize_node`         text,
    `status`                tinyint       DEFAULT '1',
    `server_id`             bigint        DEFAULT NULL,
    `server_status`         tinyint       DEFAULT '0',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for flow_db_rel
-- ----------------------------
DROP TABLE IF EXISTS `flow_db_rel`;
CREATE TABLE `flow_db_rel`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `flow_id`     varchar(100) NOT NULL,
    `db_id`       varchar(100) NOT NULL,
    `tb_id`       bigint DEFAULT NULL,
    `create_time` datetime     NOT NULL,
    `update_time` datetime     NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flow_protocol_temp
-- ----------------------------
DROP TABLE IF EXISTS `flow_protocol_temp`;
CREATE TABLE `flow_protocol_temp`
(
    `flow_id`      varchar(255) NOT NULL,
    `created_time` datetime     NOT NULL,
    `biz_protocol` mediumtext   NOT NULL,
    `sys_protocol` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flow_release_aiui_info
-- ----------------------------
DROP TABLE IF EXISTS `flow_release_aiui_info`;
CREATE TABLE `flow_release_aiui_info`
(
    `id`   int unsigned NOT NULL AUTO_INCREMENT,
    `data` text NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flow_release_channel
-- ----------------------------
DROP TABLE IF EXISTS `flow_release_channel`;
CREATE TABLE `flow_release_channel`
(
    `flow_id`     varchar(255) NOT NULL,
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime              DEFAULT CURRENT_TIMESTAMP,
    `channel`     varchar(255) NOT NULL,
    `info_id`     bigint                DEFAULT NULL,
    `status`      tinyint               DEFAULT '0' COMMENT '0=not published, 1=published',
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flow_repo_rel
-- ----------------------------
DROP TABLE IF EXISTS `flow_repo_rel`;
CREATE TABLE `flow_repo_rel`
(
    `flow_id`     varchar(255) NOT NULL,
    `repo_id`     varchar(255) NOT NULL,
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for flow_tool_rel
-- ----------------------------
DROP TABLE IF EXISTS `flow_tool_rel`;
CREATE TABLE `flow_tool_rel`
(
    `flow_id`     varchar(255) NOT NULL,
    `tool_id`     varchar(255) NOT NULL,
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `version`     varchar(100)          DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for group_tag
-- ----------------------------
DROP TABLE IF EXISTS `group_tag`;
CREATE TABLE `group_tag`
(
    `id`          bigint    NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128)       DEFAULT NULL COMMENT 'User ID',
    `name`        varchar(64)        DEFAULT NULL COMMENT 'Tag name',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Tag creation time',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for group_user
-- ----------------------------
DROP TABLE IF EXISTS `group_user`;
CREATE TABLE `group_user`
(
    `id`          bigint    NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128)       DEFAULT NULL COMMENT 'User ID',
    `user_id`     varchar(128)       DEFAULT NULL COMMENT 'Tag name',
    `tag_id`      bigint             DEFAULT NULL COMMENT 'Associated tag',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Tag creation time',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for group_visibility
-- ----------------------------
DROP TABLE IF EXISTS `group_visibility`;
CREATE TABLE `group_visibility`
(
    `id`          bigint    NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128)       DEFAULT NULL,
    `type`        int                DEFAULT NULL COMMENT 'Type: 1 knowledge base, 2 tools',
    `user_id`     varchar(128)       DEFAULT NULL,
    `relation_id` varchar(200)       DEFAULT NULL COMMENT 'Used to isolate tags between different entities',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `space_id`    bigint             DEFAULT NULL COMMENT 'Team space ID',
    PRIMARY KEY (`id`),
    KEY           `type_rel_idx` (`type`,`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for hit_test_history
-- ----------------------------
DROP TABLE IF EXISTS `hit_test_history`;
CREATE TABLE `hit_test_history`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `user_id`     varchar(128) NOT NULL DEFAULT '-999' COMMENT 'Knowledge base ID',
    `repo_id`     bigint       NOT NULL COMMENT 'Knowledge base ID',
    `query`       text         NOT NULL COMMENT 'Query string',
    `create_time` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for knowledge
-- ----------------------------
DROP TABLE IF EXISTS `knowledge`;
CREATE TABLE `knowledge`
(
    `id`               varchar(64) NOT NULL COMMENT 'Primary key ID',
    `file_id`          varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL COMMENT 'User ID',
    `content`          text,
    `char_count`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `name`             varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `description`      varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `enabled`          bit(1)                                                        DEFAULT b'0',
    `source`           bit(1)                                                        DEFAULT b'1',
    `test_hit_count`   bigint                                                        DEFAULT NULL,
    `dialog_hit_count` bigint                                                        DEFAULT NULL,
    `core_repo_name`   text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    `deleted`          bit(1)      NOT NULL                                          DEFAULT b'0',
    `created_at`       datetime    NOT NULL,
    `updated_at`       datetime                                                      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY                `flow_id` (`char_count`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for maas_template
-- ----------------------------
DROP TABLE IF EXISTS `maas_template`;
CREATE TABLE `maas_template`
(
    `id`             bigint   NOT NULL AUTO_INCREMENT,
    `core_abilities` json                                                           DEFAULT NULL,
    `core_scenarios` json                                                           DEFAULT NULL,
    `is_act`         tinyint                                                        DEFAULT NULL,
    `maas_id`        bigint                                                         DEFAULT NULL,
    `subtitle`       varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL,
    `title`          varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL,
    `bot_id`         int                                                            DEFAULT NULL,
    `cover_url`      varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `group_id`       bigint                                                         DEFAULT NULL,
    `order_index`    int                                                            DEFAULT NULL,
    `create_time`    datetime NOT NULL                                              DEFAULT CURRENT_TIMESTAMP,
    `update_time`    datetime NOT NULL                                              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workflow assistant template configuration';

-- ----------------------------
-- Table structure for mcp_data
-- ----------------------------
DROP TABLE IF EXISTS `mcp_data`;
CREATE TABLE `mcp_data`
(
    `id`           bigint                                                        NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `bot_id`       bigint                                                        NOT NULL COMMENT 'Agent ID',
    `uid`          bigint                                                        NOT NULL COMMENT 'User ID',
    `space_id`     bigint                                                                 DEFAULT NULL COMMENT 'Space ID, NULL for personal agents',
    `server_name`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MCP server name',
    `description`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'MCP server description',
    `content`      longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'MCP server content configuration',
    `icon`         varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci         DEFAULT NULL COMMENT 'MCP server icon URL',
    `server_url`   varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci         DEFAULT NULL COMMENT 'MCP server address',
    `args`         json                                                                   DEFAULT NULL COMMENT 'MCP service parameter configuration, stored in JSON format',
    `version_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci          DEFAULT NULL COMMENT 'Associated agent version name',
    `released`     tinyint                                                       NOT NULL DEFAULT '1' COMMENT 'Release status: 0=not published, 1=published',
    `is_delete`    tinyint                                                       NOT NULL DEFAULT '0' COMMENT 'Whether deleted: 0=not deleted, 1=deleted',
    `create_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_bot_id_version` (`bot_id`,`version_name`),
    KEY            `idx_uid` (`uid`),
    KEY            `idx_space_id` (`space_id`),
    KEY            `idx_bot_id` (`bot_id`),
    KEY            `idx_released` (`released`),
    KEY            `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MCP data table';

-- ----------------------------
-- Table structure for mcp_tool_config
-- ----------------------------
DROP TABLE IF EXISTS `mcp_tool_config`;
CREATE TABLE `mcp_tool_config`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `mcp_id`      varchar(255)          DEFAULT NULL COMMENT 'mcp id',
    `server_id`   varchar(255)          DEFAULT NULL COMMENT 'ID returned by link',
    `sort_link`   varchar(1024)         DEFAULT NULL COMMENT 'Short link',
    `uid`         varchar(128) NOT NULL COMMENT 'User ID',
    `type`        varchar(255)          DEFAULT NULL COMMENT 'MCP tool type',
    `content`     text COMMENT 'Details',
    `is_deleted`  bit(1)       NOT NULL DEFAULT b'0' COMMENT 'Whether deleted: 0 not deleted, 1 deleted',
    `create_time` datetime              DEFAULT NULL,
    `update_time` datetime              DEFAULT NULL,
    `parameters`  text COMMENT 'History parameters',
    `customize`   bit(1)                DEFAULT NULL COMMENT 'Whether custom parameters exist',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for model
-- ----------------------------
DROP TABLE IF EXISTS `model`;
CREATE TABLE `model`
(
    `id`                bigint       NOT NULL AUTO_INCREMENT COMMENT 'Shelf model ID',
    `name`              varchar(255)          DEFAULT NULL COMMENT 'Model name',
    `desc`              varchar(1024)         DEFAULT NULL COMMENT 'Model description, text description below model plaza card and name',
    `source`            int                   DEFAULT NULL COMMENT 'Model source: 1 self-developed, 2 open source, 3 third party',
    `uid`               varchar(128) NOT NULL COMMENT 'User ID',
    `type`              int                   DEFAULT NULL COMMENT 'Model type: 1 text interaction, 2 voice, 3 interaction, 4 multimodal',
    `url`               varchar(255)          DEFAULT NULL COMMENT 'Model call address',
    `domain`            varchar(100)          DEFAULT NULL COMMENT 'model',
    `api_key`           varchar(255)          DEFAULT NULL,
    `sub_type`          bigint                DEFAULT NULL COMMENT 'Model subtype: 1 image generation, 2 image understanding, 3 super-human synthesis, 4 image classification',
    `content`           text COMMENT 'Model details text',
    `is_deleted`        bit(1)       NOT NULL DEFAULT b'0' COMMENT 'Whether deleted: 0 not deleted, 1 deleted',
    `image_url`         varchar(255)          DEFAULT NULL,
    `doc_url`           varchar(255)          DEFAULT NULL,
    `remark`            varchar(255)          DEFAULT NULL,
    `sort`              int                   DEFAULT '0' COMMENT 'Sort order',
    `channel`           varchar(255)          DEFAULT '0' COMMENT 'Model channel',
    `tag`               varchar(255)          DEFAULT NULL COMMENT 'Tag',
    `color`             varchar(100)          DEFAULT NULL COMMENT 'Color',
    `create_time`       datetime              DEFAULT NULL,
    `update_time`       datetime              DEFAULT NULL,
    `config`            text COMMENT 'Model configuration',
    `space_id`          bigint                DEFAULT NULL COMMENT 'Space ID',
    `enable`            bit(1)                DEFAULT b'1' COMMENT 'Whether enabled',
    `status`            int                   DEFAULT NULL,
    `accelerator_count` int                   DEFAULT NULL COMMENT 'Performance configuration',
    `replica_count`     int                   DEFAULT NULL COMMENT 'Replica configuration',
    `model_path`        varchar(100)          DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for model_category
-- ----------------------------
DROP TABLE IF EXISTS `model_category`;
CREATE TABLE `model_category`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `pid`         bigint       NOT NULL,
    `key`         varchar(100) NOT NULL DEFAULT '',
    `name`        varchar(255) NOT NULL,
    `is_delete`   tinyint unsigned NOT NULL DEFAULT '0',
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `sort_order`  int          NOT NULL DEFAULT '0' COMMENT 'Sort order',
    PRIMARY KEY (`id`) USING BTREE,
    KEY           `idx_key_pid_delete` (`key`,`pid`,`is_delete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for model_category_rel
-- ----------------------------
DROP TABLE IF EXISTS `model_category_rel`;
CREATE TABLE `model_category_rel`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT,
    `model_id`    bigint   NOT NULL,
    `category_id` bigint   NOT NULL,
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_model_id_category_id` (`model_id`,`category_id`),
    KEY           `idx_category` (`category_id`),
    KEY           `idx_model` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for model_common
-- ----------------------------
DROP TABLE IF EXISTS `model_common`;
CREATE TABLE `model_common`
(
    `id`             bigint       NOT NULL AUTO_INCREMENT,
    `name`           varchar(128) NOT NULL DEFAULT '',
    `desc`           varchar(500)          DEFAULT NULL COMMENT 'Description',
    `intro`          varchar(255) NOT NULL DEFAULT '' COMMENT 'Introduction',
    `user_name`      varchar(64)  NOT NULL DEFAULT '' COMMENT 'User name',
    `user_avatar`    varchar(255) NOT NULL DEFAULT '' COMMENT 'User avatar',
    `service_id`     varchar(128) NOT NULL DEFAULT '',
    `server_id`      varchar(128) NOT NULL DEFAULT '',
    `domain`         varchar(128) NOT NULL DEFAULT '',
    `lic_channel`    varchar(128) NOT NULL DEFAULT '',
    `llm_source`     varchar(128) NOT NULL DEFAULT '',
    `url`            varchar(128) NOT NULL DEFAULT '',
    `model_type`     tinyint      NOT NULL DEFAULT '0',
    `type`           tinyint      NOT NULL DEFAULT '0',
    `source`         tinyint      NOT NULL DEFAULT '0',
    `is_think`       tinyint      NOT NULL DEFAULT '0',
    `multi_mode`     tinyint      NOT NULL DEFAULT '0',
    `is_delete`      tinyint      NOT NULL DEFAULT '0',
    `create_by`      bigint       NOT NULL DEFAULT '0',
    `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_by`      bigint       NOT NULL DEFAULT '0',
    `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `uid`            varchar(128)          DEFAULT NULL COMMENT 'User control ID',
    `disclaimer`     varchar(2048)         DEFAULT '' COMMENT 'Disclaimer',
    `config`         text COMMENT 'Model configuration information',
    `shelf_status`   int                   DEFAULT '0' COMMENT 'Shelf status: 0 on shelf, 1 pending removal, 2 removed',
    `shelf_off_time` datetime              DEFAULT NULL COMMENT 'Removal time',
    `http_url`       varchar(100)          DEFAULT NULL COMMENT 'HTTP address',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for model_custom_category
-- ----------------------------
DROP TABLE IF EXISTS `model_custom_category`;
CREATE TABLE `model_custom_category`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT,
    `owner_uid`    varchar(128) NOT NULL COMMENT 'Creator',
    `key`          varchar(100) NOT NULL DEFAULT '' COMMENT 'model_category / scene',
    `name`         varchar(255) NOT NULL,
    `pid`          bigint                DEFAULT NULL COMMENT 'Optional: attach to an official node',
    `normalized`   varchar(255) GENERATED ALWAYS AS (lower(trim(`name`))) VIRTUAL,
    `audit_status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '1=effective, 0=blocked, 2=pending review',
    `is_delete`    tinyint unsigned NOT NULL DEFAULT '0',
    `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY            `idx_key_status` (`key`,`audit_status`),
    KEY            `idx_owner` (`owner_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for model_custom_category_rel
-- ----------------------------
DROP TABLE IF EXISTS `model_custom_category_rel`;
CREATE TABLE `model_custom_category_rel`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT,
    `model_id`    bigint   NOT NULL,
    `custom_id`   bigint   NOT NULL,
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_model_custom` (`model_id`,`custom_id`),
    KEY           `idx_custom` (`custom_id`),
    CONSTRAINT `fk_rel_custom` FOREIGN KEY (`custom_id`) REFERENCES `model_custom_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for model_list_config
-- ----------------------------
DROP TABLE IF EXISTS `model_list_config`;
CREATE TABLE `model_list_config`
(
    `id`            int unsigned NOT NULL AUTO_INCREMENT,
    `create_time`   timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `node_type`     varchar(255)       DEFAULT NULL,
    `name`          varchar(255)       DEFAULT NULL,
    `description`   varchar(255)       DEFAULT NULL,
    `tag`           varchar(255)       DEFAULT NULL,
    `deleted`       bit(1)             DEFAULT b'0',
    `base_model_id` bigint             DEFAULT NULL,
    `recommended`   bit(1)             DEFAULT b'0',
    `domain`        varchar(255)       DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for node_info
-- ----------------------------
DROP TABLE IF EXISTS `node_info`;
CREATE TABLE `node_info`
(
    `id`                   bigint NOT NULL AUTO_INCREMENT,
    `app_id`               varchar(255) DEFAULT NULL,
    `bot_id`               varchar(255) DEFAULT NULL,
    `flow_id`              varchar(255) DEFAULT NULL,
    `sub`                  varchar(255) DEFAULT NULL,
    `caller`               varchar(255) DEFAULT NULL,
    `sid`                  varchar(255) DEFAULT NULL,
    `node_id`              varchar(255) DEFAULT NULL,
    `node_name`            varchar(255) DEFAULT NULL,
    `node_type`            varchar(255) DEFAULT NULL,
    `running_status`       bit(1)       DEFAULT NULL COMMENT 'Node running status',
    `node_input`           text COMMENT 'Input',
    `node_output`          text COMMENT 'Output',
    `config`               text COMMENT 'Node configuration information',
    `llm_output`           text COMMENT 'Large model output',
    `domain`               varchar(255) DEFAULT NULL,
    `cost_time`            int          DEFAULT NULL COMMENT 'Cost time',
    `first_cost_time`      int          DEFAULT NULL COMMENT 'First frame cost time',
    `node_first_cost_time` float        DEFAULT NULL COMMENT 'Node execution first frame cost time',
    `next_log_ids`         text COMMENT 'Next execution node running ID',
    `token`                int          DEFAULT NULL COMMENT 'Token consumption',
    `create_time`          datetime     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY                    `app_id` (`app_id`),
    KEY                    `bot_id` (`bot_id`),
    KEY                    `flow_id` (`flow_id`),
    KEY                    `sid` (`sid`),
    KEY                    `node_id` (`node_id`),
    KEY                    `domain` (`domain`),
    KEY                    `create_time` (`create_time`),
    KEY                    `token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`
(
    `id`            bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `type`          varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT 'Message type (personal, broadcast, system, promotion)',
    `title`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Message title',
    `body`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Message body',
    `template_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL COMMENT 'Template code for special rendering on client side',
    `payload`       json                                                          DEFAULT NULL COMMENT 'Message payload, JSON format, carries additional business data',
    `creator_uid`   varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Creator ID, e.g. system administrator',
    `created_at`    datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'Creation time',
    `expire_at`     datetime(3) DEFAULT NULL COMMENT 'Expiration time, can be used for automatic cleanup tasks',
    `meta`          json                                                          DEFAULT NULL COMMENT 'Metadata, JSON format, stores other additional information',
    PRIMARY KEY (`id`),
    KEY             `idx_type_created` (`type`,`created_at` DESC),
    KEY             `idx_expire` (`expire_at`),
    KEY             `idx_creator` (`creator_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='General message table';

-- ----------------------------
-- Table structure for preview_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `preview_knowledge`;
CREATE TABLE `preview_knowledge`
(
    `id`         varchar(64) NOT NULL COMMENT 'Primary key ID',
    `file_id`    varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL COMMENT 'User ID',
    `content`    text,
    `char_count` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `deleted`    bit(1)      NOT NULL                                          DEFAULT b'0',
    `created_at` datetime    NOT NULL,
    `updated_at` datetime                                                      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY          `flow_id` (`char_count`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for prompt_template
-- ----------------------------
DROP TABLE IF EXISTS `prompt_template`;
CREATE TABLE `prompt_template`
(
    `id`               bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `uid`              varchar(128) NOT NULL COMMENT 'User ID, empty for official',
    `name`             varchar(255)          DEFAULT NULL COMMENT 'Name',
    `description`      text COMMENT 'Description',
    `deleted`          bit(1)       NOT NULL DEFAULT b'0' COMMENT 'Whether deleted',
    `prompt`           text COMMENT 'Role setting',
    `created_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_time`     datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `node_category`    int                   DEFAULT NULL COMMENT 'Node category: 1: agent node',
    `adaptation_model` text COMMENT 'Adaptation model, 1: deepseek v3',
    `max_loop_count`   bigint                DEFAULT NULL COMMENT 'Maximum loop count',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for prompt_template_en
-- ----------------------------
DROP TABLE IF EXISTS `prompt_template_en`;
CREATE TABLE `prompt_template_en`
(
    `id`               bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `uid`              varchar(128) NOT NULL COMMENT 'User ID, empty for official',
    `name`             varchar(255)          DEFAULT NULL COMMENT 'Name',
    `description`      text COMMENT 'Description',
    `deleted`          bit(1)       NOT NULL DEFAULT b'0' COMMENT 'Whether deleted',
    `prompt`           text COMMENT 'Role setting',
    `created_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_time`     datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `node_category`    int                   DEFAULT NULL COMMENT 'Node category: 1: agent node',
    `adaptation_model` text COMMENT 'Adaptation model, 1: deepseek v3',
    `max_loop_count`   bigint                DEFAULT NULL COMMENT 'Maximum loop count',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for repo
-- ----------------------------
DROP TABLE IF EXISTS `repo`;
CREATE TABLE `repo`
(
    `id`             bigint      NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `name`           varchar(64)          DEFAULT NULL COMMENT 'Robot name',
    `user_id`        varchar(128)         DEFAULT NULL,
    `app_id`         varchar(20)          DEFAULT NULL,
    `outer_repo_id`  varchar(50)          DEFAULT NULL,
    `core_repo_id`   varchar(50)          DEFAULT NULL,
    `description`    varchar(255)         DEFAULT NULL COMMENT 'Description',
    `icon`           varchar(255)         DEFAULT NULL COMMENT 'Avatar icon',
    `color`          varchar(10)          DEFAULT NULL,
    `status`         int                  DEFAULT '0' COMMENT '1: Created 2: Published 3: Offline 4: Deleted',
    `embedded_model` varchar(20)          DEFAULT NULL COMMENT 'Embedded model',
    `index_type`     int                  DEFAULT NULL COMMENT 'Index method 0: High quality 1: Low quality',
    `visibility`     int                  DEFAULT '0' COMMENT 'Visibility 0: Only visible to self 1: Visible to some users',
    `source`         int                  DEFAULT '0' COMMENT 'Source 0: Web created 1: API created',
    `enable_audit`   tinyint(1) DEFAULT '0' COMMENT 'Whether to enable content review 0: Disable 1: Enable (default)',
    `deleted`        tinyint(1) DEFAULT '0' COMMENT 'Whether deleted: 1-Deleted, 0-Not deleted',
    `create_time`    timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time`    timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `is_top`         bit(1)               DEFAULT b'0',
    `tag`            varchar(64) NOT NULL DEFAULT 'CBG-RAG' COMMENT 'Knowledge base type tag, CBG-RAG: CBG knowledge base, AIUI-RAG2: AIUI knowledge base',
    `space_id`       bigint               DEFAULT NULL COMMENT 'Team space ID',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for req_knowledge_records
-- ----------------------------
DROP TABLE IF EXISTS `req_knowledge_records`;
CREATE TABLE `req_knowledge_records`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) DEFAULT NULL,
    `req_id`      bigint        DEFAULT NULL COMMENT 'Primary key of user question, corresponding to primary key ID of user question table',
    `req_message` varchar(8000) DEFAULT NULL COMMENT 'User question content',
    `knowledge`   varchar(4096) DEFAULT NULL COMMENT 'Retrieved knowledge',
    `create_time` datetime      DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `chat_id`     bigint        DEFAULT NULL COMMENT 'Chat window ID, chat_list primary key',
    PRIMARY KEY (`id`),
    KEY           `idx_uid_req` (`uid`,`req_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Knowledge retrieval result record table';

-- ----------------------------
-- Table structure for rpa_info
-- ----------------------------
DROP TABLE IF EXISTS `rpa_info`;
CREATE TABLE `rpa_info`
(
    `id`          bigint NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `category`    varchar(64)   DEFAULT NULL COMMENT 'RPA category',
    `name`        varchar(255)  DEFAULT NULL COMMENT 'RPA name',
    `value`       text COMMENT 'Configuration content',
    `is_deleted`  tinyint       DEFAULT '0' COMMENT 'Whether effective, 0-invalid, 1-valid',
    `remarks`     varchar(1000) DEFAULT NULL COMMENT 'Notes, remarks',
    `icon`        varchar(150)  DEFAULT NULL,
    `create_time` datetime      DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time` datetime      DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='RPA configuration table';

-- ----------------------------
-- Table structure for rpa_user_assistant
-- ----------------------------
DROP TABLE IF EXISTS `rpa_user_assistant`;
CREATE TABLE `rpa_user_assistant`
(
    `id`             bigint                                                       NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `user_id`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Belonging user ID',
    `platform_id`    bigint                                                       NOT NULL COMMENT 'rpa_info.id (Platform definition)',
    `assistant_name` varchar(128)                                                 NOT NULL COMMENT 'Assistant name (unique under same user)',
    `status`         tinyint                                                      NOT NULL DEFAULT '1' COMMENT 'Status: 1-enable, 0-disable',
    `remarks`        varchar(1000)                                                         DEFAULT NULL COMMENT 'Notes, remarks',
    `icon`           varchar(100)                                                          DEFAULT NULL,
    `robot_count`    int                                                                   DEFAULT NULL,
    `space_id`       bigint                                                                DEFAULT NULL,
    `create_time`    datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`    datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_assistant_name` (`user_id`,`assistant_name`),
    KEY              `idx_user` (`user_id`),
    KEY              `fk_rpa_platform` (`platform_id`),
    CONSTRAINT `fk_rpa_platform` FOREIGN KEY (`platform_id`) REFERENCES `rpa_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User-level RPA assistant main table';

-- ----------------------------
-- Table structure for rpa_user_assistant_field
-- ----------------------------
DROP TABLE IF EXISTS `rpa_user_assistant_field`;
CREATE TABLE `rpa_user_assistant_field`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `assistant_id` bigint       NOT NULL COMMENT 'rpa_user_assistant.id',
    `field_key`    varchar(128) NOT NULL COMMENT 'Field key (consistent with rpa_info.value[].name, such as apiKey)',
    `field_name`   varchar(255)          DEFAULT NULL COMMENT 'Field readable name (such as API KEY), redundant for audit convenience',
    `field_value`  text         NOT NULL COMMENT 'Field plain text value (not encrypted)',
    `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_assistant_field` (`assistant_id`,`field_key`),
    KEY            `idx_assistant` (`assistant_id`),
    CONSTRAINT `fk_assistant_field` FOREIGN KEY (`assistant_id`) REFERENCES `rpa_user_assistant` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User RPA assistant field table (plain text)';

-- ----------------------------
-- Table structure for share_chat
-- ----------------------------
DROP TABLE IF EXISTS `share_chat`;
CREATE TABLE `share_chat`
(
    `id`                 bigint NOT NULL AUTO_INCREMENT COMMENT 'Corresponding to share_key of chat_share_content',
    `uid`                varchar(128)    DEFAULT NULL COMMENT 'Sharing user UID',
    `url_key`            varchar(64)     DEFAULT NULL COMMENT 'Include key parameter in frontend URL to prevent scraping',
    `chat_id`            bigint          DEFAULT NULL COMMENT 'Primary key of shared conversation chat_list',
    `bot_id`             bigint          DEFAULT '0' COMMENT 'Assistant ID in assistant mode, 0 for normal mode',
    `click_times`        int             DEFAULT '0' COMMENT 'Click count',
    `max_click_times`    int             DEFAULT '-1' COMMENT 'Redundant, can limit maximum click count, default -1 means unlimited',
    `url_status`         tinyint         DEFAULT '1' COMMENT 'Whether link is valid: 0 invalid, 1 valid',
    `create_time`        datetime        DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`        datetime        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `enabled_plugin_ids` varchar(255)    DEFAULT '' COMMENT 'Currently enabled plugin IDs for this conversation list',
    `like_times`         int    NOT NULL DEFAULT '0' COMMENT 'Like count',
    `ip_location`        varchar(32)     DEFAULT '' COMMENT 'IP location when sharing',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_url_key` (`url_key`) USING BTREE,
    KEY                  `idx_bot_id` (`bot_id`),
    KEY                  `idx_enabled_plugin_ids` (`enabled_plugin_ids`),
    KEY                  `idx_create_time` (`create_time`),
    KEY                  `idx_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Conversation sharing information index table';

-- ----------------------------
-- Table structure for share_qa
-- ----------------------------
DROP TABLE IF EXISTS `share_qa`;
CREATE TABLE `share_qa`
(
    `id`            bigint NOT NULL AUTO_INCREMENT,
    `uid`           varchar(128)  DEFAULT NULL COMMENT 'User ID',
    `share_chat_id` bigint        DEFAULT NULL COMMENT 'Corresponding to primary key ID of share_chat',
    `message_q`     varchar(8000) DEFAULT NULL COMMENT 'Question content',
    `message_a`     mediumtext COMMENT 'Answer content',
    `sid`           varchar(128)  DEFAULT NULL COMMENT 'Answer SID',
    `show_status`   tinyint       DEFAULT '1' COMMENT 'Whether valid: 1 valid, 0 invalid',
    `create_time`   datetime      DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `req_id`        bigint        DEFAULT NULL COMMENT 'User question, chat_req_records primary key ID',
    `req_type`      tinyint       DEFAULT '0' COMMENT 'Multimodal question type',
    `req_url`       text COMMENT 'Multimodal question URL',
    `resp_id`       bigint        DEFAULT '0' COMMENT 'Primary key ID of answer table',
    `resp_type`     varchar(128)  DEFAULT NULL COMMENT 'Multimodal return type',
    `resp_url`      varchar(512)  DEFAULT NULL COMMENT 'Multimodal return URL',
    `chat_key`      varchar(64)   DEFAULT NULL COMMENT 'Identifier for direct conversation on sharing page, same function as chatId',
    PRIMARY KEY (`id`),
    KEY             `uin_uid_share-chat-id` (`uid`,`share_chat_id`),
    KEY             `idx_uid` (`uid`),
    KEY             `idx_resp_type` (`resp_type`),
    KEY             `idx_share_chat_id` (`share_chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Conversation sharing Q&A content table';

-- ----------------------------
-- Table structure for spark_bot
-- ----------------------------
DROP TABLE IF EXISTS `spark_bot`;
CREATE TABLE `spark_bot`
(
    `id`             bigint      NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `uuid`           varchar(64)          DEFAULT NULL,
    `name`           varchar(64) NOT NULL COMMENT 'Robot name',
    `user_id`        varchar(20)          DEFAULT NULL,
    `app_id`         varchar(50) NOT NULL,
    `description`    varchar(255)         DEFAULT NULL COMMENT 'Description',
    `avatar_icon`    varchar(255)         DEFAULT NULL COMMENT 'Avatar icon',
    `color`          varchar(10)          DEFAULT NULL,
    `floating_icon`  varchar(255)         DEFAULT NULL COMMENT 'Floating window icon',
    `greeting`       varchar(128)         DEFAULT NULL COMMENT 'Greeting',
    `floated`        tinyint(1) DEFAULT '0' COMMENT 'Whether set as floating robot 0: not set, 1: set',
    `deleted`        tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Whether deleted: 1-deleted, 0-not deleted',
    `create_time`    timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time`    timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `recommend_ques` text,
    `is_public`      tinyint     NOT NULL DEFAULT '0' COMMENT 'Whether public bot: 0 no, 1 yes',
    `bot_tag`        varchar(100)         DEFAULT NULL COMMENT 'Bot tag',
    `user_count`     int                  DEFAULT '0' COMMENT 'User count',
    `dialog_count`   int                  DEFAULT '0' COMMENT 'Conversation count',
    `favorite_count` int                  DEFAULT '0' COMMENT 'Favorite count',
    `public_id`      bigint               DEFAULT NULL COMMENT 'Public bot ID',
    `app_updatable`  bit(1)               DEFAULT b'0',
    `top`            bit(1)               DEFAULT b'0',
    `eval_set_id`    bigint               DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for system_user
-- ----------------------------
DROP TABLE IF EXISTS `system_user`;
CREATE TABLE `system_user`
(
    `id`                bigint NOT NULL COMMENT 'User ID',
    `nickname`          varchar(20)  DEFAULT NULL COMMENT 'Username',
    `login`             varchar(20)  DEFAULT NULL COMMENT 'User login name',
    `email`             varchar(128) DEFAULT NULL COMMENT 'Email',
    `mobile`            varchar(20)  DEFAULT NULL COMMENT 'Mobile number',
    `last_login_time`   datetime     DEFAULT NULL COMMENT 'Last login time',
    `registration_time` datetime     DEFAULT NULL COMMENT 'Registration time',
    `create_time`       datetime     DEFAULT NULL COMMENT 'Creation time',
    `update_by`         bigint       DEFAULT NULL,
    `is_delete`         tinyint(1) DEFAULT '0' COMMENT 'Logical deletion, 0=not deleted, 1=deleted',
    `update_time`       datetime     DEFAULT NULL,
    `source`            tinyint      DEFAULT '1',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for tag_info_v2
-- ----------------------------
DROP TABLE IF EXISTS `tag_info_v2`;
CREATE TABLE `tag_info_v2`
(
    `id`          bigint    NOT NULL AUTO_INCREMENT,
    `name`        varchar(64)        DEFAULT NULL COMMENT 'Tag name',
    `type`        int                DEFAULT NULL COMMENT 'Type 1: knowledge base, 2: folder, 3: file, 4: knowledge block',
    `relation_id` varchar(50)        DEFAULT NULL COMMENT 'Used to isolate tags between different entities',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `uid`         varchar(128)       DEFAULT NULL,
    `repo_id`     bigint             DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY           `type_rel_idx` (`type`,`relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for text_node_config
-- ----------------------------
DROP TABLE IF EXISTS `text_node_config`;
CREATE TABLE `text_node_config`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) NOT NULL,
    `separator`   varchar(255)          DEFAULT NULL,
    `comment`     varchar(255)          DEFAULT NULL,
    `deleted`     bit(1)       NOT NULL DEFAULT b'0',
    `create_time` datetime              DEFAULT NULL,
    `update_time` datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for tool_box
-- ----------------------------
DROP TABLE IF EXISTS `tool_box`;
CREATE TABLE `tool_box`
(
    `id`              bigint  NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `tool_id`         varchar(30)      DEFAULT NULL COMMENT 'Core system tool identifier',
    `name`            varchar(64)      DEFAULT NULL COMMENT 'Tool name',
    `description`     varchar(255)     DEFAULT NULL COMMENT 'Tool description',
    `icon`            varchar(255)     DEFAULT NULL COMMENT 'Avatar icon',
    `user_id`         varchar(256)     DEFAULT NULL COMMENT 'User ID',
    `app_id`          varchar(60)      DEFAULT NULL COMMENT 'appid',
    `end_point`       text COMMENT 'Request address',
    `method`          varchar(255)     DEFAULT NULL COMMENT 'Request method',
    `web_schema`      longtext COMMENT 'Web protocol',
    `schema`          longtext COMMENT 'Protocol',
    `visibility`      int              DEFAULT '0' COMMENT 'Visibility 0: only visible to self, 1: visible to some users',
    `deleted`         tinyint(1) DEFAULT '0' COMMENT 'Whether deleted: 1-deleted, 0-not deleted',
    `create_time`     timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time`     timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modification time',
    `is_public`       bit(1)           DEFAULT b'0',
    `favorite_count`  int              DEFAULT '0' COMMENT 'Favorite count',
    `usage_count`     int              DEFAULT '0' COMMENT 'Usage count',
    `tool_tag`        varchar(255)     DEFAULT NULL,
    `operation_id`    varchar(255)     DEFAULT NULL,
    `creation_method` tinyint          DEFAULT '0',
    `auth_type`       tinyint          DEFAULT '0',
    `auth_info`       varchar(1024)    DEFAULT NULL,
    `top`             int              DEFAULT '0',
    `source`          tinyint          DEFAULT '1',
    `display_source`  varchar(16)      DEFAULT '1,2',
    `avatar_color`    varchar(255)     DEFAULT NULL,
    `status`          tinyint NOT NULL DEFAULT '1' COMMENT 'Status 0: draft, 1: formal',
    `version`         varchar(100)     DEFAULT NULL,
    `temporary_data`  mediumtext COMMENT 'Plugin temporary data',
    `space_id`        bigint           DEFAULT NULL COMMENT 'Space ID',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for tool_box_copy
-- ----------------------------
DROP TABLE IF EXISTS `tool_box_copy`;
CREATE TABLE `tool_box_copy`
(
    `id`              bigint NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `tool_id`         varchar(30)   DEFAULT NULL COMMENT 'Core system tool identifier',
    `name`            varchar(64)   DEFAULT NULL COMMENT 'Tool name',
    `description`     varchar(255)  DEFAULT NULL COMMENT 'Tool description',
    `icon`            varchar(255)  DEFAULT NULL COMMENT 'Avatar icon',
    `user_id`         varchar(20)   DEFAULT NULL COMMENT 'User ID',
    `app_id`          varchar(60)   DEFAULT NULL COMMENT 'appid',
    `end_point`       text COMMENT 'Request address',
    `method`          varchar(255)  DEFAULT NULL COMMENT 'Request method',
    `web_schema`      longtext COMMENT 'Web protocol',
    `schema`          longtext COMMENT 'Protocol',
    `visibility`      int           DEFAULT '0' COMMENT 'Visibility 0: only visible to self, 1: visible to some users',
    `deleted`         tinyint(1) DEFAULT '0' COMMENT 'Whether deleted: 1-deleted, 0-not deleted',
    `create_time`     timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time`     timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modification time',
    `is_public`       bit(1)        DEFAULT b'0',
    `favorite_count`  int           DEFAULT '0' COMMENT 'Favorite count',
    `usage_count`     int           DEFAULT '0' COMMENT 'Usage count',
    `tool_tag`        varchar(255)  DEFAULT NULL,
    `operation_id`    varchar(255)  DEFAULT NULL,
    `creation_method` tinyint       DEFAULT '0',
    `auth_type`       tinyint       DEFAULT '0',
    `auth_info`       varchar(1024) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for tool_box_feedback
-- ----------------------------
DROP TABLE IF EXISTS `tool_box_feedback`;
CREATE TABLE `tool_box_feedback`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `user_id`     varchar(100) NOT NULL COMMENT 'User ID',
    `tool_id`     varchar(100)          DEFAULT NULL COMMENT 'Tool ID',
    `name`        varchar(100)          DEFAULT NULL COMMENT 'Tool name',
    `remark`      varchar(1000)         DEFAULT NULL COMMENT 'Feedback content',
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for tool_box_heat_value
-- ----------------------------
DROP TABLE IF EXISTS `tool_box_heat_value`;
CREATE TABLE `tool_box_heat_value`
(
    `id`         int NOT NULL AUTO_INCREMENT,
    `tool_name`  varchar(100) DEFAULT NULL,
    `heat_value` int          DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for tool_box_operate_history
-- ----------------------------
DROP TABLE IF EXISTS `tool_box_operate_history`;
CREATE TABLE `tool_box_operate_history`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `tool_id`     varchar(100) NOT NULL COMMENT 'Plugin ID',
    `uid`         varchar(100) NOT NULL,
    `type`        tinyint      NOT NULL COMMENT '1:debug  2:workflow',
    `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Plugin debug history';

-- ----------------------------
-- Table structure for train_set
-- ----------------------------
DROP TABLE IF EXISTS `train_set`;
CREATE TABLE `train_set`
(
    `id`               bigint       NOT NULL AUTO_INCREMENT,
    `uid`              varchar(128) NOT NULL,
    `name`             varchar(512) NOT NULL,
    `description`      varchar(1024)         DEFAULT NULL,
    `current_ver`      varchar(255)          DEFAULT NULL COMMENT 'Current version',
    `ver_count`        int                   DEFAULT '0' COMMENT 'Version count',
    `deleted`          bit(1)       NOT NULL DEFAULT b'0',
    `create_time`      datetime              DEFAULT NULL,
    `update_time`      datetime              DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `application_id`   bigint                DEFAULT NULL,
    `application_type` tinyint               DEFAULT NULL,
    `node_info`        varchar(1024)         DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for train_set_ver
-- ----------------------------
DROP TABLE IF EXISTS `train_set_ver`;
CREATE TABLE `train_set_ver`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT,
    `train_set_id` bigint       NOT NULL,
    `ver`          varchar(255) NOT NULL COMMENT 'Version number',
    `filename`     varchar(512)          DEFAULT NULL COMMENT 'File name',
    `storage_addr` varchar(512)          DEFAULT NULL COMMENT 'File address',
    `deleted`      bit(1)       NOT NULL DEFAULT b'0',
    `create_time`  datetime     NOT NULL,
    `update_time`  datetime     NOT NULL,
    `description`  varchar(255)          DEFAULT NULL,
    `node_info`    varchar(1024)         DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for train_set_ver_data
-- ----------------------------
DROP TABLE IF EXISTS `train_set_ver_data`;
CREATE TABLE `train_set_ver_data`
(
    `id`               bigint   NOT NULL AUTO_INCREMENT,
    `train_set_ver_id` bigint   NOT NULL,
    `seq`              int           DEFAULT NULL,
    `question`         varchar(2048) DEFAULT NULL,
    `expected_answer`  varchar(5096) DEFAULT NULL,
    `sid`              varchar(256)  DEFAULT NULL,
    `create_time`      datetime NOT NULL,
    `deleted`          bit(1)        DEFAULT b'0',
    `source`           tinyint       DEFAULT '1' COMMENT '1=file, 2=online data',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for untitled_table
-- ----------------------------
DROP TABLE IF EXISTS `untitled_table`;
CREATE TABLE `untitled_table`
(
    `id`            int unsigned NOT NULL AUTO_INCREMENT,
    `created_tme`   datetime NOT NULL                                             DEFAULT CURRENT_TIMESTAMP,
    `domain`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `baseModelId`   bigint                                                        DEFAULT NULL,
    `baseModelName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for upload_doc_task
-- ----------------------------
DROP TABLE IF EXISTS `upload_doc_task`;
CREATE TABLE `upload_doc_task`
(
    `id`              bigint NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `task_id`         varchar(64) DEFAULT NULL COMMENT 'Task ID',
    `extract_task_id` varchar(64) DEFAULT NULL COMMENT 'Knowledge extraction task ID',
    `file_id`         bigint      DEFAULT NULL COMMENT 'File ID',
    `bot_id`          bigint      DEFAULT NULL COMMENT 'botID',
    `repo_id`         varchar(64) DEFAULT NULL COMMENT 'Knowledge base ID',
    `step`            int         DEFAULT NULL COMMENT 'Processing steps 0: upload file, 1: parse file, 2: embed file, 3: bot bind knowledge base',
    `status`          int         DEFAULT '0' COMMENT '0: in progress, 1: success, 2: failed',
    `reason`          text,
    `app_id`          varchar(60) DEFAULT NULL COMMENT 'User ID',
    `create_time`     timestamp NULL DEFAULT NULL COMMENT 'Creation time',
    `update_time`     timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modification time',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for user_broadcast_read
-- ----------------------------
DROP TABLE IF EXISTS `user_broadcast_read`;
CREATE TABLE `user_broadcast_read`
(
    `id`              bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `receiver_uid`    varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'User ID',
    `notification_id` bigint unsigned NOT NULL COMMENT 'Associated broadcast notification ID (notifications.id)',
    `read_at`         datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'Read time',
    PRIMARY KEY (`id`),
    KEY               `idx_receiver_uid` (`receiver_uid`),
    KEY               `idx_notification` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User broadcast message read status table';

-- ----------------------------
-- Table structure for user_favorite_bot
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite_bot`;
CREATE TABLE `user_favorite_bot`
(
    `id`           bigint    NOT NULL AUTO_INCREMENT,
    `user_id`      bigint    NOT NULL,
    `bot_id`       bigint    NOT NULL,
    `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `use_flag`     tinyint            DEFAULT '0',
    `is_deleted`   tinyint            DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY            `idx_user_favorite_bot_user_id` (`user_id`),
    KEY            `idx_user_favorite_bot_bot_id` (`bot_id`),
    CONSTRAINT `user_favorite_bot_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `system_user` (`id`),
    CONSTRAINT `user_favorite_bot_ibfk_2` FOREIGN KEY (`bot_id`) REFERENCES `spark_bot` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_favorite_tool
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite_tool`;
CREATE TABLE `user_favorite_tool`
(
    `id`             bigint       NOT NULL AUTO_INCREMENT,
    `user_id`        varchar(128) NOT NULL,
    `tool_id`        bigint       NOT NULL,
    `tool_flag_id`   varchar(30)           DEFAULT NULL,
    `created_time`   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted`     tinyint               DEFAULT '0',
    `use_flag`       tinyint               DEFAULT '0' COMMENT 'Usage flag',
    `mcp_tool_id`    varchar(100)          DEFAULT NULL,
    `plugin_tool_id` varchar(100)          DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY              `idx_user_favorite_tool_user_id` (`user_id`),
    KEY              `idx_user_favorite_tool_tool_id` (`tool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info`
(
    `id`             bigint NOT NULL AUTO_INCREMENT COMMENT 'Non-business primary key',
    `uid`            varchar(128)                                                  DEFAULT NULL COMMENT 'UID',
    `username`       varchar(255)                                                  DEFAULT NULL COMMENT 'Username',
    `avatar`         varchar(512)                                                  DEFAULT NULL COMMENT 'Avatar',
    `nickname`       varchar(255)                                                  DEFAULT NULL COMMENT 'User nickname',
    `mobile`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Mobile number',
    `account_status` tinyint                                                       DEFAULT '0' COMMENT 'Activation status: 0 inactive, 1 active, 2 frozen',
    `enterprise_service_type` int                                                  DEFAULT '0' COMMENT 'Enterprise service type: 0 none, 1 team, 2 enterprise',
    `user_agreement` tinyint                                                       DEFAULT '0' COMMENT 'Whether agreed to user agreement: 0 not agreed, 1 agreed',
    `deleted`        tinyint                                                       DEFAULT '0' COMMENT 'Logical deletion flag: 0 not deleted, 1 deleted',
    `create_time`    datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`    datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uid_unique_index` (`uid`),
    KEY              `idx_create_time` (`create_time`),
    KEY              `index_mobile` (`mobile`),
    KEY              `idx_username` (`username`),
    KEY              `idx_nickname` (`nickname`),
    KEY              `idx_deleted` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User information table';

-- ----------------------------
-- Table structure for user_lang_chain_info
-- ----------------------------
DROP TABLE IF EXISTS `user_lang_chain_info`;
CREATE TABLE `user_lang_chain_info`
(
    `id`                  bigint                                                        NOT NULL AUTO_INCREMENT COMMENT 'Non-business primary key',
    `bot_id`              int                                                           NOT NULL COMMENT 'Agent ID',
    `name`                varchar(255) DEFAULT NULL COMMENT 'LangChain name',
    `desc`                text COMMENT 'Agent description',
    `open`                json         DEFAULT NULL COMMENT 'Open configuration information, including nodes and edges',
    `gcy`                 json         DEFAULT NULL COMMENT 'GCY configuration information, including virtual nodes and edges',
    `uid`                 varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'User ID',
    `flow_id`             varchar(64)  DEFAULT NULL COMMENT 'Process ID',
    `space_id`            bigint       DEFAULT NULL,
    `maas_id`             bigint       DEFAULT NULL COMMENT 'Group ID',
    `bot_name`            varchar(255) DEFAULT NULL COMMENT 'Agent name',
    `extra_inputs`        json         DEFAULT NULL COMMENT 'Extra input items',
    `extra_inputs_config` json         DEFAULT NULL COMMENT 'Multi-file parameters',
    `create_time`         datetime     DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`         datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY                   `idx_bot_id` (`bot_id`),
    KEY                   `idx_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workflow configuration table';

-- ----------------------------
-- Table structure for user_lang_chain_log
-- ----------------------------
DROP TABLE IF EXISTS `user_lang_chain_log`;
CREATE TABLE `user_lang_chain_log`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT,
    `bot_id`      bigint                                                        DEFAULT NULL,
    `maas_id`     bigint                                                        DEFAULT NULL,
    `flow_id`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  DEFAULT NULL,
    `uid`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
    `space_id`    bigint                                                        DEFAULT NULL,
    `create_time` datetime NOT NULL                                             DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL                                             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY           `idx_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_notifications
-- ----------------------------
DROP TABLE IF EXISTS `user_notifications`;
CREATE TABLE `user_notifications`
(
    `id`              bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `notification_id` bigint unsigned NOT NULL COMMENT 'Associated notification ID (notifications.id)',
    `receiver_uid`    varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Receiver user ID',
    `is_read`         tinyint                                                       NOT NULL DEFAULT '0' COMMENT 'Whether read (0=unread, 1=read)',
    `read_at`         datetime(3) DEFAULT NULL COMMENT 'Read time',
    `received_at`     datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'Receive time',
    `extra`           json                                                                   DEFAULT NULL COMMENT 'Extra data, JSON format, for storing user-specific additional information',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_user_notification` (`notification_id`,`receiver_uid`),
    KEY               `idx_user_unread` (`receiver_uid`,`is_read`,`received_at` DESC),
    KEY               `idx_notification` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User personal message association table';

-- ----------------------------
-- Table structure for user_thread_pool_config
-- ----------------------------
DROP TABLE IF EXISTS `user_thread_pool_config`;
CREATE TABLE `user_thread_pool_config`
(
    `id`   bigint                                                        NOT NULL AUTO_INCREMENT,
    `uid`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'User ID',
    `size` int                                                           NOT NULL COMMENT 'Thread pool size',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for vcn_info
-- ----------------------------
DROP TABLE IF EXISTS `vcn_info`;
CREATE TABLE `vcn_info`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `vcn`         varchar(255)  DEFAULT NULL,
    `name`        varchar(255)  DEFAULT NULL,
    `style`       varchar(255)  DEFAULT NULL,
    `emt`         varchar(255)  DEFAULT NULL,
    `image_url`   varchar(1024) DEFAULT NULL,
    `create_time` datetime      DEFAULT NULL,
    `valid`       bit(1)        DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for voice_chat_personality_agent
-- ----------------------------
DROP TABLE IF EXISTS `voice_chat_personality_agent`;
CREATE TABLE `voice_chat_personality_agent`
(
    `id`                      bigint                                                       NOT NULL AUTO_INCREMENT,
    `uid`                     bigint                                                                DEFAULT NULL,
    `player_id`               varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci          DEFAULT '' COMMENT 'Role ID',
    `agent_id`                varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'Personality engine ID',
    `vcn_id`                  bigint                                                                DEFAULT NULL COMMENT 'Speaker ID',
    `agent_name`              varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci          DEFAULT '' COMMENT 'Personality name',
    `agent_type`              varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci          DEFAULT '' COMMENT 'Personality type',
    `player_call`             varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci          DEFAULT '' COMMENT 'Personality addressing for user',
    `identity`                varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci         DEFAULT '' COMMENT 'Background',
    `personality_description` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci        DEFAULT '' COMMENT 'Personality description',
    `image_url`               varchar(2250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci        DEFAULT '' COMMENT 'Avatar address',
    `is_open`                 tinyint                                                               DEFAULT NULL COMMENT 'Whether enabled, 0-no, 1-yes',
    `is_del`                  tinyint                                                               DEFAULT NULL COMMENT 'Whether deleted, 0-no, 1-yes',
    `create_time`             datetime                                                              DEFAULT CURRENT_TIMESTAMP,
    `update_time`             datetime                                                              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `virtual_url`             varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci        DEFAULT NULL COMMENT 'Virtual character avatar',
    PRIMARY KEY (`id`),
    KEY                       `idx_agent_id` (`agent_id`),
    KEY                       `idx_agent_name` (`agent_name`),
    KEY                       `idx_uid` (`uid`),
    KEY                       `idx_vcn_id` (`vcn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Super-anthropomorphic personality role details table';

-- ----------------------------
-- Table structure for workflow
-- ----------------------------
DROP TABLE IF EXISTS `workflow`;
CREATE TABLE `workflow`
(
    `id`                   bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `uid`                  varchar(128) NOT NULL COMMENT 'User ID',
    `app_id`               varchar(255) NOT NULL,
    `flow_id`              varchar(255)          DEFAULT NULL,
    `name`                 varchar(255) NOT NULL,
    `description`          varchar(512) NOT NULL,
    `deleted`              bit(1)       NOT NULL DEFAULT b'0',
    `is_public`            bit(1)       NOT NULL DEFAULT b'0',
    `create_time`          datetime     NOT NULL,
    `update_time`          datetime              DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `published_data`       mediumtext,
    `data`                 mediumtext,
    `avatar_icon`          varchar(1000)         DEFAULT NULL,
    `avatar_color`         varchar(255)          DEFAULT NULL,
    `status`               tinyint      NOT NULL DEFAULT '-1' COMMENT '0=not published, 1=published',
    `can_publish`          bit(1)                DEFAULT b'0',
    `app_updatable`        bit(1)                DEFAULT b'0',
    `top`                  bit(1)                DEFAULT b'0',
    `edge_type`            varchar(255)          DEFAULT NULL,
    `order`                int                   DEFAULT '0',
    `eval_set_id`          bigint                DEFAULT NULL,
    `source`               tinyint               DEFAULT '1',
    `bak`                  mediumtext,
    `editing`              bit(1)                DEFAULT b'1',
    `eval_page_first_time` text,
    `advanced_config`      text COMMENT 'Advanced configuration',
    `ext`                  text,
    `category`             int                   DEFAULT NULL COMMENT 'Category',
    `space_id`             bigint                DEFAULT NULL COMMENT 'Space ID',
    PRIMARY KEY (`id`) USING BTREE,
    KEY                    `flow_id` (`flow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for workflow_comparison
-- ----------------------------
DROP TABLE IF EXISTS `workflow_comparison`;
CREATE TABLE `workflow_comparison`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `flow_id`     varchar(100) NOT NULL COMMENT 'flowId',
    `type`        tinyint      NOT NULL DEFAULT '0' COMMENT 'Protocol type',
    `data`        mediumtext   NOT NULL COMMENT 'Workflow protocol',
    `create_time` datetime     NOT NULL COMMENT 'Creation time',
    `update_time` datetime     NOT NULL COMMENT 'Update time',
    `prompt_id`   varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workflow control group protocol';

-- ----------------------------
-- Table structure for workflow_dialog
-- ----------------------------
DROP TABLE IF EXISTS `workflow_dialog`;
CREATE TABLE `workflow_dialog`
(
    `id`            bigint  NOT NULL AUTO_INCREMENT,
    `uid`           varchar(128)     DEFAULT NULL,
    `workflow_id`   bigint           DEFAULT NULL,
    `question`      text,
    `answer`        longtext,
    `data`          mediumtext,
    `create_time`   datetime         DEFAULT NULL,
    `deleted`       bit(1)           DEFAULT b'0',
    `sid`           varchar(255)     DEFAULT NULL,
    `type`          tinyint NOT NULL DEFAULT '1' COMMENT '1：debug 2：formal',
    `question_item` text,
    `answer_item`   longtext,
    `chat_id`       varchar(100)     DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    KEY             `workflow_id` (`workflow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for workflow_dialog_bak
-- ----------------------------
DROP TABLE IF EXISTS `workflow_dialog_bak`;
CREATE TABLE `workflow_dialog_bak`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) DEFAULT NULL,
    `workflow_id` bigint       DEFAULT NULL,
    `question`    text,
    `answer`      text,
    `data`        mediumtext,
    `create_time` datetime     DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    KEY           `workflow_id` (`workflow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for workflow_feedback
-- ----------------------------
DROP TABLE IF EXISTS `workflow_feedback`;
CREATE TABLE `workflow_feedback`
(
    `id`          bigint       NOT NULL AUTO_INCREMENT,
    `uid`         varchar(128) NOT NULL COMMENT 'User ID',
    `user_name`   varchar(100) NOT NULL COMMENT 'User name',
    `bot_id`      varchar(100) NOT NULL,
    `flow_id`     varchar(100) NOT NULL,
    `sid`         varchar(100) NOT NULL,
    `start_time`  datetime      DEFAULT NULL,
    `end_time`    datetime      DEFAULT NULL,
    `cost_time`   int           DEFAULT NULL COMMENT 'Cost time',
    `token`       int           DEFAULT NULL COMMENT 'Token consumption count',
    `status`      varchar(100)  DEFAULT NULL COMMENT 'Status',
    `error_code`  varchar(100)  DEFAULT NULL,
    `pic_url`     text COMMENT 'Feedback image URL',
    `description` varchar(1024) DEFAULT NULL COMMENT 'Description',
    `create_time` datetime      DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Workflow user feedback';

-- ----------------------------
-- Table structure for workflow_node_history
-- ----------------------------
DROP TABLE IF EXISTS `workflow_node_history`;
CREATE TABLE `workflow_node_history`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT,
    `node_id`      varchar(255) NOT NULL,
    `chat_id`      varchar(255) DEFAULT NULL,
    `raw_question` text,
    `raw_answer`   text,
    `create_time`  datetime     NOT NULL,
    `flow_id`      varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY            `node_id` (`node_id`),
    KEY            `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for workflow_template_group
-- ----------------------------
DROP TABLE IF EXISTS `workflow_template_group`;
CREATE TABLE `workflow_template_group`
(
    `id`            int         NOT NULL AUTO_INCREMENT COMMENT 'Non-business primary key',
    `create_user`   varchar(32) NOT NULL COMMENT 'Publisher domain account',
    `group_name`    varchar(20) NOT NULL COMMENT 'Group name',
    `sort_index`    int         NOT NULL COMMENT 'Sort order',
    `is_delete`     tinyint     NOT NULL DEFAULT '0' COMMENT 'Whether logical deletion: 0 no logical deletion, 1 logical deletion',
    `create_time`   datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`   datetime    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    `group_name_en` varchar(128)         DEFAULT NULL COMMENT 'Group English name',
    PRIMARY KEY (`id`),
    KEY             `idx_group_name` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Xingchen workflow template grouping (comprehensive management control)';

-- ----------------------------
-- Table structure for workflow_version
-- ----------------------------
DROP TABLE IF EXISTS `workflow_version`;
CREATE TABLE `workflow_version`
(
    `id`               bigint       NOT NULL AUTO_INCREMENT,
    `name`             varchar(100)          DEFAULT NULL COMMENT 'Version name',
    `version_num`      varchar(100) NOT NULL COMMENT 'Version number',
    `data`             mediumtext COMMENT 'Workflow protocol',
    `flow_id`          varchar(19)  NOT NULL,
    `is_deleted`       int          NOT NULL DEFAULT '0' COMMENT 'Delete status: 0=not deleted, 1=deleted',
    `deleted`          int          NOT NULL DEFAULT '1' COMMENT '2: deleted',
    `created_time`     datetime              DEFAULT CURRENT_TIMESTAMP COMMENT 'Publish time',
    `updated_time`     datetime              DEFAULT CURRENT_TIMESTAMP,
    `is_current`       int          NOT NULL DEFAULT '1' COMMENT 'Whether current version: 0=no, 1=yes',
    `is_version`       int          NOT NULL DEFAULT '1' COMMENT '2: not current version, 1: current version',
    `sys_data`         mediumtext COMMENT 'Core system protocol',
    `description`      varchar(100)          DEFAULT NULL COMMENT 'Version description',
    `publish_channels` varchar(255)          DEFAULT NULL COMMENT 'Publishing channels, consistent with chat_bot_market: MARKET,API,WECHAT,MCP (comma separated)',
    `publish_channel`  int                   DEFAULT NULL COMMENT 'Publishing channel: 1: WeChat official account, 2: Spark desk, 3: API, 4: MCP',
    `publish_result`   text COMMENT 'Publish result',
    `bot_id`           varchar(100)          DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for xingchen_official_prompt
-- ----------------------------
DROP TABLE IF EXISTS `xingchen_official_prompt`;
CREATE TABLE `xingchen_official_prompt`
(
    `id`             bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `name`           varchar(255) NOT NULL COMMENT 'Prompt name',
    `prompt_key`     varchar(255) NOT NULL COMMENT 'Prompt unique identifier key',
    `uid`            varchar(128) NOT NULL DEFAULT '0' COMMENT 'User ID',
    `type`           tinyint      NOT NULL DEFAULT '0' COMMENT 'Prompt type',
    `latest_version` varchar(50)           DEFAULT '' COMMENT 'Latest version number',
    `model_config`   json         NOT NULL COMMENT 'Model configuration information (JSON format)',
    `prompt_text`    json         NOT NULL COMMENT 'Prompt text content (JSON format)',
    `prompt_input`   json         NOT NULL COMMENT 'Prompt input variable configuration (JSON format)',
    `status`         tinyint      NOT NULL DEFAULT '0' COMMENT 'Status: 0-normal, 1-disabled',
    `is_delete`      tinyint      NOT NULL DEFAULT '0' COMMENT 'Whether deleted: 0-no, 1-yes',
    `commit_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Commit time',
    `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_prompt_key` (`prompt_key`),
    KEY              `idx_uid` (`uid`),
    KEY              `idx_type` (`type`),
    KEY              `idx_status` (`status`),
    KEY              `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Xingchen official Prompt table';

-- ----------------------------
-- Table structure for xingchen_prompt_manage
-- ----------------------------
DROP TABLE IF EXISTS `xingchen_prompt_manage`;
CREATE TABLE `xingchen_prompt_manage`
(
    `id`              bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `name`            varchar(500) NOT NULL COMMENT 'Prompt name',
    `prompt_key`      varchar(255) NOT NULL COMMENT 'Prompt unique identifier key',
    `uid`             varchar(128) NOT NULL COMMENT 'User ID',
    `type`            tinyint      NOT NULL DEFAULT '0' COMMENT 'Prompt type',
    `latest_version`  varchar(50)           DEFAULT '' COMMENT 'Latest version number',
    `current_version` varchar(50)           DEFAULT '' COMMENT 'Current version number',
    `model_config`    json         NOT NULL COMMENT 'Model configuration information (JSON format)',
    `prompt_text`     json         NOT NULL COMMENT 'Prompt text content (JSON format)',
    `prompt_input`    json         NOT NULL COMMENT 'Prompt input variable configuration (JSON format)',
    `status`          tinyint      NOT NULL DEFAULT '0' COMMENT 'Status: 0-Normal, 1-Disabled',
    `is_delete`       tinyint      NOT NULL DEFAULT '0' COMMENT 'Is deleted: 0-No, 1-Yes',
    `commit_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Commit time',
    `create_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_prompt_key_uid` (`prompt_key`,`uid`),
    KEY               `idx_uid` (`uid`),
    KEY               `idx_type` (`type`),
    KEY               `idx_status` (`status`),
    KEY               `idx_latest_version` (`latest_version`),
    KEY               `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Xingchen Prompt management table';

-- ----------------------------
-- Table structure for xingchen_prompt_version
-- ----------------------------
DROP TABLE IF EXISTS `xingchen_prompt_version`;
CREATE TABLE `xingchen_prompt_version`
(
    `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT 'Primary key ID',
    `prompt_id`    varchar(50)  NOT NULL COMMENT 'Associated Prompt ID',
    `uid`          varchar(128) NOT NULL COMMENT 'User ID',
    `version`      varchar(50)  NOT NULL COMMENT 'Version number',
    `version_desc` text COMMENT 'Version description',
    `commit_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Commit time',
    `commit_user`  varchar(128) NOT NULL COMMENT 'Commit user ID',
    `model_config` json         NOT NULL COMMENT 'Model configuration information (JSON format)',
    `prompt_text`  json         NOT NULL COMMENT 'Prompt text content (JSON format)',
    `prompt_input` json         NOT NULL COMMENT 'Prompt input variable configuration (JSON format)',
    `is_delete`    tinyint      NOT NULL DEFAULT '0' COMMENT 'Is deleted: 0-No, 1-Yes',
    `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
    PRIMARY KEY (`id`),
    KEY            `idx_prompt_id` (`prompt_id`),
    KEY            `idx_uid` (`uid`),
    KEY            `idx_version` (`version`),
    KEY            `idx_commit_user` (`commit_user`),
    KEY            `idx_commit_time` (`commit_time`),
    KEY            `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Xingchen Prompt version management table';

-- ----------------------------
-- Table structure for z-bot_model_config_copy
-- ----------------------------
DROP TABLE IF EXISTS `z-bot_model_config_copy`;
CREATE TABLE `z-bot_model_config_copy`
(
    `id`           bigint NOT NULL AUTO_INCREMENT,
    `bot_id`       bigint NOT NULL COMMENT 'Bot ID',
    `model_config` text   NOT NULL COMMENT 'Model configuration',
    `create_time`  timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for z-bot_repo_subscript
-- ----------------------------
DROP TABLE IF EXISTS `z-bot_repo_subscript`;
CREATE TABLE `z-bot_repo_subscript`
(
    `id`          bigint      NOT NULL AUTO_INCREMENT,
    `bot_id`      bigint      NOT NULL COMMENT 'Bot ID',
    `app_id`      varchar(64) NOT NULL COMMENT 'appId',
    `repo_id`     bigint      NOT NULL COMMENT 'repoID',
    `create_time` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for z-workflow_dialog-bak
-- ----------------------------
DROP TABLE IF EXISTS `z-workflow_dialog-bak`;
CREATE TABLE `z-workflow_dialog-bak`
(
    `id`          bigint NOT NULL AUTO_INCREMENT,
    `workflow_id` bigint   DEFAULT NULL,
    `question`    text,
    `answer`      text,
    `data`        mediumtext,
    `create_time` datetime DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    KEY           `workflow_id` (`workflow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

SET
FOREIGN_KEY_CHECKS = 1;

SELECT 'astron_console DATABASE initialization completed' AS '';

ALTER TABLE astron_console.rpa_user_assistant ADD user_name varchar(100) NULL COMMENT '用户名';

ALTER TABLE astron_console.rpa_info ADD `path` varchar(100) NULL COMMENT '平台官网地址';

INSERT INTO prompt_template_en (id,uid,name,description,deleted,prompt,created_time,updated_time,node_category,adaptation_model,max_loop_count) VALUES
	 (3,-1,'Commemorative card content creation','You are a birthday commemorative card content creation assistant capable of generating background images based on the user''s input name.',0,'{
  "characterSettings": "You are a birthday commemorative card content creation assistant capable of generating personalized birthday card content based on the user''s input name and the generated background image in the following format.\\n\\nFormat:\\nTitle: ''Happy Birthday'' or ''Happy Birthday!'' (optionally with the birthday person''s name, e.g., ''[Name]:'')\\nCover Image: ![example_text](https://example.com/example.png)\\nBlessing: Generated blessing message content.",
  "thinkStep": "You are a birthday commemorative card content creation assistant capable of generating background images based on the user''s input name.",
  "userQuery": "{{to_name}}"
}','2025-07-07 17:36:41','2025-07-23 15:54:35',1,'{"name": "deepseek_v3_moe","serviceId": "xdeepseekv3","serverId": "lmbXtIcNp","domain": "xdeepseekv3","patchId": "0","type": 1,"source": 2,"url": "wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat","appId": null,"licChannel": null,"llmSource": 1,"llmId": 216,"status": 1,"info": "{\\"conc\\":2,\\"domain\\":\\"generalv3.5\\",\\"expireTs\\":\\"2025-05-31\\",\\"qps\\":2,\\"tokensPreDay\\":1000,\\"tokensTotal\\":1000,\\"llmServiceId\\":\\"bm3.5\\"}","icon": "https://oss-beijing-m8.openstorage.cn/aicloud/llm/logo/03ee07dc3b7a16136ec925ca4ed0278e.png","color": null,"desc": "DeepSeek-V3，深度求索公司发布的AI大模型"}',1),
	 (5,-1,'Podcast Creation Assistant','You are a podcast assistant capable of generating hyper-realistic synthesized voice audio based on the story text provided by the user.',0,'{
  "characterSettings": "You are a podcast assistant. You need to present audio data in the following format:\\n\\nFormat:\\n## Title\\n\\nMP3 HTML player\\n\\nStory content",
  "thinkStep": "You are a podcast assistant capable of generating hyper-realistic synthesized voice audio based on the story text provided by the user.",
  "userQuery": "{{story}}"
}','2025-07-07 17:36:41','2025-07-23 15:55:10',1,'{"name": "deepseek_v3_moe","serviceId": "xdeepseekv3","serverId": "lmbXtIcNp","domain": "xdeepseekv3","patchId": "0","type": 1,"source": 2,"url": "wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat","appId": null,"licChannel": null,"llmSource": 1,"llmId": 216,"status": 1,"info": "{\\"conc\\":2,\\"domain\\":\\"generalv3.5\\",\\"expireTs\\":\\"2025-05-31\\",\\"qps\\":2,\\"tokensPreDay\\":1000,\\"tokensTotal\\":1000,\\"llmServiceId\\":\\"bm3.5\\"}","icon": "https://oss-beijing-m8.openstorage.cn/aicloud/llm/logo/03ee07dc3b7a16136ec925ca4ed0278e.png","color": null,"desc": "DeepSeek-V3，深度求索公司发布的AI大模型"}',1),
	 (7,-1,'Defect Analysis','You are a line chart drawing expert. Based on the input JSON list of issues, you need to generate a line chart showing the trend of online issue closures.',0,'{
  "characterSettings": "",
  "thinkStep": "You are a line chart drawing expert. Based on the input JSON list of issues, you need to generate a line chart showing the trend of online issue closures. The chart should cover the period from the current date to six days prior, including the following daily metrics: total number of online issues (cumulative up to the day), number of closed issues (cumulative up to the day), number of unresolved issues (total issues up to the day minus closed issues up to the day), and number of pending fix issues (cumulative pending fix issues up to the day).",
  "userQuery": "{{data_json}}"
}','2025-07-07 17:36:41','2025-07-23 15:55:46',1,'{"name": "deepseek_v3_moe","serviceId": "xdeepseekv3","serverId": "lmbXtIcNp","domain": "xdeepseekv3","patchId": "0","type": 1,"source": 2,"url": "wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat","appId": null,"licChannel": null,"llmSource": 1,"llmId": 216,"status": 1,"info": "{\\"conc\\":2,\\"domain\\":\\"generalv3.5\\",\\"expireTs\\":\\"2025-05-31\\",\\"qps\\":2,\\"tokensPreDay\\":1000,\\"tokensTotal\\":1000,\\"llmServiceId\\":\\"bm3.5\\"}","icon": "https://oss-beijing-m8.openstorage.cn/aicloud/llm/logo/03ee07dc3b7a16136ec925ca4ed0278e.png","color": null,"desc": "DeepSeek-V3，深度求索公司发布的AI大模型"}',1);

INSERT INTO prompt_template (id,uid,name,description,deleted,prompt,created_time,updated_time,node_category,adaptation_model,max_loop_count) VALUES
	 (13,-1,'纪念卡素材创作','你是一个生日纪念卡素材创作生成助手，能够基于用户输入的姓名生成背景图片。',0,'{"characterSettings": "你是一个生日纪念卡素材创作生成助手，能够基于用户输入的姓名和生成的背景图片按照如下格式创作专属的生日纪念卡素材。

格式：
标题：''生日快乐'' 或 ''Happy Birthday！''（可加上寿星的名字，如：''[姓名]: ''）
封面图片：![example_text](https://example.com/example.png)
祝福语：生成的祝福语内容。", "thinkStep": "你是一个生日纪念卡素材创作生成助手，能够基于用户输入的姓名生成背景图片。", "userQuery": "{{to_name}}"}','2025-07-07 17:36:41','2025-07-25 10:54:12',1,'{
  "id": 141,
  "name": "DeepSeek-V3",
  "serviceId": "xdeepseekv3",
  "serverId": "lmbXtIcNp",
  "domain": "xdeepseekv3",
  "patchId": "0",
  "type": 1,
  "config": null,
  "source": 2,
  "url": "wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat",
  "appId": null,
  "licChannel": "xdeepseekv3",
  "llmSource": 1,
  "llmId": 141,
  "status": 1,
  "info": "{\\"conc\\":2,\\"domain\\":\\"generalv3.5\\",\\"expireTs\\":\\"2025-05-31\\",\\"qps\\":2,\\"tokensPreDay\\":1000,\\"tokensTotal\\":1000,\\"llmServiceId\\":\\"bm3.5\\"}",
  "icon": "https://oss-beijing-m8.openstorage.cn/atp/image/model/icon/deepseek.png",
  "tag": [],
  "modelId": null,
  "pretrainedModel": null,
  "modelType": 2,
  "color": null,
  "isThink": false,
  "multiMode": false,
  "address": null,
  "desc": "DeepSeek-V3 是一款由深度求索公司自研的MoE模型。DeepSeek-V3 多项评测成绩超越了 Qwen2.5-72B 和 Llama-3.1-405B 等其他开源模型，并在性能上和世界顶尖的闭源模型 GPT-4o 以及 Claude-3.5-Sonnet 不分伯仲。",
  "createTime": "2025-02-07T00:12:54.000+08:00",
  "updateTime": "2025-02-08T21:50:01.000+08:00"
}',1),
	 (15,-1,'播客创建助手','你是一个播客助手，你能够基于用户输入的故事文本，使用超拟人合成语音音频。',0,'{"characterSettings": "你是一个播客助手，你需要基于以下格式展示音频数据：

格式：
## 标题

mp3 html播放器

故事正文", "thinkStep": "你是一个播客助手，你能够基于用户输入的故事文本，使用超拟人合成语音音频。", "userQuery": "{{story}}"}','2025-07-07 17:36:41','2025-07-25 10:54:13',1,'{
  "id": 141,
  "name": "DeepSeek-V3",
  "serviceId": "xdeepseekv3",
  "serverId": "lmbXtIcNp",
  "domain": "xdeepseekv3",
  "patchId": "0",
  "type": 1,
  "config": null,
  "source": 2,
  "url": "wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat",
  "appId": null,
  "licChannel": "xdeepseekv3",
  "llmSource": 1,
  "llmId": 141,
  "status": 1,
  "info": "{\\"conc\\":2,\\"domain\\":\\"generalv3.5\\",\\"expireTs\\":\\"2025-05-31\\",\\"qps\\":2,\\"tokensPreDay\\":1000,\\"tokensTotal\\":1000,\\"llmServiceId\\":\\"bm3.5\\"}",
  "icon": "https://oss-beijing-m8.openstorage.cn/atp/image/model/icon/deepseek.png",
  "tag": [],
  "modelId": null,
  "pretrainedModel": null,
  "modelType": 2,
  "color": null,
  "isThink": false,
  "multiMode": false,
  "address": null,
  "desc": "DeepSeek-V3 是一款由深度求索公司自研的MoE模型。DeepSeek-V3 多项评测成绩超越了 Qwen2.5-72B 和 Llama-3.1-405B 等其他开源模型，并在性能上和世界顶尖的闭源模型 GPT-4o 以及 Claude-3.5-Sonnet 不分伯仲。",
  "createTime": "2025-02-07T00:12:54.000+08:00",
  "updateTime": "2025-02-08T21:50:01.000+08:00"
}',1),
	 (17,-1,'缺陷分析','你是一个折线图绘制专家，需要基于输入的json问题列表生成线上问题关闭趋势折线图.',0,'{"characterSettings": "", "thinkStep": "你是一个折线图绘制专家，需要基于输入的json问题列表生成线上问题关闭趋势折线图；包含当前日期到当前日期前六天期间线上问题每日趋势，包含线上问题总数（截止当日问题总数），已关闭问题数（截止当日已关闭总数），遗留未关闭问题数（截止当日问题总数减去截止当日已关闭总数），遗留待修复问题数（截止当日待修复总数）", "userQuery": "{{data_json}}"}','2025-07-07 17:36:41','2025-07-25 10:54:13',1,'{
  "id": 141,
  "name": "DeepSeek-V3",
  "serviceId": "xdeepseekv3",
  "serverId": "lmbXtIcNp",
  "domain": "xdeepseekv3",
  "patchId": "0",
  "type": 1,
  "config": null,
  "source": 2,
  "url": "wss://maas-api.cn-huabei-1.xf-yun.com/v1.1/chat",
  "appId": null,
  "licChannel": "xdeepseekv3",
  "llmSource": 1,
  "llmId": 141,
  "status": 1,
  "info": "{\\"conc\\":2,\\"domain\\":\\"generalv3.5\\",\\"expireTs\\":\\"2025-05-31\\",\\"qps\\":2,\\"tokensPreDay\\":1000,\\"tokensTotal\\":1000,\\"llmServiceId\\":\\"bm3.5\\"}",
  "icon": "https://oss-beijing-m8.openstorage.cn/atp/image/model/icon/deepseek.png",
  "tag": [],
  "modelId": null,
  "pretrainedModel": null,
  "modelType": 2,
  "color": null,
  "isThink": false,
  "multiMode": false,
  "address": null,
  "desc": "DeepSeek-V3 是一款由深度求索公司自研的MoE模型。DeepSeek-V3 多项评测成绩超越了 Qwen2.5-72B 和 Llama-3.1-405B 等其他开源模型，并在性能上和世界顶尖的闭源模型 GPT-4o 以及 Claude-3.5-Sonnet 不分伯仲。",
  "createTime": "2025-02-07T00:12:54.000+08:00",
  "updateTime": "2025-02-08T21:50:01.000+08:00"
}',1);

-- ----------------------------
-- Table structure for app_mst
-- ----------------------------
DROP TABLE IF EXISTS `app_mst`;
CREATE TABLE `app_mst` (
  `id`           bigint         NOT NULL        AUTO_INCREMENT,
  `uid`          varchar(128)   NOT NULL        COMMENT 'User ID',
  `app_name`     varchar(128)   DEFAULT NULL,   COMMENT 'App name',
  `app_describe` varchar(512)   DEFAULT NULL,   COMMENT 'App Describe',
  `app_id`       varchar(128)   DEFAULT NULL,   COMMENT 'App ID',
  `app_key`      varchar(128)   DEFAULT NULL,   COMMENT 'App Key',
  `app_secret`   varchar(128)   DEFAULT NULL,   COMMENT 'App Secret',
  `is_delete`    tinyint        DEFAULT '0',    COMMENT 'Is Delete',
  `create_time`  datetime       DEFAULT NULL,   COMMENT 'Create Time',
  `update_time`  datetime       DEFAULT NULL,   COMMENT 'Update Time',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_app_id` (`app_id`),
  KEY `idx_app_name` (`app_name`)
) ENGINE=InnoDB COLLATE=utf8mb4_unicode_ci;