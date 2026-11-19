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

## Gender × under-18 × dropout — 2026-11-18

Student supplied read-only `table(Gender = sports_raw$Gender, Under_18 = sports_raw$Age < 18, Dropout = sports_raw$Dropout)`:

| Gender / recorded age | Dropout 0 | Dropout 1 | Total | Dropout=1 share |
|---|---:|---:|---:|---:|
| Female 18+ | 1,117 | 6,374 | 7,491 | 85.1% |
| Female under 18 | 571 | 869 | 1,440 | 60.3% |
| Male 18+ | 812 | 3,953 | 4,765 | 83.0% |
| Male under 18 | 474 | 772 | 1,246 | 62.0% |
| **All adults** | **1,929** | **10,327** | **12,256** | **84.3%** |
| **All under 18** | **1,045** | **1,641** | **2,686** | **61.1%** |

The overall total remains **14,942** with **2,974** non-dropout and **11,968** dropout. Adult female-minus-adult male dropout difference ≈2.1 percentage points; adult female-minus-under-18 female ≈24.7 percentage points. This is descriptive, not an annual churn rate or a causal effect. Age is measured at endpoint, which matters for interpretation and predictive feature timing. No records filtered or modified. **Adult-only project scope not yet approved by student.**

## Preliminary analytical scope approved — 2026-11-18

The student explicitly approved evaluating **both female and male records with recorded Age >= 18**, emphasizing women and retaining men as a comparison population. Existing read-only counts imply **n = 12,256** (female **7,491**, male **4,765**); under-18 records = **2,686**. This is a proposed analytical scope for data viability and later analysis, **not a data cleaning action**. The source `data/raw/DadosV3.csv` remains untouched; no processed file or row removal has been performed.

**Critical interpretation:** The published `Age` measure is recorded at the member's endpoint, so `Age >= 18` indicates adulthood **at that recorded reference date**, not necessarily at enrollment. The student's belief that most health clubs require members to be 18 is an assumption, not a dataset finding or a universal entry rule. Confirm eligibility policy for the target club if it becomes relevant.

## Adult recorded ages by gender — 2026-11-18

Student ran `by(sports_raw$Age[sports_raw$Age >= 18], sports_raw$Gender[sports_raw$Age >= 18], summary)`:

| Statistic | Female adults | Male adults |
|---|---:|---:|
| n (from previous approved adult scope) | 7,491 | 4,765 |
| Min | 18 | 18 |
| Q1 | 21 | 21 |
| Median | **24** | **25** |
| Mean | 29.77 | 29.92 |
| Q3 | 35 | 35 |
| Max | 86 | 87 |

Business informant separately reported medians of 46 (women) and 48 (men) across their organization's club memberships; therefore adult medians differ by 22 and 23 years respectively. These data describe different geographic/organizational populations and potentially different measurement contexts; no representativeness established. The source dictionary identifies `Age` at membership endpoint, not necessarily at enrollment. Adult-only scope remains provisional for the ongoing feasibility test.

Potential numeric candidate definitions from source dictionary (not yet selected): `AverageFrequency` = average weekly visits over entire enrollment; `AttendedClassesAverage` = average classes per week. **Both are retrospective aggregate variables**, so timing and leakage require checking if intended as forecasting predictors. Source: Pinheiro and Cavique, *Data in Brief* 36 (2021), DOI 10.1016/j.dib.2021.107054.

## Candidate numeric outcome distributions, adult scope — 2026-11-18

Student supplied read-only R summaries (subset `sports_raw$Age >= 18`, n=12,256; all raw rows preserved):

| Summary | AverageFrequency | AttendedClassesAverage |
|---|---:|---:|
| Min | 0 | 0 |
| Q1 | 0.29 | 0 |
| Median | 0.61 | 0 |
| Mean | 0.8035 | 0.07638 |
| Q3 | 1.09 | 0 |
| Max | 4.94 | 3.01 |

