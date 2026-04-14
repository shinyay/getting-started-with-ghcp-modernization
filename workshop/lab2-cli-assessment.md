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

### Step 1 — Create a portfolio workspace

Create a fresh workspace directory for this lab. The CLI expects a specific directory structure:

```bash
mkdir -p ~/workshop-portfolio
cd ~/workshop-portfolio
```

### Step 2 — Initialize the configuration directory

Create the directory structure the CLI uses for configuration:

```bash
mkdir -p .github/modernize
```

### Step 3 — Create the repos.json manifest

> **💡 Shortcut:** Instead of manually editing paths, run the helper script:
> ```bash
> bash workshop/generate-repos-json.sh
> ```
> This auto-generates `repos.json` with the correct absolute paths for your system. Then skip to Step 4.

Create the file `.github/modernize/repos.json` that tells the CLI which applications to assess:

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

> ⚠️ **IMPORTANT:** Replace `/absolute/path/to/` with the actual absolute path to your workshop directory. For example, if you cloned the repo to `~/work/github/getting-started-with-ghcp-modernization`, then the BookStore URL would be:
> ```
> file:///home/yourusername/work/github/getting-started-with-ghcp-modernization/workshop-apps/bookstore-app
> ```
>
> Alternatively, you can use relative paths from the workspace root:
> ```json
> {"name": "BookStore", "url": "../getting-started-with-ghcp-modernization/workshop-apps/bookstore-app"}
> ```

### Step 4 — Verify the manifest

Confirm the file is valid JSON and in the right location:

```bash
cat .github/modernize/repos.json | python3 -m json.tool
```

✅ Expected: Pretty-printed JSON with 4 entries. No syntax errors.

### Step 5 — Run the multi-repo assessment

Execute the assessment across all 4 applications:

```bash
modernize assess --multi-repo
```

You'll see progress output similar to:

```
Assessing BookStore...          [1/4]
Assessing NotesApp...           [2/4]
Assessing InventoryAPI...       [3/4]
Assessing OrderService...       [4/4]

Assessment complete. Report generated.
```

> ⏱ This may take 2–5 minutes depending on project sizes. Be patient.

### Step 6 — Verify the report was generated (Checkpoint 1)

```bash
ls .github/modernize/assessment/*.md
```

✅ **Expected:** One or more Markdown report files in the assessment directory.

### Step 7 — Open the assessment report

Open the generated report:

```bash
# Find and open the report
cat .github/modernize/assessment/*.md
```

Or open it in VS Code for better readability:

```bash
code .github/modernize/assessment/
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
grep -E "BookStore|NotesApp|InventoryAPI|OrderService" .github/modernize/assessment/*.md
```

✅ **Expected:** All 4 application names appear in the output.

### Step 12 — Identify key findings

Answer these questions by reading the report:

1. Which applications need a **Java version upgrade**?
2. Which applications have **security vulnerabilities** in dependencies?
3. What is the recommended **migration order** (which app first)?

> 💡 Write your answers down — you'll discuss them with your table group.

### Step 13 — Create a plan for one application

Now use the CLI to create a detailed modernization plan for the BookStore app:

```bash
modernize plan create "upgrade to Java 21" --source ../getting-started-with-ghcp-modernization/workshop-apps/bookstore-app
```

> ⚠️ Adjust the `--source` path to match your actual directory layout.

### Step 14 — Review the generated plan (Checkpoint 3)

Examine the plan output:

```bash
ls .github/modernize/*/plan.md
cat .github/modernize/*/plan.md
```

✅ **Expected:** A `plan.md` file exists describing the upgrade steps, affected files, and estimated effort.

Also check for the structured task list:

```bash
ls .github/modernize/*/tasks.json
```

### Step 15 — Compare plan vs. assessment

Notice how the **plan** is specific to one app and actionable, while the **assessment** is portfolio-wide and strategic. This is the Assess → Plan workflow:

1. **Assess** (portfolio level) — understand the landscape
2. **Plan** (app level) — create executable migration steps
3. **Execute** (app level) — run the plan (Lab 1 covered this)

---

## Checkpoints Summary

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | Report generated | `ls .github/modernize/assessment/*.md` | One or more `.md` files |
| 2 | All apps in report | `grep -c -E "BookStore\|NotesApp\|InventoryAPI\|OrderService" .github/modernize/assessment/*.md` | Matches for all 4 names |
| 3 | Plan created | `ls .github/modernize/*/plan.md` | At least one `plan.md` |

---

## What Just Happened?

The Modernize CLI's **Assess** command scanned all 4 applications in your portfolio and generated a single, aggregated report. Instead of manually inspecting each project's `pom.xml`, checking dependency versions, and cross-referencing CVE databases, the CLI automated this across the entire portfolio.

The **aggregated report** is valuable because it lets engineering leaders see the full picture: how many apps are on outdated frameworks, which upgrades are most urgent, and how to group applications into **migration waves** — batches of apps that can be upgraded together because they share similar technology stacks and dependency profiles.

The **Plan** command then drills into a single application, producing a step-by-step migration plan with specific file changes and task breakdowns. This plan can be reviewed by the team, refined, and then executed — either manually or via the `@modernize` agent in VS Code (as you did in Lab 1).

---

## Troubleshooting

| Symptom | Solution |
|---------|----------|
| **`modernize: command not found`** | The CLI is not installed or not on your PATH. Check installation docs, or try `npx @github/modernize` if installed via npm. |
| **Authentication error** | Run `gh auth login` and complete the browser-based authentication flow. Then retry. |
| **`repos.json` not detected** | Verify the file is at exactly `.github/modernize/repos.json` (case-sensitive). Run `cat .github/modernize/repos.json` to confirm. |
| **Assessment fails on one repo** | Check that the failing app has a `pom.xml` or `build.gradle` at its root. Verify the path in `repos.json` is correct and the directory exists: `ls <path>`. |
| **"No applications found"** | The `repos.json` file may have a syntax error. Validate with `python3 -m json.tool .github/modernize/repos.json`. |
| **Assessment takes very long** | Large projects take longer. Wait at least 5 minutes before assuming it's stuck. Check CPU usage with `top`. |

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
modernize assess --source ../getting-started-with-ghcp-modernization/workshop-apps/bookstore-app
```

Compare the single-app assessment with the portfolio assessment — what additional context does the portfolio view provide?
