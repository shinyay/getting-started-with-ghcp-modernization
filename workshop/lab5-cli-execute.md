# Lab 5: CLI Plan Execute — Run an Upgrade via the Modernize CLI

> 📚 **Reference docs for this lab:**
> - **[CLI deep reference](../docs/04-modernization-agent-cli.md)** — every flag and output path.
> - **[CLI task execution](../docs/05-modernization-cli-task-execution.md)** — `plan execute`, batch flows, `repos.json`.
> - **[CLI cookbook](../docs/examples/cli-cookbook.md)** — copy-paste recipes.

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | BookStore (`workshop-apps/bookstore-app/`) |
| **Stack** | Spring Boot 2.7, Java 11 → target: **Java 21 + Spring Boot LATEST GA** |
| **Verified With** | `modernize` CLI v0.0.293+ (with Copilot CLI 1.0.10) |

---

## Learning Objectives

By the end of this lab you will be able to:

1. Execute a full modernization plan using the **`modernize upgrade`** CLI command.
2. Read the agent's actual execution flow (skill → Tasks → Milestones → validation → commits) and locate the artifacts it produces.
3. Compare the **CLI workflow** with the **IDE workflow** from Lab 1.
4. Use **batch mode** (Phase B) to upgrade multiple repositories with a single `--source ./repos.json` invocation.

---

## Pre-Lab Checklist

- [ ] The `modernize` CLI is installed and on PATH:

  ```bash
  modernize --version
  modernize --help
  ```

  Tested in this lab with **v0.0.293+**.

- [ ] BookStore is in its original state (Java 11 + Spring Boot 2.7):

  ```bash
  cd workshop-apps/bookstore-app
  grep "java.version" pom.xml          # -> 11
  grep "spring-boot-starter-parent" pom.xml -A1 | head -3   # -> 2.7.x
  ```

  If you ran any previous lab against BookStore, reset it safely:

  ```bash
  git stash --include-untracked   # preserves any local scratch work
  git checkout main
  ```

  > ⚠️ If you have **no** local changes you want to keep, you may use
  > `git reset --hard main && git clean -fd` instead — this is faster but
  > **deletes untracked files** (IDE configs, scratch notes, etc.).

> ⚠️ **Be on a throwaway branch before Step 2.** The CLI **commits directly
> onto your currently checked-out branch** — it does *not* create a separate
> `appmod/*` branch the way the predefined-task agent in Lab 4 does. A
> 4-commit upgrade will land wherever `HEAD` is. Run
> `git checkout -b lab5/scratch` (or similar) first.

---

## Why This Matters

Lab 1 ran the same upgrade through the IDE chat. This lab runs it through
the CLI — same agent, same outcome, different surface. The CLI is the
right interface when you want to:

- Drop the upgrade into a **shell script** or **CI/CD pipeline**.
- Run **batch upgrades** across many repositories.
- Integrate with non-VS Code editors and remote shells.

---

## Step-by-Step Instructions

### Step 1 — Confirm the Starting State

```bash
cd workshop-apps/bookstore-app
grep "java.version" pom.xml
grep "spring-boot" pom.xml | head -3
```

You should see Java 11 and Spring Boot 2.7.x references.

### Step 2 — Run the CLI Upgrade Command

From the **repository root**, execute:

```bash
modernize upgrade "Java 21" --source ./workshop-apps/bookstore-app
```

> 💡 **Cheat sheet** — run `modernize upgrade --help` for the full surface:
> - `--source` is **repeatable** (multiple paths or Git URLs) and accepts
>   a JSON config file path (used in Phase B).
> - `--delegate local|cloud` picks the executor.
> - `--no-tty` forces plain text output for CI logs.
> - `--model` overrides the default `claude-sonnet-4.6`.
>
> 📌 **Target prompt semantics** — `"Java 21"` means
> "**Java 21 + the latest Spring Boot GA that supports it**". On the
> verification run that produced this lab, Spring Boot was upgraded
> **all the way to 3.5.3** even though the prompt only said "Java 21".
> To pin a specific Spring Boot version, prompt with
> `"Java 21, Spring Boot 3.3"` instead.

### Step 3 — Watch the Execution Flow

The CLI prints a banner with `GitHub account / GitHub CLI version /
Copilot CLI version / Model`, then progresses through these phases:

