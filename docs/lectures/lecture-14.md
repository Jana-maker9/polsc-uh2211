# Lecture 14: Causality II: Causal DAGs
Romain Ferrali

    Warning: There were 2 warnings in `mutate()`.
    The first warning was:
    ℹ In argument: `female = case_match(sex, "FEMALE" ~ 1, "MALE" ~ 0, .default =
      NA)`.
    Caused by warning:
    ! `case_match()` was deprecated in dplyr 1.2.0.
    ℹ Please use `recode_values()` instead.
    ℹ Run `dplyr::last_dplyr_warnings()` to see the 1 remaining warning.

## Empirical Motivation: Which Coefficient Should We Trust?

We want to estimate the causal effect of **education** on **income**. A
natural starting point is a simple regression. But watch what happens as
we add controls.

``` r
modelsummary(
  list(
    "Education only" = lm(income ~ edu, data = df),
    "+ Race" = lm(income ~ edu + race, data = df),
    "+ Race + Age" = lm(income ~ edu + race + age, data = df)
  ),
  stars = TRUE,
  gof_map = c("nobs", "r.squared")
)
```

<table style="width:85%;">
<colgroup>
<col style="width: 19%" />
<col style="width: 23%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr>
<th></th>
<th>Education only</th>
<th><ul>
<li>Race</li>
</ul></th>
<th><ul>
<li>Race + Age</li>
</ul></th>
</tr>
</thead>
<tbody>
<tr>
<td>(Intercept)</td>
<td>13076.048***</td>
<td>12613.164***</td>
<td>10999.858***</td>
</tr>
<tr>
<td></td>
<td>(755.720)</td>
<td>(817.053)</td>
<td>(918.104)</td>
</tr>
<tr>
<td>edu</td>
<td>589.019***</td>
<td>577.193***</td>
<td>565.982***</td>
</tr>
<tr>
<td></td>
<td>(51.374)</td>
<td>(51.849)</td>
<td>(52.748)</td>
</tr>
<tr>
<td>raceOther</td>
<td></td>
<td>228.082</td>
<td>447.230</td>
</tr>
<tr>
<td></td>
<td></td>
<td>(565.510)</td>
<td>(579.252)</td>
</tr>
<tr>
<td>raceWhite</td>
<td></td>
<td>817.531*</td>
<td>762.506+</td>
</tr>
<tr>
<td></td>
<td></td>
<td>(413.693)</td>
<td>(423.309)</td>
</tr>
<tr>
<td>age</td>
<td></td>
<td></td>
<td>39.737***</td>
</tr>
<tr>
<td></td>
<td></td>
<td></td>
<td>(10.064)</td>
</tr>
<tr>
<td>Num.Obs.</td>
<td>1981</td>
<td>1965</td>
<td>1895</td>
</tr>
<tr>
<td>R2</td>
<td>0.062</td>
<td>0.064</td>
<td>0.072</td>
</tr>
</tbody><tfoot>
<tr>
<td colspan="4"><ul>
<li>p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</li>
</ul></td>
</tr>
</tfoot>
&#10;</table>

The education coefficient changes each time we add a variable. Which
estimate, if any, is the causal effect of education on income? What are
race and age *doing* in these regressions?

Adding a control can do very different things: it can remove confounding
bias, or it can block part of the causal effect we are trying to
measure, or it can introduce new bias. Regression alone cannot tell us
which is happening. We need a framework for thinking about the *causal
structure* of the data.

**Directed Acyclic Graphs (DAGs)** are that framework.

## Directed Acyclic Graphs

A DAG is a diagram that encodes our assumptions about the causal
relationships between variables.

- **Nodes** represent variables in the system.
- **Directed edges (arrows):** $A \to B$ means “$A$ directly causes
  $B$.”
- **Acyclic** means no variable can cause itself (no feedback loops or
  cycles).

The simplest possible DAG for our question:

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  E[Education] --> I[Income]
  class E treatment
  class I outcome
```

This says: education directly causes income, and nothing else is going
on. In this world, the OLS coefficient on education is the causal
effect. But we have reason to believe the world is more complicated. A
more realistic DAG also includes race and age:

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  R[Race] --> E[Education]
  A[Age] --> E
  R --> I[Income]
  A --> I
  E --> I
  class E treatment
  class I outcome
```

This graph is the starting point for the rest of the lecture. We can use
it to introduce the key vocabulary of DAGs:

