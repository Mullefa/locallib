# package download --------------------------------------------------------


download_pkg <- function(pkg, version, archive = TRUE) {
  pkg._ <- pkg_file(pkg, version)
  urls <- pkg_urls(pkg, version, archive)

  until_success(urls, download_file, destfile = pkg._, error_msg = paste(
    "unable to download package", pkg, bracket(version)
  ))
}


download_file <- function(url, destfile, ...) {
  download.file(url, destfile, ...)
  destfile
}


# can return multiple urls if multiple repositories have been set
pkg_urls <- function(pkg, version, archive) {
  pkg._ <- pkg_file(pkg, version)

  if (!is.latest_version(pkg, version) && archive) {
    base_url <- paste0("00Archive/", pkg, "/", pkg._)
  } else {
    base_url <- pkg._
  }

  paste0(contrib.url(getOption("repos"), "source"), "/", base_url)
}


is.latest_version <- function(pkg, version) {
  version == latest_version(pkg)
}


latest_version <- function(pkg) {
  m <- available.packages(contrib.url(getOption("repos"), "source"))
  m[rownames(m) == pkg, ]["Version"]
}


pkg_file <- function(pkg, version) {
  paste0(pkg, "_", version, ".tar.gz")
}


# DESCRIPTION -------------------------------------------------------------


read_dcfs <- function(path) {
  pkgs <- list.files(path, full.names = TRUE)
  out <- lapply(setNames(pkgs, basename(pkgs)), read_dcf)
  Filter(Negate(is.null), out)
}


read_dcf <- function(pkg) {
  desc <- tryCatch(
    read.dcf(file.path(pkg, "DESCRIPTION")),
    warning = read_dcf_error(pkg),
    error = read_dcf_error(pkg)
  )

  if (is.null(desc)) {
    return(NULL)
  }

  desc <- setNames(as.list(desc), colnames(desc))
  desc
}


read_dcf_error <- function(pkg) {
  function(...) {
    warn(
      "can not read description of ", basename(pkg), " in the local library. ",
      "If its not actually a package, consider deleting it."
    )
    NULL
  }
}


# global packages ---------------------------------------------------------


global_pkgs <- function() {
  c(BASE_AND_RECOMMENDED, "drat", "git2r", "locallib", "yaml")
}


global_libs <- function() {
  out <- .libPaths()

  if (is.activated()) {
    out <- Filter(function(x) x != local_lib(), .libPaths())
  }

  out
}
