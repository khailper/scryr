context("test-scry_cards")

test_that("scry_cards parses search query correctly", {
  expect_equal(nrow(scry_cards("set:rtr has:watermark")), 138)
  expect_error(scry_cards("set:ktk wm:mardu c:u"))
})


test_that("scry_cards handles bad searches", {
  expect_error(scry_cards(query = "set:ktk", .unique = "card"))
  expect_error(scry_cards(query = "set:ktk", .order = "names"))
})

test_that("pagination works for two pages", {
  expect_equal(nrow(scry_cards(query = "set:ktk")), 254)
})

test_that("pagination works for three or more pages", {
  # 688 from manual search
  expect_equal(nrow(scry_cards(query = "b:ktk")), 688)
})