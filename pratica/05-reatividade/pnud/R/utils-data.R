conectar_bd <- function() {
  DBI::dbConnect(
    RSQLite::SQLite(),
    system.file("pnud_min.sqlite", package = "pnudSQL")
  )
}

pegar_anos <- function() {
  con <- conectar_bd()
  anos <- dplyr::tbl(con, "pnud") |>
    dplyr::distinct(ano) |>
    dplyr::collect() |>
    dplyr::pull(ano)
  DBI::dbDisconnect(con)
  anos
}
