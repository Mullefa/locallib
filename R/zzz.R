.onLoad <- function(libname, pkgname) {
  for (lib_path in global_libs()) {
    lib_warning(lib_path)
  }

  options(repos = "http://cran.rstudio.com")
}


lib_warning <- function(path) {
  pkgs <- list.files(path)

  for (pkg in pkgs) {
    if (pkg %notin% global_pkgs()) {
      warning(
        "the package ", pkg, " is installed in a global library ",
        bracket(path), call. = FALSE
      )
    }
  }
}

