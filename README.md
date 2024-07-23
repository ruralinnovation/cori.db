# Database connection, AWS S3 and interaction functions

![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)

Note: _Before installing and using the `cori.db` package, please refer to the [coriverse wiki](https://github.com/ruralinnovation/wiki) for instructions on setting up your local environment to install packages from private Github repositories._

`cori.db` is an internal R package for all things database connection, SQL function related and AWS S3.

It can be installed with (require `GITHUB_PAT`):

``` r
# install.packages("devtools")
devtools::install_github("ruralinnovation/cori.db")
```

__If you are connecting from a personal computer, your IP address will need to be whitelisted before you will be able to connect. Contact Olivier Leroy or John Hall.__

Before using `cori.db`, you must set the environment variables for our Database (Postgresql hosted in RDS from AWS) and accessing S3.

For the database you need: `DATABASE_USER_AD` and `DATABASE_PASSWORD_AD` with the values of your database username and password, respectively, in either a local `.Renviron` file (or your shell's profile i.e. `~/.bash_profile` or `~/.profile`).

On the AWS side you need `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_DEFAULT_REGION` and can get your access get from AWS.

 . The instructions in the following section provide a convenient function to do this from within `R`.

## Setting up environment variables for coriverse  in RStudio 

### Connecting to the DB with `connect_to_db()`

1. Run `set_db_credentials('user_name_here', 'password_here')` 
2. Restart R
3. Run `Sys.getenv('DATABASE_USER_AD')`. If the above steps were successful, it should return the value of DB_USER you set in Step 1

### Setting AWS credentials

1. Run `library(cori.db)` 
2. Run  `set_aws_credentials(keyID = "###", accessKey = "###")` (the region is  set by default) . 
3. Quick test `cori.db:::has_aws_credentials()` should return `TRUE`
4. Restart R or run: `readRenviron("~/.Renviron")`

## Connecting to the database with `connect_to_db()`

So, this is how the functions work...

### With environment variable set up

```r
# connect to schema metadata
con <- connect_to_db("metadata")

# always end scripts by disconnecting from the database!
DBI::dbDisconnect(con)
```

## S3 functions:

S3 interactions is still in a prototype mode, some functions cand their arguments could change as needed.

First you need to list what are our s3 buckets:

```r
list_s3_buckets()
```

You can then ask is inside an s3 buckets:

```r
list_s3_objects(bucket_name = "test-coridata") # argument is the bucket  name
```

To download a file you need to specify (1) its bucket, (2) its key and (optional) where you want to download it:

```r
(get_s3_object("test-coridata", "blabla.txt"))
```

Alternatively if the file is a csv you can read it in your R session:

```r
dbtables <- read_s3_object(bucket_name = "test-coridata", key = "data-1715776270877.csv")
```

**Attention**: it is only working with `.csv`! 


For now (cori.db Version: 0.3.0) sending to an S3 bucket is limited to specific buckets (To be discussed!).

You can either send a file:

```r
put_s3_object("test-coridata", "my_file.qmd", key = "raw_data/my_file.qmd")
```

Here you can see an example of how a fake file hiearchy is implemented in S3 (just prefix with `some_fake_dir/`)

If needed a `data.frame` or a tibble (but not an sf object!) can be directly send as a csv in a bucket:

```r
write_s3_object(bucket_name = "test-coridata", data_frame = cars, key = "raw_data/cars.csv")
```

## Setup for Development

Once you have all of the dependencies installed, to build and install this package from the local project directory, run:
```r
pkgbuild::clean_dll(); pkgbuild::compile_dll(); devtools::document(); devtools::check(); devtools::install();
```
