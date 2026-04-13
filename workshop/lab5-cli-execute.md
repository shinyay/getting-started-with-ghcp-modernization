# Lab 5: CLI Plan Execute — Run an Upgrade via the Modernize CLI

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | BookStore (`workshop-apps/bookstore-app/`) |
| **Stack** | Spring Boot 2.7, Java 11 → target: Java 21 + Spring Boot 3 |

---

## Learning Objectives

By the end of this lab you will be able to:

1. Execute a full modernization plan using the **`modernize` CLI**.
2. Compare the **CLI workflow** with the **IDE workflow** from Lab 1.
3. Understand **batch upgrade** capabilities for upgrading multiple repositories at once.

---

## Pre-Lab Checklist

- [ ] The `modernize` CLI is installed and accessible:

```bash
modernize --version
```

- [ ] BookStore is in its original state (Java 11 + Spring Boot 2.7):

```bash
cd workshop-apps/bookstore-app
git checkout main
```

> If you made changes to BookStore in previous labs, reset it:
> ```bash
> git checkout main && git clean -fd && git checkout .
> ```

---

## Step-by-Step Instructions

### Step 1 — Navigate to the Workshop Root

```bash
cd workshop-apps/bookstore-app
```

Confirm the starting state:

```bash
grep "java.version" pom.xml
grep "spring-boot" pom.xml | head -3
```

You should see Java 11 and Spring Boot 2.7.x references.

### Step 2 — Run the CLI Upgrade Command

From the **repository root**, execute:

```bash
modernize upgrade "Java 21" --source ./workshop-apps/bookstore-app
```

This single command triggers the full modernization pipeline.

### Step 3 — Observe the Execution Flow

Watch the terminal output. The CLI will progress through these stages:

1. **Assessment** — analyzes the current codebase
2. **Plan creation** — generates a step-by-step upgrade plan
3. **Execution** — applies changes (dependency updates, code migration, API changes)
4. **Build validation** — runs `mvn clean package` to verify correctness
5. **CVE scan** — checks for known vulnerabilities in updated dependencies
6. **Commits** — creates atomic git commits for each logical change

> ⏳ This process may take several minutes. Let it run to completion.

### Step 4 — Review the Git History

After the upgrade completes, examine what the CLI did:

```bash
cd workshop-apps/bookstore-app
git log --oneline
```

You should see multiple commits — one for each logical upgrade step (e.g., Java version bump, Spring Boot upgrade, `javax` → `jakarta` migration).

### Step 5 — Review the Full Diff

```bash
git diff main
```

Inspect the changes. Look for:

- `pom.xml` — updated Java version, Spring Boot version, dependencies
- `src/main/java/` — `javax.*` → `jakarta.*` imports
- Configuration changes in `application.properties` or `application.yml`

### Step 6 — Verify the Build

```bash
mvn clean package
```

The build should pass with all tests green.

### Step 7 — Compare with Lab 1

In Lab 1, you performed the same upgrade using the IDE (`@modernize` in Copilot Chat). The result is the same — the workflow is different:

- **Lab 1 (IDE):** Interactive, visual, in-editor experience.
- **Lab 5 (CLI):** Terminal-based, scriptable, automatable.

Both produce the same quality of output. Choose the interface that fits your workflow.

### Step 8 — Set Up Batch Mode

The CLI's real power is **batch upgrades** across multiple repositories.

Create a `repos.json` file in the workshop root:

```bash
cat > repos.json << 'EOF'
[
  {
    "name": "BookStore",
    "url": "file://workshop-apps/bookstore-app"
  },
  {
    "name": "InventoryAPI",
    "url": "file://workshop-apps/stub-repos/inventory-api"
  }
]
EOF
```

### Step 9 — Reset BookStore for the Batch Run

```bash
cd workshop-apps/bookstore-app
git checkout main && git clean -fd && git checkout .
cd ../..
```

### Step 10 — Run the Batch Upgrade

```bash
modernize upgrade "Java 21"
```

When `repos.json` is present in the current directory, the CLI auto-detects it and processes all repositories sequentially.

Watch as both applications are upgraded one after the other.

### Step 11 — Verify Batch Results

Check that both repositories were upgraded:

```bash
# BookStore
cd workshop-apps/bookstore-app
git log --oneline | head -5
mvn clean package
cd ../..

# InventoryAPI
cd workshop-apps/stub-repos/inventory-api
git log --oneline | head -5
mvn clean package
cd ../../..
```

### Step 12 — Clean Up

```bash
rm repos.json
```

---

## Checkpoint 1 — Jakarta Migration Confirmed

```bash
grep -r "jakarta.persistence" workshop-apps/bookstore-app/src/main/java/
```

**Expected:** One or more matches showing `jakarta.persistence` imports (migrated from `javax.persistence`).

---

## Checkpoint 2 — Commits Exist

```bash
cd workshop-apps/bookstore-app && git log --oneline | head -5
```

**Expected:** Multiple commits from the modernization process on top of the original `main` history.

---

## Checkpoint 3 — Build Passes

```bash
cd workshop-apps/bookstore-app && mvn clean package
```

**Expected:** `BUILD SUCCESS` with exit code 0.

---

## IDE vs CLI Comparison

| Feature | IDE (`@modernize`) | CLI (`modernize upgrade`) |
|---------|-------------------|--------------------------|
| **Best for** | Single app, interactive exploration | Batch processing, CI/CD, automation |
| **Execution** | Visual, in-editor with diff preview | Terminal-based, scriptable |
| **Batch support** | No | Yes (`repos.json`) |
| **Cloud delegation** | Via GitHub.com | `--delegate cloud` |
| **Human review** | Inline accept/reject per change | Post-hoc via `git diff` |
| **CI/CD integration** | Not directly | Yes — can run in pipelines |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **`modernize` command not found** | Verify installation. Check your `PATH` includes the directory where `modernize` is installed. Try `which modernize` or `where modernize`. |
| **Upgrade stalls or hangs** | Check your network connection. Try specifying a model explicitly: `modernize upgrade "Java 21" --model claude-sonnet-4.6`. |
| **Batch fails on one repo** | The CLI continues processing remaining repos. Check the failed repo's error output. Common cause: non-standard project structure or missing `pom.xml`. |
| **`repos.json` not detected** | Ensure the file is in the current working directory. Verify it is valid JSON (`cat repos.json | python3 -m json.tool`). |

---

## Stretch Goal

Try the **interactive TUI (Text User Interface)** mode:

```bash
modernize
```

Running `modernize` without arguments launches an interactive terminal UI where you can browse assessments, plans, and tasks visually — all from the terminal.
