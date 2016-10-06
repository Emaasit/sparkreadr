spark_remove_table_if_exists <- function(sc, name) {
  if (name %in% src_tbls(sc)) {
    dbRemoveTable(sc, name)
  }
}

spark_read_csv <- function(sc,
                                name,
                                path,
                                options,
                                overwrite = TRUE){
  if(missing(sc)){
    stop("Error! Please provide the spark connection")
  }
  if(missing(path)){
    stop("Error! Please provide the path")
  }
  if(missing(name)){
    stop("Error! Please provide the name of the Spark table where to store the xml file into")
  }
  if (overwrite) spark_remove_table_if_exists(sc, name)

  x <- hive_context(sc) %>%
    invoke("read") %>%
    invoke("format", "com.databricks.spark.csv") %>%
    invoke("option", options) %>%
    invoke("load", path)

  sdf <- sdf_register(x, name = name)
  sdf
}

spark_dependencies <- function(spark_version, scala_version, ...) {
  spark_dependency(
    packages = c(
      sprintf("com.databricks:spark-csv_2.10:2.0.1", scala_version)
    )
  )
}
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
