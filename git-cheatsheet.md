# Git Submodule Cheatsheet

Note that placeholders are indicated by enclosing in <angle-brackets-like-this>

## Clone repo with submodule and initialize

> git clone git@gitlab:root/<repo-name-here>.git
> cd <repo-name-here>
> git submodule init
> git submodule update

(or)

> git clone --recurse-submodules git@gitlab:root/<repo-name-here>.git

## Add a submodule

> git submodule add git@gitlab:root/<submodule-repo-name-here>.git <optional-target-relative-path-here>

## Bring in upstream changes into a submodule

> cd <submodule-folder-here>
> git fetch
> git merge origin/<branch-name-here>

(or)

> cd <main-module-folder-here>
> git submodule update --remote <submodule-folder-here>

Go back to main module and commit the changes made to submodule.

> cd ..
> git commit -am "Submodule updated."

## Change tracking branch of a submodule (when merging)

> git config -f .gitmodules submodule.<submodule-here>.branch <desired-tracking-branch-here>

## How to setup a submodule to hack on and push its changes

> cd <submodule-folder-here>
> git checkout <desired-branch-to-work-on>

Make changes and commit as you normally do. Finally push changes.

## Pull in remote changes for submodule after it has been hacked on locally

> cd <submodule-folder-here>
> git submodule update --remote --merge

(or)

> git submodule update --remote --rebase

## Push changes to main module along with all submodules

> git push --recurse-submodules=check

(or)

> git push --recurse-submodules=on-demand

Note: Make this behavior permanent with the following set configuration call.

> git config --global push.recurseSubmodules check

## To remove submodule, if added by mistake for instance

> rm -rf <submodule-here>/.git
> git submodule deinit -f -- <submodule-here>
> rm -rf .git/modules/<submodule-here>
> git rm -f <submodule-here>