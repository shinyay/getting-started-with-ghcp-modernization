# Getting Started with GitHub Copilot Modernization

> **A 60-minute demo, a half-/full-day hands-on workshop, and a comprehensive knowledge base for AI-powered application modernization with GitHub Copilot — from legacy assessment to code transformation.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/f3ac65a05ed8c8ea70b653875ccac0c6dbc10ba1/LICENSE)

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) and verified live: **April 2026***
>
> **Tested With**: `modernize v0.0.293+` · `Copilot CLI 1.0.36+` · `claude-sonnet-4.6` · VS Code 1.106+ (Insiders recommended) — verified 2026-04-25

[GitHub Copilot modernization](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) is an **agentic, end-to-end solution** that analyzes, upgrades, and migrates Java and .NET applications to Azure. It follows an **Assess → Plan → Execute** workflow with humans in the loop at every checkpoint — every recommendation is transparent, every change is reviewable, and every step is validated via git.

This repository provides everything needed to **demonstrate** GitHub Copilot modernization to a mixed audience of developers, architects, and managers:

- 🎬 **7 presenter scripts** with minute-by-minute narration (including an optional .NET act)
- 🛡️ **3 fallback files** for demo resilience (pre-generated diffs)
- 🔧 **1 custom demo app** (Spring Boot 3.2 with intentional hardcoded secrets)
- 🧑‍🏫 **7 hands-on workshop labs** (half-day Labs 1-3 / full-day Labs 1-6 / optional Lab 7 for .NET)
- 📚 **10 knowledge base documents** covering the entire platform
- ⚙️ **2 setup scripts** (`demo/setup.sh` for the demo, `workshop/setup.sh` for the labs)

> [!NOTE]
> GitHub Copilot modernization **IDE experience is GA** for both Java and .NET. The **Modernization Agent (CLI)** is in **Public Preview** as of April 2026. This demo covers both.

