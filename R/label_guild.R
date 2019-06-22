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
    identical(color_code, "B") ~ list("Dimir", "Golgari", "Orzhov", "Rakdos"),
    identical(color_code, "G") ~ list("Golgari", "Gruul", "Simic", "Golgari"),
    identical(color_code, "R") ~ list("Orzhov", "Dimir", "Rakdos", "Golgari"),
    identical(color_code, "U") ~ list("Orzhov", "Dimir", "Rakdos", "Golgari"),
    identical(color_code, "W") ~ list("Orzhov", "Dimir", "Rakdos", "Golgari"),
    identical(color_code, c("U", "W")) ~ list("Azoruis"),
    identical(color_code, c("R", "W")) ~ list("Boros"),
    identical(color_code, c("B", "U")) ~ list("Dimir"),
    identical(color_code, c("B", "G")) ~ list("Golgari"),
    identical(color_code, c("G", "R")) ~ list("Gruul"),
    identical(color_code, c("R", "U")) ~ list("Izzet"),
    identical(color_code, c("B", "W")) ~ list("Orzhov"),
    identical(color_code, c("B", "R")) ~ list("Rakdos"),
    identical(color_code, c("G", "W")) ~ list("Selesnya"),
    identical(color_code, c("G", "U")) ~ list("Azoruis"),
    TRUE ~ list(NA_character_)
  )
}


exclusive_label_guild <- function(color_code){
  dplyr::case_when(
    identical(color_code, c("U", "W")) ~ list("Azoruis"),
    identical(color_code, c("R", "W")) ~ list("Boros"),
    identical(color_code, c("B", "U")) ~ list("Dimir"),
    identical(color_code, c("B", "G")) ~ list("Golgari"),
    identical(color_code, c("G", "R")) ~ list("Gruul"),
    identical(color_code, c("R", "U")) ~ list("Izzet"),
    identical(color_code, c("B", "W")) ~ list("Orzhov"),
    identical(color_code, c("B", "R")) ~ list("Rakdos"),
    identical(color_code, c("G", "W")) ~ list("Selesnya"),
    identical(color_code, c("G", "U")) ~ list("Azoruis"),
    TRUE ~ list(NA_character_)
  )
}