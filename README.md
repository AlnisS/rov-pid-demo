# ROV PID Demo

PID control demo for ROV using Godot.

Works in Godot 3.5.1.

## Building HTML output

On macOS (assuming Godot.app is renamed & placed as shown):
```sh
'/Applications/Godot 3.5.1.app'/contents/MacOS/Godot --headless --export HTML5
```

On Linux (see build.sh):
```sh
godot-build-data/3.5.1/Godot_v3.5.1-stable_linux_headless.64 --headless --export HTML5
```

## Automated build & deploy

For static hosting like Cloudflare and Netlify, use the following configuration:

| Key | Value |
|-|-|
| Framework preset |  None |
| Build command | `./build.sh` |
| Build output (publish) directory | `build/html` |


