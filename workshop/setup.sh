#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

check_pass() {
  echo -e "  ${GREEN}✅ $1${NC}"
  PASS=$((PASS + 1))
}

check_fail() {
  echo -e "  ${RED}❌ $1${NC}"
  FAIL=$((FAIL + 1))
}

check_warn() {
  echo -e "  ${YELLOW}⚠️  $1${NC}"
}

echo ""
echo "🎓 GitHub Copilot Modernization Workshop — Setup"
echo "================================================="
echo ""
echo "Checking prerequisites..."
echo ""

# Java 21+ (required for Lab 1's *post-upgrade* build of bookstore-app on
# Java 21; pre-upgrade exercises only need the source compatibility level
# pinned in each app's pom.xml. Recommended baseline is JDK 21+.)
if command -v java &>/dev/null; then
  JAVA_VER=$(java -version 2>&1 | head -1 | sed -E 's/.*"([0-9]+).*/\1/')
  if [ "$JAVA_VER" -ge 21 ] 2>/dev/null; then
    check_pass "Java $JAVA_VER (need 21+ for post-upgrade builds)"
  elif [ "$JAVA_VER" -ge 17 ] 2>/dev/null; then
    check_warn "Java $JAVA_VER (works for pre-upgrade exercises; install 21+ before Lab 1's final build)"
  else
    check_fail "Java $JAVA_VER found (need 17+ minimum, 21+ recommended)"
  fi
else
  check_fail "Java not found (need 21+ recommended)"
fi

# Maven 3.8+
if command -v mvn &>/dev/null; then
  MVN_VER=$(mvn -version 2>&1 | head -1 | sed -E 's/.*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
  MVN_MAJOR=$(echo "$MVN_VER" | cut -d. -f1)
  MVN_MINOR=$(echo "$MVN_VER" | cut -d. -f2)
  if [ "$MVN_MAJOR" -ge 4 ] 2>/dev/null || { [ "$MVN_MAJOR" -eq 3 ] && [ "$MVN_MINOR" -ge 8 ]; } 2>/dev/null; then
    check_pass "Maven $MVN_VER (need 3.8+)"
  else
    check_fail "Maven $MVN_VER found (need 3.8+)"
  fi
else
  check_fail "Maven not found (need 3.8+)"
fi

# Git
if command -v git &>/dev/null; then
  GIT_VER=$(git --version 2>&1 | sed -E 's/git version //')
  check_pass "Git $GIT_VER"
else
  check_fail "Git not found"
fi

# VS Code
if command -v code &>/dev/null; then
  VSCODE_VER=$(code --version 2>&1 | head -1)
  check_pass "VS Code $VSCODE_VER"
else
  check_fail "VS Code not found"
fi

# VS Code extensions
# NOTE: The Java modernization extension is published as
# 'vscjava.migrate-java-to-azure' per the marketplace listing and
# docs/02. Earlier internal builds used the 'microsoft.' publisher
# prefix. We accept either prefix to tolerate both publication
# channels until the publisher question is settled (setup-004).
if command -v code &>/dev/null; then
  EXTENSIONS=$(code --list-extensions 2>/dev/null || true)
  for ext in "GitHub.copilot" "GitHub.copilot-chat"; do
    if echo "$EXTENSIONS" | grep -qi "$ext" 2>/dev/null; then
      check_pass "VS Code extension: $ext"
    else
      check_fail "VS Code extension: $ext not found"
    fi
  done
  if echo "$EXTENSIONS" | grep -qiE "(vscjava|microsoft)\.migrate-java-to-azure" 2>/dev/null; then
    check_pass "VS Code extension: migrate-java-to-azure"
  else
    check_fail "VS Code extension: migrate-java-to-azure not found (try 'vscjava.migrate-java-to-azure')"
  fi
else
  check_fail "Cannot check VS Code extensions (VS Code not found)"
fi

# modernize CLI (REQUIRED for Labs 2 and 5)
if command -v modernize &>/dev/null; then
  MOD_VER=$(modernize --version 2>&1 | head -1)
  check_pass "modernize CLI: $MOD_VER"
else
  check_fail "modernize CLI not found (REQUIRED for Labs 2 and 5 — see docs/04 for installation)"
fi

# gh auth status (optional)
if command -v gh &>/dev/null; then
  if gh auth status &>/dev/null; then
    check_pass "GitHub CLI authenticated"
  else
    check_warn "GitHub CLI not authenticated (optional — run 'gh auth login')"
  fi
else
  check_warn "GitHub CLI not found (optional)"
fi

echo ""
echo "Building workshop apps..."
echo ""

# bookstore-app
if (cd "$REPO_ROOT/workshop-apps/bookstore-app" && mvn clean package -q 2>/dev/null); then
  check_pass "bookstore-app builds successfully"
else
  check_fail "bookstore-app build failed"
fi

# notes-app
if (cd "$REPO_ROOT/workshop-apps/notes-app" && mvn clean package -q 2>/dev/null); then
  check_pass "notes-app builds successfully"
else
  check_fail "notes-app build failed"
fi

# stub-repos/inventory-api
if (cd "$REPO_ROOT/workshop-apps/stub-repos/inventory-api" && mvn compile -q 2>/dev/null); then
  check_pass "inventory-api compiles successfully"
else
  check_fail "inventory-api compile failed"
fi

# stub-repos/order-service
if (cd "$REPO_ROOT/workshop-apps/stub-repos/order-service" && mvn compile -q 2>/dev/null); then
  check_pass "order-service compiles successfully"
else
  check_fail "order-service compile failed"
fi

# dotnet-sample-app (Lab 7) — only if dotnet SDK is available
if command -v dotnet &>/dev/null; then
  if (cd "$REPO_ROOT/workshop-apps/dotnet-sample-app" && dotnet build -v q --nologo 2>/dev/null); then
    check_pass "dotnet-sample-app builds successfully"
  else
    check_fail "dotnet-sample-app build failed"
  fi
else
  check_warn "dotnet SDK not found — Lab 7 (.NET upgrade) will be unavailable"
fi

echo ""
echo "Warming Maven caches..."
(cd "$REPO_ROOT/workshop-apps/bookstore-app" && mvn dependency:go-offline -q 2>/dev/null) || true
(cd "$REPO_ROOT/workshop-apps/notes-app" && mvn dependency:go-offline -q 2>/dev/null) || true
echo -e "  ${GREEN}✅ Maven caches warmed${NC}"

echo ""
echo "================================================="
TOTAL=$((PASS + FAIL))
echo -e "Results: ${GREEN}${PASS} passed${NC} / ${RED}${FAIL} failed${NC} (out of $TOTAL checks)"
echo ""

if [ "$FAIL" -eq 0 ]; then
  echo -e "${GREEN}✅ Setup complete! You're ready for the workshop.${NC}"
else
  echo -e "${RED}❌ Some checks failed. Please resolve the issues above before the workshop.${NC}"
fi
echo ""
