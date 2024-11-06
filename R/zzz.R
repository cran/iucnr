utils::globalVariables(c(
  "iucn_data", "search_name",
  ".", ":=", "core_id", "submitted_name", "vernacular_name",
  "search_name_lower","iucn_2024",
  "threat_status", "vernacular_names",
  "common_name", "internal_taxon_id", "main", "name",
  "redlist_category",
    "scientific_name"
))

# ---------------------------------------------------------------
.pkgenv <- new.env(parent = emptyenv())

.onAttach <- function(lib, pkg) {
  packageStartupMessage("This is iucnr ",
                        utils::packageDescription("iucnr",
                                                  fields = "Version"
                        ),
                        "\nThe iucnr package is compatible with IUCN Red List version 2024-2,\nproviding tools to access and analyze the latest conservation status data.",
                        appendLF = TRUE
  )

  if (!.pkgenv$iucnrdata_available) {
    packageStartupMessage(unavailable_msg())
  }

}

# -------------------------------------------------------------------------

show_progress <- function() {
  isTRUE(getOption("iucnr.show_progress")) && # user disables progress bar
    interactive() # Not actively knitting a document
}



.onLoad <- function(libname, pkgname) {
  opt <- options()
  opt_iucnr <- list(
    iucnr.show_progress = TRUE
  )
  to_set <- !(names(opt_iucnr) %in% names(opt))
  if (any(to_set)) options(opt_iucnr[to_set])
  invisible()
  iucnrdata_available <- requireNamespace("iucnrdata", quietly = TRUE)

  .pkgenv[["iucnrdata_available"]] <- iucnrdata_available
}

# ---------------------------------------------------------------
.iucnr_available <- function() {
  iucnr_available <- requireNamespace("iucnrdata", quietly = TRUE)

  if (!iucnr_available) {
    cli::cli_abort(c(
      "The package {.code iucnrdata} is not installed.",
      "You should either:",
      "*" = "run {.code pak::pak('PaulESantos/iucnrdata')}",
      "*" = "pass a local iucnr using {.var iucn_data}"
    ))
  }
}

#.iucnr_available()
# ---------------------------------------------------------------
.iucnr_fresh <- function() {
  iucnr_fresh <- try(iucnrdata::iucn_check_version(silent=TRUE),
                     silent=TRUE)

  timeout <- FALSE
  #iucnr_fresh
  if (inherits(iucnr_fresh,"try-error")) {
    if (stringr::str_detect(iucnr_fresh[[1]], "Timeout was reached")) {
      timeout <- TRUE
      iucnr_fresh <- TRUE
    } else {
      cli::cli_abort(iucnr_fresh[[1]])
    }
  }

  .pkgenv <- new.env(parent = emptyenv())

  if (rlang::env_has(.pkgenv, "iucnr_fresh")) {
    return(invisible(NULL))
  } else {
    .pkgenv[["iucnr_fresh"]] <- iucnr_fresh
  }

  if (timeout) {
    cli::cli_warn(c(
      "Unable to contact GitHub api repo for iucnrdata ",
      "please check your internet connection and the server site.",
      "Assuming the iucnrdata data you have is up to date for now..."
    )
    )
  }

  if (!iucnr_fresh) {
    msg <- NULL
    withCallingHandlers(
      iucnrdata::iucn_check_version(),
      message = function(m) {
        msg <<- conditionMessage(m)
        tryInvokeRestart("muffleMessage")
      }
    )

    #latest_url <- stringr::str_extract(msg,
    #                                   "(?<=available from )[^\\s]+")
    cli::cli_warn(c(
      "Not using the latest version of iucnrdata.",
      "You should:",
      "*" = "update {.code iucnrdata}"
    ))
  }
}

#.iucnr_fresh()


####
unavailable_msg <- function() {
  options <- c(
    "run `pak::pak('PaulESantos/iucnrdata')`"
  )
  options <- paste0(
    "\t", cli::symbol$bullet, " ", options,
    collapse = "\n"
  )

  paste("The package `iucnrdata` is not installed.",
        "You will need to:",
        options,
        sep = "\n"
  )
}
#unavailable_msg()
