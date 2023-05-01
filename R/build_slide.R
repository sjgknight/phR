library(officer)
library(yaml)

#' Title
#'
#' @param yaml_file a yaml file with keys mapped to ph_label
#' @param layout a layout name from the template_file
#' @param template_file a path to the pptx with master slides
#' @param update default FALSE, if TRUE update an existing slide based on key slidenumber, else add new slide
#' @param discard default TRUE, if yaml keys can't find matched ph_labels discard or (if FALSE) insert into body
#' @param full_bib default TRUE, if FALSE, uses inline citation, if true full bibliographic reference
#' @param bib default empty, if provided used for references
#'
#' @return
#' @export
#'
#' @examples
build_slide <- function(yaml_file,
                        layout = "Layout-head-text",
                        template_file,
                        update = FALSE,
                        discard = TRUE,
                        bib,
                        fullbib = TRUE) {
  Layout <- layout
  # Read YAML file
  yaml_data <- yaml::read_yaml(yaml_file)

  bib <- RefManageR::ReadBib(file = "data/bib.bib")
  invisible(tibble::tibble(citation = RefManageR::TextCite(bib = bib)))

  layout <- if(!is.null(yaml_data[["Layout"]])){yaml_data[["Layout"]]} else {layout}

  #if there are citations replace the keys with full bibliographic detail
  if(ymlthis::has_field(yaml_data, "Citations") && !is.null(yaml_data[["Citations"]])){
    if(fullbib){
    yaml_data[["Citations"]] = paste0(bib_me(citations = yaml_data[["Citations"]], bib = bib))
    } else {
    yaml_data[["Citations"]] = cite_me(citations = yaml_data[["Citations"]], bib = bib)
    }
  }

  #if there are dates replace them with todays date
  if(ymlthis::has_field(yaml_data, "Date")){
      yaml_data[["Date"]] = Sys.Date()
  }

  #add sliden
  if(ymlthis::has_field(yaml_data, "Sliden")){
    yaml_data[["Sliden"]] = tools::file_path_sans_ext((basename(yaml_file)))
  }

  #add cricos
  yaml_data[["CRICOS"]] = "CRICOS 00099F"


  #this is functionally defunct because it isn't reading in an original deck in any case
  #if I wanted to do something like this the way would be to base it on file modification date maybe
  #but I don't know how to read in an existing deck using officer
  slide <- officer::add_slide(template_file, layout = layout, master = "Office Theme")
    # if (all(update,"Sliden" %in% names(yaml_data))) {
    #   # select slide to update
    #   officer::on_slide(template_file, yaml_data[["Sliden"]])
    #   } else {
    #     # add a new slide
    #     officer::add_slide(template_file, layout = layout, master = "Office Theme")
    #     }


  # Loop through YAML data and replace placeholders with content
  for (key in names(yaml_data)) {
    # Handle images
    if (!is.null(yaml_data[[key]]) && is.character(yaml_data[[key]]) && grepl("\\.(jpg|jpeg|png|bmp|gif)$", yaml_data[[key]])) {
      img_path <- here::here(yaml_data[[key]])
      officer::ph_with(slide, location = ph_location_label(ph_label = key), value = officer::external_img(here::here(img_path)))
    }

    # Handle lists
    else if (grepl("^-\\s", yaml_data[[key]])) {
      # Unordered list
      items <- strsplit(yaml_data[[key]], "- ")[[1]][-1] # Remove first empty element
      #for (i in 1:length(items)) {
        officer::ph_with(slide, location = ph_location_label(ph_label = key), value = unordered_list(str_list = items, level_list = rep(1, length(items)))) #fpar(fp_text_lite(value = items[i], bullet = "+"), level = 1))
      #}
    } else if (grepl("^\\d+\\.\\s", yaml_data[[key]])) {
      # Ordered list
      items <- strsplit(yaml_data[[key]], "\\d+\\. ")[[1]][-1] # Remove first empty element
     # for (i in 1:length(items)) {
        officer::ph_with(slide,
                         location = ph_location_label(ph_label = key),
                         value = unordered_list(str_list = items, level_list = rep(1, length(items)))) #fpar(fp_text_lite(value = items[i], bullet = i), level = 1))
      #}
    } else {
      # Replace text
      if(key %in% officer::layout_properties(template_file, layout)$ph_label){
        officer::ph_with(slide,
                         location = ph_location_label(ph_label = key),
                          value = ph_resizer(slide = slide,
                                             layout = layout,
                                             context = "slidebuild",
                                             template_file = template_file,
                                             ph = key,
                                             value = yaml_data[[key]]))
                         #value = yaml_data[[key]]) ##fpar(fp_text_lite(yaml_data[[key]])))
      } else if (!discard) {
        officer::ph_with(slide,
                         location = ph_location_type(type = "body"),
                         value = yaml_data[[key]])
      }
    }
  }

  # Return the modified PowerPoint object
  return(template_file)
}
