#' query Scryfall set API
#'
#' @importFrom attempt stop_if_all
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom tibble as_tibble
#' @param set_code three letter set code. If NULL (default), returns all sets.
#' @export
#' @rdname scry_set
#' 
#' @return result of query (document of set object at https://scryfall.com/docs/api/sets)
#' @examples 
scry_sets <- function(set_code = NULL, delay = 75){

  
  polite_rate_limit(delay)
  # create query URL
  query_url <- paste0(set_url, set_code)
  
  # Check for internet
  check_internet()
  
  # Get search results
  res <- GET(query_url)
  
  # Check the result
  check_status(res)
  
  # Get the content and return it as a data.frame
  tibble::as_tibble(fromJSON(rawToChar(res$content)))
}