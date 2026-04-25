# Lab 7: .NET Upgrade — .NET 6.0 → .NET 10

> 📚 **Reference docs for this lab:**
> - **[IDE experience — .NET](../docs/03-ide-experience-dotnet.md)** — `.NET Upgrade` extension flow and artifact paths.
> - **[Key concepts and comparison](../docs/07-key-concepts-and-comparison.md)** — how Java and .NET surfaces compare.

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | DotnetSampleApp (`workshop-apps/dotnet-sample-app/`) |
| **Difficulty** | Beginner (for .NET developers) |
| **Format** | Full-day only (optional) |
| **Verified With** | .NET Upgrade Assistant extension + modernize CLI v0.0.293+, 2026-04-25 |

---

## Learning Objectives

By the end of this lab you will be able to:

- **Understand the `@modernize-dotnet` agent** and its three-stage Assessment → Planning → Execution workflow.
- **Upgrade a .NET 6.0 application to .NET 10** using VS Code or Visual Studio, with the agent handling API changes, dependency updates, and configuration migrations.
- **Review the generated `.github/upgrades/` artifacts** (assessment.md, plan.md, tasks.md) when running in the IDE — or `.github/modernize/{plan-name}/plan.md` + `tasks.json` when running via the CLI — to understand exactly what was changed and why.

---

## Pre-Lab Checklist

Before you begin, confirm every item below:

- [ ] The **.NET SDK** (latest version) is installed:
  ```bash
  dotnet --version
  ```
  ✅ Expected: A version number (e.g., `10.x.x` or `8.x.x`)

- [ ] You have one of the following IDEs:
  - **VS Code** with GitHub Copilot + `@modernize-dotnet` extension
  - **Visual Studio 2026** (or VS 2022 v17.14.17+) with GitHub Copilot

- [ ] The **DotnetSampleApp** builds successfully:
  ```bash
  cd workshop-apps/dotnet-sample-app
  dotnet build
  ```
  ✅ Expected: `Build succeeded`

> **Tip:** If the build fails before you start, raise your hand — this must pass before proceeding.

---

## Background

The `.NET modernization agent` (`@modernize-dotnet`) follows the same **Assess → Plan → Execute** workflow as the Java `@modernize` agent, but with .NET-specific tooling:

| Aspect | Java (`@modernize`) | .NET (`@modernize-dotnet`) |
|--------|---------------------|---------------------------|
| Agent name | `@modernize` | `@modernize-dotnet` |
| Artifact location (IDE) | `.github/modernize/` | `.github/upgrades/` |
| Artifact location (CLI) | `.github/modernize/` | `.github/modernize/` *(same as Java)* |
| IDE support | VS Code, IntelliJ | VS, VS Code, CLI, GitHub.com |
| Upgrade tool | OpenRewrite + AI | AI-powered transformation |

In the IDE, the agent generates three markdown files under `.github/upgrades/{scenarioId}/`:
- **`assessment.md`** — What needs to change
- **`plan.md`** — How to change it
- **`tasks.md`** — Step-by-step execution with status tracking

> **CLI users:** the three-file trio is **IDE-only**. The CLI emits
> `plan.md` + `tasks.json` (no `assessment.md`, no `tasks.md`) under
> `.github/modernize/{plan-name}/` — same path as Java.

---

## Step-by-Step Instructions

### Step 1 — Open the project

Open the DotnetSampleApp folder in your IDE:

```bash
code workshop-apps/dotnet-sample-app
```

Make sure the Explorer pane shows `Program.cs` and `DotnetSampleApp.csproj`.

### Step 2 — Examine the "before" state

Open and inspect the following files to understand the starting point:

| File | What to look for |
|------|-----------------|
| `DotnetSampleApp.csproj` | `<TargetFramework>net6.0</TargetFramework>` — the upgrade target |
| `appsettings.json` | Hardcoded `Password=SuperSecret123!` and API keys |
| `Services/NotificationService.cs` | Hardcoded `_apiKey` and `_webhookSecret` fields |

> 📝 **Note:** The .NET version (6.0) is the primary upgrade target. The hardcoded secrets are secondary issues you can address after the upgrade (or in a separate predefined task).

### Step 3 — Create a working branch

Never upgrade directly on `main`:

```bash
git checkout -b upgrade-dotnet
```

### Step 4 — Invoke the .NET modernization agent

