# Presenter Guide — GitHub Copilot Modernization Demo (60 min)

> **Single-page master reference.** Each act has its own detailed file in `demo/`.
> This guide provides timing, transitions, audience talking points, and recovery strategies.

---

## 1. Minute-by-Minute Timing Table

| Time | Act / Scenario | Mode | Key File | Key Action |
|---|---|---|---|---|
| 00:00–01:00 | **Act 1 — Opening** | Narration | — | Welcome, introduce the modernization pain point |
| 01:00–03:00 | Act 1 — The Problem Hook | Live | `pom.xml`, `Photo.java`, `application.properties` | Show Spring Boot 2.7 EOL, Java 1.8, `javax.*` imports, hardcoded password |
| 03:00–05:00 | Act 1 — The Promise | Narration | — | Introduce Assess → Plan → Execute workflow; preview the 3-act journey |
| 05:00–06:00 | **Act 2 — CLI Walkthrough** | Walkthrough | `repos.json` | Show portfolio input file with 3 sample apps |
| 06:00–09:00 | Act 2 — Assessment Dashboard | Walkthrough | `cli-assessment-report.md` | Walk through dashboard: 3 apps, 47 issues, effort breakdown |
| 09:00–11:00 | Act 2 — Azure Mapping & Waves | Walkthrough | `cli-assessment-report.md` | Show Azure service mapping, migration waves (Quick Win → Core → Major) |
| 11:00–13:00 | Act 2 — Assessment Matrix | Walkthrough | `cli-assessment-report.md` | Recap per-app summary; highlight Wave 2 (PhotoAlbum) as the next live demo |
| 13:00–15:00 | **Act 3a — Scenario 1: Upgrade** | Live | Terminal | Create `modernize` branch; invoke `@modernize upgrade to Java 21 and Spring Boot 3` |
| 15:00–20:00 | Act 3a — Assessment Phase | Live | `plan.md` (generated) | Agent scans codebase and produces upgrade plan — narrate as it runs |
| 20:00–28:00 | Act 3a — Execution Phase | Live | `pom.xml`, `Photo.java`, `application.properties` | Narrate changes: version bumps, `javax.*` → `jakarta.*`, config updates |
| 28:00–33:00 | Act 3a — Review & Talking Points | Live | Git diff | Walk through git history; discuss OpenRewrite + AI judgment calls |
| 33:00–37:00 | **Act 3b — Scenario 2: Secrets** | Live | `application.properties`, `ExternalApiConfig.java`, `NotificationService.java` | Switch to Task Tracker; walk through 3 hardcoded secret locations |
| 37:00–39:00 | Act 3b — Invoke Predefined Task | Live | Terminal | Create `migrate-secrets` branch; run "Secrets → Azure Key Vault" predefined task |
| 39:00–44:00 | Act 3b — Migration Phase | Live | `pom.xml`, config files, Java sources | Narrate: Azure deps added, secrets → Key Vault refs, Managed Identity auth |
| 44:00–48:00 | Act 3b — Review & Talking Points | Live | Git diff | Walk through diffs; compliance messaging; transition to Act 4 |
| 48:00–50:00 | **Act 4 — Closing** | Narration | `SKILL.md` | Open NewsFeedSite custom skill; explain Agent Skills specification |
| 50:00–52:00 | Act 4 — Batch & Cloud Agents | Narration | — | Show batch upgrade command: `modernize upgrade "Java 21" --delegate cloud` |
| 52:00–55:00 | Act 4 — Recap & Call to Action | Narration | — | Recap Discover → Modernize → Scale; share resource links |
| 55:00–60:00 | **Buffer** | — | — | Overflow, audience Q&A, or wrap-up |

### Timing Variants

**30-Minute Abbreviated Version:**

| Time | Act | Content |
|------|-----|---------|
| 00:00–03:00 | Act 1 (shortened) | Quick problem hook — show 2 files |
| 03:00–05:00 | Act 2 (skip) | Brief mention of CLI capabilities |
| 05:00–22:00 | Act 3a | Version upgrade — LIVE (full 17 min) |
| 22:00–28:00 | Act 4 (shortened) | Quick recap + call to action |
| 28:00–30:00 | Buffer | Q&A |

**90-Minute Extended Version (with .NET + deep Q&A):**
Add Act 3c (.NET Upgrade, 10 min) between Acts 3b and 4. Expand Act 2 to 12 min (deeper CLI exploration). Expand Buffer to 15 min for extended Q&A.

---

## 2. Narrative Arc Summary

The demo follows a **Discover → Modernize → Scale** arc.

We start with **Discover** (Acts 1–2): the audience feels the pain of legacy Java apps — EOL frameworks, hardcoded secrets, `javax` namespaces — and then sees how the Modernize CLI can assess an entire portfolio in seconds, producing a prioritised wave plan.

Next comes **Modernize** (Act 3): two live scenarios prove the agent works. Scenario 1 (version upgrade) tackles the most common ask — jumping from Java 8 / Spring Boot 2 to Java 21 / Spring Boot 3. Scenario 2 (secrets migration) shows a compliance-driven task that resonates with security-conscious audiences.

