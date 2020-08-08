
# RQGIS3

[![Travis build
status](https://travis-ci.org/jannes-m/RQGIS3.svg?branch=master)](https://travis-ci.org/jannes-m/RQGIS3)
[![CRAN
status](https://www.r-pkg.org/badges/version/RQGIS3)](https://cran.r-project.org/package=RQGIS3)
[![Coverage
status](https://codecov.io/gh/jannes-m/RQGIS3/branch/master/graph/badge.svg)](https://codecov.io/github/jannes-m/RQGIS3?branch=master)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-rqgis-orange.svg)](https://stackoverflow.com/questions/tagged/rqgis)

## Use qgis\_process instead of RQGIS3

From now on, we discourage the usage of **RQGIS3** since it is no longer
actively maintained and due to various unresolvable issues (see also
next section). However, the good new is that there is a new [standalone
executable](https://github.com/qgis/QGIS/pull/34617) available from QGIS
3.14 onwards. This means, one can now run QGIS processing algorithms
from the command line with ease. The tool is easy to use, takes care of
setting the environmental variables to run QGIS and the user no longer
has to use Python. In short, this seems to be the perfect replacement
for **RQGIS3**. Let’s have a look how to use the standalone executable.
Windows users must specify the path to the OSGeo4W Shell in order to run
`qgis_process`, which for now is called `qgis_process-qgis` under
Windows.

``` r
# specify path to OSGeo4W Shell on your system.
# Path depends on where you have installed QGIS 3.14 on your system, hence, you
# might have to adjust the path
os_shell = "C:/OSGEO4~1/OSGeo4W.bat"
# another typical location is:
# os_shell = "C:/Program Files/QGIS 3.14/OSGeo4W.bat"
system2(os_shell, args = "qgis_process-qgis")
```

Windows users please adjust all following commands using the syntax
given in the chunk above. By contrast, UNIX users can simply type:

``` r
system("qgis_process", intern = TRUE)
```

    ## [1] "QGIS Processing Executor - 3.14.1-Pi 'Pi' (3.14.1-Pi)"                                                                                                                       
    ## [2] "Usage: qgis_process [command] [algorithm id or path to model file] [parameters]"                                                                                             
    ## [3] ""                                                                                                                                                                            
    ## [4] "Available commands:"                                                                                                                                                         
    ## [5] "\tplugins\tlist available and active plugins"                                                                                                                                
    ## [6] "\tlist\tlist all available processing algorithms"                                                                                                                            
    ## [7] "\thelp\tshow help for an algorithm. The algorithm id or a path to a model file must be specified."                                                                           
    ## [8] "\trun\truns an algorithm. The algorithm id or a path to a model file and parameter values must be specified. Parameter values are specified via the --PARAMETER=VALUE syntax"

Running `qgis_process` without specifying any parameters lists the
available commands. Let’s have a look at the available geoprocessing
algorithms.

``` r
algs = system("qgis_process list", intern = TRUE)
head(algs, 20)
```

    ##  [1] "Available algorithms"                                   
    ##  [2] ""                                                       
    ##  [3] "QGIS (3D)"                                              
    ##  [4] "\t3d:tessellate\tTessellate"                            
    ##  [5] ""                                                       
    ##  [6] "GDAL"                                                   
    ##  [7] "\tgdal:aspect\tAspect"                                  
    ##  [8] "\tgdal:assignprojection\tAssign projection"             
    ##  [9] "\tgdal:buffervectors\tBuffer vectors"                   
    ## [10] "\tgdal:buildvirtualraster\tBuild virtual raster"        
    ## [11] "\tgdal:buildvirtualvector\tBuild virtual vector"        
    ## [12] "\tgdal:cliprasterbyextent\tClip raster by extent"       
    ## [13] "\tgdal:cliprasterbymasklayer\tClip raster by mask layer"
    ## [14] "\tgdal:clipvectorbyextent\tClip vector by extent"       
    ## [15] "\tgdal:clipvectorbypolygon\tClip vector by mask layer"  
    ## [16] "\tgdal:colorrelief\tColor relief"                       
    ## [17] "\tgdal:contour\tContour"                                
    ## [18] "\tgdal:contour_polygon\tContour Polygons"               
    ## [19] "\tgdal:convertformat\tConvert format"                   
    ## [20] "\tgdal:dissolve\tDissolve"

To test if we can actually process some geodata, let’s try to find the
centroid of a spatial polygon layer. First, we need to know which
centroid algorithms are at our disposal.

``` r
grep("centroid", algs, value = TRUE)
```

    ## [1] "\tnative:centroids\tCentroids"                                                                         
    ## [2] "\tnative:generatepointspixelcentroidsinsidepolygons\tGenerate points (pixel centroids) inside polygons"
    ## [3] "\tqgis:generatepointspixelcentroidsalongline\tGenerate points (pixel centroids) along line"

Let’s use `native:centroids` to find the centroids of the NC dataset.
First, we need to find out which parameters are required by
`native:centroids`.

``` r
system("qgis_process help native:centroids", intern = TRUE)
```

    ##  [1] "Centroids (native:centroids)"                                                                                        
    ##  [2] ""                                                                                                                    
    ##  [3] "----------------"                                                                                                    
    ##  [4] "Description"                                                                                                         
    ##  [5] "----------------"                                                                                                    
    ##  [6] "This algorithm creates a new point layer, with points representing the centroid of the geometries in an input layer."
    ##  [7] ""                                                                                                                    
    ##  [8] "The attributes associated to each point in the output layer are the same ones associated to the original features."  
    ##  [9] ""                                                                                                                    
    ## [10] "----------------"                                                                                                    
    ## [11] "Arguments"                                                                                                           
    ## [12] "----------------"                                                                                                    
    ## [13] ""                                                                                                                    
    ## [14] "INPUT: Input layer"                                                                                                  
    ## [15] "\tArgument type:\tsource"                                                                                            
    ## [16] "\tAcceptable values:"                                                                                                
    ## [17] "\t\t- Path to a vector layer"                                                                                        
    ## [18] "ALL_PARTS: Create centroid for each part"                                                                            
    ## [19] "\tArgument type:\tboolean"                                                                                           
    ## [20] "\tAcceptable values:"                                                                                                
    ## [21] "\t\t- 1 for true/yes"                                                                                                
    ## [22] "\t\t- 0 for false/no"                                                                                                
    ## [23] "OUTPUT: Centroids"                                                                                                   
    ## [24] "\tArgument type:\tsink"                                                                                              
    ## [25] "\tAcceptable values:"                                                                                                
    ## [26] "\t\t- Path for new vector layer"                                                                                     
    ## [27] ""                                                                                                                    
    ## [28] "----------------"                                                                                                    
    ## [29] "Outputs"                                                                                                             
    ## [30] "----------------"                                                                                                    
    ## [31] ""                                                                                                                    
    ## [32] "OUTPUT: <outputVector>"                                                                                              
    ## [33] "\tCentroids"                                                                                                         
    ## [34] ""                                                                                                                    
    ## [35] ""

We have to specify INPUT and OUTPUT.

``` r
nc_path = system.file("shape/nc.shp", package = "sf")
out_path = tempfile(fileext = ".gpkg")
cmd = sprintf("qgis_process run native:centroids --INPUT=%s --OUTPUT=%s",
              nc_path, out_path)
system(cmd, intern = TRUE)
```

    ##  [1] ""                                                                      
    ##  [2] "----------------"                                                      
    ##  [3] "Inputs"                                                                
    ##  [4] "----------------"                                                      
    ##  [5] ""                                                                      
    ##  [6] "INPUT:\t/home/jannes/R/x86_64-pc-linux-gnu-library/4.0/sf/shape/nc.shp"
    ##  [7] "OUTPUT:\t/tmp/Rtmpc3DRJ2/filed8dc688fb520.gpkg"                        
    ##  [8] ""                                                                      
    ##  [9] "0...10...20...30...40...50...60...70...80...90..."                     
    ## [10] "----------------"                                                      
    ## [11] "Results"                                                               
    ## [12] "----------------"                                                      
    ## [13] ""                                                                      
    ## [14] "OUTPUT:\t/tmp/Rtmpc3DRJ2/filed8dc688fb520.gpkg"

It seemed to have worked. To check the output, let us read it in and
plot it.

``` r
library("sf")
library("dplyr")

# read in the data
nc = read_sf(nc_path)
nc_cen = read_sf(out_path)

# first plot nc polygons
st_geometry(nc) %>% plot
# then add the centroids computed by QGIS
st_geometry(nc_cen) %>% plot(pch = 16, col = "red", add = TRUE)
```

![](README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Excellent. We have computed the centroids of the nc polygons using QGIS
via the command line.

## ATTENTION

**RQGIS3 crashes RStudio R session on UNIX-based OS**

Though **RQGIS3** works when running it in a plain R session in the
terminal, it crashes the R session when ran inside RStudio on UNIX-based
OS (see <https://github.com/r-spatial/RQGIS3/issues/10> and
<https://github.com/rstudio/rstudio/issues/4606>). If Linux and MacOS
users would like to use **RQGIS3** in conjunction with RStudio, we
recommend to use the [geocompr docker
image](https://hub.docker.com/r/robinlovelace/geocompr/). Please refer
also to the instructions on the [geocompr landing
page](https://github.com/robinlovelace/geocompr#running-geocompr-code-in-docker)
how to use the docker image. Since **RQGIS3** and RStudio work in
harmony under Windows, a further alternative would be to use a virtual
box running Windows.

## Description

**RQGIS3** establishes an interface between R and QGIS3, i.e., it allows
the user to access QGIS3 functionalities from within R. It achieves this
by establishing a tunnel to the Python QGIS3 API via the
[reticulate-package](https://github.com/rstudio/reticulate). This
provides the user with an extensive suite of GIS functions, since QGIS3
allows you to call native as well as third-party algorithms via its
processing framework (see also
<https://docs.qgis.org/testing/en/docs/user_manual/processing/index.html>).
Third-party providers include among others GDAL, GRASS GIS, and SAGA
GIS. **RQGIS3** brings you this incredibly powerful geoprocessing
environment to the R console.

Please check also out our paper presenting **RQGIS (2)** in detail:

<div style="text-align:center">

<a href = "https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf">https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf</a>

</div>

<p align="center">

<img src="https://raw.githubusercontent.com/jannes-m/RQGIS/master/figures/r_qgis_puzzle.png" width="40%"/>

</p>

The main advantages of **RQGIS3** are:

1.  It provides access to QGIS3 functionalities. Thereby, it calls the
    Python QGIS3 API but R users can stay in their programming
    environment of choice without having to touch Python3.
2.  It offers a broad suite of geoalgorithms making it possible to solve
    most GIS problems.
3.  R users can use just one package (**RQGIS3**) instead of using
    **RSAGA** and **rgrass7** to access SAGA and GRASS functions. This,
    however, does not mean that **RSAGA** and **rgrass7** are obsolete
    since both packages offer various other advantages. For instance,
    **RSAGA** provides many user-friendly and ready-to-use GIS functions
    such as `rsaga.slope.asp.curv()` and `multi.focal.function()`.

## Package installation

In order to run **RQGIS3** properly, you need to download various
third-party software packages. Our vignette should help you with the
download and installation procedures on various platforms (Windows,
Linux, Mac OSX). To access it, use `vignette("install_guide", package =
"RQGIS3")`.

You can install:

<!--
- the latest released version from CRAN with:


```r
install.packages("RQGIS3")
```
-->

  - the latest **RQGIS3** development version from Github with:

<!-- end list -->

``` r
remotes::install_github("jannes-m/RQGIS3")
```

## Usage

Subsequently, we will show you a typical workflow of how to use
**RQGIS3**. Basically, we will follow the steps also described in the
[QGIS
documentation](https://docs.qgis.org/testing/en/docs/user_manual/processing/console.html).
In our first and very simple example we simply would like to retrieve
the centroid coordinates of a spatial polygon object. First, we will
download the administrative areas of Germany using the **raster**
package.

``` r
# attach packages
library("raster")
library("rgdal")

# download German administrative areas 
ger = getData(name = "GADM", country = "DEU", level = 1)
# ger is of class "SpatialPolygonsDataFrame"
```

Now that we have a spatial object, we can move on to using **RQGIS3**.
First of all, we need to specify all the paths necessary to run the
QGIS-API. Fortunately, `set_env()` does this for us (assuming that QGIS
and all necessary dependencies were installed correctly). The only thing
we need to do is: specify the root path to the QGIS-installation. If you
do not specify a path, `set_env()` tries to find the
OSGeo4W-installation first in the ‘C:/OSGeo4W’-folders. If this is
unsuccessful, it will search your C: drive though this might take a
while. If you are running **RQGIS3** under Linux or on a Mac,
`set_env()` assumes that your root path is `/usr` and
`/applications/QGIS.app/Contents`, respectively. Please note, that most
of the **RQGIS3** functions, you are likely to work with (such as
`find_algorithms()`, `get_args_man()` and `run_qgis()`), require the
output list (as returned by `set_env()`) containing the paths to the
various installations necessary to run QGIS3 from within R. This is why,
`set_env()` caches its result in a temporary folder, and loads it back
into R when called again (to overwrite an existing cache, set parameter
`new` to `TRUE`).

``` r
# attach RQGIS3
library("RQGIS3")

# set the environment, i.e. specify all the paths necessary to run QGIS from 
# within R
set_env()
# under Windows set_env would be much faster if you specify the root path:
# set_env("C:/OSGeo4W~1")


## $root
## [1] "C:\\OSGeo4W64"
##
## $qgis_prefix_path
## [1] "C:\\OSGeo4W64\\apps\\qgis"
##
## $python_plugins
## [1] "C:\\OSGeo4W64\\apps\\qgis\\python\\plugins"
```

Next, `open_app()` establishes a tunnel to the Python QGIS3 API which
naturally is the basis of any QGIS3 geoprocessing from within R.

``` r
open_app()
```

Internally, `open_app()` first sets all necessary paths with the help of
`set_env()` (among others the path to the QGIS Python binary) to run
QGIS3, and secondly opens a QGIS3 application with the help of
[reticulate](https://github.com/rstudio/reticulate). `open_app()` is run
automatically by all **RQGIS3** functions that need access to the QGIS3
Python API. \[1\]

Next, we would like to find a QGIS3 geoalgorithm that is able to compute
the centroids of a polygon vector layer. To do so, we use
`find_algorithms()`. Here, we look for a geoalgorithm that contains the
word `centroid` in its short description.  
Note that `search_term` also accepts regular expressions.

``` r
find_algorithms(search_term = "centroid", name_only = TRUE)

#>[1] "native:centroids"
#>[2] "qgis:generatepointspixelcentroidsalongline"     
#>[3] "qgis:generatepointspixelcentroidsinsidepolygons"
#>[4] "saga:polygoncentroids"  
```

This returns four functions we could use. Here, we’ll choose the QGIS3
function named `native:centroids`. Subsequently, we would like to know
how we can use it, i.e., which function parameters we need to specify.

``` r
get_usage(alg = "native:centroids")

#> Centroids (native:centroids)
#> 
#> This algorithm creates a new point layer
#> with points representing the centroid of the geometries in an input layer.
#> 
#> The attributes associated to each point in the output layer are the same ones associated to the original features.
#> 
#> 
#> ----------------
#> Input parameters
#> ----------------
#> 
#> INPUT: Input layer
#> 
#>  Parameter type: QgsProcessingParameterFeatureSource
#> 
#>  Accepted data types:
#>      - str: layer ID
#>      - str: layer name
#>      - str: layer source
#>      - QgsProcessingFeatureSourceDefinition
#>      - QgsProperty
#>      - QgsVectorLayer
#> 
#> ALL_PARTS: Create point on surface for each part
#> 
#>  Parameter type: QgsProcessingParameterBoolean
#> 
#>  Accepted data types:
#>      - bool
#>      - int
#>      - str
#>      - QgsProperty
#> 
#> OUTPUT: Centroids
#> 
#>  Parameter type: QgsProcessingParameterFeatureSink
#>
#>  Accepted data types:
#>      - str: destination vector file
#> e.g. d:/test.shp
#>      - str: memory: to store result in temporary memory layer
#>      - str: using vector provider ID prefix and destination URI
#> e.g. postgres:... to store result in PostGIS table
#>      - QgsProcessingOutputLayerDefinition
#>      - QgsProperty
#> 
#> ----------------
#> Outputs
#> ----------------
#> 
#> OUTPUT:  <QgsProcessingOutputVectorLayer>
#>  Centroids
```

Consequently `native:centroids` only expects a parameter called `INPUT`,
i.e., the path to a spatial polygon file whose centroid coordinates we
wish to extract, and a parameter called `OUTPUT`, i.e., the path to the
output spatial object. Since it would be tedious to specify manually
each and every function argument, especially if a function expects more
than two or three arguments, we have written a convenience function,
named `get_args_man()`, that retrieves all function parameters, and the
respective default values as arguments for a given QGIS geoalgorithm. It
returns these values in the form of a list. If a function argument lets
you choose between several options (drop-down menu in a GUI), setting
`get_arg_man()`’s `options`-argument to `TRUE` makes sure that the first
option will be selected (QGIS GUI behavior). For example,
`qgis:addfieldtoattributestable` has three options for the
`FIELD_TYPE`-parameter, namely integer, float and string. Setting
`options` to `TRUE` means that the field type of your new column will be
of type integer.

``` r
params = get_args_man(alg = "native:centroids")
params
#>$INPUT
#>[1] "None"
#>
#>$ALL_PARTS
#>[1] "False"
#>
#>$OUTPUT
#>[1] "None"
```

In our case, `native:centroids` has only two function arguments and no
default values. Naturally, we need to specify manually our input and
output layer. We can do so in two ways. Either we use directly our
parameter-argument list…

``` r
params$INPUT = ger
params$OUTPUT = file.path(tempdir(), "ger_coords.shp")
out = run_qgis(alg = "native:centroids",
               params = params,
               load_output = TRUE)
#>$OUTPUT
#>[1] "/tmp/RtmpC6SKby/ger_coords.shp"
```

… or we can use R named arguments in `run_qgis()`

``` r
out = run_qgis(alg = "native:centroids",
               INPUT = ger,
               OUTPUT = file.path(tempdir(), "ger_coords.shp"),
               load_output = TRUE)
#>$OUTPUT
#>[1] "/tmp/RtmpC6SKby/ger_coords.shp"
```

Please note that our `INPUT` is a spatial object residing in R’s global
environment. Of course, you can also use a path to specify `INPUT`
(e.g. “ger.shp”) which is the better option if your data is already
somewhere stored on your hard drive. Finally, `run_qgis()` calls the
QGIS API to run the specified geoalgorithm with the corresponding
function arguments. Since we set `load_output` to `TRUE`, `run_qgis()`
automatically loads the QGIS output back into R (`sf`-objects in the
case of vector data and `raster`-objects in the case of raster data).
Naturally, we would like to check if the result meets our expectations.

``` r
# first, plot the federal states of Germany
plot(ger)
# next plot the centroids created by QGIS
plot(out$geometry, pch = 21, add = TRUE, bg = "lightblue", col = "black")
```

<p align="center">

<img src="https://raw.githubusercontent.com/jannes-m/RQGIS/master/https://raw.githubusercontent.com/jannes-m/RQGIS/master/figures/10_plot_ger.png" width="60%"/>

</p>

Of course, this is a very simple example. We could have achieved the
same using `sf::st_as_sf(ger) %>% sf::st_centroid()`. For a more
detailed introduction to **RQGIS3** and more complex examples have a
look at our paper:

<div style="text-align:center">

<a href = "https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf">https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf</a>

</div>

## macOS

The following setup works to execute `find_algorithms()` on macOS
10.14.6 (Mojave).

Installed from `homebrew/osgeo4mac`:

  - osgeo-qgis (v3.8.0)
  - osgeo-gdal (v2.4.1)
  - osgeo-gdal-python (v2.4.1)
  - spatialindex (v1.9.0)
  - <osgeo-proj@5> (soft linked `ln -s
    /usr/local/opt/osgeo-proj/lib/libproj.15.dylib
    /usr/local/opt/osgeo-proj/lib/libproj.13.dylib`)

When running `open_app()` you’ll see a bunch of warnings but you should
be able to run `find_algorithms()`.

The current `osgeo-qgis` formula does not work with gdal v3.0 even
though the latter is the latest version of `osgeo-gdal`.

1.   Please note that the Python tunnel can only be closed by starting a
    new R session (see
    <https://github.com/rstudio/reticulate/issues/27>). On the one hand,
    this means that we only have to set up the Python environment once
    and consequently subsequent processing is faster. Additionally, you
    can use your own Python commands to customize **RQGIS3** as you
    like. On the other hand, it also means that once you have run
    `open_app()` for the first time, you have to stay with the chosen
    QGIS3 (LTR or developer version) and corresponding Python (Python 3)
    version for this session.