According to the publisher's dictionary, `AverageFrequency` is the average frequency of visits to the club per week during the full enrollment period and `AttendedClassesAverage` is average number of classes attended per week. The latter's 75th percentile equals zero, indicating a large mass at zero; an exact zero count has not yet been established. The former shows much more variation. Neither is yet chosen as the numeric target, and both summarize activity during full enrollment, which creates timing concerns for forecasting a future dropout outcome.

**Next read-only check:** count zero and positive values for each outcome in the approved adult analytical population before selection.

## Zero-versus-positive participation counts — adult scope (student's R results)

From `sapply(adult_numeric, function(x) c(Zero=sum(x==0), Above_Zero=sum(x>0), Percent_Zero=round(mean(x==0)*100,1)))` for **12,256 records with recorded Age >= 18**:

| Variable | Equal to zero | Greater than zero | Reported % zero | Calculated % positive |
|---|---:|---:|---:|---:|
| AverageFrequency | 1 | 12,255 | 0.0% (rounded; actual ~0.0082%) | ~99.99% |
| AttendedClassesAverage | 10,114 | 2,142 | 82.5% | 17.5% |

These are recorded **average weekly visit/class measures** over a member's enrollment, not evidence that the same facilities or program types were available or that zero attendance represents a lack of demand. Exact zero based on imported numeric values. No records removed; not yet testing correlations or prediction timing. In particular, retrospective averages from full enrollment are potentially contemporaneous or post-outcome measures if used to predict future dropout.

Next proposed read-only analysis: stratify mean and median of both attendance measures by observed Dropout status, with n, as a *descriptive diagnostic* only (not causal and not yet a leakage-safe predictor check).

## Attendance by dropout status among adult records — 2026-11-18

Student ran `aggregate(cbind(AverageFrequency, AttendedClassesAverage) ~ Dropout, data=sports_raw[sports_raw$Age >= 18, ], FUN=mean)` on the approved adult scope (n=12,256):

| Outcome | Dropout=0 | Dropout=1 | Difference (0 minus 1) |
|---|---:|---:|---:|
| AverageFrequency, mean weekly visits across enrollment | 1.0928357 | 0.7494723 | 0.3433634 |
| AttendedClassesAverage, mean weekly classes across enrollment | 0.13035251 | 0.06629515 | 0.06405736 |

Counts from earlier cross-tabulation: Dropout=0 adult n=1,929; Dropout=1 adult n=10,327. Relative to Dropout=0 means, dropout-group visits are about 31.4% lower and class attendance is about 49.1% lower. **These are unadjusted descriptive associations only.** Variables summarize enrollment and may contain future information if used to predict dropout at earlier time points. No causal inference or program-specific effect is warranted. No model fitted, no data altered. Next: preliminary read-only pairwise correlation screen for these two numeric candidates and Dropout before testing timing-safe predictors.

## Preliminary three-variable adult correlation screen — 2026-11-18

Student supplied R output from `round(cor(adult_screen, use = "complete.obs"), 3)` on approved adult sample, **n=12,256**, based on previously verified no-NA summaries.

| Variable | AverageFrequency | AttendedClassesAverage | Dropout |
|---|---:|---:|---:|
| AverageFrequency | 1.000 | 0.097 | -0.178 |
| AttendedClassesAverage | 0.097 | 1.000 | -0.097 |
| Dropout | -0.178 | -0.097 | 1.000 |

**Preliminary result:** No pair in this three-variable screen reaches the assignment's approximate absolute 0.20 correlation threshold. For the proposed binary target `Dropout`, neither of these engagement variables passes individually. For proposed numeric target `AverageFrequency`, neither `AttendedClassesAverage` nor `Dropout` passes. **Do not declare the entire dataset nonviable yet**: other independently measured predictors have not been screened. All three variables describe activity/outcome over or at the endpoint of enrollment, so even strong correlations may be unsuitable for forecasting future dropout due to temporal leakage. Correlation is not causation, and these are not annual churn statistics. Neither target nor predictor list has been approved; no changes to underlying data.

## Adult scope: five strongest numeric correlations with two candidate targets — 2026-11-18

Student reported R `top_correlations()` based on numeric fields of the adult (Age >=18) sample (n=12,256):

