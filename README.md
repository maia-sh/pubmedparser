# *UNDER DEVELOPMENT*

---

# Description
The `pubmedparser` package extends the [rentrez](https://github.com/ropensci/rentrez) for batch downloading [PubMed](https://www.ncbi.nlm.nih.gov/pubmed/) records using [NCBI E-Utilities](https://www.ncbi.nlm.nih.gov/books/NBK25497/). It allows the user to batch dois, query NCBI Eutils in batches, and download the resulting PubMed records.

The `pubmedparser` package uses [xml2](https://github.com/r-lib/xml2) to parse [PubMed XML](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) into a tidy format.

# Sample Usage

```R
library(pubmedparser)
```

## PART 1: Retrieve and save PubdMed records

```R
my_dois <-
  c("10.3389/fpsyt.2018.00207",
    "10.1186/s40779-018-0166-5",
    "10.1186/s12959-018-0173-5",
    "10.1103/PhysRevD.97.096016",
    "10.1038/d41586-018-05113-0",
    "10.1186/s12888-019-2026-6",
    "10.1016/j.genhosppsych.2017.10.001",
    "10.1097/PSY.0000000000000332",
    "10.1111/jcpe.12441"
  )


# Get an unparsed XML file of my_dois
my_article_set <-
  my_dois %>%
  batch_dois() %>%
  create_query_strings() %>%
  batch_fetch_pubmed_records()
  
# Save file to current directory
# write_pubmed_files(my_article_set)
````

## PART 2: Extract and tidy data from PubMed records
```R
parse_pubmed_article_set()
parse_pubmed_article()
parse_databanks()
parse_abstract()
parse_authors()
parse_references()
parse_publication_types()
parse_mesh_terms()
parse_keywords()
```

```R
# Parse article set as xml_document
article_set <- xml2::read_xml(my_article_set)

# Extract all articles as xml_nodeset
articles <- article_set %>% xml2::xml_find_all("PubmedArticle")

# Extract single article as xml_node
# article <- article_set %>% xml2::xml_find_first("PubmedArticle")
article <- articles[[6]]

single_article <- parse_pubmed_article(article)
multi_article <- parse_pubmed_article_set(article_set)

single_article_databanks <- parse_databanks(article)

```
