#!/bin/bash
# Usage: ./validate.sh lab1|lab2|lab3|lab4|lab5|lab6|lab7

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASSED=0
TOTAL=3

check_pass() {
  echo -e "  ${GREEN}✅ $1${NC}"
  PASSED=$((PASSED + 1))
}

check_fail() {
  echo -e "  ${RED}❌ $1${NC}"
}

usage() {
  echo "Usage: $0 lab1|lab2|lab3|lab4|lab5|lab6|lab7"
  echo ""
  echo "Available labs:"
  echo "  lab1  — BookStore version upgrade (javax → jakarta)"
  echo "  lab2  — CLI assessment & planning"
  echo "  lab3  — Custom skill (JUnit 4 → JUnit 5)"
  echo "  lab4  — NotesApp predefined task (logging)"
  echo "  lab5  — CLI execute (full upgrade)"
  echo "  lab6  — Bring Your Own App (manual validation)"
  echo "  lab7  — .NET upgrade (manual validation)"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

LAB="$1"

echo ""
echo "🔍 Validating $LAB checkpoints..."
echo ""

case "$LAB" in
  lab1)
    # Check 1: Lab 1's IDE chat-handler artifact dir exists with a 14-digit
    # timestamp subdir (e.g. .github/java-upgrade/20260424065029/). The dir
    # is gitignored but kept in the working tree — its presence proves the
    # @modernize-java-upgrade agent ran.
    if ls -d "$REPO_ROOT/workshop-apps/bookstore-app/.github/java-upgrade/"[0-9]*/ 2>/dev/null | grep -q .; then
      check_pass ".github/java-upgrade/{timestamp}/ artifact dir found"
    else
      check_fail "No .github/java-upgrade/{14-digit-timestamp}/ dir under workshop-apps/bookstore-app/ (did you run @modernize-java-upgrade?)"
    fi

    # Check 2: jakarta.persistence imports present
    if grep -r "jakarta.persistence" "$REPO_ROOT/workshop-apps/bookstore-app/src/main/" 2>/dev/null | head -1 | grep -q .; then
      check_pass "jakarta.persistence imports found"
    else
      check_fail "jakarta.persistence imports not found"
    fi

    # Check 3: Build passes (combined: javax removed + build green)
    if ! grep -r "javax.persistence" "$REPO_ROOT/workshop-apps/bookstore-app/src/main/" 2>/dev/null | head -1 | grep -q . \
       && (cd "$REPO_ROOT/workshop-apps/bookstore-app" && mvn clean package -q 2>/dev/null); then
      check_pass "javax.persistence removed AND bookstore-app builds successfully"
    else
      check_fail "Either javax.persistence still present, or bookstore-app build failed"
    fi
    ;;

  lab2)
    # Check 1: Assessment files exist (timestamped reports-{yyyyMMddHHmmss}/index.md)
    if ls "$REPO_ROOT/.github/modernize/assessment/reports-"*/index.md 2>/dev/null | grep -q .; then
      check_pass "Assessment markdown files exist"
    else
      check_fail "No assessment reports found in .github/modernize/assessment/reports-*/index.md (did you pass --format markdown to 'modernize assess'?)"
    fi

    # Check 2: Assessment mentions BookStore or NotesApp
    if grep -l "BookStore\|NotesApp\|bookstore\|notes-app" "$REPO_ROOT/.github/modernize/assessment/reports-"*/index.md 2>/dev/null | grep -q .; then
      check_pass "Assessment references BookStore or NotesApp"
    else
      check_fail "Assessment does not reference BookStore or NotesApp"
    fi

    # Check 3: Plan file exists at the canonical CLI output path.
    # Lab 2 uses --source ./workshop-apps/bookstore-app, which writes to
    # workshop-apps/bookstore-app/.github/modernize/{plan-name}/.
    if ls "$REPO_ROOT/workshop-apps/bookstore-app/.github/modernize/"*/plan.md 2>/dev/null | grep -q .; then
      check_pass "Modernization plan file exists"
    else
      check_fail "No plan.md found in workshop-apps/bookstore-app/.github/modernize/*/"
    fi
    ;;

  lab3)
    # Check 1: Custom skill file exists at repo root
    if test -f "$REPO_ROOT/.github/skills/junit4-to-junit5/SKILL.md"; then
      check_pass "Custom skill SKILL.md exists"
    else
      check_fail "Custom skill SKILL.md not found at .github/skills/junit4-to-junit5/SKILL.md"
    fi

    # Check 2: JUnit 5 imports present in tests
    if grep -r "org.junit.jupiter" "$REPO_ROOT/workshop-apps/bookstore-app/src/test/" 2>/dev/null | head -1 | grep -q .; then
      check_pass "JUnit 5 (org.junit.jupiter) imports found in tests"
    else
      check_fail "JUnit 5 imports not found in tests"
    fi

    # Check 3: Tests pass
    if (cd "$REPO_ROOT/workshop-apps/bookstore-app" && mvn test -q 2>/dev/null); then
      check_pass "bookstore-app tests pass"
    else
      check_fail "bookstore-app tests failed"
    fi
    ;;

  lab4)
    # Check 1: No RollingFileAppender
    if ! grep -q "RollingFileAppender" "$REPO_ROOT/workshop-apps/notes-app/src/main/resources/logback-spring.xml" 2>/dev/null; then
      check_pass "No RollingFileAppender in logback-spring.xml"
    else
      check_fail "RollingFileAppender still present in logback-spring.xml"
    fi

    # Check 2: No Files.write or FileWriter
    if ! grep -rq "Files.write\|FileWriter" "$REPO_ROOT/workshop-apps/notes-app/src/main/java/" 2>/dev/null; then
      check_pass "No Files.write or FileWriter in source code"
    else
      check_fail "Files.write or FileWriter still present in source code"
    fi

    # Check 3: Build passes
    if (cd "$REPO_ROOT/workshop-apps/notes-app" && mvn clean package -q 2>/dev/null); then
      check_pass "notes-app builds successfully"
    else
      check_fail "notes-app build failed"
    fi
    ;;

  lab5)
    # Check 1: jakarta.persistence present (upgraded)
    if grep -r "jakarta.persistence" "$REPO_ROOT/workshop-apps/bookstore-app/src/main/" 2>/dev/null | head -1 | grep -q .; then
      check_pass "jakarta.persistence imports found (upgraded)"
    else
      check_fail "jakarta.persistence imports not found"
    fi

    # Check 2: Commits exist (more than 1)
    COMMIT_COUNT=$(cd "$REPO_ROOT/workshop-apps/bookstore-app" && git log --oneline 2>/dev/null | head -3 | wc -l)
    if [ "$COMMIT_COUNT" -gt 1 ] 2>/dev/null; then
      check_pass "Multiple commits found ($COMMIT_COUNT)"
    else
      check_fail "Expected multiple commits in bookstore-app"
    fi

    # Check 3: Build passes
    if (cd "$REPO_ROOT/workshop-apps/bookstore-app" && mvn clean package -q 2>/dev/null); then
      check_pass "bookstore-app builds successfully"
    else
      check_fail "bookstore-app build failed"
    fi
    ;;

  lab6)
    echo ""
    echo "Lab 6: Bring Your Own App"
    echo "==========================================="
    echo ""
    echo "Lab 6 uses your own project — no automated validation available."
    echo "Manual verification:"
    echo "  1. Check that you're on a 'modernize-workshop' branch"
    echo "  2. Run: git log --oneline | head -5 (should show modernization commits)"
    echo "  3. Run: mvn clean test OR dotnet test (should pass)"
    echo ""
    ;;

  lab7)
    # Check 1: TFM was upgraded (anything other than net6.0 / net7.0)
    CSPROJ="$REPO_ROOT/workshop-apps/dotnet-sample-app/DotnetSampleApp.csproj"
    if [ -f "$CSPROJ" ] && grep -E "<TargetFramework>net(8|9|10)\.0</TargetFramework>" "$CSPROJ" >/dev/null 2>&1; then
      TFM=$(grep -oE "net[0-9]+\.[0-9]+" "$CSPROJ" | head -1)
      check_pass "TargetFramework upgraded to $TFM"
    else
      check_fail "TargetFramework not upgraded (expected net8.0+ in DotnetSampleApp.csproj)"
    fi

    # Check 2: dotnet build succeeds
    if command -v dotnet &>/dev/null; then
      if (cd "$REPO_ROOT/workshop-apps/dotnet-sample-app" && dotnet build -v q --nologo 2>/dev/null); then
        check_pass "dotnet-sample-app builds successfully"
      else
        check_fail "dotnet-sample-app build failed"
      fi
    else
      check_fail "dotnet SDK not found — cannot verify build"
    fi

    # Check 3: Upgrade artifacts exist (IDE .github/upgrades/ or CLI .github/modernize/)
    if ls "$REPO_ROOT/.github/upgrades/"*/ 2>/dev/null | grep -q . \
       || ls "$REPO_ROOT/workshop-apps/dotnet-sample-app/.github/modernize/"*/ 2>/dev/null | grep -q .; then
      check_pass "Upgrade artifacts found (.github/upgrades/ or .github/modernize/)"
    else
      check_fail "No upgrade artifacts in .github/upgrades/ or workshop-apps/dotnet-sample-app/.github/modernize/"
    fi
    ;;

  *)
    usage
    ;;
esac

echo ""
echo "================================================="
echo -e "Lab ${LAB}: ${GREEN}${PASSED}${NC}/3 checkpoints passed"
echo ""
