library(readxl)
library(dplyr)
library(openxlsx)
library(lubridate)

#### 1 ####
date_formats_vec <- c("11.05.2024", "05.21.2024", "2024-05-11", "2024-05-21", "2024/05/11", "2024.05.21", "05.2024", 
                      "2023.05", "21 Apr 2022")
set.seed(123)
patient_vec <- sample(100:500, 9)

dates_df <- data.frame(
  patient_id = patient_vec,
  date = date_formats_vec
)

parsed_dates <- parse_date_time(
  dates_df$date,
  orders = c("dmy", "mdy", "ymd", "my", "ym", "d b Y"),
  exact = FALSE
)

dates_df <- dates_df %>%
  mutate(date = format(parsed_dates, "%d.%m.%Y"))

dates_df

#### 2 ####
comp_dat <- readxl::read_xlsx("Trials_Reliant tool for study duration NEW.xlsx", sheet = "CompDat")

dates_raw <- comp_dat$`Completion Date`

clean_dates <- comp_dat %>%
  rename(raw_date = `Completion Date`) %>% 
  mutate(
    cleaned = case_when(
      grepl("^\\d{5}$", raw_date) ~ as.character(as.Date(as.numeric(raw_date), origin = "1899-12-30")), # Excel serial
      grepl("^\\d{4}-\\d{2}$", raw_date) ~ paste0(raw_date, "-01"),                                     # YYYY-MM → YYYY-MM-01
      grepl("^\\d{2}\\.\\d{4}$", raw_date) ~ paste0("01.", raw_date),                                   # MM.YYYY → 01.MM.YYYY
      grepl("^\\d{4}\\.\\d{2}$", raw_date) ~ paste0(raw_date, ".01"),                                   # YYYY.MM → YYYY.MM.01
      TRUE ~ raw_date
    ),
    parsed_date = parse_date_time(cleaned, orders = c("d.m.y", "Y-m-d", "d B Y", "Y.m.d"), exact = FALSE),
    final_date = format(parsed_date, "%d.%m.%Y")
  )



#### 3 ####
# Convert Excel serial number to Date in R
excel_to_date <- function(serial_num) {
  origin <- as.Date("1899-12-30")
  as.Date(serial_num, origin = origin)
}

# Convert Date to Excel serial number
date_to_excel <- function(date) {
  origin <- as.Date("1899-12-30")
  as.numeric(as.Date(date) - origin)
}
# Excel serial to Date
excel_to_date(42998)
# [1] "2017-09-20"

# Date to Excel serial
date_to_excel("2017-09-20")
# [1] 42998


#Smallest 5-digit serial = 10000
as.Date(10000, origin = "1899-12-30")
# [1] "1927-05-18"

#Largest 5-digit serial = 99999
as.Date(99999, origin = "1899-12-30")
# [1] "2173-10-16"