.onLoad <- function(lib, pkg)  {
  pkg.info <- utils::packageDescription('raster')
  packageStartupMessage(paste0(
    "\n modified raster ", pkg.info[["Version"]], " (", pkg.info["Date"], ")\n\n ",
    "you are using an unofficial, non-CRAN version of the raster package\n"
  ))
	return(invisible())
}
