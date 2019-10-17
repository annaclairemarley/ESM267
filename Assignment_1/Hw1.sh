### ESM 267 Assignment 1 ###
	# This script takes a shapefile of US counties, extracts santa barbara county from it and makes a separate shapefile
	# Then it clips MODIS imagery to that shapefile's extent and reprojects it to be EPSG:3310

#  tells bash to “echo” (type out in the bash window) each command before it’s run.
set -x

### first need to extract SB county from the US counties shapefile & reproject it into the CA Albers projection ###

	# finds the polygon for SB county and makes it into a new shapefile called sb_county in the counties folder
	ogr2ogr -where "name='Santa Barbara'" counties/sb_county.shp counties/tl_2018_us_county/tl_2018_us_county.shp

	#reproject the Sb shapefile to NAD83/California Albers for the output coordinate system & name it sb_county_3310.shp
	ogr2ogr counties/sb_county_3310.shp -t_srs "EPSG:3310" counties/sb_county.shp

### now need to clip the sb_county shapefile to the MODIS raster & reproject to ESPG 3310###

	# a list of the rasters that we want to clip and project
	raster="crefl2_*"

	# the shapefile of SB county we want to clip and project
	roi=counties/sb_county_3310.shp

	# arguments used by the GDAL commands we're going to run:
		# -of GTiff            : make the output raster a GeoTIFF
		# -co COMPRESS=DEFLATE : use the "DEFLATE" TIFF compression method
		# -overwrite           : overwrite the output raster if it already exists
	common_args="-dstalpha -of GTiff -co COMPRESS=DEFLATE -overwrite"

	#arguments for the clip command
		# -cutline $roi    : clip the input to the shapefile $roi
		# -crop_to_cutline : clip to the shape (not just its bounding box)
	clip_args="-cutline $roi -crop_to_cutline"

	# arguments for the project command
		# -t_srs EPSG:3310 : use NAD83/California Albers for the output coordinate system
	project_args="-t_srs EPSG:3310"
	
	#clip the raster into Geotiff file 
	gdalwarp $common_args $clip_args MODIS/$raster sb_raster_clipped.tif
	
	 # project GeoTIFF sb_raster_clipped.tif into GeoTIFF sb_raster_clipped_3310.tif
    gdalwarp $common_args $project_args sb_raster_clipped.tif sb_raster_clipped_3310.tif
	
	
	