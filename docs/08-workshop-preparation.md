# Workshop Preparation — Key Takeaways & Demo Scenarios

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/): April 2026*

## Executive Summary for Workshop

GitHub Copilot modernization is Microsoft's AI-powered solution for **upgrading and migrating Java and .NET applications to Azure**. It follows an **Assess → Plan → Execute** model, operates through both IDE (for developers) and CLI (for architects), and supports enterprise-scale batch operations.

### Three Things to Remember

1. **Two layers**: IDE experience (developer-focused, GA) + Modernization Agent CLI (architect-focused, Preview)
2. **Three stages**: Assessment → Planning → Execution — all transparent, reviewable, and editable
3. **Extensible**: Custom Skills let organizations capture and reuse migration patterns

---

> [!NOTE]
> The **demo scenarios** below include both Java and .NET suggestions, but the **implemented** demo scripts in `demo/` and workshop labs in `workshop/` are currently **Java-only**. .NET scenarios are described here for planning purposes — you would need to set up your own .NET sample application to deliver them live.

## Potential Demo Scenarios

### Demo 1: IDE Experience — Java Spring Boot Upgrade (Beginner)

**Goal**: Upgrade a Spring Boot 2.x app to Spring Boot 3.x using VS Code

**Steps**:
1. Clone `PhotoAlbum-Java` sample
2. Open in VS Code with Copilot modernization extension
3. Invoke `@modernize` in chat
4. Walk through: assessment → plan → execute
5. Show the generated `plan.md` and `progress.md`
6. Review git commits and code changes

**Key talking points**:
- OpenRewrite does the heavy lifting for deterministic transforms
- AI handles the edge cases
- Every change is a reviewable git commit

### Demo 2: IDE Experience — .NET Framework → .NET 10 Upgrade (Intermediate) — *Not yet implemented in this repo*

**Goal**: Upgrade a .NET Framework app to .NET 10 using Visual Studio

**Steps**:
1. Open .NET Framework solution in VS 2026
2. Right-click → Modernize (or `@Modernize` in chat)
3. Walk through three-stage workflow
4. Show `assessment.md`, `plan.md`, `tasks.md` under `.github/upgrades/`
5. Demonstrate intervention when agent encounters issues
6. Show final task completion status

### Demo 3: Predefined Task — Migrate to Azure Service Bus (Intermediate)

**Goal**: Apply a predefined migration task to move from RabbitMQ to Azure Service Bus

**Steps**:
1. Start with a Spring Boot app using RabbitMQ
2. Open Copilot modernization extension
3. Select "Spring RabbitMQ to Azure Service Bus" predefined task
4. Watch the agent create plan and execute migration
5. Review code changes: dependencies, configuration, message handling

### Demo 4: Custom Skills — Create and Apply (Advanced)

**Goal**: Create an organization-specific custom skill and apply it

**Steps**:
1. Create a custom skill via extension UI (or manually)
2. Write SKILL.md with migration instructions and code examples
3. Add resource files
4. Apply the skill to a project
5. Show how the agent auto-detects relevant skills

### Demo 5: Modernize CLI — Multi-Repo Batch Assessment (Enterprise)

**Goal**: Demonstrate enterprise-scale assessment across multiple repos

**Steps**:
1. Install Modernize CLI
2. Create `repos.json` with multiple sample repos
3. Run `modernize assess --multi-repo`
4. Review aggregated report: dashboard, recommendations, assessment matrix
5. Discuss migration waves and prioritization

### Demo 6: Modernize CLI — Batch Upgrade with Cloud Coding Agents (Enterprise)

**Goal**: Demonstrate parallel upgrades across multiple repos

**Steps**:
1. Configure MCP server in sample repos
2. Create `repos.json`
3. Run `modernize upgrade "Java 21" --delegate cloud`
4. Show parallel execution in Cloud Coding Agents
5. Review PRs created automatically

---

## Workshop Agenda Ideas

> **Note:** The agendas below are **alternative suggestions** for longer formats.
> The implemented workshop (see [`workshop/agenda.md`](/workshop/agenda.md)) uses
> a **3.5-hour half-day** and **6.5-hour full-day** format with the labs listed
> in the Workshop section of the main README.

