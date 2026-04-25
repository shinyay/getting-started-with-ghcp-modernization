<!-- Generated: April 2026 | Static fallback shown when the live demo stalls. Secret literals below match `demo-apps/task-tracker-app` byte-for-byte; if those fixtures change, regenerate this file. -->
# Fallback: Scenario 2 — Secrets Migration Expected Diff

> **Last refreshed**: 2026-04-25
>
> **Tested With**: `modernize` CLI v0.0.293+ · `claude-sonnet-4.6` · against `demo-apps/task-tracker-app` (3 hardcoded-secret patterns)
>
> Use this if the live demo stalls. Walk through these changes to show what the secrets migration produces.

---

## 1. `pom.xml` — New Azure Dependencies

### Added
```xml
<!-- Azure Key Vault Secrets -->
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-security-keyvault-secrets</artifactId>
</dependency>

<!-- Azure Identity (Managed Identity authentication) -->
<dependency>
    <groupId>com.azure</groupId>
    <artifactId>azure-identity</artifactId>
</dependency>

<!-- Spring Cloud Azure Key Vault integration -->
<dependency>
    <groupId>com.azure.spring</groupId>
    <artifactId>spring-cloud-azure-starter-keyvault-secrets</artifactId>
</dependency>
```

> "The agent added the right Azure SDKs — Key Vault for secrets retrieval and Azure Identity for Managed Identity. No manual Maven lookup."

---

## 2. `application.properties` — Secrets Removed

### Before
```properties
spring.datasource.password=SuperSecret123!
app.analytics.api-key=sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234
app.analytics.api-secret=secret_live_xYzAbCdEfGhIjKlMnOpQrStUvWxYz0123456789
```

### After
```properties
# Secrets now resolved from Azure Key Vault property source
spring.cloud.azure.keyvault.secret.property-sources[0].endpoint=https://<your-keyvault>.vault.azure.net/
spring.datasource.password=${datasource-password}
app.analytics.api-key=${analytics-api-key}
app.analytics.api-secret=${analytics-api-secret}
```

> "The hardcoded values are gone. They're now placeholders resolved from Azure Key Vault at runtime."

---

## 3. `ExternalApiConfig.java` — Key Vault Retrieval

### Before
```java
@Configuration
public class ExternalApiConfig {
    private String apiKey = "sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234";
    private String apiSecret = "secret_live_xYzAbCdEfGhIjKlMnOpQrStUvWxYz0123456789";
}
```

### After
```java
@Configuration
public class ExternalApiConfig {
    private final SecretClient secretClient;

    public ExternalApiConfig(SecretClient secretClient) {
        this.secretClient = secretClient;
    }

    public String getApiKey() {
        return secretClient.getSecret("analytics-api-key").getValue();
    }

    public String getApiSecret() {
        return secretClient.getSecret("analytics-api-secret").getValue();
    }
}
```

> "Hardcoded strings completely replaced with Key Vault retrieval via SecretClient. Authenticates using Managed Identity — no credentials needed, even for accessing the vault."

---

## 4. `NotificationService.java` — Default Removed

### Before
```java
@Value("${app.webhook.secret:whsec_MjAyNS0wNC0xM1QwMDowMDowMFo_a1b2c3d4e5f6g7h8}")
private String webhookSecret;
```

### After
```java
@Value("${app.webhook.secret}")
private String webhookSecret;
```

> "The @Value annotation stays, but the hardcoded default is removed. The secret now comes from Key Vault. If it's not configured, the app fails fast instead of silently using an insecure default."

---

## 5. New: Key Vault Configuration Class

The agent may create:
```java
@Configuration
public class AzureKeyVaultConfig {
    @Bean
    public SecretClient secretClient() {
        return new SecretClientBuilder()
            .vaultUrl("https://<your-keyvault>.vault.azure.net/")
            .credential(new DefaultAzureCredentialBuilder().build())
            .buildClient();
    }
}
```

> "`DefaultAzureCredential` automatically uses Managed Identity in Azure, developer credentials locally. Passwordless authentication — the gold standard."

---

## Summary Table

| Location | Before | After |
|----------|--------|-------|
| `application.properties` | `password=SuperSecret123!` | Key Vault property source |
| `ExternalApiConfig.java` | Hardcoded string fields | `SecretClient.getSecret()` |
| `NotificationService.java` | `@Value` with hardcoded default | `@Value` without default |
| **Authentication** | N/A | Managed Identity (passwordless) |

---

## Recovery Script

> "Three secrets in three different patterns — all detected, all externalized to Azure Key Vault."
>
> "The database password was in the properties file. The API key was hardcoded in a Java config class. The webhook secret was hidden as a @Value default."
>
> "All replaced with the same secure pattern: Key Vault retrieval using Managed Identity. No more credentials anywhere in code or config."
>
> "For compliance: this addresses SOC 2, ISO 27001, and PCI DSS requirements for secrets management — applied automatically and consistently."