**In VS Code:**
1. Open the **Copilot Chat** panel (click the Copilot icon or press `Ctrl+Shift+I`)
2. Type:
```
@modernize-dotnet upgrade to .NET 10
```

**In Visual Studio:**
1. Right-click the solution in **Solution Explorer** → **Modernize**
2. Or open **GitHub Copilot Chat** → type `@Modernize upgrade to .NET 10`

**From the CLI (alternative — if you have `modernize` installed):**

The Modernize CLI also supports .NET upgrades. Two paths exist with **materially different behavior** — read both before choosing:

| Command | Auto-commits? | Three-stage files? | Best for |
|---|---|---|---|
| `modernize upgrade ".NET 10" --source workshop-apps/dotnet-sample-app --language dotnet` | ❌ No (modifies files on disk only) | ❌ Only `plan.md` + `tasks.json` | Quick TFM bump; you commit manually |
| `modernize plan create "upgrade to .NET 10" --source workshop-apps/dotnet-sample-app --language dotnet --plan-name dotnet10-upgrade` then `modernize plan execute --plan-name dotnet10-upgrade --source workshop-apps/dotnet-sample-app --language dotnet` | ✅ Yes (one commit per task on an auto-spawned `dotnet-version-upgrade-N` branch) | ❌ Only `plan.md` + `tasks.json` | Demo-grade flow; matches Java workflow |

Run from the **repository root** (not from inside `dotnet-sample-app`). Verified against `modernize v0.0.293` + `claude-sonnet-4.6` on 2026-04-25.

> ⚠️ **CLI artifact location differs from the IDE.** The CLI writes
> artifacts to **`.github/modernize/{plan-name}/`** (mirroring the Java
> agent), **not** `.github/upgrades/{scenarioId}/` as the IDE does.
> Likewise, the CLI emits only `plan.md` + `tasks.json` — there is **no
> `assessment.md` or `tasks.md`** trio. The three-markdown-file convention
> is IDE-only. Adjust Step 8 / Checkpoint 1 accordingly when you take the
> CLI path.

### Step 5 — Watch the Assessment Phase

The agent scans your project. You'll see:
- Project structure analysis
- Dependency compatibility check
- Breaking change identification
- API compatibility assessment

When `assessment.md` appears, review it. It lists everything that needs attention.

> ⏱ This typically takes 30–60 seconds. **Do not interrupt.**

### Step 6 — Review the Plan

Once assessment completes, the agent generates a **plan** listing:
- Upgrade strategies for each component
- Dependency upgrade paths
- Risk mitigations

**Read through the plan.** This is your chance to understand what will change.

### Step 7 — Approve and Execute

Type `continue` or `yes` to proceed with execution.

The agent will:
- Update `DotnetSampleApp.csproj` target framework
- Update NuGet package versions
- Fix any breaking API changes
- Commit each change to git

> **CLI users:** Behavior depends on which subcommand you used in Step 4.
> `modernize plan execute` auto-commits each task on an auto-spawned
> `dotnet-version-upgrade-N` branch. Direct `modernize upgrade` only
> modifies files on disk — `git status` will show `M *.csproj` and you
> must stage and commit yourself (`git add -A && git commit -m "Upgrade to .NET 10"`).

### Step 8 — Verify with Checkpoint 1

Check that upgrade artifacts were generated:

```bash
# IDE path
ls .github/upgrades/

# CLI path
ls workshop-apps/dotnet-sample-app/.github/modernize/
```

✅ **Expected (IDE):** A `{scenarioId}` directory containing `assessment.md`, `plan.md`, `tasks.md`.
✅ **Expected (CLI):** A `{plan-name}` directory containing `plan.md` and `tasks.json`. (No `assessment.md` / `tasks.md` — those are IDE-only.)

### Step 9 — Verify with Checkpoint 2

Confirm the target framework was updated:

```bash
grep "TargetFramework" DotnetSampleApp.csproj
```

✅ **Expected:** `<TargetFramework>net10.0</TargetFramework>` (or the latest .NET version)

### Step 10 — Verify with Checkpoint 3

Run the full build to confirm everything compiles:

```bash
dotnet build
```

✅ **Expected:** `Build succeeded` with exit code 0.

### Step 11 — Celebrate 🎉

You just upgraded a .NET 6.0 application to .NET 10 — with AI assistance tracking every change in git.

