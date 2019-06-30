test_that("extract_subtypes() works", {
  # dash (emdash or endash) comes through wrong
  expect_equal(extract_subtypes("Creature â€” Merfolk Wizard"), 
               list("Merfolk Wizard"))
  expect_equal(extract_subtypes("Artifact Creature â€” Golem"), 
               list("Golem"))
  expect_equal(extract_subtypes("Instant â€” Arcane"), 
               list("Arcane"))
})

test_that("extract_subtypes(split = TRUE) works", {
  expect_equal(extract_subtypes("Creature â€” Merfolk Wizard", split = TRUE),
               list(c("Merfolk", "Wizard")))
  expect_equal(extract_subtypes("Instant â€” Arcane", split = TRUE),
               list(c("Arcane")))
})

test_that("extract_subtypes fails for non-strings and lack of subtype",{
  expect_error(extract_subtypes(5))
  expect_true(is.na(extract_subtypes("Instant")))
  expect_true(is.na(extract_subtypes("Instant", split = TRUE)))
})
