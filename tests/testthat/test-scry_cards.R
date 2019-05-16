context("test-scry_cards")

test_that("scry_cards parse search query correctly", {
  expect_equal(2 * 2, 4)
})


test_that("scry_cards parse handles bad searches", {
  expect_error(scry_cards(query = "set:ktk", .unique = "card"), 
               ".unique must be one of 'cards', 'part', or 'prints'")
})

test_that("pagination works for two pages", {
  expect_equal(nrow(scry_cards(query = "set:ktk")), 254)
})

test_that("pagination works for three or more pages", {
  # 688 from manual search
  expect_equal(nrow(scry_cards(query = "b:ktk")), 688)
})