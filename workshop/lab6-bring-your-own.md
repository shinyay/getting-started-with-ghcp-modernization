# Lab 6: Bring Your Own App — Apply Modernization to Your Project

> 📚 **Reference docs for this lab:**
> - **[CLI deep reference](../docs/04-modernization-agent-cli.md)** — flags and artifact paths used in this lab's harness.
> - **[Custom skills](../docs/06-custom-skills.md)** — for participants who want to layer a custom skill on top of their own project.

| Detail | Value |
|--------|-------|
| **Duration** | 40 minutes |
| **Application** | Your own Java project (or NewsFeedSite as fallback) |
| **Verified With** | Harness compatible with modernize v0.0.293+, 2026-04-25 (NewsFeedSite dry-run) |

---

## Learning Objectives

By the end of this lab you will be able to:

1. Apply GitHub Copilot modernization to a **real-world codebase** you work with.
2. Handle unexpected issues that arise during automated migration.
3. Distinguish what the agent handles well versus what needs **manual attention**.

---

## Requirements for Your App

Bring a Java project that meets these criteria:

| Requirement | Details |
|-------------|---------|
| **Language** | Java |
| **Build tool** | Maven (`pom.xml`) or Gradle (`build.gradle` / `build.gradle.kts`) |
| **Source control** | Git repository (local or cloned) |
| **Java version** | 8, 11, or 17 (upgrade target: **Java 21**) |
| **Framework** | Spring Boot preferred but not required |

> 💡 **Tip:** A mid-sized project (10–50 source files) works best for a 40-minute lab. Very large projects may not complete in time.

---

## Step-by-Step Instructions

### Step 1 — Open Your Project in VS Code

Open your project folder in VS Code. Make sure the **root** of the project (where `pom.xml` or `build.gradle` lives) is the workspace root.

### Step 2 — Create a Working Branch

Always work on a branch so you can easily review or revert changes:

```bash
git checkout -b modernize-workshop
```

### Step 3 — Start with an Assessment

Before making any changes, let the agent analyze your application:

```
@modernize assess this application
```

The assessment will identify:

- Current Java and framework versions
- Dependencies with known CVEs
- Cloud-readiness issues
- Applicable predefined tasks

> 📝 Read the assessment carefully. It will guide your next steps.

### Step 4 — Review the Assessment Output

Look for:

- **Upgrade opportunities** — Can you upgrade Java? Spring Boot?
- **Security issues** — Are there vulnerable dependencies?
- **Cloud anti-patterns** — File-based logging, hardcoded credentials, local storage?
- **Predefined tasks** — Which tasks apply to your codebase?

### Step 5 — Choose Your Modernization Path

Based on the assessment, pick **one** action to start with:

**Option A — Version Upgrade** (if your app is on an older Java/Spring Boot):

```
@modernize upgrade to Java 21
```

> 💡 If your app is **not yet on Spring Boot** (e.g. plain Servlet/Jetty)
> and you also want the framework introduced, name it explicitly:
> `@modernize upgrade to Java 21 and Spring Boot 3`. A bare `Java 21`
> prompt only bumps the JDK and dependencies needed for the build to
> pass — it will not adopt Spring Boot on its own.

**Option B — Predefined Task** (if a specific migration is relevant):

In the **IDE**:

1. Open the **TASKS** panel in the modernization extension.
2. Browse the available tasks.
3. Select one that applies to your project and click **Run**.

In the **CLI** (no enumerated catalog — translate the assess findings
into a task-shaped prompt):

```bash
# 1. read the cloud-readiness issues from .github/modernize/assessment/...
#    and pick a recommended migration (e.g. RabbitMQ → Service Bus).
# 2. create a plan from a free-form prompt:
modernize plan create "Migrate from RabbitMQ to Azure Service Bus" --source . --language java
# 3. execute the plan:
modernize plan execute --source . --language java
```

