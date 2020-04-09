# rstudioSettings

Package/Scripts to apply custom RStudio settings programmatically.

When you apply these settings, your current settings will backed up into `*.bak` files in the respective directories.

Two options are available:

- "Minimal"
- "Full"

"Full" installs the full suite of my personal settings with some opinionated packages and addins.

The config files live in `inst/`.

## Requirements

Because this config relies on a custom 3-pane layout, RStudio v1.4.162 or greater is required.

## Execution

Call the following to start the process

```r
source("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/R/install.R")
```

source("https://res.pat-s.me/rstudio")
