#' Install a particular version of a package
#'
#' @param pkg(string) Package name.
#' @param version(string) Package version.
#'
#' @export
install_version <- function(pkg, version) {
  pkg._ <- pkg_file(pkg, version)
  url <- pkg_url(pkg, version, archive = TRUE)

  tryCatch(
    download.file(url, pkg._),
    error = function(e) {
      url <- pkg_url(pkg, version, archive = FALSE)
      download.file(url, pkg._)
    }
  )

  # FIXME: if R_LIBS is set in .Renviron, this may not work for some reason?!
  install.packages(pkgs = pkg._, repos = NULL, type = "source")

  unlink(pkg._)
}

# When installing a package which is not the latest version, there are two scenarios:
# 1. the package will be in src/contrib/00Archive/<pkgname>/ (e.g. CRAN)
# 2. the package will be in src/contrib/ (e.g. a drat repository)
# Both these scenarios are handled in the tryCatch() call.
