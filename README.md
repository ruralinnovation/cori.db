# Database connection and interaction functions

![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)

Note: _Before installing and using the `cori.db` package, please refer to the [coriverse wiki](https://github.com/ruralinnovation/wiki) for instructions on setting up your local environment to install packages from private Github repositories._

`cori.db` is an internal R package for all things database connection and SQL function related.

It can be installed with (requires `GITHUB_PAT`):

``` r
# install.packages("devtools")
devtools::install_github("ruralinnovation/cori.db")
```

__If you are connecting from a personal computer, your IP address will need to be whitelisted before you will be able to connect. Contact Drew Rosebush or John Hall.__

Before using `cori.db`, you must set the environment variables for our Database (Postgresql hosted in RDS from AWS).

For the database you need: `DATABASE_USER_AD` and `DATABASE_PASSWORD_AD` with the values of your database username and password, respectively, in either a local `.Renviron` file (or your shell's profile i.e. `~/.bash_profile` or `~/.profile`).

## Setting up environment variables for coriverse in RStudio 

### Connecting to the DB with `connect_to_db()`

1. Run `set_db_credentials('user_name_here', 'password_here')` 
2. Restart R
3. Run `Sys.getenv('DATABASE_USER_AD')`. If the above steps were successful, it should return the value of DB_USER you set in Step 1

## Connecting to the database with `connect_to_db()`

So, this is how the functions work...

### With environment variable set up

```r
# connect to schema metadata
con <- connect_to_db("metadata")

# always end scripts by disconnecting from the database!
DBI::dbDisconnect(con)
```

## Setup for Development

Once you have all of the dependencies installed, to build and install this package from the local project directory, run:
```r
pkgbuild::clean_dll(); pkgbuild::compile_dll(); devtools::document(); devtools::check(); devtools::install();
```

## S3 access functions removed from this package

Note: the AWS S3 functions (`get_s3_object()`, `list_s3_objects()`, `list_s3_buckets()`, `put_s3_object()`, `put_s3_objects_recursive()`, `read_s3_object()`, `write_s3_object()`, `set_aws_credentials()`) have moved to the `cori.data` package, where they use local AWS credentials when available and otherwise fall back to temporary, read-only credentials from the CORI credential-vending endpoint.

## Table comparison functions

Note: `compare_dimensions()` and `get_dims()` moved here from `cori.utils` — they compare row/column counts of tables on a database connection, which fits `cori.db`'s DB/SQL scope better than `cori.utils`'s general-purpose utilities.

## Session codebook functions

Note: `write_session_codebook()` moved here from `cori.utils`, joining `load_session_metadata()`, which already lived here. Both are part of the same session-metadata lifecycle: `pull_metadata()` (internal) writes table/field/source metadata to a temp directory as queries run against the database, `load_session_metadata()` reads it back, and `write_session_codebook()` exports it to an Excel file or Google Sheet. Keeping all three together avoids splitting one feature across two packages.
