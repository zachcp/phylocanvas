
# phylocanvas
## an htmlwidget around phylocanvas

see the [github repo](https://github.com/phylocanvas/phylocanvas) or the [website](http://phylocanvas.org) for
more info.

## Installation
devtools::install_github("zachcp/phylocanvas")

## Basic Usage

```[R]
library(phylocanvas)
phyc <- phylocanvas("(A:0.1,B:0.2,(C:0.3,D:0.4)E:0.5)F;", treetype = "rectangular", alignlabels = T)
phyc <- add_nodestyles(phyc, "A")
phyc <- add_nodestyles(phyc, "B")
phyc
```


# Roadmap
Not expecting 1:1 parity with the pure JS version. The goal is to expose the basic styling and sizing to allow easy tree drawing within R.  Possibly, to use the metadata plugin for heatmap displays
and ideally (don't know how hard this will be) allow drag and drop selection for returnign sequence 
names into shiny.
