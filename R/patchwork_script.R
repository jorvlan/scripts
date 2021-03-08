library(raincloudplots)
library(patchwork)

df_1x1 <- data_1x1(
  array_1 = iris$Sepal.Length[1:50],
  array_2 = iris$Sepal.Length[51:100],
  jit_distance = .09,
  jit_seed = 321)

df_2x2 <- data_2x2(
  array_1 = iris$Sepal.Length[1:50],
  array_2 = iris$Sepal.Length[51:100],
  array_3 = iris$Sepal.Length[101:150],
  array_4 = iris$Sepal.Length[81:130],
  labels = (c('congruent','incongruent')),
  jit_distance = .09,
  jit_seed = 321,
  spread_x_ticks = FALSE)

df_2x2_spread <- data_2x2(
  array_1 = iris$Sepal.Length[1:50],
  array_2 = iris$Sepal.Length[51:100],
  array_3 = iris$Sepal.Length[101:150],
  array_4 = iris$Sepal.Length[81:130],
  labels = (c('congruent','incongruent')),
  jit_distance = .09,
  jit_seed = 321,
  spread_x_ticks = TRUE) 

raincloud_1_h <- raincloud_1x1(
  data = df_1x1, 
  colors = (c('#F8766D', '#00BA38')),#00BFC4
  fills = (c('#F8766D', '#00BA38')),#00BFC4
  size = 1, 
  alpha = .6, 
  ort = 'h') +
  
  scale_x_continuous(breaks=c(1,2), labels=c("Group1", "Group2"), limits=c(0, 3)) +
  xlab("group") + 
  ylab("score") +
  theme_classic()

raincloud_1_h

raincloud_1_v <- raincloud_1x1(
  data = df_1x1, 
  colors = (c('dodgerblue','darkorange')), 
  fills = (c('dodgerblue','darkorange')), 
  size = 1, 
  alpha = .6, 
  ort = 'v') +
  
  scale_x_continuous(breaks=c(1,2), labels=c("Group1", "Group2"), limits=c(0, 3)) +
  xlab("Groups") + 
  ylab("Score") +
  theme_classic()

raincloud_1_v



raincloud_2 <- raincloud_1x1_repmes(
  data = df_1x1,
  colors = (c('dodgerblue', 'darkorange')),#00BFC4 #F8766D #619CFF
  fills = (c('dodgerblue', 'darkorange')),#00BFC4 #F8766D #619CFF
  line_color = 'gray',
  line_alpha = .3,
  size = 1,
  alpha = .6,
  align_clouds = FALSE) +
  
  scale_x_continuous(breaks=c(1,2), labels=c("Pre", "Post"), limits=c(0, 3)) +
  xlab("time") + 
  ylab("score") +
  theme_classic()

raincloud_2

raincloud_2_aligned <- raincloud_1x1_repmes(
  data = df_1x1,
  colors = (c('dodgerblue', 'darkorange')),
  fills = (c('dodgerblue', 'darkorange')),
  line_color = 'gray',
  line_alpha = .3,
  size = 1,
  alpha = .6,
  align_clouds = TRUE) +
  
  scale_x_continuous(breaks=c(1,2), labels=c("Pre", "Post"), limits=c(0, 3)) +
  xlab("Time") + 
  ylab("Score") +
  theme_classic()

raincloud_2_aligned

raincloud_2x2 <- raincloud_2x2_repmes(
  data = df_2x2,
  colors = (c('dodgerblue', 'darkorange', 'dodgerblue', 'darkorange')),
  fills = (c('dodgerblue', 'darkorange', 'dodgerblue', 'darkorange')),
  size = 1,
  alpha = .6,
  spread_x_ticks = FALSE) +
  
  scale_x_continuous(breaks=c(1,2), labels=c("Pre", "Post"), limits=c(0, 3)) +
  xlab("Time") + 
  ylab("Score") +
  theme_classic()

raincloud_2x2

