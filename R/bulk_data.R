#' @title Fetch Scryfall Bulk Data
#' 
#' @description Scryfall releases bulk data files for cards and rulings that are
#' updated daily. These functions wrap calling those APIs. The cards bulk data 
#' come in three versions: default (every card in English (unless only available 
#' in a non-English language)), oracle (one card per Oracle ID), and all (every 
#' card in every language). Documentation is available at 
#' \url{https://scryfall.com/docs/api/bulk-data}.
#' @concept bulk_data
#' @rdname bulk_data
#' @return \code{bulk_rulings} returns a [tibble][tibble::tibble-package] of all
#' rulings as of the latest update. \code{oracle-id} column refers to the card
#' associate with the ruling
#' 
#' @export
bulk_rulings <- function(){
  query_url <- paste0(bulk_data_url, "rulings.json")
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content)))
}

#' @concept bulk_data
#' @rdname bulk_data
#' @export
bulk_default_cards <- function(){
  query_url <- paste0(bulk_data_url, "default-cards.json")
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content)))
}