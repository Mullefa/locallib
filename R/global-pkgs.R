global_pkgs <- function() {
  c(BASE_AND_RECOMMENDED, "drat", "git2r", "locallib", "yaml")
}


global_libs <- function() {
  out <- .libPaths()

  if (!is.null(meta_data$path)) {
    lib_path <- file.path(meta_data$path, "library")
    out <- Filter(function(x) x != lib_path, .libPaths())
  }

  out
}
