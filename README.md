# dotfiles

Arch Linux + Hyprland configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

Secrets (`~/.ssh`, `~/.config/gh`, password-manager state) are not tracked and
must never be added. Create an SSH key and add it to GitHub before cloning.

```sh
sudo pacman -S --needed git stow
git clone --recurse-submodules git@github.com:xl4624/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

Do not run `bootstrap.sh` as root.

```sh
./bootstrap.sh --check          # report drift, change nothing; exits 1 on drift
./bootstrap.sh --sync-pkglists  # regenerate pkglist-{repo,aur}.txt from installed packages
```

## Layout

Each top-level directory is a stow package mirroring `$HOME`
(`hypr/.config/hypr/` → `~/.config/hypr/`). To add one:

```sh
mkdir -p newapp/.config
mv ~/.config/newapp newapp/.config/
stow -t ~ newapp
```

## Gotchas

- Hyprland comes from AUR `-git` packages, which break when a dependency's ABI
  changes. Rebuild with `yay -S --rebuildtree hyprland-git`.
- Don't use `yay --sudoloop`. It runs `sudo -v`, which fails in non-TTY
  sessions even with `NOPASSWD`.
