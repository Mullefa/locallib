#' Install the packages specified a pkg.yaml file
#'
#' @export
thaw <- function() {
  if (!is.activated()) {
    error("local library must be activated to use thaw()")
  }

  path <- file.path(meta_data$path, "pkgs.yaml")
  pkgs <- yaml::yaml.load_file(path)

  # FIXME: need to decide how to handle yaml dependency
  pkgs$packages <- Filter(function(pkg) pkg$name %notin% global_pkgs(), pkgs$packages)

  if (pkgs$R_version != R_version()) {
    warn(
      "R version of current environment ", bracket(R_version()), " ",
      "is different to R version in which the local library was created ",
      bracket(pkgs$R_version)
    )
  }

  for (pkg in pkgs$packages) {
    if (pkg$name %in% loadedNamespaces()) {
      error(
        "the namespace of ", pkg$name, " is currently loaded. ",
        "Not attempting installation into the local library.",
        "Restart R, activate the local library, and try again."
      )
    }
  }

  lib_pkgs <- read_dcfs(local_lib())

  for (pkg in pkgs$packages) {
    lib_pkg <- lib_pkgs[[pkg$name]]

    if (!is.null(lib_pkg) && pkg$version == lib_pkg$Version) {
      message(pkg$name, " ", bracket(pkg$version)," already installed locally")
    } else {
      pkg_version <- pkg$version %||% {
        warn(
          "no version given for package ", pkg$name, ". ",
          "Installing the latest version."
        )
        latest_version(pkg$name)
      }

      install_version(pkg$name, pkg_version)
    }
  }
}
