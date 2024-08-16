# Code to install necessary packages,
# if not already installed.

needed <- c("MplusAutomation", "qgraph", "mlVAR",
            "mgcv", "lme4", "expm", "ctsem",
            "rjags", "RColorBrewer", "mgm",
            "hydroGOF", "mvtnorm", "devtools")

for (pkg in needed) {
  if (!(pkg %in% installed.packages())) {
    install.packages(pkg)
  }
}

# Note, you will need to have installed Rtools,
# a separate program, for devtools to work.
devtools::install_github("ryanoisin/ctnet")
