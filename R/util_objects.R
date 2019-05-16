#' set user agent per httr vignette
#' @importFrom httr user_agent
#' @noRd
# based on: https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html
ua <- user_agent("http://github.com/khailper/scryr")
#'
#' set up urls functions will need for API queries
#' @noRd
base_url <- "https://api.scryfall.com/"
set_url <- paste0(base_url, "sets/")
catalog_url <- paste0(base_url, "catalog/")
card_search_url <- paste0(base_url, "sets/cards/search")
#'
#'list of available catalogs so scry_catalog() can throw error
#' source: https://scryfall.com/docs/api/catalogs
#' @noRd
catalog_list <- c("card-names", "artist-names", "word-bank", "creature-types",
                  "planeswalker-types", "land-types","artifact-types",
                  "enchantment-types", "spell-types", "powers", "toughnesses",
                  "loyalties", "watermarks")