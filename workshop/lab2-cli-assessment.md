# Lab 2: CLI Portfolio Assessment — Assess Multiple Applications

| Detail | Value |
|--------|-------|
| **Duration** | 45 minutes |
| **Applications** | BookStore, NotesApp, InventoryAPI, OrderService (via `repos.json`) |
| **Difficulty** | Intermediate |

---

## Learning Objectives

By the end of this lab you will be able to:

- **Understand the Modernize CLI** and how it differs from the VS Code `@modernize` agent — CLI is designed for portfolio-wide operations.
- **Assess multiple applications at once** using a `repos.json` manifest file, generating a single aggregated report.
- **Interpret the aggregated assessment report** — read the dashboard, technology distribution, and prioritized recommendations.
- **Create a modernization plan** for a specific application using the CLI's plan command.

---

## Pre-Lab Checklist

Before you begin, confirm every item below:

- [ ] The Modernize CLI is installed and available:
  ```bash
  modernize --version
  ```
  ✅ Expected: A version number is printed (e.g., `1.x.x`).

- [ ] GitHub CLI is authenticated:
  ```bash
  gh auth status
  ```
  ✅ Expected: `Logged in to github.com`

- [ ] All 4 workshop applications build successfully:
  ```bash
  cd workshop-apps/bookstore-app && mvn clean package -q && echo "✅ BookStore OK"
  cd ../notes-app && mvn clean package -q && echo "✅ NotesApp OK"
  cd ../stub-repos/inventory-api && mvn clean package -q && echo "✅ InventoryAPI OK"
  cd ../order-service && mvn clean package -q && echo "✅ OrderService OK"
  ```

> **Tip:** If any app fails to build, fix it before proceeding — the CLI needs parseable projects.

---

## Step-by-Step Instructions

### Step 1 — Move to the repo root

This lab runs from the **repo root** so that the helper script (`workshop/generate-repos-json.sh`) and the validator (`workshop/validate.sh lab2`) both find their inputs in the expected locations:

```bash
cd /path/to/getting-started-with-ghcp-modernization
pwd     # confirm you are at the repo root
```

> 📁 **Why repo root?** `generate-repos-json.sh` writes `.github/modernize/repos.json` relative to the **repo root**, and `validate.sh lab2` looks for assessment artifacts under the repo root's `.github/modernize/`. Working anywhere else means manually fixing paths.
>
> Earlier revisions of this lab created a separate `~/workshop-portfolio` directory — **don't**. The current helper script and validator assume repo root.

### Step 2 — Create the configuration directory (if missing)

```bash
mkdir -p .github/modernize
```

> The repo's root `.gitignore` already excludes `.github/modernize/`, so anything you generate here stays out of commits.

### Step 3 — Create the repos.json manifest

> **💡 Shortcut:** Skip the manual edit and run the helper script:
> ```bash
> bash workshop/generate-repos-json.sh
> ```
> This auto-generates `.github/modernize/repos.json` with the correct absolute paths for your machine. Then jump to **Step 4**.

If you prefer to write the file by hand, create `.github/modernize/repos.json` from the repo root:

```bash
cat > .github/modernize/repos.json << 'EOF'
[
  {
    "name": "BookStore",
    "url": "file:///absolute/path/to/workshop-apps/bookstore-app"
  },
  {
    "name": "NotesApp",
    "url": "file:///absolute/path/to/workshop-apps/notes-app"
  },
  {
    "name": "InventoryAPI",
    "url": "file:///absolute/path/to/workshop-apps/stub-repos/inventory-api"
  },
  {
    "name": "OrderService",
    "url": "file:///absolute/path/to/workshop-apps/stub-repos/order-service"
  }
]
EOF
```

> ⚠️ **IMPORTANT:** Replace `/absolute/path/to/` with `$(pwd)` (your repo root). The helper script in Step 3's shortcut does this automatically. Example expanded path:
> ```
> file:///home/yourusername/work/github/getting-started-with-ghcp-modernization/workshop-apps/bookstore-app
> ```
>
> *Tip:* In v0.0.293 you can also use the simpler `"path": "./workshop-apps/bookstore-app"` field instead of `"url": "file://..."` — see [`docs/examples/repos.json.full-format.example`](../docs/examples/repos.json.full-format.example).

### Step 4 — Verify the manifest

Confirm the file is valid JSON and in the right location:

```bash
cat .github/modernize/repos.json | python3 -m json.tool
```

✅ Expected: Pretty-printed JSON with 4 entries. No syntax errors.

### Step 5 — Run the multi-repo assessment

Execute the assessment across all 4 applications. Pass the manifest via `--source` and force Markdown output so the validator (and the next steps) can grep the reports:

