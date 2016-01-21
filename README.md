# locallib

_[virtualenv](https://virtualenv.pypa.io/en/latest/) for R._

## Overview

This package looks to replicate some of the functionality of virtualenv for R. Underneath the covers there's really just one thing going on: prepending a local library to the library trees within which packages are looked for. The user is trusted to determine whether they want to include non-base packages in their global library(s).

## Getting started

Until locallib is available on CRAN, use devtools to install it: 

```R
if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_github("Mullefa/locallib")
```

To create your first project which utilises a local library, open R in a new project directory and load locallib:

```R
library(locallib)
```

You will get a lot of warnings about packages being installed globally. If you want to remove these, so that all non-base packages are installed at the project level (recommended):

```R
clean_global_libs()
```

Now you just have to create a local library and use it:

```R
create_local_lib()
use_local_lib()
```

At this point, any installed packages will be installed into the local library (file path `./library`). To get a snapshot of your local library:

```R
freeze()
```

This will create a file specifying all the packages used in the project and their versions (file path `./pkgs.yaml`). This is useful as now it is easy to replicate the local library:

```R
thaw()
```

One last thing to mention is a pattern I use whenever starting a new project with its own local library. With a R console opened in the new project directory:

```R
create_.Rprofile()
```

Now restart R. The created `.Rprofile` will activate the local library whenever the user is in interactive mode.

## Use with multidplyr

The function `cluster_use_local_lib()` can be used to activate the locally activated local lib on each of the remote nodes e.g.

```R
library(locallib)
library(dplyr)
library(multidplyr)

get_default_cluster %>% cluster_use_local_lib
```

## Examples

Check out [geohash-vis](https://github.com/Mullefa/geohash-vis).
