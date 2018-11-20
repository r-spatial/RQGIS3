library("sf")
library("raster")
devtools::load_all()
qgis_env = set_env()
setup_linux()
py_run_string("from pyvirtualdisplay import Display")
py_run_string("display = Display(visible=False, size=(1024, 768), color_depth=24)")
py_run_string("display.start()")
# open_app3()

qgis_session_info()
find_algorithms()
find_algorithms("intersection")
alg = "native:intersection"
get_usage(alg)
get_options(alg)
get_args_man(alg)

coords_1 =
  matrix(data =
           c(0, 0, 1, 0, 1, 1,0, 1, 0, 0),
         ncol = 2, byrow = TRUE)
coords_2 =
  matrix(data =
           c(-0.5, -0.5, 0.5, -0.5, 0.5,
             0.5,-0.5, 0.5, -0.5, -0.5),
         ncol = 2, byrow = TRUE)
poly_1 = st_polygon(list((coords_1))) %>%
  st_sfc %>%
  st_sf
poly_2 = st_polygon(list((coords_2))) %>%
  st_sfc %>%
  st_sf
plot(poly_1$geometry, xlim = c(-1, 1), ylim = c(-1, 1))
plot(poly_2$geometry, add = TRUE)
get_usage(alg)
int = run_qgis(alg, 
         INPUT = poly_1, 
         OVERLAY = poly_2,
         OUTPUT = file.path(tempdir(), "int.shp"),
         load_output = TRUE)
plot(poly_1$geometry, xlim = c(-1, 1), ylim = c(-1, 1))
plot(poly_2$geometry, add = TRUE)
plot(st_geometry(int), add = TRUE, col = "lightblue")

data("dem", package = "RQGIS")
alg = "saga:sagawetnessindex"
get_usage(alg)
get_options(alg)
params = get_args_man(alg)
params$DEM = dem
# .tif is not working under Linux...
params$AREA = file.path(tempdir(), "area.sdat")
params$SLOPE = file.path(tempdir(), "slope.sdat")
params$AREA_MOD = file.path(tempdir(), "area_mod.sdat")
params$TWI = file.path(tempdir(), "twi.sdat")
twi = run_qgis(alg, params = params, load_output = TRUE)
plot(stack(twi))

alg = "grass7:r.slope.aspect"
get_usage(alg)
params = get_args_man(alg)
params$elevation = dem
params$slope = file.path(tempdir(), "slope.tif")
grass = run_qgis(alg, params = params, load_output = TRUE)
plot(grass)
