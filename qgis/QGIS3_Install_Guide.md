### QGIS 3.4 Installation Issue Guide
Austin Raney\
[aaraney@crimson.ua.edu](mailto:aaraney@crimson.ua.edu)\
November 2018
---- 
The following may not apply to you, but I did incur some issues when trying to get the processing toolbox setup on my Mac machine. 
#### Issues
###### Mac OSX Installation
QGIS 3 requires that you use a python 3.6.\* version from [python.org](python.org). In this installation I used [3.6.5](https://www.python.org/ftp/python/3.6.5/python-3.6.5-macosx10.6.pkg).
If you have installed python 3 using _homebrew_ or some other package manager please remove it before installing the above python package. For example:
```bash
brew tap beeftornado/rmtree
brew rmtree python
```
`rmtree` will remove all of the dependencies that homebrew’s python installed previously. It should be noted that `homebrew's` python 3 package is called `python` not `python@2`.
###### Package `owslib` not installed
For some reason the QGIS 3 installer did not install `owslib`. To fix this open terminal and run the following:
```bash
pip3 install owslib
```
Restart QGIS 3.
###### Other possible issues
In the past I have run into issues with GDAL and specifically its absence in my `$PATH` environment variable. To test if you GDAL is in your `$PATH` open terminal and run the following:
```bash
python3 -c "import gdal"
```
If nothing is returned you are all set. Otherwise you may have a `$PATH` issue or GDAL might not be installed at all. Run the following to check if GDAL is installed for command line usage:
```bash
gdal-config --version
```
This should return 2.2.\* or 2.3.\* (\* meaning anything).
If you are still having issues with GDAL try installing GDAL 2.2 Complete from [KyngChaos](http://www.kyngchaos.com/software/frameworks/).

[https://www.kyngchaos.com/2018/04/06/qgis-3-tools-processing-workaround/](https://www.kyngchaos.com/2018/04/06/qgis-3-tools-processing-workaround/)
If you have any further issues or questions feel free to contact me via email.
