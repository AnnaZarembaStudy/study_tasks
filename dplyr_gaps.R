library("medicaldata")
library("dplyr")

data(package = "medicaldata")
data <- medicaldata::esoph_ca                            
data1 <- medicaldata::cytomegalovirus                     

data_mod <- data %>% 
  group_by(alcgp) %>% 
  arrange(desc(agegp)) %>% 
  filter(ncases > 0)

data1_mod <- data1 %>% 
  mutate(ID, age, sex, race, 
         diagnosis = case_when(
           diagnosis == "acute myeloid leukemia" ~ "aml",
           diagnosis == "non-Hodgkin lymphoma" ~ "nhl",
           TRUE ~ diagnosis 
  ),
  .keep = "none")
