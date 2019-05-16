#' set user agent per httr vignette
#' @importFrom httr user_agent
#' @noRd
# based on: https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html
scryr_ua <- user_agent("http://github.com/khailper/scryr")
#'
#' set up urls functions will need for API queries
#' @noRd
scryr_base_url <- "https://api.scryfall.com/"
scryr_set_url <- paste0(scryr_base_url, "sets/")
scryr_catalog_url <- paste0(scryr_base_url, "catalog/")
scryr_card_search_url <- paste0(scryr_base_url, "sets/cards/search?q=")
#'
#'list of available catalogs so scry_catalog() can throw error
#' source: https://scryfall.com/docs/api/catalogs
#' @noRd
catalog_list <- c("card-names", "artist-names", "word-bank", "creature-types",
                  "planeswalker-types", "land-types","artifact-types",
                  "enchantment-types", "spell-types", "powers", "toughnesses",
                  "loyalties", "watermarks")