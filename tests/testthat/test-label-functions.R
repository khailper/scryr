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
  expect_equal(label_guild(list("B", "G")), list("Golgari"))
})

test_that("label_guild(inclusive = TRUE) corectly labels a 1 color card", {
  expect_equal(label_guild(list("B"), inclusive = TRUE), 
               list("Dimir", "Golgari", "Orzhov", "Rakdos"))
})

test_that("label_tri doesn't assign guilds to cards without exactly 3 colors", {
  expect_true(is.na(label_tri(list("B"))))
  expect_true(is.na(label_tri(list("B", "G"))))
  expect_true(is.na(label_tri(list("B", "G", "R", "U"))))
  expect_true(is.na(label_tri(list("B", "G", "R", "U", "W"))))
})

test_that("label_tri(inclusive = TRUE) doesn't assign guilds to cards with >3 colors", {
  expect_true(is.na(label_tri(list("B", "G", "R", "U"), inclusive = TRUE)))
  expect_true(is.na(label_tri(list("B", "G", "R", "U", "W"), inclusive = TRUE)))
})

test_that("label_tri corectly labels a 3 color card", {
  expect_equal(label_tri(list("B", "G", "U")), list("Sultai"))
  expect_equal(label_tri(list("B", "G", "U"), shard_or_wedge = "either"), 
               list("Sultai"))  
  expect_equal(label_tri(list("B", "G", "U"), shard_or_wedge = "wedge"), 
               list("Sultai"))
  expect_true(is.na(label_tri(list("B", "G", "U"), shard_or_wedge = "shard")))
  expect_equal(label_tri(list("B", "G", "R")), list("Jund"))
  expect_equal(label_tri(list("B", "G", "R"), shard_or_wedge = "either"), 
               list("Jund"))  
  expect_equal(label_tri(list("B", "G", "R"), shard_or_wedge = "shard"), 
               list("Jund"))
  expect_true(is.na(label_tri(list("B", "G", "R"), shard_or_wedge = "wedge")))
})

test_that("label_tri(inclusive = TRUE) corectly labels a 1 or 2 color card", {
  expect_equal(label_tri(list("B"), 
                         inclusive = TRUE), 
               list("Abzan", "Esper", "Grixis", "Jund", "Mardu", "Sultai"))
  expect_equal(label_tri(list("B"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "either"), 
               list("Abzan", "Esper", "Grixis", "Jund", "Mardu", "Sultai"))
  expect_equal(label_tri(list("B"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "shard"), 
               list("Esper", "Grixis", "Jund"))
  expect_equal(label_tri(list("B"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "wedge"), 
               list("Abzan", "Mardu", "Sultai"))
  expect_equal(label_tri(list("B", "G"), 
                         inclusive = TRUE), 
               list("Abzan", "Jund", "Sultai"))
  expect_equal(label_tri(list("B", "G"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "either"), 
               list("Abzan", "Jund", "Sultai"))
  expect_equal(label_tri(list("B", "G"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "shard"), 
               list("Jund"))
  expect_equal(label_tri(list("B", "G"), 
                         inclusive = TRUE, 
                         shard_or_wedge = "wedge"), 
               list("Abzan", "Sultai"))

})


test_that("label_tri checks shard_or_wedge parameter correctly", {
  expect_error(abel_tri(list("B", "G", "U"), shard_or_wedge = "wdge"))
})