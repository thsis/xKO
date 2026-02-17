path <- here::here("data-raw", "odds.csv")
odds <- read.csv(path) |>
  dplyr::mutate(
    p1 = 1 / decimal_odds_fighter_1,
    p2 = 1 / decimal_odds_fighter_2,
    overround = p1 + p2,
    vig = overround - 1,
    probability_fighter_1_wins = p1 / overround,
    probability_fighter_2_wins = p2 / overround,
  ) |>
  dplyr::select(-p1, -p2, overround)

usethis::use_data(odds, overwrite = TRUE)
