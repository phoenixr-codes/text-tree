use parser.nu [ parse-tree ]
use formatter.nu [ format-tree ]

export const tree_styles = {
  ascii: {child: "|-- ", last_child: "`-- ", directory: "|   ", empty: "    "}
  fancy: {child: "├── ", last_child: "└── ", directory: "│   ", empty: "    "}
}

@search-terms tree
@example "Create a tree from text with default style" {
"
.
  src/
    lib.rs
    main.rs
  Cargo.toml
  README.md
" | text-tree
} --result ("
.
├── src/
│   ├── lib.rs
│   └── main.rs
├── Cargo.toml
└── README.md
" | str trim)
@example "Create a tree from text with ASCII style" {
"
.
  src/
    lib.rs
    main.rs
  Cargo.toml
  README.md
" | text-tree --style $tree_styles.ascii
} --result ("
.
|-- src/
|   |-- lib.rs
|   `-- main.rs
|-- Cargo.toml
`-- README.md
" | str trim)
@example "Create a tree from text with custom style" {
"
.
  src/
    lib.rs
    main.rs
  Cargo.toml
  README.md
" | text-tree --style {child: "|-> ", last_child: "`-> ", directory: "|   ", empty: "    "}
} --result ("
.
|-> src/
|   |-> lib.rs
|   `-> main.rs
|-> Cargo.toml
`-> README.md
" | str trim)
@example "Create a tree from the current working directory" {
  glob **/* | path split | each { slice (pwd | path split | length).. } | each { prepend "." | path join } | text-tree
}
export def main [
  --style: record<child: string, last_child: string, directory: string, empty: string> = $tree_styles.fancy # The custom style to use for the output tree
  --auto-slashes                                                                                            # Automatically add slashed for items with children
]: [
  string -> string
  list<string> -> string
] {
  if ($in | describe) == "string" {
    $in | parse-tree
  } else {
    let list = $in
    $in | each {
      let depth = (($in | path split | length) - 1)
      {
        depth: $depth
        name: ($in | path split | last)
        kind: ($in | path type)
        last: (($list | where (($it | path split | length) - 1) == $depth | last) == $in)
      }
    }
  }
  | format-tree {style: $style, auto_slashes: $auto_slashes}
}
