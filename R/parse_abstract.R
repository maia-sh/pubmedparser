#' Extract info about abstract from PubMed article
#'
#' Extract info about abstract from a single PubMed article. See [MEDLINE PubMed XML Elements](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) for details on elements. See [Structured Abstracts in MEDLINE](https://structuredabstracts.nlm.nih.gov/) for details.
#'
#' @param pubmed_article pubmed_article Unparsed or parsed XML of class PubmedArticle. Generally called by \code{\link{parse_pubmed_article_set}} to parse articles within article set.
#' @return Dataframe of information about abstract.
#' @export
#' @examples

# res$abstract <- get_value(".//AbstractText")
#
# Abstract may be truncated - check for "ABSTRACT TRUNCATED"
# OtherAbstract

# https://structuredabstracts.nlm.nih.gov/
#TODO: decide what abstract info important
# abstract df: whether truncated; whether structured; if unstructured, abstract text; if structured, col per label, e.g. BACKGROUND, OBJECTIVE, METHODS, RESULTS, CONCLUSIONS, UNASSIGNED; mush all the rest (paste? nest?) in OTHER?
# lists of allowed labels: https://structuredabstracts.nlm.nih.gov/downloads.shtml

parse_abstract <- 1
