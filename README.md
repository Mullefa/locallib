# virtualenv

_[virtualenv](https://virtualenv.pypa.io/en/latest/) for R._

## Overview

This package looks to replicate some of the functionality of virtualenv for R. Underneath the covers there's really just one thing going on: prepending a local library to the library trees within which packages are looked for. The user is trusted to determine whether they want to use non-base packages that aren't in the local library.

The common usage pattern would be for the user to call `virtualenv()` to create a virtual environment, and `activate()` to activate it. Once a virtual environment has been activated, there is no concept of deactivating it from within the R session: if the user wants to work in a new virtual environment they should create a new R session.

## Package management

Isolated environments and package management go hand in hand.  [drat](https://github.com/eddelbuettel/drat) is recommended for packagement management if base R is not sufficient. 

To facilitate adding the packages installed whilst in a virtual environment to a drat repository, the function `drat_install()` is provided. It installs packages into the virtual environment, and also inserts the source for the packages into the drat repository. The user can then push the changes to their drat repository upstream. This builds up a repository with all dependencies for the project dynamically, and saves effort on the part of the user.

To capture a snapshot of all the packages installed locally, the function `freeze()` is exported. It returns a list (invisibly) of the packages installed locally, and also writes this information to a yaml file called `pkgs.yaml` in the virtual environments root directory.

When using the functions `drat_install()` and `freeze()`, it may be desirable for packages to be ignored. Any packages referenced in the file `pkgignore` in the root of the virtual environment will not be inserted into the drat repository or included in the `pkgs.yaml` file respectively.

Lastly, the virtual environment can be replciated from the `pkgs.yaml` file using the function `thaw()`.

## Example

See the `examples/` subdirectory for typically usage patterns.