raincloud_2x2_spread <- raincloud_2x2_repmes(
  data = df_2x2_spread,
  colors = (c('dodgerblue', 'darkorange', 'dodgerblue', 'darkorange')),
  fills = (c('dodgerblue', 'darkorange', 'dodgerblue', 'darkorange')),
  line_color = 'gray',
  line_alpha = .3,
  size = 1,
  alpha = .6,
  spread_x_ticks = TRUE) +
  
  scale_x_continuous(breaks=c(1,2,3,4), labels=c("Pre", "Post", "Pre", "Post"), limits=c(0, 5)) +
  xlab("Time") + 
  ylab("Score") +
  theme_classic()

raincloud_2x2_spread

combined <- ((raincloud_1_h | raincloud_1_v) / (raincloud_2 | raincloud_2_aligned) / (raincloud_2x2 | raincloud_2x2_spread)) #+ plot_annotation(title = 'raincloudplots: a graphical overview', theme = theme(plot.title = element_text(size = 16, family = 'A')))
combined

ggsave("combined.tiff", height=6, width=6, units='in', dpi=600)

### insert 3rd figure from Rainclouds tutorial

## steps:
# load R tutorial Rainclouds
#execute script below
```{r, repdata4, include = TRUE, echo = TRUE}
#Rainclouds for repeated measures, additional plotting options 
p12 <- ggplot(rep_data, aes(x = group, y = score, fill = time)) +
  geom_flat_violin(aes(fill = time),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = FALSE, alpha = .6, colour = NA)+
  geom_point(aes(x = as.numeric(group)-.15, y = score, colour = time), alpha = .6,position = position_jitter(width = .05, height = 0), size = 1)+
  geom_boxplot(aes(x = group, y = score, fill = time),outlier.shape = NA, alpha = .6, width = .1)+
  #geom_line(data = sumrepdat, aes(x = as.numeric(group)+.1, y = score_mean, group = time, colour = time), linetype = 3)+
  #geom_point(data = sumrepdat, aes(x = as.numeric(group)+.1, y = score_mean, group = time, colour = time), shape = 18) +
  #geom_errorbar(data = sumrepdat, aes(x = as.numeric(group)+.1, y = score_mean, group = time, colour = time, ymin = score_mean-se, ymax = score_mean+se), width = .05)+
  #scale_colour_brewer(palette = "Dark2")+
  #scale_fill_brewer(palette = "Dark2")+ theme_classic() +
  #ggtitle("Figure 12: Repeated Measures - Factorial (Extended)") 
  theme_classic() +
  theme(legend.position = "none") +
  coord_flip()
ggsave('../figs/tutorial_R/12repanvplot3.png', width = w, height = h)
```

```{r figure 12}
p12
```


## Figure 1 feedback Rogier
# left-up, left-middle and 3 groups
combined_v3 <- ((raincloud_1_h | raincloud_2) / p12) #+ plot_annotation(title = 'raincloudplots: a graphical overview', theme = theme(plot.title = element_text(size = 16, family = 'A')))
combined_v3
ggsave("combined_v3.tiff", height=5, width=5, units='in', dpi=600, compression='lzw') #.png

scales:::show_col(ggplotColours(n=3))
## Figure 2

install.packages("patchwork")
library(patchwork)

library(ggplot2)
library(dplyr)

install.packages("imager")
library(imager)

p1 <- load.image("gregdunn.JPG")
p2 <- load.image("mountain_branching.jpg")
p3 <- load.image("river_branching1.jpg")
p4 <- load.image("tree_branching1.jpg")
p5 <- load.image("figure1_legend_added.png")
p6 <- load.image("Rplot02.png")

p1df <- as.data.frame(p1,wide="c") %>% mutate(rgb.val=rgb(c.1,c.2,c.3))
p2df <- as.data.frame(p2,wide="c") %>% mutate(rgb.val=rgb(c.1,c.2,c.3))
p3df <- as.data.frame(p3,wide="c") %>% mutate(rgb.val=rgb(c.1,c.2,c.3))
p4df <- as.data.frame(p4,wide="c") %>% mutate(rgb.val=rgb(c.1,c.2,c.3))
p5df <- as.data.frame(p5,wide="c") %>% mutate(rgb.val=rgb(c.1,c.2,c.3))
p6df <- as.data.frame(p6,wide="c") %>% mutate(rgb.val=rgb(c.1,c.2,c.3))


