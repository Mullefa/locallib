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
      warning(
        "the namespace of ", pkg$name, " is currently loaded. ",
        "Not attempting installation into the local library.",
        call. = FALSE
      )
    } else {
      install.packages(pkg$name, ...)
    }
  }
}

