# Lab 6: Bring Your Own App — Apply Modernization to Your Project

| Detail | Value |
|--------|-------|
| **Duration** | 40 minutes |
| **Application** | Your own Java project (or NewsFeedSite as fallback) |

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

**Option B — Predefined Task** (if a specific migration is relevant):

1. Open the **TASKS** panel in the modernization extension.
2. Browse the available tasks.
3. Select one that applies to your project and click **Run**.

**Option C — Both** (if time allows):

Start with the upgrade, then apply a predefined task.

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

### Clone NewsFeedSite

```bash
git clone https://github.com/Azure-Samples/NewsFeedSite.git
cd NewsFeedSite
```

### About NewsFeedSite

| Attribute | Value |
|-----------|-------|
| **Java version** | 8 |
| **Framework** | Servlet / Jetty |
| **Messaging** | RabbitMQ |
| **Build tool** | Maven |

This application has multiple modernization opportunities: Java upgrade, framework migration, messaging modernization, and more.

### Suggested Workflow

1. Open `NewsFeedSite` in VS Code.
2. Create a branch: `git checkout -b modernize-workshop`
3. Run the assessment: `@modernize assess this application`
4. Try the upgrade:

```
@modernize upgrade to Java 21 and Spring Boot 3
```

5. Review changes and run `mvn clean package`.

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
