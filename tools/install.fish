#!/usr/bin/env fish

# Takes color as first argument; subsequent argument text is printed in color
function colored
    set_color $argv[1]
    set -e argv[1]
    echo $argv
    set_color normal
end

if test -d ~/.tacklebox
    colored yellow -n You already have Tacklebox installed.
    echo " You'll need to remove ~/.tacklebox if you want to install."
    exit
end

colored blue Cloning Tacklebox
type git >/dev/null
and git clone https://github.com/justinmayer/tacklebox ~/.tacklebox
or begin
    colored yellow -n git is not installed.
    echo " You must install git in order to proceed."
    exit
end

if test -d ~/.tackle
    colored yellow -n You already have Tackle installed.
    echo " You'll need to remove ~/.tackle if you want to install."
    exit
end

colored blue Cloning Tackle
type git >/dev/null
and git clone https://github.com/justinmayer/tackle ~/.tackle
or begin
    colored yellow -n git is not installed.
    echo " You must install git in order to proceed."
    exit
end

colored blue Looking for an existing fish config...
if test -f ~/.config/fish/config.fish
    colored yellow -n "Found ~/.config/fish/config.fish."
    colored green " Backing up to ~/.config/fish/config.orig"
    cp ~/.config/fish/config.{fish,orig}
end

colored blue "Appending Tacklebox and Tackle to ~/.config/fish/config.fish"
set -l config "
# Paths to your tackle
set tacklebox_path ~/.tackle ~/.tacklebox

# Theme
#set tacklebox_theme entropy

# Which modules would you like to load? (modules can be found in ~/.tackle/modules/*)
# Custom modules may be added to ~/.tacklebox/modules/
# Example format: set tacklebox_modules virtualfish virtualhooks

# Which plugins would you like to enable? (plugins can be found in ~/.tackle/plugins/*)
# Custom plugins may be added to ~/.tacklebox/plugins/
# Example format: set tacklebox_plugins python extract

# Load Tacklebox configuration
. ~/.tacklebox/tacklebox.fish
"

mkdir -p ~/.config/fish
echo $config >> ~/.config/fish/config.fish

colored green "
Tacklebox is now installed.
"

# Run Fish after installation
fish
