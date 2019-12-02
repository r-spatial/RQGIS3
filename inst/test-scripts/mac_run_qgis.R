#********************************************************
# Mac ---------------------------------------
#********************************************************

devtools::load_all()

# homebrew ---------------------------------------------------------------------
Sys.setenv(LD_LIBRARY_PATH = "/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents/MacOS/lib/:/Applications/QGIS.app/Contents/Frameworks/")
Sys.setenv(PYTHONPATH = "/usr/local/opt/lib/python3.7/site-packages:/usr/local/opt/osgeo-qgis/lib/python3.7/site-packages:/usr/local/opt/osgeo-qgis/QGIS.app/Contents/Resources/python:/usr/local/opt/osgeo-gdal-python/lib/python3.7/site-packages:$PYTHONPATH")
Sys.setenv(QGIS_PREFIX_PATH = "/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents/MacOS/")

# non-homebrew -----------------------------------------------------------------

# Pythonpath is the problem
# if we take the pythonpath from above, it works
# /usr/local/opt/osgeo-qgis/lib/python3.7/site-packages/ is missing for non-homebrew
# this folder contains the PyQt5 python resources and a link to the qgis processing modules
# Q: Where are the QGIS processing libs??
Sys.setenv(LD_LIBRARY_PATH = "/Applications/QGIS3.4.app/Contents/MacOS/lib:/Applications/QGIS3.4.app/Contents/Frameworks")
Sys.setenv(PYTHONPATH = "/Applications/QGIS3.4.app/Contents/Resources/python:$PYTHONPATH")
Sys.setenv(QGIS_PREFIX_PATH = "/Applications/QGIS3.4.app/Contents/MacOS/")
Sys.setenv(QGIS_DEBUG=-1)

reticulate::use_python("/Applications/QGIS3.4.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3", required = TRUE)

py_run_string("import os, re, sys")
py_run_string("from qgis.core import *")
py_run_string("from osgeo import ogr")
py_run_string("from PyQt5.QtCore import *")
py_run_string("from PyQt5.QtGui import *")
py_run_string("from qgis.gui import *")

py_run_string("sys.path.append(r'/Applications/QGIS3.4.app/Contents/Resources/python/plugins')")
py_run_string("QgsApplication.setPrefixPath(r'/Applications/QGIS3.4.app/Contents/', True)")

# homebrew ---------------------------------------------------------------------
use_python("/usr/local/bin/python3")

py_run_string("sys.path.append(r'/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents/Resources/python/plugins')")
py_run_string("QgsApplication.setPrefixPath(r'/usr/local/Cellar/osgeo-qgis/3.8.0_1/QGIS.app/Contents', True)")

py_eval("QgsApplication.showSettings()")
py_run_string("app = QgsApplication([], True)")

py_run_string("QgsApplication.initQgis()")

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

py_run_string("Grass7Utils.checkGrassIsInstalled()")
py_run_string("g7 = Grass7Utils.isGrassInstalled")
py_run_string("if g7 is True and isMac():
      g7 = Grass7Utils.grassPath()[0:27]
      g7 = os.listdir(g7)
      delim = ';'
      g7 = delim.join(g7)
      g7 = re.findall('[0-9][0-9]', g7)")

