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
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @param catalog_name name of catalog you want (character). See above for available catalogs.
#' @param delay how many microseconds should scryr wait between requests 
#' (Scryfall asks for 50-100)
#' @export
#' @rdname scry_catalog
#' 
#' @return character vector of objects in the catalog
#' @examples
#' scry_catalog("artist-names")
#' library(dplyr)
#' scry_catalog("toughnesses") %>% as.numeric() %>% unique()
scry_catalog <- function(catalog_name, delay = 75){
  
  polite_rate_limit(delay)
  
  # Throw error if user accidentally provides catalog_name that doesn't exist
  if (!(catalog_name %in% catalog_list)){
    stop("That catalog doesn't exist. ?scry_catalog for list of available catalogs.")
  }
  
  # create query URL
  query_url <- paste0(catalog_url, catalog_name)
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- GET(query_url, ua)
  
  # Check the result
  check_status(res)
  
  # Get the content
  fromJSON(rawToChar(res$content))$data
}