#' Create a virtual environment
#'
#' @param path(string) File path of the virtual environment.
#'
#' @export
virtualenv <- function(path = NULL) {
  path <- normalize_path(path)

  if (is.activated()) {
    if (path == meta_data$path) {
      message("virtual environment already activated ", bracket(path))
      return(invisible())
    }

    stop(
      "a different virtual environment is already activated. ",
      "Restart R session to create a new one", call. = FALSE
    )
  }

  if (is.virtualenv(path)) {
    message("virtual environment already created ", bracket(path))
    return(invisible())
  }

  message("creating virtual environment ", bracket(path))

  if (!file.exists(path)) {
    dir.create(path, recursive = TRUE)
    message("creating root directory of virtual environment")
  }

  lib_path <- file.path(path, "library")

  message("creating local library of virtual environment")
  dir.create(lib_path)

  meta_data$path <- path

  invisible()
}


is.virtualenv <- function(path) {
  lib_path <- file.path(path, "library")
  file.exists(path) && file.exists(lib_path)
}
