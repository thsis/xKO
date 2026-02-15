path <- here::here("data-raw", "odds.csv")
odds <- read.csv(path)

usethis::use_data(odds, overwrite = TRUE)
