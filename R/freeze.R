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
  tdeps <- tsort(deps)
  tdeps <- Filter(function(dep) dep %notin% BASE_AND_RECOMENDED, tdeps)
  tdeps <- lapply(tdeps, function(dep) list(name = dep, version = pkgs[[dep]]$Version))

  out <- list(R_version = R_version(), packages = tdeps)
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


BASE_AND_RECOMENDED <- c(
  "base",
  "compiler",
  "datasets",
  "graphics",
  "grDevices",
  "grid",
  "methods",
  "parallel",
  "splines",
  "stats",
  "stats4",
  "tcltk",
  "KernSmooth",
  "MASS",
  "Matrix",
  "boot",
  "class",
  "cluster",
  "codetools",
  "foreign",
  "lattice",
  "mgcv",
  "nlme",
  "nnet",
  "rpart",
  "spatial",
  "survival",
  "utils"
)


R_version <- function() {
  rv <- R.Version()
  paste0(rv$major, ".", rv$minor)
}
