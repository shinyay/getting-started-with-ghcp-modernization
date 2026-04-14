# Lab 1: Version Upgrade — Spring Boot 2.7 + Java 11 → Java 21 + Spring Boot 3.x

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | BookStore (`workshop-apps/bookstore-app/`) |
| **Difficulty** | Beginner |

---

## Learning Objectives

By the end of this lab you will be able to:

- **Understand the Assess → Plan → Execute workflow** that the Copilot modernization agent follows when upgrading a project.
- **Use `@modernize` in VS Code** to invoke the agent, review its generated plan, and approve execution — all from the Copilot Chat panel.
- **Review git-traced changes** to see exactly what the agent modified, commit-by-commit, giving you full auditability.

---

## Pre-Lab Checklist

Before you begin, confirm every item below:

- [ ] The **BookStore** project is open in VS Code (`workshop-apps/bookstore-app/`).
- [ ] You are on the **`main`** branch:
  ```bash
  cd workshop-apps/bookstore-app
  git branch --show-current   # should print: main
  ```
- [ ] The project builds successfully:
  ```bash
  mvn clean package
  ```
  ✅ Expected: `BUILD SUCCESS`

> **Tip:** If the build fails before you start, raise your hand — this must pass before proceeding.

---

## Step-by-Step Instructions

### Step 1 — Open the project in VS Code

Open the BookStore project folder in VS Code:

```bash
code workshop-apps/bookstore-app
```

Make sure the Explorer pane shows the `src/` directory and `pom.xml`.

### Step 2 — Examine the "before" state

Open and inspect the following files to understand the starting point:

| File | What to look for |
|------|-----------------|
| `pom.xml` | `<java.version>11</java.version>` and `<parent>` referencing `spring-boot-starter-parent` **2.7.x** |
| `src/main/java/.../Book.java` | `import javax.persistence.*` annotations |
| `src/test/java/.../BookServiceTest.java` | `import org.junit.Test` (JUnit 4), `@RunWith(SpringRunner.class)` |

> 📝 **Note:** These are the three key areas the agent will transform: build config, runtime imports, and test framework.

### Step 3 — Create a working branch

Never upgrade directly on `main`. Create a lab branch:

```bash
git checkout -b upgrade-lab1
```

### Step 4 — Invoke the modernization agent

1. Open the **Copilot Chat** panel in VS Code (click the Copilot icon in the sidebar, or press `Ctrl+Shift+I`).
2. Type the following prompt and press Enter:

```
@modernize upgrade to Java 21 and Spring Boot 3
```

### Step 5 — Watch the assessment phase

The agent will begin scanning your project. You'll see output like:

```
Analyzing project structure...
Scanning dependencies...
Identifying migration issues...
```

This typically takes 30–60 seconds. **Do not interrupt** — let it finish the assessment.

### Step 6 — Review the generated plan

Once assessment completes, the agent displays a **migration plan** listing:

- Dependency changes (Spring Boot version bump, Java version)
- API migrations required (`javax.*` → `jakarta.*`)
- Test framework updates
- Estimated number of files affected

**Read through the plan carefully.** This is your chance to understand what will change before anything is modified.

### Step 7 — Approve and execute

When you are satisfied with the plan, type:

```
continue
```

This tells the agent to proceed with the execution phase.

### Step 8 — Watch the execution

The agent will now make changes. Watch for:

- `pom.xml` updates (Java version, Spring Boot parent, dependencies)
- Source file modifications (`javax.persistence` → `jakarta.persistence`)
- Test file updates (if included in the plan)
- Each change is committed to git automatically

### Step 9 — Verify with Checkpoint 1

After the assessment phase completes, verify that plan files were generated:

```bash
ls .github/
```

✅ **Expected:** You should see modernization plan files (e.g., `modernize/` directory or plan artifacts).

### Step 10 — Verify with Checkpoint 2

After execution completes, confirm the `javax` → `jakarta` migration:

```bash
# Should find matches — jakarta is the new namespace
grep -r "jakarta.persistence" src/main/

# Should find NO matches — javax should be fully replaced
grep -r "javax.persistence" src/main/
```

✅ **Expected:**
- First command: one or more lines showing `jakarta.persistence` imports
- Second command: **no output** (empty result)

### Step 11 — Verify with Checkpoint 3

Run the full build to confirm everything compiles and tests pass:

```bash
mvn clean package
```

✅ **Expected:** `BUILD SUCCESS` with exit code 0.

### Step 12 — Celebrate 🎉

You just upgraded a Spring Boot application from Java 11 + Spring Boot 2.7 to Java 21 + Spring Boot 3.x — with AI assistance tracking every change in git.

> **📝 Heads-up for Lab 3:** If the agent migrated your JUnit 4 tests to JUnit 5
> during this lab (check with `grep -r "org.junit.jupiter" src/test/`), you'll need
> to reset the test files before starting Lab 3: `git checkout main -- src/test/`

---

## Checkpoints Summary

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | Plan files generated | `ls .github/` | Modernization plan artifacts exist |
| 2a | Jakarta imports present | `grep -r "jakarta.persistence" src/main/` | One or more matches |
| 2b | Javax imports removed | `grep -r "javax.persistence" src/main/` | No output |
| 3 | Build passes | `mvn clean package` | `BUILD SUCCESS`, exit code 0 |

---

## What Just Happened?

The Copilot modernization agent used **OpenRewrite recipes** combined with **AI-driven code analysis** to perform the upgrade. OpenRewrite handles well-known mechanical transformations — such as the `javax.*` → `jakarta.*` namespace migration required by Jakarta EE 9+ — while the AI layer coordinates the overall plan, resolves ambiguities, and handles project-specific edge cases.

Every change the agent made was recorded as a **separate git commit**, giving you a full audit trail. This means you can review each transformation individually with `git log`, revert specific changes if needed, and understand exactly what was modified and why.

The `javax` → `jakarta` rename is one of the most impactful changes in the Spring Boot 2 → 3 migration. It affects persistence annotations, validation constraints, servlet APIs, and more. Doing this manually across a large codebase is tedious and error-prone — exactly the kind of task AI excels at.

---

## Troubleshooting

| Symptom | Solution |
|---------|----------|
| **Agent stops and asks for confirmation** | This is expected at key decision points. Type `continue` to proceed, or enable **auto-approve** mode in Copilot settings if you prefer uninterrupted execution. |
| **Build fails after upgrade** | The agent should attempt to fix build errors automatically. If it doesn't, read the error message carefully — it usually indicates a missing dependency or an import that wasn't migrated. Report the error in Copilot Chat and ask the agent to fix it. |
| **Agent seems stuck (no output for 2+ minutes)** | Wait a full 2 minutes. If still unresponsive, cancel the current operation (`Ctrl+C` in the chat or close the panel) and re-invoke with `@modernize upgrade to Java 21 and Spring Boot 3`. |
| **`javax.persistence` still found after upgrade** | The agent may have missed some files. Run `grep -rn "javax.persistence" src/` to find them, then ask Copilot: `@modernize migrate remaining javax imports to jakarta`. |
| **Branch already exists** | Delete and recreate: `git branch -D upgrade-lab1 && git checkout -b upgrade-lab1` |

---

## Stretch Goal

If you finish early, explore the git history the agent created:

```bash
# See all commits the agent made
git log --oneline

# See the full diff compared to main
git diff main

# See stats (files changed, insertions, deletions)
git diff main --stat
```

Try answering these questions:
- How many commits did the agent create?
- How many files were changed in total?
- Can you identify which commit handled the `javax` → `jakarta` migration?
