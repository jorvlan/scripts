## Jordy van Langen, adjusted from: https://rpubs.com/mramos/ganttchart 

## input data labels and dates

library(plotrix)

Ymd.format<-"%Y/%m/%d"
gantt.info<-list(labels=c("Project 1 - review","CODEC - general", "CODEC - protocol paper", "Project 2 - eye-tracking variability","OMSS", "Amsterdam eye-tracking variability","JOSS", "Project 3", "Project 4", "PhD Job", "Website"),
                 starts=as.POSIXct(strptime(c("2023/09/01","2023/09/01","2024/01/01","2024/02/01","2024/03/01","2024/04/01","2024/06/01", "2025/01/01", "2026/01/01", "2023/09/01", "2023/09/01"),
                                            format=Ymd.format)),
                 ends=as.POSIXct(strptime(c("2024/12/12","2027/01/01","2024/07/01","2024/12/31","2025/07/01","2025/07/01","2024/07/01", "2025/12/12", "2026/12/12", "2026/12/12", "2026/12/12"),
                                          format=Ymd.format)),
                 priorities=c(1,1,2,1,1,3,4,3,3,4,4))


## asign values

months <- seq(as.Date("2023/09/01", "%Y/%m/%d"), by="year", length.out=6)
monthslab <- format(months, format="%Y/%m")

vgridpos<-as.POSIXct(months,format=Ymd.format)
vgridlab<-monthslab

colfunc <- colorRampPalette(c("#440154FF", "#3CBB75FF")) #darkgoldenrod1 #red

timeframe <- as.POSIXct(c("2023/09/01","2027/07/01"),format=Ymd.format)





## create
gantt_fig <- gantt.chart(gantt.info, taskcolors=colfunc(4),xlim=timeframe, main="PhD timeline",
                         priority.legend=TRUE,vgridpos=vgridpos,vgridlab=vgridlab,hgrid=TRUE)

## save

dev.copy(pdf, width = 8, height = 6, paper = "special")
dev.off()




## CODEC timeline
Ymd.format<-"%Y/%m/%d"
gantt.info<-list(labels=c("Ethics application","Protocol paper", "MRI pipeline", "MRI Task programming","Participant recruitment","Intern recruit & supervise", "Data collection", "Data analysis", "Weekly meetings"),
                 starts=as.POSIXct(strptime(c("2023/09/01","2023/09/01","2023/09/01","2023/10/01","2024/04/01","2023/12/12","2024/09/01", "2024/09/01", "2023/09/01"),
                                            format=Ymd.format)),
                 ends=as.POSIXct(strptime(c("2024/04/01","2024/07/01","2024/09/01","2024/05/01","2026/12/12","2026/07/01","2026/12/12", "2027/05/31", "2027/05/31"),
                                          format=Ymd.format)),
                 priorities=c(1,1,1,1,1,3,1,3,4))


## asign values

months <- seq(as.Date("2023/09/01", "%Y/%m/%d"), by="year", length.out=6)
monthslab <- format(months, format="%Y/%m")

vgridpos<-as.POSIXct(months,format=Ymd.format)
vgridlab<-monthslab

colfunc <- colorRampPalette(c("#440154FF", "#3CBB75FF")) #darkgoldenrod1 #red

timeframe <- as.POSIXct(c("2023/09/01","2027/07/01"),format=Ymd.format)


## create
gantt_fig_codec <- gantt.chart(gantt.info, taskcolors=colfunc(4),xlim=timeframe, main="CODEC timeline",
                               priority.legend=TRUE,vgridpos=vgridpos,vgridlab=vgridlab,hgrid=TRUE)

## save

dev.copy(pdf, width = 8, height = 6, paper = "special")
dev.off()



## Create for Van der Gaag grant

Ymd.format<-"%Y/%m/%d"
gantt.info<-list(labels=c("Week1","Week2","Week3","Week4","Week5","Week6","Week7","Week8","Week9","Week10","Week11","Week12"),
                 starts=as.POSIXct(strptime(c("2023/09/01","2023/09/01","2024/01/01","2024/02/01","2024/03/01","2024/04/01","2024/06/01", "2025/01/01", "2026/01/01", "2023/09/01", "2023/09/01"),
                                            format=Ymd.format)),
                 ends=as.POSIXct(strptime(c("2024/12/12","2027/01/01","2024/07/01","2024/12/31","2025/07/01","2025/07/01","2024/07/01", "2025/12/12", "2026/12/12", "2026/12/12", "2026/12/12"),
                                          format=Ymd.format)),
                 priorities=c(1,1,2,1,1,3,4,3,3,4,4))


## asign values

weeks <- seq(as.Date("2023/09/01", "%Y/%m/%d"), by="week", length.out=6)
weekslab <- format(weeks, format="%Y/%m/%d")



