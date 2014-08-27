# Tacklebox: https://github.com/justinmayer/tacklebox

###
# Helper functions
###

function _fish_add_plugin
    set -l plugin $argv[1]
    set -l plugin_path "plugins/$plugin"

    for repository in $fish_path[-1..1]
        _prepend_path $repository/$plugin_path fish_function_path
    end
end

function _fish_add_module
    set -l module $argv[1]
    set -l module_path "modules/$module"

    for repository in $fish_path[-1..1]
        for module_file in $repository/$module_path/*.fish
            . $module_file
        end
    end
end

function _fish_add_completion
    set -l plugin $argv[1]
    set -l completion_path "plugins/$plugin/completions"

    for repository in $fish_path[-1..1]
        _prepend_path $repository/$completion_path fish_complete_path
    end
end

function _fish_source_plugin_load_file
    set -l plugin $argv[1]
    set -l load_file_path "plugins/$plugin/$plugin.load"

    for repository in $fish_path[-1..1]
        if test -e $repository/$load_file_path
            . $repository/$load_file_path
        end
    end
end

function _fish_load_theme
    for repository in $fish_path[-1..1]
        _prepend_path $repository/themes/$fish_theme fish_function_path
    end
end

###
# Configuration
###

# Extract user's functions, to be added back later
set user_function_path $fish_function_path[1]
set -e fish_function_path[1]

# Add all functions
for repository in $fish_path[-1..1]
    if not contains $repository/functions/ $fish_function_path
        set fish_function_path $repository/functions/ $fish_function_path
    end
end

# Add all specified plugins
for plugin in $fish_plugins
    _fish_add_plugin $plugin
    _fish_add_completion $plugin
    _fish_source_plugin_load_file $plugin
end

# Add all specified modules
for module in $fish_modules
    _fish_add_module $module
end

# Load user-specified theme
_fish_load_theme $fish_theme

# Add back user's functions so they have the highest priority
set fish_function_path $user_function_path $fish_function_path
