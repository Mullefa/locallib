`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}


`%notin%` <- Negate(`%in%`)


normalize_path <- function(path) {
  tryCatch(
    normalizePath(path %||% ".", mustWork = TRUE),
    error = function(e) {
      error("path is not valid")
    }
  )
}


bracket <- function(x) paste0("(", x, ")")


R_version <- function() {
  rv <- R.Version()
  paste0(rv$major, ".", rv$minor)
}


func_warning <- function(func_name) {
  warn(
    "the function ", func_name, "() is still under development ",
    "and could be subject to change in the future"
  )
}


error <- function(...) {
  stop(..., call. = FALSE)
}


warn <- function(...) {
  warning(..., call. = FALSE)
}
