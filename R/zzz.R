.onLoad <- function(libname, pkgname) {
  lib_path <- file.path(meta_data$path, "library")
  lib_paths <- Filter(function(x) x != lib_path, .libPaths())

  for (lib_path in lib_paths) {
    lib_warning(lib_path)
  }
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


global_pkgs <- function() {
  c(BASE_AND_RECOMMENDED, "drat", "git2r", "virtualenv", "yaml")
}
