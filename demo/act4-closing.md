# Act 4: "Scale & Standardize" — Custom Skills Teaser + Closing

> **Duration**: 7 minutes (48:00–55:00)  
> **Mode**: Narration + brief file show (NO live execution)
>
> **Verified With**: `claude-sonnet-4.6` + `modernize` CLI v0.0.293+ + GitHub Copilot App Modernization for Java, 2026-04-25

---

## Minute 48:00–51:00 — Custom Skills Teaser (3 min)

Open the pre-cloned NewsFeedSite repo and navigate to the SKILL.md:

```
NewsFeedSite/.github/skills/rabbitmq-to-azureservicebus/SKILL.md
```

**Show the file structure:**
```
.github/skills/
└── rabbitmq-to-azureservicebus/
    └── SKILL.md
```

**Show the SKILL.md content** — highlight the YAML frontmatter:
```yaml
---
name: rabbitmq-to-azureservicebus
description: Migrate from RabbitMQ to Azure Service Bus for messaging.
---
```

**Then briefly scroll through** the body: step-by-step instructions, code examples, API reference.

> "Everything I showed you today used **predefined tasks** — Microsoft's best-practice patterns for common migration scenarios."
>
> "But what about **your organization's** patterns? What about that internal library you use, or that specific migration path unique to your stack?"
>
> "**Custom Skills** let you capture any migration pattern as a `SKILL.md` file — following the open [Agent Skills specification](https://agentskills.io/specification)."
>
> "This example encodes a migration pattern from RabbitMQ to Azure Service Bus, using an organization-specific SDK. You store it in git, share it across teams, and the agent **auto-detects** relevant skills when creating modernization plans."
>
> "Every successful migration becomes a reusable pattern. The knowledge compounds over time."

---

## Minute 51:00–52:00 — Scale Message (1 min)

> "Everything I showed in the IDE today works for **one app at a time**."
>
> "But remember that portfolio assessment from the beginning? The **Modernize CLI** can also batch-upgrade — running the same upgrade across multiple repos simultaneously."

```bash
# Assess the whole portfolio (v0.0.293+: --source replaces the deprecated --multi-repo)
modernize assess --source ./.github/modernize/repos.json

# Upgrade everything to Java 21 — Java upgrade auto-commits each task
modernize upgrade "Java 21" --delegate cloud
```

> "That `--delegate cloud` flag? It sends each upgrade to a **Cloud Coding Agent** that runs in parallel. Your entire portfolio — upgraded simultaneously, with PRs created automatically for review."

---

## Minute 52:00–53:30 — Recap (1.5 min)

> "Let's recap the journey we took today:"
>
> "**Discover** — We assessed an entire portfolio with the Modernize CLI. In minutes, we had a complete map: which apps need upgrades, which have security issues, what Azure services to target, and in what order to tackle them."
>
> "**Modernize** — We upgraded a legacy app from Java 8 to 21 and Spring Boot 2.7 to 3. We hardened another app by migrating hardcoded secrets to Azure Key Vault with Managed Identity. Both followed the same **Assess → Plan → Execute** workflow."
>
> "**Scale** — Custom Skills let you capture your organization's patterns. The Modernize CLI runs them across your entire portfolio. Cloud Coding Agents parallelize the execution."
>
> "And throughout all of this — **humans remain in the loop**. Every change is transparent, reviewable, and committed to git."

---

## Minute 53:30–55:00 — Call to Action (1.5 min)

> "If you want to try this yourself:"
>
> "**Step 1**: You need a **GitHub Copilot subscription** — any plan works, including the free tier."
>
> "**Step 2**: Install the **VS Code extension** that matches your stack — for Java search 'GitHub Copilot App Modernization for Java' (ID `vscjava.migrate-java-to-azure`), and for .NET install the corresponding 'GitHub Copilot App Modernization for .NET' extension. Both are GA today."
>
> "**Step 3**: Point it at your own Java or .NET application and type `@modernize`."
>
> "**Step 4**: For enterprise scale, install the **Modernize CLI** from [github.com/microsoft/modernize-cli](https://github.com/microsoft/modernize-cli)."

### Resource Links

| Resource | URL |
|----------|-----|
| Documentation | [learn.microsoft.com/...github-copilot-app-modernization](https://learn.microsoft.com/en-us/azure/developer/github-copilot-app-modernization/) |
| Java Guide | [learn.microsoft.com/...java](https://learn.microsoft.com/en-us/azure/developer/java/migration/migrate-github-copilot-app-modernization-for-java) |
| Sample App | [github.com/Azure-Samples/PhotoAlbum-Java](https://github.com/Azure-Samples/PhotoAlbum-Java) |
| Modernize CLI | [github.com/microsoft/modernize-cli](https://github.com/microsoft/modernize-cli) |
| Agent Skills Spec | [agentskills.io](https://agentskills.io/specification) |

---

## Minute 55:00 — Q&A Transition

> "I'll take questions now."

*(See `presenter-guide.md` for common Q&A answers.)*

---

## Preparation Checklist

- [ ] NewsFeedSite pre-cloned (`git clone https://github.com/Azure-Samples/NewsFeedSite.git`)
- [ ] SKILL.md path memorized: `.github/skills/rabbitmq-to-azureservicebus/SKILL.md`
- [ ] Resource links ready to share (chat, slide, or document)
