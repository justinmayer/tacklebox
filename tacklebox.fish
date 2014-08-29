# Tacklebox: https://github.com/justinmayer/tacklebox

###
# Helper functions
###

function __tacklebox_add_plugin
    set -l plugin $argv[1]
    set -l plugin_path "plugins/$plugin"

    for repository in $fish_path[-1..1]
        _prepend_path $repository/$plugin_path fish_function_path
    end
end

function __tacklebox_add_module
    set -l module $argv[1]
    set -l module_path "modules/$module"

    for repository in $fish_path[-1..1]
        for module_file in $repository/$module_path/*.fish
            . $module_file
        end
    end
end

function __tacklebox_add_completion
    set -l plugin $argv[1]
    set -l completion_path "plugins/$plugin/completions"

    for repository in $fish_path[-1..1]
        _prepend_path $repository/$completion_path fish_complete_path
    end
end

function __tacklebox_source_plugin_load_file
    set -l plugin $argv[1]
    set -l load_file_path "plugins/$plugin/$plugin.load"

    for repository in $fish_path[-1..1]
        if test -e $repository/$load_file_path
            . $repository/$load_file_path
        end
    end
end

function __tacklebox_load_theme
    for repository in $fish_path[-1..1]
        _prepend_path $repository/themes/$fish_theme fish_function_path
    end
end

function __tacklebox_strip_word --description '__tacklebox_strip_word word varname' --no-scope-shadowing
    set -l word "$argv[1]"
    set -l list "$argv[2]"
    if set -l idx (contains -i -- $word $$list)
        set -e -- {$list}[$idx]
    else
        return 1
    end
end

###
# Configuration
###

# Standardize function path, to be restored later
# Reset to just the datadir functions. At the end, we'll put the user
# functions back on front, and the sysconf functions on the end in front
# of the datadir functions, as is normally expected.
set -l user_function_path $fish_function_path
__tacklebox_strip_word "$__fish_sysconfdir/functions" user_function_path
set -l no_sysconf $status
__tacklebox_strip_word "$__fish_datadir/functions" user_function_path
set fish_function_path "$__fish_datadir/functions"

# Add all functions
for repository in $fish_path[-1..1]
    if not contains $repository/functions/ $fish_function_path
        set fish_function_path $repository/functions/ $fish_function_path
    end
end

# Add all specified plugins
for plugin in $fish_plugins
    __tacklebox_add_plugin $plugin
    __tacklebox_add_completion $plugin
    __tacklebox_source_plugin_load_file $plugin
end

# Add all specified modules
for module in $fish_modules
    __tacklebox_add_module $module
end

# Load user-specified theme
__tacklebox_load_theme $fish_theme

# Add back the user and sysconf functions as appropriate
set user_function_path $user_function_path $fish_function_path
__tacklebox_strip_word "$__fish_datadir/functions" user_function_path
__tacklebox_strip_word "$__fish_sysconfdir/functions" user_function_path # just in case
and set no_sysconf 0
if test $no_sysconf -eq 0
    set user_function_path $user_function_path "$__fish_sysconfdir/functions"
end
set fish_function_path $user_function_path "$__fish_datadir/functions"
