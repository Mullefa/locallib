#' Output installed packages
#'
#' @export
freeze <- function() {
  if (!is.activated()) {
    stop("virtual environment must be activated to use this function")
  }

  lib_path <- file.path(meta_data$path, "library")

  pkgs <- read_dcfs(lib_path)
  deps <- lapply(pkgs, pkg_deps)
  deps <- Filter(function(dep) dep %notin% pkgignore(), tsort(deps))
  deps <- lapply(deps, function(dep) list(name = dep, version = pkgs[[dep]]$Version))

  out <- list(R_version = R_version(), packages = deps)
  write(yaml::as.yaml(out), file.path(meta_data$path, "pkgs.yaml"))

  invisible(out)
}

# FIXME: currently this will only pick up dependencies in the local library.
# Need to decide whether to extend this to other libraries to collect all
# non-base / recommended dependencies (such as drat, git2r and yaml)


# package deps ------------------------------------------------------------


pkg_deps <- function(pkg) {
  deps <- paste(c(pkg$Depends, pkg$Imports, pkg$LinkingTo), collapse = ",")
  parse_deps(deps)
}


parse_deps <- function(deps) {
  if (!length(deps) || deps == "") {
    return(NULL)
  }

  out <- strsplit(deps, ",")[[1]]
  out <- gsub("\\s||\\(.*\\)", "", out)
  out <- out[out != "R"]

  if (!length(out)) {
    NULL
  } else {
    out
  }
}
