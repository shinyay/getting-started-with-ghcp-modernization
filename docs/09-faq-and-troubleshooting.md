# FAQ & Troubleshooting

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/): April 2026*

## General FAQ

### What GitHub Copilot plan do I need?

Any plan works: **Free**, Pro, Pro+, Business, or Enterprise. No separate license is required — the modernization extension and CLI are included with your Copilot subscription.

### How is it billed?

Modernization tasks consume **premium requests** under your Copilot subscription. Each plan includes a monthly allowance of premium requests. Exceeding the limit requires a plan upgrade or extra purchase. See [Copilot plans](https://github.com/features/copilot/plans) for details.

### Does it store or train on my code?

No. GitHub Copilot modernization uses Copilot the same way you use it to modify code — **code is not retained** beyond the immediate session. Custom skills are not collected, transmitted, or stored. Session data is deleted after upgrade/migration completes. See the [Microsoft Privacy Statement](https://www.microsoft.com/en-us/privacy/privacystatement) for details.

### What languages are supported?

- **Java** and **.NET** — both Generally Available for IDE experience (language/framework upgrades and migration scenarios)
- **Python** — available for CLI plan creation (`--language python`)
- The Modernization Agent (CLI) is in **Public Preview**

---

## Java FAQ

### What Java versions are supported?

**Supported source versions:** JDK 8, 11, 17, 21, 25
**Upgrade target:** up to JDK 21

### What build tools work?

- **Maven** (including Maven Wrapper)
- **Gradle** (Gradle Wrapper v5+ only)
- Kotlin DSL-based Gradle projects are **not** supported

### What frameworks are optimized for upgrades?

- Spring Boot up to version 3.5
- Java EE (Javax) → Jakarta EE up to Jakarta EE 10
- Legacy Spring Framework up to version 6.2+
- JUnit upgrades
- Various third-party dependencies

### Which model should I use?

As a general rule, newer models outperform older ones. **Claude Sonnet models** are recommended for better accuracy in coding tasks. To reduce cost, start with models that have a lower [multiplier](https://docs.github.com/en/copilot/concepts/billing/copilot-requests#model-multipliers).

- **IDE default:** Claude Sonnet 4.5 (falls back to 'auto' if unavailable)
- **CLI default:** claude-sonnet-4.6

### The agent keeps asking me to click "Continue" — how do I stop that?

**VS Code:**
- Set `chat.tools.autoApprove` to `true` to automatically approve all tools
- Set `chat.agent.maxRequests` to `128` to reduce confirmation pauses

**IntelliJ IDEA:**
- Open **Tools** → **GitHub Copilot** → select **Auto-approve**
- Enable **Trust MCP Tool Annotations**
- Set **Max Requests** to `99`

### How does the MCP server work?

The MCP (Model Context Protocol) server enhances code transformation capabilities:

- Registered and started **automatically** after VS Code extension installation
- NPM package: `@microsoft/github-copilot-app-modernization-mcp-server`
- Logs location: `~/.ghcp-appmod-java/logs`

If you see a refresh button in the Copilot Chat panel, select it to load the latest tool versions.

---

## .NET FAQ

### What .NET project types are supported?

ASP.NET Core (MVC, Razor Pages, Web API), Blazor, Azure Functions, WPF, WinForms, class libraries, console apps, and test projects (MSTest, NUnit).

### How do I invoke the .NET agent?

| Environment | Invocation |
|-------------|-----------|
| Visual Studio | Right-click → **Modernize** or `@Modernize` in Chat |
| VS Code | `@modernize-dotnet` in Copilot Chat |
| GitHub Copilot CLI | `@modernize-dotnet` |
| GitHub.com | `modernize-dotnet` coding agent |

### Where are .NET upgrade artifacts stored?

Under `.github/upgrades/{scenarioId}/`:
- `assessment.md` — Assessment results
- `plan.md` — Upgrade plan
- `tasks.md` — Executable tasks with progress tracking

---

## CLI FAQ

### What's the difference between IDE and CLI?

| Feature | IDE Experience | Modernization Agent (CLI) |
|---------|---------------|--------------------------|
| Target user | Individual developers | Architects, platform teams |
| Scale | Single application | Multi-app, enterprise-scale |
| Interaction | Chat-based (Copilot Agent Mode) | TUI + CLI + headless |
| Batch operations | ❌ | ✅ (assess + upgrade) |
| CI/CD integration | Via GitHub.com coding agent | Native CLI support |

### How do I run in CI/CD pipelines?

Use the `--no-tty` flag to disable interactive prompts:

```bash
# Assess multiple repos in headless mode
modernize assess --multi-repo --no-tty

# Upgrade with cloud delegation, wait for completion
modernize upgrade "Java 21" --delegate cloud --wait --no-tty
```

---

## Troubleshooting

### Common Workshop Issues

| Symptom | Solution |
|---------|----------|
| `modernize: command not found` | Reinstall CLI and open a **new terminal** for PATH to update |
| `repos.json` not detected | Must be at exactly `.github/modernize/repos.json` (case-sensitive) |
| Agent stalls (no output >2 minutes) | Cancel the operation and re-invoke the same prompt |
| Build fails after upgrade | Expected behavior — review the error, ask the agent to fix it, or use fallback files |
| VS Code extensions not found | **Restart VS Code** after installing the modernization extension |
| Copilot rate limiting | Reduce `chat.agent.maxRequests`, wait 1–2 minutes between labs |
| Agent asks "Should I proceed?" | Type `continue` or `yes` — or enable auto-approve (see Java FAQ above) |
| `javax.persistence` still found after upgrade | Run `grep -rn "javax.persistence" src/` to find remaining files, then ask: `@modernize migrate remaining javax imports to jakarta` |
| IntelliJ: My Skills not showing | **My Skills** feature is not yet supported in IntelliJ IDEA (VS Code only) |

---

> **Alternative tool:** For legacy bulk assessment, the [AppCAT CLI](https://learn.microsoft.com/en-us/azure/migrate/appcat/appcat-7-cli-guide) also supports multi-project scanning via the `-bulk` flag. The Modernize CLI is the recommended tool for new modernization workflows.

## Key Resources

| Resource | URL |
|----------|-----|
| Official Documentation | [learn.microsoft.com/...github-copilot-app-modernization](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) |
| Java Modernization Guide | [learn.microsoft.com/...java](https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java) |
| .NET Modernization Guide | [learn.microsoft.com/...dotnet](https://learn.microsoft.com/en-us/dotnet/core/porting/github-copilot-app-modernization-overview) |
| Java FAQ | [learn.microsoft.com/...faq](https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java-faq) |
| Modernize CLI | [github.com/microsoft/modernize-cli](https://github.com/microsoft/modernize-cli) |
| Agent Skills Specification | [agentskills.io/specification](https://agentskills.io/specification) |
| Feedback (Agent) | [github.com/microsoft/github-copilot-appmod](https://github.com/microsoft/github-copilot-appmod/issues/new?template=feedback-template.yml) |
| Feedback (.NET) | [github.com/dotnet/modernize-dotnet](https://github.com/dotnet/modernize-dotnet/issues) |
| Feedback Form | [aka.ms/ghcp-appmod/feedback](https://aka.ms/ghcp-appmod/feedback) |
