#!/bin/bash
# Generates .github/modernize/repos.json with correct local paths
# Usage: bash workshop/generate-repos-json.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p .github/modernize

cat > .github/modernize/repos.json << EOF
[
  {
    "name": "BookStore",
    "url": "file://${REPO_ROOT}/workshop-apps/bookstore-app"
  },
  {
    "name": "NotesApp",
    "url": "file://${REPO_ROOT}/workshop-apps/notes-app"
  },
  {
    "name": "InventoryAPI",
    "url": "file://${REPO_ROOT}/workshop-apps/stub-repos/inventory-api"
  },
  {
    "name": "OrderService",
    "url": "file://${REPO_ROOT}/workshop-apps/stub-repos/order-service"
  }
]
EOF

echo "✅ Created .github/modernize/repos.json with paths relative to: ${REPO_ROOT}"
cat .github/modernize/repos.json
