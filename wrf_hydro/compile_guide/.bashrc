# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# set vi mode
set -o vi

# make sure that bash complete works
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

use netcdf461Intel
use openmpiIntel
## In my ~/.bashrc I have
##       ## WRF HYDRO
export NETCDF=/share/apps/netcdf.new/intel/
export WRF_HYDRO=1
export HYDRO_D=1
##     ### manage ifort on hydro
# export ifortNetcdfLib="/share/apps/netcdf.new/intel/lib/"
# export ifortNetcdfInc="/share/apps/netcdf.new/intel/include/"
##       # RPATH for ifort (pgi is already default so no need)
# ifortMpiLib="/share/apps/openmpi/Intel/1.6.4/lib/"
# export ifortLdFlags="-Wl,-rpath,${ifortNetcdfLib}:${ifortMpiLib} -L${ifortNetcdfLib} -L${ifortMpiLib}"
# export ifortCompiler90="/share/apps/openmpi/Intel/1.6.4/bin/mpif90" 
##       # Aliases for invoking ifort
alias impirun='/share/apps/openmpi/Intel/1.6.4/bin/mpirun'
alias iman='man -M/share/apps/netcdf.new/intel/share/man'
##       # Bonus: Check your wrf hydro environment - up you to maintain to your needs.
alias henv='printenv | egrep -i "(HYDRO|NUDG|PRECIP|CHAN_CONN|^NETCDF|^LDFLAGS|^ifort)" | egrep -v PWD'
