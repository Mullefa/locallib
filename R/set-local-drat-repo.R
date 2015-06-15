#' Set a local drat repo
#'
#' @export
set_local_drat_repo <- function(path = NULL) {
  path <- suppressWarnings(normalizePath(path %||% "~/git/drat"))

  base <- basename(path)
  dir <- dirname(path)

  if (!file.exists(dir)) {
    message("creating base path for drat repo ", bracket(dir))
    dir.create(dir, recursive = TRUE)
  }

  if (!file.exists(path)) {
    message("intialising drat repo ", bracket(path))
    drat::initRepo(base, dir)
  } else {
    if (!is.valid_local_drat_repo(path)) {
      stop("local drat repo is not valid ", bracket(path), call. = FALSE)
    }
  }

  message("setting local drat repo ", bracket(path))
  options(dratRepo = path)
  meta_data$repo_path <- path
}


is.valid_local_drat_repo <- function(path) {
  # FIXME: implement this function
  TRUE
}


is.local_drat_repo_set <- function() {
  !is.null(meta_data$repo_path)
}


local_drat_repo <- function() {
  meta_data$repo_path
}
