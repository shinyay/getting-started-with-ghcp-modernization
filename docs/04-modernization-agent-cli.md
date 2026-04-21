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

> **🔧 Internal target capability vs surfaced recommendation.** The assessment engine reports its internal capabilities under `aggregate-report.json → metadata.capabilities` (e.g. `["openjdk21"]` in v0.0.293) — that is the **JDK level the analyzer was actually calibrated against**. The narrative text in `index.md` may still recommend a *newer* LTS like "Upgrade to Java 25" because the planner extrapolates to the latest known LTS. When choosing a target for `plan create`, prefer the version that matches your fleet's current support contract (typically Java 21 today); the analyzer's findings remain valid.

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
- `clarifications.json` *(optional)* — open questions the planner could not answer from the source alone; you fill in the `"answer"` fields and re-run with `--overwrite` to refine the plan

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

> **🐛 Known issue (v0.0.293) — `plan create --no-tty` hangs after writing files.**
> During the 2026-04-22 dry-run we observed `modernize plan create … --no-tty` write all output files (`plan.md`, `tasks.json`, `clarifications.json`) within ~6 minutes, then hang indefinitely waiting for a Copilot SDK stop event. The CLI keeps printing `[!] Still waiting for Copilot response (Ns elapsed)…` forever (we saw 16 minutes+).
>
> **Workarounds:**
> 1. Once the message `Modernization plan created at .github/modernize/{plan-name}/` appears, you can safely **press Ctrl+C** — the plan files are already on disk and survive the SIGINT.
> 2. Or wrap the call with a hard timeout: `timeout 600 modernize plan create … --no-tty` (treat exit code 124 as "plan likely written, verify the output path").
> 3. Always verify `ls <source>/.github/modernize/{plan-name}/` after Ctrl+C / timeout — the three files (`plan.md`, `tasks.json`, optionally `clarifications.json`) are the source of truth.

> **Tip:** When the plan generator has open questions about your project (e.g. "should JUnit 4 → JUnit 5 also be migrated?") it writes them to `clarifications.json` alongside `plan.md`. Answer them in-place by filling the empty `"answer"` fields, then re-run the command with `--overwrite` to fold the answers into a refined plan.

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

### Multi-Repository Configuration (`repos.json`)

A `repos.json` file lets you describe a portfolio once and reuse it across `assess` and `upgrade` runs. Two shapes are supported.

