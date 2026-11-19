# BUAN 314-370: NHIS multi-year harmonization
# Script 01: append original NHIS Sample Adult records (2020, 2022, 2024)
# Student approved this exact operation on 2026-11-19.
#
# Run from the RStudio project's root directory:
#   source("scripts/01_harmonize_nhis.R")
#
# R version used in the project: 4.6.1. Only base/recommended R is required.
# Raw files are never overwritten. This script does not recode, filter, impute,
# or model survey responses; it keeps only the explicitly approved source fields.
# These are independent annual cross-sections, not a respondent panel.
# This append does not by itself specify a valid pooled survey design.

raw_dir <- file.path("data", "raw", "nhis")
processed_dir <- file.path("data", "processed")
output_file <- file.path(processed_dir, "nhis_2020_2022_2024_combined.rds")

archives <- c(
  "2020" = "adult20csv.zip",
  "2022" = "adult22csv.zip",
  "2024" = "adult24csv.zip"
)

expected_counts <- c("2020" = 31568L, "2022" = 27651L, "2024" = 32629L)

# The ten approved modeling/design columns, plus original ID and survey year.
selected_columns <- c(
  "HHX", "SRVY_YR",
  "SEX_A", "AGEP_A",
  "STRFREQW_A", "MODFREQW_A", "VIGFREQW_A",
  "MODMIN_A", "VIGMIN_A",
  "WTFA_A", "PSTRAT", "PPSU"
)

if (!dir.exists(raw_dir)) {
  stop("Raw NHIS folder not found. Open the project root in RStudio: ", raw_dir)
}
if (file.exists(output_file)) {
  stop("Processed output already exists; refusing to overwrite: ", output_file)
}

read_sample_adult_zip <- function(year) {
  zip_path <- file.path(raw_dir, archives[[year]])

  if (!file.exists(zip_path)) {
    stop("Missing required source archive: ", zip_path)
  }

  archive_contents <- utils::unzip(zip_path, list = TRUE)$Name
  csv_names <- archive_contents[grepl("\\.csv$", archive_contents,
                                      ignore.case = TRUE)]

  if (length(csv_names) != 1L) {
    stop("Expected exactly one CSV in ", zip_path,
         "; found ", length(csv_names), ". Inspect this archive before proceeding.")
  }

  connection <- unz(zip_path, csv_names[[1]])
  on.exit(close(connection), add = TRUE)

  # Force HHX to remain text; let other original CSV fields keep their
  # read.csv-detected types. No values are recoded.
  source_data <- utils::read.csv(
    connection,
    stringsAsFactors = FALSE,
    check.names = FALSE,
    colClasses = c(HHX = "character")
  )

  missing_columns <- setdiff(selected_columns, names(source_data))
  if (length(missing_columns) > 0L) {
    stop(year, " missing required column(s): ",
         paste(missing_columns, collapse = ", "))
  }

  chosen <- source_data[, selected_columns, drop = FALSE]

  if (nrow(chosen) != expected_counts[[year]]) {
    stop(year, " row count unexpected: ", nrow(chosen),
         " (expected ", expected_counts[[year]], ")")
  }
  if (anyNA(chosen$SRVY_YR) ||
      !all(chosen$SRVY_YR == as.integer(year))) {
    stop(year, " has missing or mismatched survey-year identifiers")
  }
  if (!is.character(chosen$HHX) || anyNA(chosen$HHX) ||
      any(chosen$HHX == "") || anyDuplicated(chosen$HHX) > 0L) {
    stop(year, " HHX missing, duplicated, or not stored as text")
  }
  if (anyNA(chosen$WTFA_A) || any(chosen$WTFA_A <= 0)) {
    stop(year, " has missing or nonpositive survey weights")
  }
  if (anyNA(chosen$PSTRAT) || anyNA(chosen$PPSU)) {
    stop(year, " has missing survey stratum or PSU identifiers")
  }

  cat("Validated ", year, ": ", nrow(chosen), " source rows\n", sep = "")
  chosen
}

# Re-import from untouched original archives, with no dependence on
# in-memory nhis20_raw, nhis22_raw, or nhis_raw objects.
source_tables <- lapply(names(archives), read_sample_adult_zip)
names(source_tables) <- names(archives)

# Append in ascending survey-year order; keep all original source values.
nhis_combined <- do.call(rbind, unname(source_tables))
row.names(nhis_combined) <- NULL

# Verify total counts and composite respondent keys.
observed_counts <- table(factor(nhis_combined$SRVY_YR,
                                levels = as.integer(names(expected_counts))))
if (nrow(nhis_combined) != sum(expected_counts) ||
    !identical(as.integer(observed_counts), unname(expected_counts))) {
  stop("Combined row count or survey-year breakdown failed verification")
}

composite_ids <- paste(nhis_combined$SRVY_YR, nhis_combined$HHX, sep = "_")
if (anyNA(composite_ids) || anyDuplicated(composite_ids) > 0L) {
  stop("Combined SRVY_YR + HHX identifiers are missing or duplicated")
}

# Check that appending did not change any value in any selected column.
first_row <- 1L
for (year in names(source_tables)) {
  annual_table <- source_tables[[year]]
  final_row <- first_row + nrow(annual_table) - 1L
  combined_slice <- nhis_combined[first_row:final_row, , drop = FALSE]

  for (variable in selected_columns) {
    if (!identical(combined_slice[[variable]], annual_table[[variable]])) {
      stop("Source-value verification failed for ", year, ": ", variable)
    }
  }
  first_row <- final_row + 1L
}

# Create only the processed output folder, and never overwrite an output.
if (!dir.exists(processed_dir)) {
  dir.create(processed_dir, recursive = TRUE, showWarnings = FALSE)
}
if (file.exists(output_file)) {
  stop("Processed output already exists; refusing to overwrite: ", output_file)
}

saveRDS(nhis_combined, file = output_file, compress = "gzip")

# Verify the saved file is readable and has the expected structure.
saved <- readRDS(output_file)
if (!identical(saved, nhis_combined)) {
  stop("Saved file does not match the verified in-memory combined table")
}

cat("\nPASS: NHIS append completed and verified\n")
print(data.frame(
  SurveyYear = as.integer(names(expected_counts)),
  Expected_Rows = unname(expected_counts),
  Observed_Rows = as.integer(observed_counts),
  row.names = NULL
))
cat("Total_Rows: ", nrow(saved), "\n", sep = "")
cat("Duplicate_Year_HHX_IDs: ", sum(duplicated(composite_ids)), "\n", sep = "")
cat("Selected_Columns: ", ncol(saved), "\n", sep = "")
cat("Saved_To: ", output_file, "\n", sep = "")
cat("Raw ZIP files unchanged; no filters, recodes, or imputation applied.\n")
