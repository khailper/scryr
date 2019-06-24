test_that("label_guild doesn't assign guilds to cards without exactly 2 colors", {
  expect_true(is.na(label_guild(list("B"))))
  expect_true(is.na(label_guild(list("B", "G", "U"))))
  expect_true(is.na(label_guild(list("B", "G", "R", "U"))))
  expect_true(is.na(label_guild(list("B", "G", "R", "U", "W"))))
})

test_that("label_guild(inclusive = TRUE) doesn't assign guilds to cards with >2 colors", {
  expect_true(is.na(label_guild(list("B", "G", "U"), inclusive = TRUE)))
  expect_true(is.na(label_guild(list("B", "G", "R", "U"), inclusive = TRUE)))
  expect_true(is.na(label_guild(list("B", "G", "R", "U", "W"), inclusive = TRUE)))
})

test_that("label_guild corectly labels a 2 color card", {
  expect_equal(label_guild(c("B", "G")), list("Golgari"))
})

test_that("label_guild(inclusive = TRUE) corectly labels a 1 color card", {
  expect_equal(label_guild("B", inclusive = TRUE), 
               list(c("Dimir", "Golgari", "Orzhov", "Rakdos")))
})

test_that("label_tri doesn't assign guilds to cards without exactly 3 colors", {
  expect_true(is.na(label_tri("B")))
  expect_true(is.na(label_tri(c("B", "G"))))
  expect_true(is.na(label_tri(c("B", "G", "R", "U"))))
  expect_true(is.na(label_tri(c("B", "G", "R", "U", "W"))))
})

test_that("label_tri(inclusive = TRUE) doesn't assign guilds to cards with >3 colors", {
  expect_true(is.na(label_tri(c("B", "G", "R", "U"), inclusive = TRUE)))
  expect_true(is.na(label_tri(c("B", "G", "R", "U", "W"), inclusive = TRUE)))
})

test_that("label_tri corectly labels a 3 color card", {
  expect_equal(label_tri(c("B", "G", "U")), list("Sultai"))
  expect_equal(label_tri(c("B", "G", "U"), shard_or_wedge = "either"), 
               list("Sultai"))  
  expect_equal(label_tri(c("B", "G", "U"), shard_or_wedge = "wedge"), 
               list("Sultai"))
  expect_true(is.na(label_tri(c("B", "G", "U"), shard_or_wedge = "shard")))
  expect_equal(label_tri(c("B", "G", "R")), list("Jund"))
  expect_equal(label_tri(c("B", "G", "R"), shard_or_wedge = "either"), 
               list("Jund"))  
  expect_equal(label_tri(c("B", "G", "R"), shard_or_wedge = "shard"), 
               list("Jund"))
  expect_true(is.na(label_tri(c("B", "G", "R"), shard_or_wedge = "wedge")))
})

test_that("label_tri(inclusive = TRUE) corectly labels a 1 or 2 color card", {
  expect_equal(label_tri("B", 
                         inclusive = TRUE), 
               list(c("Esper", "Grixis", "Jund", "Abzan", "Mardu", "Sultai")))
  expect_equal(label_tri("B", 
                         inclusive = TRUE, 
                         shard_or_wedge = "either"), 
               list(c("Esper", "Grixis", "Jund", "Abzan", "Mardu", "Sultai")))
  expect_equal(label_tri("B", 
                         inclusive = TRUE, 
                         shard_or_wedge = "shard"), 
               list(c("Esper", "Grixis", "Jund")))
  expect_equal(label_tri("B", 
                         inclusive = TRUE, 
                         shard_or_wedge = "wedge"), 
               list(c("Abzan", "Mardu", "Sultai")))
  expect_equal(label_tri(c("B", "G"), 
                         inclusive = TRUE), 
               list(c("Jund", "Abzan", "Sultai")))
  expect_equal(label_tri(c("B", "G"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "either"), 
               list(c("Jund", "Abzan", "Sultai")))
  expect_equal(label_tri(c("B", "G"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "shard"), 
               list("Jund"))
  expect_equal(label_tri(c("B", "G"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "wedge"), 
               list(c("Abzan", "Sultai")))

})


test_that("label_tri checks shard_or_wedge parameter correctly", {
  expect_error(label_tri(lc("B", "G", "U"), shard_or_wedge = "wdge"))
})
