# Lab 4: Predefined Tasks — Migrate File Logging to Console for Azure Monitor

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | NotesApp (`workshop-apps/notes-app/`) |
| **Stack** | Spring Boot 3.2.5, Java 17, file-based logging |

---

## Learning Objectives

By the end of this lab you will be able to:

1. Understand **predefined tasks** as codified best practices for cloud migration.
2. Apply the **"Logging to local file"** predefined task to eliminate file-based logging.
3. Verify that logging output is redirected to the console (stdout), making the application cloud-ready for Azure Monitor.

---

## Pre-Lab Checklist

- [ ] NotesApp folder (`workshop-apps/notes-app/`) is open in VS Code.
- [ ] The build passes:

```bash
cd workshop-apps/notes-app
mvn clean package
```

> If the build fails at this stage, resolve the issue before continuing.

---

## Why This Matters

In cloud and container environments, file-based logging is an anti-pattern. Container filesystems are **ephemeral** — when a container restarts, any log files written to disk are lost. Azure Monitor, Application Insights, and other observability platforms integrate with **console/stdout** output, not local files. The predefined task automates the migration from file-based logging to console-only logging, saving time and reducing the risk of misconfiguration.

---

## The Problem: Two File-Logging Anti-Patterns

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

Wait until you see `Started NotesAppApplication` in the console.

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
cat logs/notes-app.log
cat logs/audit.log
```

Both files should contain entries. This confirms the file-based logging is active.

### Step 6 — Stop the Application

Return to the terminal running the app and press **Ctrl+C** to stop it.

### Step 7 — Create a Working Branch

```bash
git checkout -b fix-logging
```

### Step 8 — Open the Predefined Tasks Panel

In VS Code:

1. Open the **GitHub Copilot Modernization** extension sidebar.
2. Navigate to **TASKS**.
3. Find the task named **"Logging to local file"**.

### Step 9 — Run the Predefined Task

Click **Run** on the "Logging to local file" task.

Alternatively, use Copilot Chat:

```
@modernize migrate file-based logging to console logging
```

### Step 10 — Watch the Changes

Observe the agent working. It should:

- **Update `logback-spring.xml`** — remove the `RollingFileAppender`, keep or add a `ConsoleAppender`.
- **Update `NoteService.java`** — replace the `writeAuditLog()` method's `FileWriter`/`Files.write()` calls with proper SLF4J logger calls.

Review each change before accepting.

### Step 11 — Rebuild and Verify

Restart the application:

```bash
mvn spring-boot:run
```

Create another note:

```bash
curl -X POST http://localhost:8083/api/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"After Fix","content":"No more file logs"}'
```

Verify:

- ✅ Logs appear in the **console** (stdout).
- ✅ No new files are created in the `logs/` directory.

### Step 12 — Stop the App and Commit

```bash
# Stop the app (Ctrl+C), then:
git add -A
git commit -m "fix: migrate file-based logging to console for Azure Monitor"
```

---

## Checkpoint 1 — No RollingFileAppender

```bash
grep "RollingFileAppender" src/main/resources/logback-spring.xml
```

**Expected:** No output (no matches found).

---

## Checkpoint 2 — No Direct File Writing

```bash
grep -r "FileWriter\|Files.write" src/main/java/
```

**Expected:** No output (no matches found).

---

## Checkpoint 3 — Build Passes

```bash
mvn clean package
```

**Expected:** `BUILD SUCCESS` with exit code 0.

---

## What Just Happened?

You used a **predefined task** — a codified best practice from Microsoft's Azure migration playbook. Instead of manually finding and fixing every file-logging instance, the task:

1. Identified all file-based logging patterns.
2. Replaced them with console/SLF4J equivalents.
3. Ensured the configuration is cloud-ready.

There are **13 predefined tasks** available for Java applications, covering:

- 📨 Messaging (e.g., switch to Azure Service Bus)
- 🔑 Identity (e.g., migrate to passwordless authentication)
- 💾 Storage (e.g., move to Azure Blob Storage)
- 🔒 Security (e.g., enable managed identity)
- 📊 Monitoring (e.g., integrate with Azure Monitor)

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **Predefined task not visible** | Ensure the `notes-app` directory is the folder open in VS Code (not a parent directory). Verify the GitHub Copilot Modernization extension is installed and loaded. |
| **App won't start after changes** | Check that `logback-spring.xml` is valid XML (no unclosed tags). Ensure there are no broken class references. |
| **Tests fail after migration** | Tests may still reference file operations (`logs/audit.log`). The agent should have updated them — if not, manually remove file-based assertions from test classes. |

---

## Stretch Goal

Browse the other predefined tasks in the **TASKS** panel. Explore what's available — you may find tasks relevant to your own projects. Consider which ones you might apply in Lab 6.
