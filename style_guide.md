author: Austin Raney\
email: aaraney@crimson.ua.edu

# SDML\_Scripts Repository Style Guide
This document outlines the conventions which must be upheld when using the sdml\_scripts repository.

### Markdown ReadMe Files
Before adding a script to the repository a markdown ".md" file must be added to the repository which outlines the script's intended use as well as the author, email, 
date written, dependencies, inputs and outputs. For both inputs and outputs their respective expected filetype should also be included. An example template can be 
found in the getting\_started folder. It is titled, script\_readme\_template.md or as follows (replace the inside <>):
```markdown
author: <++>\
email: <++>\
date: <++>

# <Script Name>
* Dependencies
	* <dep 1>
	* <dep 2>
* Inputs
	* <input name 1>.tif,grid
	* <input name 2>.shp

<Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.>
```

### Adding a Script
- **No scripts in the root directory**

Instead, files should be added to a/the folder that denotes which application or model that the script 
is written for. Ex. An ArcPy script written to augment rasters should be placed within the ArcGis folder. Each script is required to have a markdown file ".md" which 
briefly describes what the script's intended use is. To continue the ArcPy example, lets say the script is named sqrt\_raster.py. The sqrt\_raster.py file must also
have a file called sqrt\_raster.md that is placed in the same folder as the script. See the [Markdown ReadMe Files](#markdown-readme-files)

