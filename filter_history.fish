function filter_history --on-event fish_preexec
    set -l excluded_commands \
        ls cd pwd \
        v vv ll la lt l lg le \
        lsd ldot lS lsr lsn lr \
        c clear \
        e exit \
        i b dl dt \
        .. \
        reload
    
    set -l cmd_name (string split ' ' -- $argv[1])[1]
    
    if contains -- $cmd_name $excluded_commands
        history delete --exact --case-sensitive -- $argv[1]
    end
end




set -Ux fish_history_limit 100000
