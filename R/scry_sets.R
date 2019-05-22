#' @title Query Scryfall Set API
#' 
#' @description Request set-level information (e.g. release date, 
#' number of cards).
#'
#' @param set_code Three letter set code. If NULL (default), returns all sets.
#' @param include_ids Should results include ID variables (e.g. TCGPlayer ID)
#' @param include_uris Should results include URI variables (e.g. the URL for
#' the set on Scryfall)
#' @param delay Number of milliseconds scryr should wait between requests 
#' (Scryfall asks for 50-100).
#' @export
#' @rdname scry_set
#' 
#' @return a [tibble][tibble::tibble-package] of the result of the query 
#' (documention of set object at \url{https://scryfall.com/docs/api/sets)}
#' @examples
#' scry_sets() #returns all sets
#' scry_sets("aer") 
#' scry_sets("m19") # block-related columns absent since M19 isn't in a block
scry_sets <- function(set_code = NULL,
                      include_ids = FALSE, 
                      include_uris = FALSE, 
                      delay = 75){

  polite_rate_limit(delay)
  
  # create query URL
  query_url <- paste0(scryr_set_url, set_code)
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- httr::GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  # Get the content and return it as a data.frame
  
  if (!is.null(set_code)){
    search_results <- tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content)))
  } else {
    search_results <- tibble::as_tibble(jsonlite::fromJSON(rawToChar(res$content))$data)
  }
  
  if (!include_ids){
    search_results <- dplyr::select(search_results, -dplyr::ends_with("id"))
    search_results <- dplyr::select(search_results, -dplyr::ends_with("ids"))
  }
  
  if (!include_uris){
    search_results <- dplyr::select(search_results, -dplyr::contains("uri"))
  }
  
  search_results
  
  
  # may want to add ways to handle the fact that some sets don't have all 
  # values/columns. Probably not going to have much impact, so not urgent.
}