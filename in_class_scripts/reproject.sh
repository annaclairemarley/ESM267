# This script extracts tiff files from a Modis download, reprojects them into California Alberts,
# puts everything into a folder and then deletes all the .tif files at the end
# delete the last line of code if you want to keep the .tif files!

extract MODIS tiff files from folder downloaded
	for tar_archive in downloaded/*
	do
		echo $tar_archive  # tells name of archive
		tar xfv $tar_archive # tells the name of each file it extracts
	done
	
# make a new folder to put the reprojected tiff files in
	mkdir -p projected # -p says don't worry if the file already exists, overwrites whatever was there before 

	
#take the image, make the output a geotiff,compress the geotiff by deflating it, reproject it to EPSG:3310 
# and put it in a file with the same name in the projected folder 
	for image in *.tif
	do
		echo $image
		gdalwarp -of GTiff -co COMPRESS=DEFLATE -t_srs EPSG:3310 -overwrite $image projected/$image 
	done 

#remove everything that is a .tif file. rm -v lists the name of each file as it removes it
rm -v *.tif