library(locallib)

create_local_lib("examples/drat/")

use_local_lib("examples/drat/")

# set to NULL for demonstartion purposes only
options(repos = NULL)

# will probably include this information in the pkgs.yaml file so that it doesn't
# need to be set manually.
drat::addRepo("Mullefa")

thaw()
