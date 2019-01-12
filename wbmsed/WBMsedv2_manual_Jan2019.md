# User and Developer manual to the WBMsed.v2 model

Sagy Cohen, Surface Dynamics Modeling Lab, University of Alabama

sagy.cohen\@colorado.edu

Frances Dunn, University of Southampton

f.dunn\@soton.ac.uk

### Document updates:

* **WBMsed.v2 user and developer manual - Sagy Cohen - May-2012**

* **Update -- Frances Dunn - May-2015**

* **Update (new RGIS)-- Sagy Cohen - Feb-2018**

* **Update (input generation; section 4.4)- Sagy Cohen - Jan-2019**

1\. Introduction

The WBMsed model (Cohen et al., 2013) is an extension of the WBMplus
water balance and transfer model (Wisser et al., 2010). In its initial
version WBMsed introduced a riverine suspended sediment flux module
based on the BQART (Syivitski and Milliman, 2007) and Psi (Morehead et
al., 2003) models.

This document will provide instructions on how to run the model and
further develop its code and datasets. The instructions here are based
on my experience and understanding of the WBMplus model (with some
correspondence with the latest developer of WBMplus: Balazs Fekete, The
City College of New York) and may not always be the most optimal
solution. The instructions here are based on using the University of
Alabama HPCC (UAHPC), but are transferable to a desktop computer (Mac or
Linux).

2\. The model infrastructure

The WBM modeling platform was designed to be highly modular. Each
process is written as an individual or a sequence of module (e.g.
MDischMean.c). These modules, as well as the main module (WBMMain.c),
are stored in Model/WBMplus/src. The modules are typically a simple
piece of code that utilizes the numerous WBM functions which are
responsible for the computational heavy lifting. Most of these functions
are stored in the CMlib and MFlib libraries (in the ghaas directory).

The model input/output is based on the RGIS (River GIS) formats. The
model uses the RGIS data manipulation functions (stored at the ghaas
directory) to read, write and convert the datasets.

The model run is controlled by Unix shell scripts located at the Scripts
directory. These scripts determine the input datasets and simulation
parameters. More about these at the next section.

3\. Setting up the RGIS framework

The RGIS framework provide the functions, libraries and tools needed to
run WBMplus. For a new HPC or Desktop, the framework must be compiled
before the model can be used. It only needs to be compiled once. The
framework was upgraded by Balazs in 2018 and is now much more
computationally efficient.

**3.1 Compiling on Linux** (likely by system admin on an institutional
HPC)

1\. Install udunits, netcdf, cmake using your package manager (apt-get, pacman, etc)

2\. Download RGIS from GitHub whether from the website or using the
terminal:

```bash
git clone <https://github.com/bmfekete/RGIS> RGIS
```

3\. Navigate (cd) to the downloaded folder and run the install script:

```bash
./install \< installation location\>
```

4\. If installation was successful it will create a **ghaas** folder with
the tools (bin) and libraries (lib) and scripts (Scripts).

5\. Add the ghaas path to the .bash\_profile or .profile files:

``` bash
cd \~
```

```bash
vi
```

In **vi** add the GHAASDIR definition:

\[i key to start editing\]

Add these lines at the end of the file (adjust the path according to
your system):

``` bash
export GHAASDIR=\"/bighome/scohen2/RGIS/ghaas\"

export PATH=\"/bighome/scohen2/RGIS/ghaas/bin:\$PATH\"

use udunits226

use gcc4.8.4
```

\[esc key to exit editing\]

\[: key to enter command mode\]

\[type '[wq' (now quotation)]{.underline} and 'enter' key to save and
exit vi\]

6\. Exit and re-ssh to your hpc to activate the modifications.

**3.2 Compiling on macOS**

1\. Install MacPort (package management framework):
<https://www.macports.org/install.php>

2\. Install netcdf, cdo, xcode, udunits and openmotif using (e.g.):

```bash
port install netcdf
```

3\. Download RGIS from GitHub wither from the website or using the
terminal:

``` bash
git clone <https://github.com/bmfekete/RGIS> RGIS
```

4\. Navigate (cd) to the downloaded folder and run the install script:

``` bash
./install \< installation location\>
```

5\. If installation was successful it will create a **ghaas** folder with
the tools (bin) and libraries (lib) and scripts (Scripts).

6\. Add the ghaas path to the .bash\_profile or .profile files:

``` bash
cd \~
```

``` bash
vi
```

In ***vi*** add the GHAASDIR definition:

\[i key to start editing\]

add these lines at the end of the file (adjust the path according to
your system):

``` bash
export
PATH=\"/usr/local/share/ghaas/bin:/usr/local/share/ghaas/f:\$PATH\"export
```

