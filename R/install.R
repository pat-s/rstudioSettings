yesno <- menu(c("Yes!", "Ehm, wait..."),
  title = "This will overwrite all of your RStudio settings and keybindings. Do you want to continue?"
)

minimal <- menu(c(
  "Minimal",
  "Full (includes addins and more R packages)"
),
title = "Which installation type do you prefer?"
)

if (yesno != 1) {
  stop("Aborting.")
}
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
if (!requireNamespace("curl", quietly = TRUE)) install.packages("curl")
if (!requireNamespace("rstudioapi")) install.packages("rstudioapi")
if (!requireNamespace("cli")) install.packages("cli")
if (!requireNamespace("fs")) install.packages("fs")

if (minimal != 1) {
  Sys.setenv("R_REMOTES_UPGRADE" = "always")
  options("install.packages.compile.from.source" = "no")
  remotes::install_github("gadenbuie/rsthemes")
  rsthemes::install_rsthemes()
  rstudioapi::applyTheme("One Light {rsthemes}")

  remotes::install_github("krlmlr/fledge")
  remotes::install_github("pat-s/usethis@my-prs")
  remotes::install_github("r-lib/prettycode")
  remotes::install_github("tmastny/browse")
  remotes::install_github("lorenzwalthert/teamtools")
  remotes::install_github("pat-s/styler@mlr-style")
  remotes::install_github("mine-cetinkaya-rundel/addmins")
  install.packages(c("reprex", "remotes", "startup"))
}

# Check if RStudio > 1.3 is installed ------------------------------------------
if (unlist(rstudioapi::getVersion())[2] < 3) {
  cli::cli_alert_danger("You need a newer version of RStudio.")
  cli::cli_text("Please go to {.url https://dailies.rstudio.com/} and download
                version 1.3.x or greater.", wrap = TRUE)
  stop()
}

# check if RTools is installed on Windows --------------------------------------

if (Sys.info()[["sysname"]] == "Windows") {

  #  need pkgbuild to check for RTools installation
  if (!requireNamespace("pkgbuild", quietly = TRUE)) install.packages("pkgbuild", type = "binary")
  if (pkgbuild::rtools_path() == "") {
    cli::cli_alert_info("Installing `RTools`. This is required to
                      install R packages from source.", wrap = TRUE)
    if (!requireNamespace("installr", quietly = TRUE)) install.packages("installr")
    installr::install.Rtools(choose_version = FALSE, check = FALSE)
  }
}

# install utils ----------------------------------------------------------------

if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")

if (minimal != 1) {
  cli::cli_alert_info("Starting to install dependencies for RStudio Addins. Please be patient.")
}
cli::cat_rule()

# setup spinner
sp1 <- cli::make_spinner()
fun_with_spinner <- function() {
  sp1$spin()

  # addins ---------------------------------------------------------------------

  if (!minimal) {
    remotes::install_github("mine-cetinkaya-rundel/addmins", quiet = TRUE)
    if (!requireNamespace("xaringan", quietly = TRUE)) install.packages("xaringan")
    if (!requireNamespace("styler", quietly = TRUE)) install.packages("styler")
  }

  # scrape settings from gist ----------------------------------------------------

  if (minimal != 1) {
    keybindings <- jsonlite::fromJSON("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-bindings-patrick.json")
    general <- jsonlite::fromJSON("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-prefs-patrick.json")
    addins <- jsonlite::fromJSON("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/addins.json")
  } else {
    keybindings <- jsonlite::fromJSON("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-bindings-minimal.json")
    general <- jsonlite::fromJSON("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-prefs-minimal.json")
  }
  # install on user machine ----------------------------------------------------

  switch(Sys.info()[["sysname"]],
    Windows = {
      fs::dir_create("~/AppData/Roaming/RStudio/keybindings", recurse = TRUE)
      jsonlite::write_json(keybindings,
        fs::path_expand("~/AppData/Roaming/RStudio/keybindings/rstudio_bindings.json"),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Linux = {
      fs::dir_create("~/.config/rstudio/keybindings", recurse = TRUE)
      jsonlite::write_json(keybindings,
        fs::path_expand("~/.config/rstudio/keybindings/rstudio_bindings.json"),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Darwin = {
      fs::dir_create("~/.config/rstudio/keybindings", recurse = TRUE)
      jsonlite::write_json(keybindings,
        fs::path_expand("~/.config/rstudio/keybindings/rstudio_bindings.json"),
        pretty = TRUE, auto_unbox = TRUE
      )
    }
  )

  switch(Sys.info()[["sysname"]],
    Windows = {
      jsonlite::write_json(general,
        fs::path_expand("~/AppData/Roaming/RStudio/rstudio-prefs.json"),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Linux = {
      jsonlite::write_json(general,
        fs::path_expand("~/.config/rstudio/rstudio-prefs.json"),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Darwin = {
      jsonlite::write_json(general,
        fs::path_expand("~/.config/rstudio/rstudio-prefs.json"),
        pretty = TRUE, auto_unbox = TRUE
      )
    }
  )

  if (minimal != 1) {
    switch(Sys.info()[["sysname"]],
      Windows = {
        jsonlite::write_json(addins,
          fs::path_expand("~/AppData/Roaming/RStudio/keybindings/addins.json"),
          pretty = TRUE, auto_unbox = TRUE
        )
      },
      Linux = {
        jsonlite::write_json(addins,
          fs::path_expand("~/.config/rstudio/keybindings/addins.json.json"),
          pretty = TRUE, auto_unbox = TRUE
        )
      },
      Darwin = {
        jsonlite::write_json(addins,
          fs::path_expand("~/.config/rstudio/keybindings/addins.json"),
          pretty = TRUE, auto_unbox = TRUE
        )
      }
    )
  }
  sp1$finish()
}
fun_with_spinner()

rstudioapi::restartSession()

cli::ansi_with_hidden_cursor(fun_with_spinner())
if (minimal != 1) {
  cli::cli_alert_success("Successfully installed Patrick's RStudio settings.")
} else {
  cli::cli_alert_success("Successfully supercharged your RStudio settings.")
}
