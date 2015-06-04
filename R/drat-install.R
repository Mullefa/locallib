#' drat install
#'
#' Install a package into the virtual environment, then insert the source for the
#' installed packge into the drat repository.
#'
#' @export
drat_install <- function(...) {
  if (!is.activated()) {
    stop("virtual environment must be activated to use drat_install()", call. = FALSE)
  }

  if(!valid_drat_repo()) {
    stop("a valid drat local repo has not been configured", call. = FALSE)
  }

  before <- lib_snapshot()
  install.packages(...)
  after <- lib_snapshot()
  pkgs <- lib_diff(before, after)

  if (length(pkgs)) {
    message("inserting packages into drat repo ", bracket(getOption("dratRepo")))
  }

  for (pkg in pkgs) {
    message("- ", pkg$Package, " ", bracket(pkg$Version), "\n")
    download_and_insert(pkg$Package, pkg$Version)
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
  pkgs <- list.files(lib_path, full.names = TRUE)
  pkgs <- lapply(setNames(pkgs, basename(pkgs)), read_dcf)
  pkgs
}


read_dcf <- function(pkg) {
  desc <- read.dcf(file.path(pkg, "DESCRIPTION"))
  desc <- setNames(as.list(desc), colnames(desc))
  desc
}


# downlaod and insert -----------------------------------------------------


download_and_insert <- function(pkg, version) {
  pkg_file <- paste0(pkg, "_", version, ".tar.gz")
  pkg_url <- pkg_url(pkg, version)

  download.file(pkg_url, pkg_file)
  drat::insertPackage(pkg_file)

  unlink(pkg_file)
}


pkg_url <- function(pkg, version) {
  url <- paste0(pkg, "_", version, ".tar.gz")

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


# valid drat repo ---------------------------------------------------------


valid_drat_repo <- function() {
  # TODO: implement this function
  TRUE
}
