# Act 3c: .NET Upgrade — OPTIONAL Demo

> **Duration**: 10 minutes (inserted between Act 3b and Act 4)
> **Mode**: Brief WALKTHROUGH (show artifacts, not full live execution)
> **When to use**: Include this act when your audience has significant .NET representation

---

## Minute 48:00–50:00 — The Story (2 min)

Pick up from the Act 3b transition:

> "Everything we've done so far has been Java — a framework upgrade and a secrets migration."
>
> "But GitHub Copilot modernization supports **.NET equally** — and the workflow is the same. Let me show you."

**Switch VS Code** to the `workshop-apps/dotnet-sample-app/` project.

---

## Minute 50:00–53:00 — Show the .NET Agent (3 min)

### Show the project structure

Open `DotnetSampleApp.csproj` — highlight the target framework:

```xml
<TargetFramework>net6.0</TargetFramework>
```

> ".NET 6.0 — this reached end-of-life in November 2024. Just like Spring Boot 2.7 for Java."

### Show the agent invocation

Open **Copilot Chat** and type (but don't execute):

```
@modernize-dotnet upgrade to .NET 10
```

> "Same pattern as Java — one line in the chat. The agent name is `@modernize-dotnet` instead of `@modernize`, but the workflow is identical."

### Show pre-generated artifacts (if available)

If you've run the agent previously, open the `.github/upgrades/` directory and show:
- `assessment.md` — what the agent found
- `plan.md` — the upgrade strategy
- `tasks.md` — execution steps with status

> "Three markdown files — fully reviewable, fully editable, saved in your repository. Assessment, Plan, Tasks. Same three stages."

---

## Minute 53:00–56:00 — Key Differences from Java (3 min)

> "The workflow is the same, but there are a few platform differences worth noting:"

| Aspect | Java (`@modernize`) | .NET (`@modernize-dotnet`) |
|--------|---------------------|---------------------------|
| Agent name | `@modernize` | `@modernize-dotnet` |
| Artifact location | `.github/modernize/` | `.github/upgrades/` |
| IDE support | VS Code, IntelliJ | **Visual Studio**, VS Code, CLI, GitHub.com |
| Upgrade tool | OpenRewrite + AI | AI-powered transformation |
| Predefined tasks | 13 | 10 |
| Supported types | Spring Boot, Jakarta EE | ASP.NET Core, Blazor, WPF, WinForms, Azure Functions |

> "Notice that .NET has **broader IDE support** — it works in Visual Studio (including right-click → Modernize), VS Code, the Copilot CLI, and even on GitHub.com as a coding agent."
>
> "And it supports upgrading from **.NET Framework to modern .NET** — that's a major migration, not just a version bump."

---

## Minute 56:00–58:00 — Transition to Act 4 (2 min)

> "Same workflow. Same human-in-the-loop philosophy. Different language ecosystem."
>
> "Whether you're modernizing Java or .NET — or both — the Assess → Plan → Execute model is consistent."
>
> "Now let's talk about how you scale this across your entire portfolio..."

---

## Preparation Checklist

- [ ] `workshop-apps/dotnet-sample-app/` open in VS Code
- [ ] `DotnetSampleApp.csproj` tab visible
- [ ] Familiar with the comparison table
- [ ] If showing artifacts: `.github/upgrades/` pre-generated from a prior run (optional)

---

## Fallback

This act is a **walkthrough** — there is no live execution risk. You're showing files and explaining the workflow. If `@modernize-dotnet` isn't available, simply show the project structure and the comparison table while narrating the workflow.
