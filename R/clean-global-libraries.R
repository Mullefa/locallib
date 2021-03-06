#' Clean global libraries
#'
#' @export
clean_global_libs <- function() {
  paths <- unlist(lapply(global_libs(), list.files, full.names = TRUE))
  paths <- Filter(function(path) basename(path) %notin% global_pkgs(), paths)

  if (length(paths) == 0) {
    message("Global library is already clean")
    return(invisible())
  }

  message(
    paste0(
      "The following packages will be removed:\n",
      paste(" -", basename(paths), bracket(dirname(paths)), sep = " ", collapse = "\n")
    )
  )

  ans <- readline("Are you sure you want to continue? [y/n]")

  if (ans != "y") {
    message("no packages will be deleted")
    return(invisible())
  }

  message("cleaning global library(s)")

  for (path in paths) {
    pkg <- basename(path)
    lib <- dirname(path)

    message("- removing package ", pkg, " ", bracket(lib))

    tryCatch(
      remove.packages(pkg, lib),
      error = function(e) {
        message("  * unable to remove package")
      }
    )
  }
}



