# Key Concepts & Comparison Matrix

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) and verified against the live CLI: **April 2026***

## Concept Map

```
GitHub Copilot Modernization
├── Two Layers
│   ├── IDE Experience (GA)
│   │   ├── VS Code + Extensions
│   │   ├── Visual Studio + Built-in
│   │   ├── IntelliJ IDEA + Plugin
│   │   ├── GitHub Copilot CLI
│   │   └── GitHub.com (Coding Agent)
│   └── Modernization Agent / CLI (Preview)
│       ├── Interactive Mode (TUI)
│       └── Non-Interactive Mode (CLI/Headless)
│
├── Supported Languages
│   ├── Java (Maven, Gradle)
│   └── .NET (MSBuild)
│
├── Workflow: Assess → Plan → Execute
│   ├── Assessment: Code analysis, dependency mapping, readiness scoring
│   ├── Planning: Strategy generation, task breakdown, success criteria
│   └── Execution: Code transformation, build validation, CVE scanning, commits
│
├── Task Types
│   ├── Predefined Tasks (Microsoft best practices)
│   └── Custom Skills (Organization patterns)
│
├── Scale
│   ├── Single App (IDE or CLI)
│   ├── Multi-App Batch (CLI)
│   └── Cloud Coding Agent Delegation
│
└── Azure Targets
    ├── App Service
    ├── Container Apps
    ├── AKS
    └── AKS Automatic
```

## IDE vs. CLI Comparison

| Feature | IDE Experience | Modernization Agent (CLI) |
|---------|---------------|--------------------------|
| **Status** | GA | Public Preview |
| **Target user** | Individual developers | Architects, platform teams |
| **Scale** | Single application | Multi-app, enterprise-scale |
| **Interaction** | Chat-based (Copilot Agent Mode) | TUI + CLI + headless |
| **CI/CD integration** | Via GitHub.com coding agent | Native CLI support |
| **Batch operations** | ❌ | ✅ (assess + upgrade) |
| **Cloud delegation** | Via GitHub.com | ✅ Cloud Coding Agents |
| **Custom skills** | ✅ Create & apply in IDE | ✅ Auto-detected in plans |
| **Assessment reports** | Per-app | Per-app + aggregated |
| **Output artifacts** | `.github/upgrades/` | `.github/modernize/` |
| **Languages** | Java, .NET | Java, .NET |

## Java vs. .NET Comparison

| Feature | Java | .NET |
|---------|------|------|
| **IDE support** | VS Code, IntelliJ IDEA | Visual Studio, VS Code, CLI, GitHub.com |
| **Agent name** | `@modernize` / extension | `@Modernize` / `@modernize-dotnet` |
| **Build systems** | Maven, Gradle (Wrapper v5+) | MSBuild (.csproj, .sln) |
| **Upgrade tool** | OpenRewrite + AI | AI-powered transformation |
| **Version range** | JDK 8 → 21 | .NET Framework → .NET 10+ |
| **Framework focus** | Spring Boot (≤3.5), Jakarta EE (≤10) | ASP.NET Core, Blazor, WPF, WinForms |
| **Predefined tasks** | 13 tasks | 10 tasks |
| **MCP server** | `@microsoft/github-copilot-app-modernization-mcp-server` | Built-in |
| **IntelliJ support** | ✅ (Win/Mac only) | N/A |
| **Custom Skills UI** | ✅ VS Code, ❌ IntelliJ | ✅ Visual Studio |
| **Kotlin DSL** | ❌ Not supported | N/A |

## Artifact Output Locations

### IDE Experience
```
.github/
└── upgrades/
    └── {scenarioId}/
        ├── assessment.md    # Stage 1: Assessment results
        ├── plan.md          # Stage 2: Upgrade plan
        └── tasks.md         # Stage 3: Executable tasks
```

### Modernization Agent (CLI)
```
.github/
└── modernize/
    ├── assessment/          # Assessment reports (JSON, MD, HTML)
    ├── {plan-name}/
    │   ├── plan.md          # Modernization strategy
    │   └── tasks.json       # Structured task breakdown
    ├── config.json          # Repository configuration
    └── repos.json           # Multi-repo configuration
```

## Predefined Tasks Catalog — Complete Reference

