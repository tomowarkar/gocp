---
title: 最短経路詰め合わせ
---

## tl;dr

Go言語で 隣接行列を用いた最短経路導出問題の様々なアルゴリズムを実装した。

幅優先探索, ベルマン–フォード法, ダイクストラ法, プリム法


## 共通部

- 頂点数$V$の時、`V = len(Adjlist)`

```go
type pair struct {
	to, cost int
}

type Adjlist [][]pair

```

### PriorityQueue

- https://golang.org/pkg/container/heap/

```go
type PQ []pair

func (pq PQ) Len() int           { return len(pq) }
func (pq PQ) Less(i, j int) bool { return pq[i].cost < pq[j].cost }
func (pq PQ) Swap(i, j int)      { pq[i], pq[j] = pq[j], pq[i] }

func (pq *PQ) Push(x interface{}) { *pq = append(*pq, x.(pair)) }
func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	x := old[n-1]
	*pq = old[0 : n-1]
	return x
}

```

## 幅優先探索

- 最も基本となるアルゴリズム
- `result` の更新は1度しか行われないので、$O(V)$

```go
// s　から各ノードへのステップを返す O(V)
func (al Adjlist) bfs(s int) []int {
	result := make([]int, len(al))
	fill(result, INF)
	result[s] = 0

	for q := []int{s}; len(q) > 0; {
		var p int
		p, q = q[0], q[1:]

		for _, np := range al[p] {
			if result[np.to] != INF {
				continue
			}
			result[np.to] = result[p] + 1
			q = append(q, np.to)
		}
	}
	return result
}

```

## ベルマン–フォード法

- 全ての頂点からそれぞれ隣を見て、より小さい値で遷移可能であれば、値を更新する
- これを全ての頂点において更新が起きなくなるまで行う
- 一周毎に少なくとも一つのさ最小コストが決定するので、ループ回数は最大 `V`
- よって計算量は $O(VE)$

```go
// s: 開始ノード　(負のコストが含まれる場合)
func (al Adjlist) bellman(s int) []int {
	result := make([]int, len(al))
	fill(result, INF)
	result[s] = 0

	for update := true; update; {
		update = false
		for i := range al {
			for _, p := range al[i] {
				if result[p.to] > result[i]+p.cost {
					result[p.to] = result[i] + p.cost
					update = true
				}
			}

		}
	}
	return result
}

```

## ダイクストラ法

- 最小コストを1ノードずつ確定させていく
- 優先度付きキューを用いるので、キューから取り出した頂点の値が書き換わるのは最初の1度のみ
- 全ての辺を回るのに$O(E)$, キューの挿入,削除で$O(log\, E)$
- よって計算量は $O(E\, log\, E)$

```go
// s: 開始ノード (コストが全て正の場合)
func (al Adjlist) dijk(s int) []int {
	result := make([]int, len(al))
	fill(result, INF)
	result[s] = 0

	pq := new(PQ)
	heap.Init(pq)

	heap.Push(pq, pair{s, 0})
	for pq.Len() > 0 {
		p := heap.Pop(pq).(pair)

		if result[p.to] < p.cost {
			continue
		}

		for _, np := range al[p.to] {
			nc := p.cost + np.cost
			if result[np.to] > nc {
				result[np.to] = nc
				heap.Push(pq, pair{np.to, nc})
			}
		}
	}
	return result

}

```

## プリム法

- 最小木を閉路を作らない最小コストで拡張していく

```go
// 頂点 s を含む最小全域木のコストを返す
func (al Adjlist) prim(s int) int {
	v := len(al)
	result := make([]int, v)
	fill(result, INF)

	pq := new(PQ)
	heap.Init(pq)

	var length, size int

	result[s] = 0
	heap.Push(pq, pair{s, 0})

	for pq.Len() > 0 && size < v {
		p := heap.Pop(pq).(pair)
		if result[p.to] < p.cost {
			continue
		}

		result[p.to] = -INF // used
		length += p.cost
		size++

		for _, np := range al[p.to] {
			if result[np.to] > np.cost {
				result[np.to] = np.cost
				heap.Push(pq, pair{np.to, np.cost})
			}
		}
	}
	return length
}

```

## コード

