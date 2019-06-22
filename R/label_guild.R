#' @title Assign guild identity based on color/color identity
#' 
#' @description Given a card's color (or color identity), return the Ravinca 
#' guild assoicated with the card. By default, \code{label_guild} requires the 
#' card to be both of the guild's colors, but if \code{inclusive = TRUE}, 
#' mono-color cards are labeled with all guilds they could belong to. NOTE: 
#' cards with hybrid costs are treated as belonging to both colors, as though 
#' they were gold cards.
#' 
#' @concept label
#' 
#' @param color_code list of characters of the card's color/color identity, 
#' using WUBRG notation. Letters must be capital and in alphabetic order. If 
#' using with \code{link{[dplyr]mutate}} and the results of 
#' \code{link{scry_cards}}, use the \code{colors} or \code{color_identity} 
#' column.
#' @param inclusive if \{color_code} is just one (or no) color, should 
#' \code{label_guild} return all guilds that contain that color?
#' 
#' @rdname label_guild
#' 
#' @return a list of strings with all guild(s) matching the \{color_code}
#' 
#' @examples 
#' label_guild(list("U", "W"))
#' label_guild(list("U"))
#' label_guild(list("U"), inclusive = TRUE)
#' @export
label_guild <- function(color_code, inclusive = FALSE){
  if (!is.list(color_code)){
    rlang::abort("color_code needs to be a list")
  }
  
  labels <- dplyr::case_when(
    # if length == 2, doesn't matter what inclusive is
    length(color_code) ==  2 ~ exclusive_label_guild(color_code),
    inclusive & length(color_code) == 1 ~ 
      inclusive_label_guild(color_code),
    TRUE ~ list(NA_character_)
  )
  
  # labels recycles to length 10, to match longest possible length
  # if not expecting that, trim to corect length
  if (inclusive & length(color_code) == 0){
    return(labels)
  }
  
  if (inclusive & length(color_code) == 1){
    return(labels[1:4])
  }
  
  labels[1]
}

#' functions for using match color to guild. Pulled out of label_guild to make
#' flow clearer by avoiding nested case_whens
#' @noRd
inclusive_label_guild <- function(color_code){
  dplyr::case_when(
    identical(color_code, list()) ~ 
      list("Azorius", "Boros", "Dimir", "Golgari", "Gruul", 
           "Izzet", "Orzhov", "Rakdos", "Selesnya", "Simic"),
    # padding with NAs to avoid case_when error
    identical(color_code, list("B")) ~ 
      list("Dimir", "Golgari", "Orzhov", "Rakdos", NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G")) ~ 
      list("Golgari", "Gruul", "Selesnya", "Simic", NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R")) ~ 
      list("Boros", "Gruul", "Izzet", "Rakdos", NA, NA, NA, NA, NA, NA),
    identical(color_code, list("U")) ~ 
      list("Azorius", "Dimir", "Izzet", "Simic", NA, NA, NA, NA, NA, NA),
    identical(color_code, list("W")) ~ 
      list("Azorius", "Boros", "Orzhov", "Selesnya", NA, NA, NA, NA, NA, NA),
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

#' @noRd
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