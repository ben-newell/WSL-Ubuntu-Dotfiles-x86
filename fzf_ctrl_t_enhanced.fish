function fzf_ctrl_t_enhanced
    set -l search_cmd (set -q FZF_CTRL_T_COMMAND; and echo $FZF_CTRL_T_COMMAND; or echo "fd --color always")
    
    # Complete FZF options (don't append user opts)
    set -l fzf_opts --ansi --multi \
        --preview 'bat --color=always --style=numbers --line-range=:200 {}' \
        --preview-window=right:60% \
        --bind 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-/:toggle-preview' \
        --bind 'ctrl-y:execute-silent(echo {} | clip.exe)+abort' \
        --bind 'ctrl-e:execute(nvim {})' \
        --header 'Ctrl-Y: Copy | Ctrl-E: Edit | Ctrl-A: Select All'
    
    # REMOVED: if set -q FZF_CTRL_T_OPTS block
    
    set -l selected (eval $search_cmd | fzf $fzf_opts)
    
    if test -n "$selected"
        if functions -q fzf_ctrl_t_post_cmd
            fzf_ctrl_t_post_cmd $selected
        end
        
        commandline -i (string escape -- $selected | string join ' ')
    end
    
    commandline -f repaint
end
