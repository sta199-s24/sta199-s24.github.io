# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

# check that we can scrape data from the chronicle -----------------------------

paths_allowed("https://www.dukechronicle.com")

# read page --------------------------------------------------------------------

page <- ___("https://www.dukechronicle.com/section/opinion?page=1&per_page=500")

# parse components -------------------------------------------------------------

titles <- page |>
  html_elements(".headline a") |>
  html_text()

columns <- page |>
  html_elements("___") |>
  ___

abstracts <- page |>
  ___("___") |>
  ___

authors_dates <- page |>
  html_elements("___") |>
  html_text2() |>
  ___

urls <- page |>
  html_elements(".headline a") |>
  html_attr(name = "___")

# create a data frame ----------------------------------------------------------

chronicle_raw <- tibble(
  title = titles,
  author_date = authors_dates,
  abstract = abstracts,
  column = columns,
  url = urls
)

# clean up data ----------------------------------------------------------------

chronicle <- chronicle_raw |>
  # separate author_date into author and date
  ___
  # trim white space in author names
  # fix dates and their type
  ___

# write data -------------------------------------------------------------------

write_csv(chronicle, file = "___/chronicle.csv")
