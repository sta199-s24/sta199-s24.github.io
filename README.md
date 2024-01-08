# sta199-s24.github.io

## Colors

-   `#3A5883` - A darker version of Pantone Chambray Blue: use against a white background and pass contrast checks.

-   `#a4b9da` - Pantone Chambray Blue: use against a dark background.

-   `#FFBE98` - Pantone Peach Fuzz: use for accent against a dark background.

## Rendering

Locally, in RStudio, click *Build Website* on the Build tab or in any editor (including RStudio) run `quarto render` in the Terminal.

## Publishing

Push changes to the repo to trigger the GitHub Action that publishes the website. If any R packages are added or updated, make sure to run `renv::snapshot()` and commit and push the updated lockfile as well.
