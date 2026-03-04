# Lecture 12: Advanced data manipulation: joins, pivoting
Romain Ferrali

``` r
suppressPackageStartupMessages(library(tidyverse))
```

# Joins

Our problem: we have two datasets; one with information about students
(e.g., name, age, grade), and another with information about their test
scores (e.g., name, test score). We want to combine these two datasets
into one dataset that contains all the information about the students
and their test scores.

## Example 1: a one-to-one join

``` r
students <- tibble(
  id = c(1, 2, 3),
  name = c("Alice", "Bob", "Charlie"),
  age = c(20, 21, 22)
)
```

## Example 2: a one-to-many join

``` r
tests <- tibble(
  id = c(1, 1, 2, 2, 3, 3),
  test_score = c(90, 85, 95, 80, 10, 20)
)
```

## Diagnosing problems with joins

``` r
tests <- tibble(
  id = c(1, 3, 3, 4),
  test_score = c(90, 85, 95, 10)
)
```

# Pivoting

There are two formats:

- The long format: each row is an observation, and each column is a
  variable. This is the format that we typically use for data analysis
  and modeling.
- The wide format: each row contains several observations, encoded as
  different columns.

## Pivoting from wide to long format

``` r
wide <- tibble(
  id = c(1, 2, 3),
  name = c("Alice", "Bob", "Charlie"),
  test_1 = c(90, 95, 10),
  test_2 = c(85, 80, 20)
)
```

## Pivoting from long to wide format

``` r
long <- tibble(
  id = c(1, 1, 2, 2, 3, 3),
  name = c("Alice", "Alice", "Bob", "Bob", "Charlie", "Charlie"),
  test = c(1, 2, 1, 2, 1, 2),
  score = c(90, 85, 95, 80, 10, 20)
)
```
