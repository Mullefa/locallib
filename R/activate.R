#' Activate a virtual environment
#'
#' @param path(string)
#'
#' @export
activate <- function(path = NULL) {
  path <- normalize_path(path)

  if (is.activated()) {
    if (path == meta_data$path) {
      message("virtual environment already activated ", bracket(path))
      return(invisible())
    }

    stop(
      "a different virtual environment is already activated. ",
      "Restart R session to activate a new one", call. = FALSE
    )
  }

  if (!is.virtualenv(path)) {
    stop("virtual environment is not valid ", bracket(path), call. = FALSE)
  }

  message("activating virtual environment ", bracket(path))

  lib_path <- file.path(path, "library")
  .libPaths(c(lib_path, .libPaths()))

  meta_data$activated <- TRUE
  meta_data$path <- path

  invisible()
}


# meta data ---------------------------------------------------------------


meta_data <- new.env()
meta_data$activated <- FALSE
meta_data$path <- NULL


is.activated <- function() {
  meta_data$activated
}
