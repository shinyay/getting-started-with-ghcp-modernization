# Lab 7: .NET Upgrade — .NET 6.0 → .NET 10

| Detail | Value |
|--------|-------|
| **Duration** | 50 minutes |
| **Application** | DotnetSampleApp (`workshop-apps/dotnet-sample-app/`) |
| **Difficulty** | Beginner (for .NET developers) |
| **Format** | Full-day only (optional) |

---

## Learning Objectives

By the end of this lab you will be able to:

- **Understand the `@modernize-dotnet` agent** and its three-stage Assessment → Planning → Execution workflow.
- **Upgrade a .NET 6.0 application to .NET 10** using VS Code or Visual Studio, with the agent handling API changes, dependency updates, and configuration migrations.
- **Review the generated `.github/upgrades/` artifacts** (assessment.md, plan.md, tasks.md) to understand exactly what was changed and why.

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
| Artifact location | `.github/modernize/` | `.github/upgrades/` |
| IDE support | VS Code, IntelliJ | VS, VS Code, CLI, GitHub.com |
| Upgrade tool | OpenRewrite + AI | AI-powered transformation |

The agent generates three markdown files under `.github/upgrades/{scenarioId}/`:
- **`assessment.md`** — What needs to change
- **`plan.md`** — How to change it
- **`tasks.md`** — Step-by-step execution with status tracking

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

### Step 8 — Verify with Checkpoint 1

Check that upgrade artifacts were generated:

```bash
ls .github/upgrades/
```

✅ **Expected:** A directory containing `assessment.md`, `plan.md`, `tasks.md`.

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

> **📝 Comparison with Lab 1:** The workflow is identical to the Java upgrade in Lab 1: Assess → Plan → Execute. The key difference is the agent name (`@modernize-dotnet` vs `@modernize`) and the artifact location (`.github/upgrades/` vs `.github/modernize/`).

---

## Checkpoints Summary

| # | Check | Command | Expected |
|---|-------|---------|----------|
| 1 | Upgrade artifacts exist | `ls .github/upgrades/` | Directory with assessment.md, plan.md, tasks.md |
| 2 | Target framework updated | `grep "TargetFramework" *.csproj` | `net10.0` |
| 3 | Build passes | `dotnet build` | `Build succeeded` |

---

## What Just Happened?

The `@modernize-dotnet` agent followed the same **Assess → Plan → Execute** workflow as the Java `@modernize` agent:

1. **Assessment** — Analyzed your project structure, NuGet packages, and API usage to identify breaking changes between .NET 6.0 and .NET 10.
2. **Planning** — Generated a structured plan with upgrade strategies, dependency paths, and risk mitigations.
3. **Execution** — Applied changes (target framework, package versions, API fixes) and committed each step to git for full traceability.

The key .NET-specific differences:
- Artifacts are stored under `.github/upgrades/{scenarioId}/` (not `.github/modernize/`)
- The three-stage files (`assessment.md`, `plan.md`, `tasks.md`) serve as review checkpoints
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
| **`.github/upgrades/` not created** | The agent creates this directory during execution. If it's missing, the agent may not have reached the execution phase. |

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