> 📚 **Authoritative reference:** [`aka.ms/ghcp-modernization-agent/repos-config`](https://aka.ms/ghcp-modernization-agent/repos-config) (Microsoft's Batch Assessment guide). The shapes below mirror that schema.

**Simple format** — a flat array of repos (URLs only; CLI will `git clone`):

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

See [`docs/examples/repos.json.example`](./examples/repos.json.example) for a runnable workshop sample.

**Full format** — supports per-repo `branch`/`path`, app grouping, and output destinations:

```json
{
  "repos": [
    {
      "name": "bookstore-app",
      "path": "./workshop-apps/bookstore-app",
      "branch": "main",
      "description": "Spring Boot 2.7 → 3 demo"
    },
    {
      "name": "PhotoAlbum-Java",
      "url": "https://github.com/Azure-Samples/PhotoAlbum-Java.git",
      "branch": "main"
    }
  ],
  "apps": [
    {
      "name": "shop-platform",
      "description": "Customer-facing storefront",
      "repos": ["bookstore-app"]
    },
    {
      "name": "media-platform",
      "description": "Photo & gallery services",
      "repos": ["PhotoAlbum-Java"]
    }
  ],
  "output": {
    "type": "git",
    "repository": "https://github.com/your-org/modernization-reports",
    "branch": "main",
    "path": "reports/"
  }
}
```

| Key | Where | Purpose |
|-----|-------|---------|
| `repos[].name` | required | Display name in reports |
| `repos[].url` | one of url/path | Git URL (HTTPS or SSH) |
| `repos[].path` | one of url/path | Local path (alternative to `url`) |
| `repos[].branch` | optional | Branch to assess (default: repo's default branch) |
| `repos[].description` | optional | Free-text label |
| `apps[]` | optional | Logical grouping; produces grouped sections in the consolidated report |
| `apps[].repos` | required (when `apps[]` set) | List of `repos[].name` values |
| `output.type` | optional | `local` (default) or `git` to push reports to another repo |
| `output.repository` / `output.branch` / `output.path` | required when `output.type=git` | Destination for the consolidated report |

See [`docs/examples/repos.json.full-format.example`](./examples/repos.json.full-format.example) for a copy-paste starting point.

> **Tip:** When using `--source path/to/repos.json`, you **cannot** mix it with other `--source` arguments in the same command. Pick one mode per run.

> **⚠️ Local directories: use `path:` (Full format), not `url: file://…`.** The CLI treats every `url` value as a Git remote and runs `git clone` on it — `file://` URLs that point at non-bare working trees fail with `git clone failed (exit 128)`. Always use the **Full-format `path:` field** for local sources. The shipped helper `workshop/generate-repos-json.sh` does this for you.

> **🐛 Application Matrix `Repo` column.** In v0.0.293, the rendered Application Matrix only fills the `Repo` column when the source path's basename differs from the application identity. Rows where they match (e.g. `notes-app` at `workshop-apps/notes-app/`) appear with a blank `Repo` cell. The underlying `aggregate-report.json` is correct; this is a display-only quirk.

## Cloud Delegation Constraints

`--delegate cloud` hands the actual work to **GitHub's Cloud Coding Agent (CCA)** — your laptop is freed up immediately, and the CLI either exits (without `--wait`) or polls until completion. Before reaching for it, know the limits:

| Constraint | Detail |
|---|---|
| **Repository host** | **`github.com` only.** GitHub Enterprise Server, GitLab, Bitbucket, Azure DevOps, and **local-only paths** are **not supported** for cloud delegation. Use `--delegate local` for those. |
| **Repository visibility** | The cloud agent needs read/write access through your GitHub identity. Private repos require `gh auth` to be authenticated as a user with the right permissions on each target repo. |
| **Concurrency** | Only one CCA job per repo at a time. A second `--delegate cloud` run aborts unless you pass `--force` (assess) / `--force` (plan execute). |
| **Cost / quota** | Cloud runs consume your GitHub Copilot model quota (multipliers from `modernize help models` apply). Long-running upgrades may incur substantial usage — start with `--model claude-haiku-4.5` (0.33×) or a 0× model when validating pipelines. |
| **Artifacts** | Reports/plans are written to the source repo via a PR/branch (depending on the run). Local working tree is not modified. |
| **`--wait`** | Optional. Without it, the CLI returns the job ID and exits; you can re-attach later. With it, the CLI blocks until completion. |
| **Logs** | View progress at <https://github.com/{owner}/{repo}/actions> (look for the *Copilot Modernization* runs). |

> **Decision rule of thumb:** Use `--delegate local` for first-touch demos, GitHub-Enterprise / GitLab / ADO repos, and anything with a hard offline requirement. Use `--delegate cloud --wait` for nightly portfolio assessments in CI. Use `--delegate cloud` (no wait) when you trigger a long-running job from a webhook and want to free the runner.

## Output Artifacts

Both `assess` and `plan create` emit files in deterministic locations. Knowing the layout makes scripting (CI, validators, dashboards) easy.

### `modernize assess` output tree

`assess` writes to **two** places — an aggregate report at the CWD and per-app raw analysis inside each source folder:

```text
# Aggregate report — relative to the directory where you ran the command
.github/modernize/assessment/
└── reports-{yyyyMMddHHmmss}/
    ├── index.{md,html}            # Consolidated dashboard
    ├── aggregate-report.json      # Machine-readable summary across all apps
    └── repos/
        └── {app-name}/
            ├── report.{md,html}   # Per-app report
            └── report.json

# Per-app raw analysis — relative to each --source path
{source}/.github/modernize/
├── .gitignore                     # Auto-created, contains: *
└── assessment/
    ├── reports/
    │   └── report-{yyyyMMddHHmmss}/
    │       ├── summary.md
    │       └── report.json
    └── engines/appcat/result/
        ├── analysis.log
        ├── report.json
        ├── result.json
        └── shim.log
```

### `modernize plan create` output tree

```text
{source}/.github/modernize/
├── .gitignore                     # Auto-created, contains: *
└── {plan-name}/                   # Default plan-name: "modernization-plan"
    ├── plan.md                    # Strategy, success criteria, rationale
    ├── tasks.json                 # Structured, executable task list
    └── clarifications.json        # Open questions raised by the planner (optional)
```

> **🐛 UTF-8 BOM in JSON files (v0.0.293).** All JSON files emitted by `assess` and `plan create` (`aggregate-report.json`, `report.json`, `tasks.json`, `clarifications.json`) start with a UTF-8 BOM (`\ufeff`). Strict JSON parsers reject this:
>
> ```bash
> $ cat aggregate-report.json | python3 -m json.tool
> Unexpected UTF-8 BOM (decode using utf-8-sig): line 1 column 1 (char 0)
> ```
>
> **Workarounds:**
>
> ```bash
> # Option 1: jq (BOM-tolerant)
> jq . aggregate-report.json
>
> # Option 2: Python with utf-8-sig codec
> python3 -c 'import sys,json; print(json.dumps(json.loads(open(sys.argv[1],"rb").read().decode("utf-8-sig")), indent=2))' aggregate-report.json
>
> # Option 3: strip BOM then pipe
> sed '1s/^\xEF\xBB\xBF//' aggregate-report.json | python3 -m json.tool
> ```

### `tasks.json` schema (observed in v0.0.293)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "tasks": [
    {
      "type": "upgrade",
      "id": "001-upgrade-java-21-springboot-35",
      "description": "Upgrade BookStore application to Java 21 and Spring Boot 3.5",
      "reason": "...",
      "requirements": "...",
      "environmentConfiguration": null,
      "status": null,
      "taskSummary": null,
      "skills": [
        { "name": "create-java-upgrade-plan", "location": "builtin" }
      ],
      "successCriteria": {
        "passBuild": "true",
        "generateNewUnitTests": "false",
        "passUnitTests": "true"
      },
      "successCriteriaStatus": {
        "passBuild": null,
        "generateNewUnitTests": null,
        "passUnitTests": null
      }
    }
  ]
}
```

You can hand-edit `tasks.json` between `plan create` and `plan execute` to reorder, drop, or extend tasks — the executor reads the file fresh on each run.

### Git hygiene

The CLI auto-creates `.gitignore` files inside every `.github/modernize/` it touches (content: `*`), and this repo's root `.gitignore` excludes `.github/modernize/` outright. **CLI artifacts never enter your commits unless you opt in** by adding a path explicitly.

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
        run: |
          modernize assess \
            --source ./repo-a --source ./repo-b \
            --format markdown \
            --no-tty \
            --output-path ./reports
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

## Interactive (TUI) Walkthrough

When you run `modernize` with no subcommand, the CLI launches a terminal UI. The flow mirrors `assess → plan create → plan execute` but with menus and arrow-key navigation:

```text
┌─────────── GitHub Copilot Modernization Agent ───────────┐
│                                                          │
│   What do you want to do?                                │
│                                                          │
│   ❯ 1. Assess applications                               │
│     2. Create a modernization plan                       │
│     3. Execute a modernization plan                      │
│     4. End-to-end upgrade                                │
│     5. Settings                                          │
│     q. Quit                                              │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

