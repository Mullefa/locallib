#' Create a local library
#'
#' @param path(string) Path of directory to create the local library in.
#'
#' @export
create_local_lib <- function(path = NULL) {
  path <- normalize_path(path)

  if (is.activated()) {
    local_lib <- file.path(meta_data$path, "library")

    if (path == local_lib) {
      message("local library already activated ", bracket(local_lib))
      return(invisible())
    }

    stop(
      "a different local library is already activated", bracket(local_lib), ". ",
      "Restart R session to create a new one", call. = FALSE
    )
  }

  if (has_local_lib(path)) {
    message("a local library has already been created in this directory", bracket(path))
    return(invisible())
  }

  message("creating local library ", bracket(path))

  if (!file.exists(path)) {
    dir.create(path, recursive = TRUE)
    message("creating root directory of the local library")
  }

  lib_path <- file.path(path, "library")

  message("creating local library")
  dir.create(lib_path)

  meta_data$path <- path

  invisible()
}


has_local_lib <- function(path) {
  lib_path <- file.path(path, "library")
  file.exists(path) && file.exists(lib_path)
}

