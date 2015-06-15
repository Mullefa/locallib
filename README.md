# locallib

_[virtualenv](https://virtualenv.pypa.io/en/latest/) for R._

## Overview

This package looks to replicate some of the functionality of virtualenv for R. Underneath the covers there's really just one thing going on: prepending a local library to the library trees within which packages are looked for. The user is trusted to determine whether they want to include non-base packages in their global library(s).

The common usage pattern would be for the user to call `create_local_lib()` to create a local libary, and `use_local_lib()` to activate it. Once a local library has been activated, there is no concept of deactivating it from within the R session: if the user wants to work in a new local library they should create a new R session.

## Package management

Isolated environments and package management go hand in hand.  [drat](https://github.com/eddelbuettel/drat) is recommended for package management if base R is not sufficient. 

To facilitate adding the packages installed in a local library to a drat repository, the function `drat_install()` is provided. It installs packages into the local library, and also inserts the source for the packages into the drat repository. The user can then push the changes to their drat repository upstream. This builds up a repository with all dependencies for the project dynamically, and saves effort on the part of the user.

To capture a snapshot of all the packages installed locally, the function `freeze()` is exported. It returns a list (invisibly) of the packages installed locally (and their dependencies), and also writes this information to a yaml file called `pkgs.yaml` in the directory containing the local library.

When using the functions `drat_install()` and `freeze()`, it may be desirable for packages to be ignored. Any packages referenced in the file `pkgignore` in the directory containing the local library will not be inserted into the drat repository or included in the `pkgs.yaml` file respectively.

Lastly, the local library can be replicated from the `pkgs.yaml` file using the function `thaw()`.

## Installation

Installing locallib using `devtools::install_github()` is a bit of a pain: the user has to install devtools into the global library; then install virtualenv from github; then remove devtools plus all of it dependencies from the global library (assuming the user wants to only keep core packages in the global library).

Instead the following is recommended:

1. install the dependencies into the global library:

    ```R
    install.packages(c("drat", "yaml", "git2r"))
    ```
    
2. download the zip file of the master branch from github and run:

   ```sh
   R CMD INSTALL locallib-master
   ```
   
## Examples

See the `examples/` sub-directory for typically usage patterns.