Selecting **1. Assess applications** drops you into:

```text
┌────────────────── Assess: select sources ────────────────┐
│                                                          │
│  Source(s):                                              │
│  [x] ./workshop-apps/bookstore-app  (Java, Maven)        │
│  [ ] ./workshop-apps/notes-app      (Java, Gradle)       │
│  [ ] Add a Git URL...                                    │
│  [ ] Load from repos.json...                             │
│                                                          │
│  Output format:  ( ) html  (•) markdown                  │
│  Model: claude-sonnet-4.6   [press M to change]          │
│  Delegate: local            [press D to change]          │
│                                                          │
│  [Enter] Run    [Esc] Back                               │
└──────────────────────────────────────────────────────────┘
```

Key bindings inside any TUI screen:

| Key | Action |
|-----|--------|
| `↑ / ↓` | Move highlight |
| `Space` | Toggle a checkbox |
| `Enter` | Confirm / drill into selection |
| `M` | Switch model (re-uses `modernize help models` list) |
| `D` | Toggle local ↔ cloud delegation |
| `?` | Inline help |
| `Esc` | Back |
| `q` | Quit |

Run with `--no-tty` (or `MODERNIZE_NO_TTY=true`) to suppress the TUI and force pure stdout — required in SSH-without-PTY, GitHub Actions, and most container shells.

## CLI vs IDE Agent — when to use which

The Modernization Agent ships in two surfaces. Both call the same backend skills, but the ergonomics differ.

