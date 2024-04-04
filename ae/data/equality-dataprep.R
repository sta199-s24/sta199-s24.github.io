# load packages –---------------------------------------------------------------

library(tidyverse)
library(janitor)
library(knitr)

# make data –-------------------------------------------------------------------

# https://c7p4g5i9.rocketcdn.me/wp-content/uploads/2023/09/Meredith-Poll-Report-September-2023.pdf

age <- c(
  rep("18-24", 71),
  rep("25-40", 220),
  rep("41-56", 218),
  rep("57-75", 230),
  rep("76+", 61),
  rep("Prefer not to say", 1)
)

"Most changes done" <- "The country has made most of the changes needed to give women equal rights with men."
"Need more changes" <- "The country needs to continue to make changes to give women equal rights to men."
"C" <- "Don't know"

response <- c(
  rep("Most changes done", round(71*.451, 0)),  rep("Need more changes", round(71*.493, 0)),  rep("C", round(71*.056, 0)),
  rep("Most changes done", round(220*.377, 0)), rep("Need more changes", round(220*.555, 0)), rep("C", round(220*.068, 0)),
  rep("Most changes done", round(218*.248, 0)), rep("Need more changes", round(218*.642, 0)), rep("C", round(218*.11, 0)),
  rep("Most changes done", round(230*.278, 0)), rep("Need more changes", round(230*.648, 0)), rep("C", round(230*.074, 0)),
  rep("Most changes done", round(61*.164, 0)),  rep("Need more changes", round(61*.639, 0)),  rep("C", round(61*.197, 0)),
  rep("Most changes done", 1*0), rep("Need more changes", 1*1), rep("C", 1*0)
)

equal_rights_raw <- tibble(age, response)

# check –-----------------------------------------------------------------------

equal_rights_raw |>
  tabyl(age, response) |>
  adorn_totals("col") |>
  adorn_percentages("row") |>
  kable(digits = 3)

# filter to make 2x2 table from responses –-------------------------------------

equal_rights <- equal_rights_raw |>
  filter(
    age != "Prefer not to say",
    response != "C"
  ) |>
  mutate(age = if_else(age == "18-24", "18-24", "25+"))

# check –-----------------------------------------------------------------------

equal_rights |>
  tabyl(age, response) |>
  adorn_totals("col") |>
  adorn_percentages("row") |>
  kable(digits = 3)

# write data to file –----------------------------------------------------------

write_csv(equal_rights, here::here("ae", "data/equality.csv"))
