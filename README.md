
<!-- README.md is generated from README.Rmd. Please edit that file -->

# iucnr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/iucnr)](https://CRAN.R-project.org/package=iucnr)
[![R-CMD-check](https://github.com/PaulESantos/iucnr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PaulESantos/iucnr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/PaulESantos/iucnr/graph/badge.svg)](https://app.codecov.io/gh/PaulESantos/iucnr)
<!-- badges: end -->

Welcome to the `iucnr` package, a comprehensive tool designed for
researchers and conservationists to access and analyze data from the
**IUCN Red List of Threatened Species**. This package allows users to
retrieve and integrate taxonomic and vernacular name data, empowering
them to conduct thorough assessments of species status and threats. With
a strong emphasis on enhancing biodiversity research, `iucnr` offers a
user-friendly interface for navigating the extensive datasets available
through the Global Biodiversity Information Facility (GBIF).

The `iucnr` package enables access to Red List data on threatened
species without the need for an internet connection, making it a
valuable resource for evaluating the conservation status of various
species. The information is sourced from the GBIF repository
(<https://www.gbif.org/dataset/19491596-35ae-4a91-9a98-85cf505f1bd3>).

While there are other packages available for similar purposes, they
typically require an API key to access the IUCN API, which can be a
barrier for some users.

### Spanish Version

Bienvenido al paquete `iucnr`, una herramienta integral diseñada para
investigadores y conservacionistas que desean acceder y analizar datos
de la Lista Roja de Especies Amenazadas de la IUCN. Este paquete permite
a los usuarios recuperar e integrar datos taxonómicos y nombres
vernáculos, empoderándolos para realizar evaluaciones exhaustivas sobre
el estado y las amenazas a las especies. `iucnr` ofrece una interfaz
amigable para navegar a través de los extensos conjuntos de datos
disponibles a través de la Global Biodiversity Information Facility
(GBIF) de la **Lista Roja de Especies Amenazadas** sin necesidad de
estar conectado a internet, lo que lo convierte en un recurso valioso
para evaluar el estado de conservación de diversas especies. La
información se obtiene del repositorio de GBIF
(<https://www.gbif.org/dataset/19491596-35ae-4a91-9a98-85cf505f1bd3>).

Si bien existen otros paquetes disponibles para objetivos similares,
estos generalmente requieren una clave de API para acceder al API de la
IUCN, lo que puede ser un obstáculo para algunos usuarios.

## Installation

``` r
install.packages("iucnr")
# or
pak::pak("iucnr")
```

Also you can install the `iucnr` package from GitHub using the following
command:

``` r
pak::pak("PaulESantos/iucnr")
```

# Example

- Define a vector of species names

``` r
species_names <- c("Panthera uncia", "Lynx lynx", "Ara militaris", "Zonotrichia capencis")
```

- Example usage of the get_conservation_status function This retrieves
  the conservation status for the specified species

``` r
library(iucnr)
#> This is iucnr 0.0.0.1
#> The iucnr package is compatible with IUCN Red List version 2024-1,
#> providing tools to access and analyze the latest conservation status data.

conservation_status <- get_conservation_status(splist = species_names)
conservation_status
#> [1] "Vulnerable"     "Least Concern"  "Vulnerable"     "no match found"
```

- Example usage of the get_conservation_status function within a tibble
  This creates a tibble and adds a new column with the conservation
  status of each species

``` r
species_data <- tibble::tibble(splist = species_names) |> 
  dplyr::mutate(iucn = get_conservation_status(splist))
species_data
#> # A tibble: 4 × 2
#>   splist               iucn          
#>   <chr>                <chr>         
#> 1 Panthera uncia       Vulnerable    
#> 2 Lynx lynx            Least Concern 
#> 3 Ara militaris        Vulnerable    
#> 4 Zonotrichia capencis no match found
```

- Example usage of the get_vernacular_name function This retrieves the
  vernacular names for the specified species

``` r
vernacular_names_result <- get_vernacular_name(splist = species_names)
vernacular_names_result
#>         submitted_name
#> 1       Panthera uncia
#> 2            Lynx lynx
#> 3        Ara militaris
#> 4 Zonotrichia capencis
#>                                                                                                                                                                                                                            vernacular_names
#> 1 Léopard des neiges - Irvis - Ilbirs - Snow Leopard - Hiun chituwa - Pantera de la Nieves - Akilbirs - Sah - Babri barfi - Baral he - Snezhniy bars - Xue bào - Barfani chita - Schneeleopard - Ounce - Irbis - Once - Panthère des neiges
#> 2                                                                                                                                               Lynx - Evroasiin Shiluus - Eurasian Lynx - Lince - Shiluus Mii - Lince Boreal - Lynx Boréal
#> 3                                                                                                                                                                    Guacamaya Verde - Guacamayo Militar - Military Macaw - Guacamayo Verde
#> 4                                                                                                                                                                                                                            no match found
```

### Citation

- IUCN (2022). The IUCN Red List of Threatened Species. Version 2022-2.
  <https://www.iucnredlist.org>. Downloaded on 2023-05-09.
  <https://doi.org/10.15468/0qnb58> accessed via GBIF.org on 2023-11-17.
  accessed via GBIF.org on 2024-10-08.

- IUCN. 2024. The IUCN Red List of Threatened Species. Version 2024-1.
  <https://www.iucnredlist.org>.
