## code to prepare `pnud` dataset goes here

pnud <- readr::read_rds("data-raw/pnud_min.rds")

usethis::use_data(pnud, overwrite = TRUE)
