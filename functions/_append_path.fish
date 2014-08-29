function _append_path -d "Append the given path, if it exists, to the specified
    path list. If no list specified, defaults to $PATH" --no-scope-shadowing
    set -l path "$argv[1]"
    set -l list PATH
    if set -q argv[2]
        set list $argv[2]
    end

    if begin; test -d $path; and not contains $path $$list; end
        set -- $list $$list $path
    end
end
