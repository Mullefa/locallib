if (!file.exists("~/git")) {
  dir.create("~/git")
}

tryCatch(
  drat::initRepo(),
  error = function(e) {
    message(e)
  }
)
