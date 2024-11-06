#' Retrieve Vernacular Names for a Given Species
#'
#' This function retrieves vernacular (common) names for a given species using IUCN data.
#' It filters vernacular names based on matching `internal_taxon_id` and merges
#' them with species metadata.
#'
#' @param splist A character vector containing the scientific names of species for which vernacular names are to be retrieved.
#'
#' @return A `data.table` or `data.frame` with columns:
#' \describe{
#'   \item{submitted_name}{The scientific name of the species as submitted.}
#'   \item{vernacular_names}{A character string that contains the concatenated vernacular names for each species, separated by " - ".}
#' }
#'
#' @details
#' The function retrieves IUCN data for the input species, extracts the corresponding `core_id`, filters the vernacular name dataset using the `core_id`, and concatenates all unique vernacular names for each species.
#'
#' @examples
#' \donttest{
#' species <- c("Panthera uncia", "Cedrela odorata")
#' result <- get_common_name(splist = species)
#' print(result)
#' }
#'
#' @export
get_common_name <- function(splist) {
  # Validate input
  if (missing(splist) || !is.character(splist) || length(splist) == 0) {
    stop("Please provide a non-empty character vector of species names.")
  }


  normalize_species_names <- function(splist) {

    # Normalize species names: remove extra spaces, trim whitespace, and convert to "Sentence case"
    normalized_names <- stringr::str_squish(splist) |>
      stringr::str_trim() |>
      stringr::str_to_sentence()

    return(normalized_names)
  }
  if (!requireNamespace("iucnrdata", quietly = TRUE)) {
    stop("The 'iucnrdata' package is required for this function.")
  }

  # Normalize species names to lowercase and trim whitespace
  normalized_species <- normalize_species_names(splist)

  # Filter iucn_data for matching species
  result <-
  dplyr::tibble(submitted_name = splist,
                normalized_species = normalized_species) |>
    dplyr::left_join(
      iucnrdata::iucn_2024_v2,
      by = c("normalized_species" = "scientific_name")
    ) |>
    dplyr::select(submitted_name,
                  redlist_category,
                  internal_taxon_id) |>
    dplyr::mutate(
      redlist_category = ifelse(is.na(redlist_category),
                             "no match found",
                             redlist_category)
    )

  # Filter vernacular data for matching core IDs
  common_name_filtered <- iucnrdata::common_names_2024_v2 |>
    dplyr::filter(main == TRUE) |>
    dplyr::filter(internal_taxon_id %in% result$internal_taxon_id)


  # Merge vernacular names back to the main result
  final_result <-
    result |>
    dplyr::left_join(common_name_filtered,
                     by = "internal_taxon_id") |>
    dplyr::select(submitted_name,
                  scientific_name,
                  common_name = name) |>
    dplyr::mutate(common_name = ifelse(is.na(common_name),
                                       "no match found",
                                       common_name),
                  scientific_name = ifelse(is.na(scientific_name),
                                       "no match found",
                                       scientific_name))

  return(final_result)
}
