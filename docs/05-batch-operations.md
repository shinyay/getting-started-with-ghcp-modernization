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

### Execution Options

#### Local Assessment (Sequential)
```bash
# Interactive
modernize
# → Select repos → 1. Assess application → 1. Assess locally

# Non-interactive
modernize assess --multi-repo
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

# Non-interactive
modernize upgrade "Java 21"
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

1. **Language detection**: Auto-detects from first repository
2. **Plan creation**: Creates upgrade plan based on prompt (or uses latest LTS)
3. **Execution**: Applies upgrade to each repository
4. **Validation**: Builds and validates changes per repository

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