We close with **Scale** (Act 4): custom skills and batch operations show that the approach isn't a one-off trick — it's an enterprise-grade workflow that can be standardised across hundreds of apps via reusable skills and cloud-delegated agents.

This order is intentional: audiences need to *believe* the tool works (live demos) before they'll care about scaling it.

---

## 3. Transition Scripts

### Act 1 → Act 2 (Problem → Discovery)

> "So we've seen the problem up close — one app, three files, and already a multi-week project.
> Now imagine you have *dozens* of apps like this. Where do you even start?
> That's exactly what the Modernize CLI answers. Let me show you how it assesses an entire portfolio and builds a prioritised migration plan."

### Act 2 → Act 3a (Discovery → Upgrade)

> "The CLI told us PhotoAlbum-Java is a Wave 2 candidate — medium effort, high value.
> Let's stop talking about plans and actually *do* it. I'm going to open this app in VS Code and let Copilot upgrade it from Java 8 and Spring Boot 2.7 to Java 21 and Spring Boot 3 — live, right now."

### Act 3a → Act 3b (Upgrade → Secrets)

> "That was a framework upgrade — the kind of change that touches every file.
> But modernization isn't just about versions. Security teams care about *what's in the code* — and right now, our Task Tracker app has database passwords and API keys sitting in plain text.
> Let's fix that. I'll switch to the Task Tracker and have Copilot migrate every secret to Azure Key Vault."

### Act 3b → Act 4 (Secrets → Scale)

> "Two apps down. But enterprises don't modernize two apps — they modernize two *hundred*.
> The real question is: how do you take what we just did and turn it into a repeatable, organisation-wide standard?
> That's where custom skills and batch operations come in."

---

## 4. Value Propositions — Developer vs Manager

| Area | Developer | Manager |
|---|---|---|
| **Speed** | "I can upgrade a Spring Boot app in 20 minutes instead of 2 weeks." | "Our migration backlog shrinks from quarters to weeks." |
| **Quality** | "The agent handles the tedious namespace and config changes so I can focus on business logic." | "Fewer human errors in repetitive refactoring means fewer production incidents." |
| **Control** | "I review every change in a git diff before merging — nothing is auto-deployed." | "Every change is traceable through git history with clear commit messages." |
| **Compliance** | "Secrets are migrated to Key Vault with Managed Identity — no passwords to rotate." | "We can demonstrate to auditors that no secrets exist in source code." |
| **Scale** | "Custom skills let me encode our team's patterns once and reuse them across projects." | "We standardise modernization across the org instead of every team reinventing the wheel." |
| **Cost** | "I spend my time on features, not mechanical refactoring." | "One Copilot subscription replaces weeks of contractor effort per app." |

---

## 5. Common Audience Q&A

**Q1: What frameworks and languages does this support?**
A: Today GitHub Copilot modernization supports **Java and .NET** — both Generally Available. Java support covers Spring Boot, Jakarta EE, and Maven/Gradle projects. .NET support covers ASP.NET Core, Blazor, WPF, WinForms, Azure Functions, and .NET Framework upgrades. The `@modernize-dotnet` agent works in Visual Studio, VS Code, Copilot CLI, and GitHub.com. Today's demo focuses on Java, but the workflow is the same for .NET.

**Q2: Does Copilot store or train on my code?**
A: No. Code sent to Copilot for Business/Enterprise is not retained or used to train models. Your prompts and code context are discarded after the response is generated; check the Copilot Trust Centre for the latest data-handling details.

**Q3: What if the upgrade breaks something?**
A: The agent works on a branch, so your main branch is never touched. You review every change via git diff, run your test suite, and merge only when you're satisfied. The fallback files in this demo repo show the expected diffs so you can compare.

**Q4: Can we create custom skills for our own org patterns?**
A: Absolutely. The Agent Skills specification is open and file-based — you write a `SKILL.md` that describes the pattern, and Copilot uses it as context. We showed a RabbitMQ-to-Azure-Service-Bus skill in Act 4 as an example.

**Q5: How do we test after an upgrade?**
A: The same way you test any code change — run your existing test suite. The agent doesn't skip tests; in fact, it often updates test dependencies and configuration as part of the upgrade. We recommend running `mvn verify` on the branch before merging.

**Q6: How does this compare to doing it manually?**
A: A manual Spring Boot 2→3 upgrade typically takes 2–4 weeks per app, including namespace migration, dependency resolution, and config changes. The agent completes the mechanical work in minutes; you spend your time reviewing and testing rather than find-and-replacing.

**Q7: What does Copilot licensing look like?**
A: GitHub Copilot is available in Individual, Business, and Enterprise tiers. The Modernize extension and CLI are included — no separate licence. Check github.com/features/copilot for current pricing.

**Q8: Does this work for .NET applications?**
A: Yes — GitHub Copilot modernization supports both Java and .NET. The .NET agent (`@modernize-dotnet`) works in Visual Studio, VS Code, Copilot CLI, and on GitHub.com. It supports upgrading from .NET Framework to modern .NET, ASP.NET Core, Blazor, WPF, WinForms, and Azure Functions. Today's demo focuses on Java, but the workflow is the same.

