# Prerequisites & Environment Setup

## Section 1: Tooling Requirements (All Scenarios)

### 1. GitHub Copilot Subscription

Any plan works: **Free** · Pro · Pro+ · Business · Enterprise

Verify: [github.com/settings/copilot](https://github.com/settings/copilot) — confirm your subscription is active.

### 2. Visual Studio Code (v1.106+)

Download: [code.visualstudio.com](https://code.visualstudio.com/)

```bash
code --version
# Should show 1.106.0 or later
```

### 3. VS Code Extensions (3 required)

| Extension | ID | Install Command |
|-----------|-----|----------------|
| GitHub Copilot | `github.copilot` | `code --install-extension github.copilot` |
| GitHub Copilot Chat | `github.copilot-chat` | `code --install-extension github.copilot-chat` |
| Copilot Modernization | `vscjava.migrate-java-to-azure` | `code --install-extension vscjava.migrate-java-to-azure` |

**One-liner install:**
```bash
code --install-extension github.copilot && \
code --install-extension github.copilot-chat && \
code --install-extension vscjava.migrate-java-to-azure
```

> ⚠️ **Restart VS Code** after installing the modernization extension.

### 4. Java 21+ (JDK)

The Copilot modernization tooling **requires JDK 21+** to run.

Download: [Microsoft OpenJDK 21](https://learn.microsoft.com/en-us/java/openjdk/download)

```bash
java -version
# Should show version 21.x.x or later
```

### 5. Maven 3.8+

```bash
mvn -version
# Should show 3.8.x or later
```

### 6. Git

```bash
git --version
```

---

## Section 2: Scenario-Specific Requirements

### Scenario 1: Version Upgrade (PhotoAlbum-Java)

| Requirement | Status | Notes |
|-------------|--------|-------|
| JDK 8 | **Optional** | Source targets Java 8, but the extension handles upgrade internally |
| Docker | **Optional** | Oracle DB only needed to run the app; demo focuses on code transformation |

### Scenario 2: Secrets → Key Vault (Task Tracker)

| Requirement | Status | Notes |
|-------------|--------|-------|
| Additional tools | **None** | H2 in-memory database, runs standalone |
| Azure subscription | **Optional** | Only for actual Azure deployment |

### Act 2: CLI Assessment Walkthrough

| Requirement | Status | Notes |
|-------------|--------|-------|
| Modernize CLI | **Optional** | Demo uses pre-generated report. Install if you want to show the CLI briefly |

Install (if wanted):
```bash
# Linux/macOS
curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh | bash

# Verify
modernize --version
```

### Act 4: Custom Skills Teaser

| Requirement | Status | Notes |
|-------------|--------|-------|
| Additional tools | **None** | We show a pre-cloned SKILL.md file |

---

## Section 3: VS Code Settings for Demo

Open Settings (JSON) → add:

```json
{
    "chat.tools.autoApprove": true,
    "chat.agent.maxRequests": 128,
    "editor.fontSize": 16,
    "terminal.integrated.fontSize": 16
}
```

| Setting | Why |
|---------|-----|
| `chat.tools.autoApprove` | Skips confirmation prompts — keeps demo flowing |
| `chat.agent.maxRequests` | Prevents "request limit reached" interruptions mid-task |
| `editor.fontSize` / `terminal.integrated.fontSize` | Readability for screen sharing / projector |

### Enable Suggestions Matching Public Code

Prevents Copilot from blocking changes to `pom.xml` and similar files:

1. Go to [github.com/settings/copilot](https://github.com/settings/copilot)
2. Find **"Suggestions matching public code"**
3. Set to **"Allowed"**

---

## Section 4: Pre-Demo Verification

Run through all 8 checks before the demo:

```bash
# 1. Java version
echo "=== Step 1: Java ==="
java -version

# 2. Maven version
echo "=== Step 2: Maven ==="
mvn -version

# 3. Git version
echo "=== Step 3: Git ==="
git --version

# 4. VS Code version
echo "=== Step 4: VS Code ==="
code --version

# 5. VS Code extensions
echo "=== Step 5: Extensions ==="
code --list-extensions | grep -E "copilot|migrate"
# Expected output:
#   github.copilot
#   github.copilot-chat
#   vscjava.migrate-java-to-azure

# 6. PhotoAlbum-Java cloned and cached
echo "=== Step 6: PhotoAlbum-Java ==="
ls PhotoAlbum-Java/pom.xml && echo "✅ Cloned"

# 7. Task Tracker app builds
echo "=== Step 7: Task Tracker ==="
cd demo-apps/task-tracker-app && mvn clean package -q && echo "✅ Build OK" && cd ../..

# 8. NewsFeedSite cloned (for Act 4)
echo "=== Step 8: NewsFeedSite ==="
ls NewsFeedSite/.github/skills/rabbitmq-to-azureservicebus/SKILL.md && echo "✅ Cloned"

echo ""
echo "✅ All checks passed — you're ready for the demo!"
```
