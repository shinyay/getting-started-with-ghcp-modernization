# Contributing

Thank you for your interest in improving this workshop repository!

## Types of Contributions

- **Documentation fixes**: Typos, clarifications, broken links
- **Lab improvements**: Better instructions, additional checkpoints, troubleshooting tips
- **App enhancements**: Bug fixes, additional demo patterns, new applications
- **Knowledge base updates**: Accuracy checks against official docs, new topics

## How to Contribute

1. Fork the repository
2. Create a branch (`git checkout -b fix/description`)
3. Make your changes
4. Test: run `mvn clean package` in any modified Java app (or `dotnet build` for .NET)
5. Submit a Pull Request

## Style Guidelines

- **Markdown**: Use GitHub-flavored markdown with `> [!NOTE]` and `> [!IMPORTANT]` callouts
- **Labs**: Follow the existing pattern (Learning Objectives → Pre-Lab Checklist → Step-by-Step → Checkpoints → What Just Happened → Troubleshooting → Stretch Goal)
- **Code**: Follow existing naming/style conventions in each app
- **Commits**: Use [conventional commits](https://www.conventionalcommits.org/) (`fix:`, `feat:`, `docs:`, `chore:`)

## Lab Authoring Style

These conventions apply to every file under `workshop/lab*.md`.

### Section structure

Follow the canonical 7-section pattern:

1. Learning Objectives
2. Pre-Lab Checklist
3. Step-by-Step Instructions
4. Checkpoints Summary (table)
5. What Just Happened
6. Troubleshooting (table)
7. Stretch Goal

A `See also` section linking to closely-related labs/docs may follow the Stretch Goal.

> **Documented exception**: `lab6-bring-your-own.md` is an explicitly bespoke "open lab" format and may diverge from the 7-section pattern; new bespoke labs require a similar exception note here.

### Front-matter

Every lab MUST include in its detail table:

- `Verified With` — pinned tool/extension versions and ISO date (e.g. `modernize CLI v0.0.293+ + claude-sonnet-4.6, 2026-04-25`).

Every lab SHOULD include above the table:

- A `> 📚 **Reference docs for this lab:**` callout linking to the most relevant `docs/` pages.

### Step header casing

Use **sentence case** for step headers (e.g. *"Open the project in VS Code"*, not *"Open The Project In VS Code"*). Match the casing of surrounding lab content.

### Version examples

Avoid hardcoding specific patch versions where the agent resolves "latest GA" at runtime. Prefer phrasing like *"the latest Spring Boot 3.x GA at runtime (verified 2026-04-25: 3.5.x)"*. The same applies to .NET TFM examples.

### Brittle line references

Do not reference template/skill files by line number. Instruct readers to use `grep -n` so the lab survives template edits.

### Callout glyph cheat-sheet

| Glyph | Meaning |
|-------|---------|
| ⚠️ | Warning — destructive or risky action |
| 🐛 | Known bug or limitation in tooling |
| 💡 | Tip or shortcut |
| 📝 | Note (informational) |
| ℹ️ | Info / context |
| ⏱ | Timing / duration hint |
| 📂 | File or directory pointer |
| 📚 | Reference docs callout |

## Reporting Issues

Use GitHub Issues with the provided templates for bugs and feature requests.

## Questions?

Open a [Discussion](https://github.com/shinyay/getting-started-with-ghcp-modernization/discussions) or file an issue.
