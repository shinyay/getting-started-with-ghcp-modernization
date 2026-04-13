# IDE Experience — .NET Modernization

## Overview

The IDE experience for .NET is delivered through **Visual Studio**, **Visual Studio Code**, **GitHub Copilot CLI**, and **GitHub.com**, providing upgrade and Azure migration capabilities with a structured three-stage workflow.

## Agent Name

The .NET modernization agent is identified as:
- **Visual Studio**: `@Modernize` (or right-click → Modernize in Solution Explorer)
- **Visual Studio Code**: `@modernize-dotnet`
- **GitHub Copilot CLI**: `@modernize-dotnet`
- **GitHub.com**: `modernize-dotnet` coding agent

## Prerequisites

- GitHub Copilot subscription (Free, Pro, Pro+, Business, or Enterprise)
- **Visual Studio 2026** (or VS 2022 v17.14.17+) / VS Code / GitHub Copilot CLI
- Git-based repository

## Supported Project Types

| Project Type | Supported |
|-------------|-----------|
| ASP.NET Core (MVC, Razor Pages, Web API) | ✅ |
| Blazor | ✅ |
| Azure Functions | ✅ |
| Windows Presentation Foundation (WPF) | ✅ |
| Windows Forms | ✅ |
| Class Libraries | ✅ |
| Console Apps | ✅ |
| Test Projects (MSTest, NUnit) | ✅ |
| .NET Framework projects | ✅ |

## Upgrade Paths

- Older .NET → Latest .NET
- **.NET Framework** → Modern .NET (major migration)
- Modernize codebase with new features
- Migrate components/services to Azure

## Three-Stage Workflow

The .NET modernization agent follows a strict **Assessment → Planning → Execution** workflow, generating markdown files under `.github/upgrades/{scenarioId}/` at each stage:

### Stage 1: Assessment (`assessment.md`)

Copilot examines:
- Project structure and dependencies
- Breaking changes and API compatibility
- Deprecated patterns
- Upgrade scope
- Security vulnerabilities

**Output**: Lists all identified issues so you know exactly what needs attention.

**Example sections**:
- Executive Summary with high-level metrics
- Projects Compatibility analysis
- Package Compatibility analysis
- API Compatibility analysis
- Aggregate NuGet packages details
- Top API Migration Challenges
- Projects Relationship Graph
- Per-project detailed analysis

### Stage 2: Planning (`plan.md`)

Copilot generates:
- Upgrade strategies per project
- Refactoring approaches
- Dependency upgrade paths
- Risk mitigations
- Phase-by-phase migration strategy

**Important**: The plan respects project interdependencies. Modifying the plan to skip a dependency project can break downstream upgrades.

### Stage 3: Execution (`tasks.md`)

Copilot creates sequential tasks with:
- Specific validation criteria per task
- Git commit messages for each step
- Progress tracking (e.g., "3/3 tasks complete (100%)")
- Build and test validation steps

**Git strategy options** (configured during pre-initialization):
- Per task
- Per group of tasks
- At the end

### Workflow Behavior
- If `.github/upgrades/{scenarioId}` exists from a prior attempt → Copilot asks whether to continue or start fresh
- If Copilot can't resolve a problem → asks for help
- Copilot **learns from your interventions** and applies similar fixes if the same issue recurs

## Predefined Tasks (.NET Migration)

### Database
| Task | Description |
|------|-------------|
| **Managed Identity Database (Azure SQL DB, SQL MI, PostgreSQL)** | Migrate from on-prem/legacy DB (DB2, Oracle, SQL Server) with secure managed identity auth |

### Storage
| Task | Description |
|------|-------------|
| **Azure File Storage** | Move file I/O from local filesystem to Azure File Storage |
| **Azure Blob Storage** | Replace on-prem or cross-cloud object storage with Azure Blob Storage |

### Identity & Security
| Task | Description |
|------|-------------|
| **Microsoft Entra ID** | Transition from Windows Active Directory to Entra ID |
| **Managed Identity + Azure Key Vault** | Replace plaintext credentials with managed identities and Key Vault |
| **Azure Cache for Redis (Managed Identity)** | Replace in-memory/local Redis with Azure Cache for Redis |

### Messaging & Events
| Task | Description |
|------|-------------|
| **Azure Service Bus** | Migrate from MSMQ, RabbitMQ, or AWS SQS |
| **Confluent Cloud / Azure Event Hub for Kafka** | Transition from local/on-prem Kafka |

### Communication & Observability
| Task | Description |
|------|-------------|
| **Azure Communication Service Email** | Replace SMTP email sending |
| **OpenTelemetry on Azure** | Transition from log4net, serilog, Windows event log |

## How to Start an Upgrade

### Visual Studio
1. Right-click solution/project in **Solution Explorer** → **Modernize**
2. Or open **GitHub Copilot Chat** → type `@Modernize`

### Visual Studio Code
1. Open **GitHub Copilot Chat** panel
2. Type `@modernize-dotnet`
3. Describe your upgrade or migration request

### GitHub Copilot CLI
```
@modernize-dotnet upgrade to .NET 10
```

### GitHub.com
Use the `modernize-dotnet` coding agent in your repository.

## Pre-initialization Configuration

When starting an upgrade, Copilot collects:
1. **Target framework version** (e.g., .NET 10)
2. **Git branching strategy** (new branch recommended)
3. **Workflow mode**: Automatic or guided

## Monitoring Progress

### Visual Studio
1. **View** → **Output** window
2. Select **AppModernizationExtension** from dropdown
3. Real-time command-line output appears

### All environments
- Review `tasks.md` in `.github/upgrades/{scenarioId}/` for step-by-step status
- Each task shows ✓ or [ ] status with timestamps

## Limitations

- Requires local Git repository
- Upgrade suggestions not guaranteed to follow best practices
- Code fixes provided during session don't persist for future upgrades
- Cannot be trained on your codebase (but code is used as context)

## Feedback Channels

- **Visual Studio**: Help → Suggest a Feature / Report a Problem
- **GitHub**: [dotnet/modernize-dotnet](https://github.com/dotnet/modernize-dotnet) issues

## Telemetry

Collects only: project types, upgrade intent, upgrade duration. No user-identifiable information. Can be disabled in Visual Studio privacy settings.
