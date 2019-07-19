#' @title Turn Scryfall color codes into human-readable labels
#' 
#' @description Color values from \code{\link{scry_cards}} come in as single
#' character strings (e.g. "U" for blue cards). \code{relabel_mtg_color} 
#' converts them into human-readable text,  (e.g. "Red" or "Multicolored").
#' 
#' @section Warnings:
#' \code{relabel_mtg_color} treats any character vector of length >1 as a 
#' multicolored card. \cr
#' If you're using \code{relabel_mtg_color} inside 
#' \code{\link{[dplyr]mutate}}, you'll need to pair it with
#' \code{\link{[purrr]map_chr}}. See\code{vingette("using_label_functions")}.
#' 
#' @concept manipulate
#' 
#' @param color_code character vector (which can be of length 0) containing 
#' single letter WUBRG color codes.
#' 
#' @seealso \code{\link{wubrg_order}} for converting the output into an ordered
#' factor.
#' 
#' @return For mono-colored cards, \code{relabel_mtg_color} returns the card's
#' color. Otherwise, it returns "Colorless" or "Multicolored", as appropriate.
#' 
#' @examples 
#' relabel_mtg_color("G")
#' relabel_mtg_color(c("G", "U"))
#' 
#' @rdname relabel_mtg_color
#' 
#' @export
relabel_mtg_color <- function(color_code){
  if(length(color_code) > 1 & !is.character(color_code)){
    rlang::abort("color_code needs to be a character vector")
  }
  
  dplryr::case_when(
    length(color_code) == 0 ~ "Colorless",
    length(color_code) > 1 ~ "Multicolored",
    identical(color_code, "B") ~ 
      "Black",
    identical(color_code, "G") ~ 
      "Green",
    identical(color_code, "R") ~ 
      "Red",
    identical(color_code, "U") ~ 
      "Blue",
    identical(color_code, "W") ~ 
      "White",
    TRUE ~ NA_character_
  )
}