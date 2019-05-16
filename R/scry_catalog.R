#' @title Query Scryfall Catalog API
#' 
#' @description Function for reuqesting contents of catalogs. Catalogs contains 
#' all existing versions of that object. For example scry_catalog("toughnesses") 
#' returns every toughness that has ever been printed on a __Magic__ card, 
#' including non-mumeric values like "*+1". \cr
#' Available catalogs are "card-names", "artist-names", "word-bank",
#' "creature-types", "planeswalker-types", "land-types","artifact-types",
#' "enchantment-types", "spell-types", "powers", "toughnesses",
#' "loyalties", "watermarks". \cr
#' While most catalog names are self-explanatory, "word-bank" is every English 
#' word of 2+ letters that's appears in a card name.
#'
#' @param catalog_name The name of the catalog you want (character). See 
#' Description for available catalogs.
#' @param delay Number of milliseconds scryr should wait between requests 
#' (Scryfall asks for 50-100).
#' @export
#' @rdname scry_catalog
#' 
#' @return character vector of objects in the catalog
#' @examples
#' scry_catalog("artist-names")
#' library(dplyr)
#' scry_catalog("toughnesses") %>% as.numeric()
scry_catalog <- function(catalog_name, delay = 75){
  
  polite_rate_limit(delay)
  
  # Throw error if user accidentally provides catalog_name that doesn't exist
  if (!(catalog_name %in% catalog_list)){
    rlang::abort("That catalog doesn't exist. ?scry_catalog for list of available catalogs.")
  }
  
  # create query URL
  query_url <- paste0(scryr_catalog_url, catalog_name)
  
  # Check for internet
  check_internet()
  # Get search results
  res <- curl::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  # Get the content
  jsonlite::fromJSON(rawToChar(res$content))$data
}