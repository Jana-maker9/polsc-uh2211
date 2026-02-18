# Lecture 8-9: advanced linear regression, tables and plots
Romain Ferrali

``` r
library(tidyverse)
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.4     ✔ readr     2.1.6
    ✔ forcats   1.0.1     ✔ stringr   1.6.0
    ✔ ggplot2   4.0.1     ✔ tibble    3.3.1
    ✔ lubridate 1.9.4     ✔ tidyr     1.3.2
    ✔ purrr     1.2.1     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(modelsummary)
library(broom)
library(marginaleffects)
# library(knitr) # we will use only one function from this package, so we can load it separately
df <- read_csv("./data/lecture-7-gss.csv")
```

    Rows: 3544 Columns: 9
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr (6): age, educ, sex, race, rincome, ballot
    dbl (3): year, id_, rheight

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
df <- df |>
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
    race = ifelse(!race %in% c("Black", "White", "Other"), NA, race),
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
  ) |>
  select(age, female, height, income, edu, race)
```

    Warning: There was 1 warning in `mutate()`.
    ℹ In argument: `age = as.numeric(age)`.
    Caused by warning:
    ! NAs introduced by coercion

## Model fit: the R-squared

The $R^2$ is a common measure of model fit for linear regression. It is
the proportion of variance in the outcome variable that is explained by
the model. The $R^2$ can be calculated as:

$$
R^2 = 1 - \frac{SS_{res}}{SS_{tot}}
$$

Where $SS_{res}$ is the sum of squared residuals (so, the sum of
$\epsilon_i^2$’s; i.e., the difference between the observed and
predicted values) and $SS_{tot}$ is the total sum of squares (the
variance of the outcome variable). The $R^2$ ranges from 0 to 1, with
higher values indicating a better fit of the model to the data.

Adding variables to the model will always (weakly) increase the $R^2$,
even if those variables are not actually related to the outcome
variable. In other words, say you estimate model 1, and call its
R-squared $R^2_1$. Add variables to model 1, and call the new model
model 2, and its R-squared $R^2_2$. We have

$$
R^2_2 \geq R^2_1
$$

This is because if a variable doesn’t improve the fit at all, we assign
it a coefficient of 0, and the $R^2$ won’t change. Example:

``` r
df_mini <- df |> select(height, income, female) |> na.omit()
```

To adjust for that, we can use the adjusted $R^2$, which penalizes the
addition of variables to the model. Most people don’t care much about
the adjusted $R^2$.

## Making tables with `modelsummary`

``` r
#|label: basic-tables
```

## Categorical variables

## Linear hypotheses

## Interaction terms
