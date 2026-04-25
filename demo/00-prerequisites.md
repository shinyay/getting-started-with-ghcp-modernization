# Prerequisites & Environment Setup

> *Last reviewed: **April 2026***
>
> **Tested With**: `modernize v0.0.293+` · `Copilot CLI 1.0.36+` · `claude-sonnet-4.6` · VS Code 1.106+ (Insiders recommended) — verified 2026-04-25

## Section 1: Tooling Requirements (All Scenarios)

### 1. GitHub Copilot Subscription

Any plan works: **Free** · Pro · Pro+ · Business · Enterprise

Verify: [github.com/settings/copilot](https://github.com/settings/copilot) — confirm your subscription is active.

### 2. Visual Studio Code (v1.106+)

Download: [code.visualstudio.com](https://code.visualstudio.com/) — **VS Code Insiders** ([code.visualstudio.com/insiders](https://code.visualstudio.com/insiders/)) is recommended for the latest modernization preview features.

```bash
code --version
# Should show 1.106.0 or later
```

### 3. VS Code Extensions (3 required, 1 optional)

| Extension | ID | Install Command |
|-----------|-----|----------------|
| GitHub Copilot | `github.copilot` | `code --install-extension github.copilot` |
| GitHub Copilot Chat | `github.copilot-chat` | `code --install-extension github.copilot-chat` |
| GitHub Copilot App Modernization for Java | `vscjava.migrate-java-to-azure` | `code --install-extension vscjava.migrate-java-to-azure` |
| GitHub Copilot App Modernization for .NET *(only if running Act 3c)* | see [docs/03](../docs/03-ide-experience-dotnet.md) | install via Marketplace search |

**One-liner install (Java track):**
```bash
code --install-extension github.copilot && \
code --install-extension github.copilot-chat && \
code --install-extension vscjava.migrate-java-to-azure
```

> ⚠️ **Restart VS Code** after installing the modernization extension(s).

### 4. Java JDK

The Java demo scenarios (Acts 1, 2, 3a, 3b, 4) need a JDK on the PATH.

- **JDK 21+ recommended** — exercises all Java workflows including the Spring Boot 3.x / Java 21 *post*-upgrade build.
- **JDK 17+ acceptable** for the read-only walkthrough sections (Act 1 problem hook, Act 2 CLI report show-and-tell). Lab 1 in the workshop strictly requires JDK 21+ for the post-upgrade build, but the demo scripts themselves do not invoke `mvn` against the upgraded code.

Download: [Microsoft OpenJDK 21](https://learn.microsoft.com/en-us/java/openjdk/download)

```bash
java -version
# Should show 21.x.x (recommended) or at least 17.x.x
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

### Act 3c: Optional .NET 6 → .NET 10 Walkthrough

Only required if you plan to deliver the optional .NET act. See `act3c-scenario3-dotnet-upgrade.md`.

| Requirement | Status | Notes |
|-------------|--------|-------|
| .NET SDK | **SDK 10+** | Required to target `net10.0`; SDK 8 cannot rebuild the upgraded project. Verify with `dotnet --version`. |
| .NET modernization extension | **Required** | "GitHub Copilot App Modernization for .NET" — see [docs/03-ide-experience-dotnet.md](../docs/03-ide-experience-dotnet.md) for install details. |
| `workshop-apps/dotnet-sample-app` builds | **Required** | `cd workshop-apps/dotnet-sample-app && dotnet build` should succeed. `bash workshop/setup.sh` runs this automatically when `dotnet` is on the PATH. |

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

Run through all 8 checks before the demo (plus a 9th if you plan to deliver Act 3c):

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
# Expected output (Java track):
#   github.copilot
#   github.copilot-chat
#   vscjava.migrate-java-to-azure
# Plus (only if running Act 3c): the .NET modernization extension

# 6. PhotoAlbum-Java cloned and cached
echo "=== Step 6: PhotoAlbum-Java ==="
ls PhotoAlbum-Java/pom.xml && echo "✅ Cloned"

# 7. Task Tracker app builds
echo "=== Step 7: Task Tracker ==="
cd demo-apps/task-tracker-app && mvn clean package -q && echo "✅ Build OK" && cd ../..

# 8. NewsFeedSite cloned (for Act 4)
echo "=== Step 8: NewsFeedSite ==="
ls NewsFeedSite/.github/skills/rabbitmq-to-azureservicebus/SKILL.md && echo "✅ Cloned"

# 9. (Optional — only if running Act 3c) .NET sample app builds
echo "=== Step 9: dotnet-sample-app (Act 3c only) ==="
if command -v dotnet >/dev/null 2>&1; then
  ( cd workshop-apps/dotnet-sample-app && dotnet build -nologo -v q ) && echo "✅ .NET build OK"
else
  echo "ℹ️  dotnet not installed — skip if you are not delivering Act 3c"
fi

echo ""
echo "✅ All checks passed — you're ready for the demo!"
```
