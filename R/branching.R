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
p5 <- load.image("figure19.png")
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
  scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() #+
  #ggtitle("Tree")

final_p5df_colour

final_p6df_colour<- p6df_colour + 
  scale_y_reverse() + 
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0), trans=scales::reverse_trans()) + 
  theme_void() #+
#ggtitle("Tree")

final_p6df_colour

figure2 <- final_p5df_colour / final_p6df_colour
figure2

ggsave('figure2.tiff', height=7, width=6, units = 'in', dpi = 600)

patched <- final_p1df_colour / final_p2df_colour / final_p3df_colour
patched

patched <- final_p1df_colour + final_p2df_colour + final_p3df_colour + final_p4df_colour +
  plot_layout(guides = 'collect') +
  plot_annotation(title = '"Nature is no doubt simpler than all our thoughts are about it now, and the question is: in what way do we have to think about it so that we understand its simplicity?"')
patched

ggsave('branching.png', units = 'in', dpi = 300)