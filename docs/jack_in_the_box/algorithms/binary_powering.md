---
title: The binary powering algorithm
---

### 概要

$a^n$ を $O(n)$ に変わり $O(log\, n)$ で計算する。

### アイデア

$n$ を二進数で考え、乗算を分割、最適化する。

#### 例

$3^{13} = 3^{1101_2} = 3^8\cdot3^4\cdot3^1$

### アプローチ

$n\geq0$ において

$a^n = \begin{cases}
    1 & (n=0) \\
    (a^{\frac{n}{2}})^2 & (n\ even)\\
    (a^{\frac{n-1}{2}})^2\cdot a & (n\ odd)\\
  \end{cases}$

### 実装

```go
func binpow(a, b, m int) int {
	a %= m
	res := 1

	for b > 0 {
		if b&1 != 0 {
			res = res * a % m
		}
		a = a * a % m
		b >>= 1
	}
	return res
}
```

### 参考

- https://cp-algorithms.com/algebra/binary-exp.html

