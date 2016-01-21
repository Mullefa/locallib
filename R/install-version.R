#' Install a particular version of a package into a local library
#'
#' @param pkg(string) Package name.
#' @param version(string) Package version. Default: latest version.
#'
#' @section Errors:
#' \itemize{
#'   \item{local library not activated}
#'   \item{latest version of package can't be found}
#'   \item{package can't be downloaded}
#' }
#'
#' @export
install_version <- function(pkg, version = NULL) {
  if (!is.activated()) {
    error("local library must be activated to use this function")
  }

  version <- version %||% local({
    # Throws an error if latest version can't be found.
    out <- latest_version(pkg)
    warn(
      "No version given for package ", pkg, " specified. ",
      "Installing the latest version ", bracket(out), "."
    )
    out
  })

  if (is.installed_locally(pkg, version)) {
    message(pkg, " ", bracket(version)," already installed locally")
  } else {
    destfile <- download_pkg(pkg, version) %recover_with%
      download_pkg(pkg, version, archive = FALSE) %recover_with%
      error("Unable to download the package ", pkg, " ", bracket(version), ".")

    on.exit(unlink(destfile))

    # FIXME: if R_LIBS is set in .Renviron, this may not work for some reason?!
    install.packages(destfile, repos = NULL, type = "source")
  }
}


is.installed_locally <- function(pkg, version) {
  lib_pkg <- read_dcfs(local_lib())[[pkg]] %||% return(FALSE)
  # FIXME: what if version > lib_pkg$Version?
  version == lib_pkg$Version
}

# When installing a package which is not the latest version, there are two scenarios:
# 1. the package will be in src/contrib/00Archive/<pkgname>/ (e.g. CRAN)
# 2. the package will be in src/contrib/ (e.g. a drat repository)
# Both these scenarios are handled in the tryCatch() call.
