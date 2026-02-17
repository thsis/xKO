library("dplyr")
library("tidyr")
library("stringr")

path <- here::here("data-raw", "fights.csv")
fights.raw <- read.csv(path)


events <- fights.raw |>
  mutate(location = str_remove(location, ".*, ")) |>
  mutate(
    location = replace_values(
      location,
      "The Democratic Republic of The" ~ "Democratic Republic Of The Congo",
      "Turkiye" ~ "Turkey",
      "UK" ~ "United Kingdom",
      "United States" ~ "USA",
      "Ayutthaya" ~ "Thailand",
      "Macao" ~ "China",
      "California" ~ "USA",
      "Yorkshire" ~ "United Kingdom"
    )
  ) |>
  select(
    fight_id,
    fight_title,
    fought_at,
    location,
    scheduled_rounds,
    end_round,
    division_name,
    outcome
  ) |>
  distinct()

fighter_1 <- fights.raw |>
  mutate(
    fighter_1_opponent_height = fighter_2_height_cm,
    fighter_1_opponent_reach = fighter_2_reach_cm,
    fighter_1_opponent_stance = fighter_2_stance
  ) |>
  select(fight_id, contains("fighter_1"), -fighter_1_id) |>
  rename_with(function(x) str_remove(x, "fighter_1_"))


fighter_2 <- fights.raw |>
  mutate(
    fighter_2_opponent_height = fighter_1_height_cm,
    fighter_2_opponent_reach = fighter_1_reach_cm,
    fighter_2_opponent_stance = fighter_1_stance
  ) |>
  select(fight_id, contains("fighter_2"), -fighter_2_id) |>
  rename_with(function(x) str_remove(x, "fighter_2_"))


means <- bind_rows(fighter_1, fighter_2) |>
  group_by(gender) |>
  summarise(
    reach_cm_gender = mean(reach_cm, na.rm = TRUE),
    height_cm_gender = mean(height_cm, na.rm = TRUE),
    .groups = "drop"
  )


fighters <- bind_rows(fighter_1, fighter_2) |>
  left_join(means, by = "gender") |>
  mutate(
    reach_cm = if_else(is.na(reach_cm), reach_cm_gender, reach_cm),
    opponent_reach = if_else(
      is.na(opponent_reach),
      reach_cm_gender,
      opponent_reach
    ),
    height_cm = if_else(is.na(height_cm), height_cm_gender, height_cm),
    opponent_height = if_else(
      is.na(opponent_height),
      height_cm_gender,
      opponent_height
    ),
    reach_diff = reach_cm - opponent_reach,
    height_diff = height_cm - opponent_height
  ) |>
  mutate(
    nationality = replace_values(
      nationality,
      "United States" ~ "USA",
      "U.S. Virgin Islands" ~ "USA",
      "Turkiye" ~ "Turkey",
      "Northern Ireland" ~ "United Kingdom",
      "England" ~ "United Kingdom",
      "Great Britain" ~ "United Kingdom"
    ),
    gender = if_else(gender == "", "male", gender)
  ) |>
  select(-contains("imputed"), -contains("original"), -contains("opponent"))


fights <- events |>
  left_join(fighters, by = "fight_id") |>
  select(-fight_id)


usethis::use_data(fights, overwrite = TRUE)
