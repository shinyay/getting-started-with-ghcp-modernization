# Changelog

All notable changes to this repository are documented in this file.

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