> 💡 **Custom skills win automatically.** If your repo already ships
> with a project-local skill at `.github/skills/<name>/SKILL.md`, the
> agent picks it up and uses it **with priority over the built-in
> skill** — even when you don't mention the skill by name in the
> prompt. NewsFeedSite is a worked example: the
> `rabbitmq-to-azureservicebus` skill is auto-selected by the
> "Migrate from RabbitMQ to Azure Service Bus" prompt above.

> ⚠️ **`plan create --source` is local-only.** Unlike `assess`,
> `plan create` and `plan execute` only accept a local path for
> `--source` — no Git URL, no `repos.json`. Clone the repo first.

> ⚠️ **CLI may not exit on its own after success.** When you see
> "Modernization Plan — Execution Complete" with green checkmarks
> *and* fresh commits in `git log`, the work is done — you can safely
> Ctrl-C if the process keeps printing "Still waiting for Copilot
> response (Ns elapsed)…". Verify with `git log --oneline` instead of
> trusting the exit code.

**Option C — Both** (if time allows):

Start with the upgrade (Option A), then apply a predefined task
(Option B) on the upgraded tree.

> ⚠️ **Chained tasks need human review.** When the second task runs
> on an already-upgraded codebase, the agent often produces a
> **`WIP:` commit + a consistency-check report** rather than a clean
> finish — it is intentionally cautious about layered changes. Expect
> to read the consistency report under
> `.github/modernize/modernization-plan/<task-id>/` and finish the
> work manually. This is fine for a 40-minute lab, but plan time for
> the review phase rather than assuming "two tasks = two clean
> commits".

> 💡 **Don't expect bit-for-bit reproducibility.** Even with a fixed
> prompt, model, and version, framework-introduction prompts (e.g.
> `"Java 21 and Spring Boot 3"` on a non-Spring app) can land on
> different end states across runs — sometimes adopting Spring Boot,
> sometimes only doing the Jakarta EE namespace migration. Pre-run
> your demo path before the workshop and have a fallback narrative.

### Step 6 — Review Every Change

As the agent makes changes:

- Review each file modification in the diff view.
- Accept changes that look correct.
- Reject or modify changes that don't fit your project.

### Step 7 — Run Your Tests

```bash
# Maven
mvn clean test

# Gradle
./gradlew clean test
```

Fix any test failures. Some may be caused by the migration (expected); others may reveal pre-existing issues.

### Step 8 — Commit Your Progress

```bash
git add -A
git commit -m "feat: modernization from workshop lab 6"
```

---

## If You Don't Have a Project

No problem — use the **NewsFeedSite** sample application. It's a rich modernization target.

### Fork and Clone NewsFeedSite

1. **Fork** the repo at https://github.com/Azure-Samples/NewsFeedSite (click the "Fork" button)
2. Clone **your fork**:

```bash
git clone https://github.com/YOUR-USERNAME/NewsFeedSite.git
cd NewsFeedSite
```

> **Why fork?** You need write access to create branches. Cloning the original repo directly gives you read-only access.

### About NewsFeedSite

| Attribute | Value |
|-----------|-------|
| **Java version** | 17 (target: 21) |
| **Project layout** | Multi-module Maven (`client` + `service`) |
| **Framework** | Servlet / Jetty (no Spring Boot — the upgrade introduces it) |
| **Messaging** | RabbitMQ |
| **WebSocket** | `javax.websocket` (migrated to `jakarta.websocket`) |
| **Build tool** | Maven |
| **Source files** | ~4 `.java` files — small enough to fit in 40 minutes |

This application has multiple modernization opportunities packed into one
prompt: Java 17 → 21 bump, **Servlet → Spring Boot framework migration**,
JUnit 4 → 5 testing migration, `javax.*` → `jakarta.*` namespace shift,
JSP → static HTML, and Jetty → embedded Tomcat — the agent attempts all
of them as side-effects of the explicit Spring Boot 3 target.

### Suggested Workflow

1. Open `NewsFeedSite` in VS Code.
2. Create a branch: `git checkout -b modernize-workshop`
3. Run the assessment: `@modernize assess this application`
4. Try the upgrade — note the **explicit** Spring Boot 3 target is
   required because Java 21 alone won't trigger the framework migration:

