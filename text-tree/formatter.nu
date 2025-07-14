use std repeat

export def format-tree [
  options: record<style: record<child: string, last_child: string, directory: string, empty: string>, auto_slashes: bool>
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
          $options.style.directory
        } else {
          $options.style.empty
        }
      }
      | append (if $item.last { $options.style.last_child } else { $options.style.child })

    let suffix = if not ($item.name | str ends-with "/") and $options.auto_slashes and $item.kind == "dir" { "/" } else { "" }
    $"($prefix_components | str join)($item | get name)($suffix)"
  } | str join (char newline)
}
