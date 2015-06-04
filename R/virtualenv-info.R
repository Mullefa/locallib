#' Virtual environment info
#'
#' @export
virtualenv_info <- function() {
  if (!is.activated()) {
    message("virtual environment not currently activated")
  } else {
    message("virtual environment activated ", bracket(meta_data$path))
  }

  message("drat repos is located at ", drat_repo())
}