> **📝 Comparison with Lab 1:** The workflow is identical to the Java upgrade in Lab 1: Assess → Plan → Execute. The key differences are the agent name (`@modernize-dotnet` vs `@modernize`) and — when using the IDE — the artifact location (`.github/upgrades/` vs `.github/modernize/`). Via the CLI both languages share `.github/modernize/`.

---

## Checkpoints Summary

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | Upgrade artifacts exist | `ls .github/upgrades/` (IDE) **or** `ls workshop-apps/dotnet-sample-app/.github/modernize/` (CLI) | IDE: `assessment.md` + `plan.md` + `tasks.md`. CLI: `plan.md` + `tasks.json` only. |
| 2 | Target framework updated | `grep "TargetFramework" *.csproj` | `net10.0` |
| 3 | Build passes | `dotnet build` | `Build succeeded` |

---

## What Just Happened?

The `@modernize-dotnet` agent followed the same **Assess → Plan → Execute** workflow as the Java `@modernize` agent:

1. **Assessment** — Analyzed your project structure, NuGet packages, and API usage to identify breaking changes between .NET 6.0 and .NET 10.
2. **Planning** — Generated a structured plan with upgrade strategies, dependency paths, and risk mitigations.
3. **Execution** — Applied changes (target framework, package versions, API fixes) and committed each step to git for full traceability.

The key .NET-specific differences:
- Artifacts are stored under `.github/upgrades/{scenarioId}/` (not `.github/modernize/`) **— IDE only**. The CLI writes to `.github/modernize/{plan-name}/`, same path as Java, with `plan.md` + `tasks.json` only (no `assessment.md` / `tasks.md`).
- The three-stage files (`assessment.md`, `plan.md`, `tasks.md`) serve as review checkpoints — IDE only
- The agent works in Visual Studio, VS Code, GitHub Copilot CLI, and on GitHub.com
- No OpenRewrite equivalent — the agent uses AI-powered code transformation directly

---

## Troubleshooting

| Symptom | Solution |
|---------|----------|
| **`@modernize-dotnet` not recognized** | Ensure you have the GitHub Copilot modernization extension installed. In VS Code, check the Extensions panel. In Visual Studio, check if Copilot is active. |
| **Agent stops after assessment** | Type `continue` or `yes` to proceed. Or enable auto-approve in Copilot settings. |
| **Build fails after upgrade** | Read the error carefully — it usually indicates a NuGet package incompatibility. Ask the agent: `@modernize-dotnet fix the build error`. |
| **Target framework didn't change** | The agent may have found compatibility issues. Review `assessment.md` for blockers. |
| **`.github/upgrades/` not created** | The agent creates this directory during execution. If it's missing, the agent may not have reached the execution phase. **CLI users:** check `workshop-apps/dotnet-sample-app/.github/modernize/{plan-name}/` instead — the CLI uses a different path. |
| **CLI: `git status` shows `M *.csproj` after `modernize upgrade`** | `modernize upgrade --language dotnet` (direct call) does not auto-commit. Either use the `plan create` + `plan execute` chain (which does commit), or commit manually with `git add -A && git commit -m "Upgrade to .NET 10"`. |
| **CLI: orphan branch `dotnet-version-upgrade-N` appears** | The .NET upgrade engineer agent may auto-create this branch. After the run, check `git log --all --oneline` and delete with `git branch -D dotnet-version-upgrade-N` if no commits landed there. |

---

## Stretch Goal

If you finish early, try these:

1. **Review the git history:**
   ```bash
   git log --oneline
   git diff main
   ```

2. **Compare with Lab 1:** How does the .NET upgrade diff compare to the Java upgrade? Which had more changes?

3. **Try a predefined task:** In the Copilot Chat, try:
   ```
   @modernize-dotnet migrate secrets to Azure Key Vault
   ```
   Or via the CLI (verified end-to-end against this app on 2026-04-25):
   ```bash
   modernize plan create "migrate secrets to Azure Key Vault" \
       --source workshop-apps/dotnet-sample-app \
       --language dotnet --plan-name keyvault-migration
   modernize plan execute --plan-name keyvault-migration \
       --source workshop-apps/dotnet-sample-app --language dotnet
   ```
   Expected outcome: 5 secrets in `appsettings.json` + `Services/NotificationService.cs` are removed and replaced with `IConfiguration` lookups; `Program.cs` is wired with `AddAzureKeyVault` + `DefaultAzureCredential`; the built-in `migration-azure-keyvault-secret` skill drives the transformation. Two commits land on an auto-spawned `dotnet-version-upgrade-N` branch.
