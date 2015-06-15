library(locallib)

set_local_drat_repo("~/git/drat")

create_local_lib("examples/drat")

use_local_lib("examples/drat")

drat_install("dplyr", commit = TRUE)

freeze()