**Binary target `Dropout`**: `DaysWithoutFrequencyClass1` +0.345, `Ratio` -0.270, `LifetimeValue` -0.262, `NumberOfRenewals` -0.258, `NumberOfFrequencies` -0.249.

**Numeric target `AverageFrequency`**: `AverageFrequencyClass1` +0.838, `RealNumberOfVisits` +0.635, `Ratio` +0.534, `NumberOfFrequenciesClass1` +0.526, `NumberOfFrequencies` +0.505.

**Interpretation**: Both candidate targets have at least one |r| >= 0.20 in the numerical correlation screen. However, this is not yet a pass on *valid prediction*. The publisher's dictionary confirms that:
- `AverageFrequencyClass1` is a categorized encoding of the numeric target itself (mechanical relationship, unusable as its independent predictor).
- `DaysWithoutFrequencyClass1` categorizes days without visits at the member endpoint, not a clean pre-cancellation predictor.
- `LifetimeValue`, `NumberOfRenewals`, and `NumberOfFrequencies` accumulate over the enrollment span.
- `Ratio` and `RealNumberOfVisits` refer to the last activity / last two months of enrollment (attributes 40–44), making their availability at an earlier prediction time questionable.
- `NumberOfFrequenciesClass1` discretizes total visits and is also a retrospective measure.

**Decision:** Do not select the dataset or predictors yet. Next is a **read-only limited correlation screen for characteristics and program-category flags** rather than the mechanically related and endpoint-dependent variables. Original definitions: Pinheiro & Cavique, *Data in Brief* (2021), Table 1 and note (b) below Table 3, https://pmc.ncbi.nlm.nih.gov/articles/PMC8100056/ ; licensed source https://data.mendeley.com/datasets/yprk4jdgnv/1 . No raw files modified, models fitted, or feature selection approved.

## Member and activity-variable correlation screen (adult scope) — 2026-11-18

Student supplied the following `cor()` results for 12,256 records with `Age >= 18`:

| Candidate variable | Dropout | AverageFrequency |
|---|---:|---:|
| Age | -0.178 | 0.097 |
| FitnessActivities | 0.050 | 0.092 |
| WaterActivities | -0.069 | 0.025 |
| DanceActivities | NA | NA |
| RacketActivities | 0.056 | -0.047 |
| CombatActivities | -0.022 | -0.147 |
| NumberOfActivities | -0.080 | 0.022 |
| HasReferences | -0.010 | 0.006 |

**Assessment:** No finite correlation in this restricted predictor screen reaches the professor's approximate |r| >= 0.20 threshold. Correlations over 0.20 in the earlier full numeric screen involve retrospectively measured, endpoint-dependent, or mechanically derived variables. `DanceActivities` yielded undefined correlations; since the previous `is.na()` audit found no missing values, zero variance is suspected but still requires a frequency check. Do not mistake `NA` in the *correlation* for missing source values. Age is an endpoint-age measure, not necessarily a predictor at enrollment. This screen alone does not establish the usefulness, ineffectiveness, or causal impacts of programs. **No dataset approval, predictor choice, data cleaning, or model fitting has occurred.**

## Constant variable confirmation — 2026-11-18

Student ran `table(adult_data$DanceActivities, useNA="ifany")` and received only `0 = 12,256`. In the adult analytical scope, the recorded `DanceActivities` activity flag is **identically zero**, with zero variance. This explains the undefined (`NA`) Pearson correlation with both target candidates in the earlier correlation screen. It does *not* indicate a data missingness problem, a software malfunction, or the lack of demand for dance activities in other facilities. Exclude the constant variable from any future adult-sample correlation/multivariable predictor candidates, **without deleting or modifying the raw column**.

