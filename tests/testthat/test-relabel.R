test_that("relabel_mtg_color() works", {
  expect_equal(relabel_mtg_color("G"), "Green")
  expect_equal(relabel_mtg_color(c("G", "U")), "Multicolored")
  expect_equal(relabel_mtg_color(c()), "Colorless")
  expect_equal(relabel_mtg_color("Green"), NA_character_)
})
test_that("relabel_mtg_color() returns an error when it should", {
  expect_error(relabel_mtg_color(2), "color_code needs to be a character vector")
})