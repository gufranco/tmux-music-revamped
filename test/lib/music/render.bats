#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../helpers.bash"

setup() {
  setup_test_environment
  unset _MUSIC_REVAMPED_RENDER_LOADED
  source "${BATS_TEST_DIRNAME}/../../../src/lib/music/render.sh"
}

teardown() {
  cleanup_test_environment
}

@test "render.sh - _music_truncate shortens long text" {
  [[ "$(_music_truncate "Hello World" 5)" == "Hello..." ]]
}

@test "render.sh - _music_truncate leaves short text" {
  [[ "$(_music_truncate "Hi" 5)" == "Hi" ]]
}

@test "render.sh - _music_truncate is a no-op for max zero" {
  [[ "$(_music_truncate "anything" 0)" == "anything" ]]
}

@test "render.sh - _music_truncate is a no-op for non-numeric max" {
  [[ "$(_music_truncate "anything" zz)" == "anything" ]]
}

@test "render.sh - music_render_now is empty without a title" {
  [[ -z "$(music_render_now "" "")" ]]
}

@test "render.sh - music_render_now joins title and artist" {
  [[ "$(music_render_now "Song" "Band")" == "Song - Band" ]]
}

@test "render.sh - music_render_now shows the title alone without an artist" {
  [[ "$(music_render_now "Song" "")" == "Song" ]]
}

@test "render.sh - music_render_now honors a custom format" {
  set_tmux_option "@music_revamped_format" "%s by %s"
  [[ "$(music_render_now "Song" "Band")" == "Song by Band" ]]
}

@test "render.sh - music_render_now truncates with max_len" {
  set_tmux_option "@music_revamped_max_len" "4"
  [[ "$(music_render_now "LongTitle" "LongArtist")" == "Long... - Long..." ]]
}

@test "render.sh - music_render_icon returns defaults per status" {
  [[ "$(music_render_icon playing)" == ">" ]]
  [[ "$(music_render_icon paused)" == "||" ]]
  [[ "$(music_render_icon stopped)" == "[]" ]]
  [[ -z "$(music_render_icon unknown)" ]]
}

@test "render.sh - music_render_icon honors a custom icon" {
  set_tmux_option "@music_revamped_playing_icon" "PLAY"
  [[ "$(music_render_icon playing)" == "PLAY" ]]
}

@test "render.sh - music_render_text echoes its input" {
  [[ "$(music_render_text "hello")" == "hello" ]]
}
