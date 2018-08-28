context("test-scry_sets")
library(scryr)

test_that("sets have all the columns", {
  expect_equal(names(scry_sets("aer")), 
                                c("object","code", "mtgo_code", "name", "uri",
                                  "scryfall_uri", "search_uri", "released_at", 
                                  "set_type", "card_count", "digital", 
                                  "foil_only", "block_code", 
                                  "block", "icon_svg_uri"))
  
  
})

test_that("only one set returned and it's the right type", {
  expect_true(tibble::is_tibble(scry_sets("m19")))
  expect_equal(nrow(scry_sets("m19")), 1)
})

test_that("set returns error if wrong code used", {
  expect_error(scry_sets("m29"), "The API returned an error")
  expect_error(scry_sets("M19"), "The API returned an error")
  expect_error(scry_sets("m190"), "The API returned an error")
})

test_that("rate limit works"{
  expect_error(scry_sets("m19", delay = 25), 
               "Please respect Scryfall's rate limit.")
})