- **Treatment (exposure):** the variable whose causal effect we want to
  estimate — here, *Education* (blue node).
- **Outcome:** the variable we care about — here, *Income* (green node).
- **Parents** of a node: the variables with a direct arrow *into* it.
  The parents of Education are Race and Age; the parents of Income are
  Education, Race, and Age.
- **Children** of a node: the variables it directly causes. The only
  child of Education is Income.
- **Ancestors** of a node: all variables with a directed path *to* it
  (parents, parents of parents, etc.). The ancestors of Income are
  Education, Race, and Age; the ancestors of Education are Race and Age.
- **Descendants** of a node: all variables it has a directed path *to*.
  The only descendant of Education is Income.

A DAG is not a statistical model — it is a set of *assumptions* about
what causes what. Those assumptions come from theory, institutional
knowledge, and domain expertise. The DAG then tells us what we need to
do statistically to recover a causal estimate.

**To remember.** A DAG encodes causal assumptions as a graph of nodes
(variables) and directed edges (direct causal effects). Key terms:
treatment, outcome, parents, children, ancestors, descendants. The DAG
is the starting point for deciding what to control for.

## Three Structural Building Blocks

Every DAG is built from three fundamental structures. Understanding them
is the key to causal reasoning.

**1. Chain (mediator)**

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  E[Education] --> J[Job Type] --> I[Income]
  class E treatment
  class I outcome
```

Job Type lies on a directed path from Education to Income: education
affects the type of job a person obtains, which affects income. If we
condition on Job Type, we block this path — we “cut” the chain.

**2. Fork (common cause)**

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  R[Race] --> E[Education]
  R --> I[Income]
  class E treatment
  class I outcome
```

Race is a common cause of both Education and Income. Even if education
had *no* effect on income, they would still be correlated — because both
are influenced by race. This is **confounding**: a spurious association
that does not reflect a causal effect.

**3. Collider**

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  E[Education] --> I[Income]
  R[Race] --> I
  class E treatment
  class I outcome
```

Income is a **collider**: two arrows point *into* it from Education and
Race. Colliders behave differently from the other two structures. By
default, a collider *blocks* the path — Education and Race are not
spuriously correlated through Income. But if we condition on the
collider (e.g., we restrict our sample to a specific income bracket),
the path *opens* and introduces a spurious correlation. For example,
among people all earning the same income, those with less education must
(on average) have compensatory advantages along race-related dimensions
— otherwise they would not have reached that income level. More on this
in the Sources of Bias section below.

**To remember.** Association flows through chains and forks, but is
blocked by colliders (unless you condition on them). These three
structures are the building blocks of every DAG.

## Sources of Bias

The three structural building blocks generate three distinct sources of
bias. Understanding which applies in a given situation is the central
challenge of causal inference.

### Confounders

A variable $C$ is a **confounder** of the treatment–outcome relationship
if it creates a fork: it causes both the treatment and the outcome.
Equivalently, it opens a **backdoor path** — an indirect route from
treatment to outcome that runs through a common cause.

**Race as a confounder:**

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  R[Race] --> E[Education]
  R --> I[Income]
  E --> I
  class E treatment
  class I outcome
```

- Race affects educational attainment: historical and ongoing
  inequalities in access to schooling mean that Black and other minority
  respondents have, on average, fewer years of education than White
  respondents.
- Race affects income directly: labor market discrimination means that,
  conditional on education, Black respondents earn less.

This creates a backdoor path: Education ← Race → Income. Even if
education had no causal effect on income, we would still observe a
positive correlation between the two — because both are influenced by
race.

**Consequence:** if we do not control for race, the education
coefficient picks up both the causal effect of education *and* the
spurious association induced by the backdoor path. This is **omitted
variable bias**.

**Solution:** control for race. Doing so “closes” the backdoor path
through race and removes that source of confounding. This is exactly
what happens when we move from Model 1 to Model 2 in the opening table.

**Age as a second confounder:**

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  A[Age] --> E[Education]
  A --> I[Income]
  E --> I
  class E treatment
  class I outcome
```

- Older respondents have lower average education: access to college
  expanded substantially over the 20th century, so younger cohorts are
  more educated.
- Older respondents have higher income: they have more work experience
  (the experience premium).

Age therefore opens a second backdoor path: Education ← Age → Income.
Model 3 closes both backdoor paths by controlling for both race and age.

**To remember.** A confounder opens a backdoor path between treatment
and outcome. Not controlling for it causes omitted variable bias.
Controlling for it closes the backdoor path. You should control for
confounders.

### Mediators

A **mediator** is a variable that lies on a directed causal path from
treatment to outcome.

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  E[Education] --> J[Job Type]
  J --> I[Income]
  E --> I
  class E treatment
  class I outcome
```

