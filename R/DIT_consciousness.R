library("ggplot2")
f <- function(x) 0 + (1*x) - (1*x*x)
tmp <- data.frame(x=0:1, y=f(0:1))

# Make plot object
p <- qplot(x, y, data=tmp, xlab = 'Apical state', ylab = "Consciousness") +
  geom_abline(intercept = 0, slope = 0.328, color = 'dodgerblue', size = 2, linetype = 3, alpha = .8) +
  geom_abline(intercept = .3, slope = -.3, color = 'darkorange', size = 2, linetype = 3, alpha = .8)
  

p <- p + stat_function(fun=f) + theme_classic() 

p <- p + annotate("text", label = "Dendritic Integration Theory of Consciousness (Aru et al., 2020; TiCS)", x = .5, y = .3, size = 4)
p <- p + annotate("text", label = "Apical drive - cellular mechanism of dreaming (Aru et al., 2020; PsyArxiv)", x = .5, y = .28, size = 4)

#middle top
p <- p + annotate("text", label = "apical - basal coupling 'match'", x = .5, y = .23, size = 3)
p <- p + annotate("text", label = "HO Thalamus optimal control", x = .5, y = .22, size = 3)
p <- p + annotate("text", label = "Top-down - bottom-up integration", x = .5, y = .21, size = 3)
p <- p + annotate("text", label = "Context modulation", x = .5, y = .20, size = 3)
p <- p + annotate("text", label = "Awake", x = .5, y = .19, size = 3)

#middle right
p <- p + annotate("text", label = "Dreaming (REM) (high ACh, low NA)", x = .77, y = .1, size = 3)
p <- p + annotate("text", label = "Hallucinations", x = .77, y = .09, size = 3)

#bottom right

p <- p + annotate("text", label = "Apical hyper-sensitivity", x = .9, y = .01, size = 3)
p <- p + annotate("text", label = "HO Thalamus hyper-active", x = .9, y = .00, size = 3) 

#middle left
p <- p + annotate("text", label = "Inattentional blindness (basal activation)", x = .25, y = .1, size = 3)

#bottom left
p <- p + annotate("text", label = "Slow wave sleep / NREM", x = .12, y = .04, size = 3)
p <- p + annotate("text", label = "Anesthesia", x = .1, y = .03, size = 3)
p <- p + annotate("text", label = "No apical - basal coupling", x = .1, y = .02, size = 3)
p <- p + annotate("text", label = "Metabotrophic receptor blocking", x = .11, y = .01, size = 3)
p <- p + annotate("text", label = "HO Thalamus inactive", x = .1, y = .00, size = 3)

p <- p + annotate("text", label = "Isolation", x = .1, y = -.02, size = 8, color = 'darkorange')
p <- p + annotate("text", label = "Drive", x = .9, y = -.02, size = 8, color = 'dodgerblue') 
p + theme(axis.ticks = element_blank(),
          axis.text = element_blank())





#p + theme(axis.text = element_blank())
#          axis.ticks = element_blank())

ggsave("p_small.tiff", units='in', dpi=300)
ggsave("p_png.png", units='in', dpi=300)

install.packages("crayon")
library(crayon)
cat("This is how", red("Red"), "looks.\n")


#


# original code
grid = structure(c(1:12),.Dim = c(4,3))
labs = c("A","B","C")
image(1:4,1:3,grid,axes=FALSE, xlab="", ylab = "")
axiscolors = c("black","red","black")

# new code    
qplot(axis, side=2, at=1:3, col.axis=axiscolors, labels=labs, lwd=0, las=1)
axis(2,at=1:3,labels=FALSE)