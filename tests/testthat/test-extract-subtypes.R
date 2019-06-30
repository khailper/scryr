test_that("extract_subtypes() works", {
  expect_equal(extract_subtypes("Creature - Merfolk Wizard"), "Merfolk Wizard")
  expect_equal(extract_subtypes("Artifact Creature - Golem"), "Golem")
  expect_equal(extract_subtypes("Instant - Arcane"), "Arcane")
})

test_that("extract_subtypes(split = TRUE) works", {
  expect_equal(extract_subtypes("Creature - Merfolk Wizard", split = TRUE),
               c("Merfolk", "Wizard"))
  expect_equal(extract_subtypes("Instant - Arcane", split = TRUE),
               c("Arcane"))
})

test_that("extract_subtypes fails for non-strings and lack of subtype",{
  expect_error(extract_subtypes(5))
  expect_true(is.na(extract_subtypes("Instant")))
})