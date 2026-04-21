# Modernization Agent — CLI Experience

> *Last reviewed against [official documentation](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) and verified against the live CLI: **April 2026***
>
> **Tested CLI version**: `modernize v0.0.293+` (run `modernize --version` to check yours; upgrade with `modernize update`)

## Overview

The Modernization Agent is delivered through the **Modernize CLI** (officially the *GitHub Copilot Modernization Agent*), a command-line tool that orchestrates end-to-end application modernization. It combines **deterministic automation** with **AI-powered intelligence** to enable both interactive and automated modernization workflows.

**Status**: Public Preview · **Source**: [`microsoft/modernize-cli`](https://github.com/microsoft/modernize-cli)

## Installation

### Prerequisites
- **GitHub Copilot subscription**: Free, Pro, Pro+, Business, or Enterprise
- **GitHub CLI (`gh`)**: v2.45.0+ for authentication

### Platform Support
| Platform | Architecture |
|----------|-------------|
| Windows | x64, ARM64 |
| Linux | x64, ARM64 (glibc 2.27+: Ubuntu 18.04+, Debian 10+, Fedora 29+) |
| macOS | Apple Silicon, Intel |

### Installation Commands

#### Linux/macOS — Homebrew (recommended)

```bash
# Tap the Microsoft cask and install
brew tap microsoft/modernize https://github.com/microsoft/modernize-cli
brew install modernize

# Upgrade later with either of:
brew upgrade modernize
modernize update
```

> **Why Homebrew?** Works on macOS (Apple Silicon + Intel) and Linux (via Linuxbrew/WSL). Pins to a tracked release, supports clean uninstall (`brew uninstall modernize`), and avoids piping a remote shell script into `bash`.

#### Linux/macOS — install script (alternative)

```bash
# One-liner install
curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh | bash
```

#### Windows

```powershell
# Option 1: Winget (recommended)
winget install GitHub.Copilot.modernization.agent

# Option 2: PowerShell one-liner
iex (irm 'https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.ps1')

# Option 3: MSI from GitHub releases
# https://github.com/microsoft/modernize-cli/releases/latest
```

#### Verify
```bash
modernize --version
# expected: 0.0.293+<git-sha> or later
```

### Authentication
```bash
gh auth login
```

## Execution Modes

### Interactive Mode (TUI)
```bash
modernize
```
- Menu-driven navigation
- Visual plan and progress indicators
- Guided prompts for configuration
- Multi-repository selection interface

### Non-Interactive Mode (CLI)
```bash
modernize <command> [options]
```
- CI/CD pipeline integration
- Batch operation automation
- Scripting workflows
- Headless environments

## Commands Reference

### `modernize assess`

Analyze applications and generate assessment reports.

> **Supported languages:** Java, .NET, **and JavaScript/TypeScript** (per `modernize assess --help` in v0.0.293). JavaScript/TypeScript support is newer than the rest of the workflow — coverage of upgrade rules is more limited and the `--language` flag below does not yet accept it.

```bash
# Basic assessment (uses current directory, writes HTML report)
modernize assess

# Markdown output (use this when scripting / piping into validators)
modernize assess --format markdown

# Custom output path
modernize assess --output-path ./reports/assessment

# Assess and update a GitHub issue
modernize assess --issue-url https://github.com/org/repo/issues/123

# Specific project
modernize assess --source /path/to/project

# Multi-repo assessment — repeat --source per project
modernize assess \
    --source ./workshop-apps/bookstore-app \
    --source ./workshop-apps/notes-app \
    --source ./workshop-apps/inventory-service

# Multi-repo assessment via JSON config (cannot mix with --source paths)
modernize assess --source ./.github/modernize/repos.json

# Delegate to Cloud Coding Agents
modernize assess --delegate cloud

# Block until cloud assessment completes (useful in CI/CD)
modernize assess --delegate cloud --wait

# Verbose mode for troubleshooting (shows every rule + token usage)
modernize assess --verbose
```

> **⚠️ `--multi-repo` is deprecated.** Earlier releases used `modernize assess --multi-repo` to scan all subdirectories of the current folder. As of v0.0.293, prefer **`--source` (repeatable)** for explicit lists, or **`--source path/to/repos.json`** for portfolio-scale runs. The `--multi-repo` flag still parses today but emits a deprecation notice and may be removed in a future release.

**Options**:
| Option | Default | Description |
|--------|---------|-------------|
| `--source <path \| URL \| repos.json>` | `.` | Source to assess. Repeatable. Accepts a local path, a Git URL, OR a single JSON config file (cannot mix with other source types). |
| `--output-path <path>` | `.github/modernize/assessment/` | Output folder (CWD-relative). |
| `--format <format>` | `html` | `html` or `markdown`. **Default is HTML** — pass `markdown` when you need `.md` files (e.g. `validate.sh`, GitHub issue bodies). |
| `--issue-url <url>` | None | GitHub issue URL to update. |
| `--assess-config <path>` | None | YAML overrides for assessment parameters. See [aka.ms/ghcp-modernization-agent/assess-config](https://aka.ms/ghcp-modernization-agent/assess-config). |
| `--model <model>` | `claude-sonnet-4.6` | LLM model. Run `modernize help models` for the full list. |
| `--delegate <delegate>` | `local` | `local` or `cloud`. Cloud requires `github.com` repos. |
| `--wait` | Disabled | Block until cloud delegation completes (only with `--delegate cloud`). |
| `--force` | Disabled | Force restart delegation, ignoring an in-flight cloud job. |
| `--verbose` | Disabled | Emit per-rule progress, token counts, and timings. |
| `--no-tty` | Disabled | Plain-text output (CI/CD). Per-command flag — not global. |
| `--multi-repo` | *deprecated* | Replaced by repeatable `--source`. |

**Output**: Writes to TWO locations (see [Output Artifacts](#output-artifacts) for the full tree):

- **Aggregate report** (CWD-relative): `.github/modernize/assessment/reports-{yyyyMMddHHmmss}/index.{md,html}`
- **Per-app raw analysis** (source-relative): `<source>/.github/modernize/assessment/...`

When `--issue-url` is set, the aggregate summary is also posted as an issue comment.

### `modernize plan create`

Create a modernization plan from natural language prompt.

```bash
# Migration plan
modernize plan create "migrate from oracle to azure postgresql"

# Upgrade plan with custom name
modernize plan create "upgrade to spring boot 3" --plan-name spring-boot-upgrade

# Deployment plan
modernize plan create "deploy the app to azure container apps" --plan-name deploy-to-aca

# Full options
modernize plan create "upgrade to .NET 8" \
    --source /path/to/project \
    --plan-name dotnet8-upgrade \
    --language dotnet
```

**Prompt Examples**:
- Framework upgrades: `upgrade to spring boot 3`, `upgrade to .NET 10`, `upgrade to JDK 21`
- Database migrations: `migrate from oracle to azure postgresql`
- Cloud migrations: `containerize and deploy to azure container apps`
- Deployment: `deploy to azure app service`, `set up CI/CD pipeline for azure`

**Output**:
- `plan.md` — strategy document
- `tasks.json` — executable task breakdown

**⚠️ Output location depends on `--source`:**
- When `--source` is the **current directory** (the default `.`), output goes to `./.github/modernize/{plan-name}/`.
- When `--source` is a **subdirectory** (e.g. `--source workshop-apps/bookstore-app`), output goes to **`<source>/.github/modernize/{plan-name}/`** — i.e. *inside* the source folder, **not** the current directory.

This is intentional (the plan ships with the app it modernizes), but it surprises first-time users. See [Output Artifacts](#output-artifacts) for the full directory tree.

**Options**:
| Option | Default | Description |
|--------|---------|-------------|
| `--source <path>` | `.` | Path to application source code |
| `--plan-name <name>` | `modernization-plan` | Name for the modernization plan |
| `--language <lang>` | Auto-detected | Programming language. **Only `java` or `dotnet`** are accepted by the CLI in v0.0.293 (the older docs that mention `python` predate the current build). |
| `--overwrite` | Disabled | Overwrite an existing plan with the same name |
| `--model <model>` | `claude-sonnet-4.6` | LLM model to use |
| `--issue-url <url>` | None | GitHub issue URL to update with plan summary |

> **Note:** Earlier revisions of this doc claimed `--language python` was accepted. That is **not true** in v0.0.293 — the CLI rejects it. Track Python language support upstream at [microsoft/modernize-cli](https://github.com/microsoft/modernize-cli/issues).

### `modernize plan execute`

Execute a previously created modernization plan.

```bash
# Execute most recent plan
modernize plan execute

# Execute specific plan
modernize plan execute --plan-name spring-boot-upgrade

# Execute with extra instructions
modernize plan execute "skip the test" --plan-name spring-boot-upgrade

# Headless for CI/CD
modernize plan execute --plan-name spring-boot-upgrade --no-tty

# Delegate to cloud
modernize plan execute --delegate cloud
```

**Execution behavior**:
1. Loads plan and task list
2. Processes each task sequentially
3. Applies code transformations
4. Validates builds
5. Scans for CVEs
6. Creates commits with descriptive messages
7. Generates summary

**Options**:
| Option | Default | Description |
|--------|---------|-------------|
| `--source <path>` | `.` | Path to application source code |
| `--plan-name <name>` | `modernization-plan` | Name of the plan to execute |
| `--language <lang>` | Auto-detected | Programming language (`java` or `dotnet`) |
| `--model <model>` | `claude-sonnet-4.6` | LLM model to use |
| `--delegate <delegate>` | `local` | Execution mode: `local` or `cloud` (Cloud Coding Agent) |
| `--force` | Disabled | Force execution even when a CCA job is in progress |

### `modernize upgrade`

End-to-end upgrade in a single command (plan + execute combined).

```bash
# Upgrade Java
modernize upgrade "Java 17"

# Upgrade .NET
modernize upgrade ".NET 10"

# Specific project
modernize upgrade "Java 17" --source /path/to/project

# Cloud delegation
modernize upgrade "Java 17" --delegate cloud
```

### `modernize update`

Self-update the CLI to the latest released version.

```bash
# Check for and apply updates in one step
modernize update
```

- Takes no flags (run `modernize update --help` to confirm).
- Prints "already up to date" when current.
- Use this in lieu of `brew upgrade modernize` / re-running the install script when you need a quick refresh on a developer workstation.
- For CI, **pin a specific version instead** (see [CLI Cookbook → Recipe 13](./examples/cli-cookbook.md#13-self-update-vs-pinning-in-ci)).

### `modernize help models`

List available LLM models and their multipliers.

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `MODERNIZE_LOG_LEVEL` | `none`, `error`, `warning`, `info`, `debug`, `all` | `info` |
| `MODERNIZE_MODEL` | LLM model | `claude-sonnet-4.6` |
| `MODERNIZE_COLLECT_TELEMETRY` | Enable/disable telemetry | `true` |

> **Note:** The CLI default model (`claude-sonnet-4.6`) differs from the IDE extension default (`Claude Sonnet 4.5`). Both are optimized for their respective workflows.

### User Configuration

File: `~/.modernize/config.json` (user) or `.github/modernize/config.json` (repo)

```json
{
  "model": "claude-sonnet-4.6",
  "log_level": "info",
  "trusted_folders": ["/path/to/trusted/project"]
}
```

**Precedence**: Environment variables > User config > Repository config

> **Tip:** Example configuration files are available at [`docs/examples/repos.json.example`](../docs/examples/repos.json.example) and [`docs/examples/config.json.example`](../docs/examples/config.json.example).

### Multi-Repository Configuration

File: `.github/modernize/repos.json`

```json
[
  {
    "name": "PhotoAlbum-Java",
    "url": "https://github.com/Azure-Samples/PhotoAlbum-Java.git"
  },
  {
    "name": "PhotoAlbum",
    "url": "https://github.com/Azure-Samples/PhotoAlbum.git"
  }
]
```

## Global Options

| Option | Description |
|--------|-------------|
| `--help`, `-h` | Display help |
| `--no-tty` | Disable interactive prompts (headless mode) |

## Sample Applications

- **Java**: `https://github.com/Azure-Samples/PhotoAlbum-Java.git`
- **.NET**: `https://github.com/Azure-Samples/PhotoAlbum.git`
- **Custom Skills Example**: `https://github.com/Azure-Samples/NewsFeedSite`

## Quick Start (5-10 minutes)

```bash
# 1. Install
# (see installation commands above)

# 2. Authenticate
gh auth login

# 3. Clone sample
git clone https://github.com/Azure-Samples/PhotoAlbum-Java.git
cd PhotoAlbum-Java
git checkout -b modernize

# 4. Run interactive mode
modernize

# 5. Follow: Assess → Plan → Execute

# 6. Review results
git status
git diff main

# 7. Create PR
gh pr create \
    --title "Modernization: migrate the app to azure" \
    --body "Automated modernization by GitHub Copilot agent"
```

## CI/CD Integration

The Modernize CLI is designed for pipeline integration. Use `--no-tty` to disable interactive prompts in headless environments.

### Batch Assessment in GitHub Actions

```yaml
name: Modernization Assessment
on:
  schedule:
    - cron: '0 6 * * 1'  # Weekly Monday 6 AM
  workflow_dispatch:

jobs:
  assess:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Modernize CLI
        run: curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh | bash
      - name: Authenticate
        run: gh auth login --with-token <<< "${{ secrets.GITHUB_TOKEN }}"
      - name: Run Assessment
        run: modernize assess --multi-repo --no-tty --output-path ./reports
      - name: Upload Report
        uses: actions/upload-artifact@v4
        with:
          name: modernization-assessment
          path: ./reports/
```

### Cloud-Delegated Batch Upgrade

```bash
# Upgrade all repos via Cloud Coding Agents, wait for completion
modernize upgrade "Java 21" --delegate cloud --wait --no-tty
```

### Key CI/CD Flags

| Flag | Purpose |
|------|---------|
| `--no-tty` | Disable interactive prompts (headless mode) |
| `--delegate cloud` | Execute via Cloud Coding Agents |
| `--wait` | Block until delegated tasks complete |
| `--force` | Force restart if a prior delegation is in progress |

## Feedback

- [GitHub Issues](https://github.com/microsoft/github-copilot-appmod/issues/new?template=feedback-template.yml)
- [Feedback Form](https://aka.ms/ghcp-appmod/feedback)
