# BUAN 314-370 project collaboration rules

- R is the chosen language for analysis. Do not silently switch languages.
- All analysis results must be reproducible from numbered R scripts, with relative paths and explicit package versions.
- Never change the content of files in data/raw.
- Do not clean, remove, recode, or impute any data without obtaining the student's approval for the specific decision first.
- Distinguish observed evidence from hypotheses, simulations and scenario assumptions.
- Use verified data dictionaries; mark unsupported definitions UNDOCUMENTED rather than guessing.
- Each prompt should have context, ask, constraints, and verify. Log each interaction in documentation/prompt_log.md when editing this repository.
- For data changes, log rows before/after and decisions in documentation/wrangling_log.md; update documentation/codebook.md for changed or new variables.
- Keep exploratory analysis and report numbers tied to source tables. Include group counts.
- Use only ordinary linear regression, including the linear probability model for the binary target, as the assignment specifies. Do not split the sample or automatically select predictors.
- Only the student writes substantive interpretations, recommendations, and postmortem judgments; assist with checks, code and formatting.
- Never commit secrets, personal identifiers, or unlicensed redistribution of data.
- Ask before changing a software setup, deleting a file, or publishing sensitive material.
- Static report: LaTeX source compiled in Overleaf. HTML report: one standalone offline HTML/CSS/JS file, no external assets.
