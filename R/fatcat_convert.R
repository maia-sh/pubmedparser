#' Convert between PMIDs and DOIs using the [Fatcat](https://fatcat.wiki/) [API](https://api.fatcat.wiki/)
#'
#' Non-vectorized function. Wrap in `purrr::map_dfr()` to call on multiple ids.
#'
#' @param is PMID (character) or DOI (character or numeric)
#' @param type Character. Either "doi" or "pmid"
#'
#' @return One row dataframe with DOI and PMID. If `id` not found in Fatcat, returns `id` and NA for other id type.
#'
#' @export
#'
#' @examples
#' fatcat_convert(32786189, "pmid")
#' purrr::map_dfr(
#'   c("10.1056/NEJMoa1916623", "10.1038/ncomms11393", "10.5348/D01-2017-21-OA-1"),
#'   fatcat_convert,
#'   type = "doi"
#' )

fatcat_convert <- function(id, type) {

  if (!exists("type") || !type %in% c("doi", "pmid")){
    rlang::abort('`type` must be "doi" or "pmid"')
  }

  url <-
    paste0("https://api.fatcat.wiki/v0/release/lookup?", type, "=", id)

  res <- httr::GET(url)

  # Error handling: return `id` and NA
  if (res$status_code != 200) {
    if (type == "doi") {
      doi = id
      pmid = NA
    } else {
      pmid = id
      doi = NA
    }
  }

  if (res$status_code == 200) {
    parsed <- suppressMessages(jsonlite::parse_json(res))
    pmid <- parsed$ext_ids$pmid
    doi <- parsed$ext_ids$doi
  }

  tibble::as_tibble_row(c(doi = doi, pmid = pmid))
}