| Phase | Header you will see | What it does |
|-------|--------------------|--------------|
| 1 | `Preparing upgrade` | Auto-detects `Mode: Single repository` (or `Batch` for repos.json), `Language`, and `Directory` (= cwd). |
| 2 | `Creating upgrade plan` | Invokes the named skill `create-java-upgrade-plan`. The plan is structured as one or more **Tasks**, each split into **Milestones**. |
| 3 | `Executing plan` | Iterates Task by Task, Milestone by Milestone. Uses **OpenRewrite** recipes when one fits (e.g. `UpgradeToJava21`, `UpgradeSpringBoot_3_3`); falls back to manual edits otherwise. |
| 4 | (per-Task validation) | `build_java_project` → `run_tests_for_java` → CVE scan → behavioral consistency analysis. |
| 5 | `summarize_upgrade` | Writes `modernization-summary.md` (see Step 4 callout). |
| 6 | (commits) | **One commit per Milestone** + one docs commit for the summary. **Lands on your current branch.** |
| 7 | (stash restore) | The agent does **Always-Stash** on entry; uncommitted changes are restored at the end. |

> ⏳ Expect **5–15 minutes** end-to-end. Don't `Ctrl+C` mid-flight.

### Step 4 — Review the Git History

After the upgrade completes, examine what the CLI did:

```bash
git log --oneline | head -10
```

On the verification run you should see **one commit per Spring Boot
hop** plus one docs commit. The exact patch versions resolve at runtime
to the latest GA on each major line; the chain below was verified on
2026-04-25 (`2.7.x → 3.3.x → 3.4.x → 3.5.x`):

```
docs: add modernization summary for Java 21 and Spring Boot 3.x upgrade
Upgrade Spring Boot 3.4.x to 3.5.x
Upgrade Spring Boot 3.3.x to 3.4.x and migrate @MockBean to @MockitoBean
Upgrade Spring Boot 2.7.x to 3.3.x and Java 11 to 21 with javax to jakarta migration
```

> 📂 **Where the agent wrote its plan/summary**
>
> ```text
> workshop-apps/bookstore-app/.github/modernize/upgrade-to-lts-<TIMESTAMP>/
>   001-upgrade-java-spring-boot/
>     modernization-summary.md
> ```
>
> `.github/modernize/` is gitignored at the repo root. The agent
> **force-adds** `modernization-summary.md` so it lands in git as the
> docs commit.

### Step 5 — Review the Full Diff

```bash
git diff main -- workshop-apps/bookstore-app
```

For BookStore the diff is small — typically **4 files**:

| File | Change |
|------|--------|
| `pom.xml` | `spring-boot-starter-parent` 2.7.x → 3.x; `java.version`, `maven.compiler.source/target` 11 → 21 |
| `src/main/java/com/example/bookstore/model/Book.java` | `javax.persistence.*` → `jakarta.persistence.*` (Entity, GeneratedValue, GenerationType, Id, Table, Column) |
| `src/test/java/com/example/bookstore/BookControllerTest.java` | `@MockBean` → `@MockitoBean` (deprecated in Spring Boot 3.4) |
| `.github/modernize/upgrade-to-lts-<TS>/001-.../modernization-summary.md` | New file (force-added by agent) |

Larger applications will see proportionally more files, but the **shape**
of the change is the same.

### Step 6 — Verify the Build (Sanity Check)

The agent already ran the build and the test suite before each commit
(Phase 4 in Step 3). This step is just an independent confirmation:

```bash
cd workshop-apps/bookstore-app
mvn clean package
```

`BUILD SUCCESS` with all tests green.

### Step 7 — Compare with Lab 1

In Lab 1 you ran the same upgrade through the IDE (`@modernize` chat).
The result is the same; the workflow differs:

| | Lab 1 (IDE) | Lab 5 (CLI) |
|---|---|---|
| Experience | Interactive, in-editor diff preview | Terminal, scriptable |
| Branch behavior | Inline edits; you commit | Commits straight to `HEAD` |
| Batch | ❌ | ✅ via `--source ./repos.json` |
| Best for | Single-app exploration | Automation, CI/CD |

Both produce equivalent code. Pick the surface that fits your workflow.

---

## Phase B — Multi-Repository (Batch) Mode

Phase B upgrades **multiple** repositories in one invocation. The CLI
calls this **"Multi-repository" mode** (header reads
`Mode: Multi-repository (N repositories)`), and dispatches each repo
sequentially through its own per-repo plan.

### Step 8 — Prepare a `repos.json`

The CLI accepts a JSON config file via `--source`. The supported schema
is the **Full format** with `path` (absolute) — see
[`docs/examples/repos.json.full-format.example`](../docs/examples/repos.json.full-format.example)
and `docs/04-modernization-agent-cli.md` for details.

> ⚠️ **Two pitfalls verified during dry-run:**
> 1. `path` **must be an absolute path**. Relative paths like
>    `./workshop-apps/bookstore-app` are rejected at startup with
>    `ERROR: 'path' must be an absolute path`.
> 2. `url: file://...` **does not work** — the CLI treats every `url`
>    as a remote and runs `git clone`, which fails on `file://` schemes
>    in this version. Always use `path:` for local sources.

**Quickest path** — use the helper, which emits absolute paths for all
four workshop apps:

