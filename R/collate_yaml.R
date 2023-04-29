#takes the list of yaml files
#outputs just the key fields for reading (inc using cite_me)
collate_yaml <- function(yaml_list, bib, full_bib ){
  purrr::map(yaml_list, ~{
    yaml::yaml.load() %>%
      if(!is.null(.[["citation"]])){
        if(full_bib){
          .[["citation"]] = bib_me(bib, .[["citation"]])
        } else {
          yaml_data[["citation"]] = cite_me(bib, .[["citation"]])
        }
      }
      tibble::as_tibble()
  }) %>%
    dplyr::bind_cols()
}
