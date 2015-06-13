library(locallib)

create_local_lib("examples/without-drat/")

use_local_lib("examples/without-drat/")

install.packages("dplyr")

freeze()
