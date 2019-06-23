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
#' @param inclusive if \{color_code} is just one color, should 
#' \code{label_guild} return all guilds that contain that color?
#' @param shard_or_wedge
#' 
#' @rdname label_guild
#' 
#' @return a list of strings with all guild(s) matching the \{color_code}
#' 
#' @examples 
#' label_guild(list("U", "W"))
#' label_guild(list("U"))
#' label_guild(list("U"), inclusive = TRUE)
#'@export
label_tri <- function(color_code, 
                      inclusive = FALSE, 
                      shard_or_wedge = c("either", "shard", "wedge")){
  if (!is.list(color_code)){
    rlang::abort("color_code needs to be a list")
  }
  
  if (!(shard_or_wedge[1] %in% c("either", "shard", "wedge"))){
    rlang::abort("shard_or_wedge needs to be 'either', 'shard', or 'wedge'.")
  }
  labels <- dplyr::case_when(
    # if length == 3, doesn't matter what inclusive is
    length(color_code) ==  3 & shard_or_wedge == "either" ~ 
      exclusive_either_label_tri(color_code),
    length(color_code) ==  3 & shard_or_wedge == "shard" ~ 
      exclusive_shard_label_tri(color_code),
    length(color_code) ==  3 & shard_or_wedge == "wedge" ~ 
      exclusive_wedge_label_tri(color_code),
    inclusive & length(color_code) <  3 & shard_or_wedge == "either" ~ 
      inclusive_either_label_tri(color_code),
    inclusive & length(color_code) <  3 & shard_or_wedge == "shard" ~ 
      inclusive_shard_label_tri(color_code),
    inclusive & length(color_code) <  3 & shard_or_wedge == "wedge" ~ 
      inclusive_wedge_label_tri(color_code),
    TRUE ~ list(NA_character_)
  )
  
  
  # labels recycles to length 10, to match longest possible length
  # if not expecting that, trim to corect length
  dplyr::case_when(
    inclusive & length(color_code) == 0 & shard_or_wedge == "either" ~labels,
    inclusive & length(color_code) == 0 & shard_or_wedge == "shard" ~labels[1:5],
    inclusive & length(color_code) == 0 & shard_or_wedge == "wedge" ~labels[1:5],    
    inclusive & length(color_code) == 1 & shard_or_wedge == "either" ~labels[1:6],
    inclusive & length(color_code) == 1 & shard_or_wedge == "shard" ~labels[1:3],
    inclusive & length(color_code) == 1 & shard_or_wedge == "wedge" ~labels[1:3],
    inclusive & length(color_code) == 2 & shard_or_wedge == "either" ~labels[1:3],
    # need to fix these last three to account for difference between enemy and ally
    inclusive & length(color_code) == 2 & shard_or_wedge == "shard" ~labels[1:2],
    inclusive & length(color_code) == 2 & shard_or_wedge == "wedge" ~labels[1:2],
    TRUE ~ labels[1]
  )

}

