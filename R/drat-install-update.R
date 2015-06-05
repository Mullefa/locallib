drat_ <- function(f) {
  function(..., commit = FALSE) {
    if (!is.activated()) {
      stop("virtual environment must be activated to use drat_install()", call. = FALSE)
    }

    if(!valid_drat_repo()) {
      stop("a valid drat local repo has not been configured", call. = FALSE)
    }

    before <- lib_snapshot()
    f(...)

    after <- lib_snapshot()
    pkgs <- lib_diff(before, after)

    if (length(pkgs)) {
      message("inserting packages into drat repo ", bracket(drat_repo()), "\n")

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
  url <- pkg_url(pkg, version)
  pkg <- pkg_file(pkg, version)

  download.file(url, pkg)
  drat::insertPackage(pkg, commit = commit)

  unlink(pkg)
}


pkg_url <- function(pkg, version) {
  url <- pkg_file(pkg, version)

  if (!is.latest_version(pkg, version)) {
    url <- paste0("00Archive/", pkg, "/", url)
  }

  paste0(contrib.url(getOption("repos"), "source"), "/", url)
}


is.latest_version <- function(pkg, version) {
  m <- available.packages(contrib.url(getOption("repos"), "source"))
  latest_version <- m[rownames(m) == pkg, ]["Version"]
  version == latest_version
}


pkg_file <- function(pkg, version) {
  paste0(pkg, "_", version, ".tar.gz")
}


# valid drat repo ---------------------------------------------------------


valid_drat_repo <- function() {
  # TODO: implement this function
  TRUE
}


drat_repo <- function() {
  getOption("dratRepo", "~/git/drat")
}


# exported functions ------------------------------------------------------


#' drat install
#'
#' Install packages into the virtual environment, then insert the source for the
#' installed packge into the drat repository.
#'
#' @usage drat_install(...)
#' @param ... Arguments to pass to \code{\link{install.packages}()} or
#'   \code{\link{update.packages}()} respectively.
#' @export
drat_install <- drat_(install.packages)


#' @usage drat_update(...)
#' @export
#' @rdname drat_install
drat_update <- drat_(update.packages)
