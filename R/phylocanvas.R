#' phylocanvas
#'
#' An html widget wrapper of the \href{http://phylocanvas.org}{phylocanvas.js} JS library.
#'
#' @import htmlwidgets
#'
#' @param tree Required. Newick string of a phyloseq tree, \code{\link[ape]{phylo}} class object,
#' \code{\link[phylobase]{phylo4}} class object,, or path to newick-containing file.
#' @param nodestyles Optional. Default \code{NULL}. Let nodes b stylized.
#' @param treetype Optional. Default \code{"rectangular"}. Can be one of "rectengular", "circular",
#' "hierarchical", "diagonal", or "radial".
#' @param nodesize Optional. Default \code{30}. Global nodesize.
#' @param textsize Optional. Default \code{30}. Global textsize.
#' @param linewidth Optional. Default \code{3}. Global linewidth.
#' @param showlabels Optional. Default \code{TRUE}. Whether to show labels.
#' @param showhistory Optional. Default \code{FALSE}. Whether to use/show the history plugin.
#' @param showcontextmenu Optional. Default \code{TRUE}. Whether to use/show the mouse context menu.
#' @param showscalebar Optional. Default \code{FALSE}. Whether to use/show the scalebar.
#' @param alignlabels Optional. Default \code{FALSE}. Whether to align node labels
#' @param width Optional. Default \code{NULL}. HTMLWidget width
#' @param height Optional. Default \code{NULL}. HTMLWidget width
#' @param elementId Optional. Default \code{NULL}. HTMLWidget ID

#' @export
phylocanvas <- function(tree,
                        treetype = "rectangular",
                        nodestyles = NULL,
                        nodesize = 30,
                        textsize = 30,
                        linewidth = 3,
                        showlabels = TRUE,
                        alignlabels= FALSE,
                        showhistory = FALSE,
                        showcontextmenu=TRUE,
                        showscalebar=FALSE,
                        width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    tree=as_tree(tree),
    treetype=treetype,
    nodesize=nodesize,
    textsize=textsize,
    linewidth=linewidth,
    showlabels=showlabels,
    alignlabels=alignlabels,
    nodestyles=nodestyles,
    nodecollapses = NULL,
    nodehighlights = NULL,
    prunebranch = NULL,
    selectbranch = NULL,
    prunebranch = NULL,
    config = list(
      history=showhistory,
      contextMenu=TRUE,
      scalebar=list(
        active=showscalebar,
        width=100,
        height=20,
        fillStyle='black',
        strokeStyle='black',
        lineWidth=1,
        fontFamily='Sans-serif',
        fontSize=16,
        textBaseline='bottom',
        textAlign='center',
        digits=2,
        position=list(
          bottom=10,
          left=10)
      )
    )
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'phylocanvas',
    x,
    width = width,
    height = height,
    package = 'phylocanvas',
    elementId = elementId
  )
}

#' Shiny bindings for phylocanvas
#'
#' Output and render functions for using phylocanvas within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a phylocanvas
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name phylocanvas-shiny
#'
#' @export
phylocanvasOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'phylocanvas', width, height, package = 'phylocanvas')
}

#' @rdname phylocanvas-shiny
#' @export
renderPhylocanvas <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, phylocanvasOutput, env, quoted = TRUE)
}