Job Type is a mediator: education affects what type of job a person
obtains, which in turn affects income. There is also a direct arrow from
Education to Income — the effect that does not pass through job type.

Now consider the same structure from a different angle. In the main DAG,
Education is a mediator for the effect of Race on Income:

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  R[Race] --> E[Education]
  R --> I[Income]
  E --> I
  class R treatment
  class I outcome
```

Here Race is the treatment (blue), Income is the outcome (green), and
Education is a mediator — it lies on a directed path from Race to
Income. Race affects educational attainment, which in turn affects
income. But race also affects income through other channels (e.g., labor
market discrimination), represented by the direct arrow Race → Income.

**Total vs. direct effects:**

- **Total effect** of race on income: the sum of all directed paths from
  Race to Income — both the direct path (Race → Income) and the mediated
  path (Race → Education → Income).
- **Direct effect** of race on income: only the direct arrow Race →
  Income — the effect that does not operate through educational
  attainment.

**Key insight:** if we control for Education when studying the effect of
Race on Income, we block the mediated path. The coefficient on Race no
longer captures the total effect — it captures only the direct effect,
net of the education channel. This is not “correcting for confounding” —
it is *changing the quantity we are estimating*.

- If we want the **total effect** of race on income (all channels
  combined): do **not** control for education.
- If we want the **direct effect** (only the non-education channels):
  control for education *and* any remaining confounders.

**To remember.** Mediators transmit causal effects. Controlling for a
mediator blocks that causal path and changes the estimand from the total
to the direct effect. Do not control for mediators unless you
specifically want the direct effect.

### Colliders

A **collider** on a path is a node where two arrows on that path both
point *in*: $A \to C \leftarrow B$.

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  E[Education] --> I[Income]
  R[Race] --> I
  class E treatment
  class I outcome
```

Income is a collider: both Education and Race point into it. By default,
a collider *blocks* the path — Education and Race are not spuriously
correlated through Income. No association flows through a collider
unless it is conditioned on.

**The problem:** if we condition on the collider — for instance, by
restricting our sample to respondents within a specific income bracket —
the path *opens*. Among people earning the same income, those with less
education must (on average) have compensatory advantages from race (and
vice versa). Conditioning on income creates a spurious negative
correlation between Education and Race in the conditioned sample, even
if none exists in the population.

This is **collider bias** (also called selection bias). It is insidious
because conditioning on a variable feels like “controlling for more” —
when in fact it introduces new spurious associations.

**To remember.** Unlike confounders, colliders should **not** be
controlled for. Conditioning on a collider opens a spurious path and
introduces collider bias. Not every control variable improves your
estimate.

### Putting It Together

| Situation | Problem | Solution |
|----|----|----|
| Confounder not controlled | Backdoor path open → confounding bias (OVB) | Control for the confounder |
| Mediator controlled | Causal path blocked → underestimates total effect | Do not control for mediators (unless you want the direct effect) |
| Collider controlled | Spurious path opened → collider bias | Do not control for colliders |

The art of causal inference is knowing which variables to include and
which to exclude. Adding more controls does not always help — it can
hurt. A DAG makes the logic explicit and forces us to state our causal
assumptions before running any regression.

Returning to the opening table: controlling for race and age closes two
backdoor paths (fork structures). Model 3 is the right specification
*if* race and age are the only confounders, and *if* neither is a
collider or a mediator. The DAG is the tool we use to defend or
challenge that claim.

**To remember.** Confounders should be controlled for; mediators should
not (unless you want the direct effect); colliders should never be
controlled for. A DAG clarifies which is which.

## Handling Unobservables

So far we have assumed that all confounders are **observed** — we have a
variable in our dataset that measures them. But what if a confounder is
unobserved?

Consider **ability**: more able individuals are more likely to pursue
higher education, and more able individuals are more productive and thus
earn higher incomes. Ability is a confounder — it creates a backdoor
path from Education to Income. But we have no reliable measure of
ability in the GSS.

