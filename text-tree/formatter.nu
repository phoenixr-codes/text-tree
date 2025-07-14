export def format-tree [
  options: record<style: record<child: string, last_child: string, directory: string, empty: string>, auto_slashes: bool>
]: list<record<depth: int, name: string, kind: string, last: bool>> -> string {
  let items = $in
  $items | enumerate | each { |x|
    let index = $x.index
    let item = $x.item

    if ($item.depth == 0) {
      # The root level has no decoration
      return $"($item.name)"
    }

    let prefix_components = 1..($item.depth)
      | each { |offset|
        if $offset == 1 {
          # The root level is not indented
          null
        } else if ($items | enumerate | where item.depth + 1 == $offset | last | get index) > $index {
          $options.style.directory
        } else {
          $options.style.empty
        }
      }
      | append (if $item.last { $options.style.last_child } else { $options.style.child })

    let suffix = if not ($item.name | str ends-with "/") and $options.auto_slashes and $item.kind == "dir" { "/" } else { "" }
    $"($prefix_components | str join)($item.name)($suffix)"
  } | str join (char newline)
}
