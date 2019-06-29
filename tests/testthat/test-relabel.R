test_that("relabel_mtg_color() works", {
  expect_equal(relabel_mtg_color("G"), "Green")
  expect_equal(relabel_mtg_color(c("G", "U")), "Multicolored")
  expect_equal(relabel_mtg_color(c()), "Colorless")
})
