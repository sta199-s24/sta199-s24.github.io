# load packages ----------------------------------------------------------------

library(tidyverse)

# prep data --------------------------------------------------------------------

income_alcohol <- tribble(
  ~income,             ~alcohol, ~n,
  "$75,000 or more",   "Beer",   110,
  "$75,000 or more",   "Wine",   116,
  "$75,000 or more",   "Liquor", 80,
  "$30,000 - $74,999", "Beer",   213,
  "$30,000 - $74,999", "Wine",   161,
  "$30,000 - $74,999", "Liquor", 126,  
  "Less than $30,000", "Beer",   83,
  "Less than $30,000", "Wine",   67,
  "Less than $30,000", "Liquor", 44
) |>
  uncount(weights = n) |>
  mutate(
    income = fct_relevel(income, "Less than $30,000", "$30,000 - $74,999", "$75,000 or more"),
    alcohol = fct_relevel(alcohol, "Beer", "Wine", "Liquor")
  )

write_rds(income_alcohol, here::here("exam-review", "data/income-alcohol.rds"))
