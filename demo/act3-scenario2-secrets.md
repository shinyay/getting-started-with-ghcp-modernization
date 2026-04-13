# Act 3b: Secrets Migration to Azure Key Vault — LIVE Demo

> **Duration**: 15 minutes (33:00–48:00)  
> **Mode**: ⚡ LIVE demo  
> **App**: Task Tracker (`demo-apps/task-tracker-app/`) — Spring Boot 3.2.5 + Java 17 + H2  
> **Fallback**: [fallback/scenario2-expected-diff.md](fallback/scenario2-expected-diff.md)

---

## Minute 33:00–34:00 — The Story (1 min)

Pick up directly from the Act 3a transition:

> "That was a framework upgrade — the 'technical debt' story. Now let me show you a different kind of modernization — **security**."
>
> "I have another app — our Task Tracker API. Spring Boot 3.2, Java 17. It builds, tests pass, everything works. It's already on a modern framework."
>
> "But it has a critical problem — and it's one that almost every enterprise codebase shares."

**Switch VS Code** to the `demo-apps/task-tracker-app/` project.

---

## Minute 34:00–37:00 — Before State: The Security Problem (3 min)

Walk through **three** locations where secrets are hardcoded. Open each file and highlight the offending lines.

### 🔑 Secret Location 1: `application.properties`

Open `src/main/resources/application.properties` and highlight:

```properties
spring.datasource.password=SuperSecret123!

app.analytics.api-key=sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234
app.analytics.api-secret=secret_live_xYzAbCdEfGhIjKlMnOpQrStUvWxYz0123456789
```

> "Three secrets in plain text — a database password and two API credentials. Every developer who clones this repo gets them. Every commit stores them forever in git history."

### 🔑 Secret Location 2: `ExternalApiConfig.java`

Open `src/main/java/com/example/tasktracker/config/ExternalApiConfig.java` and highlight:

```java
private String apiKey = "sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234";
private String apiSecret = "secret_live_xYzAbCdEfGhIjKlMnOpQrStUvWxYz0123456789";
```

> "Same API credentials — duplicated right into a Java configuration class as string literals. You can't rotate these without a code change, a PR, a build, and a deploy."

### 🔑 Secret Location 3: `NotificationService.java`

Open `src/main/java/com/example/tasktracker/service/NotificationService.java` and highlight:

```java
@Value("${app.webhook.secret:whsec_MjAyNS0wNC0xM1QwMDowMDowMFo_a1b2c3d4e5f6g7h8}")
private String webhookSecret;
```

> "This one is sneaky. The `@Value` annotation looks fine at a glance — it reads from a property. But there's a hardcoded **default value** right after the colon. If the property isn't set — and in most environments it won't be — the app silently uses this embedded secret."
>
> "Three secrets, three different patterns, all dangerous. They can't be rotated independently. They're shared across dev, staging, and production. And they're visible to anyone with repo access."

### 💼 For Managers

> "From a compliance perspective, hardcoded secrets are a finding on **every** audit framework — SOC 2 Trust Services Criteria CC6.1, ISO 27001 Annex A.9, PCI DSS Requirement 3.4. Each one of these would be flagged. And if this pattern exists in one app, it almost certainly exists in dozens."

---

## Minute 37:00–38:00 — Create Branch + Show Predefined Tasks (1 min)

### Create migration branch
```bash
cd demo-apps/task-tracker-app
git checkout -b migrate-secrets
```

> "Just like before — we start on a branch so every change is traceable and reviewable."

### Show predefined tasks

Open the **Copilot modernization extension** pane in VS Code. Navigate to the **TASKS** section and scroll to find:

```
Secrets and Certificate Management to Azure Key Vault
```

> "Predefined tasks are **Microsoft-curated migration patterns** built into the extension. They encode best practices — the right Azure SDKs, the right authentication patterns, the right configuration. You don't have to figure out the migration path yourself."
>
> "Let's run this one."

---

## Minute 38:00–39:00 — Run the Predefined Task (1 min)

**Either** click **"Run"** on the predefined task, **or** open Copilot Chat and type:

```
@modernize migrate secrets and credentials to Azure Key Vault
```

> "One command. The agent will now scan the entire codebase for hardcoded secrets and migrate every one of them to Azure Key Vault with Managed Identity authentication."

---

## Minute 39:00–44:00 — Watch the Migration (5 min)

**This is the core execution phase.** Narrate as the agent works through the codebase.

### Assessment

> "The agent is scanning the project — finding secrets in properties files, Java source, annotations. It's building an inventory of everything that needs to move."

