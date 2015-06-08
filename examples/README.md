# example

The scripts in this sub-directories `drat/` and `without-drat/` demonstrate the typical usage patterns that will occur when using `virtualenv` with `drat` and without `drat` respectively.

1. `init.R`: initialising a virtual environment and installing packages into it using `drat_install()` or `install.packages()` respectively; and
2. `replicate.R`: recreating the virtual environment by using `thaw()` to install all of the virtual environments dependencies from the remote drat repo or CRAN respectively
