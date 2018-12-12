Author: @Austin Raney\
Email: aaraney@crimson.ua.edu

# Compiling WRF Hydro v5 on UAHPC
#### This will also work for compiling NWM on UAHPC
1. ssh into the UAHPC.
2. Enter `vim ~/.bash_profile`
3. Append the bash\_profile file from github to the end of your .bash\_profile
4. Run the command `source ~/.bash_profile` 
5. Download WRF Hydro v5 from [source](https://ral.ucar.edu/projects/wrf_hydro/model-code)
	5. Follow link and right click on the source code download link and copy link.
	5. Go to ssh session and `wget <paste-link>`
6. Unpack source file with `tar -zxvf wrf_hydro_nwm_public-5.*`
7. Change directories to the NDHMS folder. `cd wrf_hydro_nwm_public-5.*/trunk/NDHMS/`
8. Run `./configure` select option 3
9. Run `cp template/setEnvar.sh .`
10. Open `vim setEnvar.sh` and change `export SPATIAL_SOIL=1` this is if you want that setting.
11. Run `./compile_offline_NoahMP.sh setEnvar.sh` note that this also works for compiling the Noah.sh version of Wrf\_Hydro also.
