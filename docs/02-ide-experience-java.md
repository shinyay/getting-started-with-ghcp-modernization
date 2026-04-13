# IDE Experience — Java Modernization

## Overview

The IDE experience for Java is delivered through **VS Code** and **IntelliJ IDEA** extensions, providing an interactive, developer-centric modernization workflow using GitHub Copilot Agent Mode.

## Prerequisites

### Required
- GitHub account with active **GitHub Copilot** subscription (any plan)
- **Java 21** or later
- **Maven** or **Gradle** (Gradle Wrapper v5+)
- Git-based repository

### IDE Setup

#### Visual Studio Code
1. VS Code **1.106+**
2. [GitHub Copilot extension](https://code.visualstudio.com/docs/copilot/overview)
3. [GitHub Copilot modernization extension](https://marketplace.visualstudio.com/items?itemName=vscjava.migrate-java-to-azure) (`vscjava.migrate-java-to-azure`)
4. Restart VS Code after installation

#### IntelliJ IDEA
1. IntelliJ IDEA **2023.3+** (Windows/macOS only — Linux not currently supported)
2. [GitHub Copilot plugin](https://plugins.jetbrains.com/plugin/17718-github-copilot) v1.5.59+
3. [GitHub Copilot modernization plugin](https://plugins.jetbrains.com/plugin/28791-github-copilot-app-modernization)
4. Restart after installation

### Azure Account
Only required for **deploying resources to Azure**, not needed for code changes.

## How It Works

### Starting the Agent

- **VS Code**: Open Copilot Chat → type `@modernize` or use the Activity sidebar extension
- **IntelliJ IDEA**: Open GitHub Copilot Chat → invoke modernization agent

### Agent Workflow

When you invoke a task, the agent automatically:

1. Creates **plan.md** and **progress.md**
2. Checks version control status and creates a new migration branch
3. Performs code migration (using OpenRewrite + AI)
4. Runs validations: build, unit tests, CVE scanning, consistency check, completeness check
5. Generates **summary.md**

### Confirmation Handling
- The agent may pause for confirmation — type **Continue** or **yes** to proceed
- **VS Code tip**: Set `chat.tools.autoApprove` to `true` and `chat.agent.maxRequests` to `128`
- **IntelliJ tip**: Enable **Auto-approve** in Tools > GitHub Copilot, enable **Trust MCP Tool Annotations**, set **Max Requests** to `99`

## Supported Java Upgrade Paths

| From | To |
|------|------|
| JDK 8 | JDK 11, 17, 21 |
| JDK 11 | JDK 17, 21 |
| JDK 17 | JDK 21 |

### Framework Upgrade Support
- **Spring Boot** up to version 3.5
- **Java EE** (Javax) → **Jakarta EE** up to Jakarta EE 10
- **Legacy Spring Framework** up to version 6.2+
- **JUnit** upgrades
- Various third-party dependency upgrades

## Predefined Tasks (Java)

Predefined tasks encode **industry best practices** for common Azure migration scenarios:

### Messaging
| Task | Description |
|------|-------------|
| **Spring RabbitMQ → Azure Service Bus** | Converts Spring AMQP/JMS with RabbitMQ to Azure Service Bus |
| **ActiveMQ → Azure Service Bus** | Converts ActiveMQ producers/consumers/connection factories |
| **AWS SQS → Azure Service Bus** | Translates SQS-specific code to Azure Service Bus |

### Identity & Security
| Task | Description |
|------|-------------|
| **Managed Identities for Database** | Prepares code for Managed Identity auth to Azure SQL, MySQL, PostgreSQL, Cosmos DB |
| **Managed Identities for Credentials** | Transforms messaging auth to use Managed Identity (Event Hubs, Service Bus) |
| **User Auth → Microsoft Entra ID** | Transitions LDAP-based auth to Microsoft Entra ID |
| **Secrets → Azure Key Vault** | Migrates hardcoded secrets and local certificates to Key Vault |
| **AWS Secret Manager → Azure Key Vault** | Transforms all secret management to Azure Key Vault |

### Storage & Data
| Task | Description |
|------|-------------|
| **AWS S3 → Azure Blob Storage** | Converts S3 interaction code to Azure Blob Storage |
| **Local File I/O → Azure Storage File Share** | Converts local file operations to Azure Storage mount paths |
| **Oracle SQL → PostgreSQL** | Converts Oracle-specific SQL to PostgreSQL equivalents |

### Communication & Monitoring
| Task | Description |
|------|-------------|
| **Java Mail → Azure Communication Service** | Converts SMTP email to Azure Communication Services |
| **Logging → Console (Azure Monitor)** | Converts file-based logging to console-based for Azure Monitor integration |

## MCP Server

GitHub Copilot modernization uses an **MCP (Model Context Protocol) server** for enhanced code transformation:

- Registered and started automatically after VS Code extension installation
- NPM package: `@microsoft/github-copilot-app-modernization-mcp-server`
- Logs location: `~/.ghcp-appmod-java/logs`

### MCP Configuration (for Cloud Coding Agent)
```json
{
  "mcpServers": {
    "app-modernization": {
      "type": "local",
      "command": "npx",
      "tools": ["*"],
      "args": ["-y", "@microsoft/github-copilot-app-modernization-mcp-server"]
    }
  }
}
```

## Model Configuration

- Default model: **Claude Sonnet 4.5** (falls back to 'auto' if unavailable)
- Change via: Agent menu → **Configure Custom Agents** → modify `model` setting
- Or use the language model picker in chat window for current session
- **Recommendation**: Newer models outperform previous ones; Claude Sonnet models recommended for accuracy

## Limitations

- Java backend apps only (no frontend/mobile)
- Maven and Gradle (Wrapper v5+) projects only
- Kotlin DSL not supported
- Git repositories only (no other VCS)
- No guarantee that changes are optimal or best practices
- IntelliJ: **My Skills** feature not yet supported
- IntelliJ: Windows/macOS only (no Linux)

## Best Practices

1. **Always review** code changes before merging to production
2. Run all tests and complete QA checks per your change management process
3. Enable "suggestions matching public code" in GitHub Copilot settings (prevents blocking of pom.xml changes)
4. Use projects meeting the specified characteristics (Maven/Gradle, Git-based)
