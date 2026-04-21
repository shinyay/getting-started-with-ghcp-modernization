#!/bin/bash
# Generates .github/modernize/repos.json for the workshop apps using the
# Full-format manifest schema (`repos[].path`).
#
# Why `path` and not `url: file://...`?
#   The modernize CLI (v0.0.293) treats every `url` as a Git remote and
#   runs `git clone <url>` on it. The workshop apps live as plain
#   subdirectories of this repo (NOT independent git repos), so a
#   `file://` URL fails with:
#       fatal: '...workshop-apps/bookstore-app' does not appear to be a
#       git repository
#   The `path` field tells the CLI to use the directory in place — no
#   clone is attempted.
#
# Usage: bash workshop/generate-repos-json.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p .github/modernize

cat > .github/modernize/repos.json << EOF
{
  "repos": [
    {
      "name": "bookstore-app",
      "path": "${REPO_ROOT}/workshop-apps/bookstore-app",
      "description": "Spring Boot 2.7 / Java 11 storefront — upgrade target"
    },
    {
      "name": "notes-app",
      "path": "${REPO_ROOT}/workshop-apps/notes-app",
      "description": "Spring Boot 3.2 / Java 17 notes service"
    },
    {
      "name": "inventory-api",
      "path": "${REPO_ROOT}/workshop-apps/stub-repos/inventory-api",
      "description": "Spring Boot 2.7 / Java 8 inventory stub"
    },
    {
      "name": "order-service",
      "path": "${REPO_ROOT}/workshop-apps/stub-repos/order-service",
      "description": "Spring Boot 3.1 / Java 17 order stub"
    }
  ]
}
EOF

echo "✅ Created .github/modernize/repos.json with absolute paths under: ${REPO_ROOT}"
cat .github/modernize/repos.json
