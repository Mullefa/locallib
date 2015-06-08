library(virtualenv)

virtualenv("examples/drat/")

activate("examples/drat/")

# set to NULL for demonstartion purposes only
options(repos = NULL)

# will probably include this information in the pkgs.yaml file so that it doesn't
# need to be set manually.
drat::addRepo("Mullefa")

thaw()
