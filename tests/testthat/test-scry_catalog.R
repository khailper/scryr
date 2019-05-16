context("test-scry_catalog")

test_that("scry_catalog returns a character vector", {
  expect_equal(typeof(scry_catalog("artist-names")), "character")
})

test_that("scry_catalog returns informative error if catalog doesn't exist", {
  expect_error(scry_catalog("crd-names", 
                            "That catalog doesn't exist. ?scry_catalog for list of available catalogs."))
})
