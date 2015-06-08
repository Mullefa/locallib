library(virtualenv)

virtualenv("examples/without-drat/")

activate("examples/without-drat/")

install.packages("dplyr")

freeze()
