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
