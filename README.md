ggplot Piper Diagram
================
January 24, 2018

**This is a fork of the gist <https://gist.github.com/johnDorian/5561272> (by Jason Lessels, <jlessels@gmail.com>).** Forking a gist into a git-repository unfortunately does not preserve the relation to the forked project, sorry for that.

Jasons comments:

A piper diagram based on the ternary plot example here: <http://srmulcahy.github.io/2012/12/04/ternary-plots-r.html>. (this link is broken, *Note from Marko, Jan 2018*) This was written quickly, and most likely contains bugs - I advise you to check it first.

This now consists of two functions. *transform\_piper\_data()* transforms the data to match the coordinates of the piper diagram. *ggplot\_piper()* does all of the background.

Example
=======

``` r
source("ggplot_Piper.R")
library("hydrogeo")
```

Data input
----------

Input data need to be percent of meq/l!

| element | valence |
|---------|---------|
| Ca      | 2       |
| Mg      | 2       |
| Cl      | 1       |
| SO4     | 2       |

``` r
milliequivalents <- list(Ca   = c(43, 10, 73, 26, 32),
                         Mg   = c(30, 50, 83, 14, 62),
                         Na   = c(54, 76, 3, 14, 12),
                         K    = c(31, 22, 32, 22, 11),
                         Cl   = c(24, 10, 12, 30, 43),
                         SO4  = c(24, 10, 12, 30, 43),
                         CO3  = c(24, 10, 12, 30, 43),
                         HCO3 = c(42, 110, 12, 3, 4),
                         "WaterType" = c(2, 2, 1, 2, 3),
                         IDs = c("A","B","C","D","E") )
percents <- toPercent(milliequivalents)

data <- as.data.frame(percents)

data
```

    ##          Ca       Mg        Na         K        Cl       SO4       CO3
    ## 1 27.215190 18.98734 34.177215 19.620253 21.052632 21.052632 21.052632
    ## 2  6.329114 31.64557 48.101266 13.924051  7.142857  7.142857  7.142857
    ## 3 38.219895 43.45550  1.570681 16.753927 25.000000 25.000000 25.000000
    ## 4 34.210526 18.42105 18.421053 28.947368 32.258065 32.258065 32.258065
    ## 5 27.350427 52.99145 10.256410  9.401709 32.330827 32.330827 32.330827
    ##        HCO3 WaterType IDs
    ## 1 36.842105         2   A
    ## 2 78.571429         2   B
    ## 3 25.000000         1   C
    ## 4  3.225806         2   D
    ## 5  3.007519         3   E

Transformation
--------------

``` r
piper_data <- transform_piper_data(Ca   = data$Ca,
                                   Mg   = data$Mg,
                                   Cl   = data$Cl,
                                   SO4  = data$SO4,
                                   name = data$WaterType)

piper_data
```

    ##    observation         x          y
    ## 1            2  63.29114  16.443608
    ## 2            2  77.84810  27.406013
    ## 3            1  40.05236  37.633764
    ## 4            2  56.57895  15.953184
    ## 5            3  46.15385  45.892188
    ## 6            2 151.57895  18.232211
    ## 7            2 130.71429   6.185929
    ## 8            1 157.50000  21.650750
    ## 9            2 168.38710  27.936452
    ## 10           3 168.49624  27.999466
    ## 11           2 107.95137  93.797800
    ## 12           2  98.15552  62.579672
    ## 13           1  94.16230 131.355440
    ## 14           2 115.94228 118.774030
    ## 15           3 102.15989 142.898011

Plot
----

The piper function now just plots the background

``` r
ggplot_piper()
```

![](README_files/figure-markdown_github/basePlot-1.png)

Now points can be added like...

``` r
ggplot_piper() + geom_point(aes(x,y), data=piper_data)
```

![](README_files/figure-markdown_github/withPoints-1.png)

... colouring the points can be done using the observation value

``` r
ggplot_piper() + geom_point(aes(x,y, colour=factor(observation)), data=piper_data)
```

![](README_files/figure-markdown_github/withColouredPoints-1.png)

The size can be changed like..

``` r
ggplot_piper() + geom_point(aes(x,y, colour=factor(observation)), size=4, data=piper_data)
```

![](README_files/figure-markdown_github/withColouredResizedPoints-1.png)

Advanced example:

``` r
ggplot_piper() + 
  geom_point(aes(x, y,
                 colour = factor(observation),
                 shape  = factor(observation)), 
             size=4, data = piper_data) + 
  scale_colour_manual(name="legend name must be the same", values=c("#999999", "#E69F00", "#56B4E9"), labels=c("Control", "Treatment 1", "Treatment 2")) +
  scale_shape_manual(name="legend name must be the same", values=c(1,2,3), labels=c("Control", "Treatment 1", "Treatment 2")) +
  theme(legend.position = c(.8, .9))
```

![](README_files/figure-markdown_github/advanced-1.png)
