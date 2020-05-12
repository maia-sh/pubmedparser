#' Batch DOIs for Eutils server limits
#'
#' Batch DOIs to account for Eutils server limits
#' @param dois Character vector of DOIs.
#' @param batch_size Number of DOIs to include per batch. Default = 100.
#' @return List of character vectors of DOIs. Each element is a single DOI batch. List is of length number of batches (\code{dois} divided by \code{batch_size}). Can be a list of length 1 if \code{length(dois) < batch_size}.
#' @export
#' @examples
#' my_dois <- c("10.3389/fpsyt.2018.00207", "10.1186/s40779-018-0166-5", "10.1186/s12959-018-0173-5", "10.1103/PhysRevD.97.096016", "10.1038/d41586-018-05113-0")
#'
#' # Returns a list of length 1
#' batch_dois(my_dois)
#'
#' # Returns a list of length 2
#' batch_dois(my_dois, batch_size = 3)
#'

batch_dois <- function(dois, batch_size = 100) {
  split(dois, ceiling(seq_along(dois)/batch_size))
}
