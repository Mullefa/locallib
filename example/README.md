# example

The scripts in this sub-directory demonstrate the typical usage patterns that will occur when using `virtualenv`.

1. `drat.R`: setting up a local drat repo;
2. `init.R`: initialising a virtual environment and installing packages into it using `drat_install()`, so that any packages installed locally are also inserted into the local drat repo; and
3. `replicate.R`: recreating the virtual environment by using `thaw()` to install all of the virtual environments dependencies from the remote drat repo