#' functions for using match color to shard/wedge. Pulled out of label_tri to 
#' make flow clearer by avoiding nested case_whens
#' @noRd
exclusive_either_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, list("G", "U", "W")) ~ list("Bant"),
    identical(color_code, list("G", "U", "W")) ~ list("Esper"),
    identical(color_code, list("G", "U", "W")) ~ list("Grixis"),
    identical(color_code, list("G", "U", "W")) ~ list("Jund"),
    identical(color_code, list("G", "U", "W")) ~ list("Naya"),
    identical(color_code, list("G", "U", "W")) ~ list("Abzan"),
    identical(color_code, list("G", "U", "W")) ~ list("Jeskai"),
    identical(color_code, list("G", "U", "W")) ~ list("Mardu"),
    identical(color_code, list("G", "U", "W")) ~ list("Sultai"),
    identical(color_code, list("G", "U", "W")) ~ list("Temur"),
    TRUE ~ list(NA_character_)
  )
}
#'
#' @noRd
exclusive_shard_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, list("G", "U", "W")) ~ list("Bant"),
    identical(color_code, list("G", "U", "W")) ~ list("Esper"),
    identical(color_code, list("G", "U", "W")) ~ list("Grixis"),
    identical(color_code, list("G", "U", "W")) ~ list("Jund"),
    identical(color_code, list("G", "U", "W")) ~ list("Naya"),
    TRUE ~ list(NA_character_)
  )
}
#'
#' @noRd
exclusive_wedge_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, list("G", "U", "W")) ~ list("Abzan"),
    identical(color_code, list("G", "U", "W")) ~ list("Jeskai"),
    identical(color_code, list("G", "U", "W")) ~ list("Mardu"),
    identical(color_code, list("G", "U", "W")) ~ list("Sultai"),
    identical(color_code, list("G", "U", "W")) ~ list("Temur"),
    TRUE ~ list(NA_character_)
  )
}
#'
#' @noRd
inclusive_either_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, list()) ~ 
      list("Bant", "Esper", "Grixis", "Jund", "Naya", 
           "Abzan", "Jeskai", "Mardu", "Sultai", "Temur"),
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, list("B")) ~ 
      list("Esper", "Grixis", "Jund", "Abzan", 
           "Mardu", "Sultai", NA, NA, NA, NA),
    identical(color_code, list("G")) ~ 
      list("Bant", "Jund", "Naya", "Abzan", "Sultai", 
           "Temur", NA, NA, NA, NA),
    identical(color_code, list("R")) ~ 
      list("Grixis", "Jund", "Naya", "Jeskai", "Mardu", 
           "Temur", NA, NA, NA, NA),
    identical(color_code, list("U")) ~ 
      list("Bant", "Esper", "Grixis", "Jeskai", "Sultai", 
           "Temur", NA, NA, NA, NA),
    identical(color_code, list("W")) ~ 
      list("Bant", "Esper", "Naya", "Abzan", "Jeskai", 
           "Mardu", NA, NA, NA, NA),
    identical(color_code, list("B", "G")) ~ 
      list("Jund", "Abzan", "Sultai", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "R")) ~ 
      list("Grixis", "Jund", "Mardu", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "U")) ~ 
      list("Esper", "Grixis", "Sultai", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "W")) ~ 
      list("Esper", "Abzan", "Mardu", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "R")) ~ 
      list("Jund", "Naya", "Temur", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "U")) ~ 
      list("Bant", "Sultai", "Temur", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "W")) ~ 
      list("Bant", "Naya", "Abzan", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R", "U")) ~ 
      list("Grixis", "Jeskai", "Temur", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R", "W")) ~ 
      list("Naya", "Jeskai", "Mardu", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("U", "W")) ~ 
      list("Bant", "Esper", "Jeskai", NA, NA, NA, NA, NA, NA, NA),
    TRUE ~ list(NA_character_)
  )
}

#'
#' @noRd
inclusive_shard_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, list()) ~ 
      list("Bant", "Esper", "Grixis", "Jund", "Naya", NA, NA, NA, NA, NA),
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, list("B")) ~ 
      list("Esper", "Grixis", "Jund", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G")) ~ 
      list("Bant", "Jund", "Naya",NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R")) ~ 
      list("Grixis", "Jund", "Naya", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("U")) ~ 
      list("Bant", "Esper", "Grixis", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("W")) ~ 
      list("Bant", "Esper", "Naya", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "G")) ~ 
      list("Jund", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "R")) ~ 
      list("Grixis", "Jund", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "U")) ~ 
      list("Esper", "Grixis", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "W")) ~ 
      list("Esper", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "R")) ~ 
      list("Jund", "Naya", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "U")) ~ 
      list("Bant", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "W")) ~ 
      list("Bant", "Naya", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R", "U")) ~ 
      list("Grixis", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R", "W")) ~ 
      list("Naya", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("U", "W")) ~ 
      list("Bant", "Esper", NA, NA, NA, NA, NA, NA, NA, NA),
    TRUE ~ list(NA_character_)
  )
}

#'
#' @noRd
inclusive_wedge_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, list()) ~ 
      list("Abzan", "Jeskai", "Mardu", "Sultai", "Temur", NA, NA, NA, NA, NA),
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, list("B")) ~ 
      list("Abzan", "Mardu", "Sultai", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G")) ~ 
      list("Abzan", "Sultai", "Temur", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R")) ~ 
      list("Jeskai", "Mardu", "Temur", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("U")) ~ 
      list("Jeskai", "Sultai","Temur", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("W")) ~ 
      list("Abzan", "Jeskai", "Mardu", NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "G")) ~ 
      list("Abzan", "Sultai", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "R")) ~ 
      list("Mardu", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "U")) ~ 
      list("Sultai", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("B", "W")) ~ 
      list("Abzan", "Mardu", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "R")) ~ 
      list("Temur", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "U")) ~ 
      list("Sultai", "Temur", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("G", "W")) ~ 
      list("Abzan", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R", "U")) ~ 
      list("Jeskai", "Temur", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("R", "W")) ~ 
      list("Jeskai", "Mardu", NA, NA, NA, NA, NA, NA, NA, NA),
    identical(color_code, list("U", "W")) ~ 
      list("Jeskai", NA, NA, NA, NA, NA, NA, NA, NA, NA),
    TRUE ~ list(NA_character_)
  )
}