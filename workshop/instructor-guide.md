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

## 4. Handling Common Situations

- **Fast participants**: Direct them to stretch goals in each lab
- **Slow participants**: Skip stretch goals, focus on checkpoint 3 (build passes)
- **AI produces different output**: Expected! Explain non-determinism. Compare interesting differences.
- **Network issues**: Have fallback assets from `demo/fallback/` available
- **Copilot rate limiting**: Reduce `chat.agent.maxRequests`, wait 1-2 minutes between labs

## 5. Closing Discussion Points (Full-Day)

- What surprised you about the modernization agent?
- Where did it work well vs. where did it need help?
- How would you apply this to your real portfolio?
- What custom skills would your organization need?
