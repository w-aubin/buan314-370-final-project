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
