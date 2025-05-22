#!/bin/sh

dir_name="@placeholder@"
config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/${dir_name}"
config_file="${config_dir}/configrc"

if [ -z "$xtdump" ] && [ -z "$choice" ]; then
    # colorscheme for fzf, by default we ship dracula
    FZF_COLORS="--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a \
                --color=hl+:#bd93f9,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6 \
                --color=spinner:#ffb86c,header:#6272a4,border:#6272a4,scrollbar:#50fa7b"

    geom="188x38"
    name="XtermHist"

    if [ -f "$config_file" ]; then
        . "$config_file"
    fi

    FZF_LAYOUT="--border=rounded --layout=reverse --header-first"
    FZF_BINDS="--bind alt-k:preview-up --bind alt-j:preview-down \
               --bind='pgdn:half-page-down,pgup:half-page-up'"
    export FZF_DEFAULT_OPTS="${FZF_LAYOUT} ${FZF_COLORS} ${FZF_BINDS}"

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
        --scrollbar='█' \
        --header "Xterm History" \
        --cycle --ansi -m | \
        tee > "$choice"
fi
