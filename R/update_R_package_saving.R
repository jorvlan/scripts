mypks <- pacman::p_lib()
saveRDS(mypks, "~/mypks.rds")

install.packages("installr")
library(installr)

updateR()

mypks <- readRDS("~/mypks.rds")
install.packages(mypks)

library(mypks)