library(virtualenv)

virtualenv()
activate()
thaw()

library(devtools)

install_github("rstudio/DT")
install_github("smbache/loggr")
