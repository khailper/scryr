#' @title Assign guild based on color/color identity
#' 
#' @description Given a card's color (or color identity), return the Ravinca 
#' guild assoicated with the card. By default, \code{label_guild} requires the 
#' card to be both of the guild's colors, but if \code{inclusive = TRUE}, 
#' mono-color cards are labeled with all guilds they could belong to. 
#' 
#' @section  Note: 
#' cards with hybrid costs are treated as belonging to both colors, as though 
#' they were gold cards.
#' 
#' @section Warning:
#' If you're using \code{label_guild} inside 
#' \code{\link{[dplyr]mutate}}, you'll need to pair it with
#' \code{\link{[purrr]map}}. See\code{vingette("using_label_functions")}.
#' 
#' @concept label
#' 
#' @param color_code vector of characters of the card's color/color identity, 
#' using WUBRG notation. Letters must be capital and in alphabetic order. If 
#' using with \code{link{[dplyr]mutate}}, \code{link{[purrr]map_chr}}, and the 
#' results of \code{link{scry_cards}}, use the \code{colors} or 
#' \code{color_identity} column. See\code{vingette("using_label_functions")}.
#' @param inclusive if \code{color_code} is just one (or no) color, should 
#' \code{label_guild} return all guilds that contain that color?
#' @param convert_to_list Should \code{label_guild} a list instead of a vector?
#' Useful if you're planning on using functions like \code{link[tidyr]unnest}.
#' 
#' @seealso \code{\link{label_tri}}
#' 
#' @rdname label_guild
#' 
#' @return a vector of strings with all guild(s) matching the \{color_code}
#' 
#' @examples 
#' label_guild(c("U", "W"))
#' label_guild("U")
#' label_guild("U", inclusive = TRUE)
#' @export
label_guild <- function(color_code, inclusive = FALSE, convert_to_list = FALSE){

   labels <- dplyr::case_when(
    # if length == 2, doesn't matter what inclusive is
    length(color_code) ==  2 ~ exclusive_label_guild(color_code),
    inclusive & length(color_code) < 2 ~ 
      inclusive_label_guild(color_code),
    TRUE ~ list(NA_character_))
    
   if (convert_to_list){
    return(purrr::map(labels, as.list)[[1]])
   }
   
   labels
}

#' functions for using match color to guild. Pulled out of label_guild to make
#' flow clearer by avoiding nested case_whens
#' @noRd
inclusive_label_guild <- function(color_code){
  dplyr::case_when(
    length(color_code) == 0 ~ 
      list(c("Azorius", "Boros", "Dimir", "Golgari", "Gruul", 
           "Izzet", "Orzhov", "Rakdos", "Selesnya", "Simic")),
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, "B") ~ 
      list(c("Dimir", "Golgari", "Orzhov", "Rakdos")),
    identical(color_code, "G") ~ 
      list(c("Golgari", "Gruul", "Selesnya", "Simic")),
    identical(color_code, "R") ~ 
      list(c("Boros", "Gruul", "Izzet", "Rakdos")),
    identical(color_code, "U") ~ 
      list(c("Azorius", "Dimir", "Izzet", "Simic")),
    identical(color_code, "W") ~ 
      list(c("Azorius", "Boros", "Orzhov", "Selesnya")),
    TRUE ~ list(NA_character_)
  )
}

#' @noRd
exclusive_label_guild <- function(color_code){
  dplyr::case_when(
    identical(color_code, c("U", "W")) ~ list("Azorius"),
    identical(color_code, c("R", "W")) ~ list("Boros"),
    identical(color_code, c("B", "U")) ~ list("Dimir"),
    identical(color_code, c("B", "G")) ~ list("Golgari"),
    identical(color_code, c("G", "R")) ~ list("Gruul"),
    identical(color_code, c("R", "U")) ~ list("Izzet"),
    identical(color_code, c("B", "W")) ~ list("Orzhov"),
    identical(color_code, c("B", "R")) ~ list("Rakdos"),
    identical(color_code, c("G", "W")) ~ list("Selesnya"),
    identical(color_code, c("G", "U")) ~ list("Simic"),
    TRUE ~ list(NA_character_)
  )
}