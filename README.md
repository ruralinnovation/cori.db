# Database connection and interaction functions

![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)

Note: _Before installing and using the `cori.db` package, please refer to the [coriverse wiki](https://github.com/ruralinnovation/wiki) for instructions on setting up your local environment to install packages from private Github repositories._

`cori.db` is an internal R package for all things database connection and SQL function related.

__If you are connecting from a personal computer, your IP address will need to be whitelisted before you will be able to connect. Contact Olivier Leroy or John Hall.__

Before using `cori.db`, you must set the environment variables `DATABASE_USER_AD` and `DATABASE_PASSWORD_AD` with the values of your database username and password, respectively, in either a local `.Renviron` file or your shell's profile (i.e. `~/.bash_profile` or `~/.profile`). The instructions in the following section provide a convenient function to do this from within `R`.

## Setting up environment variables for coriverse `connect_to_db()` in RStudio 

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