The Sport Services candidate remains under evaluation: highly retrospective/derived variables can satisfy |r| >=0.20 numerically, but the screened basic member and activity variables have not. To compare fairly with the student's other candidate, next investigate the CDC's 2024 NHIS Sample Adult public-use CSV (`adult24csv.zip`; official publication page https://www.cdc.gov/nchs/nhis/documentation/2024-nhis.html). This is a different business proxy (physical activity, not member retention), and no selection is made.

## NHIS 2024 ZIP README inspection — 2026-11-18

Student read `readme.txt` directly from `data/raw/adult24csv.zip` via an R `unz()` connection (read-only). ZIP manifest: `adult24.csv` = 32,782,569 bytes; `readme.txt` = 2,644 bytes. README states **32,629 observations** in 2024 Sample Adult file.

Publisher warns that some NHIS variables have sparse or out-of-universe responses, which can cause data-type/length inference problems when software looks only at early rows. For **base R**, README specifically recommends `read.csv("adult24.csv", stringsAsFactors=FALSE)`, which inspects the full file before assigning variable attributes. If using `readr::read_csv`, README recommends `guess_max=32629`. Publisher also advises comparing observed frequencies with official codebook frequencies, especially sparse columns. Empty/not-asked codes must be considered in later missingness checks.

No NHIS CSV loaded or modified yet. Next: use `read.csv()` on an `unz()` connection and compare `dim()` against the documented 32,629 rows.

## NHIS 2024 adult data import verified — 2026-11-18

Student executed a base-R `read.csv()` import of `adult24.csv` through `unz("data/raw/adult24csv.zip", "adult24.csv")` with `stringsAsFactors=FALSE`. The subsequent `close(nhis_connection)` returned `invalid connection`, apparently because the connection had already been closed by the read. The following explicit verification **succeeded**: `dim(nhis_raw)` = **32,629 rows × 630 columns**, matching the CDC ZIP README's expected 32,629 observations. The source ZIP remains unchanged; the data are in the in-memory object `nhis_raw`; no extracted or processed files have been created. Additional import integrity checks remain pending (variable values versus codebook, type and missingness screening). We should not attempt to close the already invalid connection again.

## 2024 NHIS candidate column names — 2026-11-18

User ran a read-only grep across `names(nhis_raw)` and received the exact matches: `SPOUSESEX_A`, `PRTNRSEX_A`, `STRFREQW_A`, `SEX_A`, and `AGEP_A`. The **exact strengthening frequency column in the student's imported 2024 file is `STRFREQW_A`**, not `STRFREQ_A`; preserve the spelling in all next R checks. `SEX_A` and `AGEP_A` are the respondent characteristics to inspect; spouse/partner-sex columns are not the respondent's own sex. The dataset is in memory and unchanged.

Potential coding pitfall: strengthening-frequency recodes include special numeric codes for never, unable, and nonresponse, which are not literal numbers of weekly training sessions. Do not calculate the mean or correlations until verifying the **exact 2024 codebook and observed code frequencies**. Next read-only check: `table(nhis_raw$SEX_A, useNA="ifany")` and `table(nhis_raw$STRFREQW_A, useNA="ifany")`, with `AGEP_A` inspected subsequently. Official documentation landing page: https://www.cdc.gov/nchs/nhis/documentation/2024-nhis.html .

## 2024 NHIS strengthening activity coding verified — 2026-11-19

Student supplied complete read-only R frequency tables. The values match the **official CDC 2024 NHIS Sample Adult codebook** (version 18 June 2025), for `SEX_A` (codebook p.19) and the weekly strengthening frequency field imported as **`STRFREQW_A`** (codebook p.483); original source https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2024/Adult-codebook.pdf .

| SEX_A | Publisher label | R count |
|---|---|---:|
| 1 | Male | 14,985 |
| 2 | Female | 17,639 |
| 7 | Refused | 3 |
| 9 | Don't know | 2 |

Sex code 8 (not ascertained) has 0 observations.

| STRFREQW_A code | Publisher label | R count |
|---|---|---:|
| 0 | Less than once per week | 970 |
| 1–28 | 1–28 times per week (aggregated) | 11,757 |
| 94 | Never | 18,783 |
| 95 | Extreme value | 61 |
| 96 | Unable to do this type of activity | 158 |
| 97 | Refused | 32 |
| 98 | Not ascertained | 815 |
| 99 | Don't know | 53 |
| **Total** | | **32,629** |

**Major coding caveat**: `94` denotes never; `95` extreme; `96` unable; `97` refused; `98` not ascertained; `99` don't know. Neither `94–99` nor `0` should be read as literal counts of exercise episodes (`0` denotes *less than once per week*, not necessarily never). Do not calculate numeric means or correlations on these original codes. The sample's unweighted `94` proportion is 57.57%; this is not the female-specific proportion and not a weighted population estimate. No recoding, exclusions or processed file created. Download and preserve the 2024 codebook locally before proceeding with any derived variables.

## NHIS 2024 sex × never-strengthening code screen — 2026-11-19

Student ran the original-code cross-tabulation SEX_A against STRFREQW_A == 94:

| SEX_A code | STRFREQW_A != 94 | STRFREQW_A == 94 | Total |
|---|---:|---:|---:|
| 1 (Male) | 7,074 | 7,911 | 14,985 |
| 2 (Female) | 6,770 | 10,869 | 17,639 |
| 7 (Refused) | 1 | 2 | 3 |
| 9 (Don't know) | 1 | 1 | 2 |
| **Total** | **13,846** | **18,783** | **32,629** |

Unweighted within-sex never proportions: Female **61.6%**, Male **52.8%**, difference about **8.8 percentage points**. These are not survey-weighted national estimates. The FALSE column includes numeric strengthening responses, code 0 (less than weekly), and missing/unknown response codes 95–99. Do not label all FALSE cases active participants. No conclusions about willingness to buy a service or membership retention. No data changes.

Next: inspect sex-specific special codes 95–99 without editing records.

## NHIS special strengthening-frequency codes by sex — 2026-11-19

Student's read-only output of `table(nhis_raw$SEX_A, nhis_raw$STRFREQW_A)[, as.character(95:99), drop=FALSE]`:

| SEX_A | 95 Extreme | 96 Unable | 97 Refused | 98 Not ascertained | 99 Don't know | Sum |
|---|---:|---:|---:|---:|---:|---:|
| 1 Male | 28 | 59 | 18 | 399 | 26 | **530** |
| 2 Female | 33 | 99 | 14 | 416 | 27 | **589** |
| 7 Refused sex | 0 | 0 | 0 | 0 | 0 | 0 |
| 9 Don't know sex | 0 | 0 | 0 | 0 | 0 | 0 |
| **Total** | **61** | **158** | **32** | **815** | **53** | **1,119** |

Totals exactly match the official 2024 NHIS Sample Adult frequency table: https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2024/Adult-codebook.pdf . The five codes are not literal sessions per week and must not be used numerically as 95–99. Code 96 represents respondents unable to participate and is a distinct substantive group, not a technical missing answer; preserve it separately for descriptive context. No coding decisions have been applied or rows removed.

**Documentation check to resolve:** The current CDC 2024 PDF's printed weekly-strengthening recode is named `STRFREQ_A`, but the student's imported `adult24.csv` column is `STRFREQW_A`. Frequency distributions match exactly. Check release-specific naming before finalizing the codebook. Proposed next decision: for an exploratory grouping, preserve three known-frequency categories `94=never`, `0=less than weekly`, `1–28=at least weekly`; hold `95–99` apart as non-standard responses pending student's approval. Preserve source data.

## NHIS participation categories — student-approved preliminary plan (2026-11-19)

The student approved a **read-only, in-memory exploratory classification** of `STRFREQW_A`: 94 = Never; 0 = Less than weekly; 1–28 = At least weekly; 95–99 = Special response, retaining their original codes separately in the raw data. No recodes, exclusions, or updates to `nhis_raw` or the ZIP have been performed yet. The classification is intended solely for descriptive comparisons and viability checks, not as an approved regression target or treatment of missingness. Use the source codes, include sex categories 7/9 in checks, and report within-sex denominators clearly. The `96 = unable` category stays distinct in the original source and must not be described as a refusal.

## NHIS preliminary strengthening activity by sex — student-reported percentages (2026-11-19)

The student supplied the **within-sex percentage table** from the approved read-only in-memory categorization of 2024 NHIS `STRFREQW_A`. The code-to-group mapping remains: 94 = Never, 0 = Less than weekly, 1–28 = At least weekly, 95–99 = Special response. No raw values overwritten.

| SEX_A | At least weekly | Less than weekly | Never | Special response |
|---|---:|---:|---:|---:|
| 1 (Male) | 40.5% | 3.2% | 52.8% | 3.5% |
| 2 (Female) | 32.3% | 2.8% | 61.6% | 3.3% |
| 7 (Sex refused) | 33.3% | 0.0% | 66.7% | 0.0% |
| 9 (Sex don't know) | 0.0% | 50.0% | 50.0% | 0.0% |

Female-minus-male: **-8.2 percentage points** for at least weekly; **+8.8 percentage points** for never. These percentages are **unweighted within recorded-sex groups**. They do not establish demand for a paid class, retention effects, or population rates. Very small sex code 7/9 groups (n=3, n=2), so do not interpret their percentages substantively.

**Outstanding acceptance check:** The student has not yet supplied the **raw counts** from `print(strength_by_sex)`. Verify exact cell counts and that they sum to n=32,629 before recording this checkpoint as fully passed. No modifications to data, no final dataset selected, no model fitted.

## NHIS preliminary strength-group count reconciliation — 2026-11-19

Student ran `addmargins(strength_by_sex)` using the previously approved **in-memory** strength categories based on `STRFREQW_A`. Exact unweighted observed counts:

| SEX_A | At least weekly (1–28) | Less than weekly (0) | Never (94) | Special response (95–99) | Total |
|---|---:|---:|---:|---:|---:|
| 1 Male | 6,062 | 482 | 7,911 | 530 | 14,985 |
| 2 Female | 5,694 | 487 | 10,869 | 589 | 17,639 |
| 7 Sex refused | 1 | 0 | 2 | 0 | 3 |
| 9 Sex unknown | 0 | 1 | 1 | 0 | 2 |
| **Total** | **11,757** | **970** | **18,783** | **1,119** | **32,629** |

Row and column sums reconcile and match earlier separate original-code frequency tables. Women's unweighted at-least-weekly percentage ≈32.3% (5,694/17,639), men's ≈40.5% (6,062/14,985); female never ≈61.6% and male never ≈52.8%. These are **unweighted sample shares** rather than nationally representative estimates; correct weighting is required for population claims. The 95–99 special responses remain segregated; zero source rows modified or discarded. Next check is read-only inspection of `AGEP_A` codes before any age-group definition or stratification.

## NHIS 2024 age coding and provisional age summary — 2026-11-19

Student's read-only R output for `AGEP_A` (n=32,629): min 18, Q1 37, median 55, mean 53.45, Q3 69, max 99; unique highest codes reported: 78–85, 97, 99. **These descriptive statistics are provisional** because 97 and 99 are non-age responses and 85 is top-coded.

Official CDC 2024 NHIS Sample Adult frequency codebook (`AGEP_A`, printed page 21; https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2024/Adult-codebook.pdf ) defines:
- 18–84: valid exact ages, published total 31,388.
- 85: 85 years or older (top coded), published total 1,189.
- 97: refused, published total 48.
- 98: not ascertained, published total 0.
- 99: don't know, published total 4.

The student's max=99 **does not mean a 99-year-old respondent**. Because 85 includes ages 85+, any revised mean based on code 85 is a top-coded approximation, not the unobserved exact population age. Check R frequencies for these five codes against published totals before approving any cleanup; no original data changed or excluded. Adult respondent survey age distributions are not equivalent to health-club-member age distributions; survey weights are needed for national estimates.

## NHIS 2024 special age codes verified — 2026-11-19

Student ran a read-only frequency table for `AGEP_A` codes 85, 97, 98, and 99 and supplied:

| AGEP_A code | Official interpretation | Observed count |
|---|---|---:|
| 85 | 85 years or older (top-coded) | 1,189 |
| 97 | Refused | 48 |
| 98 | Not ascertained | 0 |
| 99 | Don't know | 4 |

All observed counts match the CDC 2024 NHIS Sample Adult codebook counts discussed in the prior verification. Of the 32,629 imported rows, 52 (48+4) have unknown respondent age; 32,577 have `AGEP_A` 18–85, where code 85 means 85+ and not necessarily exactly 85. No data recoding, filtering, or deletion performed. **Pending student approval:** use codes 97/99 as unknown for age-specific summaries (retaining original records) and present code 85 as "85+". Do not interpret the original 99 maximum as an observed age or treat 85 as exact 85 in age means.

## NHIS age-handling decision approved — 2026-11-19

The student explicitly approved, for **temporary age-specific summaries only**, treating `AGEP_A` values **18–84** as recorded ages, **85** as the grouped category **85 years or older**, and **97 / 99** as unknown ages excluded from age-specific comparisons. Code **98** has no observed records. All **32,629** raw observations remain intact; no change to the source file, no processed file created, and no automatic changes to outcome variables. Exactly **32,577** survey records have a valid age code from 18 through 85; this includes 1,189 top-coded 85+ respondents. Subsequent age summaries must not treat 85 as an exact age for calculating a true mean, or interpret 99 as age 99. When comparing recorded sex groups, keep clear that SEX_A = 1 means Male, 2 means Female and 7/9 are nonresponse, not male/female.

## NHIS usable-age distribution by respondent sex — 2026-11-19

User ran the read-only approved selection `valid_age_sex <- nhis_raw$AGEP_A %in% 18:85 & nhis_raw$SEX_A %in% c(1,2)` and reported the following unweighted distribution summaries (with age code 85 meaning **85+**, not exactly 85):

| Sex | Usable observations | Q1 | Median | Q3 |
|---|---:|---:|---:|---:|
| Male (SEX_A=1) | 14,963 | 36 | 53 | 68 |
| Female (SEX_A=2) | 17,609 | 38 | 56 | 70 |
| Total | 32,572 | — | — | — |

Subtracting from original sex counts confirms 22 male and 30 female observations had unusable age codes; 52 age unknown overall, plus 5 with unknown sex, consistent with 32,629 - 32,572 = 57. The friend's club reports medians of 48 (men) and 46 (women), so the NHIS sample's medians are older by 5 and 10 years respectively; the Sport Services adult female median is 24. Populations and age recording contexts differ, so these contrasts **do not establish either dataset represents the business**. No cleaning or saved subsets occurred. Next planned diagnostic: characterize women's strengthening participation across age groups, with the student's approval of age-group boundaries first.


## Provisional company-aligned NHIS age bands approved — 2026-11-19

Student explicitly approved using these **temporary five age bands** for NHIS age-stratified exploratory analysis: **18–24, 25–34, 35–44, 45–54, 55+**. This is based on the business contact's age table with original overlapping labels **45–59** and **55+**. The student assumes 45–54 is intended and will request confirmation. Keep the company's raw summary as supplied; the temporary analytical categorization must not overwrite NHIS's `AGEP_A` or any original data.

Maintain previously approved handling: 18–84 as literal ages, 85 as **85+**, and 97/99 as unknown for age-specific comparisons only. Codes for unknown reported sex (SEX_A 7/9) should remain separately visible in audit counts, not interpreted as male/female. R code should create age groups **in memory** and verify counts before comparing strength participation across groups. Company member counts are aggregate observations and should never be joined as though NHIS respondents are those members.

## NHIS company-aligned provisional age bands × sex — 2026-11-19

Student ran `table(Age_Group = nhis_age_group, Sex = nhis_raw$SEX_A, useNA = "ifany")` for the agreed provisional categories. Observed values:

| Age group | Male (1) | Female (2) | Sex refused (7) | Sex don't know (9) | Full group total |
|---|---:|---:|---:|---:|---:|
| 18–24 | 1,024 | 982 | 1 | 1 | 2,008 |
| 25–34 | 2,220 | 2,454 | 1 | 1 | 4,676 |
| 35–44 | 2,385 | 2,671 | 1 | 0 | 5,057 |
| 45–54 | 2,085 | 2,361 | 0 | 0 | 4,446 |
| 55+ | 7,249 | 9,141 | 0 | 0 | 16,390 |
| Unknown age | 22 | 30 | 0 | 0 | 52 |
| **Total** | **14,985** | **17,639** | **3** | **2** | **32,629** |

All 32,629 observations accounted for; 32,577 valid age-band codes, 52 with special age values. Female usable-age n=17,609, male usable-age n=14,963. No changes to the source data; `nhis_age_group` remains an in-memory categorical vector. Source company-provided age distribution uses all club memberships; do not directly equate to female-only NHIS subgroup. Original company reported 45–59 and 55+ overlap; student's 45–54 interpretation remains explicitly provisional. Survey data unweighted.

**Next read-only question:** Tabulate the existing approved strength-category vector for female respondents by `nhis_age_group`, including unknown ages; verify counts before computing conditional percentages.

## Female NHIS strength-training response categories by provisional business age bands — 2026-11-19

User supplied the read-only R `addmargins(female_strength_by_age)` table, using previously approved temporary strength categories (94 never; 0 less than weekly; 1–28 at least weekly; 95–99 special) and provisional company age bands (18–24;25–34;35–44;45–54;55+). Unknown age stays visible.

| Provisional age band | At least weekly | Less than weekly | Never | Special response | Total |
|---|---:|---:|---:|---:|---:|
| 18–24 | 398 | 62 | 499 | 23 | 982 |
| 25–34 | 1,017 | 122 | 1,229 | 86 | 2,454 |
| 35–44 | 1,077 | 107 | 1,411 | 76 | 2,671 |
| 45–54 | 824 | 66 | 1,401 | 70 | 2,361 |
| 55+ | 2,368 | 130 | 6,314 | 329 | 9,141 |
| Unknown age | 10 | 0 | 15 | 5 | 30 |
| **Total** | **5,694** | **487** | **10,869** | **589** | **17,639** |

Column totals match earlier female counts exactly. Unweighted at-least-weekly fractions of *all* women in each known age band (including special response cases in denominators) are approximately 40.5%, 41.4%, 40.3%, 34.9%, and 25.9%, respectively. These are exploratory percentages, not survey-weighted national population estimates. The 45–54 analytical category remains a **student-approved provisional correction** to the operator's overlapping reported labels; do not present it as officially confirmed.

Next: compute entire within-age-group percent table in R from `female_strength_by_age` using `prop.table(..., margin=1)`, showing no claims of program demand or effectiveness. The eventual report should use NHIS survey weights and acknowledge general population versus health-club membership differences. No original NHIS data edited or processed file written.

## Female weekly strengthening percentages by company-aligned age groups — 2026-11-19

Student ran `round(prop.table(female_strength_by_age, margin=1)*100, 1)` on previously approved **in-memory**, unweighted NHIS 2024 strength categories; supplied:

| Age group | At least weekly | Less than weekly | Never | Special response |
|---|---:|---:|---:|---:|
| 18–24 | 40.5% | 6.3% | 50.8% | 2.3% |
| 25–34 | 41.4% | 5.0% | 50.1% | 3.5% |
| 35–44 | 40.3% | 4.0% | 52.8% | 2.8% |
| 45–54 | 34.9% | 2.8% | 59.3% | 3.0% |
| 55+ | 25.9% | 1.4% | 69.1% | 3.6% |
| Unknown age | 33.3% | 0.0% | 50.0% | 16.7% |

Within-group percentages agree with prior exact counts; small deviations from 100% come from rounding. The weekly participation percentage gap between women aged 25–34 and 55+ is 15.5 percentage points (41.4 vs 25.9); never-participation gap is 19.0 percentage points (69.1 vs 50.1). Because these are unweighted sample percentages and include special responses in the denominators, do not present them as US prevalence. These rates do not measure fitness club membership, demand for paid introductory classes, or member retention. Age bands are provisional: business source originally said 45–59 and 55+, with overlap; 45–54 is a student-approved working correction. No raw data modified. The next stage is a read-only scan for independent candidate predictors and two outcome targets before assessing the professor's |r| ≈ 0.20 requirement.
