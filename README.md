<h1 align="center"><code>alacritty.toml</code></h1>

## Requirements

- WSL2 or Linux
- Python 3.7 or greater

## Installing

Run [`install.py`](./install.py) to generate an entrypoint file and copy it to alacritty's configuration directory. Alacritty will load the files from the folder you cloned this repository in.

```sh
python ./install.py
```

### File placement

- Windows: `%APPDATA%\alacritty\alacritty.toml`
- Linux: `$HOME/.config/alacritty/alacritty.toml`
