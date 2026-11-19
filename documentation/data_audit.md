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
