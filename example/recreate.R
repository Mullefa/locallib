library(virtualenv)

virtualenv("example")

activate("example")

# set to NULL for demonstartion purposes only
options(repos = NULL)

drat::addRepo("Mullefa")

thaw()
