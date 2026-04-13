package com.example.tasktracker.service;

import com.example.tasktracker.config.ExternalApiConfig;
import com.example.tasktracker.model.Task;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Service for sending webhook notifications when tasks are completed.
 *
 * ⚠️ SECURITY ISSUE: Webhook signing secret is hardcoded as a default value.
 * This should be stored in Azure Key Vault.
 */
@Service
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    // 🔑 HARDCODED SECRET: Webhook signing secret as @Value default
    @Value("${app.webhook.secret:whsec_MjAyNS0wNC0xM1QwMDowMDowMFo_a1b2c3d4e5f6g7h8}")
    private String webhookSecret;

    @Value("${app.webhook.url:https://hooks.example.com/task-events}")
    private String webhookUrl;

    private final ExternalApiConfig apiConfig;

    public NotificationService(ExternalApiConfig apiConfig) {
        this.apiConfig = apiConfig;
    }

    public void notifyTaskCompleted(Task task) {
        String payload = buildPayload(task);
        String signature = signPayload(payload);

        logger.info("Sending webhook notification for task '{}' to {}", task.getTitle(), webhookUrl);
        logger.debug("Webhook signature: {}", signature);
        logger.debug("Using analytics API at: {}", apiConfig.getApiBaseUrl());
    }

    private String buildPayload(Task task) {
        return String.format(
            "{\"event\":\"task.completed\",\"taskId\":%d,\"title\":\"%s\",\"priority\":\"%s\"}",
            task.getId(), task.getTitle(), task.getPriority()
        );
    }

    String signPayload(String payload) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA256");
            SecretKeySpec keySpec = new SecretKeySpec(
                webhookSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"
            );
            hmac.init(keySpec);
            byte[] hash = hmac.doFinal(payload.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            logger.error("Failed to sign webhook payload", e);
            return "";
        }
    }
}
