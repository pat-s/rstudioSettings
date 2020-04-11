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
if (!requireNamespace("rstudioapi", quietly = TRUE)) install.packages("rstudioapi")
if (!requireNamespace("cli", quietly = TRUE)) install.packages("cli")
if (!requireNamespace("fs", quietly = TRUE)) install.packages("fs")
if (!requireNamespace("glue", quietly = TRUE)) install.packages("glue")

# never upgrade packages during remotes install to avoid user input
Sys.setenv("R_REMOTES_UPGRADE" = "never")

if (minimal != 1) {
  options("install.packages.compile.from.source" = "no")
  remotes::install_github("gadenbuie/rsthemes")
  rsthemes::install_rsthemes(include_base16 = TRUE)

  remotes::install_github("krlmlr/fledge")
  remotes::install_github("pat-s/usethis@my-prs")
  remotes::install_github("r-lib/prettycode")
  remotes::install_github("tmastny/browse")
  remotes::install_github("lorenzwalthert/teamtools")
  remotes::install_github("pat-s/styler@mlr-style")
  if (!requireNamespace("reprex", quietly = TRUE)) install.packages("reprex")
}

# Check if RStudio > 1.4.162 is installed --------------------------------------
if (unlist(rstudioapi::getVersion())[2] < 4) {
  version_ok <- FALSE
} else {
  if (unlist(rstudioapi::getVersion())[3] < 162) {
    version_ok <- FALSE
  }
  version_ok <- TRUE
}

