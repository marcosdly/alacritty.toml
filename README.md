<h1 align="center"><code>alacritty.toml</code></h1>

## Installing

Run [`generate.sh`](./generate.sh) to create the entrypoint configuration file containing the import statement.

```sh
./generate.sh
```

Then run [`install.sh`](./install.sh) to move files to alacritty's configuration directory.

```sh
./install.sh
```

### File placement

- Windows: `%APPDATA%\alacritty\`
- Linux: `$HOME/.config/alacritty/`
