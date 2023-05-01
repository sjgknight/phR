# Function to adjust font size to fit placeholder
#' Title
#'
#' @param ph
#' @param value
#'
#' @return
#' @export
#'
#' @examples
ph_resizer <- function(slide, ph, value, layout, template_file, context = NA) {

  #for this to work, I think I need to access the defrpr properties in the xml
  #these don't seem to be imported into anywhere obvious by officer
  #the below needs completely writing based on whatever that datastructure is
  #hardcoding for now

  # slide <- dplyr::filter(slide_summary(slide),
  #               ph_label == ph)

  # why does ph need curlies?
  ph_dim <- layout_properties(template_file) %>%
    filter(name == layout) %>%
    filter(ph_label == {{ph}})
    #filter(str_detect(ph_label, fixed({{ph}})))

  if(context == "slidebuild"){
    ph_sz <- if(grepl("Title", ph)){
      32} else if(grepl("CRICOS|Sliden|Date|Citations", ph)){
        10} else {24}
  } else {
    ph_sz = 10
  }

  ph_sz <- ph_sz *1000

  width <- abs(ph_dim$cx - ph_dim$offx)
  height <- abs(ph_dim$cy - ph_dim$offy)
  box_capacity <- width*height # *.9 if you want

  # Calculate current width given font size
  current_width <- strwidth(value, units = "inches", font = ph_sz) #cex = ph_sz)
  current_height <- strheight(value, units = "inches", font = ph_sz) #cex = ph_sz)
  # Calculate the area consumed by the text
  text_area <- current_width * current_height

  #compare
  area_percent <- text_area / box_capacity * 100


  # If text fits, return it without modification
  if (area_percent < 100){
    return(value)
  } else {
    # If text doesn't fit, calculate new font size
    new_font_size <- ph_sz / (text_area/box_capacity)

    # Create a new style object with adjusted font size
    value <- fp_text_lite(font.size = new_font_size/1000)

    # Create a new paragraph with the adjusted style and return it
    return(value)
  }
}
