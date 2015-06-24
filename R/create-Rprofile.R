#' Create a .Rprofile
#'
#' Create a .Rprofile which creates a local library, and then activates it
#' (if R is being used interactively)
#'
#' @export
create_.Rprofile <- function() {
  if (!is.activated()) {
    stop("local library must be activated to use this function", call. = FALSE)
  }

  if (file.exists(.Rprofile_path())) {
    warning("a .Rprofile already exists", call. = FALSE)
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
