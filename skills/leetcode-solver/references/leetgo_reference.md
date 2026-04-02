# leetgo CLI Reference

Quick cookbook for `leetgo` commands used in the autoresearch loop.

## Installation

```bash
brew install j178/tap/leetgo
```

## One-Time Setup

```bash
# Initialize workspace (creates leetgo.yaml in current directory)
leetgo init

# leetgo will open a browser to authenticate with LeetCode
# It picks up cookies automatically from Chrome/Firefox/Safari
```

The `leetgo.yaml` config file is created in the current directory. Key fields:
```yaml
language: python3        # default language for new problems
leetcode:
  site: us               # us or cn
code:
  lang: python3
  filename_template: "solution"   # generates solution.py
```

---

## Core Commands

### Pick a problem
```bash
leetgo pick 1             # by problem number
leetgo pick two-sum       # by slug
leetgo pick today         # daily challenge
```

Generates:
- `<num>.<slug>/<lang>/solution.<ext>` — solution template with function signature
- `<num>.<slug>/testcases/` — sample test cases from the problem

**Always run from the leetgo workspace directory** (where `leetgo.yaml` lives).

---

### View problem info
```bash
leetgo info 1
leetgo info two-sum
```

Prints the full problem statement, constraints, and examples. Use this to read constraints when writing `gen_inputs.py`.

---

### Run local tests
```bash
leetgo test last -L       # test the last picked problem, locally (no API call)
leetgo test 1 -L          # test problem 1 locally
leetgo test last          # test against LeetCode API (slower, requires auth)
```

**Exit codes:**
- `0` — all test cases passed
- Non-zero — at least one failed (output shows which)

**Output format:**
```
✔ Case 1: [2,7,11,15], 9 => [0,1]  ✓ Expected: [0,1]
✘ Case 2: [3,2,4], 6 => [0,1]  ✗ Expected: [1,2]
```

Always use `-L` (local) in the autoresearch loop — it's instant and doesn't count against rate limits.

---

### Submit solution
```bash
leetgo submit last        # submit the last picked problem
leetgo submit 1           # submit problem 1
```

**Output format** (on success):
```
✔ Accepted
Runtime: 48 ms, faster than 87.32% of Python3 online submissions for Two Sum.
Memory Usage: 14.3 MB, less than 72.11% of Python3 online submissions for Two Sum.
```

**Output format** (on failure):
```
✘ Wrong Answer
Input: nums = [3,2,4], target = 6
Output: [0,2]
Expected: [1,2]
```

**Parsing the percentile**: look for `faster than X%` in the output. Use this as the secondary metric.

---

### Other useful commands

```bash
leetgo list                        # list all problems
leetgo list -q e                   # easy problems only (e=easy, m=medium, h=hard)
leetgo config                      # show current config
```

---

## File Layout After `leetgo pick 1`

```
<leetgo-workspace>/
├── leetgo.yaml
└── 0001.two-sum/
    ├── python3/
    │   └── solution.py       ← THE ONE FILE (edit this)
    └── testcases/
        ├── 1.in
        └── 1.out
```

The autoresearch loop also creates (in `python3/`):
- `gen_inputs.py` — problem-specific input generator (written once)
- `benchmark.py` — timing harness (rewritten each iteration)

---

## Common Issues

**"leetgo: command not found"**: run `brew install j178/tap/leetgo`

**"no session found"**: run `leetgo init` and authenticate via browser

**Rate limited on submit**: wait ~30 seconds and retry once. If still failing, count the iteration as "inconclusive" and move on.

**Wrong language generated**: set `language: python3` in `leetgo.yaml` before running `leetgo pick`.

**`leetgo test last -L` fails with "no testcases"**: the `testcases/` directory is empty or missing. Run `leetgo pick <id>` again to regenerate.
