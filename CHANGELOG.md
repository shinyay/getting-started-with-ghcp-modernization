# Changelog

All notable changes to this repository are documented in this file.

## [Unreleased]

### Fixed
- 6 broken internal markdown links surfaced by a cross-cutting audit (Phase 7A): `workshop/agenda.md` and `docs/08-workshop-preparation.md` used absolute `/docs/...` / `/workshop/...` paths that break on GitHub render; `workshop/templates/pre-workshop-email.md` used a relative depth that did not account for the file living one level deeper than other workshop docs; `workshop/lab4-predefined-task.md` (×2) and `workshop/lab5-cli-execute.md` linked to the non-existent `docs/05-modernization-cli-task-execution.md` (correct file is `docs/05-batch-operations.md`).

### Changed
- Reframed `docs/examples/SKILL.md.example` header (Phase 7B): now positioned as the **finished/reference** state of the JUnit 4 → JUnit 5 skill, complementary to (not competing with) the **starter** template at `workshop/templates/junit4-to-junit5-skill/SKILL.md`. Both files now cross-link, and `docs/06-custom-skills.md` callout explains the two-file relationship.
- Completed Tested-With/Verified-With stamp coverage on the 6 remaining files that lacked it: `workshop/agenda.md` plus `demo/act{1-opening,2-cli-walkthrough,3-scenario1-upgrade,3-scenario2-secrets,4-closing}.md` (Phase 5 had stamped only 3 of the 8 demo files).
- Tightened the canonical extension name across `docs/02-ide-experience-java.md` (link text) and `docs/08-workshop-preparation.md` (3 occurrences): "Copilot modernization extension" → "Copilot App Modernization for Java extension" to match the marketplace title used elsewhere in the repo.
- README repository structure list (line 225) now includes the 5th `docs/examples/` file (`SKILL.md.example`, shipped in 1.2.0).

## [1.2.0] — 2026-04-25

> **Release theme**: Workshop labs deep review (75 findings closed across Phases 1-3) + top-level docs refresh (Phase 4) + demo scripts refresh (Phase 5) + final polish on `demo/fallback/`, `docs/examples/`, and a shipped `SKILL.md.example` reference (Phase 6). All edits are surface-level alignment with the live `modernize` CLI v0.0.293+ / Copilot CLI 1.0.36+ / `claude-sonnet-4.6` / VS Code 1.106+ baseline as of 2026-04-25 — no behavioural changes to scripts, validators, or sample apps.

### Added
- `docs/examples/SKILL.md.example` — shipped reference copy of the Lab 3 JUnit 4 → JUnit 5 custom skill (140 lines, all 5 patterns including the workshop-dry-run Pattern 4 BookStore note + Pattern 5 `@MockitoBean` migration). The repo's `.gitignore` excludes `.github/skills/` so workshop participants generate their own copy during Lab 3 — this reference is what the workshop *would* produce.
- `docs/06-custom-skills.md`: callout under the Directory Structure section pointing at `docs/examples/SKILL.md.example` and explaining the gitignore rationale.

### Changed
- Phase 6A — `demo/fallback/*` refresh:
  - `demo/fallback/cli-assessment-report.md`: replaced the frozen "Generated: 2026-04-12" banner with a "Last refreshed: 2026-04-25" + "Tested With" stamp; flagged the static metrics (47 issues, 4m32s execution time) as illustrative; added cross-links to scenario1/scenario2 fallback files.
  - `demo/fallback/scenario1-expected-diff.md`: added "Last refreshed" + "Tested With" stamps; softened the hard-pinned Spring Boot 3.3.5 with an inline comment noting the agent picks the newest 3.3.x/3.4.x it can resolve.
  - `demo/fallback/scenario2-expected-diff.md`: added "Last refreshed" + "Tested With" stamps. Truth-checked: every secret literal matches `demo-apps/task-tracker-app` byte-for-byte; no content edits needed beyond the stamp.
- Phase 6B — `docs/examples/cli-cookbook.md` refresh:
  - Added a "Last reviewed: 2026-04-25" stamp under the v0.0.293+ banner.
  - Spot-checked all 15 recipes: no residual `--multi-repo`, model IDs current, `#modernize-plan-create` anchor in `docs/04` resolves correctly.
  - Recipe 2 (Portfolio assess from `repos.json`) now spells out that each `repos[]` entry needs one of `url:` (git remote — CLI runs `git clone`) or `path:` (local, **must be absolute**), with a pointer at `workshop/generate-repos-json.sh`, plus a warning that `url: file://...` fails with exit 128.

