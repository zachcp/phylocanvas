#' add styles to a node
#'
#' @param phycnv Required.
#' @param nodeid Required.
#'
#' @export
style_node <- function(phycnv, nodeid,
                           highlighted = FALSE,
                           color = "black",
                           shape  = 'circle', #// or square, triangle, star
                           nodesizeratio = 3, #// ratio of the base node size
                           strokecolor= "black", # '#0000ff',
                           fillcolor ='black',
                           linewidth = 2,
                           labelcolour='black',
                           labeltextsize=20, #// points
                           labelfont ='Arial',
                           labelformat = 'bold'
                           ) {
  nodestyles <- list(
      highlighted = highlighted,
      colour = color,
      shape  = shape,
      size = nodesizeratio,
      leafStyle = list(
        strokeStyle= strokecolor,
        fillStyle = fillcolor,
        lineWidth = linewidth
        ),
      labelStyle = list(
        colour=labelcolour,
        textSize=labeltextsize,
        font =labelfont,
        format = labelformat
      )
  )

  phycnv$x$nodestyles[[nodeid]] <- nodestyles
  phycnv
}

