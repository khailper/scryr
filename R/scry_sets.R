#' @title Query Scryfall Set API
#' 
#' @description Function for getting-set level information (e.g. release date, 
#' number of cards). Formatted as a tibble.
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom tibble as_tibble
#' @param set_code Three letter set code. If NULL (default), returns all sets.
#' @param delay Number of milliseconds scryr should wait between requests 
#' (Scryfall asks for 50-100).
#' @export
#' @rdname scry_set
#' 
#' @return a [tibble][tibble::tibble-package] of the result of the query 
#' (documention of set object at https://scryfall.com/docs/api/sets)
#' @examples
#' scry_sets() #returns all sets
#' scry_sets("aer") 
#' scry_sets("m19") # block-related columns absent
scry_sets <- function(set_code = NULL, delay = 75){

  polite_rate_limit(delay)
  
  # create query URL
  query_url <- paste0(scryr_set_url, set_code)
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- GET(query_url, scryr_ua)
  
  # Check the result
  check_status(res)
  
  # Get the content and return it as a data.frame
  
  if (!is.null(set_code)){
    return(as_tibble(fromJSON(rawToChar(res$content))))
  }
  as_tibble(fromJSON(rawToChar(res$content))$data)
  
  # may want to add ways to handle the fact that some sets don't have all 
  # values/columns. Probably not going to have much impact, so not urgent.
}