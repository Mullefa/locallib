#' Activate a local library remotely.
#'
#' This function activates the current local library activated on each of the nodes of
#' a cluster.
#'
#' @param .cl(cluster) A \code{multidplyr} cluster.
#'
#' @return \code{cluster}: The cluster \code{.cl} with the locally activated local library
#'   activated on each of the remote nodes.
#'
#' @section Errors:
#' \itemize{
#'   \item{argument \code{.cl} does not inherit from class \code{cluster}}
#'   \item{locally library not activated locally}
#'   \item{namespace \code{multidplyr} cannot be loaded}
#' }
#'
#' @export
cluster_use_local_lib <- function(.cl) {
  if (!is.activated()) {
    error("Local lib must be activated locally before it is activated on each node.")
  }

  if (!inherits(.cl, "cluster")) {
    error(
      "Argument .cl must inherit from class cluster. ",
      "See multidplyr::create_cluster() for creating clusters."
    )
  }

  tryCatch(
    loadNamespace("multidplyr"),
    error = function(...) {
      error("Package multidplyr must be available to use cluster_use_local_lib().")
    }
  )

  multidplyr::cluster_library(.cl, "locallib")
  multidplyr::cluster_call(.cl, "use_local_lib", path = meta_data$path)

  invisible(.cl)
}
