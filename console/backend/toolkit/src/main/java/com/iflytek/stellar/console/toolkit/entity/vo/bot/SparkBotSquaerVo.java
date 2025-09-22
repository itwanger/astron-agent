package com.iflytek.stellar.console.toolkit.entity.vo.bot;

import com.iflytek.stellar.console.toolkit.entity.table.bot.SparkBot;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * @author clliu19
 * @date 2024/05/23/11:42
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class SparkBotSquaerVo extends SparkBot {

    private String toolId;
}
