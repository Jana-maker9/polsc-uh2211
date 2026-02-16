# Lecture 7: linear regression
Romain Ferrali

Today, we’re going to talk about linear regression, which is a
statistical method for modeling the relationship between a dependent
variable and one or more independent variables. It’s a powerful tool for
understanding how different factors affect an outcome, and it’s widely
used in many fields, including economics, psychology, and of course,
sports analytics. Linear regression builds upon the concepts we have
seen (p-value, confidence interval), and subsumes some of the tests we
have seen; specifically, the t-test.

Our goal: have a simpler answer to our question: did soccer get less
exciting over time?

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
df <- read_csv("./data/lecture-1-england.csv")
```

    New names:
    Rows: 203956 Columns: 13
    ── Column specification
    ──────────────────────────────────────────────────────── Delimiter: "," chr
    (5): home, visitor, FT, division, result dbl (7): ...1, Season, hgoal, vgoal,
    tier, totgoal, goaldif date (1): Date
    ℹ Use `spec()` to retrieve the full column specification for this data. ℹ
    Specify the column types or set `show_col_types = FALSE` to quiet this message.
    • `` -> `...1`

``` r
# some housekeeping: let's turn all the column names into lowercase
colnames(df) <- tolower(colnames(df))
```

## Linear regression: the basics

Linear regression models the relationship between a dependent variable
(y) and one or more independent variables (x) by fitting a linear
equation to the observed data. The simplest form of linear regression
has only one independent variable. In other words, you want to
**estimate** the **parameters** $\alpha$ and $\beta$ in the equation:

$$
y_i = \underbrace{\alpha}_{\text{intercept}} + \underbrace{\beta}_{\text{slope}} x_i + \epsilon_i, 
$$

where

- each $i$ is an **observation** in your data (i.e., a row in your data
  frame),
- $x_i$ is the **independent variable** (you can also call it the
  **predictor**. You can have more than one independent variable, but
  we’ll stick to one for now),
- $y_i$ is the **dependent variable** (the outcome you’re trying to
  predict). It’s called “dependent” because its value *depends* on the
  value of $x_i$.
- $\alpha$, $\beta$ are the **parameters** of the model that we want to
  estimate. Parameter $\alpha$ is called the **intercept**; it
  represents the expected value of $y$ when $x$ is zero. Parameter
  $\beta$ is called the **slope**; it represents the change in $y$ for a
  one-unit change in $x$.
- $\epsilon_i$ is the **error term** that captures the variability in
  $y$ that is not explained by $x$

How do we obtain the **best** fit line? By minimizing the sum of squared
errors; i.e., minimizing the distance between the observed values and
the line. What is the distance between the observed values and the line?
You can think of that distance as the **error** you make between your
**prediction** and the observed data.

$$
\underbrace{y_i}_{\text{observation}} - \underbrace{(\alpha + \beta x_i)}_{\text{prediction}} = \epsilon_i
$$

Because we don’t care about whether our error is positive or negative,
we square it to get rid of the negative signs. So we want to pick
$\alpha$ and $\beta$ that minimize:

$$
\min_{\alpha, \beta} \sum_i (y_i - (\alpha + \beta x_i))^2 = \sum_i \epsilon_i^2
$$

So really, we minimize the sum of squared errors. This is called the
**least squares** method, and it gives us the best fit line. This is why
you sometimes call linear regression “Ordinary Least Squares
regression”, or OLS.

Notice that we can still leverage the Central Limit Theorem to make
inferences about our parameters $\alpha$ and $\beta$. So we can get
p-values and confidence intervals. Let’s put this in practice:

``` r
# estimate a linear regression model with
# - season as the independent variable (x)
# - total goals as the dependent variable (y)

# the lm() function stands for "linear model"
# the "totgoal ~ season" is called the formula.
# it means "totgoal is the dependent variable, and season is the independent variable"

# here, we store the model, because we'll use it later
mod <- lm(totgoal ~ season, data = df)

