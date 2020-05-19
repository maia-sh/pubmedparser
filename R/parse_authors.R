#' Extract info about authors from PubMed article
#'
#' Extract info about authors from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about authors.
#' @export
#' @examples


# res$authors <- paste(get_value(".//Author/LastName"), get_value(".//Author/ForeName"), sep = ", ")

# authors_scope <- doc %>% xml_find_all("//Author")
# authors_tbl <- authors_scope %>% map_df(~tibble(
#   first_names = xml_find_first(., "./ForeName") %>% xml_text,
#   last_names = xml_find_first(., "./LastName") %>% xml_text,
#   affiliation = xml_find_all(., ".//Affiliation") %>% xml_text
# ))

parse_authors <- 1
