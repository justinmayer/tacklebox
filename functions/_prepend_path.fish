function _prepend_path -d "Prepend the given path, if it exists, to the specified
    path list. If no list specified, defaults to $PATH" --no-scope-shadowing
    set -l path "$argv[1]"
    set -l list PATH
    if set -q argv[2]
        set list $argv[2]
    end

    if test -d $path
        # if the path is already in the list, remove it first.
        # Prepending puts it in front, where it belongs
        if set -l idx (contains -i -- $path $$list)
            set -e -- {$list}[$idx]
        end
        set -- $list $path $$list
    end
end
