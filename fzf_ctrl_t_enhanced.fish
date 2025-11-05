function fzf_ctrl_t_enhanced
    # Use full-path search to include nested directories
    set -l search_cmd "fd --type f --hidden --no-ignore --exclude .git --color always --full-path ."

    # FZF options
    set -l fzf_opts --ansi --multi \
        --preview 'bat --color=always --style=numbers --line-range=:200 {}' \
        --preview-window=right:60% \
        --bind 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-/:toggle-preview' \
        --bind 'ctrl-y:execute-silent(echo {} | clip.exe)+abort' \
        --bind 'ctrl-e:execute(nvim {})' \
        --header 'Ctrl-Y: Copy | Ctrl-E: Edit | Ctrl-A: Select All'

    # Run search + fzf
    set -l selected (eval $search_cmd | fzf $fzf_opts)

    # Handle selected file(s)
    if test -n "$selected"
        if functions -q fzf_ctrl_t_post_cmd
            fzf_ctrl_t_post_cmd $selected
        end
        commandline -i (string escape -- $selected | string join ' ')
    end

    commandline -f repaint
end

