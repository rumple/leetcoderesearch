# Optimization Hypotheses Catalogue

A ranked catalogue of algorithmic techniques, organized by the complexity improvement they target. During the autoresearch loop, read this file in Step B to select the next hypothesis to test.

**Selection rule**: pick the technique with the largest potential improvement that is applicable to the current problem's structure. If a technique was already tried and failed, skip it.

---

## O(n²) → O(n): Hash Map / Frequency Count

**Applicability**: Problems requiring complement lookup, pair finding, duplicate detection, or grouping by value. The key insight is replacing "for each element, search the rest of the array" with O(1) hash map lookup.

**Conditions**: Values must be hashable (integers, strings). No ordering requirement on the result.

**Sketch**:
```python
seen = {}
for i, x in enumerate(arr):
    complement = target - x
    if complement in seen:
        return [seen[complement], i]
    seen[x] = i
```

**Common gotcha**: Using the same element twice (e.g., two-sum: `seen[x] = i` must be stored AFTER checking complement, not before).

---

## O(n²) → O(n): Sliding Window

**Applicability**: Contiguous subarray/substring problems — max/min sum of length k, longest substring with property P, minimum window containing all characters.

**Conditions**: The property P must be "monotone" — expanding the window can only improve or maintain the property, not worsen it. Works for sums, character counts, distinct elements.

**Sketch**:
```python
left = 0
window_state = {}  # or a counter
best = 0
for right, x in enumerate(arr):
    # expand: add arr[right] to window
    window_state[x] = window_state.get(x, 0) + 1
    while not valid(window_state):
        # shrink: remove arr[left] from window
        window_state[arr[left]] -= 1
        left += 1
    best = max(best, right - left + 1)
return best
```

**Common gotcha**: Forgetting to update `left` pointer properly; off-by-one in window size calculation.

---

## O(n²) → O(n): Prefix Sum / Prefix Product

**Applicability**: Subarray sum queries, range queries, problems of the form "find subarray with sum = k".

**Conditions**: Values support addition/subtraction. For "subarray sum = k": use prefix sum + hash map to get O(n).

**Sketch**:
```python
prefix = {0: 1}  # prefix_sum -> count
running = 0
count = 0
for x in arr:
    running += x
    count += prefix.get(running - k, 0)
    prefix[running] = prefix.get(running, 0) + 1
return count
```

**Common gotcha**: Initialize `prefix = {0: 1}` to handle subarrays starting from index 0.

---

## O(n²) → O(n): Monotonic Stack / Queue

**Applicability**: "Next greater/smaller element", "largest rectangle in histogram", "sliding window maximum", stock price span problems.

**Conditions**: The answer for each element depends on a monotone relationship with its neighbors.

**Sketch** (next greater element):
```python
stack = []  # indices, decreasing values
result = [-1] * len(arr)
for i, x in enumerate(arr):
    while stack and arr[stack[-1]] < x:
        result[stack.pop()] = x
    stack.append(i)
return result
```

**Common gotcha**: Decide whether the stack stores indices or values; indices are almost always safer.

---

## O(n²) → O(n log n): Sort + Two Pointers

**Applicability**: Pair/triplet sum problems (two-sum on sorted array, 3-sum, 4-sum), container with most water.

**Conditions**: The problem allows sorting the input (result doesn't depend on original indices, or indices can be recovered).

**Sketch** (two-sum sorted):
```python
arr.sort()
left, right = 0, len(arr) - 1
while left < right:
    s = arr[left] + arr[right]
    if s == target: return [left, right]
    elif s < target: left += 1
    else: right -= 1
```

**Common gotcha**: For 3-sum, the outer loop must skip duplicates; for problems requiring original indices, sort a list of (value, index) pairs.

---

## O(n²) → O(n log n): Binary Search on Sorted Structure

**Applicability**: Searching in a sorted array, finding insertion position, "find peak element", problems where the answer space is monotone.

**Conditions**: The structure must already be sorted, or can be sorted. The predicate `f(mid)` must be monotone (all False then all True, or vice versa).

**Sketch** (binary search on answer):
```python
def feasible(mid):
    # can we achieve the answer with value <= mid?
    ...

lo, hi = min_val, max_val
while lo < hi:
    mid = (lo + hi) // 2
    if feasible(mid):
        hi = mid
    else:
        lo = mid + 1
return lo
```

**Common gotcha**: Off-by-one in `lo/hi` update (`hi = mid` vs `hi = mid - 1`); always use `lo < hi` to avoid infinite loops.

---

## Exponential → O(n·k): Dynamic Programming (Memoization)

**Applicability**: Problems with overlapping subproblems — Fibonacci variants, coin change, longest common subsequence, knapsack, palindrome partitioning.

**Conditions**: The problem has optimal substructure (solution to big problem = function of solutions to subproblems).

**Approach — top-down (memoization)**:
```python
from functools import lru_cache

@lru_cache(maxsize=None)
def dp(i, state):
    if base_case(i, state):
        return base_value
    return min/max(dp(i+1, new_state) + cost for new_state in transitions)
```

**Approach — bottom-up (tabulation)** (often faster in practice):
```python
dp = [[0] * (k+1) for _ in range(n+1)]
for i in range(n):
    for j in range(k+1):
        dp[i+1][j] = ...
return dp[n][target]
```

**Common gotcha**: With `lru_cache`, mutable arguments (lists, dicts) must be converted to tuples. Bottom-up requires careful ordering of loops.

---

## Exponential → O(V+E): BFS/DFS Replacing Backtracking

**Applicability**: Shortest path in unweighted graph, level-order traversal, "word ladder", flood fill, number of islands.

**Conditions**: The search space can be modeled as a graph. BFS finds shortest path; DFS finds any path.

**Sketch** (BFS shortest path):
```python
from collections import deque

queue = deque([(start, 0)])
visited = {start}
while queue:
    node, dist = queue.popleft()
    if node == end:
        return dist
    for neighbor in graph[node]:
        if neighbor not in visited:
            visited.add(neighbor)
            queue.append((neighbor, dist + 1))
return -1
```

**Common gotcha**: Always mark visited BEFORE enqueuing (not after dequeuing) to avoid processing the same node multiple times and causing O(V²) behavior.

---

## O(n) space → O(1) space: In-Place / Rolling Array

**Applicability**: DP problems where only the previous row/column is needed. Linked list reversal. Array rotation.

**Conditions**: The recurrence only depends on a fixed number of previous states.

**Sketch** (1D DP space reduction):
```python
# Before: dp[i] = f(dp[i-1], dp[i-2])
# After:
prev2, prev1 = base0, base1
for i in range(2, n+1):
    curr = f(prev1, prev2)
    prev2, prev1 = prev1, curr
return prev1
```

**Common gotcha**: Update order matters — update `prev2` and `prev1` simultaneously (use tuple assignment).

---

## Selection Priority

When choosing the next hypothesis, prefer in this order:
1. Technique that eliminates the dominant loop (biggest class jump)
2. Technique that matches the problem's primary operation (lookup → hash map; range → prefix sum; search → binary search)
3. Technique you haven't tried yet this session
4. Technique with the simplest implementation (fewest edge cases)
