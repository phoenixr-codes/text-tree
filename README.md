# Text Tree

`text-tree` is a CLI tool written in Nushell that transforms textual
representation of trees into pretty ones:

![Preview GIF](./tapes/usage.gif)

## Basic Usage

From text:

```nu
use text-tree
"
project/
  lib/
  README.md
" | text-tree
```

From path list:

```nu
use text-tree
glob **/* | path split | each { slice (pwd | path split | length).. } | each { prepend "." | path join } | text-tree
```

## Installation

### With `nupm`

```sh
git clone https://github.com/phoenixr-codes/text-tree.git
cd text-tree
nupm install --path .
```
