# Database connection and interaction functions

![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)

Part of the [coriverse](https://github.com/ruralinnovation/wiki)

`cori.db` is an internal R package for all things database connection and SQL function related.

__If you are connecting from a personal computer, your IP address will need to be whitelisted before you will be able to connect. Contact Olivier Leroy or John Hall.__

## Setting up environment variables for coriverse `connect_to_db()` in RStudio 

1. Run `set_db_credentials('user_name_here', 'password_here')` Valid DB user and password information is available in `/data/Github/base/config.yml` on the RStudio Server
2. Restart R
3. Run `Sys.getenv('DB_USER_AD')`. If the above steps were successful, it should return the value of DB_USER you set in Step 1

## Connecting to the database with `connect_to_db()`

So, this is how the functions work...

### With environment variable set up

```r
# connect to schema sch_source
con <- connect_to_db("metadata")

# always end scripts by disconnecting from the database!
DBI::dbDisconnect(con)
```

### Using a config file

```r
# connect to schema sch_metadata
con <- connect_to_db("metadata", config_name = 'db_credentials', config_file = '../base/config.yml')

# always end scripts by disconnecting from the database!
DBI::dbDisconnect(con)
```

## Setup for Development

Once you have all of the dependencies installed, to build and install this package from the local project directory, run:
```r
pkgbuild::clean_dll(); pkgbuild::compile_dll(); devtools::document(); devtools::check(); devtools::install();
```
