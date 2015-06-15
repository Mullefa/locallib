#' drat insert
#'
#' Insert packages into a local drat repo from either a library or a pkgs.yaml file.
#'
#' @param path(string) Path to library or pkgs.yaml file respectively.
#'
#' @name drat_insert
NULL


#' @rdname drat_insert
#' @export
drat_insert_lib <- function(path, commit = TRUE) {
  func_warning("drat_insert_lib")
  pkgs <- lapply(read_dcfs(path), function(pkg) {
    list(name = pkg$Package, version = pkg$Version)
  })
  drat_insert_impl(pkgs, commit)
}


#' @rdname drat_insert
#' @export
drat_insert_pkgs <- function(path, commit = TRUE) {
  func_warning("drat_insert_pkgs")
  pkgs <- yaml::yaml.load_file(path)[["packages"]]
  drat_insert_impl(pkgs, commit)
}


drat_insert_impl <- function(pkgs, commit) {
  if (!is.local_drat_repo_set()) {
    stop(
      "local drat repo has not been set. Use the function: ",
      "set_local_drat_repo() to do so.", call. = FALSE
    )
  }

  for (pkg in pkgs) {
    download_and_insert(pkg$name, pkg$version, commit)
  }
}
