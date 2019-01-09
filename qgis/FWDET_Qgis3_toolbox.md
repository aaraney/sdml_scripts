author: Austin Raney\
email: aaraney@crimson.ua.edu\
date: Jan 8, 2018 

# FWDET QGIS 3 Implimentation
* Dependencies
	* QGIS3 (This script was tested on 3.4.0-Madeira
* Inputs
	* Digital Elevation Model 
	* Flood Extent Shapefile

This is a toolbox plugin version of the Floodwater Depth Estimation Tool 
devised by Dr. Sagy Cohen and others in 2017. This version of the
tool follows the same methods found in the QGIS 2.\* and the paper but accounts for syntactical
differences found in Python3. To use the tool, open the Processing Toolbox panel in
QGIS3, next select the python symbol found in the ribbon, then Add Script to Toolbox.
Once added the toolbox should function as expected, however it should be noted that 
an output directory must be provided for the script to behave as intended. Also, results 
will not be added to the project after runtime, the user must manually add the water depth 
rasters to the project. 
