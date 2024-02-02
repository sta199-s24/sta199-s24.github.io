# load packages ----------------------------------------------------------------

library(tidyverse)

# data prep for country inflation / pivot --------------------------------------

# data source: https://stats.oecd.org

country_inflation_long <- read_csv("labs/data/KEI_02022024035830117.csv.csv") |>
  select(Country, Time, Value) |>
  rename(
    country = Country,
    year = Time,
    annual_inflation = Value
    )

country_inflation_wide <- country_inflation_long |>
  pivot_wider(
    id_cols = country,
    names_from = year,
    values_from = annual_inflation
  )

write_csv(country_inflation_wide, "labs/data/country-inflation.csv")

# data prep for us inflation / join --------------------------------------------

us_inflation_raw <- read_csv("labs/data/PRICES_CPI_19092022031404285.csv")

us_inflation_temp <- us_inflation_raw |>
  filter(Measure == "Percentage change on the same period of the previous year") |>
  select(Country, Subject, Time, Value) |>
  janitor::clean_names() |>
  rename(
    year = time,
    annual_inflation = value
    ) |>
  filter(
    subject != "CPI: 01-12 - All items",
    str_detect(subject, "CPI: [0-9][0-9] "),
    year >= 2011
    ) |>
  mutate(subject = str_remove(subject, "CPI: ")) |>
  separate(subject, sep = " - ", into = c("subject_id", "subject_description")) |>
  mutate(subject_id = as.numeric(subject_id)) |>
  rename(
    cpi_division_id = subject_id,
    cpi_division_description = subject_description
  )

us_inflation <- us_inflation_temp |>
  select(country, cpi_division_id, year, annual_inflation) |>
  arrange(cpi_division_id, year)

cpi_divisions <- us_inflation_temp |>
  distinct(cpi_division_id, cpi_division_description) |>
  arrange(cpi_division_id) |>
  rename(
    id = cpi_division_id,
    description = cpi_division_description
  )

write_csv(us_inflation, "labs/data/us-inflation.csv")
write_csv(cpi_divisions, "labs/data/cpi-divisions.csv")

# join: join other inflation indices for the US --------------------------------

us_inflation <- read_csv("labs/data/us-inflation.csv")
cpi_divisions <- read_csv("labs/data/cpi-divisions.csv")

