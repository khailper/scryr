
check_internet <- function(){
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Please check your internet connection")
}

check_status <- function(res){
  # long-term goal: customize to Scryfall's error messages
  attempt::stop_if_not(.x = httrstatus_code(res), 
              .p = ~ .x == 200,
              msg = "The API returned an error")
}
#' 
#' Polite rate limit
#' 
#' A function for enforcing rate limits.
#' 
#' @description 
#' Adds a delay before executing scry_* functions. Currently no formal rate 
#' limit exists on the Scryfall api, but they request 50-100 ms delays between 
#' queries.
#' @param delay
#' Number of milliseconds scryr should wait between requests (Scryfall asks for 
#' 50-100). (https://scryfall.com/docs/api)
#' @noRd
polite_rate_limit <- function(delay){
  if(delay < 50){
    rlang::abort("Please respect Scryfall's rate limit by setting delay >= 50.")
  }
  Sys.sleep(delay/1000)
}
#' 
#' Handle pagination
#' 
#' A function for handling large responses without additional user effort.
#'  
#' @param current_data Data from last page pulled.
#' @param next_page_uri 
#' URI for next page of data. This will be taken from the JSON response of the 
#' current page
#' @param delay Number of milliseconds scryr should wait between requests 
#' (Scryfall asks for 50-100). There's no default value because it will be 
#' carried over from calling function.
#' @noRd
handle_pagination <- function(current_data, next_page_uri, delay){
  # plan: pull data from next_page_uri, check data for another next_page,
  # if there, call handle_pagination; finally bind results to current_data
  polite_rate_limit(delay)
  
  # Check for internet
  check_internet()
  
  # Get search results
  next_page_res <-  GET(next_page_uri, scryr_ua)

  # Check the result
  check_status(next_page_res) 
  
  next_page_data <- fromJSON(rawToChar(next_page_res$content), flatten = TRUE)$data
  
  if (exists("next_page", where = fromJSON(rawToChar(next_page_res$content)))){
    handle_pagination(current_data = first_page, 
                      next_page_uri = fromJSON(rawToChar(res$content))$next_page,
                      delay = delay)
  }
  
  
  dplyr::bind_rows(current_data, next_page_data)
}


