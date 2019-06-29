test_that("wubrg_order() works", {
  # should warn since not all levels are used
  expect_warning(wubrg_order(c("Blue", "Green", "Black")))
  expect_equal(levels(wubrg_order(c("Blue", "Green", "Black"))), 
               c("Blue", "Black", "Green"))
})

test_that("wubrg_order() fails for improper strings", {
  expect_error(wubrg_order(c("Blue", "Green", "Black", "Sultai")))
})
