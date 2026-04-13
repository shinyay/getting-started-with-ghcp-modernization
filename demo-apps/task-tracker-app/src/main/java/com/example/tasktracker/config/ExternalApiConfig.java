package com.example.tasktracker.config;

import org.springframework.context.annotation.Configuration;

/**
 * Configuration for external analytics API integration.
 *
 * ⚠️ SECURITY ISSUE: API credentials are hardcoded below.
 * These should be stored in Azure Key Vault and retrieved at runtime.
 */
@Configuration
public class ExternalApiConfig {

    // 🔑 HARDCODED SECRET: External analytics API key
    private String apiKey = "sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234";

    // 🔑 HARDCODED SECRET: External analytics API secret
    private String apiSecret = "secret_live_xYzAbCdEfGhIjKlMnOpQrStUvWxYz0123456789";

    private String apiBaseUrl = "https://api.analytics-service.example.com/v2";

    public String getApiKey() {
        return apiKey;
    }

    public String getApiSecret() {
        return apiSecret;
    }

    public String getApiBaseUrl() {
        return apiBaseUrl;
    }
}
