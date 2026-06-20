#!/usr/bin/env bash
#
# render.sh: map cached now-playing values to text and an icon.

[[ -n "${_MUSIC_REVAMPED_RENDER_LOADED:-}" ]] && return 0
_MUSIC_REVAMPED_RENDER_LOADED=1

_MUSIC_RENDER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${_MUSIC_RENDER_DIR}/../tmux/tmux-ops.sh"

# _music_truncate TEXT MAX -> TEXT shortened to MAX characters with an ellipsis.
_music_truncate() {
  local text="${1}" max="${2}"
  [[ "${max}" =~ ^[0-9]+$ ]] || { echo "${text}"; return 0; }
  (( max <= 0 )) && { echo "${text}"; return 0; }
  if (( ${#text} > max )); then
    echo "${text:0:max}..."
  else
    echo "${text}"
  fi
}

music_render_now() {
  local title="${1}" artist="${2}"
  [[ -z "${title}" ]] && { echo ""; return 0; }
  local max
  max=$(get_tmux_option "@music_revamped_max_len" "0")
  title=$(_music_truncate "${title}" "${max}")
  if [[ -z "${artist}" ]]; then
    echo "${title}"
    return 0
  fi
  artist=$(_music_truncate "${artist}" "${max}")
  local fmt
  fmt=$(get_tmux_option "@music_revamped_format" "%s - %s")
  # shellcheck disable=SC2059
  printf "${fmt}" "${title}" "${artist}"
}

music_render_icon() {
  case "${1:-unknown}" in
    playing) get_tmux_option "@music_revamped_playing_icon" ">" ;;
    paused)  get_tmux_option "@music_revamped_paused_icon" "||" ;;
    stopped) get_tmux_option "@music_revamped_stopped_icon" "[]" ;;
    *)       get_tmux_option "@music_revamped_unknown_icon" "" ;;
  esac
}

music_render_text() {
  echo "${1}"
}

export -f _music_truncate
export -f music_render_now
export -f music_render_icon
export -f music_render_text
