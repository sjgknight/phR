#takes as input ymlist = a list of yaml files mapping content to layouts; template = the powerpoint template, read into R using officer
#' Title
#'
#' @param myslides
#' @param template_file
#' @param discard
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
build_deck <- function(myslides, template_file, discard = TRUE, layout, ...) {

  #get all citation keys from all files and create a bib file
  pacman::p_load_gh("paleolimbot/rbbt")

  keys <- purrr::map(myslides, ~{
    ym <- yaml::read_yaml(.x)

    if(ymlthis::has_field(ym, "Citations") && !is.null(ym[["Citations"]])){

      ym[["Citations"]] %>%
        stringr::str_split(";") %>%
        unlist(use.names = FALSE)
      }
    }
  )

  #create bib for cited works
  keys <- rbbt::bbt_write_bib("data/bib.bib",purrr::compact(keys), overwrite=T)
  bib <- RefManageR::ReadBib(file = "data/bib.bib")
  invisible(tibble::tibble(citation = RefManageR::TextCite(bib = bib)))

  #create bib for package refrences
  grateful::get_citations(grateful::scan_packages(), "data/pkgs.bib")

  #add the slide to the list of slides -
#  myslides[length(myslides)+1] <- paste0(here::here("data/"),length(myslides)+1,".yaml")

  # Create a PowerPoint object and add slide
  template_file <- officer::read_pptx(template_file)

  #compile all the slides
  purrr::map(myslides, ~build_slide(yaml_file = .x,
                                    template_file = template_file,
                                    discard = discard,
                                    layout = layout))
  }
