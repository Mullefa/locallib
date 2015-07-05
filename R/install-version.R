#' Install a particular version of a package into a local library
#'
#' @param pkg(string) Package name.
#' @param version(string) Package version.
#'
#' @export
install_version <- function(pkg, version = NULL) {
  if (!is.activated()) {
    error("local library must be activated to use this function")
  }

  version <- version %||% local({
    out <- latest_version(pkg)
    warn(
      "no version given for package ", pkg, ". ",
      "Installing the latest version ", bracket(out), "."
    )
    out
  })

  if (is.installed_locally(pkg, version)) {
    message(pkg, " ", bracket(version)," already installed locally")
  } else {
    pkg._ <- download_pkg(pkg, version) %recover_with%
      download_pkg(pkg, version, archive = FALSE)

    on.exit(unlink(pkg._))

    # FIXME: if R_LIBS is set in .Renviron, this may not work for some reason?!
    install.packages(pkg._, repos = NULL, type = "source")
  }
}


is.installed_locally <- function(pkg, version) {
  lib_pkg <- read_dcfs(local_lib())[[pkg]] %||% return(FALSE)
  version == lib_pkg$Version
}

# When installing a package which is not the latest version, there are two scenarios:
# 1. the package will be in src/contrib/00Archive/<pkgname>/ (e.g. CRAN)
# 2. the package will be in src/contrib/ (e.g. a drat repository)
# Both these scenarios are handled in the tryCatch() call.
