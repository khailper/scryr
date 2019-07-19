#' @title Extract subtypes from card's type line
#' 
#' @description Take a card's type type line (stored in the \code{type_line}) 
#' column in the output from \code{\link{scry_cards}}) and get just the subtypes 
#' (everything after the '-')
#' 
#' @section Warning:
#' If you're using \code{extract_subtypes} inside 
#' \code{\link{[dplyr]mutate}}, you'll need to pair it with
#' \code{\link{[purrr]map}}.
#' 
#' @concept manipulate
#' 
#' @param type_line card's type line.
#' @param split If the card has multiple subtypes, should 
#' \code{extract_subtypes} return a list where each subtype is its own element 
#' of the vector  or one element with all subtypes 
#' (list(c("Goblin", "Warrior")) vs list("Goblin Warrior")))?
#' 
#' 
#' @return list containing a character vector with the cards' subtypes
#' 
#' @examples 
#' extract_subtypes("Creature - Merfolk Wizard")
#' extract_subtypes("Creature - Merfolk Wizard", split = TRUE)
#' 
#' @rdname extract_subtypes
#' 
#' @export
extract_subtypes <- function(type_line, split = FALSE){
  if(!is.character(type_line)){
    rlang::abort("type_line needs to be a character vector")
  }
  
  # Check if dash is present. If not, card has no subtypes
  # dash (emdash or endash) comes through as three characters ending in u201D
  
  subtypes <- dplyr::if_else(grepl("\u201D", type_line),
                      stringr::str_remove(type_line, ".+\u201D "),
                      NA_character_)
  
  if_else(split, stringr::str_split(subtypes, pattern = " "), list(subtypes))
}