> [!IMPORTANT]
> **Hands-on scope:** Most demo scripts and workshop labs are **Java-focused** (Spring Boot + Maven). A **.NET 6 → .NET 10 upgrade** is also covered hands-on by **Lab 7** (full-day, optional) and the matching **Demo Act 3c** walkthrough, both built on the `dotnet-sample-app` shipped in this repo. The knowledge base docs (see [`docs/`](docs/)) provide comprehensive coverage of both **Java and .NET** modernization. For additional .NET hands-on guidance, refer to the [official .NET modernization documentation](https://learn.microsoft.com/en-us/dotnet/core/porting/github-copilot-app-modernization-overview).

---

## 🚀 Quick Start

### Prerequisites

| Tool | Version | Verify |
|------|---------|--------|
| GitHub Copilot | Any plan (Free/Pro/Pro+/Business/Enterprise) | [github.com/settings/copilot](https://github.com/settings/copilot) |
| VS Code | 1.106+ (**Insiders** recommended for the latest preview features) | `code --version` |
| VS Code Extensions | Copilot + Copilot Chat + Modernization (Java and/or .NET) | `code --list-extensions \| grep -E "copilot\|migrate"` |
| Java | **JDK 21+ recommended** (JDK 17+ acceptable for everything except Lab 1's *post*-upgrade build) | `java -version` |
| Maven | 3.8+ | `mvn -version` |
| Modernization Agent CLI | `v0.0.293+` (REQUIRED for Lab 2 / Lab 5 and Demo Act 2) | `modernize --version` |
| .NET SDK | **SDK 10+** (only required for Lab 7 / Demo Act 3c) | `dotnet --version` |
| Copilot CLI | `1.0.36+` (used by Lab 5 / Demo) | `copilot --version` |
| Git | Any | `git --version` |

👉 **Full setup guide**: [demo/00-prerequisites.md](demo/00-prerequisites.md)

### One-Command Setup

```bash
git clone https://github.com/shinyay/getting-started-with-ghcp-modernization.git
cd getting-started-with-ghcp-modernization
bash demo/setup.sh
```

The setup script clones sample repos, warms Maven caches, builds the demo app, and verifies all prerequisites.

### Run the Demo

Follow the **[Presenter Guide](demo/presenter-guide.md)** for the full 60-minute flow, or jump to individual acts:

```
Act 1  → demo/act1-opening.md                  (5 min — Opening hook)
Act 2  → demo/act2-cli-walkthrough.md           (8 min — Portfolio discovery)
Act 3a → demo/act3-scenario1-upgrade.md        (20 min — LIVE version upgrade — Java)
Act 3b → demo/act3-scenario2-secrets.md        (15 min — LIVE secrets migration — Java)
Act 3c → demo/act3c-scenario3-dotnet-upgrade.md (10 min — Optional .NET 6 → .NET 10 walkthrough)
Act 4  → demo/act4-closing.md                   (7 min — Custom Skills + closing)
```

---

## 🎬 Demo Overview — 3-Act Narrative (60 min)

The demo follows a **Discover → Modernize → Scale** arc that mirrors a real enterprise modernization journey:

```
┌─────────────────────────────────────────────────────────────────────┐
│ Act 1: "The Problem"              │  5 min │ Narration              │
│   Show legacy Java 8 + Spring Boot 2.7 pain — EOL frameworks,     │
│   javax imports, hardcoded secrets                                  │
├───────────────────────────────────┼────────┼────────────────────────┤
│ Act 2: "Discover Your Portfolio"  │  8 min │ Walkthrough            │
│   CLI batch assessment report — 3-app portfolio analysis,          │
│   migration waves, Azure service recommendations                   │
├───────────────────────────────────┼────────┼────────────────────────┤
│ Act 3a: Version Upgrade           │ 20 min │ ⚡ LIVE                │
│   PhotoAlbum-Java: Java 8→21, Spring Boot 2.7→3.x                 │
│   Shows: OpenRewrite + AI, javax→jakarta, git-traced commits       │
├───────────────────────────────────┼────────┼────────────────────────┤
│ Act 3b: Secrets Migration         │ 15 min │ ⚡ LIVE                │
│   Task Tracker: 3 hardcoded secrets → Azure Key Vault              │
│   Shows: Predefined tasks, Managed Identity, compliance            │
├───────────────────────────────────┼────────┼────────────────────────┤
│ Act 4: "Scale & Standardize"      │  7 min │ Narration              │
│   Custom Skills teaser (SKILL.md), batch upgrade, Cloud Coding     │
│   Agents, recap, call to action                                     │
├───────────────────────────────────┼────────┼────────────────────────┤
│ Buffer                            │  5 min │ Absorbs overruns / Q&A │
└───────────────────────────────────┴────────┴────────────────────────┘
```

### Demo Risk Management

| Scenario | Mode | Risk | Fallback |
|----------|------|------|----------|
| CLI Assessment | Walkthrough (pre-generated) | 🟢 LOW | IS the pre-generated content — never fails |
| Version Upgrade | ⚡ LIVE | 🟡 MEDIUM | [scenario1-expected-diff.md](demo/fallback/scenario1-expected-diff.md) |
| Secrets Migration | ⚡ LIVE | 🟡 MEDIUM | [scenario2-expected-diff.md](demo/fallback/scenario2-expected-diff.md) |
| Custom Skills | Brief file show | 🟢 LOW | Just show SKILL.md in browser |

---

## 📖 Demo Guides

| File | Duration | Mode | Description |
|------|----------|------|-------------|
| [00-prerequisites.md](demo/00-prerequisites.md) | — | Setup | Environment setup, VS Code settings, verification script |
| [act1-opening.md](demo/act1-opening.md) | 5 min | Narration | Opening hook — audience questions, show legacy code pain |
| [act2-cli-walkthrough.md](demo/act2-cli-walkthrough.md) | 8 min | Walkthrough | CLI assessment report — dashboard, waves, recommendations |
| [act3-scenario1-upgrade.md](demo/act3-scenario1-upgrade.md) | 20 min | ⚡ LIVE | PhotoAlbum-Java: Java 8→21, Spring Boot 2.7→3.x |
| [act3-scenario2-secrets.md](demo/act3-scenario2-secrets.md) | 15 min | ⚡ LIVE | Task Tracker: 3 hardcoded secrets → Azure Key Vault |
| [act3c-scenario3-dotnet-upgrade.md](demo/act3c-scenario3-dotnet-upgrade.md) | 10 min | Walkthrough | Optional .NET 6 → .NET 10 upgrade for mixed audiences (uses `dotnet-sample-app`) |
| [act4-closing.md](demo/act4-closing.md) | 7 min | Narration | Custom Skills teaser, scale message, recap, CTA |
| [presenter-guide.md](demo/presenter-guide.md) | — | Reference | **Master guide**: timing table, transitions, Q&A, recovery strategies |

### Fallback Materials

| File | Purpose |
|------|---------|
| [cli-assessment-report.md](demo/fallback/cli-assessment-report.md) | Simulated 3-app portfolio assessment (IS the Act 2 content) |
| [scenario1-expected-diff.md](demo/fallback/scenario1-expected-diff.md) | Expected upgrade diff + recovery script |
| [scenario2-expected-diff.md](demo/fallback/scenario2-expected-diff.md) | Expected secrets migration diff + recovery script |

---

## 🔧 Demo Application — Task Tracker

The custom demo app at [`demo-apps/task-tracker-app/`](demo-apps/task-tracker-app/) is a Spring Boot 3.2.5 REST API intentionally loaded with hardcoded secrets for the Scenario 2 demo.

| Property | Value |
|----------|-------|
| **Framework** | Spring Boot 3.2.5 |
| **Java** | 17 |
| **Database** | H2 in-memory (zero infrastructure) |
| **Build** | `mvn clean package` |
| **Run** | `mvn spring-boot:run` (port 8081) |

### Intentional Security Issues (3 Hardcoded Secrets)

| # | Location | Secret | Pattern |
|---|----------|--------|---------|
| 1 | `application.properties` | `spring.datasource.password=SuperSecret123!` + API keys | Properties file |
| 2 | `config/ExternalApiConfig.java` | `apiKey` and `apiSecret` as string fields | Java config class |
| 3 | `service/NotificationService.java` | `@Value("${app.webhook.secret:whsec_...}")` | `@Value` with hardcoded default |

These 3 patterns represent the most common enterprise secret anti-patterns and are designed to be detected by the "Secrets and Certificate Management to Azure Key Vault" predefined task.

---

## 🎓 Workshop — Hands-On Labs

The workshop provides **participant-driven** hands-on labs using **different apps and scenarios** from the demo — minimal overlap by design.

> [!NOTE]
> Labs 1-6 are Java-focused (Spring Boot + Maven). **Lab 7** adds a hands-on .NET 6 → .NET 10 upgrade for mixed audiences and is offered as an optional add-on after the full-day core. Deeper .NET background lives in the knowledge base at [`docs/03-ide-experience-dotnet.md`](docs/03-ide-experience-dotnet.md).

### Two Formats

| Format | Duration | Labs | Best For |
|--------|----------|------|----------|
| **Half-Day** | 3.5 hours | Labs 1-3 | Teams wanting an introduction with hands-on experience |
| **Full-Day** | 6h30m core + 50min optional Lab 7 | Labs 1-6 (+ Lab 7 optional) | Teams planning real modernization projects; optional .NET track |

👉 **Full agendas**: [workshop/agenda.md](workshop/agenda.md) · **Instructor guide**: [workshop/instructor-guide.md](workshop/instructor-guide.md)

### Labs

| Lab | Duration | Format | Topic | App |
|-----|----------|--------|-------|-----|
| [Lab 1](workshop/lab1-version-upgrade.md) | 50 min | Half+Full | Version upgrade: SB 2.7 + Java 11 → Java 21 + SB 3.x | BookStore |
| [Lab 2](workshop/lab2-cli-assessment.md) | 45 min | Half+Full | CLI portfolio assessment across 4 apps | All 4 apps |
| [Lab 3](workshop/lab3-custom-skills.md) | 30 min | Half+Full | Create a JUnit 4→5 custom skill | BookStore |
| [Lab 4](workshop/lab4-predefined-task.md) | 50 min | Full only | Predefined task: file logging → console | NotesApp |
| [Lab 5](workshop/lab5-cli-execute.md) | 50 min | Full only | CLI batch upgrade + plan execute | BookStore |
| [Lab 6](workshop/lab6-bring-your-own.md) | 40 min | Full only | Apply to your own project | Participant's app |
| [Lab 7](workshop/lab7-dotnet-upgrade.md) | 50 min | Full-day **optional** add-on | .NET 6 → .NET 10 upgrade (IDE + CLI parallel paths) | dotnet-sample-app |

### Workshop Apps

| App | Stack | Labs | Key Upgrade Targets |
|-----|-------|------|-------------------|
| **BookStore** | Spring Boot 2.7 + Java 11 + JUnit 4 | 1, 3, 5 | javax→jakarta, JUnit 4→5, version upgrade |
| **NotesApp** | Spring Boot 3.2 + Java 17 + file logging | 4 | Logback FILE appender, FileWriter audit log |
| **inventory-api** | Spring Boot 2.7 + Java 8 (stub) | 2, 5 | CLI portfolio variety |
| **order-service** | Spring Boot 3.1 + Java 17 (stub) | 2, 5 | CLI portfolio variety |
| **DotnetSampleApp** | .NET 6.0 + hardcoded secrets | 7 | .NET 6→10 upgrade |

### Workshop Setup

```bash
bash workshop/setup.sh          # Verify prereqs + build all apps
bash workshop/validate.sh lab1  # Check lab 1 completion (after doing the lab)
```

---

## 📚 Knowledge Base

Comprehensive research on GitHub Copilot modernization, covering the entire platform:

| Document | Topic | Key Content |
|----------|-------|-------------|
| [01 — Overview & Architecture](docs/01-overview-and-architecture.md) | Platform architecture | Two-layer design (IDE + CLI), Assess→Plan→Execute workflow, supported languages |
| [02 — IDE Experience (Java)](docs/02-ide-experience-java.md) | Java IDE modernization | VS Code/IntelliJ setup, 13 predefined tasks, MCP server, JDK 8→21 upgrade paths |
| [03 — IDE Experience (.NET)](docs/03-ide-experience-dotnet.md) | .NET IDE modernization | Visual Studio/VS Code/CLI/GitHub.com, 10 predefined tasks, .NET Framework→.NET 10 |
| [04 — Modernization Agent CLI](docs/04-modernization-agent-cli.md) | CLI reference | `assess`, `plan create`, `plan execute`, `upgrade` commands, config, installation |
| [05 — Batch Operations](docs/05-batch-operations.md) | Enterprise scale | Batch assessment, batch upgrade, Cloud Coding Agent delegation, repos.json |
| [06 — Custom Skills](docs/06-custom-skills.md) | Extensibility | Agent Skills specification, SKILL.md format, creating/sharing/applying skills |
| [07 — Key Concepts & Comparison](docs/07-key-concepts-and-comparison.md) | Reference matrix | IDE vs CLI comparison, Java vs .NET, complete predefined task catalog (23 tasks) |
| [08 — Workshop Preparation](docs/08-workshop-preparation.md) | Workshop planning | 6 demo scenarios, half-day/full-day agendas, commands cheat sheet, prerequisites |
| [09 — FAQ & Troubleshooting](docs/09-faq-and-troubleshooting.md) | Operational reference | Common errors, recovery patterns, environment gotchas across IDE + CLI |
| [10 — Deployment & Azure Integration](docs/10-deployment-and-azure-integration.md) | Post-modernization | Azure Container Apps / App Service deployment, Key Vault wiring, Managed Identity |

Worked CLI examples and config templates live alongside in [`docs/examples/`](docs/examples/) (`cli-cookbook.md`, `config.json.example`, `repos.json.example`, `repos.json.full-format.example`).

---

## 🏗️ Repository Structure

```
getting-started-with-ghcp-modernization/
│
├── README.md                              # This file
├── CHANGELOG.md                           # Versioned change log
├── CONTRIBUTING.md                        # Contribution guide + Lab Authoring Style
├── LICENSE                                # MIT
├── .gitignore                             # Maven/IDE/modernization artifact exclusions
│
├── .github/                               # Repo automation
│   ├── workflows/ci.yml                   #   CI: builds all apps + runs validate.sh
│   ├── ISSUE_TEMPLATE/                    #   Bug + feature request templates
│   ├── skills/                            #   Reusable Custom Skills (Agent Skills spec)
│   ├── modernize/                         #   Sample CLI artifacts (assessment / plan / tasks)
│   └── java-upgrade/                      #   Sample Java IDE chat-handler artifacts
│
├── demo/                                  # 60-minute demo — presenter scripts & guides
│   ├── 00-prerequisites.md                #   Environment setup & verification
│   ├── act1-opening.md                    #   Act 1: Opening hook (5 min)
│   ├── act2-cli-walkthrough.md            #   Act 2: CLI assessment walkthrough (8 min)
│   ├── act3-scenario1-upgrade.md          #   Act 3a: Java version upgrade — LIVE (20 min)
│   ├── act3-scenario2-secrets.md          #   Act 3b: Java secrets migration — LIVE (15 min)
│   ├── act3c-scenario3-dotnet-upgrade.md  #   Act 3c: Optional .NET 6 → .NET 10 (10 min)
│   ├── act4-closing.md                    #   Act 4: Custom Skills + closing (7 min)
│   ├── presenter-guide.md                 #   Master guide: timing, transitions, Q&A
│   ├── setup.sh                           #   Pre-demo automation (clone, build, verify)
│   └── fallback/                          #   Pre-generated diffs for demo resilience
│       ├── cli-assessment-report.md       #     Simulated 3-app portfolio report
│       ├── scenario1-expected-diff.md     #     Expected upgrade changes + recovery
│       └── scenario2-expected-diff.md     #     Expected secrets migration + recovery
│
├── demo-apps/                             # Custom demo applications
│   └── task-tracker-app/                  #   Spring Boot 3.2 + Java 17 + H2 (🔑 secrets)
│
├── workshop/                              # Hands-on workshop (half-day + full-day + optional)
│   ├── agenda.md                          #   Half-day (3.5h) + full-day (6h30m) + Lab 7 add-on
│   ├── instructor-guide.md                #   Per-lab instructor notes (Labs 1-7)
│   ├── lab1-version-upgrade.md            #   Lab 1: BookStore upgrade (50 min)
│   ├── lab2-cli-assessment.md             #   Lab 2: CLI portfolio assessment (45 min)
│   ├── lab3-custom-skills.md              #   Lab 3: JUnit 4→5 custom skill (30 min)
│   ├── lab4-predefined-task.md            #   Lab 4: Logging→Console (50 min, full-day)
│   ├── lab5-cli-execute.md                #   Lab 5: CLI batch upgrade (50 min, full-day)
│   ├── lab6-bring-your-own.md             #   Lab 6: BYO app clinic (40 min, full-day)
│   ├── lab7-dotnet-upgrade.md             #   Lab 7: .NET 6 → .NET 10 (50 min, optional)
│   ├── setup.sh                           #   Workshop environment setup
│   ├── validate.sh                        #   Per-lab checkpoint validation (lab1-lab7)
│   ├── generate-repos-json.sh             #   Helper for Lab 2 portfolio file
│   └── templates/
│       ├── pre-workshop-email.md          #   Participant invitation + prep checklist
│       └── junit4-to-junit5-skill/SKILL.md #  Scaffolded skill template for Lab 3
│
├── workshop-apps/                         # Workshop-specific applications
│   ├── bookstore-app/                     #   Spring Boot 2.7 + Java 11 + JUnit 4 (Labs 1,3,5)
│   ├── notes-app/                         #   Spring Boot 3.2 + file logging (Lab 4)
│   ├── dotnet-sample-app/                 #   .NET 6.0 + hardcoded secrets (Lab 7 / Act 3c)
│   └── stub-repos/
│       ├── inventory-api/                 #     SB 2.7 + Java 8 stub (Labs 2,5)
│       └── order-service/                 #     SB 3.1 + Java 17 stub (Labs 2,5)
│
└── docs/                                  # Knowledge base — 10 deep-dive documents
    ├── 01-overview-and-architecture.md
    ├── 02-ide-experience-java.md
    ├── 03-ide-experience-dotnet.md
    ├── 04-modernization-agent-cli.md
    ├── 05-batch-operations.md
    ├── 06-custom-skills.md
    ├── 07-key-concepts-and-comparison.md
    ├── 08-workshop-preparation.md
    ├── 09-faq-and-troubleshooting.md
    ├── 10-deployment-and-azure-integration.md
    └── examples/                          # Worked CLI examples + config templates
        ├── cli-cookbook.md
        ├── config.json.example
        ├── repos.json.example
        └── repos.json.full-format.example
```

---

## 🔗 External References

| Resource | URL |
|----------|-----|
| Official Documentation | [learn.microsoft.com/...github-copilot-app-modernization](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) |
| Java Modernization Guide | [learn.microsoft.com/...java](https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java) |
| .NET Modernization Guide | [learn.microsoft.com/...dotnet](https://learn.microsoft.com/en-us/dotnet/core/porting/github-copilot-app-modernization-overview) |
| PhotoAlbum-Java (Scenario 1 app) | [github.com/Azure-Samples/PhotoAlbum-Java](https://github.com/Azure-Samples/PhotoAlbum-Java) |
| NewsFeedSite (Custom Skills example) | [github.com/Azure-Samples/NewsFeedSite](https://github.com/Azure-Samples/NewsFeedSite) |
| Modernize CLI | [github.com/microsoft/modernize-cli](https://github.com/microsoft/modernize-cli) |
| Agent Skills Specification | [agentskills.io/specification](https://agentskills.io/specification) |
| Java Predefined Tasks | [learn.microsoft.com/...predefined-tasks](https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java-predefined-tasks) |

---

## 💬 Feedback

- **This repository**: [GitHub Issues](https://github.com/shinyay/getting-started-with-ghcp-modernization/issues)
- **Modernization Agent (CLI)**: [github-copilot-appmod issues](https://github.com/microsoft/github-copilot-appmod/issues/new?template=feedback-template.yml) or [feedback form](https://aka.ms/ghcp-appmod/feedback)
- **.NET modernization**: [modernize-dotnet issues](https://github.com/dotnet/modernize-dotnet/issues)

## License

Released under the [MIT License](LICENSE).

## Author

- github: <https://github.com/shinyay>
- bluesky: <https://bsky.app/profile/yanashin.bsky.social>
- twitter: <https://twitter.com/yanashin18618>
- mastodon: <https://mastodon.social/@yanashin>
- linkedin: <https://www.linkedin.com/in/yanashin/>
