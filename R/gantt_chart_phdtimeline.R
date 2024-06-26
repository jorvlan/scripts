## input data labels and dates


library(plotrix)

Ymd.format<-"%Y/%m/%d"
gantt.info<-list(labels=c("Project 1 - review","CODEC - general", "CODEC - protocol paper", "Project 2 - eye-tracking variability","OMSS", "Amsterdam eye-tracking variability","JOSS", "Project 3", "Project 4"),
                 starts=as.POSIXct(strptime(c("2023/09/01","2023/09/01","2024/01/01","2024/02/01","2024/03/01","2024/04/01","2024/06/01", "2025/01/01", "2026/01/01"),
                                            format=Ymd.format)),
                 ends=as.POSIXct(strptime(c("2024/12/12","2027/01/01","2024/07/01","2024/12/31","2025/07/01","2025/07/01","2024/07/01", "2025/12/12", "2026/12/12"),
                                          format=Ymd.format)),
                 priorities=c(1,1,2,1,1,3,4,3,3))


## asign values

months <- seq(as.Date("2023/09/01", "%Y/%m/%d"), by="year", length.out=6)
monthslab <- format(months, format="%Y/%m")

vgridpos<-as.POSIXct(months,format=Ymd.format)
vgridlab<-monthslab

colfunc <- colorRampPalette(c("#440154FF", "#3CBB75FF")) #darkgoldenrod1 #red

timeframe <- as.POSIXct(c("2023/09/01","2027/07/01"),format=Ymd.format)





## create
gantt.chart(gantt.info, taskcolors=colfunc(4),xlim=timeframe, main="PhD timeline",
            priority.legend=TRUE,vgridpos=vgridpos,vgridlab=vgridlab,hgrid=TRUE)

## save

dev.copy(pdf, width = 8, height = 6, paper = "special")
dev.off()