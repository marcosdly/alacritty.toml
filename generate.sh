#! /usr/bin/env bash

declare ARG_PREFIX

parse_args() {
  if [[ "$1" == "--prefix" ]]; then
    ARG_PREFIX="$2"
  fi
}

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
  HERE="$(dirname "${BASH_SOURCE[0]}")"
  PATH_LIST=$(
    # shellcheck disable=SC2086
    echo "$PATH_ARRAY" |
      xargs realpath --relative-to="$HERE" |
      sed "s@^@$ARG_PREFIX/@" |
      xargs realpath -m |
      sed 's/^/  "/' |
      sed 's/$/",/'
  )

  printf '%s\nimport = [\n%s\n]\n' "$TOP_COMMENT" "$PATH_LIST"
}

main() {
  parse_args "$@"

  if [ -x "$(command -v tee)" ]; then
    make_toml "${IMPORTS[@]}" | tee "$OUTPUT"
    return 0
  fi

  make_toml "${IMPORTS[@]}" >"$OUTPUT"
  return 0
}

main "$@"
