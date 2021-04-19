# rstudioSettings

Package/Scripts to apply custom RStudio settings programmatically (for any OS).

When you apply these settings, your current settings will backed up into `*.bak` files in the respective directories.

Two options are available:

-   "Minimal"
-   "Full"

"Minimal" also installs an opinionated basic setup of RStudio settings - you might want to check the configs in the `inst/` directory before proceeding.

"Full" installs the full suite of **my personal settings** with some opinionated packages and addins.

## Requirements

Because this config relies on a custom 3-pane layout, RStudio v1.4.162 or greater is required.

## Execution

Call the following to start the process

``` r
source("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/R/install.R")

# short alternative
source("https://bit.ly/rstudio-config-pat")
```

# How can I use my own settings?

1.  Fork the repo
2.  Edit the settings in `inst/` to your liking
3.  Adjust the `source()` call from above
