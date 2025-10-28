function findproc
    set -l selected (ps aux | sed 1d | fzf \
        --ansi \
        --reverse \
        --multi \
        --header-lines=0 \
        --color "prompt:cyan,border:dim,spinner:green,header:yellow,marker:magenta,nomatch:dim:#5c6370" \
        --gutter-raw │ \
        --preview 'echo "=== Process Details ===" && ps -fp {2} && echo "" && echo "=== Command Line ===" && ps -o cmd= -p {2} && echo "" && echo "=== Open Files ===" && lsof -p {2} 2>/dev/null | head -20' \
        --preview-window=up:50%:wrap \
        --prompt='🔍 processes │ ' \
        --header='ENTER: select for kill | Ctrl-K: graceful kill-15 | Ctrl-X: force kill-9 | Ctrl-T: TERM signal | TAB: multi-select | Ctrl-A: select all | Ctrl-R: reload | ESC: cancel' \
        --pointer='▶' \
        --marker='✓' \
        --bind 'ctrl-k:execute-silent(kill -15 {2})+reload(ps aux | sed 1d)' \
        --bind 'ctrl-x:execute-silent(kill -9 {2})+reload(ps aux | sed 1d)' \
        --bind 'ctrl-t:execute-silent(kill -TERM {2})+reload(ps aux | sed 1d)' \
        --bind 'ctrl-r:reload(ps aux | sed 1d)' \
        --bind 'ctrl-a:select-all' \
        --bind 'ctrl-d:deselect-all' \
        --bind 'ctrl-p:toggle-preview' \
        --height=100%)
    
    if test -n "$selected"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Selected processes for termination:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Parse selected processes
        set -l pids
        set -l users
        set -l cmds
        
        echo $selected | while read -l line
            set -l pid (echo $line | awk '{print $2}')
            set -l user (echo $line | awk '{print $1}')
            set -l cmd (echo $line | awk '{for(i=11;i<=NF;i++) printf $i" "; print ""}' | string trim)
            
            set -a pids $pid
            set -a users $user
            set -a cmds $cmd
            
            echo ""
            echo "  🔹 PID: $pid"
            echo "     User: $user"
            echo "     Command: $cmd"
        end
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Confirmation
        if test (count $pids) -eq 1
            read -l -P "Kill this process with -9? (y/N): " confirm
        else
            read -l -P "Kill these "(count $pids)" processes with -9? (y/N): " confirm
        end
        
        if test "$confirm" = "y" -o "$confirm" = "Y"
            echo ""
            for i in (seq (count $pids))
                set -l pid $pids[$i]
                set -l user $users[$i]
                
                if test "$user" = "root"
                    echo "  ⚡ Killing PID $pid (root) with sudo..."
                    sudo kill -9 $pid
                    and echo "     ✓ Successfully killed PID $pid"
                    or echo "     ✗ Failed to kill PID $pid"
                else
                    echo "  ⚡ Killing PID $pid..."
                    kill -9 $pid
                    and echo "     ✓ Successfully killed PID $pid"
                    or echo "     ✗ Failed to kill PID $pid"
                end
            end
            echo ""
            echo "✅ Process termination complete"
        else
            echo ""
            echo "❌ Cancelled - no processes killed"
        end
        echo ""
    end
end
