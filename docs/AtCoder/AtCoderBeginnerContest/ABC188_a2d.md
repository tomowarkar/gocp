---
title: 【ABC188】A~D問題
tags: 
    - AtCoder
    - ABC
    - golang
---

[AtCoder Beginner Contest 188](https://atcoder.jp/contests/abc188)


## A - Three-Point Shot

問題文: https://atcoder.jp/contests/abc188/tasks/abc188_a

### 考えたこと

問題文の通りに実装

!!! Note
    ### 入力例
    ```
    12 15
    ```
    ### 出力例
    ```
    No
    ```

??? success "AC"
	```go 
    package main

    import (
        "fmt"
    )

    func main() {
        var X, Y int
        fmt.Scan(&X, &Y)
        fmt.Println(solve(X, Y))
    }

    func solve(a, b int) string {
        if a > b {
            a, b = b, a
        }
        if a+3 > b {
            return "Yes"
        }
        return "No"
    }

    ```

## B - Orthogonality

問題文: https://atcoder.jp/contests/abc188/tasks/abc188_b

### 考えたこと

内積の計算パートと、計算結果の判定パート

!!! Note
    ### 入力例
    ```
    3
    1 3 5
    3 -6 3
    ```
    ### 出力例
    ```
    Yes
    ```

??? success "AC"
	```go 
    package main

    import (
        "bufio"
        "os"
        "fmt"
    )

    var r = bufio.NewReader(os.Stdin)

    func main() {
        n := ni()
        a, b := nis(n), nis(n)

        var cnt int
        for i := 0; i < n; i++ {
            cnt += a[i]*b[i]
        }
        if cnt == 0 {
            fmt.Println("Yes")
        } else{
            fmt.Println("No")
        }
    }



    func ni() int { var n int; fmt.Fscan(r, &n); return n }
    func nis(size int) []int {var n int;res:=make([]int,size);for i:=range res{fmt.Fscan(r,&n);res[i]=n};return res}

    ```

## C - ABC Tournament

問題文: https://atcoder.jp/contests/abc188/tasks/abc188_c

### 考えたこと

- トーナメント問題
- 選手数2~65536人
- 愚直にシミュレートしても $O(2^N)$ で間に合う

!!! Note
    ### 入力例
    ```
    4
    6 13 12 5 3 7 10 11 16 9 8 15 2 1 14 4
    ```
    ### 出力例
    ```
    2
    ```

??? success "AC"
    ```go
    package main

    import (
        "bufio"
        "fmt"
        "os"
    )

    var r = bufio.NewReader(os.Stdin)

    type player struct {
        id   int
        rate int
    }

    func main() {
        n := ni()
        ps := make([]player, 1<<n)
        for i := range ps {
            ps[i].id = i + 1
            ps[i].rate = ni()
        }
        _, loser := solve(ps)
        fmt.Println(loser.id)
    }

    func solve(ps []player) (player, player) {
        lenps := len(ps)
        if lenps == 2 {
            return battle(ps[0], ps[1])
        }
        aw, _ := solve(ps[:lenps/2])
        bw, _ := solve(ps[lenps/2:])
        return battle(aw, bw)
    }

    // 勝者, 敗者 の順で返す
    func battle(a, b player) (player, player) {
        if a.rate > b.rate {
            return a, b
        }
        return b, a
    }

    func ni() int { var n int; fmt.Fscan(r, &n); return n }
    func nis(size int) []int {
        var n int
        res := make([]int, size)
        for i := range res {
            fmt.Fscan(r, &n)
            res[i] = n
        }
        return res
    }

    ```

#### After Contest

解説の 解法2 で

!!! quote "引用"
    準優勝するのは、優勝する( = 一番レートが高い) 選手とは逆側のブロックにいる選手のうち一番レートが高い人です。

とあった言われてみればという感じ

次に同じような問題がきた場合に使えるようにしたい


## D - Snuke Prime

問題文: https://atcoder.jp/contests/abc188/tasks/abc188_d

### 考えたこと

- 区間加算問題
- $a_i \leq b_i \leq 1e9$ がネック -> 出入り口でのカウントを用いるいもす法が使用できない
- $N \leq 2e5$ なので $O(NlogN)$ での解法を考慮

```go
package main

import (
	"bufio"
	"os"
	"fmt"
	"sort"
)

var r = bufio.NewReader(os.Stdin)

type event struct {
	day int
	cost int
}

func main() {
	n, C := ni(), ni()

	es := make([]event, 2*n)
	for i:=0;i<n;i++{
		a, b, c := ni()-1, ni(), ni()
		es[i*2] = event{a, c}
		es[i*2+1] = event{b, -c}
	}

	sort.Slice(es, func(i, j int)bool{
		return es[i].day < es[j].day
	})
	
	var ans, fee, eventStart int
	for _, e := range es {
		nowTime := e.day
		if nowTime != eventStart {
			ans+=min(C, fee)*(nowTime-eventStart)
			eventStart = nowTime
		}
		fee += e.cost
	}
	fmt.Println(ans)

}


func ni() int { var n int; fmt.Fscan(r, &n); return n }
func nis(size int) []int {var n int;res:=make([]int,size);for i:=range res{fmt.Fscan(r,&n);res[i]=n};return res}
func min(a ...int)int{if len(a)==0{return 0};ret := a[0];for _,e:=range a{if e<ret{ret=e}};return ret}

```

### 反省

区間加算問題は今までいもす法を用いるものしか解いたことがなかったため、コンテスト中に解くことができなかった

$N$ の制約や、料金の更新が開始日と終了日にしか起こらない点をもう少し考えることができていれば解けたのではないか


