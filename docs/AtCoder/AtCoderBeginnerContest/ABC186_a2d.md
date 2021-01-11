---
title: 【ABC186】A~D問題
tags: 
    - AtCoder
    - ABC
    - golang
---

[パナソニックプログラミングコンテスト（AtCoder Beginner Contest 186）](https://atcoder.jp/contests/abc186)

## 振り返り

11:21で3完下滑り出しは良かったが、D問題で絶対値の考慮をせずに計算し、値があわず発狂して時間を食ってしまった。



## A - Brick

問題文: [A - Brick](https://atcoder.jp/contests/abc186/tasks/abc186_a)

### 考えたこと

整数の切り捨て除算

!!! Note
    ### 入力例
    ```
    10 3
    ```
    ### 出力例
    ```
    3
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

    func main() {
        n, w := ni(), ni()
        fmt.Println(n / w)
    }

    func ni() int { var n int; fmt.Fscan(r, &n); return n }

    ```


## B - Blocks on Grid

問題文: [B - Blocks on Grid](https://atcoder.jp/contests/abc186/tasks/abc186_b)

### 考えたこと

グリッド状のマス目自体に意味はないので1次元配列で全要素の最小値と合計値を用いることで解く。
全ての値を最小値にればいいので

$\sum_{i=0}^{HW}A_i-min(A) = sum(A)-min(A)\times H\times W$

!!! Note
    ### 入力例
    ```
    2 3
    2 2 3
    3 2 2
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

    func main() {
        h, w := ni(), ni()
        a := nis(h*w)
        min := min(a...)
        sum := sum(a...)
        fmt.Println(sum-min*h*w)
    }

    func ni() int { var n int; fmt.Fscan(r, &n); return n }
    func nis(size int) []int {var n int;res:=make([]int,size);for i:=range res{fmt.Fscan(r,&n);res[i]=n};return res}
    func min(a ...int)int{if len(a)==0{return 0};ret := a[0];for _,e:=range a{if e<ret{ret=e}};return ret}
    func sum(a... int)(sum int){for _,e:=range a{sum+=e};return}
    ```

## C - Unlucky 7

問題文: [C - Unlucky 7](https://atcoder.jp/contests/abc186/tasks/abc186_c)

### 考えたこと

整数$1~N$について10進数と8進数の文字列を作成し、それに対して7が含まれているかを判定する文字列操作

Go言語では`fmt.Sprintf("%o", i)`で8進数の文字列を作ることができる。

!!! Note
    ### 入力例
    ```
    100000
    ```
    ### 出力例
    ```
    30555
    ```

??? success "AC"
    ```go 
    package main

    import (
        "bufio"
        "fmt"
        "os"
        "strings"
    )

    var r = bufio.NewReader(os.Stdin)

    func main() {
        n := ni()
        fmt.Println(solve(n))
    }

    func solve(n int) (ans int) {
        for i := 1; i <= n; i++ {
            if s := fmt.Sprintf("%o", i); strings.Contains(s, "7") {
                continue
            }

            if s := fmt.Sprintf("%d", i); strings.Contains(s, "7") {
                continue
            }

            ans++
        }
        return
    }

    func ni() int { var n int; fmt.Fscan(r, &n); return n }

    ```

## D - Sum of difference

問題文: [D - Sum of difference](https://atcoder.jp/contests/abc186/tasks/abc186_d)

### 考えたこと


$N\leq 2\times 10^5$なので$i,j$を全て試す$O(N^2)$は間に合わない。

全ての$i, j$を試すので$A$の要素はソートしても結果は変わらず、ソートをすることにより絶対値を考慮しなくて良くなる。

!!! Note
    ### 入力例
    ```
    5
    31 41 59 26 53
    ```
    ### 出力例
    ```
    176
    ```

??? success "AC"
    ```go 
    package main

    import (
        "bufio"
        "fmt"
        "os"
        "sort"
    )

    var r = bufio.NewReader(os.Stdin)

    func main() {
        n := ni()
        a := nis(n)
        sort.Ints(a)
        fmt.Println(solve(n, a))
    }

    func solve(n int, a []int) (ans int) {
        suma := sum(a...)

        for i := 0; i < n-1; i++ {
            suma -= a[i]
            c := a[i] * (n - 1 - i)
            c -= suma
            ans += -c
        }
        return
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
    func sum(a ...int) (sum int) {
        for _, e := range a {
            sum += e
        }
        return
    }

    ```