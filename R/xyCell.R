# Author: Robert J. Hijmans
# Date :  October 2008
# Version 1.0
# Licence GPL v3


yFromRow <- function(object, row=1:nrow(object)) {
	if (rotated(object)) {
		stop('this function is not supported for rotated rasters')
	}
	row <- round(row)
	row[row < 1 | row > object@nrows] <- NA
	ymax(object) - ((row-0.5) * yres(object))
}	

.yFromRow <- function(object, rownr) {
	if (rotated(object)) {
		stop('this function is not supported for rotated rasters')
	}
	ymax(object) - ((rownr-0.5) * yres(object))
}	
	


xFromCol <- function(object, col=1:ncol(object)) {
	if (rotated(object)) {
		stop('this function is not supported for rotated rasters')
	}
	col <- round(col)
	col[col < 1 | col > object@ncols] <- NA
	xmin(object) + (col - 0.5) * xres(object) 
}  

.xFromCol <- function(object, colnr) {
	if (rotated(object)) {
		stop('this function is not supported for rotated rasters')
	}
	xmin(object) + (colnr - 0.5) * xres(object) 
 }  

	
cellFromXY <- function(object, xy) {
	if (inherits(xy, 'SpatialPoints')) {
		xy <- coordinates(xy)
		x <- xy[,1]
		y <- xy[,2]
	} else if (is.null(dim(xy))) { 
		x <- xy[1]
		y <- xy[2] 
	} else { 
		x <- xy[,1]
		y <- xy[,2] 
	}

	if (rotated(object)) {
		cr <- object@rotation@transfun(xy, inv=TRUE)
		cell <- (cr[,2]-1) * object@ncols + cr[,1]
	} else {
		cell <- .doCellFromXY(
			object@ncols, object@nrows,
			object@extent@xmin, object@extent@xmax,
			object@extent@ymin, object@extent@ymax, 
			x, y)
	}
	return(cell)
}


colFromX <- function ( object, x )	{
	if (inherits(x, 'Spatial')) { 
		x <- x@coords[,1] 
	}
	if (rotated(object)) {
		stop('this function is not supported for rotated rasters')
	}
	colnr <- trunc((x - xmin(object)) / xres(object)) + 1 
	colnr[ x == xmax(object) ] <- object@ncols
	colnr[ x < xmin(object) | x > xmax(object) ] <- NA
	return(as.vector(colnr))
}

	
rowFromY <- function ( object, y )	{
	if (inherits(y, 'Spatial')) {
		y <- y@coords[,2] 
	}
	if (rotated(object)) {
		stop('this function is not supported for rotated rasters')
	}
	rownr <- 1 + (trunc((ymax(object) - y) / yres(object)))
	rownr[y == ymin(object) ] <- object@nrows 
	rownr[y > ymax(object) | y < ymin(object)] <- NA
	return(as.vector(rownr))
}	
	

xyFromCell <- function(object, cell, spatial=FALSE) {
	if (rotated(object)) {
		xy <- object@rotation@transfun( 
			cbind(x=colFromCell(object, cell), y=rowFromCell(object, cell)) 
		)
		
	} else {
	    e <- object@extent 
		xy <- .doXYFromCell(
			object@ncols, object@nrows,
			e@xmin, e@xmax, e@ymin, e@ymax, cell
		)
		dimnames(xy) <- list(NULL, c("x", "y"))
	}

	if (spatial) {
		xy <- SpatialPoints(stats::na.omit(xy), crs(object))
	}
	return(xy)
}
	
	
if (!isGeneric("coordinates")) {
	setGeneric("coordinates", function(obj, ...)
		standardGeneric("coordinates"))
}	

		   
setMethod('coordinates', signature(obj='Raster'), 
    function(obj, ...){
		xyFromCell(obj, cell=1:ncell(obj), ...)
	}
)


yFromCell <- function(object, cell) {
	if (rotated(object)) {
		xy <- xyFromCell(object, cell)
		return(xy[,2])
	} else {
		rows <- rowFromCell(object, cell)
		return( .yFromRow(object, rows) )
	}
}  
	
xFromCell <- function(object, cell) {
	if (rotated(object)) {
		xy <- xyFromCell(object, cell)
		return(xy[,1])
	} else {
		cols <- colFromCell(object, cell)
		return( .xFromCol(object, cols) )
	}
}  

