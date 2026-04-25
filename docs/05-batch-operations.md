# Batch Operations — Enterprise-Scale Modernization

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/): April 2026*

## Overview

Batch operations enable **enterprise-scale modernization** by processing multiple applications simultaneously. There are two batch capabilities:

1. **Batch Assessment** — Analyze multiple repositories at once
2. **Batch Upgrade** — Apply consistent upgrades across multiple repositories

## Batch Assessment

### What It Does

Batch assessment evaluates multiple applications simultaneously, producing:

- **Per-App Reports**: Detailed insights for each repository
- **Aggregated Report**: Cross-repository analysis with summary insights, Azure service recommendations, target platforms, and upgrade paths

### Benefits

| Benefit | Details |
|---------|---------|
| Cross-app visibility | Aggregated reports, cross-repo analysis, prioritization insights |
| Scale & efficiency | Parallel processing (Cloud), automated workflows, weeks → hours |

### Configuration

Create `.github/modernize/repos.json`:

```json
[
  {
    "name": "PhotoAlbum-Java",
    "url": "https://github.com/Azure-Samples/PhotoAlbum-Java.git"
  },
  {
    "name": "eShopOnWeb",
    "url": "https://github.com/dotnet-architecture/eShopOnWeb.git"
  }
]
```

### Prerequisites for Cloud Delegation

Before using `--delegate cloud`, configure each target repository:

#### For Java Applications
Add MCP server configuration in the repository's **Cloud Coding Agent settings** (Settings → Copilot → Coding Agent):
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

#### For .NET Framework Applications
1. Add `.github/workflows/copilot-setup-steps.yaml` configured for `windows-latest` runner
2. Disable the integrated firewall in repository Copilot settings

#### General Requirements
- GitHub Actions permissions must allow workflow creation in each repository
- Check GitHub Actions quota limits for your organization
- Ensure you have admin access to each repository for Cloud Coding Agent delegation

### Execution Options

#### Local Assessment (Sequential)
```bash
# Interactive
modernize
# → Select repos → 1. Assess application → 1. Assess locally

# Non-interactive (v0.0.293+)
modernize assess --source ./.github/modernize/repos.json --no-tty

# Legacy: --multi-repo is deprecated, see docs/04-modernization-agent-cli.md
```

#### Cloud Coding Agent Assessment (Parallel)
```bash
# Interactive
modernize
# → Select repos → 1. Assess application → 2. Delegate to Cloud Coding Agents

# Non-interactive
modernize assess --delegate cloud
```

### Cloud Coding Agent Setup

#### For Java Applications
Configure MCP server in repository's Cloud Coding Agent settings:
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

#### For .NET Framework Applications
1. Configure `.github/workflows/copilot-setup-steps.yaml` for Windows runner:
```yaml
name: "Copilot Setup Step (Windows)"
on:
  workflow_dispatch:
jobs:
  copilot-setup-steps:
    runs-on: windows-latest
    permissions:
      contents: read
    steps:
      - name: Checkout code
        uses: actions/checkout@v5
```
2. **Disable firewall** in repository settings for Cloud Coding Agent

### Aggregated Report Contents

The aggregated report includes:

#### Dashboard
- Portfolio health snapshot: total apps, upgrade needs, blocker/issue counts
- Technology distribution across apps
- Effort distribution (small vs. large)

#### Recommendations
- **Azure Services**: Maps dependencies to Azure equivalents
- **Target Platform**: Hosting choice guidance (Container Apps vs. AKS)
- **Upgrade Path**: Framework upgrade prerequisites
- **Migration Waves**: Sequences apps by readiness and risk into phases

#### Application Assessment Matrix
- Per-app overview: framework, target platform, upgrade recommendation
- Issue breakdown: Mandatory, Potential, Optional
- Effort sizing
- Links to individual app reports

---

## Batch Upgrade

### What It Does

Applies consistent modernization plans across multiple repositories simultaneously.

### Constraints

> ⚠️ **All repositories in a batch upgrade must use the same programming language** (all Java or all .NET). Mixed-language batches will mark mismatched repos as failed and skip them.

### Execution Options

