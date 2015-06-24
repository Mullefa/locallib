#' Is a package installed locally
#'
#' Utility function to see if a package is installed locally.
#'
#' @param pkg(string) Name of package.
#' @param version(string) Package version. If \code{NULL}, function checks to see if any
#'   version of the package is installed.
#' @export
is.installed_locally <- function(pkg, version = NULL) {
  if (!is.activated()) {
    error("local library must be activated to check if a package is installed locally")
  }

  dcfs <- read_dcfs(local_lib())

  for (dcf in dcfs) {
    if (dcf$Package == pkg && dcf$Version == (version %||% dcf$Version)) {
      return(TRUE)
    }
  }

  FALSE
}
