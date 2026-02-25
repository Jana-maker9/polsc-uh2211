#' Clean GSS survey data
#'
#' Cleans and derives commonly used variables from a General Social Survey (GSS) dataset.
#'
#' This function performs the following transformations:
#' - Creates a binary "female" indicator: 1 for "FEMALE", 0 for "MALE", NA otherwise.
#' - Cleans "rheight": removes negative values (set to NA) and converts inches to centimeters.
#' - Converts income category "rincome" to numeric midpoints; assigns 25000 to top bin and 1000 to bottom bin.
#' - Keeps only "Black", "White", and "Other" values in "race"; all other values set to NA.
#' - Maps educational categories "educ" to approximate years of education.
#' - Converts age to numeric, setting "89 or older" to 89; non‑numeric or missing values become NA.
#'
#' @param df A data.frame or tibble containing GSS variables. Required columns:
#'   - sex: character/factor with values like "FEMALE", "MALE".
#'   - rheight: numeric recorded height in inches (negative values treated as missing).
#'   - rincome: income category as character/factor (e.g., "$25000 OR MORE", "LT $1000").
#'   - race: character/factor with race categories.
#'   - educ: character/factor describing education categories.
#'   - age: character/factor or numeric; may contain "89 or older".
#'
#' @return A tibble/data.frame with the original columns plus derived/cleaned variables:
#'   - female: integer (1 = female, 0 = male, NA = other/missing).
#'   - height: numeric height in centimeters (NA for invalid/negative input).
#'   - income: numeric estimated income (midpoint of bin, NA if unknown).
#'   - race: character with only "Black", "White", or "Other" preserved; other values set to NA.
#'   - edu: numeric years of education (NA if educ was missing/unrecognized).
#'   - age: numeric age with "89 or older" coerced to 89; non‑numeric values become NA.
#'
#' @details
#' The function intentionally coerces certain character "missing" indicators to NA when converting
#' variables to numeric; R will emit a warning during coercion which can be safely ignored.
#'
#' @examples
#' # Example usage:
#' # cleaned <- clean_gss(gss_df)
#' # dplyr::glimpse(cleaned)
#'
#' @export

clean_gss <- function(df) {
  df |>
    mutate(
      female = case_match(
        sex,
        "FEMALE" ~ 1,
        "MALE" ~ 0,
        .default = NA
      ),
      height = ifelse(rheight < 0, NA, rheight),
      height = height * 2.54,
      income = case_match(
        rincome,
        "$25000 OR MORE" ~ 25000,
        "$20000 - 24999" ~ 22500,
        "$15000 - 19999" ~ 17500,
        "$10000 - 14999" ~ 12500,
        "$8000 TO 9999" ~ 9000,
        "$7000 TO 7999" ~ 7500,
        "$6000 TO 6999" ~ 6500,
        "$5000 TO 5999" ~ 5500,
        "$4000 TO 4999" ~ 4500,
        "$3000 TO 3999" ~ 3500,
        "$1000 TO 2999" ~ 2000,
        "LT $1000" ~ 1000,
        .default = NA
      ),
      race = ifelse(race %in% c("Black", "White", "Other"), race, NA),
      edu = case_match(
        educ,
        "No formal schooling" ~ 0,
        "1st grade" ~ 1,
        "2nd grade" ~ 2,
        "3rd grade" ~ 3,
        "4th grade" ~ 4,
        "5th grade" ~ 5,
        "6th grade" ~ 6,
        "7th grade" ~ 7,
        "8th grade" ~ 8,
        "9th grade" ~ 9,
        "10th grade" ~ 10,
        "11th grade" ~ 11,
        "12th grade" ~ 12,
        "1 year of college" ~ 13,
        "2 years of college" ~ 14,
        "3 years of college" ~ 15,
        "4 years of college" ~ 16,
        "5 years of college" ~ 17,
        "6 years of college" ~ 18,
        "7 years of college" ~ 19,
        "8 or more years of college" ~ 20,
        .default = NA
      ),
      age = ifelse(age == "89 or older", 89, age),
      age = as.numeric(age)
    )
}
