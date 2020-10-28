#' Parse batch of PubMed records and extract specified datatypes as csv's
#'
#' @param batch Batch of unparsed PubMed records, such as the output of \code{\link{fetch_batch}}.
#' @param pmids Vector of pmids. If pmids not user-provided, pmids will be saved as .rds.
#' @param datatypes Types of data to extract from xml for which there is a corresponding "pubmed_" function ("table", "abstract", "databanks", "authors", "mesh", "keywords", "pubtypes")
#' @param file_name Root for file names. Defaults to "pubmed".
#' @param suffix Suffice for file names. For example, record numbers. Default to null.
#' @param dir Directory for saving files. Defaults to project root (\code{here::here()})
#' @param quiet Whether to silence messages in console. Defaults to FALSE.
#' @param return Whether to return parsed xml. Defaults to TRUE. Set to FALSE if interested in only side-effect csv's.
#'
#' @return Parsed xml with names = pmids. Also, side-effect of specified datatypes as csv's.
#' @export

parse_batch <- function(batch,
                        pmids = NULL,
                        datatypes = c("table", "abstract", "databanks",
                                     "authors", "mesh", "keywords",
                                     "pubtypes"),
                        file_name = "pubmed",
                        suffix = NULL,
                        dir = here::here(),
                        quiet = FALSE,
                        return = TRUE){

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
    articles <- tidypubmed::pubmed_nodeset(batch)
    pmids <- names(articles)

    readr::write_rds(
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
  purrr::walk(datatypes,
       ~ extract_datatype(., articles,
                          file_name = file_name, suffix = suffix,
                          dir = dir, quiet = quiet)
  )

  if (return) articles
}
