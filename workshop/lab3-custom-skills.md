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

- [ ] The repository is open in VS Code at the **repo root** (`getting-started-with-ghcp-modernization/`), so the modernize extension can scan `.github/skills/`.
- [ ] You are either on the Lab 1 upgraded branch (`upgrade-lab1`) or on `main` — both work for this lab.
- [ ] BookStore tests pass in the current state:
  ```bash
  cd workshop-apps/bookstore-app
  mvn test
  cd ../..
  ```
  ✅ Expected: `BUILD SUCCESS`

> 📁 **Working directory matters.** All commands in this lab are written to be run from the **repo root** (the directory containing `workshop/`, `docs/`, `.github/`). Step 2 will fail if you stay inside `workshop-apps/bookstore-app/`. Always `cd` back to the repo root after the Pre-Lab `mvn test`.

> 🗂 **Workspace contains multiple apps.** Besides BookStore, this workspace also has `workshop-apps/notes-app/`, `workshop-apps/dotnet-sample-app/`, `workshop-apps/stub-repos/*`, and `demo-apps/task-tracker-app/`. Lab 3 targets **BookStore only** — when you invoke the skill in Step 8, always specify `bookstore-app` explicitly so the agent does not accidentally pick a different project.

> **Note:** If you completed Lab 1, the BookStore may already have some Spring Boot 3 changes but could still have JUnit 4 tests. That's exactly the scenario this lab addresses.

> **⚠️ Important:** If Lab 1 already migrated your tests to JUnit 5 (check with
> `grep -r "org.junit.jupiter" workshop-apps/bookstore-app/src/test/`), reset the test files to
> JUnit 4 before starting this lab:
> ```bash
> git checkout main -- workshop-apps/bookstore-app/src/test/
> ```
> This resets only the test files to their original JUnit 4 state while keeping
> any other Lab 1 changes (pom.xml, source code).

---

## Background

