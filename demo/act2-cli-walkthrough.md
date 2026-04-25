# Act 2: "Discover Your Portfolio" — CLI Assessment Walkthrough

> **Duration**: 8 minutes (05:00–13:00)  
> **Mode**: WALKTHROUGH — uses pre-generated content (NOT live execution)  
> **Source**: Content from [fallback/cli-assessment-report.md](fallback/cli-assessment-report.md)
>
> **Verified With**: `claude-sonnet-4.6` + `modernize` CLI v0.0.293+ + GitHub Copilot App Modernization for Java, 2026-04-25

---

## Minute 5:00–6:00 — Introduce the CLI

> "Before we start fixing individual apps, let's zoom out. How do you even know what needs modernization across a portfolio of 50 or 100 applications?"
>
> "The **Modernize CLI** handles portfolio-level discovery. You define your repositories in a simple JSON file..."

**Show** `repos.json` (in terminal or pre-written file):

```json
[
  { "name": "PhotoAlbum-Java", "url": "https://github.com/Azure-Samples/PhotoAlbum-Java.git" },
  { "name": "TaskTracker",     "url": "https://github.com/your-org/task-tracker-app.git"     },
  { "name": "NewsFeedSite",    "url": "https://github.com/Azure-Samples/NewsFeedSite.git"    }
]
```

**Show** the command:

```bash
# v0.0.293+: prefer --source pointing at a repos.json manifest
modernize assess --source ./.github/modernize/repos.json
```

> "One command assesses everything. Or you can delegate to **Cloud Coding Agents** for parallel processing across your entire portfolio (`--delegate cloud`). Either way, you get back a comprehensive report."

> 📝 Older decks may show `modernize assess --multi-repo`; that flag still parses in v0.0.293 but emits a deprecation notice — `--source` is the supported portfolio entrypoint going forward.

---

## Minute 6:00–7:00 — Dashboard

Open the CLI assessment report and show the **Dashboard** section:

> "Here's the aggregated report for our 3-app portfolio."

**Point out the key metrics:**

| Metric | Value |
|--------|-------|
| Applications assessed | 3 |
| Need framework upgrade | 2 |
| Need security remediation | 1 |
| Total issues | 47 (12 Mandatory · 23 Potential · 12 Optional) |
| Effort: Small | 1 app (TaskTracker) |
| Effort: Medium | 1 app (PhotoAlbum-Java) |
| Effort: Large | 1 app (NewsFeedSite) |

> "At a glance — we have 3 apps, 47 issues across them, and a mix of effort levels. Let's look at what the CLI recommends."

---

## Minute 7:00–9:00 — Recommendations

### Azure Services Mapping

> "The CLI maps your current dependencies to recommended Azure equivalents."

| Current | Recommended Azure Service |
|---------|--------------------------|
| Oracle Database | Azure Database for PostgreSQL + Managed Identity |
| RabbitMQ | Azure Service Bus |
| Hardcoded secrets | Azure Key Vault |
| File-based logging | Azure Monitor via console logging |

### Target Platform

> "Based on each app's architecture, it recommends the right Azure hosting:"

| App | Recommended Platform | Reason |
|-----|---------------------|--------|
| PhotoAlbum-Java | Azure Container Apps | Web app, Spring Boot, containerizable |
| TaskTracker | Azure Container Apps | REST API, Spring Boot, lightweight |
| NewsFeedSite | Azure Kubernetes Service | Multi-component (client + service), WebSocket |

### Upgrade Paths

> "And the framework upgrade paths are clearly identified:"

| App | Current | Target |
|-----|---------|--------|
| PhotoAlbum-Java | Java 8, Spring Boot 2.7 | Java 21, Spring Boot 3.x |
| TaskTracker | Java 17, Spring Boot 3.2 | Already current (secrets only) |
| NewsFeedSite | Java 17, Servlet/Jetty (multi-module) | Java 21, Spring Boot 3.x |

---

## Minute 9:00–11:00 — Migration Waves

> "This is my favorite part of the report — **migration waves**. The CLI sequences your apps by readiness and risk."

### Wave 1: Quick Win

| App | Why first | Effort | Key change |
|-----|-----------|--------|------------|
| **TaskTracker** | Already on Spring Boot 3.2, Java 17 | Small | Secrets → Azure Key Vault only |

> "Start here — it's already on a modern framework. The only issue is hardcoded secrets. Quick win, immediate security improvement."

### Wave 2: Core Upgrade

| App | Why second | Effort | Key changes |
|-----|------------|--------|------------|
| **PhotoAlbum-Java** | Standard Spring Boot app, well-structured | Medium | Java 8→21, Spring Boot 2.7→3.x, Oracle→PostgreSQL |

> "Once Wave 1 proves the process works, tackle this one. It's a standard upgrade — the kind Copilot modernization handles very well."

### Wave 3: Major Modernization

| App | Why last | Effort | Key changes |
|-----|----------|--------|------------|
| **NewsFeedSite** | Non-standard architecture (Jetty + Servlets, multi-module) | Large | Java 17→21, Jetty→Spring Boot, RabbitMQ→Service Bus |

> "Save this for last — it needs architectural changes beyond a simple upgrade. The patterns learned from Wave 1 and 2 can be captured as custom skills to accelerate this."

**For Managers:**

> "This wave approach means you get **early wins** — security improvements deployed in days — while the harder applications are prepared in parallel. Risk is managed, value is delivered incrementally."

---

## Minute 11:00–12:00 — Per-App Assessment Matrix

> "And here's the summary matrix — one row per app, everything at a glance."

| App | Framework | Java | Target Platform | Upgrade | Mandatory | Potential | Effort |
|-----|-----------|------|-----------------|---------|-----------|-----------|--------|
| PhotoAlbum-Java | Spring Boot 2.7 | 8 | Container Apps | Java 21 + SB 3.x | 8 | 12 | Medium |
| TaskTracker | Spring Boot 3.2 | 17 | Container Apps | Secrets only | 3 | 5 | Small |
| NewsFeedSite | Servlet/Jetty | 8 | AKS | Java 21 + SB 3.x | 1 | 6 | Large |

> "This report — covering our entire portfolio — was generated in **minutes**. Normally this discovery and assessment phase takes **weeks or months** with consultants and manual code review."

---

## Minute 12:00–13:00 — Transition to Act 3

> "So we've discovered our portfolio and know what needs modernization — and in what order."
>
> "Now let's actually **do it**. I'll show you two live scenarios:"
>
> "First — the PhotoAlbum app from Wave 2. We'll upgrade it from Java 8 to 21 and Spring Boot 2.7 to 3."
>
> "Then — the TaskTracker from Wave 1. We'll migrate its hardcoded secrets to Azure Key Vault."
>
> "Let's start with the upgrade."

---

## Preparation Checklist

- [ ] `demo/fallback/cli-assessment-report.md` open or ready to display
- [ ] Familiar with all sections of the report
- [ ] Key transition phrases rehearsed
