# Wrangling log

| Step number | What changed | Why / student's approval | Rows before | Rows after | Script |
|---|---|---|---|---|---|
| 01 — script committed (execution pending) | Approved plan: read the three unchanged NHIS Sample Adult ZIPs, select original 12 columns (HHX, SRVY_YR, SEX_A, AGEP_A, STRFREQW_A, MODFREQW_A, VIGFREQW_A, MODMIN_A, VIGMIN_A, WTFA_A, PSTRAT, PPSU), append whole rows, verify values and year+HHX composite IDs, save only processed RDS. **No recoding or filtering**. Not yet run in student's local RStudio. | Student explicitly approved structure and execution, 2026-11-19; no raw files or GitHub data uploads. | 2020: 31,568; 2022: 27,651; 2024: 32,629 (previously verified) | **Expected 91,848; not yet locally observed** | [scripts/01_harmonize_nhis.R](../scripts/01_harmonize_nhis.R) |
