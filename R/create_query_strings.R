#' Create PubMed query strings
#'
#' Create PubMed query strings for each DOI batch
#'
#' NOTE: I understand "query string" and "search string" to be synonymous. I use "query string" for internal consistency.
#' @param dois List or character vector of DOIs. For multiple DOI batches, use a list of character vectors. For a single doi batch, use a character vector or list (of length 1) of character vectors. Generally the output of \code{\link{batch_dois}}
#' @param term OPTIONAL. Character string of additional terms to append to each query string. Include appropriate booleans. See \href{https://www.ncbi.nlm.nih.gov/books/NBK3827/#_pubmedhelp_Search_Field_Descriptions_and_}{PubMed Help} for available tags.
#' @return Character vector of length number of batches (length \code{dois} if \code{dois} is a list, else 1)
#' @export
#' @examples
#'
#' # With a single batch of DOIs as a character vector
#' my_dois <- c("10.3389/fpsyt.2018.00207", "10.1186/s40779-018-0166-5", "10.1186/s12959-018-0173-5", "10.1103/PhysRevD.97.096016", "10.1038/d41586-018-05113-0")
#'
#' create_query_strings(my_dois)
#' create_query_strings(my_dois, term  = 'AND "clinical trial"[Publication Type]')
#'
#' # With multiple batches of DOIs as a list of character vectors
#' my_dois_list <- list(c("10.3389/fpsyt.2018.00207", "10.1186/s40779-018-0166-5", "10.1186/s12959-018-0173-5"), c("10.1103/PhysRevD.97.096016", "10.1038/d41586-018-05113-0"))
#'
#' create_query_strings(my_dois_list)
#'

#TODO: edit create_query_string() to take an additional arguments specific elements in the query string, e.g., "clinical trial"[Publication Type]"
#TODO: conditional piping

create_query_strings <- function(dois, terms = NULL) {

  # Create query string for single doi batch (character vector)
  create_query_string <- function(dois, terms) {

    query_string <- paste0('"', dois, '"[DOI]', collapse = ' OR ')

    if (!rlang::is_null(terms)) {
      query_string <- paste(query_string, terms)
    }

    return(query_string)
  }

  # Create query strings depending on character vector or list
  if (rlang::is_character(dois)) {
    create_query_string(dois, terms)
  } else if (rlang::is_list(dois)) {
    purrr::map_chr(dois, create_query_string, terms)
  }
}
