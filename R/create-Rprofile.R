#' Create a .Rprofile
#'
#' Create a .Rprofile which creates a local library, and then activates it
#' (if R is being used interactively)
#'
#' @export
create_.Rprofile <- function() {
  if (!is.activated()) {
    error("local library must be activated to use this function")
  }

  if (file.exists(.Rprofile_path())) {
    warn("a .Rprofile already exists")
    return(invisible())
  }

  message("creating .Rprofile")
  invisible(copy_.Rprofile())
}


copy_.Rprofile <- function() {
  template <- system.file("templates", "Rprofile.R", package = "locallib")
  file.copy(template, .Rprofile_path())
}


.Rprofile_path <- function() {
  file.path(meta_data$path, ".Rprofile")
}