**Q9: Can we integrate this into CI/CD pipelines?**
A: The Modernize CLI is designed for exactly that. You can run assessments and batch upgrades in a CI pipeline, generate reports, and even open pull requests automatically. The `--delegate cloud` flag offloads execution to cloud agents for parallelism.

**Q10: How does this scale to hundreds of apps?**
A: Three mechanisms: (1) the CLI assesses your entire portfolio from a `repos.json` manifest and produces a prioritised wave plan, (2) batch commands like `modernize upgrade "Java 21" --delegate cloud` process multiple repos in parallel, and (3) custom skills encode your org's patterns so every upgrade follows the same standard.

---

## 5b. Extended Demo Timing Variant (70 min — with .NET scenario)

Insert **Act 3c** (10 min .NET walkthrough) between Act 3b and Act 4. Reduce buffer from 5 min to 0 min. Best for mixed Java/.NET audiences.

| Time | Act | Duration | Notes |
|------|-----|----------|-------|
| 48:00–58:00 | **Act 3c: .NET Upgrade** | 10 min | Show DotnetSampleApp + `@modernize-dotnet` + comparison table |
| 58:00–65:00 | Act 4: Closing | 7 min | Same as standard |
| 65:00–70:00 | Buffer / Q&A | 5 min | |

See [`demo/act3c-scenario3-dotnet-upgrade.md`](act3c-scenario3-dotnet-upgrade.md) for the full script.

---

## 6. Recovery Strategies

| Scenario | Trigger | Action | Recovery Line |
|---|---|---|---|
| **Agent stalls** | Copilot spinner runs >90 seconds with no output | Click **Stop** in the Chat panel, wait 5 seconds, re-invoke the same prompt | *"AI agents are probabilistic — sometimes they need a fresh start. Let me re-run this."* |
| **Agent asks for confirmation** | Agent pauses and prompts "Should I proceed?" or similar | Click **Continue** or type `yes` | *"The agent is being cautious here — it wants confirmation before making changes. That's a feature, not a bug."* |
| **Build failure after upgrade** | `mvn verify` fails after agent completes | Show the error, explain this is a normal part of the review cycle, open the corresponding `fallback/` diff | *"This is exactly why we work on a branch. Let's look at the expected output and compare."* |
| **Network issues** | Copilot returns a connection error or timeout | Switch to the pre-generated `fallback/` files and narrate the expected changes | *"Looks like the network is having a moment. Let me show you the expected output — this is what the agent would produce."* |
| **Model unavailable** | Copilot returns a capacity or model error | Wait 15 seconds and retry once; if still failing, switch to fallback files | *"The model is temporarily at capacity. Let me walk you through the expected result instead."* |

---

## 7. Pre-Demo Checklist

1. **VS Code** installed (v1.106 or later) and launched
2. **Extensions** installed and enabled:
   - GitHub Copilot
   - GitHub Copilot Chat
   - GitHub Copilot Modernization (preview)
3. **Java 21 JDK** installed and `java --version` returns 21+
4. **Maven 3.8+** installed and `mvn --version` returns 3.8+
5. **Git** installed and configured with your GitHub credentials
6. **GitHub Copilot authenticated** — Copilot icon in VS Code status bar shows active (not "Sign in")
7. **PhotoAlbum-Java** repository cloned and opens cleanly in VS Code
8. **Task Tracker app** built successfully — run `cd demo-apps/task-tracker-app && mvn compile -q` to verify
9. **NewsFeedSite** repository cloned (for Act 4 custom skill demo)
10. **Maven caches warmed** — run `mvn dependency:resolve -q` in both PhotoAlbum-Java and Task Tracker to avoid download delays during live demo
11. **VS Code settings applied** (see §8 Display Settings below):
    - `chat.tools.autoApprove: true`
    - `chat.agent.maxRequests: 128`
    - `editor.fontSize: 16`
    - `terminal.integrated.fontSize: 16`
12. **Copilot code-referencing** — "Suggestions matching public code" set to **Allow** in Copilot settings
13. **Fallback files accessible** — verify `demo/fallback/` contains `cli-assessment-report.md`, `scenario1-expected-diff.md`, `scenario2-expected-diff.md`
14. **Screen sharing / projector** verified — code is readable from the back of the room (minimum 16pt font)
15. **Timer visible** — phone timer, browser tab, or presenter display showing elapsed time

---

## 8. Display Settings

Apply these VS Code settings before the demo for readability on projectors and shared screens:

```json
{
    "editor.fontSize": 16,
    "terminal.integrated.fontSize": 16,
    "chat.tools.autoApprove": true,
    "chat.agent.maxRequests": 128
}
```

**Additional tips:**
- Use a **light** or **high-contrast** VS Code theme if the projector washes out dark themes
- **Zoom the Chat panel** with `Ctrl + =` if the audience can't read agent output
- **Collapse the sidebar** (`Ctrl + B`) during live demos to maximise the editor and terminal area
- Set `"editor.minimap.enabled": false` to reclaim horizontal space