# first, let's take a quick look at it:
# this shows basic information; just the formula and the coefficients
mod
```


    Call:
    lm(formula = totgoal ~ season, data = df)

    Coefficients:
    (Intercept)       season  
      17.005763    -0.007185  

``` r
# the summary() function gives us more information about the model, in particular:
summary(mod)
```


    Call:
    lm(formula = totgoal ~ season, data = df)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -3.4397 -1.2529 -0.1451  1.1207 13.8980 

    Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 17.0057629  0.2327471   73.06   <2e-16 ***
    season      -0.0071854  0.0001182  -60.77   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 1.791 on 203954 degrees of freedom
    Multiple R-squared:  0.01779,   Adjusted R-squared:  0.01778 
    F-statistic:  3693 on 1 and 203954 DF,  p-value: < 2.2e-16

``` r
# the Coefficients table gives us:
# - the value of each coefficient (Estimate column)
# - the standard error of each coefficient (Std. Error column)
# - the t-value of each coefficient, derived from std. error (t value column)
# (it's the test statistic for the null hypothesis that the coefficient is zero)
# - the p-value of each coefficient (Pr(>|t|) column):
#  the probability of observing a coefficient as extreme as the one we observed,
# if the null hypothesis were true (i.e., if the coefficient were actually zero)
# - the stars next to the p-values indicate the level of statistical significance:
#   - '***' for p < 0.001 (so, siginificant at the 0.1% level, i.e., we're 99.9% confident that the coefficient is not zero)
#   - '**' for p < 0.01 (so, siginificant at the 1% level, i.e., we're 99% confident that the coefficient is not zero)
#   - '*' for p < 0.05 (so, siginificant at the 5% level, i.e., we're 95% confident that the coefficient is not zero)

# below, the R-Squared numbers give us a sense of model fit:
# how well the model approximates the data. It's a number between 0 and 1. 0 = horrible fit; 1 = perfect fit
# here, the R-squared is 0.01. So, we explain 1% of the variance in total goals (y). Not great at all
```

``` r
# we can also get confidence intervals for our coefficients using the confint() function

confint(mod)
```

                       2.5 %       97.5 %
    (Intercept) 16.549584174 17.461941650
    season      -0.007417143 -0.006953657

``` r
# the 95% confidence interval for the season coefficient doesn't include 0
# this is consistent with the p-value we got before
# this is not by chance: confidence intervals and p-values are
# different ways of displaying the same information about statistical significance.
```

We can also fairly easily visualize this relationship by plotting the
data and the fitted line.

``` r
ggplot(df, aes(x = season, y = totgoal)) +
  # plot the points but add a little random noise to avoid plotting points
  # on top of each other (because there are many matches in the same season, so they have the same x value)
  # and add a lot of transparency to see the density of points
  geom_jitter(alpha = 0.01) +
  # then, add the best fit line automatically, using the geom_smooth() function
  # we set method = "lm" to use the lm() function to get a line
  # se = FALSE to not plot the confidence interval around the line
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Season", y = "Total Goals", title = "Total Goals Over Time")
```

    `geom_smooth()` using formula = 'y ~ x'

![](lecture-7_files/figure-commonmark/linear%20regression%20plot-1.png)

## Where does that best fit line come from? OLS as a conditional mean estimator

**When the independent variable ($x_i$) is binary, the best fit is
really the average.** It is quite intuitive: if you want to predict a
quantity, your best bet is to set the prediction is its average value
and attribute everything else to noise. Let’s see this in practice,
looking at home and away games. Now we estimate the following model:

$$
\text{goals}_i = \alpha + \beta \text{hometeam}_i + \epsilon_i
$$

The variable $\text{hometeam}_i$ is a binary variable that takes the
value 1 if the match was played at home, and 0 if it was played away.
So, $\alpha$ is the average score of a visiting team, while
$\alpha + \beta$ is the average score of a home team. The coefficient
$\beta$ captures the **difference** in goals scored between home and
away games.

``` r
# we need to transform our data:
# before, 1 row = 1 game, with two columns for goals (home and away)
# now, we want 1 row = 1 team in a game, with one column for goals and one column for home/away
df_hometeam <- df |>
  select(hgoal, vgoal) |>
  # use this column to make the data longer
  # i.e.: instead of 1 row = 1 game, we have 2 rows = 1 game (one for the home team, one for the away team)
  pivot_longer(everything()) |>
  # create a new variable that is 1 if the team is the home team, and 0 if it's the away team
  mutate(hometeam = as.integer(name == "hgoal")) |>
  rename(score = value)

