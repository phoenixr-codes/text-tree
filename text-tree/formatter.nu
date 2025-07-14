use std repeat

export def format-tree [
  style: record<child: string, last_child: string, directory: string, empty: string>
]: list<record<depth: int, name: string, kind: string, last: bool>> -> string {
  let items = $in
  $items | enumerate | each { |x|
    let index = $x.index
    let item = $x.item

    let prefix_components = 0..($item.depth - 1)
      | each { |offset|
        if ($item.depth == 0) {
          null
        } else if ($items | enumerate | where item.depth == $offset | last | get index) > $index {
          $style.directory
        } else {
          $style.empty
        }
      }
      | append (if $item.last { $style.last_child } else { $style.child })

    $"($prefix_components | str join)($item | get name)"
  } | str join (char newline)
}
