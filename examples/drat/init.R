library(virtualenv)

set_local_drat_repo("~/git/drat")

virtualenv("examples/drat")

activate("examples/drat")

drat_install("dplyr", commit = TRUE)

freeze()
