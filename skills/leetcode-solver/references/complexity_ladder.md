# Complexity Ladder

Maps problem categories to their **theoretically optimal** complexity. Use this during the autoresearch loop termination check (Step A): if the current `baseline_class` equals the optimal for the problem type, stop — further improvement is impossible.

---

## Termination Rule

```
if baseline_class == optimal_class_for_problem_type:
    STOP — optimal complexity reached
```

If the problem type is not in this table, use static analysis and information-theoretic reasoning to estimate the lower bound.

---

## Array / Sequence Problems

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| Unsorted array linear scan | O(n) | O(1) | Must read every element |
| Unsorted array search (no extra info) | O(n) | O(1) | Information-theoretic lower bound |
| Sorted array search | O(log n) | O(1) | Binary search is tight |
| Two-sum (unsorted, return indices) | O(n) | O(n) | One-pass hash map |
| Two-sum (sorted, return values) | O(n) | O(1) | Two pointers |
| Three-sum (find all triplets) | O(n²) | O(1) or O(n) | Sort + two pointers; O(n^1.5) not achievable in general |
| Subarray sum equals k | O(n) | O(n) | Prefix sum + hash map |
| Maximum subarray sum | O(n) | O(1) | Kadane's algorithm |
| Sliding window (fixed k) | O(n) | O(k) | Single pass |
| Longest substring with property | O(n) | O(alphabet) | Sliding window |
| Median of two sorted arrays | O(log(m+n)) | O(1) | Binary search on shorter array |
| Majority element (>n/2) | O(n) | O(1) | Boyer-Moore voting |

---

## Sorting / Order Statistics

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| Comparison sort | O(n log n) | O(log n) | Comparison lower bound |
| Integer sort (bounded range [0, k]) | O(n + k) | O(k) | Counting sort |
| k-th largest/smallest | O(n) | O(1) | Quickselect expected; O(n) worst case with median-of-medians |
| Top-k elements | O(n log k) | O(k) | Min-heap of size k |

---

## String Problems

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| Exact substring search | O(n + m) | O(m) | KMP or Rabin-Karp |
| Longest common subsequence | O(mn) | O(min(m,n)) | DP lower bound |
| Longest palindromic substring | O(n) | O(1) | Manacher's algorithm |
| Anagram detection (all) | O(n) | O(1) | Sliding window + freq count |
| Word break (dict D, string s) | O(n²) or O(n·D) | O(n) | DP; O(n log n) with trie |

---

## Graph Problems

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| Graph traversal (BFS/DFS) | O(V + E) | O(V) | Must visit all edges |
| Shortest path (unweighted) | O(V + E) | O(V) | BFS |
| Shortest path (weighted, non-neg) | O(E log V) | O(V) | Dijkstra with binary heap |
| Shortest path (negative weights) | O(VE) | O(V) | Bellman-Ford |
| All-pairs shortest path | O(V³) | O(V²) | Floyd-Warshall |
| Minimum spanning tree | O(E log V) | O(V) | Prim or Kruskal |
| Topological sort | O(V + E) | O(V) | BFS (Kahn's) or DFS |
| Detect cycle (directed) | O(V + E) | O(V) | DFS with coloring |
| Number of connected components | O(V + E) | O(V) | BFS/DFS or Union-Find |
| Union-Find operations | O(α(n)) ≈ O(1) | O(n) | Path compression + union by rank |

---

## Dynamic Programming

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| Fibonacci / linear recurrence | O(n) | O(1) | Rolling variables |
| Coin change (unbounded) | O(n·k) | O(n) | k = num coin types |
| 0/1 Knapsack | O(n·W) | O(W) | W = capacity |
| Longest increasing subsequence | O(n log n) | O(n) | Patience sorting / binary search |
| Edit distance | O(mn) | O(min(m,n)) | Rolling array DP |
| Matrix chain multiplication | O(n³) | O(n²) | Standard DP |
| Palindrome partitioning | O(n²) | O(n²) | DP with palindrome precompute |

---

## Tree Problems

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| BST search/insert/delete | O(h); O(log n) balanced | O(h) | h = height |
| Tree traversal (any order) | O(n) | O(h) | Must visit all nodes |
| Lowest common ancestor | O(n) preprocessing, O(log n) query | O(n) | Binary lifting |
| Serialize / deserialize tree | O(n) | O(n) | BFS or DFS |
| Diameter of binary tree | O(n) | O(h) | Single DFS |

---

## Math / Bit Manipulation

| Problem type | Optimal time | Optimal space | Reasoning |
|---|---|---|---|
| GCD | O(log min(a,b)) | O(1) | Euclidean algorithm |
| Primality test | O(√n) | O(1) | Trial division |
| Sieve of Eratosthenes (primes up to n) | O(n log log n) | O(n) | — |
| Power (a^b mod m) | O(log b) | O(1) | Fast exponentiation |
| Count set bits (single int) | O(1) | O(1) | Brian Kernighan or popcount |
| Single number (XOR trick) | O(n) | O(1) | XOR all elements |

---

## When the Problem Type Is Unknown

Apply information-theoretic reasoning:
1. **Must read all input?** → lower bound is O(n)
2. **Must compare all pairs?** → lower bound is O(n²)
3. **Comparison-based sort needed?** → lower bound is O(n log n)
4. **Search in sorted structure?** → O(log n) is achievable
5. **Overlapping subproblems, polynomial states?** → DP gives polynomial time

If none of the above apply and static analysis says the current solution matches the lower bound, declare it optimal.
