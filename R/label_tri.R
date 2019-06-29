#' @title Assign shard and/or wedge based on color/color identity
#' 
#' @description Given a card's color (or color identity), return the Alara 
#' and/or Tarkir wedge assoicated with the card. By default, \code{label_tri} 
#' requires the card to be both all the group's colors, but if 
#' \code{inclusive = TRUE}, cards with less than three colors are labeled with 
#' all groups they could belong to. 
#' 
#' @section Note: 
#' cards with hybrid costs are treated 
#' as belonging to both colors, as though they were gold cards.
#' 
#' @concept label
#' 
#' @param color_code vector of characters of the card's color/color identity, 
#' using WUBRG notation. Letters must be capital and in alphabetic order. If 
#' using with \code{link{[dplyr]mutate}}, \code{link{[purrr]map_chr}}, and 
#' the results of \code{link{scry_cards}}, use the \code{colors} or 
#' \code{color_identity} column. See\code{vingette("using_label_functions")}.
#' @param inclusive if \code{color_code} is just one color, should 
#' \code{label_tri} return all groups that contain that color?
#' @param shard_or_wedge Should \code{label_tri} match based on shards and 
#' wedges ("either"), just shards ("shard"), or just wedges ("wedge")?
#' @param convert_to_list Should \code{label_tri} a list instead of a vector?
#' Useful if you're planning on using functions like \code{link[tidyr]unnest}.
#' 
#' @seealso \code{\link{label_guild}}
#' 
#' @rdname label_tri
#' 
#' @return a vector of strings with all group(s) matching the \code{color_code}
#' 
#' @examples 
#' label_tri(c("B", "U", "W"))
#' label_tri(c("B", "U", "W"), shard_or_wedge = "shard")
#' label_tri(c("B", "U", "W"), shard_or_wedge = "wedge")
#' label_tri("U")
#' label_tri("U", inclusive = TRUE)
#'@export
label_tri <- function(color_code, 
                      inclusive = FALSE, 
                      shard_or_wedge = c("either", "shard", "wedge"),
                      convert_to_list = FALSE){

  if (!(shard_or_wedge[1] %in% c("either", "shard", "wedge"))){
    rlang::abort("shard_or_wedge needs to be 'either', 'shard', or 'wedge'.")
  }
  
  shard_or_wedge <- shard_or_wedge[1]
  
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
  
  if (convert_to_list){
    return(purrr::map(labels, as.list)[[1]])
  }
  
  labels
}

#' functions for using match color to shard/wedge. Pulled out of label_tri to 
#' make flow clearer by avoiding nested case_whens
#' @noRd
exclusive_either_label_tri <- function(color_code){
  dplyr::case_when(
    identical(color_code, c("G", "U", "W")) ~ list("Bant"),
    identical(color_code, c("B", "U", "W")) ~ list("Esper"),
    identical(color_code, c("B", "R", "U")) ~ list("Grixis"),
    identical(color_code, c("B", "G", "R")) ~ list("Jund"),
    identical(color_code, c("G", "R", "W")) ~ list("Naya"),
    identical(color_code, c("B", "G", "W")) ~ list("Abzan"),
    identical(color_code, c("R", "U", "W")) ~ list("Jeskai"),
    identical(color_code, c("B", "R", "W")) ~ list("Mardu"),
    identical(color_code, c("B", "G", "U")) ~ list("Sultai"),
    identical(color_code, c("G", "R", "U")) ~ list("Temur"),
    TRUE ~ list(NA_character_)
  )
}
#'
#' @noRd
exclusive_shard_label_tri <- function(color_code){
  dplyr::case_when(
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, c("G", "U", "W")) ~ list("Bant"),
    identical(color_code, c("B", "U", "W")) ~ list("Esper"),
    identical(color_code, c("B", "R", "U")) ~ list("Grixis"),
    identical(color_code, c("B", "G", "R")) ~ list("Jund"),
    identical(color_code, c("G", "R", "W")) ~ list("Naya"),
    TRUE ~ list(NA_character_)
  )
}
#'
#' @noRd
exclusive_wedge_label_tri <- function(color_code){
  dplyr::case_when(
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, c("B", "G", "W")) ~ list("Abzan"),
    identical(color_code, c("R", "U", "W")) ~ list("Jeskai"),
    identical(color_code, c("B", "R", "W")) ~ list("Mardu"),
    identical(color_code, c("B", "G", "U")) ~ list("Sultai"),
    identical(color_code, c("G", "R", "U")) ~ list("Temur"),
    TRUE ~ list(NA_character_)
  )
}
#'
#' @noRd
inclusive_either_label_tri <- function(color_code){
  dplyr::case_when(
    length(color_code) == 0 ~ 
      list(c("Bant", "Esper", "Grixis", "Jund", "Naya", 
           "Abzan", "Jeskai", "Mardu", "Sultai", "Temur")),
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, "B") ~ 
      list(c("Esper", "Grixis", "Jund", "Abzan", 
           "Mardu", "Sultai")),
    identical(color_code, "G") ~ 
      list(c("Bant", "Jund", "Naya", "Abzan", "Sultai", 
           "Temur")),
    identical(color_code, "R") ~ 
      list(c("Grixis", "Jund", "Naya", "Jeskai", "Mardu", 
           "Temur")),
    identical(color_code, "U") ~ 
      list(c("Bant", "Esper", "Grixis", "Jeskai", "Sultai", 
           "Temur")),
    identical(color_code, "W") ~ 
      list(c("Bant", "Esper", "Naya", "Abzan", "Jeskai", 
           "Mardu")),
    identical(color_code, c("B", "G")) ~ 
      list(c("Jund", "Abzan", "Sultai")),
    identical(color_code, c("B", "R")) ~ 
      list(c("Grixis", "Jund", "Mardu")),
    identical(color_code, c("B", "U")) ~ 
      list(c("Esper", "Grixis", "Sultai")),
    identical(color_code, c("B", "W")) ~ 
      list(c("Esper", "Abzan", "Mardu")),
    identical(color_code, c("G", "R")) ~ 
      list(c("Jund", "Naya", "Temur")),
    identical(color_code, c("G", "U")) ~ 
      list(c("Bant", "Sultai", "Temur")),
    identical(color_code, c("G", "W")) ~ 
      list(c("Bant", "Naya", "Abzan")),
    identical(color_code, c("R", "U")) ~ 
      list(c("Grixis", "Jeskai", "Temur")),
    identical(color_code, c("R", "W")) ~ 
      list(c("Naya", "Jeskai", "Mardu")),
    identical(color_code, c("U", "W")) ~ 
      list(c("Bant", "Esper", "Jeskai")),
    TRUE ~ list(NA_character_)
  )
}