p1df_colour <- ggplot(p1df,aes(x,y))+geom_raster(aes(fill=rgb.val))+scale_fill_identity()
p2df_colour <- ggplot(p2df,aes(x,y))+geom_raster(aes(fill=rgb.val))+scale_fill_identity()
p3df_colour <- ggplot(p3df,aes(x,y))+geom_raster(aes(fill=rgb.val))+scale_fill_identity()
p4df_colour <- ggplot(p4df,aes(x,y))+geom_raster(aes(fill=rgb.val))+scale_fill_identity()
p5df_colour <- ggplot(p5df,aes(x,y))+geom_raster(aes(fill=rgb.val))+scale_fill_identity()
p6df_colour <- ggplot(p6df,aes(x,y))+geom_raster(aes(fill=rgb.val))+scale_fill_identity()

final_p1df_colour<- p1df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() +
  ggtitle("Pyramidal cells")

final_p1df_colour


final_p2df_colour<- p2df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() +
  ggtitle("Mountains")

final_p2df_colour

final_p3df_colour<- p3df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() +
  ggtitle("Rivers")

final_p3df_colour

final_p4df_colour<- p4df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() +
  ggtitle("Tree")

final_p4df_colour

final_p5df_colour<- p5df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  #scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  #scale_colour_manual(name="group", values = c("group1" = "dodgerblue", "group2" = "darkred", "group3" = "darkorange", "group4" = "darkgreen")) +
  theme_void() #+
#ggtitle("Tree")

final_p5df_colour

final_p6df_colour<- p6df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  #scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() #+
#ggtitle("Tree")

final_p6df_colour



figure2 <- final_p5df_colour / final_p6df_colour
figure2

ggsave('figure2_legends_added.tiff', height=5.39, width=3.73, units = 'in', dpi = 600, compression='lzw')

##Branching

patched <- final_p1df_colour / final_p2df_colour / final_p3df_colour
patched

patched <- final_p1df_colour + final_p2df_colour + final_p3df_colour + final_p4df_colour +
  plot_layout(guides = 'collect') +
  plot_annotation(title = '"Nature is no doubt simpler than all our thoughts are about it now, and the question is: in what way do we have to think about it so that we understand its simplicity?"')
patched

ggsave('branching.png', units = 'in', dpi = 300)


## Figure 1a

before = iris$Sepal.Length[1:50] 
after = iris$Sepal.Length[51:100]
n <- length(before) 
d <- data.frame(y = c(before, after),
                x = rep(c(1,2), each=n),
                z = rep(c(3,4), each=n), 
                x1 = rep(c(5,6), each=n),
                z1 = rep(c(7,8), each=n),
                x2 = rep(c(9,10), each=n),
                id = factor(rep(1:n,2))) 
set.seed(321)
d$xj <- jitter(d$x, amount = .09) 
d$xj_2 <- jitter(d$z, amount = .09)
d$xj_3 <- jitter(d$x1, amount = .09)
d$xj_4 <- jitter(d$z1, amount = .09)
d$xj_5 <- jitter(d$x2, amount = .09)

