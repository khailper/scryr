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
#' @param query search query to pass to the API. A character string that looks
#' the same as a search you'd manually enter into Scryfall.
#' @param .unique  How Scryfall handles cases where different versions of the 
#' same card match the `query`. "cards" (default) returns only one instance of 
#' card, "art" returns each instance with a different art "prints" returns all 
#' of them.
#' @param .order How Scryfall sorts returned cards. "name" (default): card name, 
#' "set": set code and collector number, "released": release date, "rarity": 
#' rarity, "color": color, "usd": price in US dollars, "tix"; price in tickets 
#' on MTGO, "eur": price in Euros, "cmc": converted mana cost, "power": power, 
#' "toughenss": toughness, "edhrec": EDHREC rating, or "artist": artist name. 
#' 
#' @param direction Which direction cards are sorted in based on \code{.order}. 
#' "auto" (default): order that makes most sense for \code{.order}, 
#' "asc": ascending order, and "desc": descending order.  "auto" sorts in 
#' descending order for prices ("usd", "tix", and "eur"), "release date", and 
#' "rarity". For all other \code{.order} options, "auto sorts in ascending 
#' order.
#' @param include_extras Should results include extras like tokens or schemes. 
#' The default is FALSE.
#' @param include_multilingual Should results include cards in all supported 
#' languages. The default is FALSE.
#' @param include_variations Should results include rare case variants. The 
#' default is FALSE.
#' @param delay  Number of milliseconds scryr should wait between requests. 
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
                       include_multilingual = FALSE, include_variations = FALSE,
                       delay = 75){
  
  polite_rate_limit(delay)
  

  # Check arguements (https://scryfall.com/docs/api/cards/search for 
  # documentation of options)
  if (!(.unique %in% c("cards", "art", "prints"))){
    rlang::abort(".unique must be one of 'cards', 'art', or 'prints'.")
  }
  
  if (!(.order %in% c("name", "set", "released", "rarity", "color", "usd",
                      "tix", "eur", "cmc", "power", "toughness", "edhrec",
                      "artist"))){
    rlang::abort(".order must be one of 'name', 'set', 'released', 'rarity', 
    'color', 'usd', 'tix', 'eur', 'cmc', 'power', 'toughness', 'edhrec', or 
                 'artist'.")
  }
  
  if (!(direction %in% c("auto", "asc", "desc"))){
    rlang::abort("direction must be one of 'auto', 'asc', or 'desc'.")
  }
  
  if (!is.logical(include_extras) || !is.logical(include_multilingual) ||
      !is.logical(include_variations)){
    rlang::abort("Both include_extras, include multilingual, and 
    include_variations need to be Booleans.")
  }
  
  
  # create query URL
  encoded_query <- URLencode(query)
  query_url <- paste0(scryr_card_search_url, encoded_query, "&unique=", 
                      .unique, "&order=", .order, "&dir=", direction,
                      "&include_extras=", include_extras, 
                      "&include_multilingual=", "&include_variations=",
                      include_variations)
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  # Get the first page
  first_page <- jsonlite::fromJSON(rawToChar(res$content), flatten = TRUE)$data
  
  # if the results are large, we need to query multiple times and consolidate 
  # the data. If not, we can return early
  if (!exists("next_page", where = jsonlite::fromJSON(rawToChar(res$content)))){
    return(first_page)
  }
  handle_pagination(current_data = first_page, 
                    next_page_uri = jsonlite::fromJSON(rawToChar(res$content))$next_page,
                    delay = delay)
}