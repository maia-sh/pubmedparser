The `pubmedparser` package extends the [rentrez](https://github.com/ropensci/rentrez) for batch downloading [PubMed](https://www.ncbi.nlm.nih.gov/pubmed/) records using [NCBI E-Utilities](https://www.ncbi.nlm.nih.gov/books/NBK25497/). It allows the user to batch dois, query NCBI Eutils in batches, and download the resulting PubMed records.

The `pubmedparser` package uses [xml2](https://github.com/r-lib/xml2) to parse [PubMed XML](https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html) into a tidy format.

# Retrieve and save records

```R
my_dois <- c("10.1186/s12970-020-0336-1", "10.1016/S0140-6736(19)32971-X", "10.1056/NEJMoa1905239", "10.1371/journal.pone.0226893", "10.1016/S2352-3026(19)30207-8")

my_dois %>% 
batch_dois() %>%
create_query_strings() %>%
batch_fetch_pubmed_records() %>%
write_pubmed_files()
````

