#!/usr/bin/env bash
#
# Set up (or audit) this machine from the dotfiles repo.
#
#   ./bootstrap.sh            install everything, idempotent
#   ./bootstrap.sh --check    report drift only, change nothing
#
# Safe to re-run. In install mode nothing is overwritten: if a real file sits
# where a symlink belongs, the conflict is reported and that package is skipped
# rather than clobbered.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK=0
DRIFT=0

OHMYZSH="$HOME/.oh-my-zsh"
ZSH_PLUGINS="$OHMYZSH/custom/plugins"

# oh-my-zsh plugins that are git clones rather than packages.
declare -Ar ZSH_PLUGIN_REPOS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
)

case "${1:-}" in
    --check) CHECK=1 ;;
    "")      ;;
    *)       echo "usage: $0 [--check]" >&2; exit 2 ;;
esac

c_red=$'\033[31m'; c_green=$'\033[32m'; c_yellow=$'\033[33m'
c_bold=$'\033[1m'; c_reset=$'\033[0m'

section() { printf '\n%s==> %s%s\n' "$c_bold" "$1" "$c_reset"; }
ok()      { printf '  %s✓%s %s\n' "$c_green" "$c_reset" "$1"; }
warn()    { printf '  %s!%s %s\n' "$c_yellow" "$c_reset" "$1"; DRIFT=1; }
err()     { printf '  %s✗%s %s\n' "$c_red" "$c_reset" "$1"; DRIFT=1; }

# Report an action; performs it only when not in --check mode.
# Usage: act "<description>" <command...>
act() {
    local desc=$1; shift
    if (( CHECK )); then
        warn "$desc (would run: $*)"
    else
        printf '  → %s\n' "$desc"
        "$@"
    fi
}

# ---------------------------------------------------------------- preflight

section "Preflight"

if (( EUID == 0 )); then
    echo "Refusing to run as root: stow would create root-owned symlinks in \$HOME." >&2
    exit 1
fi

for cmd in git stow pacman; do
    if command -v "$cmd" >/dev/null; then
        ok "$cmd present"
    else
        err "$cmd missing — install it first (pacman -S $cmd)"
        # stow and git are hard requirements for every later step.
        (( CHECK )) || exit 1
    fi
done

# ---------------------------------------------------------------- packages

section "Packages"

