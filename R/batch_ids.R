#' Batch IDs for Eutils server limits
#'
#' Batch IDs to account for Eutils server limits
#' @param ids Character vector of IDs.
#' @param batch_size Number of IDs to include per batch. Default = 100.
#' @return List of character vectors of IDs. Each element is a single DOI batch. List is of length number of batches (\code{ids} divided by \code{batch_size}). Can be a list of length 1 if \code{length(ids) < batch_size}.
#'
#' @examples
#' my_dois <- c("10.3389/fpsyt.2018.00207", "10.1186/s40779-018-0166-5", "10.1186/s12959-018-0173-5", "10.1103/PhysRevD.97.096016", "10.1038/d41586-018-05113-0")
#'
#' # Returns a list of length 1
#' batch_ids(my_dois)
#'
#' # Returns a list of length 2
#' batch_ids(my_dois, batch_size = 3)
#'
#' my_pmids <- c("29904359", "29855634", "29848381", "29805157")
#'
#'# Returns a list of length 1
#' batch_ids(my_pmids)
#'
#' # Returns a list of length 2
#' batch_ids(my_pmids, batch_size = 3)
#'
#'@export

batch_ids <- function(ids, batch_size = 100) {
  split(ids, ceiling(seq_along(ids)/batch_size))
}
