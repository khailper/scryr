#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
#' 
check_internet <- function(){
  stop_if_not(.x = has_internet(), 
              msg = "Please check your internet connection")
}
#' @importFrom httr status_code
check_status <- function(res){
  # long-term goal: customize to Scryfall's error messages
  stop_if_not(.x = status_code(res), 
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
#' @importFrom rlang abort
#' @param delay
#' Number of microseconds scryr should wait between requests (Scryfall asks for 
#' 50-100). (https://scryfall.com/docs/api)
#' @noRd
polite_rate_limit <- function(delay){
  if(delay < 50){
    abort("Please respect Scryfall's rate limit by setting delay >= 50.")
  }
  Sys.sleep(delay/1000)
}
#' functions for checking function arguments
#' 
#' 
#' Handle pagination
#' 
#' A function for handling large responses without additional user effort.
#'  
#' @param current_data Data from last page pulled.
#' @param next_page_uri 
#' URI for next page of data. This will be taken from the JSON response of the 
#' current page
#' @param delay
#' Number of microseconds scryr should wait between requests (Scryfall asks for 
#' 50-100). There's no default value because it will be carried over from 
#' calling function.
#' @importFrom dplyr bind_rows
#' @noRd
handle_pagination <- function(current_data, next_page_uri, delay){
  # plan: pull data from next_page_uri, check data for another next_page,
  # if there, call handle_pagination; finally bind results to current_data
  bind_rows(current_data, next_page_data)
}


