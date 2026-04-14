#!/bin/bash
set -e

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Tracking results
declare -A RESULTS

# Helper function to print header
print_header() {
  echo ""
  echo -e "${YELLOW}🚀 GitHub Copilot Modernization — Pre-Demo Setup${NC}"
  echo -e "${YELLOW}========================================${NC}"
  echo ""
}

# Helper function to check command exists
check_command() {
  local cmd=$1
  local label=$2
  if command -v "$cmd" &> /dev/null; then
    echo -e "${GREEN}✅${NC} $label"
    RESULTS[$label]="✅"
  else
    echo -e "${RED}❌${NC} $label"
    RESULTS[$label]="❌"
  fi
}

# Helper function to execute step and track result
execute_step() {
  local step_name=$1
  local cmd=$2
  echo -n "Setting up $step_name... "
  if eval "$cmd" &>/dev/null; then
    echo -e "${GREEN}✅${NC}"
    RESULTS[$step_name]="✅"
  else
    echo -e "${RED}❌${NC}"
    RESULTS[$step_name]="❌"
  fi
}

# Start
print_header

# Step 1: Check prerequisites
echo "Checking prerequisites..."
check_command "java" "Java"
check_command "mvn" "Maven"
check_command "git" "Git"
check_command "code" "VS Code CLI"
echo ""

# Step 2: Clone PhotoAlbum-Java
echo "Cloning sample repositories..."
DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$DEMO_DIR")"

if [ ! -d "$PARENT_DIR/PhotoAlbum-Java" ]; then
  echo -n "Cloning PhotoAlbum-Java... "
  if git clone https://github.com/Azure-Samples/PhotoAlbum-Java.git "$PARENT_DIR/PhotoAlbum-Java" 2>/dev/null; then
    echo -e "${GREEN}✅${NC}"
    RESULTS["PhotoAlbum-Java clone"]="✅"
  else
    echo -e "${RED}❌${NC}"
    RESULTS["PhotoAlbum-Java clone"]="❌"
  fi
else
  echo -e "${GREEN}✅${NC} PhotoAlbum-Java (already cloned)"
  RESULTS["PhotoAlbum-Java clone"]="✅"
fi

# Step 3: Clone NewsFeedSite
if [ ! -d "$PARENT_DIR/NewsFeedSite" ]; then
  echo -n "Cloning NewsFeedSite... "
  if git clone https://github.com/Azure-Samples/NewsFeedSite.git "$PARENT_DIR/NewsFeedSite" 2>/dev/null; then
    echo -e "${GREEN}✅${NC}"
    RESULTS["NewsFeedSite clone"]="✅"
  else
    echo -e "${RED}❌${NC}"
    RESULTS["NewsFeedSite clone"]="❌"
  fi
else
  echo -e "${GREEN}✅${NC} NewsFeedSite (already cloned)"
  RESULTS["NewsFeedSite clone"]="✅"
fi
echo ""

# Step 4: Build Task Tracker app
echo "Building Task Tracker app..."
if [ -d "$PARENT_DIR/demo-apps/task-tracker-app" ]; then
  echo -n "Building task-tracker-app... "
  if (cd "$PARENT_DIR/demo-apps/task-tracker-app" && mvn clean package -q 2>/dev/null); then
    echo -e "${GREEN}✅${NC}"
    RESULTS["Task Tracker build"]="✅"
  else
    echo -e "${YELLOW}⚠${NC} Task Tracker build (may not be needed)"
    RESULTS["Task Tracker build"]="⚠"
  fi
else
  echo -e "${YELLOW}⚠${NC} Task Tracker app not found (may not be needed)"
  RESULTS["Task Tracker build"]="⚠"
fi
echo ""

# Step 5: Warm Maven caches
echo "Warming Maven caches..."
if [ -d "$PARENT_DIR/PhotoAlbum-Java" ]; then
  echo -n "Warming PhotoAlbum-Java dependencies... "
  if (cd "$PARENT_DIR/PhotoAlbum-Java" && mvn dependency:go-offline -q 2>/dev/null); then
    echo -e "${GREEN}✅${NC}"
    RESULTS["Maven cache warming"]="✅"
  else
    echo -e "${YELLOW}⚠${NC} Maven cache warming (may skip on first run)"
    RESULTS["Maven cache warming"]="⚠"
  fi
else
  echo -e "${YELLOW}⚠${NC} PhotoAlbum-Java not available for cache warming"
  RESULTS["Maven cache warming"]="⚠"
fi
echo ""

# Step 6: Check VS Code extensions
echo "Checking VS Code extensions..."
echo -n "GitHub Copilot & Migration extensions... "
if command -v code &> /dev/null; then
  if code --list-extensions 2>/dev/null | grep -qE "copilot|migrate"; then
    echo -e "${GREEN}✅${NC}"
    RESULTS["VS Code extensions"]="✅"
  else
    echo -e "${YELLOW}⚠${NC} (Install extensions in VS Code)"
    RESULTS["VS Code extensions"]="⚠"
  fi
else
  echo -e "${YELLOW}⚠${NC} (VS Code CLI not available)"
  RESULTS["VS Code extensions"]="⚠"
fi
echo ""

# Print summary
echo -e "${YELLOW}========================================${NC}"
echo "Setup Summary:"
echo -e "${YELLOW}========================================${NC}"
for step in "${!RESULTS[@]}"; do
  echo -e "${RESULTS[$step]} $step"
done
echo ""
echo -e "${GREEN}✨ Setup complete! Open VS Code and run the demo.${NC}"
echo ""
