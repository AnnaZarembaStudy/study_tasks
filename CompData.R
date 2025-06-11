library(readxl)
library(dplyr)
library(openxlsx)

params <- readxl::read_xlsx("Trials_Reliant tool for study duration.xlsx", sheet = "Parameters STD AZ") %>% 
  select(-2)
comp_dat <- readxl::read_xlsx("Trials_Reliant tool for study duration.xlsx", sheet = "CompDat")

# join to params from comp_dat column Completion Date by NCT number
joined_dat <- comp_dat %>%
  left_join(params, by = "NCT Number") %>% 
  mutate(`Completion Date` = as.character(`Completion Date`)) %>% 
  #organise by date
  arrange(desc(`Completion Date`))

# save
write.xlsx(joined_dat, "joined_comp_data.xlsx", row.names = FALSE)


unique(joined_dat$`Control description`)
unique(joined_dat$`Weight assessment`)