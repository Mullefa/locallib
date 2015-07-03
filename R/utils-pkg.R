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


# package dependencies ----------------------------------------------------


pkg_deps <- function(pkg) {
  deps <- paste(c(pkg$Depends, pkg$Imports, pkg$LinkingTo), collapse = ",")
  parse_deps(deps)
}


parse_deps <- function(deps) {
  if (!length(deps) || deps == "") {
    return(NULL)
  }

  out <- strsplit(deps, ",")[[1]]
  out <- gsub("\\s||\\(.*\\)", "", out)

  # remove dependency on R, or empty strings created by trailing commas e.g. R,
  out <- out[out %notin% c("R", "")]

  if (!length(out)) {
    NULL
  } else {
    out
  }
}


# pkgignore ---------------------------------------------------------------


# FIXME: create robust version of this function
pkgignore <- function() {
  path <- file.path(meta_data$path, "pkgignore")

  if (file.exists(path)) {
    pkgs <- readChar(path, file.info(path)$size)
    pkgs <- strsplit(pkgs, "\n")[[1]]
  } else {
    pkgs <- NULL
  }

  c(BASE_AND_RECOMMENDED, pkgs)
}


BASE_AND_RECOMMENDED <- c(
  "base",
  "compiler",
  "datasets",
  "graphics",
  "grDevices",
  "grid",
  "methods",
  "parallel",
  "splines",
  "stats",
  "stats4",
  "tcltk",
  "KernSmooth",
  "MASS",
  "Matrix",
  "boot",
  "class",
  "cluster",
  "codetools",
  "foreign",
  "lattice",
  "mgcv",
  "nlme",
  "nnet",
  "rpart",
  "spatial",
  "survival",
  "tools",
  "translations",
  "utils",
  "00LOCK-locallib"
)
