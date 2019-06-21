test_that("label_guild doesn't assign guilds to cards without exactly 2 colors", {
  expect_true(is.na(label_guild("B")))
  expect_true(is.na(label_guild(c("B", "G", "U"))))
  expect_true(is.na(label_guild(c("B", "G", "R", "U"))))
  expect_true(is.na(label_guild(c("B", "G", "R", "U", "W"))))
})

test_that("label_guild(inclusive = TRUE) doesn't assign guilds to cards with >2 colors", {
  expect_true(is.na(label_guild(c("B", "G", "U")), inclusive = TRUE))
  expect_true(is.na(label_guild(c("B", "G", "R", "U")), inclusive = TRUE))
  expect_true(is.na(label_guild(c("B", "G", "R", "U", "W")), inclusive = TRUE))
})

test_that("label_guild corectly labels a 2 color card", {
  expect_equal(label_guild(	c("B", "G")), "Golgari")
})

test_that("label_guild(inclusive = TRUE) corectly labels a 1 color card", {
  expect_equal(label_guild("B", inclusive = TRUE), 
               c("Dimir", "Golgari", "Orzhov", "Rakdos"))
})