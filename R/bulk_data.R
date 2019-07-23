#' @title Fetch Scryfall Bulk Data
#' 
#' @description Scryfall releases bulk data files for cards and rulings that are
#' updated daily. These functions wrap calling those APIs. The cards bulk data 
#' come in three versions: default (every card in English (unless only available 
#' in a non-English language)), oracle (one card per Oracle ID), and all (every 
#' card in every language). Documentation is available at 
#' <https://scryfall.com/docs/api/bulk-data>.
#' @concept bulk_data
#' @rdname bulk_data
#' @return `bulk_rulings` returns a [tibble][tibble::tibble-package] of all
#' rulings as of the latest update. `oracle-id` column refers to the card
#' associate with the ruling. The `bulk_*_cards` functions return a 
#' [tibble][tibble::tibble-package] with all relevent cards as of the latest 
#' update.
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

#' @param include_ids Should results include ID variables (e.g. MTGO ID). Note 
#' that this includes Oracle ID, which may make it hard to work with 
#' `bulk_oracle_cards` if you're planning on using that as a unique ID.
#' @param include_uris Should results include URI variables (e.g. the URL for
#' the card on Scryfall)
#' @concept bulk_data
#' @rdname bulk_data
#' @export
bulk_default_cards <- function(include_ids = FALSE, include_uris = FALSE){
  query_url <- paste0(bulk_data_url, "default-cards.json")
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  bulk_data <- tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content)))
  
  if (!include_ids){
    bulk_data <- dplyr::select(bulk_data, 
                               -dplyr::ends_with("id"), 
                               -dplyr::ends_with("ids"))
  }
  
  if (!include_uris){
    bulk_data <- dplyr::select(bulk_data, 
                               -dplyr::contains("uri"),
                               -dplyr::contains("uris"))
  }
  
  return(bulk_data)
}

#' @concept bulk_data
#' @rdname bulk_data
#' @export
bulk_oracle_cards <- function(include_ids = FALSE, include_uris = FALSE){
  query_url <- paste0(bulk_data_url, "oracle-cards.json")
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  bulk_data <- tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content)))
  
  if (!include_ids){
    bulk_data <- dplyr::select(bulk_data, 
                               -dplyr::ends_with("id"), 
                               -dplyr::ends_with("ids"))
  }
  
  if (!include_uris){
    bulk_data <- dplyr::select(bulk_data, 
                               -dplyr::contains("uri"),
                               -dplyr::contains("uris"))
  }
  
  return(bulk_data)
}

#' @concept bulk_data
#' @rdname bulk_data
#' @export
bulk_all_cards <- function(include_ids = FALSE, include_uris = FALSE){
  query_url <- paste0(bulk_data_url, "all-cards.json")
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  bulk_data <- tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content)))
  
  if (!include_ids){
    bulk_data <- dplyr::select(bulk_data, 
                               -dplyr::ends_with("id"), 
                               -dplyr::ends_with("ids"))
  }
  
  if (!include_uris){
    bulk_data <- dplyr::select(bulk_data, 
                               -dplyr::contains("uri"),
                               -dplyr::contains("uris"))
  }
  
  return(bulk_data)
}
