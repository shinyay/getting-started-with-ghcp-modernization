# Instructor Guide — GitHub Copilot Modernization Workshop

## 1. Before the Workshop

- Send prerequisites checklist **1 week ahead** (link to `workshop/setup.sh`)
- Verify your own environment works end-to-end
- Have fallback plans for each lab (pre-generated outputs)
- Set up a shared chat/channel for participant questions

## 2. Introduction Block (30 min) — What to Cover

- What is GitHub Copilot modernization (2 min pitch)
- Assess → Plan → Execute workflow diagram
- Two layers: IDE for developers, CLI for architects
- Quick show: open the VS Code extension, show the TASKS panel
- Set expectations: "AI is non-deterministic — your output may differ from your neighbor's"

## 3. Lab-by-Lab Instructor Notes

### Lab 1: Version Upgrade (50 min)

- **What to say before**: "This lab upgrades a real Spring Boot 2.7 app to 3.x with Java 21. Focus on the workflow, not just the result."
- **What to watch for**: participants stuck on confirmation prompts (remind about auto-approve), slow Maven downloads (should be cached from setup.sh), javax→jakarta not fully migrated
- **Common mistakes**: forgetting to create branch, trying to run upgraded app (H2 should still work)
- **Fast participants**: suggest reviewing git log, trying to revert one change, examining the generated plan

### Lab 2: CLI Assessment (45 min)

- **What to say before**: "Now let's zoom out from one app to a whole portfolio. The CLI gives you the architect's view."
- **What to watch for**: repos.json path issues (absolute vs relative), CLI not installed, gh auth not configured
- **Common mistakes**: wrong paths in repos.json, running from wrong directory
- **Fast participants**: try interactive TUI mode (`modernize`), explore the HTML report

### Lab 3: Custom Skills (30 min)

- **What to say before**: "Everything so far used built-in capabilities. Custom skills let you encode YOUR organization's patterns."
- **What to watch for**: SKILL.md name field with spaces (must use hyphens), skill not appearing in My Skills (click Refresh), template copy issues
- **Common mistakes**: invalid YAML frontmatter, referencing wrong test file paths
- **Fast participants**: try adding a second migration pattern to the skill, create a completely new skill from scratch

### Lab 4: Predefined Task (50 min, full-day)

- **What to say before**: "This app works fine — but it's not cloud-ready. File logging doesn't survive container restarts."
- **What to watch for**: predefined task not visible (ensure NotesApp directory is open), logback changes breaking app startup
- **Common mistakes**: not stopping the app before running the task, looking at wrong log files
- **Fast participants**: browse other predefined tasks, try applying a second task

### Lab 5: CLI Execute (50 min, full-day)

- **What to say before**: "You've used the IDE and the CLI for assessment. Now let's use the CLI to actually execute an upgrade."
- **What to watch for**: BookStore needs to be reset to original state (main branch), batch mode repos.json conflicts with lab2's repos.json
- **Common mistakes**: running on already-upgraded BookStore, path issues in repos.json
- **Fast participants**: try `--delegate cloud` (requires CCA setup), compare output with Lab 1

### Lab 6: Bring Your Own (40 min, full-day)

- **What to say before**: "This is your chance to try it on YOUR code. Start small — just an assessment first."
- **What to watch for**: participants with non-Java projects, projects too large for session time, build tool issues (Gradle Kotlin DSL not supported)
- **When to intervene**: if participant is stuck for >5 min on the same error, if assessment produces no useful output, if participant has no project (offer NewsFeedSite)
- **Managing expectations**: "Not every app will migrate cleanly in 40 minutes — the goal is to experience the workflow and understand what's possible"

### Lab 7: .NET Upgrade (50 min, optional)

- **What to say before**: "Same Assess→Plan→Execute workflow you saw in Lab 1, applied to a .NET 6 → .NET 10 upgrade. Useful contrast for polyglot teams."
- **What to watch for**: missing `dotnet` SDK (**.NET 10 SDK required** to target `net10.0`; SDK 8 cannot rebuild the upgraded project), the .NET extension creating its own `dotnet-version-upgrade-N` branch, IDE artifacts landing in `.github/upgrades/{scenarioId}/` (not `.github/modernize/`)
- **Common mistakes**: confusing the Java IDE artifact path with the .NET one, expecting the CLI and IDE surfaces to share the same workflow
- **Fast participants**: try the same upgrade via the CLI (`modernize plan execute`) and compare commit history; cross-reference with Lab 1 to see Java/.NET differences

## 4. Tooling versions to call out

When introducing each lab, briefly mention the pinned tooling baseline so participants can interpret deviations correctly:

- **VS Code extension**: `GitHub Copilot app modernization` v0.0.293+ (Insiders for predefined tasks)
- **modernize CLI**: v0.0.293+
- **Underlying model**: `claude-sonnet-4.6`
- Each lab's front-matter `Verified With` row pins the exact date the lab was last validated. Tell participants: *"Your output may differ — both because AI is non-deterministic AND because tool versions move. The Verified-With date tells you when the lab was last known-good."*

## 5. Handling Common Situations

- **Fast participants**: Direct them to stretch goals in each lab
- **Slow participants**: Skip stretch goals, focus on checkpoint 3 (build passes)
- **AI produces different output**: Expected! Explain non-determinism. Compare interesting differences.
- **Network issues**: Have fallback assets from `demo/fallback/` available
- **Copilot rate limiting**: Reduce `chat.agent.maxRequests`, wait 1-2 minutes between labs

## 6. Closing Discussion Points (Full-Day)

- What surprised you about the modernization agent?
- Where did it work well vs. where did it need help?
- How would you apply this to your real portfolio?
- What custom skills would your organization need?
