#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../helpers.bash"

setup() {
  setup_test_environment
  unset _MUSIC_REVAMPED_MUSIC_LOADED _MUSIC_REVAMPED_RENDER_LOADED
  export CACHE_SYNC=1
  source "${BATS_TEST_DIRNAME}/../../../src/music.sh"
  read_music() { printf 'Playing\nSong\nBand\n'; }
}

teardown() {
  cleanup_test_environment
}

@test "music.sh dispatcher - functions are defined" {
  function_exists main
  function_exists music_refresh
  function_exists music_tick
  function_exists music_max_age
}

@test "music.sh dispatcher - music_max_age default is 5" {
  [[ "$(music_max_age)" == "5" ]]
}

@test "music.sh dispatcher - music_max_age honors the interval option" {
  set_tmux_option "@music_revamped_interval" "3"
  [[ "$(music_max_age)" == "3" ]]
}

@test "music.sh dispatcher - music_refresh caches status, title, artist" {
  music_refresh
  [[ "$(cache_get status)" == "playing" ]]
  [[ "$(cache_get title)" == "Song" ]]
  [[ "$(cache_get artist)" == "Band" ]]
}

@test "music.sh dispatcher - refresh subcommand caches values" {
  main refresh
  [[ "$(cache_get title)" == "Song" ]]
}

@test "music.sh dispatcher - now renders the cached track" {
  run main now
  [[ "${output}" == "Song - Band" ]]
}

@test "music.sh dispatcher - icon maps the cached status" {
  run main icon
  [[ "${output}" == ">" ]]
}

@test "music.sh dispatcher - status, title, artist echo cached values" {
  run main status
  [[ "${output}" == "playing" ]]
  run main title
  [[ "${output}" == "Song" ]]
  run main artist
  [[ "${output}" == "Band" ]]
}

@test "music.sh dispatcher - now is empty when idle" {
  read_music() { return 0; }
  run main now
  [[ -z "${output}" ]]
}

@test "music.sh dispatcher - unknown subcommand produces no output" {
  run main bogus
  [[ -z "${output}" ]]
}
