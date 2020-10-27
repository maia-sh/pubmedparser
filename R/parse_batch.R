#' Parse batch of PubMed records and extract specified datatypes
#'
#' @param batch Batch of unparsed PubMed records, such as the output of \code{\link{fetch_batch}}.
#' @param pmids Vector of pmids
#' @param datatypes Types of data to extract from xml for which there is a corresponding "pubmed_" function ("table", "abstract", "databanks", "authors", "mesh", "keywords", "pubtypes")
#' @param file_name Root for file names. Default to "pubmed".
#' @param suffix Suffice for file names. For example, record numbers. Default to null.
#' @param dir Directory for saving files. Default to project root (\code{here::here()})
#' @param quiet Whether to silence messages in console. Defaults to FALSE.

parse_batch <- function(batch,
                        pmids = NULL,
                        datatypes = c("table", "abstract", "databanks",
                                     "authors", "mesh", "keywords",
                                     "pubtypes"),
                        file_name = "pubmed",
                        suffix = NULL,
                        dir = here::here(),
                        quiet = FALSE){

  # Create directory if it doesn't exist
  if (!fs::dir_exists(dir)) {fs::dir_create(dir)}

  # Use user-provided pmids, else extract from xml
  # Alternative to pubmed_nodeset would be to get pmids and  set_names (version 3/4), which seems faster but less readable and harder to write_rds of new pmids
  if (!is.null(pmids)) {
    articles  <-
      batch %>%
      read_xml() %>%
      xml_find_all("PubmedArticle") %>%
      set_names(pmids)
  } else {
    articles <- pubmed_nodeset(batch)
    pmids <- names(articles)

    write_rds(
      pmids,
      paste0(dir, "/",
             Sys.Date(),"_",
             file_name, "_",
             "pmids",
             if (!is.null(suffix)) paste0("_", suffix),
             ".rds"
      )
    )
  }
  # Create tables
  walk(datatypes, ~ extract_datatype(., articles, suffix = suffix, quiet = quiet))
}