# here is our regression:
lm(score ~ hometeam, data = df_hometeam) |>
  summary()
```


    Call:
    lm(formula = score ~ hometeam, data = df_hometeam)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -1.7468 -1.1168 -0.1168  0.8832 11.2532 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 1.116780   0.002822   395.8   <2e-16 ***
    hometeam    0.630008   0.003991   157.9   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 1.274 on 407910 degrees of freedom
    Multiple R-squared:  0.05759,   Adjusted R-squared:  0.05758 
    F-statistic: 2.492e+04 on 1 and 407910 DF,  p-value: < 2.2e-16

``` r
# notice that beta = 0.63: playing at home gives you, on average 0.63 more goals than playing at home
# the coefficient is significant at the 0.1% level,
# so we're 99.9% confident 0.63 is not zero.

# here are the means
df_hometeam |>
  group_by(hometeam) |>
  summarize(mean_score = mean(score))
```

    # A tibble: 2 × 2
      hometeam mean_score
         <int>      <dbl>
    1        0       1.12
    2        1       1.75

``` r
# notice how
# - alpha = mean score for away games (hometeam = 0)
# - alpha + beta = mean score for home games (hometeam = 1)
# this isn't a coincidence: the best fit line is really just
# the average of the dependent variable for each value of the
# independent variable.
```

So the best fit line is really just the average of the dependent
variable for each value of the independent variable. In other words, the
best fit is the mean $y$ conditional on $x$ taking a specific value.
This is why we call linear regression a **conditional mean estimator**:
it estimates the mean of $y$ conditional on $x$. Here, we get the mean
number of goals scored conditional on playing at home (`hometeam = 1`)
and conditional on playing as a visitor (`hometeam = 0`).

This generalizes to continuous independent variables. Consider our
example of goals scored ($y$) over time ($x$). The conditional mean is
the mean number of goals in a given season. We can represent that as a
series of points: each point is the mean number of goals in a given
season. The best fit line summarizes all these points into a line.

``` r
# get the average number of goals per season
pl <- df |> group_by(season) |> summarize(goals = mean(totgoal))

ggplot(pl, aes(x = season, y = goals)) +
  # plot the average number of goals per season as points
  geom_point() +
  # plot the best fit line from the linear regression model we estimated before
  # remember that the model used the whole data set, not just the averages, to estimate the coefficients
  # see: the line fits really well those averages.
  # so the line is really a summary of the conditional means (the points) across all seasons
  geom_abline(intercept = coef(mod)[1], slope = coef(mod)[2], color = "red")
```

![](lecture-7_files/figure-commonmark/linear%20regression%20with%20continuous%20independent%20variable-1.png)

``` r
# R programming aside: you can use the coef() function
# to get the coefficients of a linear model, as a numeric vector
coef(mod) # get all the coefficients
```

    (Intercept)      season 
     17.0057629  -0.0071854 

``` r
coef(mod)[2] # get the slope (beta)
```

        season 
    -0.0071854 

``` r
# you can also use the name of the variable to get the coefficient,
# which is more robust to changes in the model (e.g., if you add
# more variables, the position of the coefficients might change, but their names won't)
coef(mod)["season"]
```

        season 
    -0.0071854 

## Linear regression with multiple independent variables

We can also have more than one independent variable. In that case, the
model looks like this: $$
y_i = \alpha + \beta_1 x_{1i} + \beta_2 x_{2i} + \ldots + \epsilon_i
$$

Let’s combine home/away and season to see how they jointly affect the
number of goals scored in a match.

``` r
df_multiple <- df |>
  select(season, hgoal, vgoal) |>
  pivot_longer(c(hgoal, vgoal)) |>
  mutate(hometeam = as.integer(name == "hgoal")) |>
  rename(score = value)

