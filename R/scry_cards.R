#' @title Query Scryfall Card Search API
#' 
#' @description Function for contents of catalogs. Catalogs contains all 
#' existing versions of that object. For example scry_catalog("toughnesses") 
#' returns every toughness that has ever been printed on a __Magic__ card, 
#' including non-mumeric values like "*+1". \cr
#' Available catalogs are "card-names", "artist-names", "word-bank",
#' "creature-types", "planeswalker-types", "land-types","artifact-types",
#' "enchantment-types", "spell-types", "powers", "toughnesses",
#' "loyalties", "watermarks". \cr
#' While most catalog names are self-explanatory, "word-bank" is every English 
#' word of 2+ letters that's appears in a card name.
#'
#' @importFrom utils URLencode
#' @importFrom httr modify_url
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @param query
#' @param .unique
#' @param .order
#' @param direction
#' @param include_extras
#' @param include_multilingual
#' @param delay 
#' Number of microseconds scryr should wait between requests. 
#' (Scryfall asks for 50-100)
#' @importFrom httr GET 
#' @export
#' @rdname scry_cards
#' 
#' @return data frame of cards matching the search parameters
#' @examples
#' scry_catalog("artist-names")
#' library(dplyr)
#' scry_catalog("toughnesses") %>% as.numeric() %>% unique()
scry_cards <- function(query, .unique = "cards", .order = "name", 
                       direction = "auto", include_extras = FALSE, 
                       include_multilingual = FALSE, delay = 75){
  
  polite_rate_limit(delay)
  
  # Throw error if user accidentally provides catalog_name that doesn't exist
  if (!(catalog_name %in% catalog_list)){
    stop("That catalog doesn't exist. ?scry_catalog for list of available catalogs.")
  }
  
  # create query URL
  query_url <- paste0(card_search_url, catalog_name)
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- GET(query_url, ua)
  
  # Check the result
  check_status(res)
  
  # Get the first page
  first_page <- fromJSON(rawToChar(res$content))$data
  
  # if the results are large, we need to query multiple times and consolidate 
  # the data. If not, we can return early
  if (!exists(fromJSON(rawToChar(res$content))$next_page)){
    return(first_page)
  }
}