#### Local Upgrade (Sequential)
```bash
# Interactive
modernize
# → Select repos → 2. Upgrade → 1. Upgrade locally

# Non-interactive (v0.0.293+)
modernize upgrade "Java 21" --source ./.github/modernize/repos.json
```

#### Cloud Coding Agent Upgrade (Parallel)
```bash
# Interactive
modernize
# → Select repos → 2. Upgrade → 2. Delegate to Cloud Coding Agents

# Non-interactive
modernize upgrade "Java 21" --delegate cloud
```

### Upgrade Workflow

For a single-repo invocation (`--source ./path/to/app`), the agent:

1. **Plan creation**: `create-java-upgrade-plan` builds a milestone plan
   (Java + Spring Boot hops) tailored to the source's current versions.
2. **Per-milestone execution**: applies an OpenRewrite recipe when one
   exists (`UpgradeToJava21`, `UpgradeSpringBoot_3_3`, …) and falls
   back to manual edits otherwise. Each milestone is committed.
3. **Validation per milestone**: build + unit tests + CVE check +
   behavioral consistency review.
4. **Summary**: writes `modernization-summary.md` and force-adds it
   (the artifact dir is gitignored).

For a multi-repo invocation (`--source repos.json`), the workflow is a
**two-layer plan** with a **minimum-change strategy**:

1. **Top-level plan** (single shared task). The CLI writes a generic
   `001-upgrade-java-21` task to the repo root and dispatches each
   repo sequentially through the **Upgrade Dashboard**.
2. **Per-repo dynamic milestones**. The execution agent inspects each
   repo's actual state and only adds the Spring Boot hops that the
   build actually requires. Example: bookstore-app (Java 11 + SB 2.7.18)
   gets a single `pom.xml` Java bump because SB 2.7.18 still builds on
   Java 21; inventory-api (Java 8 + `javax.persistence`) gets the full
   SB 2.7 → 3.5 hop chain because Jakarta migration is forced.
3. **Per-repo validation** as in single-repo mode.
4. **Per-repo summary** + commits land on the current branch (use a
   throwaway branch).
5. **Aggregated Upgrade Report** at the end lists each repo's outcome.

To force a uniform floor across all repos, pin it in the prompt:
`modernize upgrade "Java 21, Spring Boot 3.5" --source repos.json`.

See [`docs/04-modernization-agent-cli.md` § Multi-Repository Runtime Behavior](04-modernization-agent-cli.md#multi-repository-runtime-behavior-phase-b--batch-mode)
for the full runtime UI reference, and
[`workshop/lab5-cli-execute.md`](../workshop/lab5-cli-execute.md) Phase B
for a hands-on walkthrough.

### Review Results

```bash
# Review changes per repo
cd <repository-name>
git status
git diff

# Create PR
gh pr create --title "Upgrade to Java 21" --body "Automated upgrade by modernization agent"
```

---

## Cloud Coding Agent Integration Architecture

```
┌──────────────────────────────────────────────┐
│          Modernize CLI (Local)                │
│                                              │
│  repos.json → Detect repos                   │
│           ↓                                  │
│  For each repo:                              │
│    → Submit task to Cloud Coding Agent        │
│    → Tasks execute in parallel (cloud)        │
│    → Pull results back locally                │
│           ↓                                  │
│  Generate aggregated report (locally)         │
└──────────────────────────────────────────────┘
          ↕                    ↕
┌──────────────┐    ┌──────────────┐
│  Repo A      │    │  Repo B      │
│  (CCA Job)   │    │  (CCA Job)   │
│  - Assess    │    │  - Assess    │
│  - Plan      │    │  - Plan      │
│  - Execute   │    │  - Execute   │
│  - PR        │    │  - PR        │
└──────────────┘    └──────────────┘
```

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| Repository access errors | Verify `gh auth status`, check repo permissions |
| Clone failures | Verify URLs in repos.json, check network/VPN |
| Assessment failures | Ensure valid Java/NET projects with build files |
| Language mismatch (batch upgrade) | Separate batches by language |
| Build failures after upgrade | Review error messages, check 3rd-party library compatibility |
| Cloud Coding Agent issues | Check GitHub Actions permissions/quotas, verify MCP config |
| .NET Framework cloud issues | Ensure Windows runner config is set |
