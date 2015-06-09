`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}


`%notin%` <- Negate(`%in%`)


normalize_path <- function(path) {
  tryCatch(
    normalizePath(path %||% ".", mustWork = TRUE),
    error = function(e) {
      stop("path is not valid", call. = FALSE)
    }
  )
}


bracket <- function(x) paste0("(", x, ")")


R_version <- function() {
  rv <- R.Version()
  paste0(rv$major, ".", rv$minor)
}
