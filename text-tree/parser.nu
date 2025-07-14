# Returns the structural representation of a text tree.
#
# - `depth` is the depth of the directory/file in the tree starting from 0.
# - `name` is the directory/file name (not the full path, only the last component).
# - `kind` is either "dir" or "file".
# - `last` is `true` when the directory/file is the last of its parent directory.
export def parse-tree []: string -> list<record<depth: int, name: string, kind: string, last: bool>> {
  if ($in | str trim | is-empty) {
    return []
  }
  let lines = $in | str trim | lines

  # Get the minimum indentation level
  let indentation = $lines | each { split chars | take while { $in == " " }} | skip | math min | length

  let shifted = $lines | skip | append [null]

  let items = $lines | zip $shifted | each {
    let line = $in | get 0
    let next_line = $in | get 1

    let depth = $line | depth $indentation
    let depth_below = if $next_line == null { null } else { $next_line | depth $indentation }

    {
      depth: $depth
      name: ($line | str trim --left)
      kind: (if ($line | str ends-with "/") or $depth_below != null and ($depth_below > $depth) { "dir" } else { "file" })
      last: ($depth_below == null or $depth_below < $depth)
    }
  }

  # Set `last` for each depth's last item
  mut output = []
  mut checked = []
  for item in ($items | reverse) {
    if not ($item.depth in $checked) {
      $output = $output | append ($item | update last true)
      $checked = $checked | append $item.depth
    } else {
      $output = $output | append $item
    }
  }

  $output | reverse
}

def depth [indentation: int]: string -> int {
  ($in | split chars | take while { $in == " " } | length ) // $indentation
}