```go
package main

import (
	"bufio"
	"bytes"
	"container/heap"
	"fmt"
	"strconv"
)

const (
	initialBufSize = 1e4
	INF            = 1 << 60
)

var input = []byte(`10 12
4 9 90
3 4 210
3 1 90
1 0 210
4 5 120
5 3 30
5 6 90
6 1 120
7 6 120
7 8 150
2 1 210
2 7 180`)

var r = bytes.NewReader(input)
var sc = bufio.NewScanner(r)

type pair struct {
	to, cost int
}

type Adjlist [][]pair

type PQ []pair

func (pq PQ) Len() int           { return len(pq) }
func (pq PQ) Less(i, j int) bool { return pq[i].cost < pq[j].cost }
func (pq PQ) Swap(i, j int)      { pq[i], pq[j] = pq[j], pq[i] }

func (pq *PQ) Push(x interface{}) { *pq = append(*pq, x.(pair)) }
func (pq *PQ) Pop() interface{} {
	old := *pq
	n := len(old)
	x := old[n-1]
	*pq = old[0 : n-1]
	return x
}

// s　から各ノードへのステップを返す O(V)
func (al Adjlist) bfs(s int) []int {
	result := make([]int, len(al))
	fill(result, INF)
	result[s] = 0

	for q := []int{s}; len(q) > 0; {
		var p int
		p, q = q[0], q[1:]

		for _, np := range al[p] {
			if result[np.to] != INF {
				continue
			}
			result[np.to] = result[p] + 1
			q = append(q, np.to)
		}
	}
	return result
}

// s: 開始ノード (コストが全て正の場合)
func (al Adjlist) dijk(s int) []int {
	result := make([]int, len(al))
	fill(result, INF)
	result[s] = 0

	pq := new(PQ)
	heap.Init(pq)

	heap.Push(pq, pair{s, 0})
	for pq.Len() > 0 {
		p := heap.Pop(pq).(pair)

		if result[p.to] < p.cost {
			continue
		}

		for _, np := range al[p.to] {
			nc := p.cost + np.cost
			if result[np.to] > nc {
				result[np.to] = nc
				heap.Push(pq, pair{np.to, nc})
			}
		}
	}
	return result

}

// s: 開始ノード　(負のコストが含まれる場合)
func (al Adjlist) bellman(s int) []int {
	result := make([]int, len(al))
	fill(result, INF)
	result[s] = 0

	for update := true; update; {
		update = false
		for i := range al {
			for _, p := range al[i] {
				if result[p.to] > result[i]+p.cost {
					result[p.to] = result[i] + p.cost
					update = true
				}
			}

		}
	}
	return result
}

// 頂点 s を含む最小全域木のコストを返す
func (al Adjlist) prim(s int) int {
	v := len(al)
	result := make([]int, v)
	fill(result, INF)

	pq := new(PQ)
	heap.Init(pq)

	var length, size int

	result[s] = 0
	heap.Push(pq, pair{s, 0})

	for pq.Len() > 0 && size < v {
		p := heap.Pop(pq).(pair)
		if result[p.to] < p.cost {
			continue
		}

		result[p.to] = -INF // used
		length += p.cost
		size++

		for _, np := range al[p.to] {
			if result[np.to] > np.cost {
				result[np.to] = np.cost
				heap.Push(pq, pair{np.to, np.cost})
			}
		}
	}
	return length
}

func main() {
	V, E := nextInt(), nextInt()
	adjlist := make(Adjlist, V)

	for i := 0; i < E; i++ {
		a, b, c := nextInt(), nextInt(), nextInt()
		adjlist[a] = append(adjlist[a], pair{b, c})
		adjlist[b] = append(adjlist[b], pair{a, c})
	}

	fmt.Println(adjlist.bellman(4)) // [450 240 450 150 0 120 210 330 480 90]
	fmt.Println(adjlist.dijk(4))    // [450 240 450 150 0 120 210 330 480 90]
	fmt.Println(adjlist.prim(4))    // 1080
	fmt.Println(adjlist.bfs(4))     // [3 2 3 1 0 1 2 3 4 1]
}

func init() {
	buf := make([]byte, initialBufSize)
	sc.Buffer(buf, bufio.MaxScanTokenSize)
	sc.Split(bufio.ScanWords)
}

func next() string {
	sc.Scan()
	return sc.Text()
}

func nextInt() int {
	sc.Scan()
	i, e := strconv.Atoi(sc.Text())
	if e != nil {
		panic(e)
	}
	return i
}

func fill(a []int, x int) {
	a[0] = x
	for i := 1; i < len(a); i *= 2 {
		copy(a[i:], a[:i])
	}
}

```

## 参考

- https://www.slideshare.net/hcpc_hokudai/ss-62620083
