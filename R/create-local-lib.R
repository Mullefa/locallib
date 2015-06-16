#' Create a local library
#'
#' @param path(string) Path of directory to create the local library in.
#'
#' @export
create_local_lib <- function(path = NULL) {
  path <- normalize_path(path)

  if (is.activated()) {
    if (path == local_lib()) {
      message("local library already activated ", bracket(local_lib()))
      return(invisible())
    }

    stop(
      "a different local library is already activated", bracket(local_lib()), ". ",
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

  meta_data$path <- path

  message("creating local library")
  dir.create(local_lib())

  invisible()
}


has_local_lib <- function(path) {
  # NOTE: doesn't use local_lib() as this function might be called
  # when local library is not activated
  file.exists(path) && file.exists(file.path(path, "library"))
}


local_lib <- function() {
  file.path(meta_data$path, "library")
}
