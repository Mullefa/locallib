# package download --------------------------------------------------------


download_pkg <- function(pkg, version, type, use_archive = TRUE) {
  destfile <- file.path(tempdir(), pkg_file(pkg, version, type))
  urls <- pkg_urls(pkg, version, type, use_archive)

  until_success(urls, download_file, destfile = destfile, error_msg = paste(
    "unable to download package", pkg, bracket(version)
  ))
}


download_file <- function(url, destfile) {
  download.file(url, destfile)
  destfile
}


# Can return multiple urls if multiple repositories have been set.
#
# SCENARIO:
#   1. latest source version (lv) is greater than latest binary version (bv)
#   2. latest source version specified in yaml file
#   3. installing with type binary
#
# FIXME: if use_archive = TRUE (typically is), the url of the latest source
# package will point to an archive file.
pkg_urls <- function(pkg, version, type, use_archive) {

  lv <- latest_version(pkg, type)

  if (version != lv) {
    if (type == "binary") {
      warn(
        "Package ", pkg, " ", bracket(version), " ",
        "is not the latest version ", bracket(lv), ". ",
        "Installing from source instead of binary."
      )
      type <- "source"
    }
  }

  base_url <- pkg_file(pkg, version, type)

  if (version != lv && use_archive) {
    base_url <- paste0("00Archive/", pkg, "/", base_url)
  }

  paste0(contrib.url(getOption("repos"), type), "/", base_url)
}


latest_version <- function(pkg, type) {
  stopifnot(type %in% c("source", "binary"))

  m <- available.packages(contrib.url(getOption("repos"), type))
  out <- unname(m[rownames(m) == pkg, ]["Version"])

  if (!is.na(out)) out else {
    error("Latest verion of ", pkg, " can't be found (type: ", type, ").")
  }
}


pkg_file <- function(pkg, version, type) {
  stopifnot(type %in% c("source", "binary"))

  fn <- if (type =="binary") {
    if (.Platform$OS.type == "windows") ".zip" else ".tgz"
  } else ".tar.gz"

  paste0(pkg, "_", version, fn)
}


default_pkg_type <- function() {
  if (getOption("pkgType") == "source") "source" else "binary"
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