```bash
bash workshop/generate-repos-json.sh
# Writes .github/modernize/repos.json (Full-format, absolute paths)
```

**Manual minimal example** for just two repos:

```bash
mkdir -p .github/modernize
REPO_ROOT="$(pwd)"
cat > .github/modernize/repos.json << JSON
{
  "repos": [
    {
      "name": "bookstore-app",
      "path": "${REPO_ROOT}/workshop-apps/bookstore-app",
      "description": "Spring Boot 2.7 / Java 11 storefront"
    },
    {
      "name": "inventory-api",
      "path": "${REPO_ROOT}/workshop-apps/stub-repos/inventory-api",
      "description": "Spring Boot 2.7 / Java 8 inventory stub"
    }
  ]
}
JSON
```

### Step 9 — Reset BookStore for the Batch Run

If you completed Phase A on this branch, reset bookstore-app so the
batch run starts from a clean Java 11 / Spring Boot 2.7 baseline:

```bash
cd workshop-apps/bookstore-app
git stash --include-untracked
git checkout main
cd ../..
```

> ⚠️ Same destructive-alternative caveat as the Pre-Lab Checklist applies:
> `git reset --hard main && git clean -fd` is faster but deletes
> untracked files.

### Step 10 — Run the Batch Upgrade

> ⚠️ **No auto-detection.** Pass the JSON file explicitly with `--source`.
> The CLI does not look for `repos.json` in the cwd or in
> `.github/modernize/` automatically.

```bash
modernize upgrade "Java 21" --source ./.github/modernize/repos.json
```

You'll see, in order:

