# User Preferences

## Shell Tools

- ALWAYS use `rg` (ripgrep) instead of `grep` for searching file contents. Never use `grep`.
- ALWAYS use `fd` instead of `find` for finding files. Never use `find`.

Subagents do NOT automatically inherit this CLAUDE.md. When spawning any subagent via the Agent tool, please include these tool preferences explicitly in the prompt:
- Use `rg` (ripgrep) instead of `grep`
- Use `fd` instead of `find`
