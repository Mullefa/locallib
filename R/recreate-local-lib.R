#' Recreate a local library
#'
#' @param path(string) Path of directory to create the local library in.
#'
#' @export
recreate_local_lib <- function(path = NULL) {
  if (is.activated()) {
    error("local library must not be activated to call this function")
  }

  create_local_lib(path)
  use_local_lib(path)
  thaw()
}