> **ℹ️ "Predefined task" is IDE nomenclature.** The names below are what
> the **VS Code TASKS panel** surfaces as one-click options. **The CLI
> has no equivalent listing command** — `modernize plan` only exposes
> `create` and `execute`. From the CLI you trigger the same migrations
> with a free-form prompt to `plan create`, e.g.
> `modernize plan create "Migrate from RabbitMQ to Azure Service Bus"`.
> The agent matches your prompt against this same catalog under the
> hood. See [docs/04 — `modernize plan create`](04-modernization-agent-cli.md#modernize-plan-create)
> for the prompt-authoring conventions.

### Java Tasks (13)

| # | Category | Task Name | Migration Path |
|---|----------|-----------|----------------|
| 1 | Messaging | Spring RabbitMQ → Azure Service Bus | RabbitMQ → Service Bus |
| 2 | Messaging | ActiveMQ → Azure Service Bus | ActiveMQ → Service Bus |
| 3 | Messaging | AWS SQS → Azure Service Bus | AWS SQS → Service Bus |
| 4 | Database | Managed Identities for Database | Local DB → Azure DB (SQL, MySQL, PostgreSQL, Cosmos DB) |
| 5 | Security | Managed Identities for Credentials | Connection strings → Managed Identity |
| 6 | Identity | User Auth → Microsoft Entra ID | LDAP → Entra ID |
| 7 | Secrets | Secrets → Azure Key Vault | Hardcoded secrets/certs → Key Vault |
| 8 | Secrets | AWS Secret Manager → Azure Key Vault | AWS Secrets → Key Vault |
| 9 | Storage | AWS S3 → Azure Blob Storage | S3 → Blob Storage |
| 10 | Storage | Local File I/O → Azure Storage File Share | Local files → File Share mounts |
| 11 | Data | Oracle SQL → PostgreSQL | Oracle dialect → PostgreSQL dialect |
| 12 | Email | Java Mail → Azure Communication Service | SMTP → Azure Communication Services |
| 13 | Monitoring | Logging → Console (Azure Monitor) | File logging → Console logging |

### .NET Tasks (10)

| # | Category | Task Name | Migration Path |
|---|----------|-----------|----------------|
| 1 | Database | Managed Identity Database | DB2/Oracle/SQL Server → Azure SQL/MI/PostgreSQL |
| 2 | Storage | Azure File Storage | Local filesystem → Azure File Storage |
| 3 | Storage | Azure Blob Storage | On-prem/cross-cloud → Azure Blob Storage |
| 4 | Identity | Microsoft Entra ID | Windows AD → Entra ID |
| 5 | Security | Managed Identity + Azure Key Vault | Plaintext credentials → Managed Identity + Key Vault |
| 6 | Messaging | Azure Service Bus | MSMQ/RabbitMQ/AWS SQS → Service Bus |
| 7 | Email | Azure Communication Service Email | SMTP → Azure Communication Services |
| 8 | Events | Confluent Cloud / Azure Event Hub | Local Kafka → Confluent Cloud / Event Hubs |
| 9 | Monitoring | OpenTelemetry on Azure | log4net/serilog/Event Log → OpenTelemetry |
| 10 | Caching | Azure Cache for Redis | In-memory/local Redis → Azure Cache for Redis |

For the latest .NET predefined task list, see the [official .NET modernization documentation](https://learn.microsoft.com/en-us/dotnet/core/porting/github-copilot-app-modernization-overview#predefined-tasks-for-migration).

## Key Technologies Used

| Technology | Role |
|-----------|------|
| **OpenRewrite** | Deterministic code transformation (API replacements, dependency updates) for Java |
| **GitHub Copilot Agent Mode** | AI-powered code analysis and generation |
| **MCP (Model Context Protocol)** | Tool integration for enhanced code transformation |
| **Cloud Coding Agents** | Parallel cloud execution of modernization tasks |
| **Agent Skills Specification** | Standard format for custom skill definition |

## Security & Privacy Summary

| Concern | Answer |
|---------|--------|
| Code stored? | ❌ No — not retained beyond immediate session |
| Code used for training? | ❌ No — never used to train models |
| Custom skills collected? | ❌ No — not transmitted or stored |
| Session data? | Deleted after upgrade/migration completes |
| Telemetry? | Project types, upgrade intent, duration only (no PII) |
| Telemetry opt-out? | ✅ Yes — via IDE privacy settings |
