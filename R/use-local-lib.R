#' Activate a local library
#'
#' @param path(string) Path to directory containing a local library.
#'
#' @export
use_local_lib <- function(path = NULL) {
  path <- normalize_path(path)

  if (is.activated()) {
    if (path == meta_data$path) {
      message("local library already activated ", bracket(local_lib()))
      return(invisible())
    }

    error(
      "a different local library is already activated ", bracket(local_lib()), ". ",
      "Restart R to activate a new one"
    )
  }

  if (!has_local_lib(path)) {
    error("directory does not have a local library ", bracket(path))
  }

  message("activating local library ", bracket(path))

  lib_path <- file.path(path, "library")
  .libPaths(c(lib_path, .libPaths()))

  meta_data$activated <- TRUE
  meta_data$path <- path

  invisible()
}


is.activated <- function() {
  meta_data$activated
}


# meta data ---------------------------------------------------------------


meta_data <- new.env()
meta_data$activated <- FALSE
meta_data$path <- NULL
meta_data$repo_path <- NULL
