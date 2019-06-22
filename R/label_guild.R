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
  dplyr::case_when(
    inclusive & length(color_code) %in% c(1,2) ~ 
      inclusive_label_guild(color_code),
    !inclusive & length(color_code) ==  2 ~ exclusive_label_guild(color_code),
    TRUE ~ list(NA_character_)
  )
  
  if(inclusive){
    return(inclusive_label_guild(color_code))
  }
  
  exclusive_label_guild(color_code)
}

inclusive_label_guild <- function(color_code){
  dplyr::case_when(
    # 
    identical(color_code, list("B")) ~ 
      list("Dimir", "Golgari", "Orzhov", "Rakdos"),
    identical(color_code, list("G")) ~ 
      list("Golgari", "Gruul", "Selesnya", "Simic"),
    identical(color_code, list("R")) ~ 
      list("Boros", "Gruul", "Izzet", "Rakdos"),
    identical(color_code, list("U")) ~ 
      list("Azorius", "Dimir", "Izzet", "Simic"),
    identical(color_code, list("W")) ~ 
      list("Azorius", "Boros", "Orzhov", "Selesnya"),
    identical(color_code, list("U", "W")) ~ list("Azoruis"),
    identical(color_code, list("R", "W")) ~ list("Boros"),
    identical(color_code, list("B", "U")) ~ list("Dimir"),
    identical(color_code, list("B", "G")) ~ list("Golgari"),
    identical(color_code, list("G", "R")) ~ list("Gruul"),
    identical(color_code, list("R", "U")) ~ list("Izzet"),
    identical(color_code, list("B", "W")) ~ list("Orzhov"),
    identical(color_code, list("B", "R")) ~ list("Rakdos"),
    identical(color_code, list("G", "W")) ~ list("Selesnya"),
    identical(color_code, list("G", "U")) ~ list("Azoruis"),
    TRUE ~ list(NA_character_)
  )
}


exclusive_label_guild <- function(color_code){
  dplyr::case_when(
    identical(color_code, list("U", "W")) ~ list("Azoruis"),
    identical(color_code, list("R", "W")) ~ list("Boros"),
    identical(color_code, list("B", "U")) ~ list("Dimir"),
    identical(color_code, list("B", "G")) ~ list("Golgari"),
    identical(color_code, list("G", "R")) ~ list("Gruul"),
    identical(color_code, list("R", "U")) ~ list("Izzet"),
    identical(color_code, list("B", "W")) ~ list("Orzhov"),
    identical(color_code, list("B", "R")) ~ list("Rakdos"),
    identical(color_code, list("G", "W")) ~ list("Selesnya"),
    identical(color_code, list("G", "U")) ~ list("Azoruis"),
    TRUE ~ list(NA_character_)
  )
}