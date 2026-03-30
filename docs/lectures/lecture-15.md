# Lecture 15: Cheating at regression
Romain Ferrali

## Empirical Motivation: Paul the Octopus

In the 2010 FIFA World Cup, Paul the Octopus correctly predicted the
outcome of 8 out of 8 matches (all the games played by Germany (went to
semis), + the finals). What are the chances of this happening by random
chance?

$$\Pr(\text{success}) = 0.5 \equiv p$$

$$\Pr(\text{2 successes}) = p^2 = 0.25$$

$$\Pr(\text{8 successes}) = p^8 \approx 0.0039$$

Paul seems to be a genius. The issue: you too could be in the animal
fortune-telling business if you had one animal. In fact, if you had a
pet shop, you could turn all your animals into fortune tellers. Let’s
see how the probability of having one genius pet changes as you increase
the number of pets. Let $p_G = 0.0039$ be the probability of a pet being
a genius. Then, with $n$ pets, the probability of no genius pet is
$(1-p_G)^n$. So the probability of at least one genius pet is:

$$P_G = 1 - (1 - p_G)^n$$

## How to cheat at regression

That logic extends to p-values. Let’s say you are 95% certain that your
regression coefficient is zero. That means that if you were to repeat
the experiment many times with similar data,

- 95% of the time you would get a p-value greater than 0.05
  $\Rightarrow$ not significant
- 5% of the time you would get a p-value less than 0.05 $\Rightarrow$
  significant.

So, **the more tests you run, the more likely it is that you’ll get a
significant result by random chance.**

This means that

- If you run a regression with many variables, you are more likely to
  find a significant coefficient by random chance.
- If you run many regressions, you are more likely to find a significant
  coefficient by random chance.

### How to do it in practice? Data mining

1.  Pick a dataset with many variables, and don’t have a clear
    hypothesis in mind.
2.  Run many regressions with different combinations of variables until
    you find a significant coefficient.
3.  Build a nice story about significant coefficient you found, and
    pretend this was your idea all along.

You can also do this with experiments. Typically, running many
treatments is expensive. Collecting data on many outcomes, however, is
cheap. So you can run one experiment, and then test many outcomes until
you find a significant result.

## How to avoid it?

1.  **Statistical adjustments.** There are ways to adjust p-values for
    multiple testing. The most common one is the Bonferroni correction,
    which divides the significance level by the number of tests. For
    example, if you run 10 tests, you would use a significance level of
    0.005 instead of 0.05. This makes it harder to find significant
    results by random chance.
2.  **Pre-registration.** This is the practice of specifying your
    hypotheses and analysis plan before collecting data. You deposit
    your plan in an archive (e.g., https://osf.io). This way, you can’t
    change your hypotheses after seeing the data. This is becoming very
    common in the social sciences.

## Another thing that feels like cheating, but may not be

We have seen that regression is bad at predicting non-linear
relationships. So, if you have a non-linear relationship, you can try to
transform your variables to make the relationship linear. For example,
if you have data that is highly skewed (like income), it is often useful
to run the following regression:

$$\log(\text{income}) = \beta_0 + \beta_1 \text{education} + \epsilon$$

Is this cheating? Individually, no. It is a common practice to transform
variables to make them more suitable for regression. However, if you try
many different transformations until you find one that gives you a
significant result, then you may be back to the problem of multiple
testing.
