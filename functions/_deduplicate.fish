function _deduplicate --description "Remove duplicates from variable"
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                _increment count
            else
                set newvar $newvar $v
            end
        end
        set $argv $newvar
    else
        for a in $argv
            _deduplicate $a
        end
    end
end
