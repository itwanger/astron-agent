package com.iflytek.astra.console.toolkit.service.common;

import com.iflytek.astra.console.commons.constant.ResponseEnum;
import com.iflytek.astra.console.commons.exception.BusinessException;
import com.iflytek.astra.console.toolkit.util.S3Util;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.UUID;

/**
 * Service for handling image uploads to S3/MinIO storage.
 */
@Service
@Slf4j
public class ImageService {

    @Resource
    private S3Util s3UtilClient;

    /** Allowed Content-Types (extend as needed). */
    private static final String[] ALLOWED_TYPES = {
            "image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp", "image/svg+xml"
    };

    /** MinIO/Amazon recommended minimum part size for multipart upload: 5MB. */
    private static final long MULTIPART_PART_SIZE = 5L * 1024 * 1024;

    /**
     * Upload an image and return the object key.
     * <p>
     * If the bucket policy is not public, the caller should use the object key
     * to obtain a pre-signed URL or controlled download path.
     *
     * @param file the image file to upload
     * @return the object key of the uploaded file
     * @throws BusinessException if the file is empty, has an unsupported type,
     *                           or if upload to S3 fails
     */
    public String upload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException(ResponseEnum.RESPONSE_FAILED, "Empty file");
        }

        final String contentType = normalizeContentType(file.getContentType());
        if (!isAllowedType(contentType)) {
            throw new BusinessException(ResponseEnum.RESPONSE_FAILED, "Unsupported content type: " + contentType);
        }

        final long size = file.getSize();

        final String original = file.getOriginalFilename();
        final String safeName = buildSafeFileName(original, contentType);
        final String objectKey = "icon/user/" + safeName;

        try (InputStream in = file.getInputStream()) {
            if (size > 0) {
                // Known size upload (preferred).
                s3UtilClient.putObject(objectKey, in, size, contentType);
            } else {
                // Unknown size, use multipart upload.
                s3UtilClient.putObject(objectKey, in, contentType, MULTIPART_PART_SIZE);
            }
        } catch (Exception e) {
            log.error("Upload image failed, name={}, size={}, type={}, err={}",
                    original, size, contentType, e.getMessage(), e);
            throw new BusinessException(ResponseEnum.S3_UPLOAD_ERROR);
        }
        return objectKey;
    }

    /**
     * Check whether the content type is allowed.
     *
     * @param contentType the MIME type of the file
     * @return true if allowed, false otherwise
     */
    private static boolean isAllowedType(String contentType) {
        if (contentType == null) return false;
        for (String t : ALLOWED_TYPES) {
            if (t.equalsIgnoreCase(contentType)) return true;
        }
        // Fallback: allow image/* (can be disabled if needed).
        return contentType.toLowerCase(Locale.ROOT).startsWith("image/");
    }

    /**
     * Normalize content type string.
     *
     * @param ct original content type
     * @return normalized content type, or "application/octet-stream" if blank
     */
    private static String normalizeContentType(String ct) {
        if (ct == null || ct.isBlank()) return "application/octet-stream";
        return ct.trim();
    }

    /**
     * Build a safe file name without exposing the original name.
     * <p>
     * The generated file name format: sparkBot_<uuid>.<ext>
     *
     * @param original    the original file name
     * @param contentType the file MIME type
     * @return generated safe file name
     */
    private static String buildSafeFileName(String original, String contentType) {
        String ext = guessExtension(original, contentType);
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return "sparkBot_" + uuid + (ext.isEmpty() ? "" : "." + ext);
    }

    /**
     * Guess file extension from original name or content type.
     *
     * @param original    original file name
     * @param contentType MIME type of the file
     * @return guessed file extension in lowercase, or empty string if unknown
     */
    private static String guessExtension(String original, String contentType) {
        // Try to get extension from original file name
        String ext = "";
        if (original != null) {
            String clean = stripUnsafe(original);
            int dot = clean.lastIndexOf('.');
            if (dot > -1 && dot < clean.length() - 1) {
                ext = clean.substring(dot + 1);
            }
        }
        // Fallback: infer from content type
        if (ext.isBlank() && contentType != null) {
            switch (contentType.toLowerCase(Locale.ROOT)) {
                case "image/png": ext = "png"; break;
                case "image/jpeg":
                case "image/jpg": ext = "jpg"; break;
                case "image/gif": ext = "gif"; break;
                case "image/webp": ext = "webp"; break;
                case "image/svg+xml": ext = "svg"; break;
                default: ext = ""; // no extension
            }
        }
        return ext.toLowerCase(Locale.ROOT);
    }

    /**
     * Remove unsafe characters from the file name to prevent path traversal.
     * <p>
     * Whitespace is removed, reserved characters are replaced with underscores,
     * and leading/trailing dots are sanitized.
     *
     * @param name the original file name
     * @return sanitized file name
     */
    private static String stripUnsafe(String name) {
        String cleaned = new String(name.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8)
                .replaceAll("\\s+", "")
                .replaceAll("[\\\\/:*?\"<>|]+", "_");
        // Prevent multiple or leading dots
        cleaned = cleaned.replaceAll("\\.\\.+", ".");
        cleaned = cleaned.replaceAll("^\\.+", "");
        return cleaned;
    }
}