### `pom.xml` — New dependencies

> "Watch the pom.xml — Azure Key Vault SDK added... Azure Identity for Managed Identity... Spring Cloud Azure starter for the Key Vault property source integration. It picked the right libraries automatically."

### `application.properties` — Secrets externalized

> "Now the properties file — `SuperSecret123!` is gone. The API key is gone. They're replaced with **Key Vault property source references** — placeholders that resolve from Azure Key Vault at runtime."

### `ExternalApiConfig.java` — SecretClient retrieval

> "The Java config class — those hardcoded string fields are being replaced with `SecretClient` calls. The class now retrieves secrets from Key Vault on demand. And `SecretClient` authenticates via **Managed Identity** — passwordless, no credentials even for accessing the vault."

### `NotificationService.java` — Default removed

> "And the sneaky `@Value` default — the hardcoded fallback is stripped out. Now if the secret isn't configured in Key Vault, the app **fails fast** instead of silently running with an insecure default. That's the right behavior."

### Key Vault configuration

> "The agent may also create a configuration class that sets up the `SecretClient` bean with `DefaultAzureCredential`. This automatically uses Managed Identity in Azure and developer credentials locally — zero-config, passwordless authentication."

**If the agent pauses for confirmation**, type **"continue"** or **"yes"**.

**If the agent encounters a build error**, narrate:
> "The agent hit a compilation issue — and now it's analyzing the error and fixing it. This validate-and-fix loop is part of the workflow."

---

## Minute 44:00–46:00 — Review Results (2 min)

```bash
git --no-pager diff --stat
git --no-pager diff
```

Walk through the key changes:

> "Let's look at what just happened in about [X] minutes."

**Highlight in the diff:**

1. **`pom.xml`** — New Azure Key Vault + Identity + Spring Cloud Azure dependencies
2. **`application.properties`** — Hardcoded secrets → Key Vault property source references
3. **`ExternalApiConfig.java`** — String literals → `SecretClient.getSecret()` calls
4. **`NotificationService.java`** — `@Value` default removed, fail-fast behavior
5. **New config class** (if created) — `SecretClient` bean with `DefaultAzureCredential`

> "Three secrets in three different patterns — properties file, Java string field, annotation default. All detected. All externalized to Azure Key Vault. All authenticated with Managed Identity."
>
> "No credentials anywhere in code or configuration. And every change is in a git diff you can review before merging."

---

## Minute 46:00–48:00 — Talking Points + Transition (2 min)

### For Developers

> "Predefined tasks encode **battle-tested migration patterns**. You don't need to research which Azure SDK version to use, how to configure Managed Identity, or which Spring Boot starter integrates with Key Vault. The agent knows the pattern and applies it consistently."
>
> "And it handles all three secret patterns — properties files, Java source, annotation defaults — in one pass."

### For Managers

> "This is a **compliance accelerator**. Every hardcoded secret flagged in an audit can be remediated with a single predefined task — consistently, across your entire portfolio. SOC 2, ISO 27001, PCI DSS — all addressed."
>
> "And because predefined tasks are standardized, you get the same migration pattern every time. Not one developer's interpretation of 'move to Key Vault' — a consistent, reviewed, best-practice implementation."

### Transition to Act 4

> "We've seen the IDE solution — upgrade a legacy framework, secure a modern one. Two different modernization scenarios, same Assess → Plan → Execute workflow."
>
> "Now let's zoom out to the **enterprise level**. How do you apply this across not one app — but your entire portfolio?"

---

## Fallback Plan

**Trigger**: If the agent shows no visible progress for 5+ minutes.

**Recovery**:
1. Say: *"While the agent works through this, let me show you what the completed migration looks like from a previous run."*
2. Open `demo/fallback/scenario2-expected-diff.md`
3. Walk through the pre-generated diffs for each file
4. If the agent finishes in the background, switch back: *"And it looks like the agent just finished — let's compare with the actual results."*

---

## Preparation Checklist

- [ ] Task Tracker app open in VS Code (`demo-apps/task-tracker-app/`)
- [ ] `mvn compile` succeeds (build verified)
- [ ] On `main` branch, ready to `git checkout -b migrate-secrets`
- [ ] Three secret files bookmarked / tabs open: `application.properties`, `ExternalApiConfig.java`, `NotificationService.java`
- [ ] Copilot modernization extension installed and TASKS pane accessible
- [ ] Fallback file accessible: `demo/fallback/scenario2-expected-diff.md`
- [ ] Timer visible to track against 15-minute budget
