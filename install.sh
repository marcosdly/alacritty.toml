#! /usr/bin/env bash

is_wsl() {
  local SYSCORE=/mnt/c/Windows/System32

  if [[ $(systemd-detect-virt --container) == "wsl" ||
  -d "$SYSCORE" &&
  -x "$SYSCORE/powershell.exe" &&
  -x "$SYSCORE/cmd.exe" ]]; then
    return 0
  fi
  return 1
}

get_windows_env() {
  local VAR=$1
  cmd.exe /c echo "%$VAR%"
}

# Only absolute paths
win_path_to_wsl() {
  local WINPATH=$1
  local CONVERTED
  CONVERTED=$(echo "$WINPATH" | sed -E 's@\\@/@g' | tr -d '\r')
  printf '%s' "$CONVERTED"
}

main() {
  local PREFIX

  if is_wsl; then
    PREFIX="$(win_path_to_wsl "$(get_windows_env APPDATA)")"
  else
    PREFIX="$HOME/.config"
  fi

  ./generate.sh --prefix "$PREFIX"

  cp -r ./alacritty "$PREFIX"
}

main