missing_repo=()
while IFS= read -r pkg; do
    [[ -z $pkg || $pkg == \#* ]] && continue
    pacman -Qq "$pkg" &>/dev/null || missing_repo+=("$pkg")
done < "$DOTFILES/pkglist-repo.txt"

if (( ${#missing_repo[@]} == 0 )); then
    ok "all $(grep -cve '^\s*$' "$DOTFILES/pkglist-repo.txt") repo packages installed"
else
    warn "${#missing_repo[@]} repo packages missing: ${missing_repo[*]}"
    (( CHECK )) || sudo pacman -S --needed --noconfirm "${missing_repo[@]}"
fi

# yay is itself an AUR package, so it has to be built from source once before
# it can install anything else.
if ! command -v yay >/dev/null; then
    if (( CHECK )); then
        warn "yay missing — needed for $(grep -cve '^\s*$' "$DOTFILES/pkglist-aur.txt") AUR packages"
    else
        printf '  → bootstrapping yay from source\n'
        sudo pacman -S --needed --noconfirm base-devel git
        tmp=$(mktemp -d)
        git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay"
        (cd "$tmp/yay" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
else
    ok "yay present"
fi

if command -v yay >/dev/null; then
    missing_aur=()
    while IFS= read -r pkg; do
        [[ -z $pkg || $pkg == \#* ]] && continue
        pacman -Qq "$pkg" &>/dev/null || missing_aur+=("$pkg")
    done < "$DOTFILES/pkglist-aur.txt"

    if (( ${#missing_aur[@]} == 0 )); then
        ok "all $(grep -cve '^\s*$' "$DOTFILES/pkglist-aur.txt") AUR packages installed"
    else
        warn "${#missing_aur[@]} AUR packages missing: ${missing_aur[*]}"
        # Never pass --sudoloop: it runs `sudo -v`, which re-authenticates
        # unconditionally and fails in non-TTY sessions even under NOPASSWD.
        (( CHECK )) || yay -S --needed --noconfirm "${missing_aur[@]}"
    fi
fi

# ---------------------------------------------------------------- submodules

section "Submodules"

if [[ -f "$DOTFILES/.gitmodules" ]]; then
    # An uninitialised submodule shows a leading '-' in `git submodule status`.
    uninit=$(git -C "$DOTFILES" submodule status --recursive | grep -c '^-' || true)
    if (( uninit == 0 )); then
        ok "all submodules initialised"
    else
        warn "$uninit submodule(s) not initialised"
        (( CHECK )) || git -C "$DOTFILES" submodule update --init --recursive
    fi
fi

# ---------------------------------------------------------------- oh-my-zsh

section "Zsh environment"

if [[ -d $OHMYZSH ]]; then
    ok "oh-my-zsh present"
else
    # Deliberately a plain clone: the upstream install.sh overwrites ~/.zshrc,
    # which is a symlink into this repo and must not be replaced.
    act "clone oh-my-zsh" \
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$OHMYZSH"
fi

for plugin in "${!ZSH_PLUGIN_REPOS[@]}"; do
    if [[ -d "$ZSH_PLUGINS/$plugin" ]]; then
        ok "plugin $plugin present"
    else
        act "clone plugin $plugin" \
            git clone --depth 1 "${ZSH_PLUGIN_REPOS[$plugin]}" "$ZSH_PLUGINS/$plugin"
    fi
done

if [[ ${SHELL:-} == */zsh ]]; then
    ok "login shell is zsh"
else
    warn "login shell is ${SHELL:-unset}, not zsh (fix: chsh -s /usr/bin/zsh)"
fi

# ---------------------------------------------------------------- stow

section "Symlinks (stow)"

# Every top-level non-hidden directory is a stow package; discovered rather than
# listed so adding a package needs no edit here. Hidden directories are repo
# metadata (.git, .claude) and are never packages.
mapfile -t packages < <(
    find "$DOTFILES" -maxdepth 1 -mindepth 1 -type d -not -name '.*' -printf '%f\n' | sort
)

for pkg in "${packages[@]}"; do
    # --no --verbose simulates and prints what it *would* do; any conflict shows
    # up on stderr, so a clean simulation means the package is safe to stow.
    if conflicts=$(stow --no --verbose --target="$HOME" --dir="$DOTFILES" "$pkg" 2>&1 >/dev/null \
                   | grep -E '^\s*\*|conflict' || true); [[ -n $conflicts ]]; then
        err "$pkg has conflicts:"
        printf '      %s\n' "$conflicts"
        continue
    fi

    # A package with nothing left to do produces no output in simulation.
    pending=$(stow --no --verbose --target="$HOME" --dir="$DOTFILES" "$pkg" 2>&1 >/dev/null \
              | grep -E '^(LINK|MKDIR|UNLINK)' || true)

    if [[ -z $pending ]]; then
        ok "$pkg linked"
    else
        act "stow $pkg" stow --target="$HOME" --dir="$DOTFILES" "$pkg"
    fi
done

# ---------------------------------------------------------------- summary

section "Summary"

if (( DRIFT == 0 )); then
    printf '  %sMachine matches the repo.%s\n\n' "$c_green" "$c_reset"
    exit 0
fi

if (( CHECK )); then
    printf '  %sDrift found — run ./bootstrap.sh to fix.%s\n\n' "$c_yellow" "$c_reset"
    exit 1
fi

printf '  %sBootstrap finished. Re-run with --check to confirm.%s\n\n' "$c_green" "$c_reset"
