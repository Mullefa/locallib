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


error <- function(...) {
  stop(..., call. = FALSE)
}


warn <- function(...) {
  warning(..., call. = FALSE)
}


until_success <- function(xs, f, ..., error_msg = NULL) {
  i <- 1
  n <- length(xs)
  success <- FALSE

  while (!success) {
    if (i > n) {
      error(error_msg %||% "")
    }
    tryCatch({
        out <- f(xs[[i]], ...)
        success <- TRUE
      },
      error = function(err) {
        NULL
      }
    )
    i <- i + 1
  }

  out
}


`%recover_with%` <- function(x, y) {
  tryCatch(x, error = function(err) y)
}


add_rstudio_cran_mirror <- function() {
  repos <- getOption("repos")

  if (RSTUDIO_CRAN_MIRROR %notin% repos) {
    options(repos = c(repos, RSTUDIO_CRAN_MIRROR))
  }
}


RSTUDIO_CRAN_MIRROR <- "http://cran.rstudio.com"
