#' Create a pkgignore file
#'
#' @export
create_pkgignore <- function() {
  if (!is.activated()) {
    stop("local library must be activated to use this function", call. = FALSE)
  }

  if (file.exists(pkgignore_path())) {
    warning("a pkgignore file already exists", call. = FALSE)
    return(invisible())
  }

  message("creating pkgignore")
  invisible(file.create(pkgignore_path()))
}


pkgignore_path <- function() {
  file.path(meta_data$path, "pkgignore")
}
