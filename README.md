# Text Tree

`text-tree` is a CLI tool written in Nushell that transforms textual
representation of trees into pretty ones:

## Usage

```nu
"
project/
  lib/
  README.md
" | text-tree
```

```nu
glob **/* --exclude ["**/.git/**"] | str substring ((pwd | str length) + 1).. | text-tree
```
