---
title: Fenwick Tree
---

## tl;dr

Go言語で Fenwick tree (binary indexed tree, BIT) を実装した。

## メリット

- 省メモリ (要素数 `N` に対してサイズ `N` で実装可能)
- 和の計算, 値の更新が $O(log\, n)$

## コード

```go
package main

import (
	"fmt"
)

type FenwickTree []int

func newFenwickTree(n int) *FenwickTree {
	fw := make(FenwickTree, n+1)
	return &fw
}

func (fw FenwickTree) add(i, x int) {
	for i < len(fw) {
		fw[i] += x
		i += i & -i
	}
}

func (fw FenwickTree) add0(i, x int) {
	fw.add(i+1, x)
}

// [0, i] の累積和
func (fw FenwickTree) _sum(i int) int {
	s := 0
	for i > 0 {
		s += fw[i]
		i -= i & -i
	}
	return s
}

// 0-indexed
func (fw FenwickTree) _sum0(i int) int {
	return fw._sum(i + 1)
}

// [i, j] の累積和
func (fw FenwickTree) sum(i, j int) int {
	return fw._sum(j) - fw._sum(i-1)
}

// 0-indexed
func (fw FenwickTree) sum0(i, j int) int {
	return fw._sum0(j) - fw._sum0(i-1)
}

// よく使う形に変換 (デバック用)
func (fw FenwickTree) flatten() []int {
	ret := make([]int, len(fw))
	for i := range ret {
		ret[i] = fw.sum(i, i)
	}
	return ret
}

func main() {
	n := 3
	fw := newFenwickTree(n)

	fw.add(1, 1)
	fw.add(2, 2)
    fw.add(3, 3)
    
    fmt.Println(fw.sum(1, 2)) // 3
	fmt.Println(fw)           // [0 1 3 3]
	fmt.Println(fw.flatten()) // [0 1 2 3]
}

```

!!! Note
    [最下位ビット(LSB) - Wikipedia](https://ja.wikipedia.org/wiki/%E6%9C%80%E4%B8%8B%E4%BD%8D%E3%83%93%E3%83%83%E3%83%88)

    二進数で表した時、初めて1が出現する位置

    `i = 3` の時 二進数表記で `0b0001` なので `LSB = 1`
    `i = 6` の時 二進数表記で `0b0110` なので `LSB = 2`

    LSB は `i & -i` で取得できる

    `LSB = 3 & -3 = 1`, `LSB = 6 & -6 = 2`

    ``

### 転倒数

- 数列 $A = [a_0, a_i,...,a_{N-1}]$ における $i < j$ かつ $a_i>a_j$ を満たす添字の組$(i, j)$ の個数
- $j$ を固定して考える
- $j$ の左側にある、$a_j$ より大きな数$a_i$の個数の総和が求める数

```go
func main() {
	N := nextInt()
	A := nextInts(N)

	fw := newFenwickTree(N)

	var ans int
	for _, a := range A {
		ans += fw.sum0(a, N-1)
		fw.add0(a, 1)
	}

	fmt.Println(ans)
}

```

```
Input:
10
0 3 1 5 4 2 9 6 8 7

Output:
9
```

- https://qiita.com/wisteria0410ss/items/296e0daa9e967ca71ed6 

## 参考

- https://atcoder.github.io/ac-library/document_ja/fenwicktree.html
- https://www.slideshare.net/hcpc_hokudai/binary-indexed-tree