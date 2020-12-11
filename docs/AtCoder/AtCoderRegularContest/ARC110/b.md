---
title: B - Many 110
tags: 
    - AtCoder
    - ARC
    - golang
---

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
		fmt.Println(solve())
	}

	func solve() int {
		N := ni()
		T := ns()

		if N == 1 {
			switch T {
			case "1":
				return 2e10
			case "0":
				return 1e10
			default:
				return 0
			}
		}

		var f func(a, b string) bool

		f = strings.HasPrefix
		if f(T, "10") {
			T = "1" + T
		} else if f(T, "01") {
			T = "11" + T
		}

		f = strings.HasSuffix
		if f(T, "11") {
			T += "0"
		} else if f(T, "01") {
			T += "10"
		}

		if T == strings.Repeat("110", len(T)/3) {
			return 1e10 - len(T)/3 + 1
		}
		return 0
	}

	func ni() int    { var n int; fmt.Fscan(r, &n); return n }
	func ns() string { var s string; fmt.Fscan(r, &s); return s }
	```