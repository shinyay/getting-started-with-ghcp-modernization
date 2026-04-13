# Custom Skills — Reusable Migration Patterns

## Overview

Custom skills are the **organizational knowledge capture** mechanism of GitHub Copilot modernization. They enable teams to define organization-specific migration patterns, internal library usage, and coding standards as **reusable, shareable skills** that can be applied consistently across projects and teams.

## Why Custom Skills?

| Use Case | Example |
|----------|---------|
| Internal library migrations | Switching to org-specific SDKs or frameworks |
| Migration pattern reuse | Capturing successful migration patterns from one project for others |
| Coding standards enforcement | Ensuring consistent patterns across teams |
| Knowledge accumulation | Each successful migration expands the knowledge base |
| Custom task extensions | Copying and modifying Microsoft predefined tasks |

## Agent Skills Specification

Custom skills follow the [Agent Skills specification](https://agentskills.io/specification).

### Directory Structure

```
.github/skills/
└── my-migration-pattern/
    ├── SKILL.md          # Required: metadata + instructions
    ├── scripts/          # Optional: executable code
    ├── references/       # Optional: documentation
    ├── assets/           # Optional: templates, resources
    └── ...               # Any additional files
```

### SKILL.md Format

The `SKILL.md` file consists of **YAML frontmatter** + **Markdown body**:

```markdown
---
name: my-migration-pattern
description: A concrete description of what this skill helps migrate
---

## Overview

Description of the migration scenario.

## Steps

1. Step-by-step instructions for the agent
2. ...

## Sample Code

### Before
```java
// Original code
```

### After
```java
// Migrated code
```

## Verification Checks

- Build succeeds
- Tests pass
- No deprecated API usage remains
```

### YAML Frontmatter Fields

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | ✅ | Max 64 chars. Lowercase letters, numbers, hyphens only. Must match parent directory name. No consecutive hyphens. |
| `description` | ✅ | Max 1024 chars. Describes what the skill does and **when to use it**. Critical for auto-detection. |
| `license` | ❌ | License name or reference to bundled file |
| `compatibility` | ❌ | Max 500 chars. Environment requirements |
| `metadata` | ❌ | Arbitrary key-value mapping |
| `allowed-tools` | ❌ | Space-separated pre-approved tools (experimental) |

### Description Quality Matters!

The `description` field is **critical** — the agent uses it to determine when to apply the skill.

| Quality | Example |
|---------|---------|
| ✅ Good | "Migrate from RabbitMQ with AMQP to Azure Service Bus for messaging" |
| ✅ Good | "Replace direct JDBC calls with Spring Data repositories" |
| ❌ Bad | "Messaging migration" (too vague) |
| ❌ Bad | "Update libraries" (not specific) |
| ❌ Bad | "Improve code" (unclear goal) |

## Creating Custom Skills

### Method 1: Via VS Code Extension UI

1. Open **GitHub Copilot modernization** extension pane
2. Hover over **TASKS** section → **Create a Custom Skill**
3. Fill in: Skill Name, Skill Description, Skill Content
4. **Add Resources** → select files or folders for reference knowledge
5. **Save** → appears in **My Skills** section

### Method 2: Manual File Creation

```bash
# Step 1: Create directory
mkdir -p .github/skills/my-migration-pattern

# Step 2: Create SKILL.md
cat > .github/skills/my-migration-pattern/SKILL.md << 'EOF'
---
name: my-migration-pattern
description: Migrate from RabbitMQ to Azure Service Bus for Spring Boot applications
---

# Migration Guide

## Overview
This skill guides the migration from RabbitMQ to Azure Service Bus...

## Steps
1. Replace RabbitMQ dependencies with Azure Service Bus SDK
2. Update connection configuration
3. Convert message producers
4. Convert message consumers
5. Update error handling patterns

## Code Examples
...
EOF
```

### Method 3: Copy and Customize Microsoft Tasks

1. In **TASKS** section, right-click a Microsoft predefined task
2. Select **Copy to My Skills**
3. Edit the name, description, content, and resources
4. Save

## Applying Custom Skills

### Automatic Detection

When creating a modernization plan, the agent **automatically**:
1. Scans `.github/skills/` for custom skills
2. Compares migration prompt with skill descriptions
3. Incorporates relevant skills into the plan
4. Uses skills to guide code transformations

```bash
# Agent auto-detects and uses the RabbitMQ skill
modernize plan create "migrate from rabbitmq to azure service bus"
```

### IDE: Run Skill Manually

1. Open `SKILL.md` → click **Run** button
2. Or find skill in **My Skills** → **Run Skill**
3. Agent Mode activates and executes the skill workflow

### Verification

Check `.github/modernization/{plan-name}/tasks.json` for skill references:
```json
"skills": [
  {
    "name": "your-skill-name",
    "location": "project"
  }
]
```

## Sharing Custom Skills

### Share with team
1. Copy skill folder from `.github/skills/`
2. Share with recipient
3. Recipient places folder under `.github/skills/` in their project
4. Click **Refresh** in extension pane

### Version control
Since skills live in `.github/skills/` within your repository, they are naturally version-controlled with Git.

## Resource Files

Resources provide reference knowledge for the agent:

- **Files**: Individual migration instructions, configuration examples, git commit diffs
- **Folders**: All files within a folder as resources

### Resource Linking

Resources must be explicitly referenced in `SKILL.md`:
```markdown
**Resources:**
- file:///references.txt
- file:///guide.md
```

### Progressive Disclosure
- **Metadata** (~100 tokens): `name` and `description` loaded at startup
- **Instructions** (< 5000 tokens recommended): Full `SKILL.md` body loaded when activated
- **Resources** (as needed): Files loaded only when required

### Best Practices
- Keep `SKILL.md` under 500 lines
- Move detailed reference material to separate files
- Keep file references one level deep
- Reference files by name in the Skill Content field

## Git Commit Diffs as Resources

One powerful pattern: convert **Git commits** from previously migrated applications into reusable skill resources:

1. Export the diff from a successful migration commit
2. Add it as a resource file in the skill
3. Reference it in `SKILL.md` as a migration guide

This enables the agent to learn from real-world migrations and apply proven patterns.

## Managing Custom Skills

### Update a Skill
- Right-click in **My Skills** → **Edit**

### Delete a Skill
- Right-click in **My Skills** → **Delete**

## Storage Locations

| Type | Location |
|------|----------|
| Predefined (Microsoft) tasks | `~/.vscode/extensions/microsoft.migrate-java-to-azure-*/rag` |
| Custom skills (project) | `.github/skills/` in your project |
| Legacy custom tasks (migrated) | Previously `.github/appmod/custom-tasks/` → now `.github/skills/` |

## Sample Repository

[NewsFeedSite](https://github.com/Azure-Samples/NewsFeedSite) includes:
- Custom skill for RabbitMQ → Azure Service Bus
- Internal JDK library usage example
- Proper skill structure and formatting

```bash
git clone https://github.com/Azure-Samples/NewsFeedSite.git
cd NewsFeedSite
ls -la .github/skills/
modernize plan create "migrate from rabbitmq to azure service bus"
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Skill not detected | Check `name` has no spaces (use hyphens), verify `description` matches prompt, check YAML syntax |
| Skill not in UI | Ensure `SKILL.md` exists at `.github/skills/{name}/SKILL.md`, click **Refresh** |
| Resources not visible | Add link entries in `SKILL.md` under Resources section |
| Skill doesn't apply correctly | Make description more specific, make prompt more specific |
