#' @title Convert MTG color names into ordered factor
#' 
#' @description Turn the outputs of \code{\link{relabel_mtg_color}} into an
#' ordered factor (WUBRG order, then "Multicolored", followed by "Colorless").
#' Converting strings into ordered factors is useful for having plot outputs
#' display in a useful order. 
#' 
#' @concept label
#' 
#' @param label_chr vector of characters that can contain the values 
#' "White", "Blue", "Black", "Red", "Green", "Multicolored", or "Colorless".
#' The main source is \code{\link{relabel_mtg_color}}.
#' 
#' @seealso \code{\link{relabel_mtg_color}} for the main source of inputs to 
#' this function
#' 
#' @return vector of ordered factors with the same length and labels as
#'  \code{label_chr}
#' 
#' @example
#' wubrg_order(c("Blue", "Green", "Black"))
#' 
#' @rdname  wubrg_order
#' 
#' @export
wubrg_order <- function(label_chr){
  # check for non-color strings
  in_wubrg <- label_chr %in% c("White", "Blue", "Black", "Red", "Green",
                               "Multicolored", "Colorless")
  
  # if any are false, average will be <1
  if(ave(in_wubrg != 1)){
    rlang::abort('Strings in wubrg_order() need to be "White", "Blue", "Black", "Red", "Green", "Multicolored", or "Colorless".')
  }
  
  fct_relevel(label_chr, "White", "Blue", 
              "Black", "Red", "Green",
              "Multicolored", "Colorless")
}