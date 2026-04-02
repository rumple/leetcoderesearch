#!/usr/bin/env bash
set -euo pipefail

ERRORS=0
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check leetgo
if ! command -v leetgo &>/dev/null; then
  echo -e "${RED}ERROR: leetgo is not installed.${NC}"
  echo "  Install: brew install j178/tap/leetgo"
  echo "  Docs:    https://github.com/j178/leetgo"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✓ leetgo$(NC) $(leetgo version 2>/dev/null | head -1 || echo '')"
fi

# Check git
if ! command -v git &>/dev/null; then
  echo -e "${RED}ERROR: git is not installed.${NC}"
  echo "  Install: brew install git"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✓ git${NC}"
fi

# Check python3
if ! command -v python3 &>/dev/null; then
  echo -e "${RED}ERROR: python3 is not installed.${NC}"
  echo "  Install: brew install python3"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✓ python3${NC}"
fi

if [ $ERRORS -gt 0 ]; then
  echo ""
  echo -e "${RED}Fix the above errors before running /leetcode.${NC}"
  exit 1
fi

# Ensure solutions git repo exists
SOLUTIONS_DIR="${LEETCODE_SOLUTIONS_DIR:-$HOME/leetcode-solutions}"
if [ ! -d "$SOLUTIONS_DIR" ]; then
  mkdir -p "$SOLUTIONS_DIR"
  git -C "$SOLUTIONS_DIR" init -q
  echo -e "${GREEN}✓ Initialized solutions repo at $SOLUTIONS_DIR${NC}"
elif [ ! -d "$SOLUTIONS_DIR/.git" ]; then
  git -C "$SOLUTIONS_DIR" init -q
  echo -e "${YELLOW}✓ Initialized git in existing directory $SOLUTIONS_DIR${NC}"
else
  echo -e "${GREEN}✓ Solutions repo at $SOLUTIONS_DIR${NC}"
fi

echo ""
echo "All dependencies satisfied."