**Custom skills** are organization-specific migration patterns stored as `SKILL.md` files. They follow the [Agent Skills specification](https://agentskills.io) and act as reusable instructions that the Copilot modernization agent can discover and apply automatically.

Think of a skill as a "playbook" — it encodes your team's knowledge about how a specific migration should be done, including patterns, examples, and edge cases. Once created, skills are shared via git and auto-detected by the agent in future modernization plans.

---

## Step-by-Step Instructions

> 📁 **All commands below run from the repo root.** If you are still inside `workshop-apps/bookstore-app/` from the Pre-Lab, run `cd ../..` first.

### Step 1 — Examine the current JUnit 4 tests

Open `workshop-apps/bookstore-app/src/test/java/com/example/bookstore/BookServiceTest.java` in VS Code and identify the JUnit 4 patterns:

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
> grep -rl "org.junit.Test" workshop-apps/bookstore-app/src/test/
> ```

### Step 2 — Copy the skill template

A scaffolded template is provided in the workshop materials. Create the destination directory first, then copy:

```bash
mkdir -p .github/skills
cp -r workshop/templates/junit4-to-junit5-skill .github/skills/junit4-to-junit5
ls .github/skills/junit4-to-junit5/
```

✅ **Expected:** `SKILL.md`

> 💡 **Why repo root, not inside the app?** The modernize extension scans the workspace root's `.github/skills/` so the same skill can be reused across every app in the repo (BookStore today, NotesApp next).

### Step 3 — Open the SKILL.md file

Open the skill file in VS Code:

```bash
code .github/skills/junit4-to-junit5/SKILL.md
```

If you copied the template, you'll see pre-filled sections. If you created the directory manually, create the file with the structure below.

### Step 4 — Review the SKILL.md structure

The SKILL.md follows the Agent Skills specification. The shipped template contains the following sections — open it in VS Code and confirm:

```text
---                              # YAML frontmatter (required)
name, description                # Routing metadata
language: java                   # Language hint (helps the agent route correctly)
applicable_to:                   # File globs the skill applies to
  - "**/pom.xml"
  - "**/src/test/java/**/*.java"
requires:                        # Marker the agent should look for
  - "org.junit.Test"
---

# JUnit 4 → JUnit 5 Migration Skill

## Overview                      # 1-line purpose statement

## Migration Patterns            # Before/After code blocks
### Pattern 1: Test Runner       (@RunWith → removed)
### Pattern 2: Test Annotation   (org.junit.Test → org.junit.jupiter.api.Test)
### Pattern 3: Assertions        (Assert.* → assertEquals etc.)
### Pattern 4: Setup and Teardown  (@Before/@After → @BeforeEach/@AfterEach)
<!-- TODO markers here: extend with org-specific patterns -->

## Steps                         # Numbered procedure for the agent

## Verification Checks           # Checklist the agent self-validates against
```

> 💡 **Patterns 1-4 cover the most common cases out of the box.** The TODO markers are where you, as the skill author, encode *organization-specific* knowledge — e.g. internal mock framework migrations, custom assertion libraries, project naming conventions.

### Step 5 — Fill in the TODO markers (YOUR TURN)

Open `SKILL.md` and find the two `<!-- TODO: -->` comments (around lines 65 and 69). They mark places where you can extend the skill for *your* codebase. For BookStore, a useful addition is the `@MockBean → @MockitoBean` migration that Spring Boot 3.4 introduced.

#### TODO 1 (around line 65) — Add a Spring Boot 3.4 mock annotation pattern

Replace the comment `<!-- TODO: Add additional patterns specific to your organization's codebase -->` with a new Pattern 5:

````markdown
### Pattern 5: Mock Annotations (Spring Boot 3.4+)

**Before (Spring Boot 2.x / 3.x ≤ 3.3):**
```java
import org.springframework.boot.test.mock.mockito.MockBean;

@MockBean
private BookRepository bookRepository;
```

**After (Spring Boot 3.4+):**
```java
import org.springframework.test.context.bean.override.mockito.MockitoBean;

@MockitoBean
private BookRepository bookRepository;
```

> Note: `@MockBean` is deprecated in Spring Boot 3.4. The replacement `@MockitoBean` lives in `org.springframework.test.context.bean.override.mockito` and works identically with JUnit 5.
````

#### TODO 2 (around line 69) — Add project-specific teardown guidance

Replace the comment `<!-- TODO: Extend this pattern with any project-specific @Before/@After teardown logic -->` with:

```markdown
> **BookStore-specific note:** The current test classes (`BookServiceTest`, `BookControllerTest`) do not use `@Before`/`@After`. If new fixture setup is added later, prefer `@BeforeEach` for per-test isolation; reserve `@BeforeAll` (static) for expensive shared resources only.
```

### Step 6 — Save the SKILL.md

Save the file (`Ctrl+S`). Verify it looks correct:

```bash
cat .github/skills/junit4-to-junit5/SKILL.md | head -10
grep -c "TODO" .github/skills/junit4-to-junit5/SKILL.md   # → expected: 0
```

✅ **Expected:** First lines show the YAML frontmatter (`name: junit4-to-junit5`, `language: java`, …), and no TODO markers remain.

### Step 7 — Verify the skill is detected

In VS Code:

1. Open the **Copilot Modernization** extension pane (look for the modernize icon in the Activity Bar).
2. Find the **My Skills** section.
3. Your `junit4-to-junit5` skill should appear in the list.
4. If it doesn't appear, click the **Refresh** button (🔄).

> **Tip:** The extension scans the workspace's `.github/skills/` for valid SKILL.md files. If the skill doesn't appear, double-check the path: `.github/skills/junit4-to-junit5/SKILL.md` (at the repo root).

### Step 8 — Run the skill from Copilot Chat

Open **Copilot Chat** in VS Code and invoke the skill with a slash command:

```
/junit4-to-junit5 を workshop-apps/bookstore-app に対して実行してください
```

You can also write the prompt in English:

```
/junit4-to-junit5 apply to workshop-apps/bookstore-app
```

✅ **Expected:** Chat responds with `Skill "junit4-to-junit5" loaded successfully. Follow the instructions in the skill context.`, then the agent reads the test files, edits them, updates `pom.xml`, and runs `mvn test`.

> 💡 **Why a slash command?** Copilot Chat exposes every SKILL.md under `.github/skills/` as a slash command using the skill's `name:` value. This is the most reliable way to invoke a skill on a *specific* target — you control which app the skill runs against by naming it in the prompt. The Copilot Modernization extension also exposes a **Run Skill** button in the My Skills pane, but on workspaces that contain a mix of languages (e.g. Java + .NET) it can pick the wrong project; specifying the target in chat avoids that.

### Step 9 — Watch the agent work

The agent will:

1. Find all test files with JUnit 4 patterns under `workshop-apps/bookstore-app/src/test/`.
2. Apply the migration rules from your SKILL.md.
3. Update imports, annotations, and assertions.
4. Update `pom.xml` (remove the JUnit 4 dependency, drop the `junit-jupiter` exclusion).
5. Run `mvn test` to confirm the migration.

> 📝 **The agent does not auto-commit.** When it finishes, the changes are staged in your working tree. Review them in the Source Control pane, then commit yourself (Step 12 shows the command).

### Step 10 — Verify the migration (Checkpoint 2)

Check that JUnit 5 imports are now present:

```bash
# Should find JUnit 5 (Jupiter) imports
grep -r "org.junit.jupiter" workshop-apps/bookstore-app/src/test/

# Should find NO JUnit 4 imports
grep -r "import org.junit.Test" workshop-apps/bookstore-app/src/test/
grep -r "import org.junit.Assert" workshop-apps/bookstore-app/src/test/
```

✅ **Expected:**
- First command: multiple matches for `org.junit.jupiter`
- Second and third commands: **no output**

### Step 11 — Run the tests (Checkpoint 3)

Confirm all tests still pass after migration:

```bash
cd workshop-apps/bookstore-app
mvn test
cd ../..
```

✅ **Expected:** `BUILD SUCCESS` — all tests pass with JUnit 5.

### Step 12 — Review and commit

See what the skill changed:

```bash
git status
git diff -- workshop-apps/bookstore-app/
```

Then commit the migration:

```bash
git add workshop-apps/bookstore-app/
git commit -m "test(bookstore): migrate JUnit 4 → JUnit 5 via custom skill"
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
