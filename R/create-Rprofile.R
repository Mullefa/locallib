#' Create a .Rprofile
#'
#' Create a .Rprofile which creates a local library, and then activates it
#' (if R is being used interactively).
#'
#' @export
create_.Rprofile <- function(path = NULL) {
  if (is.activated()) {
    error("local library must be deactivated to create a .Rprofile")
  }

  path <- normalize_path(path)

  if (.Rprofile_exists(path)) {
    warn("a .Rprofile already exists in this directory ", bracket(path))
    return(invisible())
  }

  message("creating .Rprofile")
  invisible(copy_.Rprofile(path))
}


copy_.Rprofile <- function(path) {
  template <- system.file("templates", "Rprofile.R", package = "locallib")
  file.copy(template, file.path(path, ".Rprofile"))
}


.Rprofile_exists <- function(path) {
  path <- file.path(path, ".Rprofile")
  file.exists(path)
}
