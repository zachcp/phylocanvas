an htmlwidget for phylocanvas JS
================================


Latest Information
------------------

See the [documentation webpage](https://zachcp.github.io/phylocanvas/) fot the latest information.

Installation
------------

``` r
devtools::install_github("zachcp/phylocanvas")
```

Basic Usage
-----------

Use phylocanvas to draw phylogenetic trees. Basic options to control the tree are availalbe in this top level function. The tree shape in controlled by the `treetype` option. Try 'radial' and 'heirarchical' as well.

``` r
library(phylocanvas)
library(dplyr)

phycanv <- phylocanvas("(A:0.1,B:0.2,(C:0.3,D:0.4)E:0.5)F;", treetype = "rectangular", alignlabels = T)


# stylize nodes
phycanv %>%
  style_node("A", nodesizeratio = 4, fillcolor="rgb(0, 255, 0)") %>% 
  style_node("B", fillcolor = "blue") %>%
  style_node("C", labeltextsize = 10, shape="triangle") %>%
  style_node("D", fillcolor="#ffa500", highlighted=TRUE) 
```

Roadmap
-------

Not expecting 1:1 parity with the pure JS version. The goal is to expose the basic styling and sizing to allow easy tree drawing within R. Possibly, to use the metadata plugin for heatmap displays and ideally (don't know how hard this will be) allow drag and drop selection for returnign sequence names into shiny.

Reference
---------

The sourcecode for the phylocanvas htmltools package can be found at the [github repo](https://github.com/zachcp/phylocanvas). For more information about the phylocanvas JavaScript library, check out the [phylocanvas website](http://phylocanvas.org).
