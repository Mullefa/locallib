# FIXME: create robust version of this function
pkgignore <- function() {
  path <- file.path(meta_data$path, "pkgignore")

  if (file.exists(path)) {
    pkgs <- readChar(path, file.info(path)$size)
    pkgs <- strsplit(pkgs, "\n")[[1]]
  } else {
    pkgs <- NULL
  }

  c(BASE_AND_RECOMMENDED, pkgs)
}


BASE_AND_RECOMMENDED <- c(
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
  "tools",
  "translations",
  "utils",
  "00LOCK-virtualenv"
)
