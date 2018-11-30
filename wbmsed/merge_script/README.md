author: Austin Raney
email: aaraney@crimson.ua.edu
date: "28-11-2018"

# merger.sh Read Me File

## Description:
	This script uses bash and python to merge WBMsed and USGS gaging site csv files into an analysis ready product.

1. Place both the merger.sh and formatter.py files into a new directory. 
2. Open terminal and cd to the folder that you placed the scripts in
3. chmod +x merger.sh
4. ./merger.sh
5. Place the WBMsed files into the model folder and the gaging station files into the usgs folder
	5. It should be noted that the gaging station id numbers are used to match which files are merged together
6. ./merger.sh 
7. A new folder called merged should be in your current working directory and will hold the merged WBMsed data files.

Happy scripting
