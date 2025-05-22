#!/bin/sh

dir_name="@placeholder@"
config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/${dir_name}"
config_file="${config_dir}/configrc"

if [ -z "$xtdump" ] && [ -z "$choice" ]; then
    geom="188x38"
    name="XtermHist"

    if [ -f "$config_file" ]; then
        . "$config_file"
    fi

    # the line(s) that will be copied to clipboard
    selected=""

    xtdump="/tmp/xterm-open-$$.hst"
    choice="/tmp/xterm-open-$$.out"
    cat "$@" | sed 's|^..5||' > "$xtdump"
    export xtdump choice

    uxterm -geometry "$geom"  -T "$name" -name "$name"  -e "$0"

    selected=$(cat "$choice")
    rm "$xtdump" "$choice"

    if [ -n "$selected" ]; then
        echo "$selected" | tr -d '\n' | xclip -selection clipboard
        notify-send "copied" "$selected"
    fi
else
        cat "$xtdump" | \
        fzf \
        --height 100% \
        --header "Xterm History" \
        --header-first \
        --bind alt-k:preview-up \
        --bind alt-j:preview-down \
        --bind='pgdn:half-page-down,pgup:half-page-up' \
        --cycle --ansi -m | \
        tee > "$choice"
fi
