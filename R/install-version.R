#' Install a particular version of a package
#'
#' @param pkg(string) Package name.
#' @param version(string) Package version.
#'
#' @export
install_version <- function(pkg, version) {
  pkg._ <- download_pkg(pkg, version) %recover_with%
    download_pkg(pkg, version, archive = FALSE)

  on.exit(unlink(pkg._))

  # FIXME: if R_LIBS is set in .Renviron, this may not work for some reason?!
  install.packages(pkg._, repos = NULL, type = "source")
}

# When installing a package which is not the latest version, there are two scenarios:
# 1. the package will be in src/contrib/00Archive/<pkgname>/ (e.g. CRAN)
# 2. the package will be in src/contrib/ (e.g. a drat repository)
# Both these scenarios are handled in the tryCatch() call.