vgridpos<-as.POSIXct(weeks,format=Ymd.format)
vgridlab<-weekslab

colfunc <- colorRampPalette(c("#440154FF", "#3CBB75FF")) #darkgoldenrod1 #red

timeframe <- as.POSIXct(c("2026/03/01","2026/05/31"),format=Ymd.format)





## create
gantt_fig <- gantt.chart(gantt.info, taskcolors=colfunc(4),xlim=timeframe, main="Project timeline by week",
                         priority.legend=TRUE,vgridpos=vgridpos,vgridlab=vgridlab,hgrid=TRUE)
gantt_fig
## save

dev.copy(pdf, width = 8, height = 6, paper = "special")
dev.off()


############################
#### alternative gantt chart
############################

Ymd.format <- "%Y/%m/%d"

# Project start
project_start <- as.Date("2026/03/01", format=Ymd.format)

# Define weekly grid for vertical lines
n_weeks <- 12
week_starts <- seq(project_start, by="week", length.out=n_weeks)
week_labels <- paste0("W", 1:n_weeks)

# ---- Define tasks ----
# Each task has a start week and duration (in weeks)
tasks <- data.frame(
  label     = c("Data preprocessing", "Statistical modeling", "Group meetings", "Present", "Article writing", ""),
  start_wk  = c(1, 3, 5, 9, 11, 1),   # starting week number
  duration  = c(2, 8, c(3,7), 2, 1, 1),    # duration in weeks
  priority  = c(1, 1, 1, 1, 3, 1)     # can be used for coloring
)

# Compute actual dates from week numbers
tasks$start_date <- project_start + (tasks$start_wk - 1) * 7
tasks$end_date   <- tasks$start_date + (tasks$duration * 7 - 1)

# ---- Build gantt.info ----
gantt.info <- list(
  labels     = tasks$label,
  starts     = as.POSIXct(tasks$start_date),
  ends       = as.POSIXct(tasks$end_date),
  priorities = tasks$priority
)

# ---- Weekly grid ----
vgridpos <- as.POSIXct(week_starts)
vgridlab <- format(week_starts, "%Y/%m/%d")

# ---- Colors ----
colfunc <- colorRampPalette(c("#440154FF", "#3CBB75FF"))

# ---- Timeframe (covers all weeks) ----
timeframe <- c(min(as.POSIXct(week_starts)), max(as.POSIXct(week_starts + 6)))

# ---- Create Gantt chart ----
gantt.chart(
  gantt.info,
  taskcolors = colfunc(4),
  xlim = timeframe,
  main = "Project Timeline (weekly)",
  priority.legend = TRUE,
  vgridpos = vgridpos,
  vgridlab = vgridlab,
  hgrid = TRUE
)


## try with ggplot2

library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

# ---- Setup ----
Ymd.format <- "%Y/%m/%d"
project_start <- as.Date("2026/03/01", format = Ymd.format)

# ---- Weekly grid ----
n_weeks <- 12
week_starts <- seq(project_start, by = "week", length.out = n_weeks)

# ---- Define tasks (some recurring) ----
tasks <- data.frame(
  label     = c("Data preprocessing", "Statistical modeling", "Attend group meeting", "Host workshop", "Present results", "Article writing"),
  start_wk  = c(1, 2, 1, 8, 11, 9),   # starting week
  duration  = c(2, 6, 0.2, 1, 1, 3),   # duration in weeks
  repeats   = c(1, 1, 12, 1, 1, 1)    # number of repeats
)

# ---- Expand tasks for repeats ----
tasks_expanded <- tasks %>%
  rowwise() %>%
  mutate(occurrence = list(0:(repeats-1))) %>%  # create sequence for each repeat
  unnest(occurrence) %>%
  mutate(
    start_date = project_start + (start_wk - 1 + occurrence * (duration + 1)) * 7, # add gap
    end_date   = start_date + (duration * 7 - 1)
  ) %>%
  ungroup() %>%
  # Keep y-axis as factor for Gantt-style rows
  mutate(label = factor(label, levels = rev(unique(label))))  # first task at top

# ---- Plot ----
ggplot(tasks_expanded, aes(x = start_date, xend = end_date,
                           y = label, yend = label)) +
  geom_segment(size = 4, lineend = "round", color = "#3CBB75FF") +  # thick bars
  geom_vline(xintercept = week_starts, color = "grey80", linetype = "dotted") +
  scale_x_date(
    breaks = week_starts,
    labels = format(week_starts, "%m/%d"),
    expand = c(0,0)
  ) +
  labs(title = "Research visit - timeline", x = "By week", y = "") +
  theme_classic(base_size = 14) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )