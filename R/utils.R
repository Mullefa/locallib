`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}


`%notin%` <- Negate(`%in%`)


normalize_path <- function(path) {
  tryCatch(
    normalizePath(path %||% ".", mustWork = TRUE),
    error = function(e) {
      stop("path is not valid", call. = FALSE)
    }
  )
}


bracket <- function(x) paste0("(", x, ")")


R_version <- function() {
  rv <- R.Version()
  paste0(rv$major, ".", rv$minor)
}


# A hacky topological sort which which reduces the set of all nodes recursively by
# removing nodes which are not incoming nodes. Needs improvement, in particular,
# informative error messages for cyclic graphs.

tsort <- function(deps) {
  for (dep in names(deps)) {
    deps[[dep]] <- setdiff(deps[[dep]], dep)
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

    if (i == j) stop(call. = FALSE)
  }

  out
}
