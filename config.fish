if status is-interactive

    # ============================================================================
    # FORCE RELOAD CUSTOM FUNCTIONS ON STARTUP
    # ============================================================================
    
    # Clear cached custom functions
    functions -e filter_history fzf_ctrl_t_enhanced fh
    
    # Force reload from disk
    if test -f ~/.config/fish/functions/filter_history.fish
        source ~/.config/fish/functions/filter_history.fish
    end
    if test -f ~/.config/fish/functions/fzf_ctrl_t_enhanced.fish
        source ~/.config/fish/functions/fzf_ctrl_t_enhanced.fish
    end

    # ============================================================================
    # ENVIRONMENT & PATH
    # ============================================================================

    # PATH additions
    fish_add_path ~/.config/fish/functions/
    set -gx PATH ~/bin $PATH
    set -gx PATH /usr/local/bin $PATH
    set -gx PATH $HOME/.local/bin $PATH
    set -gx PATH /opt/homebrew/sbin $PATH
    set -gx PATH /opt/homebrew/bin $PATH
    set -gx PATH /home/bnewell/go/bin $PATH
    set -Ux PATH /opt/homebrew/opt/qt@5/bin $PATH
    set -Ux PATH /opt/mssql-tools/bin $PATH
    set -Ux PATH /opt/homebrew/opt/tcl-tk/bin $PATH

    # SSL/TLS certificates
    set -x SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    set -x REQUESTS_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt

    # Homebrew
    set -x HOMEBREW_NO_INSTALL_FROM_API 1
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Editors
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # Build flags for tcl-tk
    set -Ux LDFLAGS "-L/opt/homebrew/opt/tcl-tk/lib"
    set -Ux CPPFLAGS "-I/opt/homebrew/opt/tcl-tk/include"
    set -Ux PKG_CONFIG_PATH "/opt/homebrew/opt/tcl-tk/lib/pkgconfig"

    # NVM
    export NVM_DIR='$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")'


    # ============================================================================
    # SHELL BEHAVIOR & APPEARANCE
    # ============================================================================

    # Fish colors
    set -U fish_color_match red
    set -U fish_color_search_match green
    set -U fish_color_completion green
    set -U fish_color_command cyan
    set -U fish_color_param red

    # Case insensitive completions
    set -gx fish_case_insensitive 1
    set -gx LC_COLLATE C

    # LS colors (using vivid)
    set -x LS_COLORS (vivid generate molokai)

    # Colored man pages
    set -x LESS '-R'
    set -x MANROFFOPT '-c'
    set -x LESS_TERMCAP_mb (printf '\e[01;31m')
    set -x LESS_TERMCAP_md (printf '\e[01;38;5;74m')
    set -x LESS_TERMCAP_me (printf '\e[0m')
    set -x LESS_TERMCAP_se (printf '\e[0m')
    set -x LESS_TERMCAP_so (printf '\e[01;44;33m')
    set -x LESS_TERMCAP_ue (printf '\e[0m')
    set -x LESS_TERMCAP_us (printf '\e[04;38;5;146m')

    # ============================================================================
    # KEY BINDINGS & VI MODE
    # ============================================================================

    # Enable vi key bindings FIRST
    fish_vi_key_bindings

    # Fix vi mode cursor - force block cursor in insert mode
    set fish_cursor_default block
    set fish_cursor_insert block
    set fish_cursor_replace_one block
    set fish_cursor_visual block

    # Or if you want the traditional vi cursors but more visible:
    # set fish_cursor_default block blink        # Normal mode: blinking block
    # set fish_cursor_insert line blink          # Insert mode: blinking line (but thicker)
    # set fish_cursor_replace_one underscore     # Replace mode: underscore

    # Disable FZF default keybindings (we define our own)
    set -Ux FZF_DISABLE_KEYBINDINGS 1

    # MUST rebind AFTER vi mode (vi mode clears some bindings)
    bind -M insert \cr fh                                      # Ctrl-R: history search
    bind -M default \cr fh                                     # Ctrl-R: history search (normal mode)
    bind -M insert \ct fzf_ctrl_t_enhanced                     # Ctrl-T: file selector
    bind -M default \ct fzf_ctrl_t_enhanced                    # Ctrl-T: file selector (normal mode)
    bind -M insert \cf 'commandline -i (eval $FZF_CTRL_T_COMMAND)'      # Ctrl-F: file insert
    bind -M default \cf 'commandline -i (eval $FZF_CTRL_T_COMMAND)'     # Ctrl-F: file insert (normal mode)

    # ============================================================================
    # FZF CONFIGURATION
    # ============================================================================

    # FZF Ctrl-T command and options
    set -Ux FZF_CTRL_T_COMMAND "fd --color always"
    set -Ux FZF_CTRL_T_OPTS "--ansi --raw --color 'nomatch:strip:dim:#5c6370' --gutter-raw │ --bind alt-r:toggle-raw"

    # FZF Ctrl-F command and options
    set -gx FZF_CTRL_F_COMMAND "fd --color always"
    set -gx FZF_CTRL_F_OPTS "--ansi --preview 'bat --color=always --style=numbers --line-range=:200 {}' --preview-window=right:60%"


    # ============================================================================
    # ALIASES
    # ============================================================================

    # Navigation shortcuts
    alias i="cd /mnt/c/Users/bnewell/OneDrive\ -\ WRB"
    alias b="cd ~/vault"

    # System commands
    alias c='clear'
    alias e='exit'
    alias cp='cp -i'
    alias mv='mv -i'

    # Git
    alias g='git'

    # File listing (eza/lsd)
    alias ls="eza"
    alias ll='eza -l --color=auto --group-directories-first'
    alias la='eza -la --color=auto --group-directories-first --git'
    alias lt='clear; eza -T --color=auto --group-directories-first'
    alias l='eza -d .* --color=auto'
    alias lg='eza -l --color=auto --group-directories-first --git-ignore --git'
    alias le="/bin/ls -C --color=yes | less -R"
    alias v='eza -1 --color=auto --color-scale --group-directories-first --icons --long --sort=size --time-style=long-iso --git'
    alias vv='lsd -1a'

    # Utilities
    alias cpwd="pwd | clip.exe"
    alias zj='zellij'
    alias jl="jupyter lab --no-browser --ip=127.0.0.1 --port=8888 --NotebookApp.token=''"
    alias ops='eval $(op signin)'


    # ============================================================================
    # FUNCTIONS - Navigation & Utilities
    # ============================================================================

    function dl; cd /mnt/c/Users/bnewell/Downloads; end
    function dt; cd ~/Desktop; end
    function o; open $argv; end
    function t; touch (date -I)-$argv; end
    function reload; exec fish; end
    function mcd; mkdir -p $argv; and cd $argv; end

    # Change directory with fzf
    function cdf
        set dir (fzf-cd-widget)
        if test -n "$dir"
            cd $dir
        end
    end


    # ============================================================================
    # FUNCTIONS - File Operations
    # ============================================================================

    # LSD variations
    function l; lsd -lFh; end
    function lr; clear; lsd -tRFh; end
    function ldot; lsd -ld .*; end
    function lS; lsd -1FSsh; end
    function lsr; lsd -lARFh; end
    function lsn; lsd -1; end

    # Bat with tail -f
    function batf
        set filename $argv[1]
        if not test -f "$filename"
            echo "Error: File '$filename' does not exist."
            return 1
        end
        set extension (string split -r '.' -- "$filename")[2]
        tail -f "$filename" | bat -l "$extension" --paging=never
    end

    # FZF with fd (raw mode)
    function fzf_raw
        fd --color always $argv | fzf \
            --ansi \
            --raw \
            --reverse \
            --color "nomatch:strip:dim:#5c6370" \
            --gutter-raw │ \
            --bind "alt-r:toggle-raw,up:up-match,down:down-match" \
            --preview 'bat --color=always --style=numbers --line-range=:200 {}' \
            --preview-window=right:60%
    end

    # History search with delete capability
    function fh
        set -l cmd (history --null | string split0 | fzf \
            --ansi \
            --raw \
            --reverse \
            --multi \
            --color "prompt:cyan,border:dim,spinner:green,header:yellow,marker:magenta,nomatch:dim:#5c6370" \
            --gutter-raw │ \
            --bind "ctrl-r:toggle-raw,ctrl-p:toggle-preview,ctrl-a:toggle-all" \
            --bind "ctrl-d:execute-silent(history delete --exact --case-sensitive -- {})+reload(history --null | string split0)" \
            --preview 'echo {} | bat --color=always --style=plain --language=bash' \
            --preview-window=up:40%:wrap \
            --prompt='🔍 history │ ' \
            --header='Ctrl-R raw | Ctrl-P preview | Ctrl-A mark all | Ctrl-D delete | TAB select' \
            --pointer='▶' \
            --marker='✓' \
            --height=100%)

        if test -n "$cmd"
            commandline --replace $cmd
        end
    end


    # ============================================================================
    # FUNCTIONS - Process Management
    # ============================================================================

    # FZF process kill
    function fproc
        ps aux | fzf --preview 'echo {}' --preview-window right:65% | awk '{print $2}' | xargs kill -9
    end

    function killfzf
        set pid (ps -ef | sed 1d | fzf --height 40% --reverse --preview 'ps -fp {2}' | awk '{print $2}')
        if test -n "$pid"
            if ps -o user= -p $pid | grep -q root
                echo "Root-owned process detected. Using sudo..."
                sudo kill -9 $pid
            else
                kill -9 $pid
            end
        end
    end

    function killfzf_root
        set pid (ps -ef | sed 1d | fzf --height 40% --reverse --preview 'ps -fp {1}' | awk '{print $2}')
        if test -n "$pid"
            sudo kill -9 $pid
        end
    end


    # ============================================================================
    # FUNCTIONS - Development Tools
    # ============================================================================

    # Git commit shortcut
    function gcp
        read -l -P "Enter commit message: " msg
        git add . && git commit -m "$msg" && git push
    end

    # Brew search
    function bs
        brew search $argv
    end

    # New note
    function newnote
        /bin/newnote.py $argv
    end

    # RTF clipboard test
    function cliptest
        cmd.exe /c "C:\\dev\\rtfclip\\_run.bat $argv"
    end


    # ============================================================================
    # FUNCTIONS - Applications
    # ============================================================================

    # Obsidian launcher
    function obs
        set -lx NODE_TLS_REJECT_UNAUTHORIZED 0
        ~/apps/obsidian/Obsidian.AppImage --no-sandbox &
    end

    # Obsidian updater
    function obs-update
        set -l ver (curl -ks https://api.github.com/repos/obsidianmd/obsidian-releases/releases | grep -m1 '"tag_name"' | cut -d '"' -f4)
        curl -kL -o Obsidian.AppImage https://github.com/obsidianmd/obsidian-releases/releases/download/$ver/Obsidian-$ver.AppImage
        chmod +x Obsidian.AppImage
        echo "Obsidian $ver downloaded and made executable."
    end

    # Chrome history search
    function ch
        set cols (math $COLUMNS / 3)
        set sep '{::}'
        cp ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
        sqlite3 -separator $sep /tmp/h \
            "select substr(title, 1, $cols), url from urls order by last_visit_time desc" |
            awk -F $sep '{printf "%-'$cols's \x1b[36m%s\x1b[m\n", $1, $2}' |
            fzf --ansi --multi |
            sed 's#.*\(https*://\)#\1#' |
            xargs -o open
    end

    # Colored man pages (function version)
    function man
        env \
            LESS_TERMCAP_mb=(printf "\e[1;31m") \
            LESS_TERMCAP_md=(printf "\e[1;31m") \
            LESS_TERMCAP_me=(printf "\e[0m") \
            LESS_TERMCAP_se=(printf "\e[0m") \
            LESS_TERMCAP_so=(printf "\e[1;44;33m") \
            LESS_TERMCAP_ue=(printf "\e[0m") \
            LESS_TERMCAP_us=(printf "\e[1;32m") \
            man "$argv"
    end


    # ============================================================================
    # FUNCTIONS - TMUX
    # ============================================================================

    function reload_all_fish
        for pane_id in (tmux list-panes -s -F '#{pane_id}')
            echo "Reloading Fish in pane: $pane_id"
            tmux send-keys -t $pane_id 'exec fish' C-m
        end
    end


    # ============================================================================
    # INITIALIZATION
    # ============================================================================

    # Pyenv
    pyenv init - fish | source

    # Startup message
    echo 'this is config.fish'

    if type -q zellij
      zellij setup --generate-completion fish | source
    end

end
