# Tacklebox: https://github.com/justinmayer/tacklebox

###
# Helper functions
###

function __tacklebox_add_plugin
    set -l plugin "$argv[1]"
    set -l plugin_path "plugins/$plugin"

    for repository in $tacklebox_path[-1..1]
        __tacklebox_prepend_path $repository/$plugin_path fish_function_path
    end
end

function __tacklebox_add_module
    set -l module "$argv[1]"
    set -l module_path "modules/$module"

    for repository in $tacklebox_path[-1..1]
        for module_file in $repository/$module_path/*.fish
            source $module_file
        end
    end
end

function __tacklebox_add_completion
    set -l plugin "$argv[1]"
    set -l completion_path "plugins/$plugin/completions"

    for repository in $tacklebox_path[-1..1]
        __tacklebox_prepend_path $repository/$completion_path fish_complete_path
    end
end

function __tacklebox_source_plugin_load_file
    set -l plugin "$argv[1]"
    set -l load_file_path "plugins/$plugin/$plugin.load"

    for repository in $tacklebox_path[-1..1]
        if test -e $repository/$load_file_path
            source $repository/$load_file_path
        end
    end
end

function __tacklebox_load_theme
    set -l theme "$argv[1]"
    set -l theme_path "themes/$theme"

    for repository in $tacklebox_path[-1..1]
        __tacklebox_prepend_path $repository/$theme_path fish_function_path
    end
end

function __tacklebox_strip_word --no-scope-shadowing --description '__tacklebox_strip_word word varname'
    set -l word "$argv[1]"
    set -l list "$argv[2]"
    if set -l idx (contains -i -- $word $$list)
        set -e -- {$list}[$idx]
    else
        return 1
    end
end

function __tacklebox_prepend_path --no-scope-shadowing --description \
        'Prepend the given path, if it exists, to the specified path list (defaults to PATH)'
    set -l path "$argv[1]"
    set -l list PATH
    if set -q argv[2]
        set list $argv[2]
    end

    if test -d $path
        # If the path is already in the list, remove it first.
        # Prepending puts it in front, where it belongs
        if set -l idx (contains -i -- $path $$list)
            set -e -- {$list}[$idx]
        end
        set -- $list $path $$list
    end
end

function __tacklebox_append_path --no-scope-shadowing --description \
        'Append the given path, if it exists, to the specified path list (defaults to PATH)'
    set -l path "$argv[1]"
    set -l list PATH
    if set -q argv[2]
        set list $argv[2]
    end

    if test -d $path
        # If the path is already in the list, skip it.
        if not contains -- $path $$list
            set -- $list $$list $path
        end
    end
end

###
# Configuration
###

# Standardize function path, to be restored later.
set -l user_function_path $fish_function_path
# Ensure the function path is global, not universal
set -g fish_function_path "$__fish_datadir/functions"

# Add all functions
for repository in $tacklebox_path[-1..1]
    __tacklebox_prepend_path $repository/functions fish_function_path
end

# Add all specified plugins
for plugin in $tacklebox_plugins
    __tacklebox_add_plugin $plugin
    __tacklebox_add_completion $plugin
    __tacklebox_source_plugin_load_file $plugin
end

# Add all specified modules
for module in $tacklebox_modules
    __tacklebox_add_module $module
end

# Load user-specified theme
if test -n "$tacklebox_theme"
    __tacklebox_load_theme $tacklebox_theme
end

# Add back the user and sysconf functions as appropriate
for path in $fish_function_path
    # don't append either system path
    if not contains -- "$path" "$__fish_sysconfdir/functions" "$__fish_datadir/functions"
        __tacklebox_append_path $path user_function_path
    end
end
if __tacklebox_strip_word "$__fish_sysconfdir/functions" user_function_path
    set user_function_path $user_function_path "$__fish_sysconfdir/functions"
end
__tacklebox_strip_word "$__fish_datadir/functions" user_function_path
set -g fish_function_path $user_function_path "$__fish_datadir/functions"
