# Project proposal

**Working title:** Health Club Service and Customer Demand Analysis  
**Status:** Preliminary; awaiting health-club operator's five-question interview.

## Current context
A full-service health-club operator may wish to prioritize fitness and wellness services for different customer groups. The student selected the fitness/wellness-services direction as a tentative priority. No final decision, geographic scope, dataset, prediction targets, or numerical findings have been approved.

## Three problem statements
| Type | Student-approved problem statement | Outcome / units | Scope / one row | Status |
|---|---|---|---|---|
| Descriptive | Pending | Pending | Pending | Not drafted |
| Predictive: numeric and binary targets | Pending | Pending | Pending | Not drafted |
| Prescriptive | Pending | Pending | Pending | Not drafted |

## Dataset candidate scorecard
| Source | Access | License | Relevance | Granularity | Size | Variable mix | Correlation | Documentation | Provenance | Privacy | Room to grow | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Not yet selected | | | | | | | | | | | | |

**Note:** Do not claim that a dataset meets the assignment requirements before inspecting a downloaded source, documentation, and target correlations.

## Preliminary feasibility comparison — 2026-11-18

**Status:** Source candidates identified, neither fully validated. The public research focus is retention improvement through targeted wellness programming. No private business figures included.

| Option | Original source | Published data structure | Numeric outcome candidate | Binary outcome candidate | Unverified checks |
|---|---|---|---|---|---|
| Women's strengthening habits | [2024 NHIS adult survey](https://www.cdc.gov/nchs/nhis/documentation/2024-nhis.html) | 32,629 adults in full public-use sample; `STRFREQ_A` documented | Times per week doing strength activity, with special missing/never codes handled correctly | Separate aerobic activity category or guideline outcome, not a mechanical copy of strength frequency | Female sample, variable types, target correlations, survey weights, viability |
| Member retention | [Sport Services Dataset v1](https://data.mendeley.com/datasets/yprk4jdgnv/1), [publisher article](https://pmc.ncbi.nlm.nih.gov/articles/PMC8100056/) | 14,942 real user records; 45 documented attributes; Lisbon 2014–2019, CC BY 4.0 | Average attendance or classes per week (subject to timing checks) | `Dropout` True/False | Actual downloadable file inspection, correlation, timing leakage, population transfer |

**Important:** Published sports-facility data include variables computed over the entire enrollment or final two months. Do not use these to predict an earlier event. Age is recorded at endpoint rather than signup. Some activity descriptions in the paper appear inconsistent; confirm categories from the source and actual file. No association establishes that an untested program prevents churn.

**ATUS:** The student has five 2025 ATUS source files stored locally in `data/raw` and began read-only ZIP inspection. Those files remain available but are not yet the chosen project data.


## Provisional alignment to operator's average membership age distribution — 2026-11-19

The club contact provided the following **average per-club** membership summary. These figures are company-provided context and must not be represented as NHIS observations or publicly verified national estimates:

| Supplied age-band label | Average members per club | Supplied share |
|---|---:|---:|
| 18–24 | 348 | 5% |
| 25–34 | 1,005 | 16% |
| 35–44 | 1,208 | 19% |
| 45–59 | 1,701 | 26% |
| 55+ | 2,206.5 | 34% |
| Total | 6,468.5 | 100% |

**Original labels overlap at 55–59.** The student explicitly approved **provisional analytical bands** 18–24, 25–34, 35–44, **45–54**, and 55+ on 2026-11-19, pending confirmation by the business contact. The 45–54 band is an assumption, **not an edit to the source summary**. Do not silently change or conflate original and provisional descriptions. When confirmed, update the grouping code and rerun affected counts, charts and comparisons.

For NHIS, the 55+ analytical band includes code 85 (top-coded 85+), but excludes AGEP_A 97/99 (unknown). The company summary is aggregate context only; do not merge it row-by-row into NHIS. No dataset selected or modeled.

## NHIS release recency and potential longitudinal comparison (research note, 2026-11-19)

**New official verification:** The latest **public-use NHIS survey year is 2025**, announced by NCHS on Sept. 30, 2026 (https://www.cdc.gov/nchs/blog/bulletin/new-2025-national-health-interview-survey-public-use-files.html); the 2025 adult dataset contains **24,215** published records (https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2025/Checksum-filelist.pdf). But the detailed physical activity and muscle-strengthening questionnaire is **rotating core**, administered in **2020, 2022, 2024** (and scheduled for 2026, without a complete public-use 2026 annual release as of Nov. 19, 2026). Survey schedule: https://www.cdc.gov/nchs/data/nhis/Sample-Adult-Questionnaire.pdf ; IPUMS NHIS STRONGFTP availability: https://nhis.ipums.org/nhis-action/variables/STRONGFTP .

**Candidate extension (not yet approved):** Analyze the comparable strengthening outcome in 2020, 2022, and 2024 in year-specific, provisional company age bands for women and men, to distinguish age group differences from change over time. For a minimum-complexity comparison, start with **2022 and 2024** and consider **2020 as longer-run pandemic-era context**, noting disrupted exercise patterns and possible changes in survey collection. The NHIS redesign in 2019 makes pre-2019 comparisons inappropriate without explicit reconciliation. Do not claim a trend from one year or treat the year as a continuous balanced respondent panel: these are independent cross-sections, not the same members tracked over time.

**Technical safeguards:** verify comparable question wording, variable definitions and special codes across years before combining any rows. Survey weights (e.g. WTFA_A), strata and clusters are essential for national prevalence and inference; age-specific percentages calculated earlier are unweighted pilot checks. For multi-year descriptive trends, calculate **separate weighted estimates for each year**, not a simple average of raw respondents. Pooling years for a model requires its own weights/design decisions and compatible predictors; this is not yet approved. Any time-trend finding remains about activity among U.S. adults, not about membership retention or interest in buying the club's program.

**Status:** 2024 downloaded and inspected. 2020 and 2022 files not yet downloaded. No years chosen and no models fitted.

## Multiyear NHIS feasibility scope approved — November 19, 2026

The student explicitly approved investigating **2020, 2022, and 2024** for a repeated-cross-section trend study of strengthening activity, **without yet selecting the final dataset or combining years**. Begin by checking the 2022 sample-adult codebook and raw file. Preserve the already approved (provisional) age bands 18–24, 25–34, 35–44, 45–54, 55+, with 45–54 pending confirmation from the business contact. Do not imply these survey respondents are the club's members.

Official CDC sources:
- 2022 NHIS annual documentation: https://www.cdc.gov/nchs/nhis/documentation/2022-nhis.html
- 2022 Sample Adult codebook: https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2022/adult-codebook.pdf
- 2022 Sample Adult CSV archive: https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHIS/2022/adult22csv.zip
- 2020 NHIS annual documentation: https://www.cdc.gov/nchs/nhis/documentation/2020-nhis.html

The official 2022 codebook documents **`STRFREQW_A`**, frequency of strengthening physical activity (times per week), with codes `0` = less than once weekly; `1–28` = sessions per week; `94` = never; and `95–99` = special responses. Publisher's counts: **27,651** adults, including 802 less-than-weekly, 9,523 weekly numeric, 16,228 never, 60 extreme, 177 unable, 24 refused, 789 not ascertained, 48 don't know. These coding categories match the **code values and descriptions** in the 2024 codebook (whose printed variable label is `STRFREQ_A` while the imported 2024 CSV used `STRFREQW_A`). Exact question wording, year-specific weighting, and consistency of candidate regression predictors are not yet fully checked, so treat cross-year comparability as provisional. Survey trends require survey weights and design-aware estimates; 2020 had pandemic-era changes and a revised adult file. The 2022 dataset has not yet been downloaded or inspected by the student.

## Provisional binary outcome approved — November 19, 2026

The student selected **at least twice weekly muscle-strengthening activity** as a candidate binary classification target for NHIS feasibility analysis, using `STRFREQW_A` in the 2024 Sample Adult file. Code **1** (yes): 2–28 times/week. Code **0** (no): 94 never, 0 less than weekly, and 1 once weekly. Codes 95–99: `NA` in the candidate binary model only; the original response categories remain separate for descriptive analysis, including inability to participate (96). This is an **approved preliminary outcome**, not yet the final modeling target or a commitment to NHIS. The target must be screened against **independently measured predictors**, and the second **numeric regression target** remains unselected. The original files remain unchanged and RStudio operations will be in memory until an explicit cleaning plan is approved.

## Numeric regression outcome screening plan — 2026-11-19

The student approved retaining **both** `MODMIN_A` (reported moderate-activity duration per activity occasion, minutes) and `VIGMIN_A` (vigorous-activity duration, same units) as **candidate numeric targets** during feasibility testing. Neither is selected as the required final regression outcome. The binary candidate remains twice-weekly strength training (coded from `STRFREQW_A`). The student favors separate numeric and binary outcomes drawn from the same original NHIS sample rather than mechanically defining both from a single source measure.

Next screening uses valid duration values `1:720` and independently measured preexisting activity indicators (`strength_twice_weekly`, `moderate_weekly`, `vigorous_weekly`). Record pairwise complete-case sample sizes, do not treat special codes as minutes, and do not use a derived duplicate of the numeric target to satisfy correlation requirements. The two duration questions have different eligible populations and must not be mislabeled as total weekly minutes. No modifications to raw data and no modeling yet.

## Three-year NHIS append structure approved — November 19, 2026

Student explicitly approved the **proposed structure subject to final checks**, **not** execution of a row append or writing a processed dataset. Preserve **91,848 original responses** across 2020, 2022, and 2024; retain previously verified 10 source columns (`SEX_A`, `AGEP_A`, `STRFREQW_A`, `MODFREQW_A`, `VIGFREQW_A`, `MODMIN_A`, `VIGMIN_A`, `WTFA_A`, `PSTRAT`, `PPSU`), an audit key, year identifier, and approved analysis-only age/strength participation groupings. Retain ZIP archives untouched and save any processed output separately after explicit approval.

**Further source review:** CDC's [2020 NHIS documentation](https://www.cdc.gov/nchs/nhis/documentation/2020-nhis.html) indicates the *2020 Sample Adult Interview* file is appropriate for 2020 estimates and trend analyses and records pandemic-era telephone collection and lower response rates. CDC codebooks for [2020](https://ftp.cdc.gov/pub/health_statistics/nchs/dataset_documentation/NHIS/2020/Adult-codebook.pdf), [2022](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2022/adult-codebook.pdf), [2024](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2024/adult-codebook.pdf) support common strengthening-frequency definitions; survey questionnaire wording and pool-specific design treatment still deserve final checks. The codebooks indicate an existing `SRVY_YR` (survey year) field; **verify R-imported annual values before adding a redundant new year column**. Survey estimates should be calculated separately with each year's annual `WTFA_A` weights and design settings; do not simply reuse stratum/PSU IDs across years in a pooled design. The assembled table should not be treated as a panel of the same respondents. No combining has occurred.