#'
#' @noRd
inclusive_shard_label_tri <- function(color_code){
  dplyr::case_when(
    length(color_code) == 0 ~ 
      list(c("Bant", "Esper", "Grixis", "Jund", "Naya")),
    identical(color_code, "B") ~ 
      list(c("Esper", "Grixis", "Jund")),
    identical(color_code, "G") ~ 
      list(c("Bant", "Jund", "Naya")),
    identical(color_code, "R") ~ 
      list(c("Grixis", "Jund", "Naya")),
    identical(color_code, "U") ~ 
      list(c("Bant", "Esper", "Grixis")),
    identical(color_code, "W") ~ 
      list(c("Bant", "Esper", "Naya")),
    identical(color_code, c("B", "G")) ~ 
      list("Jund"),
    identical(color_code, c("B", "R")) ~ 
      list(c("Grixis", "Jund")),
    identical(color_code, c("B", "U")) ~ 
      list(c("Esper", "Grixis")),
    identical(color_code, c("B", "W")) ~ 
      list("Esper"),
    identical(color_code, c("G", "R")) ~ 
      list(c("Jund", "Naya")),
    identical(color_code, c("G", "U")) ~ 
      list("Bant"),
    identical(color_code, c("G", "W")) ~ 
      list(c("Bant", "Naya")),
    identical(color_code, c("R", "U")) ~ 
      list("Grixis"),
    identical(color_code, c("R", "W")) ~ 
      list("Naya"),
    identical(color_code, c("U", "W")) ~ 
      list(c("Bant", "Esper")),
    TRUE ~ list(NA_character_)
  )
}

#'
#' @noRd
inclusive_wedge_label_tri <- function(color_code){
  dplyr::case_when(
    length(color_code) == 0 ~ 
      list(c("Abzan", "Jeskai", "Mardu", "Sultai", "Temur")),
    # padding with NAs to avoid case_when error, will trim them later
    identical(color_code, "B") ~ 
      list(c("Abzan", "Mardu", "Sultai")),
    identical(color_code, "G") ~ 
      list(c("Abzan", "Sultai", "Temur")),
    identical(color_code, "R") ~ 
      list(c("Jeskai", "Mardu", "Temur")),
    identical(color_code, "U") ~ 
      list(c("Jeskai", "Sultai","Temur")),
    identical(color_code, "W") ~ 
      list(c("Abzan", "Jeskai", "Mardu")),
    identical(color_code, c("B", "G")) ~ 
      list(c("Abzan", "Sultai")),
    identical(color_code, c("B", "R")) ~ 
      list("Mardu"),
    identical(color_code, c("B", "U")) ~ 
      list("Sultai"),
    identical(color_code, c("B", "W")) ~ 
      list(c("Abzan", "Mardu")),
    identical(color_code, c("G", "R")) ~ 
      list("Temur"),
    identical(color_code, c("G", "U")) ~ 
      list(c("Sultai", "Temur")),
    identical(color_code, c("G", "W")) ~ 
      list("Abzan"),
    identical(color_code, c("R", "U")) ~ 
      list(c("Jeskai", "Temur")),
    identical(color_code, c("R", "W")) ~ 
      list(c("Jeskai", "Mardu")),
    identical(color_code, c("U", "W")) ~ 
      list("Jeskai"),
    TRUE ~ list(NA_character_)
  )
}