```bash
modernize assess \
    --source ./.github/modernize/repos.json \
    --format markdown \
    --no-tty
```

You'll see progress output similar to:

```
Assessing BookStore...          [1/4]
Assessing NotesApp...           [2/4]
Assessing InventoryAPI...       [3/4]
Assessing OrderService...       [4/4]

Assessment complete. Report generated.
```

> ⏱ This may take 2–5 minutes depending on project sizes (longer with the default `claude-sonnet-4.6` model). Add `--model claude-haiku-4.5` to speed up dry runs at lower cost (0.33× multiplier).
>
> 💡 **Why not `--multi-repo`?** That flag is **deprecated** as of modernize v0.0.293. The current idiom is repeatable `--source` (or a single `--source repos.json`). See [`docs/04-modernization-agent-cli.md`](../docs/04-modernization-agent-cli.md#modernize-assess).

### Step 6 — Verify the report was generated (Checkpoint 1)

The CLI writes a **timestamped** subfolder under `.github/modernize/assessment/`. Find it:

```bash
ls -d .github/modernize/assessment/reports-*/
```

✅ **Expected:** One directory matching `reports-{yyyyMMddHHmmss}/`.

Inspect the contents:

```bash
ls .github/modernize/assessment/reports-*/
```

✅ **Expected:** `index.md` (consolidated report), `aggregate-report.json` (machine-readable summary), and a `repos/` folder with one `report.md` per app.

> 🔍 **Why is the path not just `assessment/*.md`?** The CLI scopes every run into its own `reports-{timestamp}/` directory so reruns don't clobber prior results. The validator (`workshop/validate.sh lab2`) globs `assessment/reports-*/index.md` for this reason.
>
> 💡 The default output format is **HTML** — without `--format markdown` in Step 5 you'd see `index.html` and `report.html` instead.

### Step 7 — Open the assessment report

Open the consolidated dashboard:

```bash
cat .github/modernize/assessment/reports-*/index.md
```

Or open it in VS Code for better readability:

```bash
code .github/modernize/assessment/reports-*/
```

### Step 8 — Walk through the Dashboard section

The report starts with a **Dashboard** that summarizes:

- **Total applications assessed** — should be 4
- **Total issues found** — number of migration items across all apps
- **Severity breakdown** — critical, high, medium, low

> 📝 Take a moment to note the total issue count and how many are critical.

### Step 9 — Review Technology Distribution

The **Technology Distribution** section shows:

- Java versions in use across the portfolio
- Spring Boot versions
- Build tool distribution (Maven/Gradle)
- Testing framework versions

> 📝 How many apps are still on Java 11? How many on Spring Boot 2.x?

### Step 10 — Read the Recommendations

The **Recommendations** section prioritizes actions:

- Which apps should be upgraded first (highest impact, lowest risk)
- Suggested migration waves (group apps that can be upgraded together)
- Security-related upgrades flagged as urgent

### Step 11 — Verify all 4 apps appear (Checkpoint 2)

Confirm the report covers every application:

```bash
grep -E "BookStore|NotesApp|InventoryAPI|OrderService" .github/modernize/assessment/reports-*/index.md
```

✅ **Expected:** All 4 application names appear in the output.

### Step 12 — Identify key findings

Answer these questions by reading the report:

1. Which applications need a **Java version upgrade**?
2. Which applications have **security vulnerabilities** in dependencies?
3. What is the recommended **migration order** (which app first)?

> 💡 Write your answers down — you'll discuss them with your table group.

### Step 13 — Create a plan for one application

Now use the CLI to create a detailed modernization plan for the BookStore app. Pin the plan name so the next step (and the validator) knows where to look:

```bash
modernize plan create "upgrade to Java 21 and Spring Boot 3.5" \
    --source ./workshop-apps/bookstore-app \
    --plan-name bookstore-java21 \
    --language java \
    --no-tty
```

> ⚠️ **Output path is source-relative, not CWD-relative.** Because we passed `--source ./workshop-apps/bookstore-app`, the plan lands inside that folder, **not** in the repo-root `.github/modernize/`. This is intentional (the plan ships with the app), but it surprises everyone the first time.

### Step 14 — Review the generated plan (Checkpoint 3)

Examine the plan output (note the source-relative path):

```bash
ls workshop-apps/bookstore-app/.github/modernize/bookstore-java21/
cat workshop-apps/bookstore-app/.github/modernize/bookstore-java21/plan.md
```

✅ **Expected:** A `plan.md` file describing the upgrade steps, affected files, and success criteria.

Also check for the structured task list:

```bash
cat workshop-apps/bookstore-app/.github/modernize/bookstore-java21/tasks.json | python3 -m json.tool | head -40
```

✅ **Expected:** Valid JSON with a `tasks[]` array. Each task has `id`, `description`, `requirements`, `skills`, and `successCriteria`. See [`docs/04-modernization-agent-cli.md`](../docs/04-modernization-agent-cli.md#output-artifacts) for the full schema.

### Step 15 — Compare plan vs. assessment

Notice how the **plan** is specific to one app and actionable, while the **assessment** is portfolio-wide and strategic. This is the Assess → Plan workflow:

1. **Assess** (portfolio level) — understand the landscape
2. **Plan** (app level) — create executable migration steps
3. **Execute** (app level) — run the plan (Lab 1 covered this)

---

## Checkpoints Summary

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | Report generated | `ls -d .github/modernize/assessment/reports-*/` | One timestamped `reports-{yyyyMMddHHmmss}/` directory |
| 2 | All apps in report | `grep -c -E "BookStore\|NotesApp\|InventoryAPI\|OrderService" .github/modernize/assessment/reports-*/index.md` | Matches for all 4 names |
| 3 | Plan created | `ls workshop-apps/bookstore-app/.github/modernize/bookstore-java21/plan.md` | File exists |

---

## What Just Happened?

The Modernize CLI's **Assess** command scanned all 4 applications in your portfolio and generated a single, aggregated report. Instead of manually inspecting each project's `pom.xml`, checking dependency versions, and cross-referencing CVE databases, the CLI automated this across the entire portfolio.

The **aggregated report** is valuable because it lets engineering leaders see the full picture: how many apps are on outdated frameworks, which upgrades are most urgent, and how to group applications into **migration waves** — batches of apps that can be upgraded together because they share similar technology stacks and dependency profiles.

The **Plan** command then drills into a single application, producing a step-by-step migration plan with specific file changes and task breakdowns. This plan can be reviewed by the team, refined, and then executed — either manually or via the `@modernize` agent in VS Code (as you did in Lab 1).

---

## Troubleshooting

| Symptom | Solution |
|---------|----------|
| **`modernize: command not found`** | The CLI is not installed or not on your PATH. Install via Homebrew (`brew tap microsoft/modernize https://github.com/microsoft/modernize-cli && brew install modernize`), the install script (`curl -fsSL https://raw.githubusercontent.com/microsoft/modernize-cli/main/scripts/install.sh \| bash`), or `winget install GitHub.Copilot.modernization.agent` on Windows. There is **no npm package** — ignore any old guidance suggesting `npx @github/modernize`. See [`docs/04-modernization-agent-cli.md`](../docs/04-modernization-agent-cli.md#installation). |
| **Authentication error** | Run `gh auth login` and complete the browser flow. If `--delegate cloud` errors with permissions, ensure your token has `repo` and `read:org` scopes. |
| **`repos.json` not detected** | Verify the file is at exactly `.github/modernize/repos.json` (case-sensitive). Run `cat .github/modernize/repos.json \| python3 -m json.tool` to confirm valid JSON. |
| **Assessment fails on one repo** | Check that the failing app has a `pom.xml` or `build.gradle` at its root. Verify the path in `repos.json` is correct: `ls "$(jq -r '.[0].url' .github/modernize/repos.json \| sed 's#file://##')"`. |
| **"No applications found"** | The `repos.json` may have a syntax error. Validate: `python3 -m json.tool .github/modernize/repos.json`. |
| **Assessment takes very long** | Default model `claude-sonnet-4.6` is thorough. Switch to `--model claude-haiku-4.5` (0.33×) for dry runs, or pre-flight on one app with `--source ./workshop-apps/bookstore-app`. |
| **Validator (`workshop/validate.sh lab2`) finds no reports** | You probably ran without `--format markdown` (so the CLI emitted HTML). Re-run Step 5 with `--format markdown`. |
| **Plan command's output is "missing"** | It's not — `modernize plan create --source <path>` writes inside that path's `.github/modernize/{plan-name}/`, not the repo root. Look in `workshop-apps/bookstore-app/.github/modernize/`. |
| **`--delegate cloud` fails with "host not supported"** | Cloud delegation works only for `github.com` repos. Use `--delegate local` for GHES, GitLab, ADO, or local-only paths. |

---

## Stretch Goal

If you finish early, try the **interactive TUI** (terminal UI) mode:

```bash
modernize
```

This launches an interactive interface where you can:

- Browse assessed applications
- Select an app to plan or execute
- View reports in a formatted terminal view

Explore the TUI and see how it presents the same information you reviewed in the Markdown report.

You can also try assessing a single app directly:

```bash
modernize assess --source ./workshop-apps/bookstore-app --format markdown --no-tty
```

Compare the single-app assessment with the portfolio assessment — what additional context does the portfolio view provide?