#library(gghalves)
f17 <- ggplot(data=d, aes(y=y)) +
  #Add geom_() objects
  
  
  
  geom_half_violin(
    data = d %>% filter(x=="1"),aes(x = x, colour="group1"), position = position_nudge(x = 0), 
    side = "l", fill = 'dodgerblue', alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(x=="2"),aes(x = x, colour="group2"), position = position_nudge(x = 0), 
    side = "r", fill = "darkred", alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(z=="3"),aes(x = z, colour="group3"), position = position_nudge(x = 0), 
    side = "l", fill = "darkorange", alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(z=="4"),aes(x = z, colour="group4"), position = position_nudge(x = 0), 
    side = "r", fill = 'darkgreen', alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(x1=="5"),aes(x = x1, colour="group1"), position = position_nudge(x = 0), 
    side = "l", fill = "dodgerblue", alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(x1=="6"),aes(x = x1, colour="group2"), position = position_nudge(x = 0), 
    side = "r", fill = "darkred", alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(z1=="7"),aes(x = z1, colour="group3"), position = position_nudge(x = 0), 
    side = "l", fill = "darkorange", alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(z1=="8"),aes(x = z1, colour="group4"), position = position_nudge(x = 0), 
    side = "r", fill = 'darkgreen', alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(x2=="9"),aes(x = x2, colour="group1"), position = position_nudge(x = 0), 
    side = "l", fill = "dodgerblue", alpha = .15, color = "white", trim = TRUE) +
  
  geom_half_violin(
    data = d %>% filter(x2=="10"),aes(x = x2, colour="group2"), position = position_nudge(x = 0), 
    side = "r", fill = "darkred", alpha = .15, color = 'white', trim = TRUE) +
  
  
  geom_point(data = d %>% dplyr::filter(x =="1"), aes(x = xj, colour="group1"), color = 'dodgerblue', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(x =="2"), aes(x = xj, colour="group2"), color = 'darkred', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(z =="3"), aes(x = xj_2, colour="group3"), color = 'darkorange', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(z =="4"), aes(x = xj_2, colour="group4"), color = 'darkgreen', size = 1.5,
             alpha = .6) +
  
  geom_point(data = d %>% dplyr::filter(x1 =="5"), aes(x = xj_3, colour="group1"), color = 'dodgerblue', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(x1 =="6"), aes(x = xj_3, colour="group2"), color = 'darkred', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(z1 =="7"), aes(x = xj_4, colour="group3"), color = 'darkorange', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(z1 =="8"), aes(x = xj_4, colour="group4"), color = 'darkgreen', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(x2 =="9"), aes(x = xj_5, colour="group1"), color = 'dodgerblue', size = 1.5,
             alpha = .6) +
  geom_point(data = d %>% dplyr::filter(x2 =="10"), aes(x = xj_5, colour="group2"), color = 'darkred', size = 1.5,
             alpha = .6) +
  
  #geom_line(aes(x=jit, y = y, group=id), color = 'lightgray') +
  #geom_line(data = d %>% dplyr::filter(x %in% c("1", "2")), aes(x = xj, y = y, group = id), color = 'lightgray', alpha = .3) +
  #geom_line(data = d %>% dplyr::filter(x %in% c("3", "4")), aes(x = xj_2, y = y, group = id), color = 'lightgray', alpha = .3) +
  geom_line(aes(x=xj, group=id), color = 'lightgray', alpha = .5) +
  geom_line(aes(x=xj_2, group=id), color = 'lightgray', alpha = .5) +
  geom_line(aes(x=xj_3, group=id), color = 'lightgray', alpha = .5) +
  geom_line(aes(x=xj_4, group=id), color = 'lightgray', alpha = .5) +
  geom_line(aes(x=xj_5, group=id), color = 'lightgray', alpha = .5) +
  geom_boxplot(
    data = d %>% dplyr::filter(x=="1"), aes(x=x, colour="group1"), fill = 'dodgerblue',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(x=="2"), aes(x=x, colour="group2"), fill = 'darkred',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(z=="3"), aes(x=z, colour="group3"), fill = 'darkorange',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(z=="4"), aes(x=z, colour="group4"), fill = 'darkgreen',
    outlier.shape = NA, width = .2, alpha = .1) +
  
  
  geom_boxplot(
    data = d %>% dplyr::filter(x1=="5"), aes(x=x1, colour="group1"), fill = 'dodgerblue',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(x1=="6"), aes(x=x1, colour="group2"), fill = 'darkred',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(z1=="7"), aes(x=z1, colour="group3"), fill = 'darkorange',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(z1=="8"), aes(x=z1, colour="group4"), fill = 'darkgreen',
    outlier.shape = NA, width = .2, alpha = .1) +
  
  
  geom_boxplot(
    data = d %>% dplyr::filter(x2=="9"), aes(x=x2, colour="group1"), fill = 'dodgerblue',
    outlier.shape = NA, width = .2, alpha = .1) +
  geom_boxplot(
    data = d %>% dplyr::filter(x2=="10"), aes(x=x2, colour="group2"), fill = 'darkred',
    outlier.shape = NA, width = .2, alpha = .1) +
  
  
  
  
  
  #Define additional settings
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10), labels=c("Pre", "Post", "Pre", "Post","Pre", "Post", "Pre", "Post", "Pre", "Post"), limits=c(0, 11)) +
  xlab("Condition") + ylab("Value") +
  #ggtitle('Figure 15: Repeated measures with jittered datapoints and connections') +
  theme_classic()+
  coord_cartesian(ylim=c(4, 8))+
  scale_colour_manual(name="group",
                      values=c(group1="dodgerblue", group2="darkred", group3="darkorange", group4="darkgreen"))