# let's take a look at the data
df_multiple
```

    # A tibble: 407,912 × 4
       season name  score hometeam
        <dbl> <chr> <dbl>    <int>
     1   1888 hgoal     3        1
     2   1888 vgoal     6        0
     3   1888 hgoal     2        1
     4   1888 vgoal     1        0
     5   1888 hgoal     5        1
     6   1888 vgoal     2        0
     7   1888 hgoal     0        1
     8   1888 vgoal     2        0
     9   1888 hgoal     1        1
    10   1888 vgoal     1        0
    # ℹ 407,902 more rows

``` r
# and now, let's estimate the model
mod_multiple <- lm(score ~ season + hometeam, data = df_multiple)
summary(mod_multiple)
```


    Call:
    lm(formula = score ~ season + hometeam, data = df_multiple)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -2.0349 -0.9702 -0.1210  0.8215 11.1735 

    Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  8.188e+00  1.166e-01   70.22   <2e-16 ***
    season      -3.593e-03  5.922e-05  -60.66   <2e-16 ***
    hometeam     6.300e-01  3.973e-03  158.59   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 1.269 on 407909 degrees of freedom
    Multiple R-squared:  0.06601,   Adjusted R-squared:  0.06601 
    F-statistic: 1.441e+04 on 2 and 407909 DF,  p-value: < 2.2e-16

``` r
# we find the same results as before:
# - the coefficient for season is negative and significant, so goals have decreased over time
# - the coefficient for hometeam is positive and significant, so playing at home gives you an advantage
```

Linear regressions with multiple variables can become quite complicated,
and you can leverage them to get predictions. For example, we can use
the model we just estimated to predict the average number of goals in a
match in the 1888 season (the first season of the English league) and in
the 2020 season (the most recent season).

``` r
# predictions
predict(
  mod_multiple,
  newdata = data.frame(
    season = c(1888, 2020),
    hometeam = c(0, 1)
  )
)
```

           1        2 
    1.404860 1.560632 

``` r
# notice that the predicted number of goals in 1888 is lower than in 2020
# this is because the home team advantage is larger than the compounded decrease in goals over time.
# that's where predictions become interesting: they allow you to combine effects of multiple variables
# it's up to you to pick the comparisons wisely so as to get interesting insights.
```

``` r
# pro tip: you can get confidence intervals around your predictions
# using the predict() function with the argument interval = "confidence"

predict(
  mod_multiple,
  newdata = data.frame(
    season = c(1888, 2020),
    hometeam = c(0, 1)
  ),
  interval = "confidence"
)
```

           fit      lwr      upr
    1 1.404860 1.394046 1.415674
    2 1.560632 1.552478 1.568786

``` r
# the predicted number of goals in 1880, not hometeam is
# significantly lower than the predicted number of goals in 2020, hometeam
# since the confidence intervals don't overlap.
```

## What if my data is not linear? A word

Sometimes, your data isn’t linear. Let’s simulate some data that has a
non-linear relationship between $x$ and $y$. We will generate data such
that $y = x^2$ and add some noise :

``` r
# draw 1000 random numbers between -1 and 1
x <- runif(1e3, -1, 1)
y <- x^2 + rnorm(1e3, 0, 0.1) # add some noise

df_non_linear <- tibble(x = x, y = y)

# plot the data
ggplot(df_non_linear, aes(x = x, y = y)) +
  geom_point(alpha = .1) +
  labs(title = "Non-linear data")
```

![](lecture-7_files/figure-commonmark/non-linear%20data-1.png)

In this case, a linear regression would not capture the relationship
between $x$ and $y$ well. See for yourself:

``` r
ggplot(df_non_linear, aes(x = x, y = y)) +
  geom_point(alpha = .1) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Linear regression on non-linear data")
```

    `geom_smooth()` using formula = 'y ~ x'

![](lecture-7_files/figure-commonmark/linear%20regression%20on%20non-linear%20data-1.png)

We get a line that’s quite flat. This is because the linear regression
is trying to fit a line to data that has a non-linear relationship.
There are two ways to look at this:

1.  This is a bad fit
2.  The overall average effect of $x$ on $y$ is zero, because the
    positive effects of $x$ on $y$ when $x$ is positive are balanced out
    by the negative effects of $x$ on $y$ when $x$ is negative.

There are two main ways to capture the non-linear relationship between
$x$ and $y$:

1.  Turn your linear regression into a non-linear regression by adding
    terms that represent the non-linear relationship. For example, you
    can add a quadratic term to capture the $x^2$ relationship.
2.  Fit separate regressions for different ranges of $x$. For example,
    you can fit one regression for $x < 0$ and another regression for
    $x > 0$.

``` r
# the non-linear regression approach

