#' Spatial - Exports a data frame object.
#'
#' Exports a data frame object to a specified output.
#'
#' Wrapper for sf::st_write function.
#'
#' @param dfobj Data.frame class R object. Data frame object to export.
#' @param create_dsn Boolean.
#' @param index.unique String. Name of variable(s) in dfobj to make unique
#' index.
#' @param index String. Name of variable(s) in dfobj to make (non-unique)
#' index.
#' dbconnopen Logical. If TRUE, keep database connection open.
#' @param savedata_opts List. See help(savedata_options()) for a list
#' of options.
#' @param dbconn Open database connection.
#' @param dbconnopen Logical. If TRUE, keep database connection open.
#' @return An sf spatial object is written to the out_dsn.
#' @note If out_fmt='shp':\cr The ESRI shapefile driver truncates variable
#' names to 10 characters or less.  Variable names are changed before export
#' using an internal function (trunc10shp). Name changes are output to the
#' outfolder, 'outshpnm'_newnames.csv.
#'
#' If sf object has more than 1 record, it cannot be exported to a shapefile.
#' @author Tracey S. Frescino
#' @keywords data
#' @export datExportData
datExportData <- function(dfobj, 
                          create_dsn = FALSE,
                          index.unique = NULL, 
                          index = NULL, 
                          savedata_opts = savedata_options(),
                          dbconn = NULL,
                          dbconnopen = FALSE
                          ) {
  ###########################################################################
  ## DESCRIPTION: Exports a data.frame to file or database.
  ## out_fmt	Output format ('csv', 'sqlite', 'gpkg', 'shp', 'rda', 'rds', 'llo')
  ## out_dsn	Database file path (including extension or outfolder
  ## out_layer	Only include if out_dsn is a database (e.g., *.db, *.gdb)
  ##			If NULL, basename of out_dsn is used
  ## outfn.pre	Add a prefix to layer name
  ## index.unique String vector or List. A unique index containing one or more 
  ##                 variables in dfobj (e.g., c('PLT_CN', 'CONDID')) or
  ##                 a list of one or more unique indices (if out_fmt = "sqlite").
  ## index  String vector or List. A non-unique index containing one or more 
  ##             variables in dfobj (e.g., c('STATECD', 'UNITCD', 'COUNTYCD', 'PLOT'))
  ##             or a list of one or more non-unique indices (if out_fmt = "sqlite").
  ###########################################################################

  ##################################################################
  ## CHECK INPUT PARAMETERS
  ##################################################################

  ## IF NO ARGUMENTS SPECIFIED, ASSUME GUI=TRUE
  gui <- ifelse(nargs() == 0, TRUE, FALSE)


  ## Check dfobj
  ###########################################################
  if (is.null(dfobj)) {
    dfnm <- select.list(ls(pos=1, all.names=TRUE), title="data frame object?",
		multiple=FALSE)
    dfobj <- get(dfnm)
  }
  if (!"data.frame" %in% class(dfobj)) {
    stop("the object must be of class data frame")
#  } else if ("data.table" %in% class(dfobj)) {
#    dfobj <- setDF(dfobj)
  }

  # Check input parameters
  input.params <- names(as.list(match.call()))[-1]
  formallst <- c(names(formals(datExportData)))
  if (!all(input.params %in% formallst)) {
    miss <- input.params[!input.params %in% formallst]
    stop("invalid parameter: ", toString(miss))
  }

  ## Check parameter lists
  pcheck.params(input.params, savedata_opts=savedata_opts)

  ## Set savedata defaults
  savedata_defaults_list <- formals(savedata_options)[-length(formals(savedata_options))]

  for (i in 1:length(savedata_defaults_list)) {
    assign(names(savedata_defaults_list)[[i]], savedata_defaults_list[[i]])
  }

  ## Set user-supplied savedata values
  if (length(savedata_opts) > 0) {
    for (i in 1:length(savedata_opts)) {
      assign(names(savedata_opts)[[i]], savedata_opts[[i]])
    }
  }
 
  ## Check output data
  outlst <- pcheck.output(out_fmt=out_fmt, outfolder=outfolder,
	out_dsn=out_dsn, overwrite_dsn=overwrite_dsn, overwrite_layer=overwrite_layer,
	outfn.date=outfn.date, add_layer=add_layer, append_layer=append_layer,
	outfn.pre=outfn.pre, out_conn=dbconn, dbconnopen=TRUE)
  out_fmt <- outlst$out_fmt
  out_dsn <- outlst$out_dsn
  outfolder <- outlst$outfolder
  overwrite_layer <- outlst$overwrite_layer
  append_layer <- outlst$append_layer
  out_conn <- outlst$out_conn
 
  ## Check out_layer
  ####################################################
  if (is.null(out_dsn) && is.null(out_layer)) {
    stop("out_layer and out_dsn are NULL")
  }
  if (is.null(out_layer)) {
    out_layer <- basename.NoExt(out_dsn)
  }
  if (!is.null(layer.pre)) {
    out_layer <- paste0(layer.pre, "_", out_layer)
  }


  ## Write data frame
  ########################################################
  if (out_fmt %in% c("sqlite", "gpkg")) {
    gpkg <- ifelse(out_fmt == "gpkg", TRUE, FALSE)
 
    dbconn <- write2sqlite(setDT(dfobj), SQLitefn=out_dsn, 
          out_name=out_layer, gpkg=gpkg,
          overwrite=overwrite_layer, append_layer=append_layer,
          index.unique=index.unique, index=index, createnew=create_dsn, 
          dbconn=out_conn, dbconnopen=TRUE)

  } else if (out_fmt == "gdb") {
     stop("cannot write to a geodatabase")
#    message(out_layer, " written to ", out_dsn)
#    out_dsn <- DBtestESRIgdb(out_dsn, outfolder=outfolder,
#		overwrite=overwrite_dsn, outfn.date=outfn.date, showlist=FALSE)
#    arcgisbinding::arc.write(file.path(out_dsn, out_layer), dfobj,
#			overwrite=overwrite_layer)

  } else if (out_fmt == "csv") {
    write2csv(dfobj, outfolder=outfolder, outfilenm=out_layer,
		outfn.pre=outfn.pre, outfn.date=outfn.date, overwrite=overwrite_layer,
		appendfile=append_layer)

  } else if (out_fmt == "rda") {
    objfn <- getoutfn(outfn=out_layer, outfolder=outfolder, outfn.pre=outfn.pre,
		outfn.date=outfn.date, overwrite=overwrite_layer, ext="rda")
    save(dfobj, file=objfn)
  } else if (out_fmt == "rds") {
    objfn <- getoutfn(outfn=out_layer, outfolder=outfolder, outfn.pre=outfn.pre,
		outfn.date=outfn.date, overwrite=overwrite_layer, ext="rds")
    save(dfobj, file=objfn)
  } else if (out_fmt == "llo") {
    objfn <- getoutfn(outfn=out_layer, outfolder=outfolder, outfn.pre=outfn.pre,
		outfn.date=outfn.date, overwrite=overwrite_layer, ext="llo")
    save(dfobj, file=objfn)
  } else {
    stop(out_fmt, " currently not supported")
  }
 
  if (!is.null(dbconn) && DBI::dbIsValid(dbconn)) {   
    if (!dbconnopen) {
      DBI::dbDisconnect(dbconn)
      return(NULL)
    } else {
      return(dbconn)
    }
  }  
}
