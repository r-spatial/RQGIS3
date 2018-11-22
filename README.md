
<!-- README.md is generated from README.Rmd. Please edit that file -->
#### General

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.2.0-6666ff.svg)](https://cran.r-project.org/) [![Last-changedate](https://img.shields.io/badge/last%20change-2018--11--22-yellowgreen.svg)](/commits/master)

[![linux=true Status](https://badges.herokuapp.com/travis/jannes-m/RQGIS?branch=master&env=linux=true&label=Linux)](https://travis-ci.org/jannes-m/RQGIS) [![mac=true Status](https://badges.herokuapp.com/travis/jannes-m/RQGIS?branch=master&env=mac=true&label=macOS)](https://travis-ci.org/jannes-m/RQGIS) [![Build status](https://ci.appveyor.com/api/projects/status/ftk03jo1933vm3we/branch/master?svg=true)](https://ci.appveyor.com/project/jannes-m/rqgis/branch/master) <a href="https://codecov.io/gh/jannes-m/RQGIS"><img src="https://codecov.io/gh/jannes-m/RQGIS/branch/master/graph/badge.svg" alt="Coverage Status"/></a>

#### CRAN

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/RQGIS)](http://cran.r-project.org/package=RQGIS) [![Downloads](http://cranlogs.r-pkg.org/badges/RQGIS?color=brightgreen)](http://www.r-pkg.org/pkg/RQGIS) ![](http://cranlogs.r-pkg.org/badges/grand-total/RQGIS)

<!-- C:\OSGeo4W64\bin\python-qgis -> opens Python!!
/usr/share/qgis/python/plugins/processing-->
**RQGIS3** establishes an interface between R and QGIS3, i.e. it allows the user to access QGIS3 functionalities from within R. It achieves this by establishing a tunnel to the Python QGIS API via the [reticulate-package](https://github.com/rstudio/reticulate). This provides the user with an extensive suite of GIS functions, since QGIS allows you to call native as well as third-party algorithms via its processing framework (see also <https://docs.qgis.org/testing/en/docs/user_manual/processing/index.html>). Third-party providers include among others GDAL, GRASS GIS, and SAGA GIS. **RQGIS3** brings you this incredibly powerful geoprocessing environment to the R console.

Please check also out our paper presenting **RQGIS** in detail:

<a href = "https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf">https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf</a>

<p align="center">
<img src="https://raw.githubusercontent.com/jannes-m/RQGIS/master/figures/r_qgis_puzzle.png" width="40%"/>
</p>
The main advantages of **RQGIS3** are:

1.  It provides access to QGIS3 functionalities. Thereby, it calls Python QGIS API but R users can stay in their programming environment of choice without having to touch Python.
2.  It offers a broad suite of geoalgorithms making it possible to solve most GIS problems.
3.  R users can use just one package (**RQGIS3**) instead of using **RSAGA** and **rgrass7** to access SAGA and GRASS functions. This, however, does not mean that **RSAGA** and **rgrass7** are obsolete since both packages offer various other advantages. For instance, **RSAGA** provides many user-friendly and ready-to-use GIS functions such as `rsaga.slope.asp.curv()` and `multi.focal.function()`.

Installation
============

Package installation
--------------------

In order to run **RQGIS3** properly, you need to download various third-party software packages. Our vignette should help you with the download and installation procedures on various platforms (Windows, Linux, Mac OSX). To access it, use `vignette("install_guide", package = "RQGIS3")`.

You can install: <!--
- the latest released version from CRAN with:


```r
install.packages("RQGIS3")
```
--> - the latest RQGIS development version from Github with:

``` r
devtools::install_github("jannes-m/RQGIS3")
```

RQGIS3 usage
============

Subsequently, we will show you a typical workflow of how to use **RQGIS3**. Basically, we will follow the steps also described in the [QGIS documentation](https://docs.qgis.org/testing/en/docs/user_manual/processing/console.html). In our first and very simple example we simply would like to retrieve the centroid coordinates of a spatial polygon object. First off, we will download the administrative areas of Germany using the raster package.

``` r
# attach packages
library("raster")
library("rgdal")

# download German administrative areas 
ger = getData(name = "GADM", country = "DEU", level = 1)
# ger is of class "SpatialPolygonsDataFrame"
```

Now that we have a spatial object, we can move on to using RQGIS. First of all, we need to specify all the paths necessary to run the QGIS-API. Fortunately, `set_env()` does this for us (assuming that QGIS and all necessary dependencies were installed correctly). The only thing we need to do is: specify the root path to the QGIS-installation. If you do not specify a path, `set_env()` tries to find the OSGeo4W-installation first in the 'C:/OSGeo4W'-folders. If this is unsuccessful, it will search your C: drive though this might take a while. If you are running RQGIS under Linux or on a Mac, `set_env()` assumes that your root path is `/usr` and `/applications/QGIS.app/Contents`, respectively. Please note, that most of the RQGIS functions, you are likely to work with (such as `find_algorithms()`, `get_args_man()` and `run_qgis()`), require the output list (as returned by `set_env()`) containing the paths to the various installations necessary to run QGIS from within R. This is why, `set_env()` caches its result in a temporary folder, and loads it back into R when called again (to overwrite an existing cache, set parameter `new` to `TRUE`).

``` r
# attach RQGIS
library("RQGIS")

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

Secondly, we would like to find out how the function in QGIS is called which gives us the centroids of a polygon shapefile. To do so, we use `find_algorithms()`. Here, we look for a geoalgorithm that contain the word `centroid`.
Note that `search_term` accepts also regular expressions.

``` r
library("RQGIS")
find_algorithms(search_term = "centroid")

#> [1] "Centroids-------------------------------------------->native:centroids"
#> [2] "Generate points (pixel centroids) along line--------->qgis:generatepointspixelcentroidsalongline"  
#> [3] "Generate points (pixel centroids) inside polygons---->qgis:generatepointspixelcentroidsinsidepolygons"
#> [4] "Polygon centroids------------------------------------>saga:polygoncentroids"```
```

This returns four functions we could use. Here, we'll choose the QGIS function named `native:centroids`. Subsequently, we would like to know how we can use it, i.e. which function parameters we need to specify.

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

Consequently `native:centroids` only expects a parameter called `INPUT`, i.e. the path to a polygon shapefile whose centroid coordinates we wish to extract, and a parameter called `OUTPUT`, i.e. the path to the output shapefile. Since it would be tedious to specify manually each and every function argument, especially if a function has more than two or three arguments, we have written a convenience function, named `get_args_man()`, that retrieves all function arguments and respective default values for a given GIS function. It returns these values in the form of a list. If a function argument lets you choose between several options (drop-down menu in a GUI), setting `get_arg_man()`'s `options`-argument to `TRUE` makes sure that the first option will be selected (QGIS GUI behavior). For example, `qgis:addfieldtoattributestable` has three options for the `FIELD_TYPE`-parameter, namely integer, float and string. Setting `options` to `TRUE` means that the field type of your new column will be of type integer.

``` r
params = get_args_man(alg = "native:centroids")
params
```

In our case, `native:centroids` has only two function arguments and no default values. Naturally, we need to specify manually our input and output layer. We can do so in two ways. Either we use directly our parameter-argument list...

``` r
params$INPUT = ger
params$OUTPUT = file.path(tempdir(), "ger_coords.shp")
out = run_qgis(alg = "native:centroids",
               params = params,
               load_output = TRUE)
#>$OUTPUT
[#>1] "/tmp/RtmpC6SKby/ger_coords.shp"
```

... or we can use R named arguments in `run_qgis()`

``` r
out = run_qgis(alg = "qgis:polygoncentroids",
               INPUT = ger,
               OUTPUT_LAYER = file.path(tempdir(), "ger_coords.shp"),
               load_output = TRUE)
#>$OUTPUT
#>[1] "/tmp/RtmpC6SKby/ger_coords.shp"
```

Please note that our `INPUT` is a spatial object residing in R's global environment. Of course, you can also use a path to specify `INPUT` (e.g. "ger.shp") which is the better option if your data is somewhere stored on your hard drive. Finally, `run_qgis()` calls the QGIS API to run the specified geoalgorithm with the corresponding function arguments. Since we set `load_output` to `TRUE`, `run_qgis()` automatically loads the QGIS output back into R (an `sf`-object in the case of vector data and a `raster`-object in the case of raster data). Naturally, we would like to check if the result meets our expectations.

``` r
# first, plot the federal states of Germany
plot(ger)
# next plot the centroids created by QGIS
plot(out$geometry, pch = 21, add = TRUE, bg = "lightblue", col = "black")
```

<p align="center">
<img src="https://raw.githubusercontent.com/jannes-m/RQGIS/master/https://raw.githubusercontent.com/jannes-m/RQGIS/master/figures/10_plot_ger.png" width="60%"/>
</p>
Of course, this is a very simple example. We could have achieved the same using `sp::coordinates()`. For a more detailed introduction to **RQGIS** and more complex examples have a look at our paper:

<a href = "https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf">https://rjournal.github.io/archive/2017/RJ-2017-067/RJ-2017-067.pdf</a>

Advanced topics
===============

**Calling the QGIS Python API**

Internally, `open_app()` first sets all necessary paths (among others the path to the QGIS Python binary) to run QGIS, and secondly opens a QGIS application with the help of [reticulate](https://github.com/rstudio/reticulate). Please note that `open_app()` establishes a tunnel to the QGIS Pyton API which can only be closed by starting a new R session (see <https://github.com/rstudio/reticulate/issues/27>). On the one hand, this means that we only have to set up the Python environment once and consequently subsequent processing is faster. Additionally, you can use your own Python commands to customize RQGIS as you wish. On the other hand, it also means that once you have run the first RQGIS command interacting with the QGIS Python API (e.g., `find_algorithms()`, `get_usage()`, etc.), you have to stay with the chosen QGIS version for this session.
