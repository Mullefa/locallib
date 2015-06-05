#' Recreate a virtual environment
#'
#' @param ... Further arguments to pass to \code{\link{install.packages}()}
#'  (not the package name).
#'
#' @export
thaw <- function(...) {
  if (!is.activated()) {
    stop("virtual environment must be activated to use thaw()", call. = FALSE)
  }

  path <- file.path(meta_data$path, "pkgs.yaml")
  pkgs <- yaml::yaml.load_file(path)

  if (pkgs$R_version != R_version()) {
    warning(
      "R version of current environment ", bracket(R_version()),
      " is different to R version in which the virtual environment was created", bracket(pkgs$R_version),
      call. = FALSE
    )
  }

  for (pkg in pkgs$packages) {
    if (pkg$name %in% loadedNamespaces()) {
      stop(
        "the namespace of ", pkg$name, " is currently loaded. ",
        "Not attempting installation into the local library.",
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
      download_and_install(pkg$name, pkg$version)
    }
  }
}


download_and_install <- function(pkg, version) {
  url <- pkg_url(pkg, version)
  pkg <- pkg_file(pkg, version)

  download.file(url, pkg)
  install.packages(pkg, repos = NULL, type = "source")

  unlink(pkg)
}