if (!version_ok) {
  cli::cli_alert_danger("You need a newer version of RStudio.")
  cli::cli_text("Please go to {.url https://dailies.rstudio.com/} and download
                version 1.4.162 or greater.")
  cli::cli_alert_info("If you are using a Mac and {.code homebrew}, you can 
    call {.code brew cask install rstudio-daily}.", wrap = TRUE)
  stop("RStudio version too old.", call. = FALSE)
}

# backup old settings ----------------------------------------------------------

win_dir <- "~/AppData/Roaming/RStudio"
linux_dir <- "~/.config/rstudio"
mac_dir <- "~/.config/rstudio"

switch(Sys.info()[["sysname"]],
  Windows = {
    fs::dir_create(glue::glue("{win_dir}/keybindings"), recurse = TRUE)
    # rstudio_bindings
    if (fs::file_exists(glue::glue("{win_dir}/keybindings/rstudio_bindings.json"))) {
      fs::file_copy(
        glue::glue("{win_dir}/keybindings/rstudio_bindings.json"),
        glue::glue("{win_dir}/keybindings/rstudio_bindings.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file rstudio_bindings.json} to 
        {.file {win_dir}/keybindings/rstudio_bindings.json.bak}.")
    }
    # addins
    if (fs::file_exists(glue::glue("{win_dir}/keybindings/addins.json"))) {
      fs::file_copy(
        glue::glue("{win_dir}/keybindings/addins.json"),
        glue::glue("{win_dir}/keybindings/addins.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file addins.json} to 
        {.file {win_dir}/keybindings/addins.json}.")
    }
    # rstudio-prefs
    if (fs::file_exists(glue::glue("{win_dir}/rstudio-prefs.json"))) {
      fs::file_copy(
        glue::glue("{win_dir}/rstudio-prefs.json"),
        glue::glue("{win_dir}/rstudio-prefs.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file rstudio-prefs.json} to 
        {.file {win_dir}/rstudio-prefs.json.bak}.")
    }
  },
  Linux = {
    fs::dir_create(glue::glue("{linux_dir}/keybindings"), recurse = TRUE)
    # rstudio_bindings
    if (fs::file_exists(glue::glue("{linux_dir}/keybindings/rstudio_bindings.json"))) {
      fs::file_copy(
        glue::glue("{linux_dir}/keybindings/rstudio_bindings.json"),
        glue::glue("{linux_dir}/keybindings/rstudio_bindings.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file rstudio_bindings.json} to 
        {.file {linux_dir}/keybindings/rstudio_bindings.json.bak}.")
    }
    # addins
    if (fs::file_exists(glue::glue("{linux_dir}/keybindings/addins.json"))) {
      fs::file_copy(
        glue::glue("{linux_dir}/keybindings/addins.json"),
        glue::glue("{linux_dir}/keybindings/addins.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file addins.json} to 
        {.file {linux_dir}/keybindings/addins.json}.")
    }
    # rstudio-prefs
    if (fs::file_exists(glue::glue("{linux_dir}/rstudio-prefs.json"))) {
      fs::file_copy(
        glue::glue("{linux_dir}/rstudio-prefs.json"),
        glue::glue("{linux_dir}/rstudio-prefs.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file rstudio-prefs.json} to 
        {.file {linux_dir}/rstudio-prefs.json.bak}.")
    }
  },
  Darwin = {
    fs::dir_create(glue::glue("{mac_dir}/keybindings"), recurse = TRUE)
    # rstudio_bindings
    if (fs::file_exists(glue::glue("{mac_dir}/keybindings/rstudio_bindings.json"))) {
      fs::file_copy(
        glue::glue("{mac_dir}/keybindings/rstudio_bindings.json"),
        glue::glue("{mac_dir}/keybindings/rstudio_bindings.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file rstudio_bindings.json} to 
        {.file {mac_dir}/keybindings/rstudio_bindings.json.bak}.")
    }
    # addins
    if (fs::file_exists(glue::glue("{mac_dir}/keybindings/addins.json"))) {
      fs::file_copy(
        glue::glue("{mac_dir}/keybindings/addins.json"),
        glue::glue("{mac_dir}/keybindings/addins.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file addins.json} to 
        {.file {mac_dir}/keybindings/addins.json}.")
    }
    # rstudio-prefs
    if (fs::file_exists(glue::glue("{mac_dir}/rstudio-prefs.json"))) {
      fs::file_copy(
        glue::glue("{mac_dir}/rstudio-prefs.json"),
        glue::glue("{mac_dir}/rstudio-prefs.json.bak"),
        overwrite = TRUE
      )
      cli::cli_alert_success("Backed up old {.file rstudio-prefs.json} to 
        {.file {mac_dir}/rstudio-prefs.json.bak}.")
    }
  }
)

# check if RTools is installed on Windows --------------------------------------

if (Sys.info()[["sysname"]] == "Windows") {

  #  need pkgbuild to check for RTools installation
  if (!requireNamespace("pkgbuild", quietly = TRUE)) install.packages("pkgbuild", type = "binary")
  if (pkgbuild::rtools_path() == "") {
    cli::cli_alert_info("Installing `RTools`. This is required to install R 
      packages from source.")
    if (!requireNamespace("installr", quietly = TRUE)) install.packages("installr")
    installr::install.Rtools(choose_version = FALSE, check = FALSE)
  }
}

# install utils ----------------------------------------------------------------

if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")

if (minimal != 1) {
  cli::cli_alert_info("Starting to install dependencies for RStudio Addins. 
    Please be patient.")
}
cli::cat_rule()

# setup spinner
sp1 <- cli::make_spinner()
fun_with_spinner <- function() {

  sp1$spin()

  # addins ---------------------------------------------------------------------

  if (!minimal) {
    remotes::install_github("pat-s/raddins", quiet = TRUE)
    if (!requireNamespace("xaringan", quietly = TRUE)) install.packages("xaringan")
    if (!requireNamespace("styler", quietly = TRUE)) install.packages("styler")
  }

  # scrape settings from gist ----------------------------------------------------

  if (minimal != 1) {
    keybindings <- jsonlite::read_json("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-bindings-patrick.json")
    general <- jsonlite::read_json("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-prefs-patrick.json")
    addins <- jsonlite::read_json("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/addins.json")
  } else {
    keybindings <- jsonlite::read_json("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-bindings-minimal.json")
    general <- jsonlite::read_json("https://raw.githubusercontent.com/pat-s/rstudioSettings/master/inst/rstudio-prefs-minimal.json")
  }
  # install on user machine ----------------------------------------------------

  switch(Sys.info()[["sysname"]],
    Windows = {
      fs::dir_create(glue::glue("{win_dir}/keybindings"), recurse = TRUE)
      jsonlite::write_json(keybindings,
        fs::path_expand(glue::glue("{win_dir}/keybindings/rstudio_bindings.json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Linux = {
      fs::dir_create(glue::glue("{linux_dir}/keybindings"), recurse = TRUE)
      jsonlite::write_json(keybindings,
        fs::path_expand(glue::glue("{linux_dir}/keybindings/rstudio_bindings.json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Darwin = {
      fs::dir_create(glue::glue("{mac_dir}/keybindings"), recurse = TRUE)
      jsonlite::write_json(keybindings,
        fs::path_expand(glue::glue("{mac_dir}/keybindings/rstudio_bindings.json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    }
  )

  # not unboxing here since an unboxed single value in a tabSet crashes RStudio
  switch(Sys.info()[["sysname"]],
    Windows = {
      jsonlite::write_json(general,
        fs::path_expand(glue::glue("{win_dir}/rstudio-prefs.json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Linux = {
      jsonlite::write_json(general,
        fs::path_expand(glue::glue("{linux_dir}/rstudio-prefs.json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    },
    Darwin = {
      jsonlite::write_json(general,
        fs::path_expand(glue::glue("{mac_dir}/rstudio-prefs.json")),
        pretty = TRUE, auto_unbox = TRUE
      )
    }
  )

  if (minimal != 1) {
    switch(Sys.info()[["sysname"]],
      Windows = {
        jsonlite::write_json(addins,
          fs::path_expand(glue::glue("{win_dir}/keybindings/addins.json")),
          pretty = TRUE, auto_unbox = TRUE
        )
      },
      Linux = {
        jsonlite::write_json(addins,
          fs::path_expand(glue::glue("{linux_dir}/keybindings/addins.json")),
          pretty = TRUE, auto_unbox = TRUE
        )
      },
      Darwin = {
        jsonlite::write_json(addins,
          fs::path_expand(glue::glue("{mac_dir}/keybindings/addins.json")),
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
cli::cli_text("You can view your new keyboard shortcuts via {.file Tools -> 
  Modify Keyboard Shortcuts -> Customized}.")
cli::cli_text("In addition, your console pane is now on the right instead of 
  splitting your editor pane in half. You are now using a 3-pane layout instead
   of the default 4-pane layout. If you don`t like it, you can restore the old
   style via {.file View -> Panes -> Pane Layout}.")
