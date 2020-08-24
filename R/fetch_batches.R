#' Fetch batches of records
#'
#' Batch IDs to account for Eutils server limits
#' @param esearch Esearch object. Generally the output of \code{\link{search_get_pmids}} or \code{\link{check_update_esearch}}.
#' @param fetch_start Record fetch should start with. Default to 1.
#' @param fetch_end Record fetch should end with. Defaults to NULL and dynamically set to max of esearch query.
#'  @param  batch_size Maximum batch size. Defaults to 10000, which is eutilities' limit.
#'  @param sleep_time Sleep between queries to respect server limits. Defaults to 0.2 seconds.
#'  @param dir Directory for saving files. Default to project root (\code{here::here()})
#' @param file_name Root for file names. Default to NULL and dynamically set to esearch query.
#' @param quiet Whether to silence messages in console. Defaults to FALSE.
#' @param save_each_batch Whether each batch should be saved as raw characters to file. Defaults to TRUE.
#' @param save_all_batches Whether all batches should be saved as vector of raw characters to file and nodeset. Defaults to FALSE (NOTE: This parameter is in development and should be set to FALSE.)
#' @return NULL
#'
#' @examples
#' # Run search and don't save any output
#' records_search <- search_get_pmids(term = "aquilegia[TITLE]",
#'                                    dir = NULL, output = NULL)
#' batch <- fetch_batches(records_search)
#'
#'@export

fetch_batches <- function(esearch, #or web_history?
                          fetch_start = 1,
                          fetch_end = NULL,
                          batch_size = 10000,
                          sleep_time = 0.2,
                          dir = here::here(),
                          file_name = NULL,
                          quiet = FALSE,
                          save_each_batch = TRUE,
                          # could separate raw/nodeset)
                          save_all_batches = FALSE){

  if (save_all_batches) {
    all_records_raw <- NULL
    all_records_nodeset <- NULL
  }

  if (is_null(fetch_end)) {fetch_end <- esearch$count}

  for (batch_start in seq(fetch_start, fetch_end, batch_size)) {

    rlang::inform(paste(batch_start, ":", esearch$web_history$WebEnv))

    esearch <- check_update_esearch(esearch)

    records_batch <- fetch_batch(esearch = esearch,
                                          batch_start = batch_start,
                                          records_max = fetch_end,
                                          batch_size = batch_size,
                                          save_file = save_each_batch,
                                          dir = dir)

    # If saving all batches, add batch to vector of all records
    if (save_all_batches) {

      # Raw characters: Each element is one batch as xml_doc
      all_records_raw <- append(all_records_raw, records_batch)

      # Extract nodeset
      articles_batch <-
        records_batch %>%
        xml2::read_xml() %>%
        xml2::xml_find_all("PubmedArticle")

      # Nodset: Each element is a node
      all_records_nodeset <- append(all_records_nodeset, articles_batch)
    }

    Sys.sleep(sleep_time)

  }

  # safe <- all_records_nodeset
  # safe2 <- articles_batch
  #
  # articles_batch %>%
  #   xml_add_parent("PubmedArticle", "PubmedArticleSet")

  # If saving all records, write out records
  if (save_all_batches) {

    # Write all records to a single .rds file
    # WARNING: This could be a very large file!
    # Each item in all_records is a batch and xml_document
    readr::write_rds(
      all_records_raw,
      paste0(dir, "/",
             Sys.Date(),"_",
             esearch$QueryTranslation, "_",
             "all-records_",
             format(esearch$count, scientific = FALSE),
             ".rds"
      )
    )

    #TODO: write out all_records_nodeset

  }
}