### Changed
- Demo scripts + workshop ancillary refresh (Phase 5 — surface-only alignment of `demo/` presenter scripts with the post-review repo state):
  - `demo/00-prerequisites.md`: added "Tested With" version stamp; added VS Code Insiders recommendation; promoted the .NET modernization extension to a 4th (optional) row gated on Act 3c; replaced the hard "JDK 21+ required" pin with "JDK 21+ recommended / 17+ acceptable for the read-only walkthrough sections" (no demo step builds the *upgraded* Java code); added a new "Act 3c" block in Section 2 covering .NET SDK 10+, the .NET extension, and the `dotnet-sample-app` build check; added a 9th `dotnet build` verification step in Section 4 gated on `command -v dotnet`.
  - `demo/act2-cli-walkthrough.md`: replaced the deprecated `modernize assess --multi-repo` with `modernize assess --source ./.github/modernize/repos.json` (matching `docs/04` line 124; `--multi-repo` still parses on v0.0.293 but emits a deprecation notice).
  - `demo/act4-closing.md`: same `--multi-repo` → `--source` replacement; clarified the "install the VS Code extension" step to name both Java (`vscjava.migrate-java-to-azure`) and .NET extensions, both now GA.
  - `demo/act3c-scenario3-dotnet-upgrade.md`: added "Verified With" stamp; mirrored Lab 7's "Roslyn analyzers + AI-driven transforms (no OpenRewrite-style recipe engine)" wording in the Java vs .NET comparison table; added a `🔧 Pre-requisite` callout pointing at the new Section 2 Act 3c block in `00-prerequisites.md`.
  - `demo/presenter-guide.md`: added "Verified With" stamp; reconciled the conflicting `90-Minute Extended` blurb in §1 with the canonical `70-Minute Extended` table in §5b (Act 3c is 10 min); refreshed §7 Pre-Demo Checklist to label both Java and .NET modernization extensions as **GA** (the previous "(preview)" label was obsolete) and softened the JDK 21 pin to match the rest of the docs.
  - `workshop/instructor-guide.md`: tightened the Lab 7 SDK watch-for note from ".NET 10 SDK preview required" to ".NET 10 SDK required to target `net10.0`; SDK 8 cannot rebuild the upgraded project" (matches Lab 7's Pre-Lab clarification).
  - `workshop/templates/pre-workshop-email.md`: rebased the Format line to "Half-day (3.5 hours) / Full-day (6h30m core + 50 min optional Lab 7)"; tightened the .NET section to "**.NET SDK 10+ required** (SDK 8 cannot target `net10.0`)"; loosened "for .NET Lab participants (full-day only, Lab 7)" to "(optional Lab 7 add-on)".
  - `README.md`: corrected a Phase-4 self-error — Demo Act 3c is a 10-minute walkthrough, not 15. Updated the Quick Start act list, the Demo Guides table, and the Repository Structure tree comment.

### Changed
- Top-level docs refresh (Phase 4 — README & cross-cutting docs alignment after the workshop labs deep review):
  - `README.md`: header bullets corrected (`6→7` presenter scripts, `8→10` knowledge base docs, `1→2` setup scripts; added a "7 hands-on workshop labs" bullet); replaced the stale "workshop is currently Java-only" NOTE with a Lab 7 / Demo Act 3c acknowledgement; rebased Two-Formats table to "6h30m core + 50min optional Lab 7"; added a top-level "Tested With" version stamp (`modernize v0.0.293+` · `Copilot CLI 1.0.36+` · `claude-sonnet-4.6` · VS Code 1.106+ Insiders, verified 2026-04-25); refreshed the Prerequisites table (added `modernize` CLI as REQUIRED, `dotnet` SDK 10+ for Lab 7, Copilot CLI 1.0.36+; softened Java to "JDK 21+ recommended / 17+ acceptable except Lab 1 post-upgrade"); added Demo Act 3c rows to both the Quick Start act list and the Demo Guides table; added `docs/09` and `docs/10` rows plus a pointer to `docs/examples/` to the Knowledge Base table; refreshed the Repository Structure tree to include `CHANGELOG.md`, `CONTRIBUTING.md`, `LICENSE`, `.github/` (workflows, ISSUE_TEMPLATE, skills, modernize, java-upgrade), `demo/act3c`, `workshop/lab7`, `workshop/generate-repos-json.sh`, `workshop/templates/pre-workshop-email.md`, `docs/09`, `docs/10`, and `docs/examples/`.
  - `docs/08-workshop-preparation.md`: replaced the stale "demo scripts and workshop labs are currently Java-only" NOTE with a Lab 7 / Act 3c / `dotnet-sample-app` acknowledgement.
  - `CONTRIBUTING.md`: How-to-Contribute step 3 now references the Lab Authoring Style section; step 4 also runs `bash workshop/validate.sh lab{2,3,4,5}` for any `workshop/` change.

### Changed
- Workshop labs deep review (Phase 2 — Live verification & high-impact fixes): an additional ~22 of 75 review findings addressed across 4 commits, all live-verified against `modernize` CLI v0.0.293 + Copilot CLI 1.0.36 + `claude-sonnet-4.6` on 2026-04-25.
  - Lab 1 / `docs/07`: corrected Java IDE chat-handler artifact path. The pattern is `.github/java-upgrade/{yyyyMMddHHmmss}/` (14-digit timestamp), not `{yyyyMMdd}-bks-{NNN}`. Added a 📂 path-note distinguishing the three Java output paths (IDE chat handler, IDE predefined-tasks panel, CLI) and expanded the docs/07 "Artifact Output Locations" section accordingly.
  - Lab 2: removed the stale `plan create --no-tty` indefinite-hang callout (the issue is no longer reproducible on v0.0.293 — it now exits cleanly in 30-60s); kept the defensive `timeout 600` wrapper guidance. Expanded the `tasks.json` schema description from 5 to the 8 actually-emitted fields plus the top-level `metadata` block.
  - Lab 5: refreshed `Verified-With` to pin Copilot CLI 1.0.36 (was 1.0.10) with explicit 2026-04-25 date stamp.
  - `setup.sh`: relaxed Java check (warn at JDK 17-20, fail only below 17 — only Lab 1's *post-upgrade* build strictly requires JDK 21+); promoted `modernize` CLI from optional to required; accept both `vscjava.` and `microsoft.` extension publisher prefixes; added a guarded `dotnet build` of `dotnet-sample-app` for Lab 7.
  - `validate.sh`: replaced Lab 7's manual-instructions stub with three real automated checks (TFM upgraded to net8.0+, `dotnet build` succeeds, upgrade artifacts present); updated the usage banner to include lab6/lab7; dropped the legacy repo-root plan.md fallback for Lab 2.
  - `templates/pre-workshop-email.md`: recommended VS Code Insiders, added the `modernize` CLI install step, renamed the Java extension to its current marketplace name, and tightened the .NET prerequisites.

### Changed
- Workshop labs deep review (Phase 3 — Cleanup): the remaining 23 of 75 review findings closed in a single commit. All edits are content/structure refinements; no IDE re-verification was needed because behavior was already confirmed during Lab 1-7 dry-runs.
  - Lab 1 / 4: small ergonomics fixes (`cd` context for `git checkout`, Pre-Lab `cd ../..` back to repo root, `git log --branches=` instead of glob-on-refspec, Checkpoints Summary table replaces three H2 sub-sections, `Background` H2 merges `Why This Matters` + `The Problem`).
  - Lab 5: `Phase B` H2 retitled "Phase B (Optional Extension)" with an explicit "continues Steps 8-12" note; removed the duplicate Step 7 IDE/CLI mini-table; clarified that `--no-tty` is for CI/log piping, not a stall fix.
  - Lab 6: replaced Step 5 Option B pseudo-comment scaffolding with four executable commands (assessment grep → plan create → cat plan/tasks → plan execute); renamed "Instructor Help" to "Troubleshooting (Instructor Help)" and de-duplicated the "CLI may not exit" callout.
  - Lab 7: `dotnet --version` Pre-Lab now correctly distinguishes SDK 10 (required for `net10.0`) from SDK 8 (insufficient); `Upgrade tool` background row softened from "OpenRewrite + AI" to "Roslyn analyzers + AI-driven transforms" (no OpenRewrite-style recipe engine); `Target framework didn't change` troubleshooting now splits IDE (assessment.md) vs CLI (inline plan.md) guidance; minor table-cell wrapping with `<br>`.
  - `validate.sh`: `lab1` case grew a check for the `.github/java-upgrade/{yyyyMMddHHmmss}/` artifact dir to validate the Step 9 / Checkpoint 1 claim. Three checks total preserved (1 new, 2 combined).

### Status
- **All 75 review findings now closed** (Phase 1: 24, Phase 2: 28, Phase 3: 23). `bash workshop/validate.sh lab{2,3,4,5}` → 3/3; `lab1` → 2/3 in pre-IDE-run state (expected); `lab7` → 1/3 in pre-upgrade baseline (expected).

### Changed (Phase 1 — Quick Wins, 2026-04-25)
- Workshop labs deep review (Phase 1 — Quick Wins): 24 of 75 review findings addressed across 6 commits.
  - Lab 3 / Lab 5: removed Japanese-language prompt leak and replaced destructive `git clean -fd` reset with safer `git stash --include-untracked` (with documented destructive alternative).
  - Lab 1 / 2 / 3 / 6 / 7: added `Verified With` front-matter row + `📚 Reference docs for this lab` callout for parity with Labs 4 / 5; Lab 4 / 5 also got the Reference-docs callout.
  - Lab 1 / 3 / 5 + `validate.sh`: replaced hardcoded patch versions with date-stamped phrasing; replaced brittle `around lines 65/69` references with `grep -n TODO` instructions; added full FQCN for `@MockitoBean`.
  - `instructor-guide.md`: added Lab 7 instructor section + a "Tooling versions to call out" subsection pinning the verified extension/CLI/model baseline.
  - `agenda.md`: clarified Java vs .NET note and rebased Full-Day header to "6h30m core + 50min optional Lab 7".
  - Lab 1 / 4 / 5 / 7: added reciprocal `See also` cross-links closing the IDE↔CLI and Java↔.NET asymmetries.
  - `CONTRIBUTING.md`: codified the Lab Authoring Style (canonical 7-section structure with documented Lab 6 exception, required Verified-With, sentence-case step headers, version-stamp convention, callout glyph cheat-sheet).

## [1.1.0] — 2026-04-14

### Added
- .NET sample application (`workshop-apps/dotnet-sample-app/`) — ASP.NET Core 6.0 with intentional secrets
- Workshop Lab 7: .NET 6→10 upgrade using `@modernize-dotnet`
- Demo Act 3c: Optional .NET walkthrough for mixed audiences
- FAQ & Troubleshooting knowledge base doc (`docs/09-faq-and-troubleshooting.md`)
- CI/CD integration examples in CLI reference
- GitHub Actions CI workflow (`.github/workflows/ci.yml`)
- Lab 2 helper script (`workshop/generate-repos-json.sh`)
- Example CLI configurations (`docs/examples/`)
- MIT LICENSE file
- CONTRIBUTING.md and issue templates
- Last-reviewed dates on all knowledge base docs

### Fixed
- Presenter guide Q1: .NET is GA, not "on the roadmap"
- demo/setup.sh: broken Task Tracker build path (`$DEMO_DIR` → `$PARENT_DIR`)
- docs/06: `.github/modernization/` typo → `.github/modernize/`
- docs/01: JDK 25 clarified as source-only (upgrade target max JDK 21)
- Lab 3: removed non-standard `version`/`triggers` YAML frontmatter
- Lab 5: repos.json path corrected to `.github/modernize/repos.json`
- Lab 1/3 dependency: added JUnit 4 reset instructions
- Instructor guide: intro duration 20min → 30min (matches agenda)
- README: scope claims aligned with actual Java-focused content

### Changed
- README tagline softened to reflect actual repo scope
- docs/08 workshop agendas labeled as alternative suggestions
- Workshop apps table updated with DotnetSampleApp
- CLI reference: added `plan create` and `plan execute` options tables
- Cloud delegation prerequisites added to batch operations doc
- Model name clarification (IDE: Sonnet 4.5 vs CLI: 4.6)

## [1.0.0] — 2026-04-13

### Added
- 60-minute demo with 4 acts (Opening, CLI Walkthrough, Version Upgrade, Secrets Migration, Closing)
- 6 workshop labs (Version Upgrade, CLI Assessment, Custom Skills, Predefined Task, CLI Execute, BYO)
- 8 knowledge base documents covering the full GitHub Copilot modernization platform
- 5 sample Java applications (task-tracker, bookstore, notes, inventory-api, order-service)
- Pre-demo and workshop setup scripts with validation
- Fallback materials for demo resilience
- JUnit 4→5 custom skill template
