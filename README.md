# leetcode-solver

A Claude Code plugin that solves LeetCode problems using **Karpathy's autoresearch methodology**: start with a naive brute-force baseline, empirically measure its complexity, then iterate — forming hypotheses, implementing optimizations, benchmarking, and committing improvements — until the theoretically optimal complexity is reached.

## How It Works

The loop:
1. **Fetch** the problem via `leetgo pick <id>`
2. **Baseline**: write the simplest correct solution, verify it passes local tests
3. **Benchmark**: generate problem-specific inputs, time the solution at 5 scales (n=100→10,000), compute growth ratios to empirically determine Big-O class
4. **Loop**:
   - Form a hypothesis (which algorithmic technique could reduce complexity?)
   - Implement it
   - Local test → if fail: discard, try next hypothesis
   - Benchmark → if complexity class improved: `git commit` as new baseline
   - Submit to LeetCode → record runtime percentile
   - Repeat until optimal or budget exhausted (max 10 iterations, 5 consecutive failures)
5. **Report**: complexity timeline, final solution, git log of improvements

The empirical ratio table (t(3n)/t(n)) is the ground truth for complexity class:
- ~3x → O(n), ~9x → O(n²), ~5x → O(n log n), ~27x → O(n³)

## Prerequisites

```bash
# LeetCode CLI
brew install j178/tap/leetgo

# Authenticate — run this from your solutions workspace (NOT the plugin directory)
# leetgo will pick up cookies automatically from Chrome/Firefox/Safari
cd ~/leetcode-solutions && leetgo init

# Also required
git
python3
```

## Usage

```
/leetcode two-sum
/leetcode 1 python3
/leetcode longest-substring-without-repeating-characters golang
```

The language defaults to `python3`. Supported: `python3`, `golang`, `cpp`, `java`, `typescript`.

## Configuration

The plugin runs `leetgo` commands from whatever directory you invoke `/leetcode` in — that directory must contain a `leetgo.yaml`. The included `leetgo.yaml` is pre-configured; copy or symlink it into your solutions workspace if needed.

Set `LEETCODE_SOLUTIONS_DIR` as a reference path for organizing work across problems:

```bash
export LEETCODE_SOLUTIONS_DIR=~/code/leetcode
```

Default: `~/leetcode-solutions/`

Git tracking happens inside the **leetgo workspace** (wherever `leetgo pick` generates the solution file). Each problem gets commits like:
```
baseline: two-sum O(n²) [empirical ratio 9.1]
iter-1: two-sum O(n) [ratio 2.9] via hash map
```

## Plugin Structure

```
.
├── .claude-plugin/plugin.json          # plugin manifest
├── commands/leetcode.md                # /leetcode slash command
├── leetgo.yaml                         # leetgo config (pre-configured)
├── skills/leetcode-solver/
│   ├── SKILL.md                        # autoresearch loop logic
│   └── references/
│       ├── optimization_hypotheses.md  # algorithmic technique catalogue
│       ├── complexity_ladder.md        # optimal complexities by problem type
│       └── leetgo_reference.md         # leetgo CLI cookbook
└── scripts/check_deps.sh               # dependency checker
```

## Installing This Plugin

From Claude Code:
```
/install-plugin /path/to/leetcoderesearch
```

Or add to your Claude Code settings to load from this directory.
