use parser.nu [ parse-tree ]
use formatter.nu [ format-tree ]

const default_style = {child: "├── ", last_child: "└── ", directory: "│   ", empty: "    "}

# Transforms a simple indented text tree into a pretty one.
@example "Create a tree with default style" { text-tree "project\n  lib" } --result "└── project\n    └── lib"
export def main [
  input: string                                                                                         # The string representation of the tree
  --style: record<child: string, last_child: string, directory: string, empty: string> = $default_style # The custom style to use for the output tree
]: nothing -> string {
  $input | parse-tree | format-tree $style
}

# Transforms a directory into a text tree.
export def "main path" [
  path: path                                                                                            # The path to the directory
  --style: record<child: string, last_child: string, directory: string, empty: string> = $default_style # The custom style to use for the output tree
] {
  # TODO
}
