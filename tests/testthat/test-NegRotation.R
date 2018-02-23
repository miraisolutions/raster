# suppressMessages({
#   library(assertthat)
# })

context("negative rotation\n\n")

if (FALSE) {
  local_reporters <- c(
    "progress" # default
    , "location" # shows also successful tests
    #, "rstudio" # displays warnings as they are thrown
  )
  # Execute the command below to run the tests
  devtools::test(pkg = ".", reporter = local_reporters)
}

test_that("Negative and positive rotations yield different objects\n", {

  set.seed(12)

  R_Tif <- system.file("external", "R.tif", package = "raster", mustWork = TRUE)
  R_Tif_pos45 <- system.file("external", "R_pos45.tif", package = "raster", mustWork = TRUE)
  R_Tif_neg45 <- system.file("external", "R_neg45.tif", package = "raster", mustWork = TRUE)
  R_Tif_pos100 <- system.file("external", "R_pos100.tif", package = "raster", mustWork = TRUE)
  R_Tif_neg100 <- system.file("external", "R_neg100.tif", package = "raster", mustWork = TRUE)
  R_Tif_pos315 <- system.file("external", "R_pos315.tif", package = "raster", mustWork = TRUE)

  # RasterBricks
  RTif <- brick(R_Tif)
  # plotRGB(RTif, 1, 2, 3)
  pos45Tif <- suppressWarnings(brick(R_Tif_pos45))
  # plotRGB(pos45Tif, 1, 2, 3)
  neg45Tif <- suppressWarnings(brick(R_Tif_neg45))
  # plotRGB(neg45Tif,1,2,3)
  pos315Tif <- suppressWarnings(brick(R_Tif_pos315))
  # plotRGB(pos315Tif,1,2,3)
  pos100Tif <- suppressWarnings(brick(R_Tif_pos100))
  # plotRGB(pos100Tif, 1, 2, 3)
  neg100Tif <- suppressWarnings(brick(R_Tif_neg100))
  # plotRGB(neg100Tif, 1, 2, 3)

  expect_is(RTif, "RasterBrick")

  expect_identical(res(pos45Tif), res(neg45Tif))

  expect_false(isTRUE(all.equal(neg45Tif@extent, pos45Tif@extent)))

  expect_equal(neg45Tif@extent, pos315Tif@extent)

  expect_false(identical(res(pos45Tif), res(pos100Tif)))

})