1. Header: `Mode: Multi-repository (2 repositories)`
2. A **Copilot Usage** notice ("This operation will run across N
   repositories and use Copilot premium requests for each one").
3. An **Upgrade Dashboard** table (TASK / NAME / STATUS / TIME) that
   refreshes between repos with `PENDING` → `RUNNING...` → `SUCCESS` /
   `FAILED`.
4. A single **shared plan** is created at
   `.github/modernize/upgrade-to-lts-<TIMESTAMP>/plan.md` containing
   one generic task: `001-upgrade-java-21` (skill `java-version-upgrade`).
5. Each repo is then processed **sequentially** — one `RUNNING...` at a
   time, never two — and the per-repo agent generates its own
   milestones based on the repo's actual state.
6. A final **Aggregated Upgrade Report** lists each repo with
   Success / Failed.

### Step 11 — Verify Both Repositories

```bash
( cd workshop-apps/bookstore-app           && git log --oneline | head -5 && mvn -q clean package )
( cd workshop-apps/stub-repos/inventory-api && git log --oneline | head -5 && mvn -q clean package )
```

> 💡 **Don't be surprised if the two repos receive different upgrades.**
> In Multi-repository mode the CLI applies a **minimum-change strategy**:
> it bumps Spring Boot only when required for the build to pass on the
> target Java version.
>
> | Repo | Start | Result | Commits added |
> |---|---|---|---|
> | bookstore-app | Java 11 / SB 2.7.18 | Java 21 / **SB 2.7.18** | 2 (pom + summary) |
> | inventory-api | Java 8 / SB 2.7.18 / `javax.persistence` | Java 21 / SB 3.5.3 / `jakarta.persistence` | 4 (3 SB hops + summary) |
>
> bookstore-app skips the Spring Boot upgrade because SB 2.7.18 still
> builds on Java 21. inventory-api is forced through three SB hops
> because `javax.persistence` requires Spring Boot 3.x. This differs
> from Phase A, where the same bookstore-app received the full
> SB 2.7 → 3.5 chain.

### Step 12 — Clean Up

`.github/modernize/` is gitignored at the repo root, so generated
artifacts (`repos.json`, `upgrade-to-lts-*/`) won't pollute commits.
You can remove `repos.json` if you want a clean working tree:

```bash
rm .github/modernize/repos.json
```

---

## Checkpoints

These commands use `&& / ||` so they work the same in `bash`, `zsh`, and `fish`.

### Checkpoint 1 — Jakarta Migration Confirmed

```bash
grep -r "jakarta.persistence" workshop-apps/bookstore-app/src/main/java/ \
  && echo "PASS: jakarta.persistence imports present" \
  || echo "FAIL: still on javax.persistence"
```

### Checkpoint 2 — Multiple Commits Exist

```bash
( cd workshop-apps/bookstore-app && [ "$(git log --oneline | head -3 | wc -l)" -gt 1 ] ) \
  && echo "PASS: multiple commits present" \
  || echo "FAIL: expected multiple commits"
```

### Checkpoint 3 — Build Passes

```bash
( cd workshop-apps/bookstore-app && mvn -q clean package ) \
  && echo "PASS: BUILD SUCCESS" \
  || echo "FAIL: build failed"
```

The included automation runs all three at once:

```bash
bash workshop/validate.sh lab5
# -> Lab lab5: 3/3 checkpoints passed
```

---

## What Just Happened?

### Phase A — single repository

The CLI did the same thing the IDE does in Lab 1, with the agent's
internals more visible:

1. Loaded the `create-java-upgrade-plan` skill.
2. Built a Task with multiple **Milestones** (Java + Spring Boot 3.3,
   Spring Boot 3.4 with `@MockBean` migration, Spring Boot 3.5).
3. For each Milestone, applied an **OpenRewrite** recipe when available
   (`UpgradeToJava21`, `UpgradeSpringBoot_3_3`, …) and edited manually
   when no recipe existed.
4. Validated each Milestone (build + tests + CVE + behavioral consistency).
5. Wrote `modernization-summary.md` and committed everything to `HEAD`.

### Phase B — multi-repository

The Multi-repository flow is two layers:

1. **Top-level batch plan** — `create-java-upgrade-plan` runs once at
   the repo root and writes a single generic task
   (`001-upgrade-java-21`, skill `java-version-upgrade`) to
   `.github/modernize/upgrade-to-lts-<TIMESTAMP>/plan.md`.
2. **Per-repo execution** — for each repo in `repos.json`, the CLI
   launches the upgrade agent which generates its own session-specific
   milestone plan based on that repo's actual state. Repos that already
   build on the target Java version skip the Spring Boot bumps; repos
   that require Jakarta migration get the full SB hop chain.

This minimum-change strategy is why the same prompt produces different
commit histories per repo. To force the full upgrade chain everywhere,
pass an explicit floor like `"Java 21, Spring Boot 3.5"`.

---

## IDE vs CLI Comparison

| Feature | IDE (`@modernize`) | CLI (`modernize upgrade`) |
|---------|-------------------|---------------------------|
| **Best for** | Single app, interactive exploration | Batch processing, CI/CD, automation |
| **Execution** | Visual, in-editor diff preview | Terminal-based, scriptable |
| **Branch policy** | Inline edits; you commit | Auto-commits to current branch (use a throwaway branch) |
| **Batch support** | No | Yes (`--source ./repos.json`) |
| **Cloud delegation** | Via GitHub.com | `--delegate cloud` |
| **Human review** | Inline accept/reject per change | Post-hoc via `git diff` / `git log` |
| **CI/CD integration** | Not directly | Yes — drop into pipelines |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **`modernize` command not found** | Verify installation. Check your `PATH`. Try `which modernize` (or `where modernize` on Windows). |
| **Upgrade stalls / hangs** | Check network. Try a different model: `modernize upgrade "Java 21" --source ... --model claude-sonnet-4.6`. Consider `--no-tty` if the rich UI is interfering with the terminal. |
| **The agent committed onto my feature branch — I wanted a separate one** | This is by design for `modernize upgrade`. To recover: `git branch lab5/result HEAD` to save it, then `git reset --hard <pre-upgrade-sha>` on the original branch. Always start on a throwaway branch (Pre-Lab note). |
| **Spring Boot version overshoots my target** | The prompt `"Java 21"` upgrades to the **latest** Spring Boot GA. Pin it explicitly: `modernize upgrade "Java 21, Spring Boot 3.3" --source ...`. |
| **`modernization-summary.md` is missing from the commits** | `.github/modernize/` is gitignored at the repo root. The agent normally `git add -f`'s the summary; if it's missing the agent failed at the summarize phase — check the CLI output for the `summarize_upgrade` step. |
| **Batch fails on one repo** | The CLI continues with remaining repos; check the failed repo's error. Common cause: non-standard project structure, missing `pom.xml`, or no detectable language. |
| **`repos.json` not picked up** | The CLI does **not** auto-detect it. Pass it explicitly: `--source ./.github/modernize/repos.json`. Validate JSON: `cat .github/modernize/repos.json \| python3 -m json.tool`. |
| **`ERROR: 'path' must be an absolute path`** | Full-format `repos[].path` only accepts absolute paths. Use `bash workshop/generate-repos-json.sh` (which uses absolute paths) or build paths with `"$(pwd)/workshop-apps/..."`. |
| **`url: file://...` causes `git clone` failure** | `repos[].url` is treated as a remote and cloned. Use `repos[].path` (absolute) for local sources instead. |
| **Batch upgraded one repo but skipped Spring Boot on another** | Multi-repository mode applies a minimum-change strategy per repo. To force the SB upgrade everywhere, pin the floor: `modernize upgrade "Java 21, Spring Boot 3.5" --source ...`. |

---

## Stretch Goal

Try the **interactive TUI (Text User Interface)** mode:

```bash
modernize
```

Running `modernize` without arguments launches an interactive terminal UI
where you can browse assessments, plans, and tasks visually — all from
the terminal.
