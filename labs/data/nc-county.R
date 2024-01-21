library(tidycensus)
library(tidyverse)
library(tigris)

us_county_raw <- get_decennial(
  geography = "county",
  variables = "P1_001N",
  year = 2020,
  geometry = TRUE,
  keep_geo_vars = TRUE
)

us_county <- us_county_raw |>
  mutate(
    land_area_mi2 = ALAND / 2589988.11,
    density = value / land_area_mi2
  ) |> #m2 ÷ 2,589,988.11 = mi2
  rename(
    county = NAME.x,
    state_abb = STUSPS,
    state_name = STATE_NAME,
    land_area_m2 = ALAND,
    population = value
  ) |>
  select(county, state_abb, state_name, land_area_m2, land_area_mi2, population, density) |>
  st_drop_geometry()

nc_county <- us_county |>
  filter(state_abb == "NC")

ggplot(nc_county, aes(x = land_area_mi2, y = density)) +
  geom_point()

write_csv(nc_county, file = here::here("labs/data", "nc-county.csv"))
