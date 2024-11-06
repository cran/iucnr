#' Get Conservation Status of Species
#'
#' This function retrieves the conservation status of species from the iucn_data dataset.
#' It is vectorized to handle multiple species names and optimized using data.table for performance.
#'
#' @param splist A character vector of species names to search for in the iucn_data dataset.
#' @return A data.table with species names and their corresponding conservation status or "no match found".
#' @export
#' @examples
#' \donttest{
#' species <- c("Panthera uncia", "Cedrela odorata")
#' result <- get_conservation_status(splist = species)
#' print(result)
#' }
get_conservation_status <- function(splist) {

  cli::cli_h1("Matching names to IUCN species list")
  {
    .iucnr_available()
    .iucnr_fresh()
  }
  # Load data
  data <- iucnrdata::iucn_2024_v2  # Keep as tibble

  # Validate input
  if (missing(splist) || !is.character(splist) || length(splist) == 0) {
    stop("Please provide a non-empty character vector of species names.")
  }

  # Normalize species names to lowercase and trim whitespace
  species_names <- stringr::str_squish(splist) |>
    stringr::str_trim() |>
    stringr::str_to_sentence()

  # Perform the join
  result <-
    dplyr::tibble(scientific_name = species_names) |>
    dplyr::left_join(data, by = "scientific_name") |>
    dplyr::mutate(redlist_category = ifelse(is.na(redlist_category),
                                         "no match found",
                                         redlist_category)) |>
    dplyr::select(scientific_name, redlist_category)

  return(result$redlist_category)  # Return as a tibble
}
