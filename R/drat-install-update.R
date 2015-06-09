drat_ <- function(f) {
  function(..., commit = FALSE) {
    if (!is.activated()) {
      stop("virtual environment must be activated to use drat_install()", call. = FALSE)
    }

    if (!is.local_drat_repo_set()) {
      stop(
        "local drat repo has not been set. Use the function: ",
        "set_local_drat_repo() to do so.", call. = FALSE
      )
    }

    before <- lib_snapshot()
    f(...)

    after <- lib_snapshot()
    pkgs <- lib_diff(before, after)
    pkgs <- Filter(function(pkg) pkg$Package %notin% pkgignore(), pkgs)

    if (length(pkgs)) {
      message("inserting packages into drat repo ", bracket(local_drat_repo()), "\n")

      for (pkg in pkgs) {
        message("- ", pkg$Package, " ", bracket(pkg$Version), "\n")
        download_and_insert(pkg$Package, pkg$Version, commit)
      }
    }
  }
}


# lib diff ----------------------------------------------------------------


lib_diff <- function(before, after) {
  for (pkg in names(after)) {
    if (pkg %in% names(before) && before[[pkg]]$Version == after[[pkg]]$Version) {
      after[[pkg]] <- NULL
    }
  }
  after
}


lib_snapshot <- function() {
  lib_path <- file.path(meta_data$path, "library")
  read_dcfs(lib_path)
}


read_dcfs <- function(lib_path) {
  pkgs <- list.files(lib_path, full.names = TRUE)
  lapply(setNames(pkgs, basename(pkgs)), read_dcf)
}


read_dcf <- function(pkg) {
  desc <- read.dcf(file.path(pkg, "DESCRIPTION"))
  desc <- setNames(as.list(desc), colnames(desc))
  desc
}


# downlaod and insert -----------------------------------------------------


download_and_insert <- function(pkg, version, commit) {
  pkg._ <- pkg_file(pkg, version)
  url <- pkg_url(pkg, version, archive = TRUE)

  download.file(url, pkg._)
  drat::insertPackage(pkg._, commit = commit, repodir = meta_data$repo_path)

  unlink(pkg._)
}


pkg_url <- function(pkg, version, archive) {
  pkg._ <- pkg_file(pkg, version)

  if (!is.latest_version(pkg, version) && archive) {
    base_url <- paste0("00Archive/", pkg, "/", pkg._)
  } else {
    base_url <- pkg._
  }

  paste0(contrib.url(getOption("repos"), "source"), "/", base_url)
}


is.latest_version <- function(pkg, version) {
  m <- available.packages(contrib.url(getOption("repos"), "source"))
  latest_version <- m[rownames(m) == pkg, ]["Version"]
  version == latest_version
}


pkg_file <- function(pkg, version) {
  paste0(pkg, "_", version, ".tar.gz")
}


# exported functions ------------------------------------------------------


#' drat install
#'
#' Install packages into the virtual environment, then insert the source for the
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
