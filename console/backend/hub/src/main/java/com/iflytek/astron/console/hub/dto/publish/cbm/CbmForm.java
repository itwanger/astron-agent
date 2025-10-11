package com.iflytek.astron.console.hub.dto.publish.cbm;

import lombok.Data;

@Data
public class CbmForm {

    private Integer botId;

    // 老版创建需要 appId， 新版创建只需要keyId
    private String appId;

    private Long publishBindId;

}
