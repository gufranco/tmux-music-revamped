#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../helpers.bash"

setup() {
  setup_test_environment
  unset _MUSIC_REVAMPED_MUSIC_LOADED
  source "${BATS_TEST_DIRNAME}/../../../src/lib/music/music.sh"
}

teardown() {
  cleanup_test_environment
}

@test "music.sh - music_norm_status normalizes states" {
  [[ "$(music_norm_status Playing)" == "playing" ]]
  [[ "$(music_norm_status Paused)" == "paused" ]]
  [[ "$(music_norm_status Stopped)" == "stopped" ]]
  [[ "$(music_norm_status weird)" == "unknown" ]]
}

@test "music.sh - read_music uses playerctl when present" {
  has_command() { [[ "$1" == "playerctl" ]]; }
  _read_playerctl_status() { echo "Playing"; }
  _read_playerctl_meta() { case "$1" in title) echo "Song" ;; artist) echo "Band" ;; esac; }
  run read_music
  [[ "${lines[0]}" == "Playing" ]]
  [[ "${lines[1]}" == "Song" ]]
  [[ "${lines[2]}" == "Band" ]]
}

@test "music.sh - read_music is empty when playerctl has no player" {
  has_command() { [[ "$1" == "playerctl" ]]; }
  _read_playerctl_status() { echo ""; }
  run read_music
  [[ -z "${output}" ]]
}

@test "music.sh - read_music falls back to osascript on macOS" {
  _PLATFORM_OS_CACHE="Darwin"
  has_command() { [[ "$1" == "osascript" ]]; }
  _read_osascript() { printf 'playing\nSong\nBand\n'; }
  run read_music
  [[ "${lines[0]}" == "playing" ]]
  [[ "${lines[1]}" == "Song" ]]
}

@test "music.sh - read_music is empty with no backend" {
  _PLATFORM_OS_CACHE="Linux"
  has_command() { return 1; }
  run read_music
  [[ -z "${output}" ]]
}
