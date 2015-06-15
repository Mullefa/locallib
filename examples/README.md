# examples

The scripts in this sub-directories `drat/` and `without-drat/` demonstrate the typical usage patterns that will occur when using `locallib` with `drat` and without `drat` respectively.

1. `init.R`: creates a local library and installs packages into it using `drat_install()` or `install.packages()` respectively; and

2. `recreate.R`: recreates the local library using `thaw()`

The the sub-directory `non-CRAN/` gives an example of how local library might be used with packages that need to be installed from github. This is not ideal - see [here](http://eddelbuettel.github.io/drat/DratFAQ.html) for more information - but sometimes it can not be avoided.

As an example, at work we wanted to use the packages [DT](https://github.com/rstudio/DT) and [loggr](https://github.com/smbache/loggr) in a shiny application, but these are not yet released on CRAN. To solve this issue, we included a `setup.R` file in the root of the shiny application, and executed this with `Rscript` after copying the code to the server.

When these packages are released on CRAN, we will move to proper versioning.
