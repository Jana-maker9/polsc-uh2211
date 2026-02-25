clean_gss <- function(df) {
  df |>
    mutate(
      # trun sex into a binary variable that = 1 for female,
      # 0 for male, NA for everything else
      female = case_match(
        sex,
        "FEMALE" ~ 1,
        "MALE" ~ 0,
        .default = NA
      ),
      # remove negative values from height, and convert from inches to cm
      height = ifelse(rheight < 0, NA, rheight),
      height = height * 2.54,
      # turn income bins into a numeric variable by taking the midpoint of each bin
      # for the top bin, we assign it a value of 25000
      # for the bottom bin, we assign it a value of 1000
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
      # race: we keep only the three meaningful categories,
      # and set the rest (missing race, ...) to NA
      race = ifelse(race %in% c("Black", "White", "Other"), race, NA),
      # turn education categories into a numeric variables
      # (i.e., years of education)
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
      # age: we set the top bin to 89, and convert to numeric
      age = ifelse(age == "89 or older", 89, age),
      # converting to numeric will turn "missing" into an NA automatically
      # R will give us a warning when doing this
      # we can ignore the warning, because we actually want the "missing" values to be turned into NAs
      age = as.numeric(age)
    )
}
