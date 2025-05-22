#!/bin/sh

dir_name="shell"
config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/${dir_name}"
config_file="${config_dir}/fzfrc"

if [ -f "$config_file" ]; then
    # shellcheck source=/home/ed/.config/shell/fzfrc
    . "$config_file"
fi

xtdump="/tmp/xterm-open.hst"
choice="/tmp/xterm-open.out"
cat "$@" | sed 's|^..5| |' > "$xtdump"
export xtdump choice
uxterm -geometry 188x40 -T XtermHist -e sh -c '\
    cat "$xtdump" | \
    fzf \
    --height 100% \
    --header "Xterm History" \
    --header-first \
    --cycle --ansi -m | \
    tee > "$choice"'
selected=$(cat "$choice")
rm "$xtdump" "$choice"

if [ -n "$selected" ]; then
    echo "$selected" | tr -d '\n' | xclip -selection clipboard
    notify-send "copied" "$selected"
fi
