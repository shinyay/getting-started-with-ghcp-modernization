# Lab 3: Custom Skills — Create a JUnit 4 → JUnit 5 Migration Skill

| Detail | Value |
|--------|-------|
| **Duration** | 30 minutes |
| **Application** | BookStore (`workshop-apps/bookstore-app/`) |
| **Difficulty** | Intermediate |

---

## Learning Objectives

By the end of this lab you will be able to:

- **Understand the Agent Skills specification** — what a SKILL.md file is, how it's structured, and why it matters.
- **Create a custom SKILL.md** that encodes organization-specific migration knowledge for JUnit 4 → JUnit 5.
- **Run a skill explicitly** via the Copilot modernization extension or Copilot Chat.
- **Verify migration results** by checking imports, annotations, and running the test suite.

---

## Pre-Lab Checklist

Before you begin, confirm every item below:

- [ ] The **BookStore** project is open in VS Code (`workshop-apps/bookstore-app/`).
- [ ] You are either on the Lab 1 upgraded branch (`upgrade-lab1`) or on `main` — both work for this lab.
- [ ] Tests pass in the current state:
  ```bash
  mvn test
  ```
  ✅ Expected: `BUILD SUCCESS`

> **Note:** If you completed Lab 1, the BookStore may already have some Spring Boot 3 changes but could still have JUnit 4 tests. That's exactly the scenario this lab addresses.

---

## Background

