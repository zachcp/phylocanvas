#' add styles to a node
#'
#' @param phycnv Required.
#' @param nodeid Required.
#'
#' @export
add_nodestyles <- function(phycnv, nodeid,
                           color = "black",
                           shape  = 'circle', #// or square, triangle, star
                           nodesizeratio = 3, #// ratio of the base node size
                           strokecolor= "black", # '#0000ff',
                           #fillstyle ='rgb(0, 255, 0)',
                           fillcolor ='black',
                           linewidth = 2,
                           labelcolour='black',
                           labeltextsize=20, #// points
                           labelfont ='Arial',
                           labelformat = 'bold'
                           ) {
  nodestyles <- list(
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

