if (FALSE) {
  library("reticulate")
  library("sp")
  library("rgdal")

  # is this the correct way to set the paths???
  # "export PYTHONPATH=/usr/share/qgis/python" "export LD_LIBRARY_PATH=/usr/lib"
  # system("echo $PYTHONPATH")
  # system("export PYTHONPATH=/usr/share/qgis/python")
  # system("export LD_LIBRARY_PATH=/usr/lib")
  # system("echo $LD_LIBRARY_PATH")
  # system("echo $PYTHONPATH")

  # reproducing our batch script cmd.exe (change for MAC!!)
  Sys.setenv(PYTHONPATH = "/usr/share/qgis/python")
  # do not overwrite LD_LIBRARY_PATH but add your path,
  # otherwise RStudio gets problems..
  Sys.setenv(LD_LIBRARY_PATH = paste("/usr/lib", Sys.getenv("LD_LIBRARY_PATH"),
                                     sep = ":"))
  # setting here the QGIS_PREFIX_PATH also works instead of running it twice
  Sys.setenv(QGIS_PREFIX_PATH = "/usr")
  # reproducing our py_cmd.py
  py_run_string("import os, sys")
  py_run_string("from qgis.core import *")
  py_run_string("from osgeo import ogr")
  py_run_string("from PyQt5.QtCore import *")
  py_run_string("from PyQt5.QtGui import *")
  py_run_string("from qgis.gui import *")
  # py_run_string("QgsApplication.setPrefixPath(r'/usr/bin/qgis', True)")
  # it works if we call setPrefixPath two times, once before starting the
  # application and once after having started it... (using /usr instead of
  # /usr/bin/qgis)
  # before running the app both usr/bin/qgis and /usr work
  py_run_string("QgsApplication.setPrefixPath(r'/usr/bin/qgis', True)")  # change for MAC!!
  # py_run_string("QgsApplication.setPrefixPath(r'/usr', True)")
  py_run_string("print QgsApplication.showSettings()")
  py_run_string("app = QgsApplication([], True)")
  # uncomment this line if there is trouble with processing.runalg
  # under Linux this worked
  # py_run_string("app.setPrefixPath('/usr', True)")  # change path for MAC
  py_run_string("print app.showSettings()")
  py_run_string("QgsApplication.initQgis()")
  py_run_string("sys.path.append(r'/usr/share/qgis/python/plugins')")  # change for MAC
  py_run_string("from processing.core.Processing import Processing")
  py_run_string("Processing.initialize()")
  py_run_string("import processing")

  # check if it works
  py_run_string("processing.alglist()")
  py_run_string("processing.algoptions('grass7:r.slope.aspect')")
  py_run_string("processing.alghelp('grass7:r.slope.aspect')")
  # and now check processing.runalg
  coords_1 <-
    matrix(data = c(0, 0, 1, 0, 1, 1, 0, 1, 0, 0),
           ncol = 2, byrow = TRUE)
  coords_2 <- coords_1 + 2
  polys <-
    # convert the coordinates into polygons
    polys <- list(Polygons(list(Polygon(coords_1)), 1),
                  Polygons(list(Polygon(coords_2)), 2))
  polys <- as(SpatialPolygons(polys), "SpatialPolygonsDataFrame")
  writeOGR(polys, dsn = tempdir(), layer = "polys", driver = "ESRI Shapefile")

  inp <- file.path(tempdir(), "polys.shp")
  out <- file.path(tempdir(), "out.shp")
  cmd <- paste(shQuote("qgis:polygoncentroids"), shQuote(inp),
               shQuote(out), sep = ",")
  cmd <- paste0("processing.runalg(", cmd, ")")
  py_run_string(cmd)
  # load output
  out <- readOGR(dsn = tempdir(), layer = "out")
  plot(polys)
  points(out)

  #********************************************************
  # Barry's approach---------------------------------------
  #********************************************************

  # also throws an error message
  # library("reticulate")
  # py_run_string("from qgis.core import *")
  # py_run_string("from qgis.gui import *")
  # py_run_string("sys.path.append('/usr/share/qgis/python/plugins')")
  # py_run_string("from PyQt5.QtCore import *")
  # py_run_string("from PyQt5.QtGui import *")
  # py_run_string("app = QgsApplication([], True)")
  # py_run_string("app.setPrefixPath('/usr', True)")
  # py_run_string("app.initQgis()")
  # py_run_string("from processing.core.Processing import Processing")
  # py_run_string("Processing.initialize()")

  #********************************************************
  # Mac ---------------------------------------
  #********************************************************

  if (Sys.info()["sysname"] == "Darwin") {
    pacman::p_load(sp, RQGIS, reticulate, rgdal)

    library(reticulate)
    use_python("/usr/local/bin/python3")

    Sys.setenv(LD_LIBRARY_PATH = paste("/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents/MacOS/lib/:/Applications/QGIS.app/Contents/Frameworks/"))

    Sys.setenv(PYTHONPATH = "PYTHONPATH=/usr/local/opt/lib/python3.7/site-packages:/usr/local/opt/osgeo-qgis/lib/python3.7/site-packages:/usr/local/opt/osgeo-qgis/QGIS.app/Contents/Resources/python:/usr/local/opt/osgeo-gdal-python/lib/python3.7/site-packages:$PYTHONPATH")

    Sys.setenv(QGIS_PREFIX_PATH = "/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents/MacOS/")
    Sys.setenv(QGIS_DEBUG=-1)

    # reproducing our py_cmd.py
    py_run_string("import os, re, sys")
    py_run_string("from qgis.core import *")
    py_run_string("from osgeo import ogr")
    py_run_string("from PyQt5.QtCore import *")
    py_run_string("from PyQt5.QtGui import *")
    py_run_string("from qgis.gui import *")

    py_run_string("sys.path.append(r'/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents/Resources/python/plugins')")
    py_run_string("QgsApplication.setPrefixPath(r'/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents', True)")

    py_eval("QgsApplication.showSettings()")
    py_run_string("app = QgsApplication([], True)")

    py_run_string("QgsApplication.initQgis()")

    py_run_string("from qgis.core import (QgsSettings,
                       QgsProcessingFeedback,
                       Qgis,
                       QgsMessageLog,
                       QgsApplication,
                       QgsMapLayer,
                       QgsProcessingProvider,
                       QgsProcessingAlgorithm,
                       QgsProcessingException,
                       QgsProcessingParameterDefinition,
                       QgsProcessingParameterEnum,
                       QgsProcessingOutputVectorLayer,
                       QgsProcessingOutputRasterLayer,
                       QgsProcessingOutputMapLayer,
                       QgsProcessingOutputMultipleLayers)")

    py_run_string("from processing.tools.general import algorithmHelp
                   from processing.algs.saga.SagaAlgorithmProvider import SagaAlgorithmProvider
                   from processing.algs.saga import SagaUtils
                   from processing.algs.grass7.Grass7Utils import Grass7Utils
                   from osgeo import gdal
                   from processing.algs.qgis.QgisAlgorithm import QgisAlgorithm
                   from processing.tools.system import isWindows, isMac")

    py_run_string("import processing")
    py_run_string("from processing.core.Processing import Processing")
    py_run_string("Processing.initialize()")

    py_eval("Grass7Utils.checkGrassIsInstalled()")
    py_run_string("g7 = Grass7Utils.isGrassInstalled")
    py_run_string("if g7 is True and isMac():
      g7 = Grass7Utils.grassPath()[0:27]
      g7 = os.listdir(g7)
      delim = ';'
      g7 = delim.join(g7)
      g7 = re.findall('[0-9][0-9]', g7)")
    # check if it works
    py_run_string("processing.alglist()")
    py_run_string("processing.algoptions('grass7:r.slope.aspect')")
    py_run_string("processing.alghelp('grass7:r.slope.aspect')")

    # and now check processing.runalg
    coords_1 <-
      matrix(data = c(0, 0, 1, 0, 1, 1, 0, 1, 0, 0),
             ncol = 2, byrow = TRUE)
    coords_2 <- coords_1 + 2
    polys <-
      # convert the coordinates into polygons
      polys <- list(Polygons(list(Polygon(coords_1)), 1),
                    Polygons(list(Polygon(coords_2)), 2))
    polys <- as(SpatialPolygons(polys), "SpatialPolygonsDataFrame")
    writeOGR(polys, dsn = tempdir(), layer = "polys", driver = "ESRI Shapefile")

    inp <- file.path(tempdir(), "polys.shp")
    out <- file.path(tempdir(), "out.shp")
    cmd <- paste(shQuote("qgis:polygoncentroids"), shQuote(inp),
                 shQuote(out), sep = ",")
    cmd <- paste0("processing.runalg(", cmd, ")")
    py_run_string(cmd)
    # load output
    out <- readOGR(dsn = tempdir(), layer = "out")
    plot(polys)
    points(out)
  }



}
