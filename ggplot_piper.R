### A piper diagram based on the ternary plot example here: http://srmulcahy.github.io/2012/12/04/ternary-plots-r.html
### This was written quickly, and most likely contains bugs - I advise you to check it first.
### Jason Lessels jlessels@gmail.com


library(ggplot2)
ggplot_piper <- function(Mg, Ca, Cl, SO4, colour=NULL, shape=NULL) {
  
  y1 <- Mg * 0.86603
  x1 <- 100*(1-(Ca/100) - (Mg/200))
  y2 <- SO4 * 0.86603
  x2 <-120+(100*Cl/100 + 0.5 * 100*SO4/100)
  
  new_point <- function(x1, x2, y1, y2, grad=1.73206){
    b1 <- y1-(grad*x1)
    b2 <- y2-(-grad*x2)
    M <- matrix(c(grad, -grad, -1,-1), ncol=2)
    intercepts <- as.matrix(c(b1,b2))
    t_mat <- -solve(M) %*% intercepts
    data.frame(x=t_mat[1,1], y=t_mat[2,1])
  }
  
  np_list <- lapply(1:length(x1), function(i) new_point(x1[i], x2[i], y1[i], y2[i]))
  npoints <- do.call("rbind",np_list)
  
  
  grid1p1 <<- data.frame(x1 = c(20,40,60,80), x2= c(10,20,30,40),y1 = c(0,0,0,0), y2 =  c(17.3206,34.6412,51.9618, 69.2824))
  grid1p2 <<- data.frame(x1 = c(20,40,60,80), x2= c(60,70,80,90),y1 = c(0,0,0,0), y2 =  c(69.2824, 51.9618,34.6412,17.3206))
  grid1p3 <<- data.frame(x1 = c(10,20,30,40), x2= c(90,80,70,60),y1 = c(17.3206,34.6412,51.9618, 69.2824), y2 =  c(17.3206,34.6412,51.9618, 69.2824))
  
  grid2p1 <<- grid1p1
  grid2p1$x1 <- grid2p1$x1+120
  grid2p1$x2 <- grid2p1$x2+120
  
  grid2p2 <<- grid1p2
  grid2p2$x1 <- grid2p2$x1+120
  grid2p2$x2 <- grid2p2$x2+120
  
  grid2p3 <<- grid1p3
  grid2p3$x1 <- grid2p3$x1+120
  grid2p3$x2 <- grid2p3$x2+120
  
  grid3p1 <<- data.frame(x1=c(100,90, 80, 70),y1=c(34.6412, 51.9618, 69.2824, 86.603), x2=c(150, 140, 130, 120), y2=c(121.2442,138.5648,155.8854,173.2060))
  grid3p2 <<- data.frame(x1=c(70, 80, 90, 100),y1=c(121.2442,138.5648,155.8854,173.2060), x2=c(120, 130, 140, 150), y2=c(34.6412, 51.9618, 69.2824, 86.603))
  
  
  
  
  points <-data.frame(x=c(x1, x2, npoints$x), y=c(y=y1, y2, npoints$y))  
  
  p <- ggplot() +
    ## left hand ternary plot 
    geom_segment(aes(x=0,y=0, xend=100, yend=0)) +
    geom_segment(aes(x=0,y=0, xend=50, yend=86.603)) +
    geom_segment(aes(x=50,y=86.603, xend=100, yend=0)) + 
    ## right hand ternary plot 
    geom_segment(aes(x=120,y=0, xend=220, yend=0)) +
    geom_segment(aes(x=120,y=0, xend=170, yend=86.603)) +
    geom_segment(aes(x=170,y=86.603, xend=220, yend=0)) +
    ## Upper diamond
    geom_segment(aes(x=110,y=190.5266, xend=60, yend=103.9236)) +
    geom_segment(aes(x=110,y=190.5266, xend=160, yend=103.9236)) + 
    geom_segment(aes(x=110,y=17.3206, xend=160, yend=103.9236)) +
    geom_segment(aes(x=110,y=17.3206, xend=60, yend=103.9236)) +
    
    ## Add grid lines to the plots
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid1p1, linetype = "dashed", size = 0.25, colour = "grey50") + 
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid1p2, linetype = "dashed", size = 0.25, colour = "grey50") +
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid1p3, linetype = "dashed", size = 0.25, colour = "grey50") +
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid2p1, linetype = "dashed", size = 0.25, colour = "grey50") +
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid2p2, linetype = "dashed", size = 0.25, colour = "grey50") +
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid2p3, linetype = "dashed", size = 0.25, colour = "grey50") +
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid3p1, linetype = "dashed", size = 0.25, colour = "grey50") +
    geom_segment(aes(x=x1, y=y1, yend=y2, xend=x2), data=grid3p2, linetype = "dashed", size = 0.25, colour = "grey50") +
    ### Labels and grid values
    #geom_text(aes(50,-10, label="Ca^2"), parse=T, size=4) + # Commented out, as parse=TRUE can cause issues
    geom_text(aes(50,-10, label="Ca2"), size=4) + 
    geom_text(aes(c(20,40,60,80),c(-5,-5,-5,-5), label=c(80, 60, 40, 20)), size=3) + 
    geom_text(aes(c(35,25,15,5),grid1p2$y2, label=c(80, 60, 40, 20)), size=3) + 
    geom_text(aes(c(95,85,75,65),grid1p3$y2, label=c(80, 60, 40, 20)), size=3) + 
    # geom_text(aes(17,50, label="Mg^2"), parse=T, angle=60, size=4) + 
    geom_text(aes(17,50, label="Mg2"), angle=60, size=4) + 
    geom_text(aes(82.5,50, label="Na + K"), angle=-60, size=4) + 
    geom_text(aes(170,-10, label="Cl-"), size=4) + 
    geom_text(aes(205,50, label="SO4"), angle=-60, size=4) + 
    geom_text(aes(137.5,50, label="Alkalinity as HCO3"), angle=60, size=4) +
    geom_text(aes(c(155,145,135,125),grid2p2$y2, label=c(20, 40, 60, 80)), size=3) + 
    geom_text(aes(c(215,205,195,185),grid2p3$y2, label=c(20, 40, 60, 80)), size=3) + 
    geom_text(aes(c(140,160,180,200),c(-5,-5,-5,-5), label=c(20, 40, 60, 80)), size=3) + 
    
    geom_text(aes(grid3p1$x1-5,grid3p1$y1,  label=c(80, 60, 40, 20)), size=3) + 
    geom_text(aes(grid3p1$x2+5,grid3p1$y2,  label=c(20, 40, 60, 80)), size=3) + 
    geom_text(aes(grid3p2$x1-5,grid3p2$y1,  label=c(20, 40, 60, 80)), size=3) + 
    geom_text(aes(grid3p2$x2+5,grid3p2$y2,  label=c(80, 60, 40, 20)), size=3) + 
    geom_text(aes(72.5,150, label="SO4 + Cl-"), angle=60, size=4) +
    geom_text(aes(147.5,150, label="Ca2 + Mg2"), angle=-60, size=4) +
    
    theme_bw() + 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          panel.border = element_blank(), axis.ticks = element_blank(), 
          axis.text.x = element_blank(), axis.text.y = element_blank(),
          axis.title.x = element_blank(), axis.title.y = element_blank())
  
  ## Simple version - no colours and no factors
  if(is.null(colour)&&is.null(shape)){
    return(p + geom_point(aes(x=x, y=y), data=points))
  }
  ## Now there is colour but no factor
  if(!is.null(colour)&&is.null(shape)){
    points$colour <- rep(colour, 3)
    return(p + geom_point(aes(x=x, y=y, colour=colour), data=points))
  }
  ## Now there is no colour but a factor
  if(is.null(colour)&&!is.null(shape)){
    points$shape <- rep(shape, 3)
    return(p+ geom_point(aes(x=x, y=y, shape=shape), data=points))
  }
  ## Now there is colour and a factor
  if(!is.null(colour)&&!is.null(shape)){
    points$shape <- rep(shape, 3)
    points$colour <- rep(colour, 3)
    return(p + geom_point(aes(x=x, y=y, colour=colour, shape=shape), data=points))
  } 
  
  
}
### A plan and simple piper diagram
data=as.data.frame(list("Ca"=c(43,10,73,26,32),"Mg"=c(30,50,3,14,12),Cl=c(24,10,12,30,43),"SO4"=c(24,10,12,30,43),"WaterType"=c(2,2,1,2,3)),row.names=c("A","B","C","D","E"))
### Now a piper diagram with colouring - this could be stream temperature
ggplot_piper(Ca=data$Ca, Mg = data$Mg, Cl=data$Cl, SO4= data$SO4, colour=data$WaterType)
### Noon-continuous colours
ggplot_piper(Ca=data$Ca, Mg = data$Mg, Cl=data$Cl, SO4= data$SO4, colour=as.factor(data$WaterType))
### Now change the shape
ggplot_piper(Ca=data$Ca, Mg = data$Mg, Cl=data$Cl, SO4= data$SO4, shape=as.factor(data$WaterType))
### Now change the both shape and colour
ggplot_piper(Ca=data$Ca, Mg = data$Mg, Cl=data$Cl, SO4= data$SO4, shape=as.factor(data$WaterType), colour=as.factor(data$WaterType))
### Now add better labels to the legend - and a title.
ggplot_piper(Ca=data$Ca, Mg = data$Mg, Cl=data$Cl, SO4= data$SO4, shape=as.factor(data$WaterType), colour=as.factor(data$WaterType)) + 
  labs(shape="Water type 1", colour="Water type 2") + ggtitle("A piper diagram example")
## Change colours and shapes and mergingthe legends together
ggplot_piper(Ca=data$Ca, Mg = data$Mg, Cl=data$Cl, SO4= data$SO4, shape=as.factor(data$WaterType), colour =as.factor(data$WaterType))  + 
  scale_colour_manual(name="legend name must be the same", values=c("#999999", "#E69F00", "#56B4E9"), labels=c("Control", "Treatment 1", "Treatment 2")) +
  scale_shape_manual(name="legend name must be the same", values=c(1,2,3), labels=c("Control", "Treatment 1", "Treatment 2"))