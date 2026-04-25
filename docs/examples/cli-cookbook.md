# Modernize CLI Cookbook

> Practical, copy-paste recipes for the **GitHub Copilot Modernization Agent CLI** (`modernize`).
>
> Tested against `modernize v0.0.293+`. Run `modernize --version` to confirm yours; upgrade with `modernize update` (or `brew upgrade modernize`).
>
> For deep reference (every flag, every output path) see [`docs/04-modernization-agent-cli.md`](../04-modernization-agent-cli.md).

---

## Recipes

1. [Single-app quick assess (Markdown output)](#1-single-app-quick-assess-markdown-output)
2. [Portfolio assess from `repos.json`](#2-portfolio-assess-from-reposjson)
3. [Cloud-delegated assess that waits for completion](#3-cloud-delegated-assess-that-waits-for-completion)
4. [Generate a plan with a custom name and language hint](#4-generate-a-plan-with-a-custom-name-and-language-hint)
5. [Execute a plan headlessly (CI mode)](#5-execute-a-plan-headlessly-ci-mode)
6. [Resume / re-execute after manual `tasks.json` edits](#6-resume--re-execute-after-manual-tasksjson-edits)
7. [One-shot upgrade with `modernize upgrade`](#7-one-shot-upgrade-with-modernize-upgrade)
8. [Group repos into apps for separated reports](#8-group-repos-into-apps-for-separated-reports)
9. [Post the assessment summary to a GitHub issue](#9-post-the-assessment-summary-to-a-github-issue)
10. [Override the LLM model and list available models](#10-override-the-llm-model-and-list-available-models)
11. [Daily scheduled assessment in GitHub Actions](#11-daily-scheduled-assessment-in-github-actions)
12. [Compare two assessment runs (diff the Markdown reports)](#12-compare-two-assessment-runs-diff-the-markdown-reports)
13. [Self-update vs pinning in CI](#13-self-update-vs-pinning-in-ci)
14. [Telemetry opt-out and redacted CI logs](#14-telemetry-opt-out-and-redacted-ci-logs)
15. [Custom-skills override flow](#15-custom-skills-override-flow)

---

### 1. Single-app quick assess (Markdown output)

Useful for: workshop demos, validators that grep `*.md`, posting summaries to GitHub.

```bash
modernize assess \
    --source ./workshop-apps/bookstore-app \
    --format markdown \
    --no-tty \
    --model claude-haiku-4.5
```

Output (CWD-relative):
- `.github/modernize/assessment/reports-{yyyyMMddHHmmss}/index.md`
- `.github/modernize/assessment/reports-{yyyyMMddHHmmss}/repos/bookstore-app/report.md`

> 🎚 The default `--format` is **`html`** — pass `markdown` whenever you need `.md`.

---

### 2. Portfolio assess from `repos.json`

```bash
modernize assess --source ./.github/modernize/repos.json --format markdown --no-tty
```

Use either the [simple](./repos.json.example) or [full-format](./repos.json.full-format.example) shape.

> ⚠ `--source repos.json` **cannot** be combined with other `--source` arguments in the same command. Pick one mode per run.

---

### 3. Cloud-delegated assess that waits for completion

For nightly portfolio runs in CI where you want exit code = pipeline gate.

```bash
modernize assess \
    --source ./.github/modernize/repos.json \
    --delegate cloud \
    --wait \
    --no-tty
```

> Cloud delegation is **github.com-only**. GHES, GitLab, ADO, and local-only paths must use `--delegate local`.

---

### 4. Generate a plan with a custom name and language hint

```bash
modernize plan create "upgrade to Java 21 and Spring Boot 3.5" \
    --source ./workshop-apps/bookstore-app \
    --plan-name bookstore-java21 \
    --language java \
    --no-tty
```

Output (note: source-relative, **not** CWD):
- `workshop-apps/bookstore-app/.github/modernize/bookstore-java21/plan.md`
- `workshop-apps/bookstore-app/.github/modernize/bookstore-java21/tasks.json`

`--language` accepts only `java` or `dotnet` in v0.0.293 (see [docs/04 → Commands Reference](../04-modernization-agent-cli.md#modernize-plan-create)).

---

### 5. Execute a plan headlessly (CI mode)

```bash
modernize plan execute \
    --plan-name bookstore-java21 \
    --source ./workshop-apps/bookstore-app \
    --no-tty
```

Add `--delegate cloud --force` to push execution to a Cloud Coding Agent and ignore any in-flight job.

---

### 6. Resume / re-execute after manual `tasks.json` edits

The executor **re-reads `tasks.json` on every run**. To skip a task, set its `status` to `"skipped"` (or remove it). To add a follow-up task, append a new entry with a fresh `id`. Then:

```bash
# After editing workshop-apps/bookstore-app/.github/modernize/bookstore-java21/tasks.json
modernize plan execute \
    --plan-name bookstore-java21 \
    --source ./workshop-apps/bookstore-app
```

Pair with `git diff` on the `tasks.json` to keep an audit trail of human overrides.

---

### 7. One-shot upgrade with `modernize upgrade`

For when you trust the agent and don't need to review the plan first:

```bash
modernize upgrade "Java 21" --source ./workshop-apps/bookstore-app
```

Internally this is `plan create` + `plan execute` chained together. No intermediate review.

---

### 8. Group repos into apps for separated reports

Use the [full-format `repos.json`](./repos.json.full-format.example):

```json
{
  "repos": [ { "name": "bookstore-app", "path": "/abs/path/to/repo/workshop-apps/bookstore-app" }, ... ],
  "apps": [
    { "name": "shop-platform",  "repos": ["bookstore-app", "notes-app"] },
    { "name": "media-platform", "repos": ["PhotoAlbum-Java", "PhotoAlbum-DotNet"] }
  ]
}
```

> ⚠️ `repos[].path` must be **absolute**. Use `bash workshop/generate-repos-json.sh` to emit a Full-format `repos.json` with absolute paths for all workshop apps, or build paths from `"$(pwd)"`.

```bash
modernize assess --source ./.github/modernize/repos.json --format markdown --no-tty
```

The consolidated `index.md` will contain per-app sections matching the `apps[].name` values.

---

### 9. Post the assessment summary to a GitHub issue

```bash
modernize assess \
    --source ./workshop-apps/bookstore-app \
    --format markdown \
    --issue-url https://github.com/your-org/your-repo/issues/123 \
    --no-tty
```

The agent appends the `index.md` summary as a comment on the linked issue. Works on `plan create` and `plan execute` too (use the same flag).

---

### 10. Override the LLM model and list available models

```bash
# List all available models with cost multipliers
modernize help models

# Use a cheap model for dry runs / smoke tests
modernize assess --source ./app --model claude-haiku-4.5     # 0.33×

# Use the strongest model for high-stakes upgrades
modernize plan execute --plan-name java21 --model claude-opus-4.6   # 3×

# Free models (multiplier 0×, useful for piping outputs)
modernize assess --source ./app --model gpt-5-mini --format markdown
```

Default: `claude-sonnet-4.6` (1×).

---

### 11. Daily scheduled assessment in GitHub Actions

```yaml
name: Modernization Assessment

on:
  schedule:
    - cron: '0 6 * * 1'   # Weekly Monday 06:00 UTC
  workflow_dispatch:

jobs:
  assess:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Modernize CLI (pinned)
        run: |
          curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh \
            | MODERNIZE_VERSION=0.0.293 bash

      - name: Authenticate gh
        run: gh auth login --with-token <<< "${{ secrets.GITHUB_TOKEN }}"

      - name: Assess portfolio
        run: |
          modernize assess \
            --source ./.github/modernize/repos.json \
            --format markdown \
            --no-tty \
            --output-path ./reports

      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: modernization-assessment-${{ github.run_id }}
          path: ./reports/
```

---

### 12. Compare two assessment runs (diff the Markdown reports)

```bash
# After two runs (e.g., before and after a dependency bump)
diff -u \
  .github/modernize/assessment/reports-20260101000000/index.md \
  .github/modernize/assessment/reports-20260201000000/index.md \
  | tee assessment-delta.diff
```

For machine-readable deltas, diff `aggregate-report.json` with `jq`:

```bash
jq -S . reports-A/aggregate-report.json > /tmp/a.json
jq -S . reports-B/aggregate-report.json > /tmp/b.json
diff -u /tmp/a.json /tmp/b.json
```

---

### 13. Self-update vs pinning in CI

```bash
# Workstation: take the latest, verified release
modernize update

# CI: pin a known-good version so a CLI release doesn't break your pipeline
MODERNIZE_VERSION=0.0.293 \
  curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh | bash

# Or via Homebrew with a pinned formula
brew install microsoft/modernize/modernize@0.0.293   # if a versioned formula exists
brew pin modernize
```

> Always pair a CLI version pin with a tested `--model` pin for reproducible CI runs.

---

### 14. Telemetry opt-out and redacted CI logs

```bash
# Opt out of anonymous telemetry, persistently
export MODERNIZE_COLLECT_TELEMETRY=false

# Reduce log noise (and avoid leaking diagnostic detail) in CI
export MODERNIZE_LOG_LEVEL=warning
```

For PR descriptions or screenshots, redact source paths with `sed` after the fact:

```bash
modernize assess --source ./internal-app --format markdown --no-tty \
  | sed -E 's|(/[^ ]*/)internal-app|\1<redacted-app>|g'
```

---

### 15. Custom-skills override flow

The CLI honors per-app skill overrides for `--language java` upgrades. Drop your overrides at:

```
{source}/.github/skills/{skill-name}/SKILL.md
```

Then run as usual:

```bash
modernize plan execute --plan-name bookstore-java21 \
    --source ./workshop-apps/bookstore-app
```

The executor matches `tasks.json` → `skills[].name` → first hit in `<source>/.github/skills/`, falling back to `location: builtin` when nothing local is found. See [`docs/06-custom-skills.md`](../06-custom-skills.md) for authoring guidance.

---

## See also

- [`docs/04-modernization-agent-cli.md`](../04-modernization-agent-cli.md) — full CLI reference
- [`docs/05-batch-operations.md`](../05-batch-operations.md) — multi-repo batch patterns
- [`docs/06-custom-skills.md`](../06-custom-skills.md) — authoring custom skills
- [`docs/examples/repos.json.example`](./repos.json.example) — simple `repos.json`
- [`docs/examples/repos.json.full-format.example`](./repos.json.full-format.example) — full `repos.json`
- [`workshop/lab2-cli-assessment.md`](../../workshop/lab2-cli-assessment.md) — Lab 2 walkthrough
