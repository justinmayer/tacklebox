function _prepend_path -d "Prepend the given path, if it exists, to the specified
    path list. If no list specified, defaults to $PATH"
    set -l path PATH

    if test (echo $argv | wc -w) -eq 2
        set path $argv[2]
    end

    if test -d $argv[1]
        set $path "$argv[1]" $$path
        _deduplicate $path
    end
end
