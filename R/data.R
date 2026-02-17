#' Boxing Fight Data
#' @format ## `fights`
#'
"fights"

#' Historical Boxing Odds
#' @format ## `odds`
#' A data frame containing winning odds for different fights with different bookmakers with 4162
#' rows and 16 columns:
#' \describe{
#'     \item{source}{Original Url}
#'     \item{scheduled_at}{Scheduled time of the fight}
#'     \item{fighter_1_name, fighter_2_name}{Names of the athletes}
#'     \item{division_name}{Name of Division}
#'     \item{gender}{Gender of Athletes}
#'     \item{event_title}{Event Title}
#'     \item{fight_title}{Fight Title}
#'     \item{location}{Location}
#'     \item{bookmaker}{Bookmaker}
#'     \item{decimal_odds_fighter_1, decimal_odds_fighter_2}{Winning odds for each athlete}
#'     \item{is_fighter_1_winner, is_fighter_2_winner, is_draw}{
#'         either \code{TRUE} or \code{FALSE} indicating which athlete won the fight or if it ended
#'         in a draw}
#'     \item{bet_type}{Type of bet}
#' }
"odds"
