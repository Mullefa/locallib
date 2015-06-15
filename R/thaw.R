#' Install the packages specified a pkg.yaml file
#'
#' @param ... Further arguments to pass to \code{\link{install.packages}()}
#'  (not the package name).
#'
#' @export
thaw <- function(...) {
  if (!is.activated()) {
    stop("local library must be activated to use thaw()", call. = FALSE)
  }

  path <- file.path(meta_data$path, "pkgs.yaml")
  pkgs <- yaml::yaml.load_file(path)

  # FIXME: need to decide how to handle yaml dependency
  pkgs$packages <- Filter(function(pkg) pkg$name %notin% global_pkgs(), pkgs$packages)

  if (pkgs$R_version != R_version()) {
    warning(
      "R version of current environment ", bracket(R_version()), " ",
      "is different to R version in which the local library was created ",
      bracket(pkgs$R_version), call. = FALSE
    )
  }

  for (pkg in pkgs$packages) {
    if (pkg$name %in% loadedNamespaces()) {
      stop(
        "the namespace of ", pkg$name, " is currently loaded. ",
        "Not attempting installation into the local library.",
        "Restart R, activate the local library, and try again.",
        call. = FALSE
      )
    }
  }

  lib_path <- file.path(meta_data$path, "library")
  lib_pkgs <- read_dcfs(lib_path)

  for (pkg in pkgs$packages) {
    lib_pkg <- lib_pkgs[[pkg$name]]

    if (!is.null(lib_pkg) && pkg$version == lib_pkg$Version) {
      message(pkg$name, " ", bracket(pkg$version)," already installed locally")
    }  else {
      pkg_version <- pkg$version %||% {
        warning(
          "no version given for package ", pkg$name, ". ",
          "Installing the latest version.", call. = FALSE
        )
        latest_version(pkg$name)
      }

      download_and_install(pkg$name, pkg_version)
    }
  }
}


# When installing a package which is not the latest version, there are two scenarios:
# 1. the package will be in src/contrib/00Archive/<pkgname>/ (e.g. CRAN)
# 2. the package will be in src/contrib/ (e.g. a drat repository)
# Both these scenarios are handled in the tryCatch() call.
download_and_install <- function(pkg, version) {
  pkg._ <- pkg_file(pkg, version)
  url <- pkg_url(pkg, version, archive = TRUE)

  tryCatch(
    download.file(url, pkg._),
    error = function(e) {
      url <- pkg_url(pkg, version, archive = FALSE)
      download.file(url, pkg._)
    }
  )

  install.packages(pkg._, repos = NULL, type = "source")

  unlink(pkg._)
}

