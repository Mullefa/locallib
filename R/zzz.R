.onLoad <- function(libname, pkgname) {
  for (lib_path in global_libs()) {
    lib_warning(lib_path)
  }

  add_rstudio_cran_mirror()
}


lib_warning <- function(path) {
  pkgs <- list.files(path)

  for (pkg in pkgs) {
    if (pkg %notin% global_pkgs()) {
      warn("the package ", pkg, " is installed in a global library ", bracket(path))
    }
  }
}