**Custom skills** are organization-specific migration patterns stored as `SKILL.md` files. They follow the [Agent Skills specification](https://agentskills.io) and act as reusable instructions that the Copilot modernization agent can discover and apply automatically.

Think of a skill as a "playbook" — it encodes your team's knowledge about how a specific migration should be done, including patterns, examples, and edge cases. Once created, skills are shared via git and auto-detected by the agent in future modernization plans.

---

## Step-by-Step Instructions

### Step 1 — Examine the current JUnit 4 tests

Open `src/test/java/.../BookServiceTest.java` in VS Code and identify the JUnit 4 patterns:

```java
// JUnit 4 patterns to look for:
import org.junit.Test;                          // ← JUnit 4 Test annotation
import org.junit.runner.RunWith;                // ← JUnit 4 runner model
import org.springframework.test.context.junit4.SpringRunner;
import static org.junit.Assert.assertEquals;    // ← JUnit 4 assertions

@RunWith(SpringRunner.class)                    // ← JUnit 4 runner
public class BookServiceTest {

    @Test                                       // ← org.junit.Test (JUnit 4)
    public void testFindAll() {
        // ...
        Assert.assertEquals(expected, actual);  // ← JUnit 4 assertion
    }
}
```

> 📝 Count how many test files use JUnit 4 patterns:
> ```bash
> grep -rl "org.junit.Test" src/test/
> ```

### Step 2 — Copy the skill template

A scaffolded template is provided in the workshop materials. Copy it to the correct location:

```bash
cp -r workshop/templates/junit4-to-junit5-skill .github/skills/junit4-to-junit5
```

> If the template directory doesn't exist, create the skill directory manually:
> ```bash
> mkdir -p .github/skills/junit4-to-junit5
> ```

### Step 3 — Open the SKILL.md file

Open the skill file in VS Code:

```bash
code .github/skills/junit4-to-junit5/SKILL.md
```

If you copied the template, you'll see pre-filled sections. If you created the directory manually, create the file with the structure below.

### Step 4 — Review the SKILL.md structure

The SKILL.md follows the Agent Skills specification. Here's the expected structure:

```markdown
---
name: junit4-to-junit5
description: Migrate JUnit 4 tests to JUnit 5 (Jupiter) — replaces @RunWith with @ExtendWith, org.junit.Test with org.junit.jupiter.api.Test, and Assert.* with Assertions.*.
---

# JUnit 4 → JUnit 5 Migration Skill

## Overview

This skill migrates Java test files from JUnit 4 to JUnit 5 (Jupiter).
It handles annotation changes, import updates, assertion API migration,
and runner-to-extension model conversion.

## Steps

1. **Update imports**: Replace `org.junit.*` with `org.junit.jupiter.api.*`
2. **Migrate annotations**: Replace `@RunWith` with `@ExtendWith`
3. **Update assertions**: Replace `Assert.*` with `Assertions.*`
4. **Update lifecycle annotations**: `@Before` → `@BeforeEach`, `@After` → `@AfterEach`

<!-- TODO: Add detailed step for @RunWith migration -->
<!-- TODO: Add code example for Assert migration -->

## Examples

### Example 1: Basic Test Migration

**Before:**
```java
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class MyTest {
    @Test
    public void testSomething() {
        assertEquals(2, 1 + 1);
    }
}
```

**After:**
```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class MyTest {
    @Test
    void testSomething() {
        assertEquals(2, 1 + 1);
    }
}
```

## Patterns

| JUnit 4 | JUnit 5 |
|---------|---------|
| `org.junit.Test` | `org.junit.jupiter.api.Test` |
| `org.junit.Assert` | `org.junit.jupiter.api.Assertions` |
| `org.junit.Before` | `org.junit.jupiter.api.BeforeEach` |
| `org.junit.After` | `org.junit.jupiter.api.AfterEach` |
| `org.junit.BeforeClass` | `org.junit.jupiter.api.BeforeAll` |
| `org.junit.AfterClass` | `org.junit.jupiter.api.AfterAll` |
| `org.junit.Ignore` | `org.junit.jupiter.api.Disabled` |
| `@RunWith(SpringRunner.class)` | `@ExtendWith(SpringExtension.class)` |
| `@Rule` / `@ClassRule` | `@ExtendWith` or `@RegisterExtension` |
```

### Step 5 — Fill in the TODO sections (YOUR TURN)

This is the hands-on part. You need to add two things to the SKILL.md:

#### TODO 1: Add a detailed step for `@RunWith` migration

Under the `## Steps` section, add a new step with specifics:

```markdown
5. **Migrate `@RunWith` to `@ExtendWith`**: Replace `@RunWith(SpringRunner.class)`
   with `@ExtendWith(SpringExtension.class)`. Update the import from
   `org.springframework.test.context.junit4.SpringRunner` to
   `org.junit.jupiter.api.extension.ExtendWith` and
   `org.springframework.test.context.junit.jupiter.SpringExtension`.
```

#### TODO 2: Add a code example for assertion migration

Under `## Examples`, add a new example:

```markdown
### Example 2: Assertion Migration

**Before:**
```java
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

Assert.assertEquals("message", expected, actual);
Assert.assertNotNull(object);
Assert.assertTrue(condition);
```

**After:**
```java
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

Assertions.assertEquals(expected, actual, "message");  // message moved to last parameter
Assertions.assertNotNull(object);
Assertions.assertTrue(condition);
```

> ⚠️ **Note:** In JUnit 5, the assertion message parameter moved from the **first** argument to the **last** argument. This is a common source of compilation errors.
```

### Step 6 — Save the SKILL.md

Save the file (`Ctrl+S`). Verify it looks correct:

```bash
cat .github/skills/junit4-to-junit5/SKILL.md | head -5
```

✅ **Expected:** The first few lines show the YAML frontmatter:
```
---
name: junit4-to-junit5
description: Migrate JUnit 4 tests to JUnit 5 (Jupiter) API
...
```

### Step 7 — Verify the skill is detected

In VS Code:

1. Open the **Copilot modernization extension** pane (look for the modernize icon in the Activity Bar).
2. Find the **My Skills** section.
3. Your `junit4-to-junit5` skill should appear in the list.
4. If it doesn't appear, click the **Refresh** button (🔄).

> **Tip:** The extension scans `.github/skills/` for valid SKILL.md files. If the skill doesn't appear, double-check the path: `.github/skills/junit4-to-junit5/SKILL.md`.

### Step 8 — Run the skill

You have two options:

**Option A — Via the extension pane:**
1. Click **Run Skill** next to the `junit4-to-junit5` skill.
2. The agent will scan test files and apply the migration.

**Option B — Via Copilot Chat:**
1. Open Copilot Chat.
2. Type:
   ```
   @modernize migrate JUnit 4 tests to JUnit 5 using my custom skill
   ```
3. The agent will discover your custom skill and apply it.

### Step 9 — Watch the agent work

The agent will:

1. Find all test files with JUnit 4 patterns.
2. Apply the migration rules from your SKILL.md.
3. Update imports, annotations, and assertions.
4. Commit each change to git.

### Step 10 — Verify the migration (Checkpoint 2)

Check that JUnit 5 imports are now present:

```bash
# Should find JUnit 5 (Jupiter) imports
grep -r "org.junit.jupiter" src/test/

# Should find NO JUnit 4 imports
grep -r "import org.junit.Test" src/test/
grep -r "import org.junit.Assert" src/test/
```

✅ **Expected:**
- First command: multiple matches for `org.junit.jupiter`
- Second and third commands: **no output**

### Step 11 — Run the tests (Checkpoint 3)

Confirm all tests still pass after migration:

```bash
mvn test
```

✅ **Expected:** `BUILD SUCCESS` — all tests pass with JUnit 5.

### Step 12 — Review what changed

See the git history of the skill-driven migration:

```bash
git log --oneline -5
git diff HEAD~3 -- src/test/
```

---

## Checkpoints Summary

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | SKILL.md exists | `cat .github/skills/junit4-to-junit5/SKILL.md \| head -5` | Shows YAML frontmatter with `name: junit4-to-junit5` |
| 2 | Tests migrated | `grep -r "org.junit.jupiter" src/test/` | One or more matches |
| 3 | Tests pass | `mvn test` | `BUILD SUCCESS` |

---

## What Just Happened?

You created a **custom skill** that encodes your organization's knowledge about how JUnit 4 → JUnit 5 migration should be done. This is powerful for several reasons:

- **Reusable**: The skill lives in `.github/skills/` and is version-controlled. Any team member who clones the repo gets the skill automatically.
- **Discoverable**: The Copilot modernization agent auto-detects skills in `.github/skills/` and can include them in future migration plans — even without being explicitly told.
- **Shareable**: Skills follow the open [Agent Skills specification](https://agentskills.io), so they can be shared across repositories and organizations.
- **Customizable**: You can encode organization-specific patterns, naming conventions, and edge cases that generic migration tools miss.

In production, teams create skills for their most common migration patterns: logging framework changes, security library updates, internal API migrations, and more.

---

## Troubleshooting

| Symptom | Solution |
|---------|----------|
| **Skill not showing in My Skills** | Click the Refresh button. Verify the skill name uses hyphens, not spaces (e.g., `junit4-to-junit5`). Check the file path is exactly `.github/skills/junit4-to-junit5/SKILL.md`. |
| **Agent doesn't use the skill** | Run it explicitly using the **Run Skill** button in the extension pane, not via auto-detection. Auto-detection works in assessment/plan flows, but explicit invocation is more reliable for testing. |
| **Tests don't compile after migration** | Check import statements. Common issue: `org.junit.jupiter.api.Test` (correct) vs. `org.junit.Test` (JUnit 4). Also verify the assertion message parameter order — in JUnit 5, the message is the **last** parameter. |
| **`@ExtendWith` not recognized** | Ensure the `junit-jupiter` dependency is in `pom.xml`. If using Spring Boot 3.x, it should be included via `spring-boot-starter-test`. For Spring Boot 2.x, add manually: `org.junit.jupiter:junit-jupiter:5.10.x`. |
| **Mixed JUnit 4 and 5 in same file** | The agent should handle this, but if not, manually remove any remaining JUnit 4 imports and replace them with JUnit 5 equivalents from the Patterns table above. |
