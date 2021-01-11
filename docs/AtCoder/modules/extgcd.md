---
title: 拡張ユークリッド
tags: 
    - golang
---

## 概要

拡張ユークリッドアルゴリズムは最大公約数とベズー係数[^1]の一組を計算する.

$a, b$の最大公約数$g$だけでなく、$g=ax\times by$を満たす$x, y$を計算するので、modの逆元の導出に用いられる。


```go
func extGCD(a, b int) (int, int, int) {
    if b == 0 {
        return a, 1, 0
    }
    g, x, y := extGCD(b, a%b)
    return g, y, x - a/b*y
}
```

```
g, x, y = extGCD(a, b)

g, dx, dy = extGCD(b, a%b)
```

```
g = a・x + b・y = dx・b + dy・(a%b)
= dx・b + dy・(a-a/b)
= dy・a + dx・b - (a/b)・dy
= a・dy + b・(dx-()・dy)
```


[^1]:[べズーの等式](https://ja.wikipedia.org/wiki/%E3%83%99%E3%82%BA%E3%83%BC%E3%81%AE%E7%AD%89%E5%BC%8F)