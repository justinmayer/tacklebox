# Tacklebox

### Problem

It's tough to organize and share shell code libraries and snippets.

### Solution

Tacklebox is a framework for the [Fish][] shell that makes it easy to organize and share collections of useful shell functions, tools, and themes.

Fish's design philosophy is to avoid including the kitchen sink and only bundle built-in functions that are hard to implement as external tools. This lean design is part of what makes Fish great. The flip side is that you (and other folks like you) might want to do something that Fish doesn't do by default, and now everyone is trying to figure out how to solve it by inventing the wheel independently.

Tacklebox solves this problem by allowing you to utilize community-curated repositories, enabling only those tools that are relevant to your desired workflow.

## Installation

Assuming Fish 2.0+ is already installed, the following will install Tacklebox and [Tackle][]:

    curl -O https://raw.githubusercontent.com/justinmayer/tacklebox/master/tools/install.fish
    cat install.fish  # inspect contents to ensure you understand what it’s doing
    cat install.fish | fish; rm install.fish

Alternatively, if you aware of the potential security concern with piping directly to shell, you can perform the installation in one step:

    curl -L https://raw.githubusercontent.com/justinmayer/tacklebox/master/tools/install.fish | fish

You can now skip to the **Usage** section below.

### Manual installation

If you prefer to install manually, the first step is to clone the Tacklebox repository:

    git clone https://github.com/justinmayer/tacklebox ~/.tacklebox

To install external repositories, first clone them to your desired location. For example, you can clone the [Tackle][] repository via:

    git clone https://github.com/justinmayer/tackle ~/.tackle

Don't like those locations? Clone them wherever you want. Just keep in mind that the instructions below assume those locations, so modify them as needed.

If you are setting up Fish for the first time and don't have an existing configuration file at `~/.config/fish/config.fish`, now is a good time to create one.

### Staying up-to-date

Updating is easy:

    cd ~/.tacklebox; git pull
    cd ~/.tackle; git pull

## Usage

Modules, plugins, and themes are enabled via the configuration file at: `~/.config/fish/config.fish`

Adding the following line to the above file will create a minimal configuration that includes no external repositories and does not enable any modules or plugins:

    source ~/.tacklebox/tacklebox.fish

But since one of the advantages of Tacklebox is the ability to include external repositories, let's replace the line above with some configuration that includes an external repository and enables some of its components.

Assuming you used the automated install script (or manually cloned the [Tackle][] repository as noted above), you can enable the [Tackle][] repository by adding it to the `tacklebox_path` list in order of preference. While we're at it, let's also specify some modules, plugins, and a theme:

    set tacklebox_path ~/.tackle
    set tacklebox_modules virtualfish virtualhooks
    set tacklebox_plugins extract grc pip python up
    set tacklebox_theme entropy
    source ~/.tacklebox/tacklebox.fish

The last line initializes Tacklebox, so whichever `tacklebox_*` settings you choose, just make sure they come before that line, or else they won't be taken into account when Tacklebox is initialized.

## Concepts

These are not official terms by any means — just useful concepts to help understand how Tacklebox works.

* *repository* — a collection of components (e.g., [Tackle][], [Oh My Fish][])
* *component* — a module, plugin, or theme
* *module* - files that are *sourced* (e.g., `virtualfish`)
* *plugin* - dynamically-loaded functions (e.g., `up`)
* *theme* - functions to customize appearance of the shell prompt

Plugins are composed of one or more files, each of which usually contains a function that matches the file name — otherwise, the function will not be dynamically loaded (and thus must be sourced instead).

While dynamically-loaded functions are preferred, there are some situations in which this isn't feasible, and that's where modules can be useful.

## Customization

Can't find a plugin that does what you want? Prefer to create your own theme? Tacklebox includes locations for you to store your own customized modules, plugins, and themes:

* `~/.tacklebox/modules/`
* `~/.tacklebox/plugins/`
* `~/.tacklebox/themes/`

Remember that adding your custom components at the above locations isn't sufficient — you must enable them by including them in your `tacklebox_modules`, `tacklebox_plugins`, and/or `tacklebox_theme` settings, in addition to including `~/.tacklebox` itself in your `tacklebox_path` setting.

If you would rather keep your collection of custom goodies in your own versioned repository instead of the directories provided by Tacklebox, just create your own repository at your preferred filesystem location and prepend its path to the `tacklebox_path` list.

Have a very simple function that you don't necessarily feel is worthy of creating a plugin? Put it in `~/.config/fish/functions/[your-function-name].fish`, creating the parent directory if it doesn't already exist.

## Contributing

Contributions to both Tacklebox and [Tackle][] are welcomed. If you'd like to contribute to the project, please review the [contributing guidelines][] thoroughly.

## Questions nobody asked but here are answers anyway

_How is this different from other shell management tools?_

Tacklebox…

1. supports multiple repositories, including your own if you wish
1. decouples the repositories (e.g., [Tackle][]) from the loading mechanisms and organizational conventions (i.e., Tacklebox)
1. can source modules using `*.fish` filename extensions (instead of using `*.load`, which requires monkeying with your $EDITOR to get proper syntax highlighting)

_But I want to create a plugin that includes files that must be sourced!_

That's not a question, but you can still put `*.load` files inside plugins if you must, and they will be sourced. That said, dynamically-loadable functions are probably more "fishy", and code that isn't suitable as dynamically-loadable functions might be best included as a module.

[Fish]: http://fishshell.com/
[contributing guidelines]: https://github.com/justinmayer/tacklebox/blob/master/Contributing.md
[Tackle]: https://github.com/justinmayer/tackle