f17

ggsave('figure1a_legend_added.png', units = 'in', dpi = 600)

## Figure 2a

samplesize<-1000
group1_cog1<-rnorm(.6*samplesize,100,15)
group2_cog1<-rnorm(.1*samplesize,110,15)
group3_cog1<-rnorm(.2*samplesize,115,15)
group4_cog1<-rnorm(.1*samplesize,115,15)

group1_cog2<-rnorm(.6*samplesize,80,15)
group2_cog2<-rnorm(.1*samplesize,80,15)
group3_cog2<-rnorm(.2*samplesize,85,15)
group4_cog2<-rnorm(.1*samplesize,85,15)


group1_cog3<-rnorm(.6*samplesize,20,15)
group2_cog3<-rnorm(.1*samplesize,10,15)
group3_cog3<-rnorm(.2*samplesize,35,15)
group4_cog3<-rnorm(.1*samplesize,30,15)



plotdata_wide<-data.frame(c(group1_cog1,group2_cog1,group3_cog1,group4_cog1),
                          c(group1_cog2,group2_cog2,group3_cog2,group4_cog2),
                          c(group1_cog3,group2_cog3,group3_cog3,group4_cog3),
                          c(rep('group1',times=.6*samplesize),rep('group2',times=.1*samplesize),rep('group3',times=.2*samplesize),rep('group4',times=.1*samplesize))
)

colnames(plotdata_wide)<-c('cog1','cog2','cog3','group')

plotdata_long<-melt(plotdata_wide)
f1 <- ggplot(plotdata_long,aes(value,group=group,fill=group))+
  geom_jitter(data = plotdata_long, aes(value,y=-0.01, color=group), height = 0.005, alpha = .5) + ##added
  geom_density(adjust=2,alpha=.1)+
  geom_histogram(aes(y=..density..),binwidth=5, alpha = .4) +
  geom_boxplot(aes(x = value, y = 0, fill = group),outlier.shape = NA, alpha = .5, width = .005, colour = "black")+
  facet_grid(group~variable)+
  theme_classic()
f1

#png("4*3_raincloud.png", type = "cairo")
#print(f1)
#dev.off()

ggsave('figure2b_legend_added.png', units = 'in', dpi = 600)

figure2_new <- f17 / f1
figure2_new

ggsave('figure2_new.tiff', height = 10, width = 10, units = 'in', dpi = 600, compression='lzw')














#or just grab 1
ggplot(dplyr::filter(plotdata_long,variable=='cog1'),aes(value,fill=group)) +
  geom_jitter(data = plotdata_long %>% filter(variable=='cog1'),aes(value,y=-0.01), height = 0.005, alpha = .3) + ##added
  geom_density(adjust=2,alpha=.6) +
  theme_classic(base_size=12) +
  facet_wrap(~group,ncol=1) #+

ggsave("cog1_raincloud.png", dpi = 300)
