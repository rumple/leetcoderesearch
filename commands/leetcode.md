---
description: Solve and iteratively optimize a LeetCode problem using Karpathy's autoresearch loop (empirical benchmarking + git baseline tracking)
argument-hint: <problem-id-or-slug> [language]
allowed-tools: [Bash, Read, Write, Edit, Glob]
---

# /leetcode — LeetCode Autoresearch Solver

Solve a LeetCode problem from scratch and iterate toward the theoretically optimal solution using Karpathy's autoresearch loop.

## Step 1: Dependency Check

Run the dependency checker. If it exits non-zero, stop immediately and show the user the error output — do not proceed.

```
bash "${CLAUDE_PLUGIN_ROOT}/scripts/check_deps.sh"
```

## Step 2: Parse Arguments

Arguments: `$ARGUMENTS`

- **problem**: first token (e.g. `1`, `two-sum`, `longest-substring-without-repeating-characters`)
- **language**: second token if present; default `python3`

Supported languages: `python3`, `golang`, `cpp`, `java`, `typescript`

## Step 3: Fetch the Problem

```bash
leetgo pick <problem>
```

Read the generated solution file (leetgo outputs its path). Extract:
- Problem title and number
- Full problem statement and examples
- Constraints (especially the bounds on `n` — these determine the achievable optimal complexity)

Also note the generated solution file path — this is the **one file** for the entire autoresearch loop.

## Step 4: Run the Autoresearch Loop

The full loop logic is defined in the `leetcode-solver` skill (already in context). Hand off to it now with:
- The problem number, slug, language, solution file path
- The constraints extracted above
- The solutions directory: `$LEETCODE_SOLUTIONS_DIR` or `~/leetcode-solutions`

The skill will handle: naive baseline → gen_inputs.py → benchmark.py → hypothesis loop → git commits → final report.
