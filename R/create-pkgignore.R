#' Create a pkgignore file
#'
#' @export
create_pkgignore <- function() {
  if (!is.activated()) {
    error("local library must be activated to use this function")
  }

  if (file.exists(pkgignore_path())) {
    warn("a pkgignore file already exists")
    return(invisible())
  }

  message("creating pkgignore")
  invisible(file.create(pkgignore_path()))
}


pkgignore_path <- function() {
  file.path(meta_data$path, "pkgignore")
}