```
@modernize upgrade to Java 21 and Spring Boot 3
```

5. Review changes and run the build with **Java 21 on your `PATH`**:

```bash
mvn clean package
```

> 💡 **Java toolchain.** After the upgrade, `pom.xml` requires Java 21.
> If `java -version` still shows an older JDK, switch with `sdk use java
> 21.0.x-open` (SDKMAN!) or set `JAVA_HOME` to a JDK 21 install before
> running `mvn`.

> 💡 **Single-task vs milestone plan.** Because the prompt names both
> the JDK and the Spring Boot target explicitly, the agent collapses
> the work into a **single task** (one commit). Compare with Lab 5
> Phase A, where the prompt `"Java 21"` alone produced 3 Spring Boot
> milestone hops. Be explicit when you want fewer commits; be vague
> when you want a stepwise audit trail.

---

## Tips for Success

| # | Tip |
|---|-----|
| 1 | **Start small.** Assess first, then pick one upgrade or migration. Don't try to modernize everything at once. |
| 2 | **Don't try to do everything.** A single upgrade (e.g., Java 11 → 21) is a perfectly good outcome for this lab. |
| 3 | **Well-structured projects work best.** The agent performs best on standard Maven/Gradle project layouts. |
| 4 | **Review every change.** The agent is good but not perfect — your domain knowledge matters. |
| 5 | **Iterate.** If the first pass doesn't fully work, run the agent again on the remaining issues. |

---

## Instructor Help

Raise your hand if you encounter any of these situations:

| Situation | What's Happening |
|-----------|-----------------|
| **Build fails after migration** | Check the specific error message. Often a single dependency or import needs manual correction. |
| **Agent can't analyze the project** | The project structure may be non-standard (e.g., multi-module with unusual layout). Try pointing the agent at a specific submodule. |
| **Partial migration** | This is expected for complex applications. The agent handles the bulk of the work; some edge cases require manual finishing. |
| **Agent suggests changes you disagree with** | Reject them. You know your codebase best. The agent's suggestions are recommendations, not mandates. |
| **`mvn` says "release version 21 not supported"** | Your local JDK is older than the upgraded `pom.xml` requires. Switch JDKs (`sdk use java 21.0.x-open` with SDKMAN!) or set `JAVA_HOME` before running `mvn`. |
| **CLI users only: orphan `.github/modernize/upgrade-to-lts-*/` appears in the wrong repo** | If you ran `modernize upgrade --source /path/to/your/app` from a different directory, the plan dir is created in the **CWD** repo as well as the source. `cd` into the source first, or delete the orphan after the run. The IDE flow (`@modernize`) does not have this issue. |
| **CLI: `plan execute` won't exit even though it says "Complete"** | Known v0.0.293 quirk. After "Modernization Plan — Execution Complete" with green checks AND new `git log` commits, you can Ctrl-C the process. Verify with `git log --oneline` rather than waiting for an exit code. |
| **Option C: only a `WIP:` commit appears, no clean finish** | Expected for chained tasks. The agent ran the migration, then a consistency check flagged items for manual review. Read `.github/modernize/modernization-plan/<task>/` for the report and finish manually. |
| **Same prompt produced a different result this time** | Framework-introduction prompts (e.g. `Java 21 and Spring Boot 3` on a non-Spring app) are not bit-for-bit reproducible. Use a fixed pre-recorded fallback for live demos; in the lab, treat both outcomes as valid teaching material. |

---

## Reflection Questions

Discuss with your neighbors or table group:

1. **What did the agent handle well?**
   Think about the types of changes that were accurate and complete.

2. **What needed manual intervention?**
   Were there patterns the agent missed or got wrong?

3. **How would you create a custom skill for patterns unique to your project?**
   Consider recurring migration patterns in your organization — could they become predefined tasks?

4. **Would you use the IDE or CLI workflow for your team's migration?**
   Think about your team's size, number of repositories, and CI/CD setup.

5. **What's your next step after the workshop?**
   Identify one concrete action you'll take in the next week.
