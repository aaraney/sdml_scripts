Author: @Austin Raney
Email: aaraney@crimson.ua.edu

# Compiling WRF Hydro v5 on UAHPC
1. ssh into the UAHPC.
2. Enter `vim ~/.bashrc`
3. Paste the bashrc file from github to the end of your .bashrc
4. Exit the terminal and restart another ssh session on the UAHPC
5. Download WRF Hydro v5 from [source](https://ral.ucar.edu/projects/wrf_hydro/model-code)
    5. Follow link and right click on the source code download link and copy link.
    5. Go to ssh session and `wget <paste-link>`
6. Unpack source file with `tar -zxvf wrf_hydro_nwm_public-5.*`
7. Change directories to the NDHMS folder. `cd wrf_hydro_nwm_public-5.*/trunk/NDHMS/`
8. Run `./configure` select option 3
9. Run `rm macros`
10. Paste `wget https://raw.githubusercontent.com/aaraney/sdml_scripts/master/wrf_hydro/compile_guide/macros`
11. Run `cp template/setEnvar.sh .`
12. Open `vim setEnvar.sh` and change `export SPATIAL_SOIL=1` this is if you want that setting.
13. Run `./compileNoahMP.sh setEnvar.sh`