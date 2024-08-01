#! /usr/bin/env bash

OUTPUT=./alacritty/alacritty.toml
IMPORTS=(
  ./alacritty/window.toml
  ./alacritty/motion.toml
  ./alacritty/keymap.toml
  ./alacritty/appearance.toml
  ./alacritty/shell.toml
)

make_toml() {
  PATH_ARRAY="$*"
  TOP_COMMENT='# THIS FILE WAS GENERATED AUTOMARICALLY
# DO NOT CHANGE IT
# See: github.com/marcosdly/allacritty.toml
# License: MIT
# Please drop a star, feedback or suggestion.
  '
  PATH_LIST=$(
    # shellcheck disable=SC2086
    echo "$PATH_ARRAY" |
      xargs realpath |
      sed 's/^/  "/' |
      sed 's/$/",/'
  )

  printf '%s\nimport = [\n%s\n]\n' "$TOP_COMMENT" "$PATH_LIST"
}

main() {
  if [ -x "$(command -v tee)" ]; then
    make_toml "${IMPORTS[@]}" | tee "$OUTPUT"
    return 0
  fi

  make_toml "${IMPORTS[@]}" >"$OUTPUT"
  return 0
}

main
