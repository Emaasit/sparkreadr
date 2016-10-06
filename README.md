Read flat files into Spark DataFrames
=====================================

What is sparkreadr?
-------------------

sparkreadr is an extension for sparklyr to read flat files into Spark
DataFrames. It uses the Spark package spark-csv.

Installation
------------

sparkreadr requires the sparklyr package to run

### Install sparklyr

I recommend the latest stable version of sparklyr available on CRAN

    install.packages("sparklyr")

### Install sparkreadr

Install the development version of sparkreadr from this Github repo
using devtools

    library(devtools)
    devtools::install_github("emaasit/sparkreadr")

Connecting to Spark
-------------------

If Spark is not already installed, use the following sparklyr command to
install your preferred version of Spark:

    library(sparklyr)
    spark_install(version = "2.0.0")

The call to `library(sparkreadr)` will make the sparkreadr functions
available on the R search path and will also ensure that the
dependencies required by the package are included when we connect to
Spark.

    library(sparkreadr) 

We can create a Spark connection as follows:

    sc <- spark_connect(master = "local")

Reading readr files
-------------------

sparkreadr provides the function `spark_read_readr` to read readr data
files into Spark DataFrames. It uses a Spark package called spark-readr.
Here's an example.

    mtcars_file <- system.file("extdata", "mtcars.csv", package = "sparkreadr")

    mtcars_df <- spark_read_csv(sc, path = mtcars_file, table = "readr_table")
    mtcars_df

The resulting pointer to a Spark table can be further used in dplyr
statements.

    library(dplyr)
    mtcars_df %>% group_by(cyl) %>%
      summarise(count = n(), avg.mpg = mean(mpg), avg.displacment = mean(disp), avg.horsepower = mean(hp))

Logs & Disconnect
-----------------

Look at the Spark log from R:

    spark_log(sc, n = 100)

Now we disconnect from Spark:

    spark_disconnect(sc)

Acknowledgements
----------------

Thanks to RStudio for the sparklyr package that provides functionality
to create Extensions.
