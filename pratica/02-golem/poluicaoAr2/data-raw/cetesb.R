## code to prepare `cetesb` dataset goes here

cetesb <- readr::read_rds("data-raw/rds/cetesb.rds")

usethis::use_data(cetesb, overwrite = TRUE)
