# Raw data audit

| Variable / test | Data type | Missing share | Distinct values | Summary / observed issue | Example rows | Source dictionary reference |
|---|---|---|---|---|---|---|

## Preliminary Sport Services raw-file inspection — 2026-11-18

- Source candidate: Mendeley Sport Services Dataset, file `DadosV3.csv` (downloaded alongside `yprk4jdgnv-1.zip`).
- Raw path currently on student's local machine: `data/raw/DadosV3.csv`. The source archive is `data/raw/yprk4jdgnv-1.zip`.
- Original archive lists one `DadosV3.csv` member, uncompressed length **4,488,165 bytes**.
- Student's read-only R commands reported `dim(sports_raw)` = **14,942 rows × 47 columns**.
- Student's CSV file size = **4,488,165 bytes**, matching the archive's uncompressed length (not yet hash-verified).
- `sum(duplicated(sports_raw$Id))` = **0**, i.e. no duplicate non-first IDs in imported dataset.
- File delimiter observed: semicolon; decimal separator: period.
- Published dataset description previously mentioned 45 attributes; imported file has 47 columns. Resolve against the file dictionary before finalizing column mapping.
- Pending: column types, missingness, sample rows, coverage, dictionary mapping, correlation and temporal leakage tests.
- **No cleaning, row removals, model fitting, or source modifications have occurred.**

## Column types and initial NA audit — 2026-11-18

Student supplied the `column_audit` table generated in R from `sports_raw`. All **47** columns returned **Missing_Count = 0** and **Missing_Percent = 0** using `is.na()`.

- **12 character** columns (including identifiers, grouping labels and three date/time fields).
- **35 numeric/integer** columns; some integer columns are actually category codes (for example `Dropout`, `HasReferences`), not continuous quantities.
- **Dates are currently character strings** (`EnrollmentStart`, `EnrollmentFinish`, `LastPeriodStart`, `LastPeriodFinish`, `DateLastVisit`); no date conversion approved or performed.
- **Caution:** `is.na()` results alone do not rule out blank strings, encoded missing-value sentinels, or invalid values. Await checks before calling dataset complete.

## Blank-string check — 2026-11-18

Student ran `sapply(sports_raw[, text_columns, drop = FALSE], function(x) sum(trimws(x) == "", na.rm = TRUE))`. All **12 imported character columns** returned **0 blank or whitespace-only values**: Id, AgeClass, Gender, EnrollmentStart, EnrollmentFinish, EnrollmentDurationClass2, LastPeriodStart, LastPeriodFinish, DateLastVisit, DaysWithoutFrequencyClass2, AverageFrequencyClass2, RatioClass2.

**Limit:** Blank-string and `is.na()` checks do not reveal special numeric/text codes for unknown, not applicable, or missing observations; check the published dictionary and frequency distributions before classifying the data as complete. No source files modified.

## Gender and dropout coding screen — 2026-11-18

Read-only counts supplied by student, `n = 14,942`:
- `Gender`: Female **8,931 (59.8%)**, Male **6,011 (40.2%)**.
- `Dropout`: 0 = **2,974 (19.9%)**; 1 = **11,968 (80.1%)**.
- No missing categories in these two tables (`useNA = "ifany"`).

Original data dictionary in Pinheiro & Cavique (2021), Table 1, defines `Dropout` as **True when quitting**, False otherwise; Table 5 records **11,968 True / 2,974 False**. On this imported integer-coded file, **1 = dropout and 0 = not dropout**.
Source: https://pmc.ncbi.nlm.nih.gov/articles/PMC8100056/

This is an outcome status at the documented finish date, **not an 80.1% annual churn rate**. Cohort and prediction-timing concerns remain. Next check cross-tabulation by Gender.

## Gender × dropout conditional shares — 2026-11-18

Student reported within-gender percentages from `round(prop.table(gender_dropout, margin = 1) * 100, 1)`:
- Female: **18.9% Dropout=0**, **81.1% Dropout=1**
- Male: **21.4% Dropout=0**, **78.6% Dropout=1**
- Female-minus-male reported dropout difference: **+2.5 percentage points** (rounded).
- Cross-tabulation absolute counts (`addmargins(gender_dropout)`) not yet provided; request them for exact numerical verification.

**Interpretation limit:** Historical within-gender proportions among records in this one facility, not an annual churn rate. No statistical significance, causal mechanism, or effect of a new training program established.

## Gender × dropout counts verified — 2026-11-18

```text
             Dropout 0  Dropout 1   Total
Female           1688       7243    8931
Male             1286       4725    6011
Total            2974      11968   14942
```

- Row and column totals all reconcile.
- Female dropout share: 7,243 / 8,931 ≈ **81.1%**.
- Male dropout share: 4,725 / 6,011 ≈ **78.6%**.
- Female-minus-male difference: **about 2.5 percentage points**.
- These are retrospective proportions from one facility, not annual rates or causal program effects.
- Cross-tabulation counts and shares now verified. Continue with age and other variable availability audit before viability decision.

## Existing age classes × gender — 2026-11-18

Student supplied `table(sports_raw$AgeClass, sports_raw$Gender)`:

| Original AgeClass | Female | Male | Total |
|---|---:|---:|---:|
| [00,20[ | 2,137 | 1,678 | 3,815 |
| [20,35[ | 4,920 | 3,122 | 8,042 |
| [35,49[ | 1,099 | 758 | 1,857 |
| [49,65[ | 557 | 326 | 883 |
| [65,inf[ | 218 | 127 | 345 |
| **Total** | **8,931** | **6,011** | **14,942** |

**Observed:** 7,057 of 8,931 female records (79.0%) fall into under-20 or 20–34 age classes; 1,874 (21.0%) are age 35 or older according to these codes. Among women, 218 (2.4%) fall in 65+. The operator described a female membership median age of 46, so transferability is a concern; no claims about sampling representativeness are justified yet. Under-20 respondents may include minors; investigate suitability before research scope is chosen. Still waiting on output of `summary(sports_raw$Age)` to establish observed numeric age distribution. Do not re-bin or modify source data without approval.

## Numeric age summary — 2026-11-18

Student reported `summary(sports_raw$Age)`: **Min 0**, **Q1 19**, **Median 23**, **Mean 26.02**, **Q3 31**, **Max 87** (n = 14,942). The median age of the full dataset is not a female-only median.

According to Pinheiro and Cavique's published dictionary, `Age` is measured as of **2019-10-31 for non-dropouts**, or as of **EnrollmentFinish for dropouts**. It is not necessarily the age at enrollment or a valid earlier-date predictor. Source: https://pmc.ncbi.nlm.nih.gov/articles/PMC8100056/ (Table 1).

A recorded minimum of 0 requires investigating how many child records exist; do **not** interpret it as an error, delete, filter, or recode observations without student approval. Next: tabulate age under 18 and age exactly 0 by gender.

## Under-18 age check — 2026-11-18

Student's read-only `table(Gender = sports_raw$Gender, Under_18 = sports_raw$Age < 18)` and age-zero count:

| Gender | Age >=18 | Age <18 | Total |
|---|---:|---:|---:|
| Female | 7,491 | 1,440 | 8,931 |
| Male | 4,765 | 1,246 | 6,011 |
| Total | 12,256 | 2,686 | 14,942 |

`sum(sports_raw$Age == 0)` returned **19**. Under-18 records constitute approximately **18.0%** of total; female adults n = **7,491**. Source of age zero remains unexplained. No ages changed; no rows removed or filtered from underlying data. Next: read-only three-way tabulation by gender, age eligibility, and dropout.
