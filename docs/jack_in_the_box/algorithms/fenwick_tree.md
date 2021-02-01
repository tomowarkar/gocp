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

// 1-indexed 注意
type FenwickTree []int

func (fw FenwickTree) add(i, x int) {
	for i < len(fw) {
		fw[i] += x
		i += i & -i
	}
}

// [i, j] の累積和
func (fw FenwickTree) sum(i, j int) int {
	return fw._sum(j) - fw._sum(i-1)
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
	fw := make(FenwickTree, n+1)

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



## 参考

- https://atcoder.github.io/ac-library/document_ja/fenwicktree.html
- https://www.slideshare.net/hcpc_hokudai/binary-indexed-tree