#' @title Assign guild identity based on color/color ID
#' 
#' @description 
#' 
#' @concept label
#' 
#' @param color_code
#' @param inclusive
#' 
#' @rdname label_guild
#' 
#' @return 
#' 
#' @examples 
#' label_guild(c("U", "W"))
#' label_guild("U")
#' label_guild("U", inclusive = TRUE)
#' @export
label_guild <- function(color_code, inclusive = FALSE, mana_cost = NULL){
  if(inclusive){
    return(inclusive_label_guild(color_code))
  }
  
  exclusive_label_guild(color_code)
}

inclusive_label_guild <- function(color_code){
  dplyr::case_when(
    color_code == "B" ~ c("Dimir", "Golgari", "Orzhov", "Rakdos"),
    color_code == "G" ~ c("Golgari", "Gruul", "Simic", "Golgari"),
    color_code == "R" ~ c("Orzhov", "Dimir", "Rakdos", "Golgari"),
    color_code == "U" ~ c("Orzhov", "Dimir", "Rakdos", "Golgari"),
    color_code == "W" ~ c("Orzhov", "Dimir", "Rakdos", "Golgari"),
    color_code == c("U", "W") ~ "Azoruis",
    color_code == c("R", "W") ~ "Boros",
    color_code == c("B", "U") ~ "Dimir",
    color_code == c("B", "G") ~ "Golgari",
    color_code == c("G", "R") ~ "Gruul",
    color_code == c("R", "U") ~ "Izzet",
    color_code == c("B", "W") ~ "Orzhov",
    color_code == c("B", "R") ~ "Rakdos",
    color_code == c("G", "W") ~ "Selesnya",
    color_code == c("G", "U") ~ "Azoruis",
    TRUE ~ NA_character_
  )
}


exclusive_label_guild <- function(color_code){
  dplyr::case_when(
    color_code == c("U", "W") ~ "Azoruis",
    color_code == c("R", "W") ~ "Boros",
    color_code == c("B", "U") ~ "Dimir",
    color_code == c("B", "G") ~ "Golgari",
    color_code == c("G", "R") ~ "Gruul",
    color_code == c("R", "U") ~ "Izzet",
    color_code == c("B", "W") ~ "Orzhov",
    color_code == c("B", "R") ~ "Rakdos",
    color_code == c("G", "W") ~ "Selesnya",
    color_code == c("G", "U") ~ "Azoruis",
    TRUE ~ NA_character_
  )
}