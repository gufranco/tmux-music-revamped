# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-19

### Added

- Now-playing placeholders: `#{music}`, `#{music_icon}`, `#{music_status}`,
  `#{music_title}`, `#{music_artist}`.
- Non-blocking design: the player query runs in a background worker and values
  are read from tmux user-options, with no temp files.
- `playerctl` backend with an AppleScript Spotify fallback on macOS.
- Configurable format, truncation length, and status icons.
