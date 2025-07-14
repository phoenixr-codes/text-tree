# Text Tree

`text-tree` is a CLI tool written in Nushell that transforms textual
representation of trees into pretty ones:

![Preview GIF](./tapes/usage.gif)

## Basic Usage

From text:

```nu
"
project/
  lib/
  README.md
" | text-tree
```

From path list:

```nu
glob **/* | path split | each { slice (pwd | path split | length).. } | each { prepend "." | path join } | text-tree
```