df_non_linear <- df_non_linear |>
  # add a new variable that is the square of x
  mutate(x_squared = x^2)

# run regression with both x and x_squared as independent variables
lm(y ~ x + x_squared, data = df_non_linear) |>
  summary()
```


    Call:
    lm(formula = y ~ x + x_squared, data = df_non_linear)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -0.31042 -0.06842  0.00090  0.06923  0.33492 

    Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  0.003118   0.004856   0.642    0.521    
    x           -0.000493   0.005720  -0.086    0.931    
    x_squared    1.000884   0.010951  91.395   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 0.1034 on 997 degrees of freedom
    Multiple R-squared:  0.8937,    Adjusted R-squared:  0.8935 
    F-statistic:  4190 on 2 and 997 DF,  p-value: < 2.2e-16

``` r
# we find that the term on x is very close to 0 (and not significant)
# conversely, the term on x_squared is positive and significant
# this is as expected, since our data was generated by y = x^2 + noise
# so really, y = 0 * x + 1 * x^2 + noise
```

``` r
# the piecewise regression approach

# fit a regression for x < 0
mod_left <- lm(y ~ x, data = df_non_linear |> filter(x < 0))

# fit a regression for x > 0
mod_right <- lm(y ~ x, data = df_non_linear |> filter(x > 0))

# plot the data with the two regression lines
ggplot(df_non_linear, aes(x = x, y = y)) +
  geom_point(alpha = .1) +
  geom_abline(
    intercept = coef(mod_left)[1],
    slope = coef(mod_left)[2],
    color = "blue"
  ) +
  geom_abline(
    intercept = coef(mod_right)[1],
    slope = coef(mod_right)[2],
    color = "red"
  ) +
  labs(title = "Piecewise regression on non-linear data")
```

![](lecture-7_files/figure-commonmark/piecewise%20regression-1.png)

## A word on correlation vs. causation

I will show you that, on average, taller people earn more money than
shorter people.

``` r
# data cleaning
gss <- read_csv("./data/lecture-7-gss.csv") |>
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
    )
  ) |>
  select(female, height, income) |>
  na.omit()
```

    Rows: 3544 Columns: 6
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr (3): sex, rincome, ballot
    dbl (3): year, id_, rheight

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
lm(income ~ height, data = gss) |>
  summary()
```


    Call:
    lm(formula = income ~ height, data = gss)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -21497.0    541.9   3041.9   4119.6   6005.6 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  3097.96    4568.91   0.678    0.498    
    height        106.08      26.68   3.976 7.84e-05 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 6957 on 620 degrees of freedom
    Multiple R-squared:  0.02486,   Adjusted R-squared:  0.02329 
    F-statistic: 15.81 on 1 and 620 DF,  p-value: 7.841e-05

``` r
# on average, being 1cm taller is associated with earning $106 more per year.
# This is a positive and significant association
```

Why? An important reason is that men tend to be taller than women. In
statistical language, we say that **height is correlated with gender.**
Correlation is not causation: height is correlated with income, but
that’s because gender causes both height and income. In other words,
being taller does not cause you to earn more money; rather, being male
causes you to be taller and to earn more money. So, the relationship
between height and income is spurious: it’s driven by a third variable
(gender) that causes both height and income.

``` r
lm(income ~ height + female, data = gss) |>
  summary()
```


    Call:
    lm(formula = income ~ height + female, data = gss)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -21532.8    451.7   2951.7   4245.1   5940.7 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)   
    (Intercept)  5092.06    6586.10   0.773  0.43973   
    height         95.37      36.89   2.585  0.00996 **
    female       -324.49     771.42  -0.421  0.67417   
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 6962 on 619 degrees of freedom
    Multiple R-squared:  0.02514,   Adjusted R-squared:  0.02199 
    F-statistic: 7.981 on 2 and 619 DF,  p-value: 0.0003781

When we run another regression that includes both height and gender (a
variable that = 1 for being female and 0 for being male), we find that
being female is associated with earning \$325 less per year than men on
average (although the relationship is not significant). We also find
that the relationship between height and income, while still
significant, is smaller: being 1cm taller is now associated with earning
\$95 more per year. This means that part of the relationship between
height and income was due to the fact that men are taller than women.
