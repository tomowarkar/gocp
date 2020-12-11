---
title: 文字列操作
tags: 
    - golang
    - python
---

### Repeat

=== "go"
    ```go
    s := "a"
    strings.Repeat(s, 2)
    ```
=== "py"
    ```py
    s = "a"
    s * 2
    ```

##### Result:

```result
aa
```

### HasPrefix

=== "go"
    ```go
    a, b := "Gopher", "Go"
    strings.HasPrefix(a, b)
    ```
=== "py"
    ```py
    a, b = "Gopher", "Go"
    a.startswith(b)
    ```

##### Result:

```result
true
```

### HasSuffix

=== "go"
    ```go
    a, b := "Python", "on"
    strings.HasSuffix(a, b)
    ```
=== "py"
    ```py
    a, b = "Python", "on"
    a.endswith(b)
    ```

##### Result:

```result
true
```