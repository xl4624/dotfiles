#!/usr/bin/env bash
input=$(cat)

used=$(echo "$input" | jq -r 'if .context_window.used_percentage != null then (.context_window.used_percentage | floor | tostring) else "0" end')
model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')

used_int=$(( used + 0 ))

if [ "$used_int" -ge 80 ]; then
  color="\033[31m"
elif [ "$used_int" -ge 60 ]; then
  color="\033[33m"
else
  color="\033[32m"
fi
reset="\033[0m"

mdl=${model:+" | ${model}"}
dir=$(basename "${cwd:-$(pwd)}")

printf "[$(whoami)@${dir}] | ctx: ${color}${used}%%${reset}${mdl}"
