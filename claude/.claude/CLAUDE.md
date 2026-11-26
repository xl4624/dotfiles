## Code

- Match the existing style of a project. Don't add dependencies or refactor beyond what was asked without checking first.
- Point out any workaround you introduce.
- Write code, comments, and UI text for a future reader who never saw this conversation or task:
  - Comments explain why (a non-obvious constraint, a gotcha), never what changed or what was asked. No "implemented", "fixed", "updated", "now does X", "no longer".
  - No references to the task, prompt, ticket, or review round in code, test names, or UI strings. That history goes in the commit message.
  - Don't comment what the code plainly does.
  - UI text describes the feature to the user, never how it was built or that it's new.
  - Don't claim completeness ("fully implemented", "handles all cases"); say what's untested or missing instead.

## Debugging

- Find the root cause from logs (`journalctl`, `dmesg`) before changing config. If a fix is a guess and hasn't been checked, say so.
- After changing a system setting, verify it actually applied (e.g. `systemctl status`, `hyprctl ... --verify-config`).

## System (Arch Linux)

- Dotfiles are managed with GNU stow under `~/dotfiles`. Edit the file in the repo, not the symlink in `$HOME`.
- Upgrade with `yay -Syu --devel`; never do a partial upgrade (`-Sy` alone). Check yay's output for build failures — it exits 0 even when a build fails.
- Before deleting interpreters, environments, or caches, check with `pgrep` that nothing is using them.
- Ask before changing anything under `/etc`, the bootloader, initramfs, or the kernel. User-level changes don't need confirmation.
- You have passwordless sudo and can run sudo commands normally (use `sudo -n` so a missing credential fails instead of hanging). Be careful: double-check every sudo command, including its target and flags, before running it.

## Communication

- Keep answers short: the result first, details only if they matter.
- Use absolute dates in notes and memory, not relative ones like "yesterday".

## Shell Tools

- ALWAYS use `rg` (ripgrep) instead of `grep` for searching file contents. Never use `grep`.
- ALWAYS use `fd` instead of `find` for finding files. Never use `find`.
