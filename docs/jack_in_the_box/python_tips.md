---
title: あまり知らなかった Python の書き方
tags: 
    - python
---

```
Python 3.8.0 (v3.8.0:fa919fdf25, Oct 14 2019, 10:23:27) 
[Clang 6.0 (clang-600.0.57)] on darwin
```

## Tips 1

```python
>>> [1, 2][False]
1
>>> [1, 2][True]
2
```

### なぜこうなる?

```python
>>> True == 1
True
>>> False == 0
True
```

!!! Note
    整数には 整数(int) と ブール値(bool) の二つのタイプがあります。

    [3. Data model — Python 3.9.1 documentation](https://docs.python.org/3/reference/datamodel.html#index-10)

    ```python
    >>> int.__base__
    <class 'object'>
    
    >>> int.__subclasses__()
    [<class 'bool'>]
    ```


短絡評価
```py
>>> print("1st") or print("2nd")
1st
2nd
>>> print("3rd") and print("4th")
3rd
```
