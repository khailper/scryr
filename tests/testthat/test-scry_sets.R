context("test-scry_sets")
library(scryr)

test_that("sets have all the columns", {
  expect_equal(names(scry_sets("m19"), 
                                c("code", "mtgo_code", "name", "set_type",
                                  "release_at", "block_code", "block",
                                  "parent_set_code", "card_count",
                                  "digital", "foil_only", "icon_svg_uri")))
})

test_that("only one set returned", {
  expect_equal(nrow(scry_sets("m19")), 1)
})

test_that("set returns error if wrong code used", {
  expect_error(scry_sets("m29"), "Error message for non-existant set")
  expect_error(scry_sets("M19"), "Error message for non-existant set")
  expect_error(scry_sets("m190"), "Error message for non-existant set")
})


