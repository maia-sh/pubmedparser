#' Save PubMed files
#'
#' Save PubMed files as unparsed XML in ".txt" files, so that user can choose to parse with `XML` or `xml2` packages.
#'
#' @param pubmed_data Character vector of unparsed XML with root node "PubmedArticleSet". Generally the output of \code{\link{batch_fetch_pubmed_records}}.
#' @param dir Directory to save files to. Default = current directory via \code{getwd()}.
#' @return SIDE-EFFECT. Unparsed XML in ".txt" files with batch number
#' @export
#' @examples
#'
#' my_dois <- c("10.1186/s12970-020-0336-1", "10.1016/S0140-6736(19)32971-X", "10.1056/NEJMoa1905239", "10.1371/journal.pone.0226893", "10.1016/S2352-3026(19)30207-8")
#'
#' batch_dois() %>%
#' create_query_strings() %>%
#' batch_fetch_pubmed_records() %>%
#' write_pubmed_files()

# TODO: decide whether to save parsed or unparsed
# TODO: decide whether to save within fetch or after batch
# TODO: improve filenaming and user options

write_pubmed_files <- function(pubmed_data, dir = getwd(), prefix = "") {
  if (prefix != "") {prefix = paste0("_", prefix)}

  purrr::walk2(pubmed_data,
        paste0(dir, "/", Sys.Date(), prefix, "_pubmed_data_",
               1:length(pubmed_data), ".txt"),
        readr::write_file)
}
