# Practicum
Romain Ferrali & Paul Love

Feel free to use the starter template at
<https://github.com/recap-org/template-r-small> for a clean starting
setup. Also feel free to check out the [commented
example](../../assets/example-practicum.pdf) using an article from [Good
Authority](https://goodauthority.org/), which is a newsletter that
applies data science to current political events.

For this assignment, you will need materials from the course’s GitHub
repository:

- The [January 2014](../../data/practicum-jan-2014.dta) and [May
  2014](../../data/practicum-may-2014.dta) public opinion datasets.
  These files are `.dta` files; the file format used by Stata. To open
  these files, you will need to use the `haven` package in R, which can
  read Stata files. It is part of the `tidyverse`. Use the
  `haven::read_dta()` function to read the .dta files into R.
- The [codebook](../../data/practicum-codebook.txt) describing each
  variable in the dataset.

## Scenario

Eight years before the Russian full-scale invasion into Ukraine, on
February 27th of 2014, Vladimir Putin illegally annexed the Ukrainian
peninsula of Crimea. His approval ratings soared.

Why did the annexation of Crimea boost his approval?

- One argument is that the Russian state propaganda machine, mostly
  through television, was an important factor.
- Another argument is that resentment toward the West, and in particular
  Western sanctions against Russia, led people to view Crimea’s
  annexation as a blow against their oppressors.
- Yet others argue that it was mere territorial expansion that made
  people approve of Putin.

Levada Center, the most respected and reliable polling institution in
Russia, conducts regular surveys in Russia and provides the results to
the public. It surveyed 1603 people in January of 2014 (prior to
annexation) and 1600 people in May of 2014 (after the annexation). The
wide range of questions asked in the survey gives us a unique
opportunity to look into different explanations of Putin’s increasing
popularity.

## Assignment

Use the statistical techniques you’ve learned in class to evaluate the
hypothesis that people watching more news approve of Putin more, or
increase their approval more after annexation. Look for evidence either
to support this claim or to suggest an alternative interpretation.

Next, look through the variables in the data set and develop your own
theory for why the annexation helped Putin’s approval ratings, and test
that theory.

Summarize your findings in a report, and keep in mind that the broader
public is not comprised of statistical experts: you’ll need to
communicate your findings clearly without relying on jargon. Note:
avoiding jargon does *not* mean teaching introductory statistics to your
audience. Detailed results may be supplied in an appendix, if necessary.

Include in your summary any other insights you think are helpful in
understanding what can and cannot be determined (i.e. what is or is not
causal) from the available data.

HINT: think about what DAGs are implied by each of the explanations, and
what regressions you need for each of those DAGs.

Your report should be no more than 2000 words of text and 3 figures, all
of which should be publication-quality. Only `.pdf` or `.html` files
will be accepted. Please also submit your `.qmd` with the **commented**
code for your analyses. Anything that doesn’t fit in the text can and
should go in an Appendix.

## Grading Rubric

I am looking for five key things in this assignment:

1.  That you can translate hypotheses to regressions (evaluated from the
    code and the text)
2.  That you can interpret those regressions correctly and explain their
    results (mostly evaluated from the text)
3.  That you can design and produce high-quality data visualizations
    that each make one key point and have all necessary elements
    (titles, axis labels, legends, etc.) to be understandable on their
    own.
4.  That you can explain the causal limitations of your analyses.
    (evaluated from the text)
5.  Most importantly, that you can communicate all of this clearly to a
    non-statistical audience in a well-formatted and well-structured
    report. (evaluated from the text)

## Important reminder

This assignment is tough, but it is more open-ended than you may be used
to. If you need help, do not hesitate to email us!

Good luck!