\[esc key to exit editing\]

\[: key to enter command mode\]

\[type '[wq' (now quotation)]{.underline} and 'enter' key to save and
exit vi\]

6\. Close and reopen the terminal to activate the modifications.

**\
4. Running the model**

**4.1. Compiling --** Unnecessary if you\'re running the model without
modifying the C code. The model needs to be recompiled before launching
it on a new computer platform or if its C code was modified.

The WBMplus code can be downloaded from GitHub:
<https://github.com/bmfekete/WBMplus>

The WBMsed code is also available on GitHub
(<https://github.com/csdms-contrib/wbmsed>) but is not updated
regularly. Contact Sagy Cohen for most updated version
(<sagy.cohen@ua.edu>).

To compile the code (will only work if RGIS is installed):

Navigate to the model directory:

``` bash
cd /grps1/scohen2/WBMsed\_runs/WBMsed3.3/Model/WBMplus

make
```

A successful compilation will create a new wbmplus.bin file in
Model/WBMplus/bin

**4.2. Setting the run script --** The run shell script (e.g.
/grps1/scohen2/WBMsed\_runs/WBMsed3.3/Scripts/WBMsed\_monthly.sh)
controls the simulation. It has a rigid structure that must be kept.

*The WBMsed model (unlike WBMplus) requires a separate initial
simulation. This initial simulation is needed only once for each
simulation domain (e.g. Global, North America). This simulation is
controlled by the BQARTpreprocess.sh script. It generates long-term
temperature ~~and discharge~~ outputs used in the main simulation
controlled by the main script. *

Below I describe the important variable in the model simulation script
file.

PROJECTDIR -- Define the simulation directory --where the model is and
where to save intermediate and final results. Assumes that the script
file and the model are in the same directory (simulation directory)
using the above specified file structure.

GHAASDIR -- Location of the ghaas directory. If it was defined in the
.bash\_profile (section 3.1), it does not need to be defined here. In
UAHPC it is currently at: \"/bighome/scohen2/RGIS/ghaas\"

MODEL -- the location of the model bin file, e.g.:
\"\${PROJECTDIR}/Model\_new/WBMplus/bin/wbmplus.bin\"

RGISARCHIVE -- the location of the input datasets directory. On UAHPC
use /grps1/scohen2/InputData/RGISarchive2 More about adding input
datasets later.

RGISRESULTS -- here you determine where you want the model to save the
results. The default is \${PROJECTDIR}/RGISresults

RGISCSDMS- the location of WBMsed specific (as appose to WBMplus) input
files. On UAHPC use /grps1/scohen2/InputData/RGISarchiveCSDMS

MEANINPUTS- the location of the WBMsed phase long-term input files. On
UAHPC use /grps1/scohen2/InputData/SDMLmeanInputs

EXPERIMENT -- the name of the simulation. Will be imbedded in the output
files name.

STARTYEAR -- the simulation start year. Make sure the input datasets
begins at that or an earlier year.

ENDYEAR -- the simulation end year. Make sure the input datasets reach
this year.

AIRTEMP\_STATIC up to PRECIP\_FRAC\_DYNAMIC -- setting the air
temperature and precipitation input datasets.

NETVERSION -- the flow network dataset. Use a different dataset for 6
and 30 minute spatial resolution. The current network used for 6 are-min
simulation is HydroSTN30. The following WBMsed input datasets are
network-specific or dependent: ReliefMax, Reservoirs, BankfullQ,
~~DischargeAcc~~

RGISarchiveFormat netcdf -- if this line is added the output files will
be written as NetCDF

FwArguments -- here you define some of the simulation parameters. The
important ones are:

> -s (on/off) -- spin-up -- a set of simulation cycles to initializing
> the model runs; Default: on

-f (on/off) -- final run -- the actual simulation after the spin-up
cycles; Default: on

-n (\#) -- number of spin-up cycles; Default: 10

> -D (on/off) -- daily output -- when set to 'on' the model will create
> yearly, monthly and daily output layers, when 'off' it will only
> create yearly and monthly (can save a lot of disk space).
>
> -p (on/off) -- Parallel -- when set to 'on' the model will not save
> intermediate files (can save a lot of disk space and runtime).

source \"\${GHAASDIR}/Scripts/fwFunctions23.sh\" -- define the functions
file.

DATASOURCES - the input datasets array. Here you control the dataset
which corresponds to each input parameter in your simulation. You can
add inputs here but must follow the syntax. More about how to add an
input later.

OPTIONS -- the simulation options array. The Model option defines which
module the model will start with. So if you want to simulate discharge
alone you write Model discharge; and the model will first go to the
discharge module and initiate all the relevant modules from there. If
you want to simulate sediment you write Model sedimentflux. In this case
discharge will also be simulated as it is called by the SedimentFlux
module. Other options are bedloadflux and balance.

OUTPUTS -- the simulation output array. Here you define which of the
model parameters will be exported as outputs. These names must
correspond to parameters name in the modules and in the
/bighome/scohen2/RGIS/ghaas/include/MF.h file. More about adding new
parameters in the developers section below.

FwDataSrc - a function call (to fwFunctions23.sh) which set up the input
data source listed.

FwOptions - a function call (to fwFunctions23.sh) which set up the
option listed.

FwOutputs - a function call (to fwFunctions23.sh) which set up the
outputs listed.

FwRun - a function call (to fwFunctions23.sh) which controls the model
run.

As you can see the fwFunctions23.sh is an important file containing many
of the shell functions needed to run the model.

You can use any text-editing tool (e.g. vi) to edit the script file.
ForkLift is a good app for connecting Mac to UAHPC so you can edit the
script with a text editor (e.g. TextWrangler). If you create a new shell
script you will probably need to define its permissions. You do so with
the chmod command:

``` bash
chmod 755 filename.sh
```

**3.4. Launching the model --** when you log into UAHPC you start in its
headnode. DO NOT run long or heavy calculations on the headnode as it
slows it down for everyone. For running the model on beach you MUST use
the SLURM queuing system. SLURM has many useful options and tools for
controlling your simulation (see:
<https://oit.ua.edu/service/research-getting-started/>).

Go to the Scripts directory:

``` bash
cd \<name of simulation directory\>/Scripts
```

Alter the SLURM script file (sbatch\_owner.sh) to suit your simulation.
The script file allows you to define a number of simulation parameters
and will direct you to the most appropriate queue on UAHPC. Here is an
example of a script file to run WBMsed (sbatch\_owner.sh):

``` bash
#!/bin/bash
#SBATCH \--job-name=WBMsed
#SBATCH -n 8
#SBATCH \--mem=32G
#SBATCH -p owners
#SBATCH \--qos scohen2
#SBATCH \--error=error.%J.txt
#SBATCH \--output=output.%J.txt
```

``` bash
./WBMsed\_monthly.sh Global 06min dist
```

The \#SBATCH notation define the different options for the simulation:

\--job-name -- simulation name which will appear on the queue (squeue
command);

-n -- number of cores requested; The SDML owner queue have a total of 16
cores.

\--mem -- the size of ram requested for this job;

-p -- the SLURM queue requested; SDML is part of the 'owners' queue.
Other queues include 'long' and 'main'.

\--qos scohen2 -- define which owners queue to direct the job. For using
the SDML allocations use scohen2

\--error=error.%J.txt -- name of the error file that will be created at
the /Scripts folder; record the errors that occurred during the job run.

\--error=output.%J.txt -- name of the output file that will be created
at the /Scripts folder; record the output messages that the job
generate.

./WBMsed\_monthly.sh Global dist 06min -- command that initiate the
model run.

The final line is important for your simulation:

The [first argument]{.underline} is the shell script name.

The [second argument]{.underline} is the simulated domain (e.g. Global,
NAmerica). You need to be aware of the input datasets available for each
domain. The model will automatically use a Global dataset to fill in for
missing datasets in smaller domain. The most important dataset to run a
model in a smaller domain is the Network.

The [third argument]{.underline} can take the following options:

dist - distributed simulation (standard);

prist - pristine simulations (turning off the irrigation and reservoir
operation modules);

dist+gbc or prist+gbc - are the same but turning on the water chemistry
modules.

The [fourth argument]{.underline} is the spatial resolution. If the
model cannot find the resolution of dataset specified it will use a
lower resolution.

To launch the SLURM script, make sure you are in the Scripts directory:

``` bash
cd Scripts
```

Then submit it to the queue:

``` bash
sbatch \< sbatch\_owner.sh
```

You can limit the display to just your runs with:

``` bash
squeue --u \<your\_username\>
```

**3.5. During the simulation --** first the model will create a folder
named GDS where the intermediate input and output datasets and log files
will be created and updated during the simulation. The spin-up cycles
will use the first year input datasets in all the spin-up cycles. After
the last spin-up cycle the model will create a new folder named
RGISresults where the output files will be stored. For each simulation
year the model will create a new set of input and output files in GDS
and at the end of the year it will export that year's final output files
to RGISresults.

** 4. Developer guide **

This section will show how to develop the WBM code and how to compile
new input and output datasets and incorporate them in the model
simulation. The explanations here are based on my experience from
developing the WBMsed model.

** 4.1 Building and editing a module **

As in all C programs the first lines in a WBM module are the \#include
definition. In addition to the standard and general C libraries (e.g.
stdio.h and math.h) a module must include the WBM libraries: cm.h, MF.h
and MD.h. These header files are located in the '/include' directories
in the: CMlib, MFlib and WBMplus directories respectively. They contain
the functions and parameters used in WBM.

After the \#include list we define all the input and output parameters
ID in the module like this:

``` C
static int \_MDInDischargeID = MFUnset;
```

These IDs are used in the WBM functions to query (e.g. MFVarGetFloat)
and manipulate (e.g. MFVarSetFloat) the model parameters. MFUnset is an
initial value before an actual ID is set in the definition function.

WBM is built as an array of modules each typically computes a specific
process (e.g. MFDischarge.c). Each module contain two functions: (1) a
what we will call **main function** and (2) a **definition**
**function.** In MFSedimentFlux.c module the main function is called
'\_MDSedimentFlux**'** and the definition function is called
**'**MDSedimentFluxDef**'**.

** The definition function ** set the ID of all the input
and output parameters used in the main function. If a parameter (e.g.
Discharge) is calculated in a different module within the WBM model this
module is initialized like this:

((\_MDInDischargeID = MDDischargeDef ()) == CMfailed) \|\|

where \_MDInDischargeID is the variable that holds the discharge
parameter ID in the MFSedimentFlux.c module, MDDischargeDef () is the
name of the definition function in the Discharge module (MFDischarge.c)
and CMfailed is an error control variable (note the 'if' at the start of
the parameter definition list).

This is how WBM works, it starts with one module (MFSedimentFlux.c in
the WBMsed case) and each module calls the other modules it needs. This
chain of module interactions is recorded at the 'Run\<year\>\_Info.log'
file during the simulation (at the /GDS/...\..../logs directory).

An input and output dataset parameter (e.g. air temperature) ID is
defined like this:

((\_MDInAirTempID = MFVarGetID (MDVarAirTemperature, "degC", MFInput,
MFState, MFBoundary)) == CMfailed) \|\|

where \_MDInAirTempID is the parameter ID variable, MFVarGedID is a WBM
function that define IDs to input and output parameters. It requires the
following arguments:

The first argument is the parameter name. This variable is
what links the module to the simulation shell script (e.g.
BQARTdaily.sh) input and output list (DATASOURCES and OUTPUTS
respectively; see section 3 above).

The second argument is the parameter units (e.g. "degC",
"km2", "m3/s"). This variable does not seem to have an effect on the
model run and is for cataloging purposes.

The third argument can take the following options:
MFInput- a regular input parameter; MFOutput a regular output parameter;
MFRoute- the model will accumulate the parameter content in the
downstream grid cell, so by the time the execution gets to the
downstream grid cell it already contains the accumulated values from
upstream.

The fourth argument affects how temporal disaggregation is
handled. It can take the following options: MFState- the input value is
passed to the modules as is; MFFlux- the input value is divided by the
number of days in the input time step.

The fifth argument affects how a variable is read. It can
take the following options: MFBoundary- the parameter is read constantly
from input, by matching up to the current time step; MFInitial- the
model forwards to the last time step in the data, reads in the latest
values and closes the input stream assuming that the parameter will be
updated by the model.

After the list of input and output parameters ID definitions the module
initiates the main function:

(MDModelAddFunction (\_MDSedimentFlux) == CMfailed)) return (CMfailed);

where MDModelAddFunction is a WBM function, \_MDSedimentFlux is this
function argument -- the name of the module main function. CMfailed is
an error controller.

Next is the MFDefLeaving function which takes a string argument (e.g.
"SedimentFlux") of the module name.

The final line in a module definition function returns the module main
output ID (e.g. \_MDOutSedimentFluxID) which was defined in the
parameters ID definition list above it.

** The main function (e.g. \_MDSedimentFlux) is where the
processes are simulated. It gets at least one argument called 'itemID'
in its definition line:

static void \_MDSedimentFlux (int itemID) {

itemID is a pixel number. WBM assigns a number to each pixel based on
its location in the flow network. The model goes through the whole
simulation cycle a pixel at a time at a daily time step. So for one
model iteration (a day) it calls each simulated module a number of times
equal to the number of simulated pixels. For each such call the itemID
change in accordance to downstream pixel location (e.g. pixel \#345 is
downstream of pixel \#344). Note that the pixel numbering is continues
so a hinterland pixel number of a basin can follow an outlet pixel of a
different basin on a different continent.

As in all C functions the first lines in a module main function are the
local variable declarations.

WBM use a multitude of functions to query and manipulate its parameters.
My personal preference is to assign a variable to both input and output
parameters.

**First** **I** **get the input parameter value**, for example:

R = MFVarGetFloat (\_MDInReliefID, itemID, 0.0);

where R is the relief variable, MFVarGetFloat is a WBM function that
reads a parameter value. It get the following arguments:

The first argument is the parameter ID (e.g
\_MDInReliefID). This ID was assigned at the module definition function
(see above);

The second argument is the pixel ID (i.e. itemID);

The third argument is an initial value (I'm not sure what
it's for!).

I can then easily manipulate this variable:

R = R/1000; // convert to km

I then use the variables to calculate the module processes, for example:

Qsbar = w \* B \* pow(Qbar\_km3y,n1) \* pow(A,n2) \* R \* Tbar;

Finally I **set the resulting output parameters**:

MFVarSetFloat (\_MDOutQs\_barID, itemID, Qsbar);

where MFVarSetFloat is a WBM function that set or update a parameter
value. It gets the following arguments:

The first argument is the parameter ID (e.g
\_MDOutQs\_barID).

The second argument is the pixel ID (i.e. itemID);

The third argument is the variable that holds the value
you wish to set (Qsbar).

These get and set operations are also used for bookkeeping purposes. For
example in WBMsed we need to calculate long-term average temperature for
each pixel and then basin-average it (we consider each pixel to be a
local outlet of its upstream contributing area).

I start by getting daily temperature for each pixel from an input
dataset:

Tday = MFVarGetFloat (\_MDInAirTempID, itemID, 0.0);

I then temporally accumulate a pixel temperature into a bookkeeping
parameter (\_MDInNewAirTempAccID):

T\_time=(MFVarGetFloat(\_MDInNewAirTempAcc\_timeID, itemID, 0.0)+ Tday);

MFVarSetFloat (\_MDInNewAirTempAcc\_timeID, itemID, T\_time);

Note that I'm using the MFVarGetFloat function within the calculation in
this case. This is a more efficient way of coding but can be harder to
debug.

In order to spatially average temperature I first spatially accumulate
the temporal summation (T\_time):

Tacc = (MFVarGetFloat (\_MDInAirTempAcc\_spaceID, itemID, 0.0) + T\_time
\* PixelSize\_km2);

where PixelSize\_km2 is the size (area) of the pixel (calculated with
the MFModelGetArea function).

I then average the temperature by dividing it by the number of iteration
passes since the start of the simulation (TimeStep) and the size of the
pixel upstream contributing area (A):

Tbar = Tacc/TimeStep/A;

Finally I pass the Tbar value to an output parameter
(\_MDOutBQART\_TID):

MFVarSetFloat (\_MDOutBQART\_TID, itemID, Tbar);

**An important note**: to allow downstream spatial accumulation a
parameter needs to be defined (in the definition function) as MFRoute.
If it is set as MFOutput it will accumulate things in time. The
definition arguments were described earlier.

**4.2 Adding a new output parameter to a module**

WBM is an interaction between a core C program and shell script files
that control it. Therefore in order to add a new output parameter we
need to accurately define this new parameter in several locations. Below
is a step-by-step description of how to add an output parameter using
the sediment load (Qsbar) parameter in the MFSedimentFlux.c module.

**Step 1**- at the start of the module C file (MFSedimentFlux.c) add the
ID variable declaration:

static int \_MDOutQs\_barID = MFUnset;

**Step 2-** in the module definition function (MDSedimentFluxDef**)**
add an ID definition line:

((\_MDOutQs\_barID = MFVarGetID (MDVarQs\_bar,\"kg/s\",MFOutput,
MFState, MFBoundary)) == CMfailed) \|\|

This code was explained earlier.

**Step 3-** define the parameter "nickname" in the WBMsed header file
(MD.h located at /Model/WBMplus/include):

\#define MDVarQs\_bar \"Qs\_bar\"

Note that the parameter name (MDVarQs\_bar) must be the same as in step
2.

**Step 4-** you can now use the parameter in the module main function
(\_MDSedimentFlux) for example to set its value:

MFVarSetFloat (\_MDOutQs\_barID, itemID, Qsbar);

This code was explained earlier.

**Step 5-** to set WBMsed to create an output dataset of this parameter
you need to add it to simulation script (e.g. BQARTdaily.sh) output
list:

OUTPUTS\[\${OutNum}\]=\"Qs\_bar\"; ((++OutNum))

Note that the parameter "nickname" must be similar to step 3.

**4.3 Adding an input parameter of an existing dataset**

The steps for adding an input parameter linked to a dataset already in
existence at the WBM datasets library (the /data/ccny/RGISarchive
directory on beach) are similar to adding an output parameter with the
following differences:

In **Step 2** the arguments of the MFVarGetID function need to reflect
an input parameter (see description in section 4.1).

In **step 5** you should add the parameter to the datasources (rather
than the OUTPUTS) list like this:

DATASOURCES\[\${DataNum}\]=\"FieldCapacity static Common file
\$(RGISfile \${RGISARCHIVE} \${DOMAIN}+ field\_capacity WBM
\${RESOLUTION}+ static)\"; ((++DataNum))

This exact syntax must be kept for the model to get the dataset name and
location. In the example above 'FieldCapacity' is the parameter
"nickname" defined in MD.h (**Step 3**) and 'field\_capacity' is an RGIS
"nickname" defined at the RGISfunctions.sh file located at the
/ghaas/scripts directory. In the above example if:

RGISARCHIVE = "/data/ccny/RGISarchive" (defined in the simulation script
e.g. BQARTdaily.sh);

DOMAIN = "Global" (entered at the model run command; see section 3.4);

RESOLUTION = "30min" (entered at the model run command; see section
3.4);

The model translates this to the following file location and name:

/data/ccny/RGISarchive/Global/Soil-FieldCapacity/WBM/30min/Static/
Global\_Soil-FieldCapacity\_WBM\_30min\_Static.gdbc

**4.4 Preparing and adding a new input dataset **

WBM use the RGIS (River GIS) format for input datasets. Below I describe
the procedure I use to compile new input datasets that can be read by
WBMsed. This description is focused on manipulating ArcGIS and NetCDF
rasters and using RGIS tools. Other tools may be needed for different
GIS packages and formats. Compilation of a new Network Domain, a static
input file and (temporally) dynamic input dataset are described.

**4.4.1 Generating new Network Domain Files (from a DEM)**

Network files in WBMsed controls the simulation domain (stream network)
and resolution. The WBM framework offer a large number of ready-to-use
domain files. Generating a new Domain can be done by subsetting an
existing network in RGIS (not described here) or from a DEM:

**Step 1** -- Calculate Flow Direction (D8) in ArcGIS (Flow Direction
Tool)

**Step 2** -- Convert the Flow Direction raster to ASCII in ArcGIS
(Raster to ASCII Tool)

**Step 3** -- Import the flow direction ascii file to RGIS either by:

In Terminal:

``` bash
netImportASCII \<flowdir.asc\> \<output.gdbn.gz\>
```

In RGIS GUI: Tools -\> Import -\> Network Grid

**Step 4** -- set the network file header and name (remember to follow
the WBM naming structure) in the RGIS GUI or command line

**Step 5** -- generate a directory tree in the input database location
(/grps1/scohen2/InputData/RGISarchive2); see figure below.

**Step 6** -- add a 'parent' file which include the work 'Global'. Best
to copy it from a different non-global directory. This file tells WBM to
use global input files when needed.

**Step 7** -- if the resolution of the file does not exist in WBM (e.g.
0.1sec) it needs to be added to the RGISfunction.sh file
(/bighome/scohen2/RGIS/ghaas/Scripts) in line 1380.

**Step 8** -- Modify the simulation script to run the new network, e.g.
in line 64:

(0.3sec\|01sec)

NETVERSION = "NED"

;;

![](media/image1.png){width="3.254166666666667in" height="1.9in"}

**4.4.2 Generating Static Input File (Relief)**

The maximum relief layer is the difference between a pixel local
topographic elevation (DEM) and the maximum elevation of its upstream
contributing area. It is paramount that the Relief input is matched to
the simulation network domain. This can be ensured by using the network
domain Flow Direction and DEM files. Calculation of the relief layer in
ArcGIS using TauDEM extension
(<http://hydrology.usu.edu/taudem/taudem5/downloads.html>):

**Step 1** -- convert the flow direction layer coding to TauDEM coding
using ArcGIS Reclassify tool (see table below).

  Old Value   New Value
  ----------- -----------
  1           1
  2           8
  4           7
  8           6
  16          5
  32          3
  64          4
  128         2

**Step 2** -- use 'D8 Extreme Upstream Value' TauDEM tool using the flow
direction and DEM as inputs \[I needed to modify the tool's python
script by adding 'if arcpy.Exists(ogrfile):' in line 83\].

**Step 3** -- In ArcGIS Raster Calculator calculate deduct the DEM
elevation from the output of Step 2: \<MaxElevation\> - \<DEM\>

**Step 4** -- Convert the new relief raster to ASCII in ArcGIS (Raster
to ASCII Tool)

**Step 5** -- convert ascii file to gdbc in terminal:

\> grdImport \<name.asc\>

Follow prompt option. Set output name according to WBM naming standard.

**Step 6** -- set file header

\> setHeader --a Max-Relief\_30min\_Global.gdbc (and follow the prompt)

Or use the RGIS GUI (/ghaas/bin):

\> ./rgis21

and use the 'File -\> Header Info' tool.

**Step 7** - It is crucial to **set the layer date** in the RGIS GUI
with the 'Edit -\> Date Layer' tool. For a temporally static dataset
(e.g. Relief) set the year to xxxx.

Save these changes in the RGIS GUI ('File -\> Save').

Test the layer conversions and edits by **converting it to NetCDF**:

\> rgis2netcdf Max-Relief\_30min\_Global.gdbc.gz
Max-Relief\_30min\_Global.nc

**Step 8** - Rename the RGIS layer and put it in a directory in
accordance to the model's datasources format (in the simulation script
e.g. BQARTdaily.sh, described in section 4.3 above:

RGISarchiveCSDMS/Global/Relief-Max/ETOPO1/30min/Static/

Global\_Relief-Max\_ETOPO1\_30min\_Static.gdbc

**Step 9** -- The dataset name and location should be referenced in the
simulation script datasources list:

DATASOURCES\[\${DataNum}\]=\"ReliefMax static Common file \$(RGISfile
\${RGISARCHIVE} \${DOMAIN}+ relief\_max PotSTNv120 \${RESOLUTION}+
static)\"; (( ++DataNum ))

**Step 10** -- [if]{.underline} this dataset is a for a new parameterm
we need to set the two "nicknames":

The first (e.g. "ReliefMax") in /Model/WBMplus/include/MD.h file:

\#define MDVarRelief \"ReliefMax\"

The second (e.g. "relief\_max") in the /ghaas/Scripts/RGISfunctions.sh
file:

(relief\_max)

echo \"Relief-Max\"

;;

***4.4.3 Generating Dynamic Input Dataset (Daily Precipitation)***

Temporally dynamic datasets can be generated with an automated script
which convert the GIS files (ascii files in this case) to gdbc files
(grdImport) and set its date (grdDateLayers) and header information
(setHeader). In this example, daily precipitation data is organized as
individual ascii files. The grdImport has a 'file list' option which
will create a multi-dimensional (monthly or daily) gdbc file. When this
option is used a txt file with the files' names need to be provided.

**Step 1** -- generate .txt files which contain the names of all daily
file names for a given year. A python script (grdImport\_FileList.py)
was used:

``` python
import datetime

firstYear = 1990

lastYear = 2014

for year in range(firstYear, lastYear+1):

print year

start = datetime.datetime.strptime(str(year)+\'\_01\_01\',
\'%Y\_%m\_%d\')

end = datetime.datetime.strptime(str(year)+\'\_12\_31\', \'%Y\_%m\_%d\')

step = datetime.timedelta(days=1)

Outfname = str(year)+\'.txt\'

f = open(Outfname, \'w\')

while start \<= end:

date = start.date()

strDate = str(date)

fName = \'RF\_All\_{0}\_{1}\_{2}.asc\'.format(date.year, strDate\[5:7\],
strDate\[8:10\])

f.write(fName+\'\\n\')

start += step
```

**Step 2** -- Run the Convert\_ASCII2RGIS\_Daily.sh script to generate
the .gdbc.gz flies:

``` bash
#!/bin/bash

if \[ -z \"\$1\" \]; then

echo \"Please enter first and last year\"

fi

if \[ -z \"\$2\" \]; then

echo \"Please enter first and last year\"

fi

yr=\$1

lyr=\$2

touch partialInputFile3.txt

for (( i=\$yr; i\<=\$lyr; i++ ))

do

fname=Hawaii\_Precipitation\_HI\_7.5sec\_dTS\$\[i\].gdbc.gz

echo 3 \> partialInputFile3.txt \#Binary Type: 0=byte, 1=short, 2=long,
3=float, 4=double?

echo -9999 \>\> partialInputFile3.txt

echo 1 \>\> partialInputFile3.txt

echo \$fname \>\> partialInputFile3.txt

echo 1 \>\> partialInputFile3.txt

echo \"\$\[i\].txt\"

grdImport -b \$\[i\].txt \< partialInputFile3.txt

grdDateLayers -e day -y \$i \$fname \$fname

setHeader -s Precipitation -d Hawaii \$fname

setHeader -t \'Hawaii, Precipitation (7.5sec, DaliyTS, \$i)\' \$fname

done
```

**Step 3** -- Copy the gdbc.gz files to the input directory making sure
to follow the naming and directory tree structure of WBM. For a
non-global dataset, the name of the simulation domain should be used. In
the below screenshot, the dataset was generated for the state of Hawaii
and was placed in a directory tree starting with its domain name. The
directory below it is for the Oahu (one of the Hawaiian Islands)
simulation domain which include a 'parent' file which contain the word
'Hawaii'. This will direct the 'Oahu' simulation to the 'Hawaii'
precipitation and then to 'Global' 'everything else' (the Hawaii domain
has a 'Global' parent file).

![](media/image2.png){width="1.292361111111111in"
height="1.8305555555555555in"}

**4.5 Incorporating a new module to WBM**

The WBM module structure was explained in section 4.1. Here I will
describe the additional steps needed to incorporate a new module to WBM.
As before I will use the MFSedimentFlux.c module as an example.

I recommend starting with a simple module with just a couple of
parameters and gradually add to it once it is successfully incorporated
in WBM (as will be described next). A simple way to do so is to copy an
existing module file (e.g. MFDischarge.c) change its file and functions
(main and definition functions) names and delete most of its code,
leaving just a couple of parameters and variables:

``` C
#include \<stdio.h\>

\#include \<string.h\>

\#include \<cm.h\>

\#include \<MF.h\>

\#include \<MD.h\>

// Input parameter

static int \_MDInDischargeID = MFUnset;

// Output parameter

static int \_MDOutSedimentFluxID = MFUnset;

**//The main function:**

static void \_MDSedimentFlux (int itemID) {

float Qs,Q;

Q = MFVarGetFloat (\_MDInDischargeID,itemID, 0.0);

Qs = pow(Q,2);

MFVarSetFloat (\_MDOutSedimentFluxID,itemID, Qs);

}

**//The definition function:**

int MDSedimentFluxDef() {

MFDefEntering (\"SedimentFlux\");

if (((\_MDInDischargeID = MDDischargeDef()) == CMfailed) \|\|

((\_MDOutSedimentFluxID = MFVarGetID (MDVarSedimentFlux,\"kg/s\",
MFRoute, MFState, MFBoundary))== CMfailed) \|\|

(MFModelAddFunction (\_MDSedimentFlux) == CMfailed)) return (CMfailed);

MFDefLeaving (\"SedimentFlux\");

return (\_MDOutSedimentFluxID);

}
```

The next step is to add the new definition function to the model header
file (/Model/WBMplus/include/MD.h):

``` C
int MDSedimentFluxDef();

//Add the input and output parameters to the simulation script file (e.g.
/Scripts/BQARTdaily.sh) and model header file (MD.h) as described in
sections 4.2-4.4. In the example above we only need to add the
MDVarSedimentFlux parameter to the header (MD.h) file:

#define MDVarSedimentFlux \"SedimentFlux\"
```

// and set it as an output in the simulation script file:

OUTPUTS\[\${OutNum}\]=\"SedimentFlux\"; ((++OutNum))

The input parameter in this case is an existing module (MDDischargeDef)
so is it is already defined.

The next two steps depend on whether the new module will be a leading
module or not. A leading module is the first module at the module
simulation chain. For example in WBMsed MFSedimentFlux.c is the leading
module. The model starts with this module which then calls the modules
it needs which intern call the modules they require and so on.

In the case of **a new leading module** you need to add it to the WBM
main file (/Model/WBMplus/WBMmain.c) in the following places:

1\. In the enum declaration: MDsedimentflux};

2\. In the \*options\[\] definition: \"sedimentflux\",(char \*) NULL };

3\. In the switch(optID){ list:

case MDsedimentflux: return (MFModelRun
(argc,argv,argNum,MDSedimentFluxDef));

At the simulation script file (e.g. /Scripts/BQARTdaily.sh) you need to
change the OPTIONS "Model" argument to:

OPTIONS\[\${OptNum}\]=\"Model sedimentflux\"; (( ++OptNum )):

And add:

``` bash
OPTIONS\[\${OptNum}\]=\"SedimentFlux calculate\"; (( ++OptNum ))
```

In the case where the module is **not a new leading module** you only
need to add an initiation call in a relevant calling module. In the
example above the MFSedimentFlux.c module is initiating the
MFDischarge.c module by calling its definition function:

((\_MDInDischargeID = MDDischargeDef()) == CMfailed) \|\|

The final step is to **add the new module to the WBM 'Makefile' file**
(at /Model/WBMplus/src/ directory):

\$(OBJ)/MDSedimentFlux.o\\

and **compile the model** (see section 3.1).
