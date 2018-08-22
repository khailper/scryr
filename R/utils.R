#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connexion")
}

#' @importFrom httr status_code
check_status <- function(res){
  stop_if_not(.x = status_code(res), 
              .p = ~ .x == 200,
              msg = "The API returned an error")
}

base_url <- "https://api.scryfall.com/"
set_url <- paste0(base_url, "sets")


# function for enforcing rate limits
# currently none exist, but Scryfall requests 50-100 ms delay
# (https://scryfall.com/docs/api)
polite_rate_limit <- function(delay){
  if(delay < 50){
    stop()
  }
  Sys.sleep(delay/1000)
}

# functions for checking function arguements
# 
# testing if set code is accepted 3 character code


# set user agent per httr vignette
# (https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html)
ua <- user_agent("http://github.com/khailper/scryr")