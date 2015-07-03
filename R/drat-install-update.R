drat_ <- function(f) {
  function(..., commit = FALSE) {
    if (!is.activated()) {
      error("local library must be activated to use drat_install()")
    }

    if (!is.local_drat_repo_set()) {
      error(
        "local drat repo has not been set. Use the function: ",
        "set_local_drat_repo() to do so."
      )
    }

    before <- read_dcfs(local_lib())
    f(...)

    after <- read_dcfs(local_lib())
    pkgs <- lib_diff(before, after)
    pkgs <- Filter(function(pkg) pkg$Package %notin% pkgignore(), pkgs)

    if (length(pkgs)) {
      message("inserting packages into drat repo ", bracket(local_drat_repo()), "\n")

      for (pkg in pkgs) {
        message("- ", pkg$Package, " ", bracket(pkg$Version), "\n")
        drat_insert_version(pkg$Package, pkg$Version, commit)
      }
    }
  }
}


lib_diff <- function(before, after) {
  for (pkg in names(after)) {
    if (pkg %in% names(before) && before[[pkg]]$Version == after[[pkg]]$Version) {
      after[[pkg]] <- NULL
    }
  }
  after
}


# TODO: consider exporting
drat_insert_version <- function(pkg, version, commit) {
  pkg._ <- download_pkg(pkg, version)
  on.exit(unlink(pkg._))
  drat::insertPackage(pkg._, commit = commit, repodir = meta_data$repo_path)
}


#' drat install
#'
#' Install packages into the local library, then insert the source for the
#' installed packge into the drat repository.
#'
#' @usage drat_install(..., commit = FALSE)
#' @param ... Arguments to pass to \code{\link{install.packages}()} or
#'   \code{\link{update.packages}()} respectively.
#' @param commit See \code{commit} argument of \code{drat::\link[drat]{insertPackage}()}.
#' @export
drat_install <- drat_(install.packages)


#' @usage drat_update(..., commit = FALSE)
#' @export
#' @rdname drat_install
drat_update <- drat_(update.packages)
