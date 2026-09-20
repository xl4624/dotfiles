# dotfiles

Arch Linux + Hyprland (Wayland) configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup on a new machine

### Prerequisites: access

Secrets are deliberately **not** in this repo, so set up GitHub access before
cloning — the command below uses SSH and will fail without a key:

```sh
ssh-keygen -t ed25519 -C "you@example.com"   # then add the .pub key to GitHub
gh auth login                                # for gh; not needed just to clone
```

### Install

```sh
sudo pacman -S --needed git stow
git clone --recurse-submodules git@github.com:xl4624/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

That installs every package (repo + AUR), initialises submodules, clones
oh-my-zsh and its plugins, and symlinks all configs into `$HOME`.

If cloning over HTTPS instead, or if you forgot `--recurse-submodules`,
`bootstrap.sh` initialises submodules for you.

## Auditing an existing machine

```sh
./bootstrap.sh --check
```

Checks for missing packages, unstowed configs, absent submodules and
changes nothing. Exits `0` when the machine matches the repo, `1` when it does
not.

## Layout

Each top-level directory is a stow package whose contents mirror `$HOME`:

```
zsh/.zshrc              →  ~/.zshrc
hypr/.config/hypr/      →  ~/.config/hypr/
```

Hidden top-level directories (`.git`, `.claude`) are repo metadata, not
packages, and are skipped by `bootstrap.sh`.

| Package | Contents |
| --- | --- |
| `zsh` | `.zshrc`, `.zprofile`, `.p10k.zsh` |
| `git` | `.gitconfig`, `.gitignore_global`, `.gitmessage` |
| `hypr` | Hyprland (Lua config — 0.56+ dropped `hyprland.conf`) |
| `waybar`, `dunst`, `rofimoji` | Bar, notifications, emoji picker |
| `networkmanager-dmenu` | Wi-Fi picker (`Super + N`), rendered through rofi |
| `nvim`, `tmux`, `btop`, `jj`, `zathura` | Editor and CLI tools |
| `kitty`, `alacritty`, `ghostty`, `wezterm` | Terminals |
| `gtk` | GTK 3 theme and font settings |
| `xremap`, `libinput-gestures` | Key remapping, touchpad gestures |
| `systemd` | User units (`tmux.service`) |
| `claude` | Claude Code settings and commands |

## Managing packages

Two lists, because AUR packages need `yay` rather than `pacman`:

- `pkglist-repo.txt` — official repositories
- `pkglist-aur.txt` — AUR

Both are generated files — regenerate them after installing or removing
things rather than editing by hand:

```sh
./bootstrap.sh --sync-pkglists
```

That rewrites both lists from what is installed, prints what it added and
removed, and leaves committing to you. `./bootstrap.sh --check` reports the
drift in both directions: packages listed but not installed, and packages
installed but not listed.

## Adding a config

```sh
mkdir -p newapp/.config/newapp
mv ~/.config/newapp/* newapp/.config/newapp/
rmdir ~/.config/newapp
stow -t ~ newapp
```

`bootstrap.sh` discovers packages from the directory listing, so nothing needs
editing there.

## Notes

- **Editing a file under `~/.config/` edits this repo** — those paths are
  symlinks. Commit after changing anything.
- **Never run `bootstrap.sh` as root**; it refuses, since that would create
  root-owned symlinks in `$HOME`.
- **Secrets are deliberately excluded.** `~/.config/gh` (GitHub OAuth token),
  `~/.ssh`, and password-manager state are not tracked and must not be added.
  They have to be recreated by hand on a new machine — see
  [Prerequisites](#prerequisites-access).
- **Hyprland comes from AUR `-git` packages**, which break on dependency ABI
  bumps. Fix with `yay -S --rebuildtree hyprland-git` and verify with `ldd`.
- **Never pass `yay --sudoloop`** here: it runs `sudo -v`, which re-authenticates
  unconditionally and fails in non-TTY sessions even under `NOPASSWD`.
