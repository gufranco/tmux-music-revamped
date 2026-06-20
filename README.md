# tmux-music-revamped

Now playing in your tmux status bar, without ever blocking the status render.

Media players are queried in a detached background worker; the status line reads
the result from a tmux server user-option and returns instantly. Each backend
probe carries a timeout so a hung player never stalls the bar. No temp files are
used.

Built from
[tmux-plugin-template](https://github.com/gufranco/tmux-plugin-template).

## Placeholders

| Placeholder | Output |
|-------------|--------|
| `#{music}` | the current track, for example `Song - Band` |
| `#{music_icon}` | a play, pause, or stop icon |
| `#{music_status}` | `playing`, `paused`, `stopped`, or `unknown` |
| `#{music_title}` | the track title |
| `#{music_artist}` | the track artist |

## Install

With [TPM](https://github.com/tmux-plugins/tpm):

```tmux
set -g @plugin 'gufranco/tmux-music-revamped'
set -g status-left '#{music_icon} #{music}'
```

Press `prefix + I` to install.

## Configuration

| Option | Default | Meaning |
|--------|---------|---------|
| `@music_revamped_interval` | `5` | seconds a reading stays fresh |
| `@music_revamped_format` | `%s - %s` | format for title and artist |
| `@music_revamped_max_len` | `0` | truncate title and artist to this length, `0` disables |
| `@music_revamped_playing_icon` | `>` | icon while playing |
| `@music_revamped_paused_icon` | `\|\|` | icon while paused |
| `@music_revamped_stopped_icon` | `[]` | icon while stopped |
| `@music_revamped_unknown_icon` | empty | icon when no player is found |
| `@music_revamped_enable_logging` | `0` | set to `1` to log under `~/.tmux/music-revamped-logs` |

## Platform support

`playerctl` is used where present, on Linux and on macOS when installed. On macOS
without playerctl, Spotify is read through AppleScript. When no player is active
the placeholders render empty.

## License

[MIT](LICENSE), copyright Gustavo Franco.
