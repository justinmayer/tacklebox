# Contributing to Tacklebox

Contributions to Tacklebox and [Tackle][] are welcomed and encouraged. When considering submitting a pull request, please adhere to the following guidelines.

## Code standards

Consistency throughout the project makes it easier for everyone. When making changes, please…

* use 4-space indents (no tabs)
* use `-d` to include descriptions for all function declarations

## Git and GitHub

* Create a new git feature branch specific to your change (as opposed to making
  your commits in the master branch).
* **Don't put multiple unrelated fixes/features in the same branch / pull request.**
  For example, if while working on a new feature you find and fix a bug on which
  your new feature does not directly depend, **make a new distinct branch and
  pull request** for the bugfix.
* Check for unnecessary whitespace via `git diff --check` before committing.
* First line of your commit message should start with present-tense verb, be 50
  characters or less, and include the relevant issue number(s) if applicable.
  *Example:* `Add .xz support to extract plugin. Refs #982.` If the commit
  *completely fixes* an existing bug report, please use ``Fixes #982`` or ``Fix
  #982`` syntax (so the relevant issue is automatically closed upon PR merge).
* After the first line of the commit message, add a blank line and then a more
  detailed explanation.
* Squash your commits to eliminate merge commits and ensure a clean and
  readable commit history.

[Tackle]: https://github.com/justinmayer/tackle