``` mermaid
graph LR
  classDef treatment fill:#4a90d9,color:#fff,stroke:#2c6fad
  classDef outcome fill:#27ae60,color:#fff,stroke:#1a7a43
  U([Ability - unobserved]) -.-> E[Education]
  U -.-> I[Income]
  R[Race] --> E
  A[Age] --> E
  R --> I
  A --> I
  E --> I
  class E treatment
  class I outcome
```

The dashed node represents an unobserved variable. Because we cannot
observe ability, we cannot control for it. The backdoor path Education ←
Ability → Income remains open. No matter how carefully we select our
other controls, OLS on observational data cannot close a backdoor path
through an unobserved confounder.

### Why randomization solves it

Suppose a government runs a randomized vocational training program:
applicants are selected by lottery, so participation is independent of
ability, race, and age by design. In the DAG, there are no arrows into
the training assignment — nothing can confound it, not even unobserved
variables. The difference in outcomes between participants and
non-participants is a valid causal estimate.

### When randomization is not feasible

Education itself cannot be randomly assigned. When randomization is not
possible, researchers use quasi-experimental strategies — instrumental
variables, regression discontinuity, and difference-in-differences —
that exploit particular sources of variation to close backdoor paths
even through unobserved confounders. These strategies are the subject of
future lectures.

**To remember.** DAGs expose what we must assume for a causal estimate
to be valid. When a confounder like ability is unobserved, OLS on
observational data is biased regardless of how many other controls we
include. Experimental and quasi-experimental designs solve this by
severing all backdoor paths — including those through unobservables — by
construction.

## Equilibrium Behavior and Causal DAGs

DAGs assume a strict one-way flow of causation: every arrow goes from
cause to effect, and no variable can cause itself. This is a powerful
simplification, but it comes at a cost: **DAGs are poorly suited for
equilibrium behavior** — situations where $X$ and $Y$ mutually determine
each other.

A simple example is **social contagion in smoking**: person $i$ smokes
because person $j$ smokes, and person $j$ smokes because person $i$
smokes. The underlying process is genuinely simultaneous — behavior
co-evolves through social interaction. Drawing this as a DAG requires a
directed graph, which means choosing a direction:

``` mermaid
graph LR
  Si["i smokes"] --> Sj["j smokes"]
  Sj --> Si
```

But this is a **cycle**, which is not allowed in a DAG. The acyclicity
requirement is not just a technicality — a cyclic graph has no causal
starting point and cannot be used for identification.

The standard workaround is to introduce a common cause that drove both
behaviors into equilibrium — for example, shared **social norms**:

``` mermaid
graph LR
  N[Social Norms] --> Si["i smokes"]
  N --> Sj["j smokes"]
```

In this DAG, the correlation between $i$’s and $j$’s smoking is not a
peer effect — it is confounding by shared norms, a fork structure. This
reframing is sometimes entirely plausible: if two people grew up in the
same household or community, shared norms may genuinely explain the
co-occurrence of their behaviors without any direct influence of one on
the other.

But the workaround can also feel forced. If the equilibrium truly arises
from ongoing mutual feedback — prices adjusting to supply and demand,
two firms setting strategies in response to each other, friends
reinforcing each other’s habits over time — then replacing the cycle
with a single common-cause node papers over the dynamics rather than
modeling them. In those cases, DAGs reach their limits, and other
frameworks (structural equation models, game-theoretic models) may be
more appropriate.

**To remember.** DAGs cannot represent mutual causation. The standard
fix — replacing a cycle with a common cause — is sometimes the right
substantive story, and sometimes an awkward workaround. Knowing when to
trust the DAG and when the question calls for a different framework is
part of causal reasoning.

## Key Takeaway

The main value of a DAG is not technical — it is *disciplinary*. Drawing
a DAG before running a regression forces you to answer a question that
is easy to skip: **what do I believe the causal structure of my data
looks like?**

Once the DAG is on paper, the regression choices follow directly:

- Which variables are confounders that must be controlled for?
- Which variables are mediators that must be left out (if you want the
  total effect)?
- Which variables are colliders that must never be included?
- Are any confounders unobserved — and if so, is OLS on this data
  credible at all?

A regression without a DAG is a set of choices without justification.
The coefficient you get may or may not be what you think it is. A DAG
does not guarantee a correct answer, but it makes the assumptions
explicit — and explicit assumptions can be debated, tested, and
improved.

**To remember.** Before running a regression, draw a DAG. It will tell
you which variables to include, which to exclude, and whether your data
can answer the causal question you are asking.
