# `kosi`: Stata package to run `keep`, `order`, `sort` and `isid` in one line


## Installation

```stata
net install kosi, from(https://github.com/sergiocorreia/kosi/raw/master/)
```


## Syntax

```stata
kosi vars_isid | vars_sort | vars_order | vars_keep  [, Verbose]
```

Note: You can omit variables, so for instance `kosi ||| price` is the same as `keep price` and `kosi price` is the same as `keep price`, `order price`, `sort price`, `isid price`.


## Usage

```stata
kosi vars1 | vars2 | vars3 | vars4
```

Is equivalent to

```stata
keep  vars1 vars2 vars3 vars4
order vars1 vars2 vars3
sort  vars1 vars2
isid  vars1
```

## Details

```
       +------------------------------------+
 kosi  | <isid> | <sort> | <order> | <keep> |
       +------------------------------------+

                                            ^
 keep  +------------------------------------+

                                   ^
 order +---------------------------+

                         ^
 sort  +-----------------+

                ^
 isid  +--------+
 
 ```

 (...maybe call it `isok`?)