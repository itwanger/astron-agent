package com.iflytek.astra.console.toolkit.controller.common;

import com.alibaba.fastjson2.JSONObject;
import com.iflytek.astra.console.commons.constant.ResponseEnum;
import com.iflytek.astra.console.commons.exception.BusinessException;
import com.iflytek.astra.console.commons.response.ApiResult;
import com.iflytek.astra.console.toolkit.common.anno.ResponseResultBody;
import com.iflytek.astra.console.toolkit.service.common.ImageService;
import com.iflytek.astra.console.toolkit.util.S3Util;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.List;

/**
 * REST controller for handling image upload requests.
 */
@RestController
@RequestMapping("/image")
@Slf4j
@ResponseResultBody
public class ImageController {

    @Resource
    private ImageService imageService;

    @Resource
    private S3Util s3UtilClient;

    /**
     * Uploads an image file to S3 storage.
     * <p>
     * The method validates the file suffix to ensure it is one of the allowed formats
     * (png, jpg, jpeg). If validation passes, the file is uploaded to S3 and a JSON
     * response containing the S3 key and download link is returned.
     *
     * @param file the image file to be uploaded; must be of type png, jpg, or jpeg
     * @return an {@link ApiResult} containing a JSON object with:
     * <ul>
     *     <li>{@code s3Key} - the unique key of the file stored in S3</li>
     *     <li>{@code downloadLink} - the generated download URL for accessing the file</li>
     * </ul>
     * @throws BusinessException if the file format is invalid or does not have a suffix
     */
    @PostMapping("/upload")
    public ApiResult<JSONObject> upload(@RequestParam("file") MultipartFile file) {
        // Validate file suffix
        List<String> allowedSuffixes = Arrays.asList("png", "jpg", "jpeg");
        String fileName = file.getOriginalFilename();

        if (fileName == null || !fileName.contains(".")) {
            throw new BusinessException(ResponseEnum.RESPONSE_FAILED,
                    "Invalid file format, please upload an image in png or jpg format");
        }

        String suffix = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        if (!allowedSuffixes.contains(suffix)) {
            throw new BusinessException(ResponseEnum.RESPONSE_FAILED,
                    "Invalid file format, please upload an image in png or jpg format");
        }

        String s3Key = imageService.upload(file);
        JSONObject res = new JSONObject();
        // Generate a unique file name
        res.put("s3Key", s3Key);
        res.put("downloadLink", s3UtilClient.getS3Url(s3Key));
        return ApiResult.success(res);
    }
}