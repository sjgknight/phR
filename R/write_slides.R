write_slides <- function(pptx, targetpath){

  print(pptx, target = targetpath)

  bibs <- RefManageR::ReadBib("data/bib.bib")
  pkgs <- RefManageR::ReadBib("data/pkgs.bib")

  refs <- officer::read_pptx(targetpath) %>%
    officer::add_slide(layout = "Layout-head-text", master = "Office Theme") %>%
    officer::ph_with(location = ph_location_type(ph_type = "body"),
                     value = unordered_list(
                       str_list = paste0(format(pkgs)),
                       level_list = rep(1, length(pkgs)))) %>%
    officer::add_slide(layout = "Layout-head-text", master = "Office Theme") %>%
    officer::ph_with(location = ph_location_type(ph_type = "body"),
                     value = unordered_list(
                       str_list = paste0(format(bibs)),
                       level_list = rep(1, length(bibs))))

  print(refs, target = targetpath)
  return(refs)
}
