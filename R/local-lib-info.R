#' Local lib info
#'
#' Generate messages providing information on and related to the local library.
#'
#' @export
local_lib_info <- function() {
  message("local lib info:")
  message("================")

  if (!is.activated()) {
    message("- no local library activated")
  } else {
    message("- local library activated ", bracket(meta_data$path))
  }

  if (is.local_drat_repo_set()) {
    message("- local drat repos set ", bracket(local_drat_repo()))
  } else {
    message("- local drat repo not set")
  }

  message("- package search paths:")

  for (path in .libPaths()) {
    message("  * ", path)
  }
}
