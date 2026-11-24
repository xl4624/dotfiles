## System (Arch Linux)

- Dotfiles are managed with GNU stow under `~/dotfiles`. Edit the file in the repo, not the symlink in `$HOME`.
- Upgrade with `yay -Syu --devel`; never do a partial upgrade (`-Sy` alone). Check yay's output for build failures — it exits 0 even when a build fails.
- Before deleting interpreters, environments, or caches, check with `pgrep` that nothing is using them.
- Ask before changing anything under `/etc`, the bootloader, initramfs, or the kernel. User-level changes don't need confirmation.
- You have passwordless sudo and can run sudo commands normally (use `sudo -n` so a missing credential fails instead of hanging). Be careful: double-check every sudo command, including its target and flags, before running it.

## Debugging

- Find the root cause from logs (`journalctl`, `dmesg`) before changing config. If a fix is a guess and hasn't been checked, say so.
- After changing a system setting, verify it actually applied (e.g. `systemctl status`, `hyprctl ... --verify-config`).

## Communication

- Keep answers short: the result first, details only if they matter.
- Use absolute dates in notes and memory, not relative ones like "yesterday".

## Code

- Match the existing style of a project. Don't add dependencies or refactor beyond what was asked without checking first.
- Briefly point out any workaround you introduce.

## Shell Tools

- ALWAYS use `rg` (ripgrep) instead of `grep` for searching file contents. Never use `grep`.
- ALWAYS use `fd` instead of `find` for finding files. Never use `find`.

Subagents do NOT automatically inherit this CLAUDE.md. When spawning any subagent via the Agent tool, please include these tool preferences explicitly in the prompt:
- Use `rg` (ripgrep) instead of `grep`
- Use `fd` instead of `find`

