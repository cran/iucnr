## Prueba para la función get_conservation_status
#test_that("get_conservation_status retrieves correct conservation statuses", {
#
#  # Caso 1: Prueba con nombres de especies existentes
#  # Nombres de especies y sus estados de conservación esperados
#  species_1 <- c("Cedrela odorata", "Persea americana")
#  expected_status_1 <- c("Vulnerable", "Least Concern")
#
#  # Ejecutar la función y comparar los resultados con los esperados
#  result_1 <- get_conservation_status(species_1)
#  expect_equal(result_1, expected_status_1)
#
#  # Caso 2: Prueba con especies mixtas (algunas con datos y otras sin coincidencia)
#  species_2 <- c("Panthera uncia", "Lynx lynx", "Ara militaris", "Zonotrichia capencis")
#  expected_status_2 <- c("Vulnerable", "Least Concern", "Vulnerable", "no match found")
#
#  # Ejecutar la función y comparar los resultados con los esperados
#  result_2 <- get_conservation_status(species_2)
#  expect_equal(result_2, expected_status_2)
#
#  # Caso 3: Prueba con especies no encontradas en la base de datos
#  species_3 <- c("Unknown species", "Nonexistent plant")
#  expected_status_3 <- c("no match found", "no match found")
#
#  # Ejecutar la función y comparar los resultados con los esperados
#  result_3 <- get_conservation_status(species_3)
#  expect_equal(result_3, expected_status_3)
#
#  # Caso 4: Prueba con una entrada vacía
#  expect_error(get_conservation_status(character(0)),
#               "Please provide a non-empty character vector of species names.")
#
#  # Caso 5: Prueba con una entrada no válida (NULL)
#  expect_error(get_conservation_status(NULL),
#               "Please provide a non-empty character vector of species names.")
#})
