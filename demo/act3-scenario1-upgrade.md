# Act 3a: Version Upgrade — LIVE Demo

> **Duration**: 20 minutes (13:00–33:00)  
> **Mode**: ⚡ LIVE demo  
> **App**: [PhotoAlbum-Java](https://github.com/Azure-Samples/PhotoAlbum-Java) — Spring Boot 2.7.18 + Java 8 + Oracle DB  
> **Fallback**: [fallback/scenario1-expected-diff.md](fallback/scenario1-expected-diff.md)

---

## Minute 13:00–16:00 — Before State (3 min)

PhotoAlbum-Java should already be open from Act 1. Quick recap for context:

### Show `pom.xml`
```xml
<version>2.7.18</version>     <!-- Spring Boot EOL -->
<java.version>1.8</java.version> <!-- Legacy Java -->
```

### Show `Photo.java` — the javax imports
```java
import javax.persistence.*;            // → will become jakarta
import javax.validation.constraints.*; // → will become jakarta
```

### Create migration branch
```bash
cd PhotoAlbum-Java
git checkout -b modernize
```

> "Here's our photo gallery app. Spring Boot 2.7 on Java 8. The model class uses `javax.persistence` for JPA — these will all need to become `jakarta`. The Oracle JDBC driver needs upgrading. Dozens of files, hundreds of individual changes."
>
> "Let's see how long this takes with Copilot modernization."

---

## Minute 16:00–17:00 — Invoke Modernization (1 min)

Open **Copilot Chat** (Ctrl+Shift+I / Cmd+Shift+I):

```
@modernize upgrade to Java 21 and Spring Boot 3
```

> "One line. That's it. Let's watch what happens."

---

## Minute 17:00–20:00 — Assessment Phase (3 min)

Narrate while Copilot works:

> "The agent is now scanning the entire codebase — analyzing `pom.xml` dependencies, finding `javax` imports across all Java files, checking for deprecated APIs, evaluating Spring Boot 3.x breaking changes."

**When `plan.md` appears**, open it and highlight:
- List of javax→jakarta changes needed (affected files)
- Dependency updates required (Spring Boot, Oracle JDBC, commons-io)
- Any breaking changes detected
- Ordered task list with success criteria

> "This plan is a **Markdown file** — it's fully editable. You can review it, modify steps, add context, even remove tasks you don't want. The human is always in control."
>
> "Let's approve it and proceed."

---

## Minute 20:00–21:00 — Approve the Plan (1 min)

Type **"continue"** or **"yes"** in the chat.

> "Now the agent is executing the plan. It uses a combination of **OpenRewrite** — an open-source deterministic transformation engine — for the systematic changes, and **AI** for the edge cases that need judgment."

---

## Minute 21:00–28:00 — Execution Phase (7 min)

**This is the core visual spectacle.** Narrate changes as they happen:

### pom.xml changes
> "Watch the pom.xml — Java version just changed from 1.8 to 21... Spring Boot parent is now 3.x... Oracle JDBC driver updated..."

### Namespace migration
> "Now it's migrating the javax imports — Photo.java, the controller, the repository... `javax.persistence` becomes `jakarta.persistence` across every file."

### Configuration changes
> "Configuration is being updated too — Hibernate dialect, Spring Boot 3.x property formats..."

### Git commits
> "Notice — every transformation step creates a **git commit**. Fully auditable. Fully reversible."

**If the agent pauses for confirmation**, type **"continue"**.

**If the agent encounters a build error**, narrate:
> "The agent just hit a compilation error — and now it's analyzing the cause and applying a fix. This is part of the workflow — it doesn't just transform code, it validates the build and fixes issues."

---

## Minute 28:00–31:00 — Review Results (3 min)

```bash
git --no-pager log --oneline
git --no-pager diff main --stat
```

Walk through the highlights:

> "In just a few minutes, the agent upgraded the entire application."
>
> "Let's look at the results:"

**Highlight in the diff:**
1. `pom.xml` — Java version, Spring Boot version, dependency updates
2. Java source files — `javax.*` → `jakarta.*` across model, controller, repository
3. Configuration — property updates for Spring Boot 3.x
4. Git history — individual commits for each transformation step

---

## Minute 31:00–33:00 — Talking Points + Transition (2 min)

### For Developers
> "OpenRewrite handles the deterministic transforms — namespace changes, known API replacements — with AST-level precision. The AI handles the judgment calls — deprecated APIs where there's no 1:1 mapping, configuration nuances."

### For Managers
> "Copilot compresses assessment, planning, and first-pass remediation from **weeks of manual analysis into minutes** — with humans reviewing and validating every change. And every change is traceable through git history for compliance."

### Transition to Scenario 2
> "That was a framework upgrade — the 'technical debt' story. Now let me show you a different kind of modernization — **security**."
>
> "I have another app — a modern Spring Boot 3.2 API. It builds, tests pass, everything works. But it has a critical problem..."

---

## Fallback Plan

**Trigger**: If the agent shows no visible progress for 5+ minutes.

**Recovery**:
1. Say: *"While the agent works on this, let me show you what the output looks like from a previous successful run."*
2. Open `demo/fallback/scenario1-expected-diff.md`
3. Walk through the pre-generated diffs
4. If the agent finishes in the background, switch back: *"And it looks like the agent just finished — let's see the actual results."*

---

## Preparation Checklist

- [ ] PhotoAlbum-Java cloned and Maven cache warmed
- [ ] On `main` branch, ready to `git checkout -b modernize`
- [ ] Copilot Chat accessible
- [ ] Fallback file accessible if needed
- [ ] Timer visible to track against 20-minute budget
