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
#' @importFrom httr GET 
#' @param query
#' @param .unique  How Scryfall handles cases where different versions of the 
#' same card match the `query`. "cards" (default) returns only one instance of 
#' card, "art" returns each instance with a different art "prints" returns all of them.
#' @param .order How Scryfall sorts returned cards. "name" (default): card name, 
#' "set": set code and collector number, "released": release date, "rarity": 
#' rarity, "color": color, "usd": price in US dollars, "tix"; price in tickets 
#' on MTGO, "eur": price in Euros, "cmc": converted mana cost, "power": power, 
#' "toughenss": toughness, "edhrec": EDHREC rating, or "artist": artist name. 
#' See vignette("sorting-cards") for more information on how sorting works.
#' @param direction Which direction cards are sorted in based on `.order`. 
#' "auto" (default): order that makes most sense for `.order`, 
#' "asc": ascending order, and "desc": descending order. See 
#' vignette("sorting-cards") for more information on how sorting works.
#' @param include_extras Should results include extras like tokens or schemes. 
#' The default is FALSE.
#' @param include_multilingual Should results include cards in all supported 
#' languages. The default is FALSE.
#' @param delay  Number of microseconds scryr should wait between requests. 
#' (Scryfall asks for 50-100)
#' @export
#' @rdname scry_cards
#' 
#' @return a [tibble][tibble::tibble-package] of cards matching the search 
#' parameters
#' @examples
#' scry_catalog("artist-names")
#' library(dplyr)
#' scry_catalog("toughnesses") %>% as.numeric() %>% unique()
scry_cards <- function(query, .unique = "cards", .order = "name", 
                       direction = "auto", include_extras = FALSE, 
                       include_multilingual = FALSE, delay = 75){
  
  polite_rate_limit(delay)
  

  # Check arguements (https://scryfall.com/docs/api/cards/search for 
  # documentation of options)
  if (!(unique %in% c("cards", "part", "prints"))){
    stop(".unique must be one of 'cards', 'part', or 'prints'")
  }
  if (!(order %in% c("cards", "part", "prints"))){
    stop(".unique must be one of 'cards', 'part', or 'prints'")
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
  handle_pagination(current_data = first_page, 
                    next_page_uri = fromJSON(rawToChar(res$content))$next_page,
                    delay = delay)
}