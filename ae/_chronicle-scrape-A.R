# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

# check that we can scrape data from the chronicle -----------------------------

paths_allowed("https://www.dukechronicle.com")

# read page --------------------------------------------------------------------

page <- read_html("https://www.dukechronicle.com/section/opinion?page=1&per_page=500")

# parse components -------------------------------------------------------------

titles <- page |>
  html_elements(".headline a") |>
  html_text()

columns <- page |>
  html_elements(".col-md-8 .kicker a+ a") |>
  html_text()

abstracts <- page |>
  html_elements(".article-abstract") |>
  html_text2()

authors_dates <- page |>
  html_elements(".col-md-8 .dateline") |>
  html_text2() |>
  str_remove("By ")

urls <- page |>
  html_elements(".headline a") |>
  html_attr(name = "href")

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
  separate(author_date, into = c("author", "date"), sep = "\\| ", fill = "left") |>
  mutate(
    author = str_trim(author),
    date = case_when(
      str_detect(date, "hours ago") ~ "February 22, 2024",
      date == "Yesterday" ~ "February 21, 2024",
      date == "2 days ago" ~ "February 20, 2024",
      date == "5 days ago" ~ "February 17, 2024",
      date == "6 days ago" ~ "February 16, 2024",
      TRUE ~ date
    ),
    date = mdy(date)
  )

# write data -------------------------------------------------------------------

write_csv(chronicle, file = "data/chronicle.csv")
