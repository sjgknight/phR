
pacman::p_load(dplyr,magrittr,purrr,tidyr,stringr,readr,ftExtra,RefManageR)

#setup citation function
cite_me <- function(citations, bib = bib, sep = ";") {
  TC <- function(citations, bib = bib) {
    #citekey = .x
    RefManageR::TextCite(bib = bib, citations, .opts = list(max.names = 3))
  }

    if_else(is.na(sep),
          TC(citations, bib),
          stringr::str_split(citations, sep) %>%
            purrr::map(~TC(.x, bib)) %>%
            unlist(use.names = FALSE)
  )
}

bib_me <- function(citations, bib = bib, sep = ";") {
  TC <- function(citations, bib = bib) {
    #citekey = .x
    format(bib[citations], style = "markdown")
  }

  if_else(is.na(sep),
          TC(citations, bib),
          stringr::str_split(citations, sep) %>%
            purrr::map(~TC(., bib)) %>%
            unlist(use.names = FALSE)
  )
}



#    title = RefManageR::TextCite(bib = bib, citation_key)
    #cat(names(print(bib[citation_key], "text")))
