#' Output installed packages
#'
#' @export
freeze <- function() {
  if (!is.activated()) {
    error("local library must be activated to use this function")
  }

  pkgs <- read_dcfs(local_lib())
  deps <- tsort(lapply(pkgs, pkg_deps))

  deps <- Filter(function(dep) dep %notin% pkgignore(), deps)

  deps <- lapply(deps, function(dep) {
    list(
      name = dep,
      version = pkgs[[dep]]$Version %||%
        find_version(dep) %||% {
          warn(
            "dependency ", dep, " cannot be found in any of the libraries. ",
            "Is it installed?!"
          )
          NULL
        }
    )
  })

  for (dep in deps) {
    if (is.null(dep$version)) {
      warn("could not find version of package ", bracket(dep))
    }
  }

  out <- list(R_version = R_version(), packages = deps)
  write(yaml::as.yaml(out), file.path(meta_data$path, "pkgs.yaml"))

  invisible(out)
}


# A hacky topological sort which which reduces the set of all nodes recursively by
# removing nodes which are not incoming nodes. Needs improvement, in particular,
# informative error messages for cyclic graphs.

tsort <- function(deps) {
  for (dep in names(deps)) {
    if (dep %in% deps[[dep]]) {
      error("package can not depend on itself ", bracket(dep))
    }
  }

  incoming <- function() {
    unique(unlist(deps, use.names = TRUE))
  }

  nodes <- union(names(deps), incoming())
  n <- length(nodes)
  out <- character(n)
  i <- n

  while (length(nodes)) {
    inc <- incoming()
    j <- i

    for (node in nodes) {
      if (node %notin% inc) {
        nodes <- setdiff(nodes, node)
        deps[[node]] <- NULL
        out[i] <- node
        i <- i - 1
      }
    }

    if (i == j) error("cyclic dependency")
  }

  out
}


# find version ------------------------------------------------------------


find_version <- function(pkg_name) {
  for (path in .libPaths()[-1]) {
    pkg <- read_dcf(file.path(path, pkg_name))

    if (!is.null(pkg) && !is.null(pkg$Version)) {
      return(pkg$Version)
    }
  }

  NULL
}
