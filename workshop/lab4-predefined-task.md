# Lab 4: Predefined Tasks — Migrate File Logging to Console for Azure Monitor

> 📚 **Reference docs for this lab:**
> - **[IDE experience — Java](../docs/02-ide-experience-java.md#predefined-tasks)** — Tasks panel and predefined task catalog.
> - **[CLI task execution](../docs/05-batch-operations.md)** — the CLI equivalent for batch operations.

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | NotesApp (`workshop-apps/notes-app/`) |
| **Stack** | Spring Boot 3.2.5, Java 17, file-based logging |
| **Verified With** | GitHub Copilot app modernization extension v0.0.293+ (VS Code Insiders) |

---

## Learning Objectives

By the end of this lab you will be able to:

1. Understand **predefined tasks** as codified best practices for cloud migration.
2. Locate the task **"Migrate file logging to console logging"** in the v0.0.293+ Tasks panel (nested under Java > Migration Tasks > Storage Tasks).
3. Run the task and observe the agent's full pipeline — plan → migrate → multi-stage validation → auto-commit.
4. Verify that logging output is redirected to the console (stdout), making the application cloud-ready for Azure Monitor.

---

## Pre-Lab Checklist

- [ ] **Open `workshop-apps/notes-app/` as the workspace folder in VS Code Insiders** (not the repo root). The extension only enumerates predefined tasks for the folder it has open.
- [ ] The build passes:

  ```bash
  cd workshop-apps/notes-app
  mvn clean package
  cd ../..   # return to repo root
  ```

- [ ] When the predefined task starts, VS Code will prompt you to start two MCP servers — **CopilotMod** and **Foundry MCP**. Click **Allow / Start** for both. Without these the task cannot run.

> If the build fails at this stage, resolve the issue before continuing.

---

## Background

In cloud and container environments, file-based logging is an anti-pattern. Container filesystems are **ephemeral** — when a container restarts, any log files written to disk are lost. Azure Monitor, Application Insights, and other observability platforms integrate with **console/stdout** output, not local files. The predefined task automates the migration from file-based logging to console-only logging, saving time and reducing the risk of misconfiguration.

The NotesApp contains **two** places where logs are written to the filesystem:

| # | File | What It Does |
|---|------|-------------|
| 1 | `src/main/resources/logback-spring.xml` | Defines a `RollingFileAppender` that writes to `logs/notes-app.log` |
| 2 | `src/main/java/.../service/NoteService.java` | Contains a `writeAuditLog()` method that uses `java.nio.file.Files.write()` to write directly to `logs/audit.log` |

Both must be eliminated before the application is cloud-ready.

---

## Step-by-Step Instructions

### Step 1 — Examine the Logback Configuration

Open `src/main/resources/logback-spring.xml` in VS Code.

Look for the **FILE** appender — it uses `RollingFileAppender` and writes to `logs/notes-app.log`:

```xml
<!-- You should see something like this -->
<appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>logs/notes-app.log</file>
    ...
</appender>
```

> 📝 **Note:** This is the first anti-pattern — the framework-level logging configuration writes to a file.

### Step 2 — Examine the Audit Log Code

Open `src/main/java/.../service/NoteService.java`.

Find the `writeAuditLog()` method. It uses `java.nio.file.Files.write()` to write directly to the filesystem:

```java
// You should see something like this
private void writeAuditLog(String message) {
    // ... uses Files.write() to append to logs/audit.log
}
```

> 📝 **Note:** This is the second anti-pattern — application code writes log data directly to a file, bypassing the logging framework entirely.

### Step 3 — Start the Application

```bash
cd workshop-apps/notes-app
mvn spring-boot:run
```

Wait until you see `Started NotesApplication` in the console (port `8083`).

### Step 4 — Create a Test Note

Open a **new terminal** and run:

```bash
curl -X POST http://localhost:8083/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","content":"Hello"}'
```

You should receive a JSON response confirming the note was created.

### Step 5 — Verify File Logging Exists

```bash
ls -la logs/
cat logs/notes-app.log
cat logs/audit.log
```

Both files should contain entries. This confirms the file-based logging is active.

### Step 6 — Stop the Application

Return to the terminal running the app and press **Ctrl+C** to stop it.

> ℹ️ **No manual `git checkout -b` is needed.** The predefined-task agent will automatically create its own working branch in the next step (see Step 8).

### Step 7 — Open the Predefined Tasks Panel

In VS Code Insiders:

1. Open the **GitHub Copilot app modernization** extension sidebar (the rocket-ship icon).
2. Expand the **TASKS** view.
3. The tasks are grouped by **language**: `Common Tasks`, **`Java`**, `Python`, `.NET`, `TypeScript`, `My Skills`.
4. Expand **`Java`** → **`Migration Tasks`** → **`Storage Tasks`**.
5. The task you want is **"Migrate file logging to console logging"**.

> 📝 **Heads up — task naming.** The official Microsoft Learn catalog still lists this task under its old name **"Logging to local file"**. The extension UI renamed it to "Migrate file logging to console logging" in v0.0.293+. They are the same task (internal `kbId: log-to-console`).

### Step 8 — Run the Predefined Task

Click **Run** on **"Migrate file logging to console logging"**.

Alternatively, from Copilot Chat, you can invoke the same task directly:

```
#appmod-run-task kbId=log-to-console
```

When the task starts:

1. VS Code will prompt to start the **CopilotMod** and **Foundry MCP** servers — click **Allow / Start** for both.
2. The agent reports progress as **`Phase X / 8`**:
   1. Initialization
   2. Create `progress.md`
   3. Pre-condition checks (build green, clean tree)
   4. Plan generation
   5. Version control (creates branch `appmod/java-log-to-console-<TIMESTAMP>`)
   6. Code migration
   7. Validation pipeline (see Step 9)
   8. Final summary

> ℹ️ **Branch is automatic.** The agent commits its work onto a branch named `appmod/java-log-to-console-<TIMESTAMP>` — your current branch is left untouched.

### Step 9 — Observe the Validation Pipeline & Auto-Commits

After the code migration phase the agent runs a **5-stage validation pipeline**:

| Stage | What it Checks |
|-------|----------------|
| **Build** | `mvn clean package` succeeds |
| **CVE** | No new vulnerable dependencies introduced |
| **Consistency** | Diff against the baseline revision is internally coherent |
| **Tests** | Existing tests still pass |
| **Completeness** | A second pass that re-scans for *any remaining* anti-patterns |

If the **Completeness** stage finds leftovers (e.g. unused `LOG_DIR` properties), the agent **performs a second edit and a second commit** — so expect **two or more commits** on the `appmod/...` branch:

| Commit | Typical Message |
|--------|-----------------|
| 1 | `Code migration: migrate file-based logging to console for Azure Monitor` |
| 2 | `Completeness fixes: remove FILE appender definition and unused LOG_DIR/LOG_FILE properties from logback-spring.xml` |

You **do not** need to approve every change; the agent commits automatically. Your job is to read the diff afterwards.

> 📝 **Artifacts.** The agent writes its plan, progress, and final summary to `.github/modernize/code-migration/log-to-console-<TIMESTAMP>/{plan,progress,summary}.md`. This directory is `.gitignore`d — open it in VS Code to inspect what the agent decided.

### Step 10 — Restart and Verify

Stop any leftover app process (it should already be stopped from Step 6), move the old logs aside so you can prove no new ones are created, then restart:

```bash
mv logs logs.before-fix     # keep old logs for comparison
mvn spring-boot:run
```

Create another note:

```bash
curl -X POST http://localhost:8083/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"After Fix","content":"No more file logs"}'
```

Verify:

- ✅ Audit lines appear on the **console** in the form
  `AUDIT | CREATE | Note ID: 1 | Title: After Fix`.
- ✅ `ls logs` returns *No such file or directory* — the `logs/` directory is **not recreated**.

Press **Ctrl+C** to stop the app, then clean up the comparison folder:

```bash
rm -rf logs.before-fix
```

### Step 11 — Review What the Agent Committed

```bash
git log --oneline --branches='appmod/java-log-to-console-*' --not main
```

You should see the commits the agent created (typically two — one for the migration, one for completeness fixes). Inspect them:

```bash
git --no-pager show <sha>
```

> ℹ️ **No manual `git commit` is needed for this lab.** The predefined-task agent already committed the work for you. If you want the changes on `main`, fast-forward merge or cherry-pick the `appmod/...` branch.

---

## Checkpoints Summary

Run these from the `workshop-apps/notes-app/` directory.

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | No `RollingFileAppender` in Logback config | `grep "RollingFileAppender" src/main/resources/logback-spring.xml \|\| echo "PASS: RollingFileAppender removed"` | `PASS: RollingFileAppender removed` |
| 2 | No direct file-writing in source | `grep -rE "FileWriter\|Files\\.write" src/main/java/ \|\| echo "PASS: no direct file writes"` | `PASS: no direct file writes` |
| 3 | Build passes | `mvn clean package` | `BUILD SUCCESS`, exit code 0 |

> ⚡ **One-shot validation:** From the repository root, run `bash workshop/validate.sh lab4` to execute all three checkpoints in a single command. Expected: `3/3 passed`.

> 💡 **Shell note.** The Checkpoint 1/2 one-liners use `&& / ||` so they work the same in `bash`, `zsh`, and `fish`. (Avoid `$?` — that variable does not exist in `fish`; use `$status` there.)

---

## What Just Happened?

You used a **predefined task** — a codified best practice from Microsoft's Azure migration playbook. Instead of manually finding and fixing every file-logging instance, the task:

1. Created its own working branch (`appmod/java-log-to-console-<TIMESTAMP>`).
2. Generated a plan, then identified all file-based logging patterns.
3. Replaced them with SLF4J / console equivalents.
4. Ran a 5-stage validation pipeline and made a follow-up commit when the **Completeness** check found leftovers.
5. Wrote audit artifacts to `.github/modernize/code-migration/log-to-console-<TIMESTAMP>/`.

There are **13 predefined tasks** available for Java applications, covering:

- 📨 Messaging (Spring RabbitMQ / ActiveMQ / AWS SQS → Azure Service Bus)
- 🔑 Identity (Managed Identities for DB & credentials, Microsoft Entra ID)
- 💾 Storage (AWS S3 → Blob, local file I/O → File share, **file logging → console**)
- 🔒 Secrets (AWS Secrets Manager → Key Vault, generic Key Vault migration)
- 📨 Email (Java Mail → Azure Communication Service)
- 🛢️ SQL (Oracle SQL dialect → PostgreSQL)

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **TASKS panel is empty / task not visible** | Open `workshop-apps/notes-app/` as the workspace folder (not the repo root). The extension enumerates tasks per workspace folder. Then expand `Java > Migration Tasks > Storage Tasks`. |
| **Task is named "Logging to local file" in docs but I can't find it** | The UI renamed it to **"Migrate file logging to console logging"** in v0.0.293+. Same task, same `kbId`. |
| **MCP servers prompt does not appear / task hangs at Phase 1** | Reload the VS Code window and re-run the task. When prompted, click **Allow / Start** for both `CopilotMod` and `Foundry MCP`. |
| **App won't start after changes** | Check that `logback-spring.xml` is valid XML (no unclosed tags). Ensure there are no broken class references. |
| **Tests fail after migration** | Tests may still reference file operations (`logs/audit.log`). The agent should have updated them — if not, manually remove file-based assertions from test classes. |
| **`logs/` keeps reappearing** | You probably restarted from a stale build. Run `mvn clean package` first, then `mvn spring-boot:run`. |

---

## Stretch Goal

Browse the other predefined tasks in the **TASKS** panel under `Java > Migration Tasks` (Security / Database / Message Queue / Compute / Storage / Build Tools / Authentication / Cache / Configuration / Email / Event Streaming). Explore what's available — you may find tasks relevant to your own projects. Consider which ones you might apply in Lab 6.

## See also

- **[CLI task execution](../docs/05-batch-operations.md)** — the CLI equivalent of predefined tasks, including batch operations across multiple repos.
