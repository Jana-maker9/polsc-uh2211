# Problem set 2
Romain Ferrali

Feel free to use the starter template at
<https://github.com/recap-org/template-r-small> for a clean starting
setup.

Load the test scores dataset
[homework-2-scores.csv](../../data/homework-2-scores.csv), uploaded to
the course’s GitHub repository. Also on the course’s GitHub repository
is a [codebook](../../data/homework-2-scores-codebook.md) describing
each variable in the dataset `homework-2-scores.csv`. Use the dataset to
address the following questions.

## Problem 1: Linear regression.

1.  Run a linear regression with 8th grade math score as the outcome and
    socio-economic status as the input variable. Note that both
    variables are *standardized*, meaning that the raw variables for SES
    and math were transformed by subtracting the mean for each variable
    and then dividing by the standard deviation of each variable. As a
    result, a score of 0 for either variable is equivalent to an
    individual having average SES or math score, while a value of 1 (-1)
    means that the individual had a score that was 1 standard deviation
    above (below) the average value. Present the results in a table
    using `modelsummary`. Interpret the results of the regression,
    including specific discussion of the slope and intercept terms.
    Then, compare the prediction of the math score at SES equal to -2
    and +2. Discuss what this means in substantive terms.

2.  Run a linear regression to explore the relationship between
    kindergarten reading score and ethnicity. Present the results as a
    table using `modelsummary`. Plot the coefficients on the ethnicity
    variables using ggplot, and interpret those results relative to the
    reference group.

<!-- 3. Pose a clear hypothesis of your own regarding the data and use regression analysis with interaction effects to test that hypothesis. Present the results as a table using `modelsummary`. Interpret and explain the coefficients, including the interaction coefficient. -->

## Problem 2: Tidyverse

Load the England soccer data. Calculate the total number of goals scored
by each team, both when the team is playing at home and away. Produce a
publication-quality table that has both the top 5 and bottom 5 teams,
ordered by the total number of goals scored. Please use the tidyverse.

## Problem 3: Writing Functions

1.  Write a function to convert pounds to kilograms.

2.  Write a function to convert pounds to kilograms, or kilograms to
    pounds.

3.  Write a function to convert any of pounds, kilograms, stone, or gram
    to any of the other units. Start by thinking about what arguments
    your function should take. There should be 3.

**End of HW2.** Make sure to submit both your .qmd file and output,
either as a self-contained HTML or PDF file (the starter template at
<https://github.com/recap-org/template-r-small> are set up to output
self-contained HTML files). And if you need help, remember the rule: if
you can’t figure out a coding issue after spending 30 minutes and
Googling, EMAIL US.

Good luck!
