# Lecture 12: Advanced data manipulation: joins, pivoting
Romain Ferrali

``` r
suppressPackageStartupMessages(library(tidyverse))
```

This lecture is the most important one we will cover on R. Most
everyting else we saw in this course can be done with Excel. This, on
the other hand, is something that is very difficult to do in Excel, and
is one of the main reasons why we use R (or other programming languages)
for data manipulation.

# Joins

Our problem: we have two datasets; one with information about students
(e.g., name, age, grade), and another with information about their test
scores (e.g., name, test score). We want to combine these two datasets
into one dataset that contains all the information about the students
and their test scores.

This is a very common problem in data analysis. The action of comining
two dataets is called a **join**. In other programming languages (e.g.,
Stata), this is also called a **merge**.

## Example 1: a one-to-one join

The notion of one-to-one join is conceptual, rather than technical. It
means that there is a one-to-one relationship between the two datasets.
In other words, each row in one dataset corresponds to exactly one row
in the other dataset. In our example, each student took one test, so
there is a one-to-one relationship between the students and their test
scores.

``` r
students <- tibble(
  id = c(1, 2, 3),
  name = c("Alice", "Bob", "Charlie"),
  age = c(20, 21, 22)
)
```

## Example 2: a one-to-many join

Another type of relationship is a one-to-many relationship. In other
words, each row in one dataset corresponds to multiple rows in the other
dataset. In our example, each student took multiple tests, so there is a
one-to-many relationship between the students and their test scores.
There is a final type of relationship, called many-to-many, but we will
not cover it in this lecture. Technically, whether the relationship is
one-to-one, one-to-many, or many-to-many does not affect how we perform
the join. However, it does affect how we interpret the results of the
join.

``` r
tests <- tibble(
  id = c(1, 1, 2, 2, 3, 3),
  test_score = c(90, 85, 95, 80, 10, 20)
)
```

## Diagnosing problems with joins

There may be problems with the data that prevent us from performing the
join correctly. For example, there may be duplicate rows in one of the
datasets, or there may be missing values. It is important to diagnose
these problems before performing the join, because they can lead to
incorrect results. I like to think about this in the following way:

1.  What is relationship we expect to see between the two datasets?
    (one-to-one, one-to-many, many-to-many)?
2.  Do we expect to see missing data?
3.  How does this translate into
    - the number of rows we expect to see in the joined dataset?
    - the number of rows we expect to see in each group of the joined
      dataset?

``` r
tests <- tibble(
  id = c(1, 3, 3, 4),
  test_score = c(90, 85, 95, 10)
)
```

## Subtelties of joins

### Joining on variables with different names

``` r
tests <- tibble(
  student_id = c(1, 1, 2, 2, 3, 3),
  test_score = c(90, 85, 95, 80, 10, 20)
)
```

### Joining on multiple variables

``` r
students <- tibble(
  id = c(1, 2, 3),
  name = c("Alice", "Bob", "Charlie"),
  age = c(20, 21, 22)
)

tests <- tibble(
  name = c("Alice", "Bob", "Charlie"),
  age = c(20, 21, 22),
  test_score = c(90, 85, 95)
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
