Author: @Austin Raney\
Email: aaraney@crimson.ua.edu

# Compiling WRF Hydro v5 on UAHPC
#### This will also work for compiling NWM on UAHPC
1. ssh into the UAHPC.
1. Enter `use netcdf4.6.2Intel`
1. Download WRF Hydro v5 from [source](https://ral.ucar.edu/projects/wrf_hydro/model-code)
	5. Follow link and right click on the source code download link and copy link.
	5. Go to ssh session and `wget <paste-link>`
1. Unpack source file with `tar zxvf wrf_hydro_nwm_public-5.*`
1. Change directories to the NDHMS folder. `cd wrf_hydro_nwm_public-5.*/trunk/NDHMS/`
1. Run the configure file with: `./configure` select option 3
1. Copy the setEnvar.sh file found in the template dir to your current dir with `cp template/setEnvar.sh .`
1. Open `vim setEnvar.sh` and change `export SPATIAL_SOIL=1` this is if you want that setting.
1. Run `./compile_offline_NoahMP.sh setEnvar.sh` note that this also works for compiling the Noah.sh version of Wrf\_Hydro also.
