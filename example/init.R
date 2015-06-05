library(virtualenv)

options(dratRepo = "~/git/drat")

virtualenv("example")

activate("example")

drat_install("dplyr", commit = TRUE)

freeze()
