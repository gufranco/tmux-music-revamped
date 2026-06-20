#!/usr/bin/env bash
#
# music.sh: now-playing acquisition across backends.
#
# read_music returns three lines: status, title, artist. playerctl is preferred
# where present, with an AppleScript Spotify fallback on macOS. Each probe sits
# behind a seam tests override. music_norm_status is pure.

[[ -n "${_MUSIC_REVAMPED_MUSIC_LOADED:-}" ]] && return 0
_MUSIC_REVAMPED_MUSIC_LOADED=1

_MUSIC_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${_MUSIC_LIB_DIR}/../utils/platform.sh"
# shellcheck source=/dev/null
source "${_MUSIC_LIB_DIR}/../utils/has-command.sh"

# music_norm_status RAW -> playing|paused|stopped|unknown.
music_norm_status() {
  case "$(printf '%s' "${1}" | tr '[:upper:]' '[:lower:]')" in
    *playing*) echo "playing" ;;
    *paused*)  echo "paused" ;;
    *stopped*) echo "stopped" ;;
    *)         echo "unknown" ;;
  esac
}

# Host-probe seams.
_read_playerctl_status() { playerctl status 2>/dev/null; }
_read_playerctl_meta() { playerctl metadata "${1}" 2>/dev/null; }
_read_osascript() {
  osascript 2>/dev/null <<'APPLESCRIPT'
on run
  if application "Spotify" is running then
    tell application "Spotify"
      set st to player state as string
      set tt to name of current track
      set ar to artist of current track
      return st & linefeed & tt & linefeed & ar
    end tell
  end if
end run
APPLESCRIPT
}

# read_music -> three lines (status, title, artist), or nothing when idle.
read_music() {
  if has_command playerctl; then
    local status
    status=$(_read_playerctl_status)
    [[ -z "${status}" ]] && return 0
    printf '%s\n%s\n%s\n' \
      "${status}" "$(_read_playerctl_meta title)" "$(_read_playerctl_meta artist)"
  elif is_macos && has_command osascript; then
    _read_osascript
  fi
}

export -f music_norm_status
export -f _read_playerctl_status
export -f _read_playerctl_meta
export -f _read_osascript
export -f read_music