| Concern | **CLI (`modernize`)** | **IDE Agent (`@modernize-*` in VS Code Chat)** |
|---|---|---|
| Best for | Headless, scripted, batch, CI | One-off interactive upgrades, code review |
| Multi-repo | Native (`--source` repeatable, `repos.json`) | One workspace at a time |
| Audit trail | Stdout + `tasks.json` + report files | Chat history + workspace edits |
| Pre-commit review | `git diff` after run | Live diffs in editor before accept |
| Cloud delegation | `--delegate cloud` | "Run on Cloud" button |
| Human-in-the-loop | Pause between `plan create` and `plan execute` | Accept/reject each chunk in chat |
| Telemetry redaction | `MODERNIZE_LOG_LEVEL=warning` + `sed` | Limited; respect VS Code settings |
| **Workshop mapping** | **Lab 2** ([`lab2-cli-assessment.md`](../workshop/lab2-cli-assessment.md)) | **Lab 1** ([`lab1-version-upgrade.md`](../workshop/lab1-version-upgrade.md)) |

**Rule of thumb**

- *Single repo, single dev, want to feel the changes?* → IDE Agent (Lab 1).
- *5+ repos, weekly cadence, want a Slack-postable report?* → CLI + GitHub Actions (Lab 2 + Cookbook recipe 11).
- *Both?* — that's exactly the workshop arc: Lab 1 to learn the shape, Lab 2 to scale it.

## CLI Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `modernize: command not found` after install | Shell PATH not refreshed | Open a new terminal, or `hash -r`; for Linuxbrew run `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"`. |
| `gh: not authenticated` during a CLI run | `gh auth login` not completed (or token expired) | `gh auth status`; re-run `gh auth login -s repo,read:org` if scopes are missing. |
| Default run produces only HTML, validators expect `*.md` | `--format` defaults to `html` | Pass `--format markdown` explicitly. The CLI does *not* auto-emit both. |
| `validate.sh lab2` fails to find reports under `.github/modernize/assessment/` | Reports actually land in `.github/modernize/assessment/reports-{ts}/index.md` | Use a glob like `assessment/reports-*/index.md` (this repo's `validate.sh` was updated for this layout). |
| `modernize plan create --source workshop-apps/bookstore-app` doesn't show plan in repo root | Plan output is **source-relative** | Look in `workshop-apps/bookstore-app/.github/modernize/{plan-name}/`. |
| `--delegate cloud` errors with "host not supported" | URL is not `github.com` (GHES, GitLab, ADO, local path) | Use `--delegate local`, or push the repo to `github.com` first. |
| `--language python` error | Python isn't accepted in v0.0.293 | Drop the flag (auto-detect) or stick to `java`/`dotnet`. |
| Repeated rate-limit / quota errors during `--delegate cloud` | Model multiplier × portfolio size exceeds Copilot quota | Switch to `--model claude-haiku-4.5` (0.33×) or a 0× model for dry runs; pre-flight with `modernize help models`. |
| `.github/modernize/` artifacts polluting `git status` | This repo's `.gitignore` already excludes them | Confirm with `git check-ignore -v .github/modernize/...`; the CLI also auto-creates per-folder `.gitignore` with `*`. |
| Want to silence anonymous telemetry | `MODERNIZE_COLLECT_TELEMETRY=true` is the default | `export MODERNIZE_COLLECT_TELEMETRY=false`. |
| Stale plan blocks a re-run | `--plan-name` collides with prior run | Pass `--overwrite`, or delete `<source>/.github/modernize/{plan-name}/`. |

> Still stuck? File via `modernize` → [GitHub Issues](https://github.com/microsoft/github-copilot-appmod/issues/new?template=feedback-template.yml).

## Related Reading

- **Cookbook** — practical recipes: [`docs/examples/cli-cookbook.md`](./examples/cli-cookbook.md)
- **Batch operations** — multi-repo patterns: [`docs/05-batch-operations.md`](./05-batch-operations.md)
- **Custom skills** — author your own upgrade rules: [`docs/06-custom-skills.md`](./06-custom-skills.md)
- **Lab 1 (IDE)** — first contact with the agent: [`workshop/lab1-version-upgrade.md`](../workshop/lab1-version-upgrade.md)
- **Lab 2 (CLI)** — portfolio-scale assessment + plan: [`workshop/lab2-cli-assessment.md`](../workshop/lab2-cli-assessment.md)

## Feedback

- [GitHub Issues](https://github.com/microsoft/github-copilot-appmod/issues/new?template=feedback-template.yml)
- [Feedback Form](https://aka.ms/ghcp-appmod/feedback)