### Half-Day Workshop (4 hours)

| Time | Topic | Type |
|------|-------|------|
| 0:00-0:30 | Introduction to App Modernization & GitHub Copilot Modernization | Lecture |
| 0:30-1:00 | Architecture Deep Dive: Two Layers, Three Stages | Lecture |
| 1:00-1:30 | **Demo**: IDE Experience — Java Upgrade | Live Demo |
| 1:30-2:00 | **Hands-on**: Upgrade PhotoAlbum-Java | Lab |
| 2:00-2:15 | Break | |
| 2:15-2:45 | Predefined Tasks & Custom Skills | Lecture + Demo |
| 2:45-3:15 | **Hands-on**: Apply a predefined task OR create a custom skill | Lab |
| 3:15-3:45 | Modernize CLI & Enterprise Batch Operations | Demo |
| 3:45-4:00 | Q&A and Next Steps | Discussion |

### Full-Day Workshop (8 hours)

Add:
- .NET modernization track
- Custom skills deep dive with hands-on creation
- Multi-repo batch operations hands-on
- Cloud Coding Agent delegation
- CI/CD integration patterns
- Migration planning strategies

---

## Sample Commands Cheat Sheet

### IDE Experience (Java)
```
# In VS Code Copilot Chat:
@modernize upgrade to Java 21 and Spring Boot 3

# In VS Code Copilot Chat:
@modernize migrate from RabbitMQ to Azure Service Bus

# In VS Code Copilot Chat:
@modernize assess this application for Azure migration
```

### IDE Experience (.NET)
```
# In VS Code Copilot Chat:
@modernize-dotnet upgrade to .NET 10

# In Visual Studio Copilot Chat:
@Modernize migrate to Azure SQL with managed identity
```

### Modernize CLI
```bash
# Interactive mode
modernize

# Assess
modernize assess
modernize assess --multi-repo
modernize assess --delegate cloud

# Plan
modernize plan create "upgrade to spring boot 3"
modernize plan create "migrate from oracle to azure postgresql" --plan-name db-migration

# Execute
modernize plan execute --plan-name spring-boot-upgrade

# End-to-end upgrade
modernize upgrade "Java 21"
modernize upgrade ".NET 10"
modernize upgrade "Java 21" --delegate cloud
```

---

## Prerequisites for Workshop Participants

### Required
- [ ] GitHub account with active Copilot subscription
- [ ] Git installed
- [ ] GitHub CLI (`gh`) installed and authenticated

### For Java Track
- [ ] Java 21+ installed
- [ ] Maven or Gradle installed
- [ ] VS Code with GitHub Copilot + Copilot modernization extensions
- [ ] OR IntelliJ IDEA 2023.3+ with plugins (Windows/macOS only)

### For .NET Track
- [ ] .NET SDK (latest) installed
- [ ] Visual Studio 2026 (or VS 2022 v17.14.17+) OR VS Code
- [ ] GitHub Copilot extensions

### For CLI/Enterprise Track
- [ ] Modernize CLI installed (`modernize --version`)
- [ ] Access to sample repositories (or own repos)

### Optional (for deployment demos)
- [ ] Azure subscription
- [ ] Azure CLI installed

---

## Key Resources

| Resource | URL |
|----------|-----|
| Main Documentation | https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/ |
| Java Modernization | https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java |
| .NET Modernization | https://learn.microsoft.com/en-us/dotnet/core/porting/github-copilot-app-modernization-overview |
| Modernize CLI Repo | https://github.com/microsoft/modernize-cli |
| Java Sample App | https://github.com/Azure-Samples/PhotoAlbum-Java |
| .NET Sample App | https://github.com/Azure-Samples/PhotoAlbum |
| Custom Skills Sample | https://github.com/Azure-Samples/NewsFeedSite |
| Agent Skills Spec | https://agentskills.io/specification |
| Java FAQ | https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java-faq |
| .NET FAQ | https://learn.microsoft.com/en-us/dotnet/core/porting/github-copilot-app-modernization-faq |
| Feedback (Agent) | https://github.com/microsoft/github-copilot-appmod/issues |
| Feedback (.NET) | https://github.com/dotnet/modernize-dotnet/issues |
