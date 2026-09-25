# Will they say yes — or is this high risk?

**Binary prediction case study — income and health risk.**

Most business questions that matter are **yes / no**: will they earn above the threshold, will they develop the condition, will they leave (same maths). I help teams turn messy profiles into **probabilities people can act on** — and explain the odds in language a stakeholder can defend.

---

## The stake

A label without a probability is a blunt instrument. Leaders need **who is likely** and **what moves that likelihood** — not a black-box yes. The same log-odds story runs through credit, health risk, churn, and eligibility.

## The story

Three binary jobs, one family of model:

| Question | What we predict |
|----------|-----------------|
| **Income** | Above $50K vs not — from age, education, hours, … |
| **Health risk** | Diabetes vs not — starting with glucose |
| **The maths** | Probability ↔ odds ↔ log-odds (so the model is explainable) |

**Outcome on this build:**
- Full **GLM + tidymodels** paths on a 48K-row income table  
- **Coefficient reading** (education, age, hours — including uncomfortable real-world signals)  
- **Diabetes**: a single feature already yields useful risk scores (e.g. high glucose → high probability)  
- Probability conversions your analysts can put in a memo  

> **The commercial idea:** ship **risk scores + reason codes**, not just a classification label.

---

## What that looks like in your world

| You have | I turn it into |
|----------|----------------|
| Customer / patient / applicant rows | **Probability** of the yes |
| “Flag the high risk ones” | Threshold you choose + **who sits above it** |
| Coefficients nobody reads | **Odds story** in business language |
| Three tools, three scorecards | One honest binary playbook |

**Typical engagement:** define the yes/no and the cost of mistakes → fit on your data → calibrated scores + top drivers.

**[Talk to me about risk scoring →](https://datafying.co/#contactus)** · [datafying](https://datafying.co/)

---

## Why leaders bring me in

- Binary problems are everywhere — this is the **workhorse**, not a toy  
- Coefficients are turned into **odds you can argue with**  
- Shows the full loop: EDA → model → interpretation → probability maths  
- Honest about fairness and proxy variables in demographic data  

---

## Proof of craft *(technical)*

### Scripts

| File | Data | Target | Focus |
|------|------|--------|--------|
| `01-income-glm.R` | Adult / census (`data/adult.csv`) | income >50K | GLM, VIF, odds, holdout confusion |
| `02-diabetes-glucose.R` | `mlbench::PimaIndiansDiabetes2` | diabetes | Glucose→full GLM · confusions · recall/precision/F1/AUC |

### Probability ↔ odds ↔ log-odds

```
odds     = p / (1 - p)
log-odds = log(odds)
p        = exp(log-odds) / (1 + exp(log-odds))
```

Example (diabetes / glucose): coefficient `0.043` → each glucose unit multiplies odds by `exp(0.043) ≈ 1.044`; a 10-unit rise ≈ **1.54× odds**.

### Limits (honesty)
- Adult data includes sensitive attributes — **fairness review required** in production  
- Naive row deletes on missing data (diabetes demo) are for teaching clarity  
- Correlation in coefficients ≠ intervention effect  
- Recalibrate when population shifts  

---

## Reproduce

```bash
git clone https://github.com/47096/binary-predictions.git
cd binary-predictions
```

```r
source("setup.R")
source("01-income-glm.R")
source("02-diabetes-glucose.R")
```

**Data:** `data/adult.csv` (UCI Adult, vendored) · `PimaIndiansDiabetes2` via `mlbench`

**Stack:** `tidyverse` · `tidymodels` · `caret` · `glm` · `vip` · `mlbench` · `naniar`

---

## Next step

If you have a yes/no decision and only hard labels today — that is the engagement I run.

**[Book a conversation →](https://datafying.co/#contactus)** · Customer & risk analytics · [datafying](https://datafying.co/)
