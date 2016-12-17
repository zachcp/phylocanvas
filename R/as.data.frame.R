# Unless explicity noted, everythign in this file is copied from ggtree.
# I've copied instread of depending simply to avoid the large nubmer of dependencies
# of the ggtree package. This keep phylocanvas light.
#
# Taken from ggtree:
# https://github.com/GuangchuangYu/ggtree/blob/master/R/method-fortify.R
# https://github.com/GuangchuangYu/ggtree/blob/master/R/tree-utilities.R

setOldClass("phylo")

##' convert phylo to data.frame
##'
##'
##' @title as.data.frame
##' @param x phylo object
##' @param row.names omitted here
##' @param optional omitted here
##' @param layout layout
##' @param ... additional parameter
##' @return data.frame
##' @method as.data.frame phylo
##' @export
as.data.frame.phylo <- function(x, row.names, optional, layout="rectangular", ...) {
  if (layout == "unrooted") {
    return(layout.unrooted(x))
  }
  as.data.frame.phylo_(x, layout, ...)
}

as.data.frame.phylo_ <- function(x, layout="rectangular",
                                 branch.length="branch.length", ...) {
  if (branch.length != 'none') {
    branch.length = "branch.length"
  }

  tip.label <- x[["tip.label"]]
  Ntip <- length(tip.label)
  N <- getNodeNum(x)

  edge <- as.data.frame(x[["edge"]])
  colnames(edge) <- c("parent", "node")

  if (! is.null(x$edge.length)) {
    edge$length <- x$edge.length
    if (branch.length == "none") {
      xpos <- getXcoord_no_length(x)
      ypos <- getYcoord(x)
    } else {
      xpos <- getXcoord(x)
      ypos <- getYcoord(x)
    }
  } else {
    xpos <- getXcoord_no_length(x)
    ypos <- getYcoord(x)
  }

  xypos <- data.frame(node=1:N, x=xpos, y=ypos)

  res <- merge(edge, xypos, by.x="node", by.y="node", all.y=TRUE)
  label <- rep(NA, N)
  label[1:Ntip] <- tip.label
  if ( !is.null(x$node.label) ) {
    label[(Ntip+1):N] <- x$node.label
  }
  res$label <- label
  isTip <- rep(FALSE, N)
  isTip[1:Ntip] <- TRUE
  res$isTip <- isTip

  ## add branch mid position
  res <- calculate_branch_mid(res)

  ## ## angle for all layout, if 'rectangular', user use coord_polar, can still use angle
  res <- calculate_angle(res)
  return(res)
}

calculate_angle <- function(data) {
  data$angle <- 360/(diff(range(data$y)) + 1) * data$y
  return(data)
}

##' calculate total number of nodes
##'
##'
##' @title getNodeNum
##' @param tr phylo object
##' @return number
##' @author Guangchuang Yu
getNodeNum <- function(tr) {
  Ntip <- length(tr[["tip.label"]])
  Nnode <- tr[["Nnode"]]
  ## total nodes
  N <- Ntip + Nnode
  return(N)
}

getXcoord <- function(tr) {
  edge <- tr$edge
  parent <- edge[,1]
  child <- edge[,2]
  root <- getRoot(tr)

  len <- tr$edge.length

  N <- getNodeNum(tr)
  x <- numeric(N)
  x <- getXcoord2(x, root, parent, child, len)
  return(x)
}

##' get the root number
##'
##'
##' @title getRoot
##' @param tr phylo object
##' @return root number
##' @author Guangchuang Yu
getRoot <- function(tr) {
  edge <- tr[["edge"]]
  ## 1st col is parent,
  ## 2nd col is child,
  if (!is.null(attr(tr, "order")) && attr(tr, "order") == "postorder")
    return(edge[nrow(edge), 1])

  parent <- unique(edge[,1])
  child <- unique(edge[,2])
  ## the node that has no parent should be the root
  root <- parent[ ! parent %in% child ]
  if (length(root) > 1) {
    stop("multiple roots founded...")
  }
  return(root)
}


##' @importFrom ape reorder.phylo
layout.unrooted <- function(tree) {
  N <- getNodeNum(tree)
  root <- getRoot(tree)

  df <- as.data.frame.phylo_(tree)
  df$x <- NA
  df$y <- NA
  df$start <- NA
  df$end   <- NA
  df$angle <- NA
  df[root, "x"] <- 0
  df[root, "y"] <- 0
  df[root, "start"] <- 0
  df[root, "end"]   <- 2
  df[root, "angle"] <- 0

  nb.sp <- sapply(1:N, function(i) length(get.offspring.tip(tree, i)))

  nodes <- getNodes_by_postorder(tree)

  for(curNode in nodes) {
    curNtip <- nb.sp[curNode]
    children <- getChild(tree, curNode)

    start <- df[curNode, "start"]
    end <- df[curNode, "end"]

    if (length(children) == 0) {
      ## is a tip
      next
    }

    for (i in seq_along(children)) {
      child <- children[i]
      ntip.child <- nb.sp[child]

      alpha <- (end - start) * ntip.child/curNtip
      beta <- start + alpha / 2

      length.child <- df[child, "length"]
      df[child, "x"] <- df[curNode, "x"] + cospi(beta) * length.child
      df[child, "y"] <- df[curNode, "y"] + sinpi(beta) * length.child
      df[child, "angle"] <- -90 -180 * beta * sign(beta - 1)
      df[child, "start"] <- start
      df[child, "end"] <- start + alpha
      start <- start + alpha
    }

  }

  return(df)
}


##' calculate total number of nodes
##'
##'
##' @title getNodeNum
##' @param tr phylo object
##' @return number
##' @author Guangchuang Yu
getNodeNum <- function(tr) {
  Ntip <- length(tr[["tip.label"]])
  Nnode <- tr[["Nnode"]]
  ## total nodes
  N <- Ntip + Nnode
  return(N)
}

##' get the root number
##'
##'
##' @title getRoot
##' @param tr phylo object
##' @return root number
##' @author Guangchuang Yu
getRoot <- function(tr) {
  edge <- tr[["edge"]]
  ## 1st col is parent,
  ## 2nd col is child,
  if (!is.null(attr(tr, "order")) && attr(tr, "order") == "postorder")
    return(edge[nrow(edge), 1])

  parent <- unique(edge[,1])
  child <- unique(edge[,2])
  ## the node that has no parent should be the root
  root <- parent[ ! parent %in% child ]
  if (length(root) > 1) {
    stop("multiple roots founded...")
  }
  return(root)
}

get.trunk <- function(tr) {
  root <- getRoot(tr)
  path_length <- sapply(1:(root-1), function(x) get.path_length(tr, root, x))
  i <- which.max(path_length)
  return(get.path(tr, root, i))
}

##' path from start node to end node
##'
##'
##' @title get.path
##' @param phylo phylo object
##' @param from start node
##' @param to end node
##' @return node vectot
##' @author Guangchuang Yu
get.path <- function(phylo, from, to) {
  anc_from <- getAncestor(phylo, from)
  anc_from <- c(from, anc_from)
  anc_to <- getAncestor(phylo, to)
  anc_to <- c(to, anc_to)
  mrca <- intersect(anc_from, anc_to)[1]

  i <- which(anc_from == mrca)
  j <- which(anc_to == mrca)

  path <- c(anc_from[1:i], rev(anc_to[1:(j-1)]))
  return(path)
}

get.path_length <- function(phylo, from, to, weight=NULL) {
  path <- get.path(phylo, from, to)
  if (is.null(weight)) {
    return(length(path)-1)
  }

  df <- fortify(phylo)
  if ( ! (weight %in% colnames(df))) {
    stop("weight should be one of numerical attributes of the tree...")
  }

  res <- 0

  get_edge_index <- function(df, from, to) {
    which((df[,1] == from | df[,2] == from) &
            (df[,1] == to | df[,2] == to))
  }

  for(i in 1:(length(path)-1)) {
    ee <- get_edge_index(df, path[i], path[i+1])
    res <- res + df[ee, weight]
  }

  return(res)
}

getNodes_by_postorder <- function(tree) {
  tree <- reorder.phylo(tree, "postorder")
  unique(rev(as.vector(t(tree$edge[,c(2,1)]))))
}

getXcoord2 <- function(x, root, parent, child, len, start=0, rev=FALSE) {
  x[root] <- start
  x[-root] <- NA  ## only root is set to start, by default 0

  currentNode <- root
  direction <- 1
  if (rev == TRUE) {
    direction <- -1
  }
  while(anyNA(x)) {
    idx <- which(parent %in% currentNode)
    newNode <- child[idx]
    x[newNode] <- x[parent[idx]]+len[idx] * direction
    currentNode <- newNode
  }

  return(x)
}

getXcoord_no_length <- function(tr) {
  edge <- tr$edge
  parent <- edge[,1]
  child <- edge[,2]
  root <- getRoot(tr)

  len <- tr$edge.length

  N <- getNodeNum(tr)
  x <- numeric(N)
  ntip <- Ntip(tr)
  currentNode <- 1:ntip
  x[-currentNode] <- NA

  cl <- split(child, parent)
  child_list <- list()
  child_list[as.numeric(names(cl))] <- cl

  while(anyNA(x)) {
    idx <- match(currentNode, child)
    pNode <- parent[idx]
    ## child number table
    p1 <- table(parent[parent %in% pNode])
    p2 <- table(pNode)
    np <- names(p2)
    i <- p1[np] == p2
    newNode <- as.numeric(np[i])

    exclude <- rep(NA, max(child))
    for (j in newNode) {
      x[j] <- min(x[child_list[[j]]]) - 1
      exclude[child_list[[j]]] <- child_list[[j]]
    }
    exclude <- exclude[!is.na(exclude)]

    ## currentNode %<>% `[`(!(. %in% exclude))
    ## currentNode %<>% c(., newNode) %>% unique
    currentNode <- currentNode[!currentNode %in% exclude]
    currentNode <- unique(c(currentNode, newNode))

  }
  x <- x - min(x)
  return(x)
}


getXcoord <- function(tr) {
  edge <- tr$edge
  parent <- edge[,1]
  child <- edge[,2]
  root <- getRoot(tr)

  len <- tr$edge.length

  N <- getNodeNum(tr)
  x <- numeric(N)
  x <- getXcoord2(x, root, parent, child, len)
  return(x)
}

getXYcoord_slanted <- function(tr) {

  edge <- tr$edge
  parent <- edge[,1]
  child <- edge[,2]
  root <- getRoot(tr)

  N <- getNodeNum(tr)
  len <- tr$edge.length
  y <- getYcoord(tr, step=min(len)/2)

  len <- sqrt(len^2 - (y[parent]-y[child])^2)
  x <- numeric(N)
  x <- getXcoord2(x, root, parent, child, len)
  res <- data.frame(x=x, y=y)
  return(res)
}


## @importFrom magrittr %>%
##' @importFrom magrittr equals
getYcoord <- function(tr, step=1) {
  Ntip <- length(tr[["tip.label"]])
  N <- getNodeNum(tr)

  edge <- tr[["edge"]]
  parent <- edge[,1]
  child <- edge[,2]

  cl <- split(child, parent)
  child_list <- list()
  child_list[as.numeric(names(cl))] <- cl

  y <- numeric(N)
  tip.idx <- child[child <= Ntip]
  y[tip.idx] <- 1:Ntip * step
  y[-tip.idx] <- NA

  currentNode <- 1:Ntip
  while(anyNA(y)) {
    pNode <- unique(parent[child %in% currentNode])
    ## piping of magrittr is slower than nested function call.
    ## pipeR is fastest, may consider to use pipeR
    ##
    ## child %in% currentNode %>% which %>% parent[.] %>% unique
    ## idx <- sapply(pNode, function(i) all(child[parent == i] %in% currentNode))
    idx <- sapply(pNode, function(i) all(child_list[[i]] %in% currentNode))
    newNode <- pNode[idx]

    y[newNode] <- sapply(newNode, function(i) {
      mean(y[child_list[[i]]], na.rm=TRUE)
      ##child[parent == i] %>% y[.] %>% mean(na.rm=TRUE)
    })

    currentNode <- c(currentNode[!currentNode %in% unlist(child_list[newNode])], newNode)
    ## currentNode <- c(currentNode[!currentNode %in% child[parent %in% newNode]], newNode)
    ## parent %in% newNode %>% child[.] %>%
    ##     `%in%`(currentNode, .) %>% `!` %>%
    ##         currentNode[.] %>% c(., newNode)
  }

  return(y)
}

getYcoord_scale <- function(tr, df, yscale) {

  N <- getNodeNum(tr)
  y <- numeric(N)

  root <- getRoot(tr)
  y[root] <- 0
  y[-root] <- NA

  edge <- tr$edge
  parent <- edge[,1]
  child <- edge[,2]

  currentNodes <- root
  while(anyNA(y)) {
    newNodes <- c()
    for (currentNode in currentNodes) {
      idx <- which(parent %in% currentNode)
      newNode <- child[idx]
      direction <- -1
      for (i in seq_along(newNode)) {
        y[newNode[i]] <- y[currentNode] + df[newNode[i], yscale] * direction
        direction <- -1 * direction
      }
      newNodes <- c(newNodes, newNode)
    }
    currentNodes <- unique(newNodes)
  }
  if (min(y) < 0) {
    y <- y + abs(min(y))
  }
  return(y)
}

getYcoord_scale2 <- function(tr, df, yscale) {
  root <- getRoot(tr)

  pathLength <- sapply(1:length(tr$tip.label), function(i) {
    get.path_length(tr, i, root, yscale)
  })

  ordered_tip <- order(pathLength, decreasing = TRUE)
  ii <- 1
  ntip <- length(ordered_tip)
  while(ii < ntip) {
    sib <- getSibling(tr, ordered_tip[ii])
    if (length(sib) == 0) {
      ii <- ii + 1
      next
    }
    jj <- which(ordered_tip %in% sib)
    if (length(jj) == 0) {
      ii <- ii + 1
      next
    }
    sib <- ordered_tip[jj]
    ordered_tip <- ordered_tip[-jj]
    nn <- length(sib)
    if (ii < length(ordered_tip)) {
      ordered_tip <- c(ordered_tip[1:ii],sib, ordered_tip[(ii+1):length(ordered_tip)])
    } else {
      ordered_tip <- c(ordered_tip[1:ii],sib)
    }

    ii <- ii + nn + 1
  }


  long_branch <- getAncestor(tr, ordered_tip[1]) %>% rev
  long_branch <- c(long_branch, ordered_tip[1])

  N <- getNodeNum(tr)
  y <- numeric(N)

  y[root] <- 0
  y[-root] <- NA

  ## yy <- df[, yscale]
  ## yy[is.na(yy)] <- 0

  for (i in 2:length(long_branch)) {
    y[long_branch[i]] <- y[long_branch[i-1]] + df[long_branch[i], yscale]
  }

  parent <- df[, "parent"]
  child <- df[, "node"]

  currentNodes <- root
  while(anyNA(y)) {
    newNodes <- c()
    for (currentNode in currentNodes) {
      idx <- which(parent %in% currentNode)
      newNode <- child[idx]
      newNode <- c(newNode[! newNode %in% ordered_tip],
                   rev(ordered_tip[ordered_tip %in% newNode]))
      direction <- -1
      for (i in seq_along(newNode)) {
        if (is.na(y[newNode[i]])) {
          y[newNode[i]] <- y[currentNode] + df[newNode[i], yscale] * direction
          direction <- -1 * direction
        }
      }
      newNodes <- c(newNodes, newNode)
    }
    currentNodes <- unique(newNodes)
  }
  if (min(y) < 0) {
    y <- y + abs(min(y))
  }
  return(y)
}

getYcoord_scale_numeric <- function(tr, df, yscale, ...) {
  df <- .assign_parent_status(tr, df, yscale)
  df <- .assign_child_status(tr, df, yscale)

  y <- df[, yscale]

  if (anyNA(y)) {
    warning("NA found in y scale mapping, all were setting to 0")
    y[is.na(y)] <- 0
  }

  return(y)
}

.assign_parent_status <- function(tr, df, variable) {
  yy <- df[, variable]
  na.idx <- which(is.na(yy))
  if (length(na.idx) > 0) {
    tree <- get.tree(tr)
    nodes <- getNodes_by_postorder(tree)
    for (curNode in nodes) {
      children <- getChild(tree, curNode)
      if (length(children) == 0) {
        next
      }
      idx <- which(is.na(yy[children]))
      if (length(idx) > 0) {
        yy[children[idx]] <- yy[curNode]
      }
    }
  }
  df[, variable] <- yy
  return(df)
}

.assign_child_status <- function(tr, df, variable, yscale_mapping=NULL) {
  yy <- df[, variable]
  if (!is.null(yscale_mapping)) {
    yy <- yscale_mapping[yy]
  }

  na.idx <- which(is.na(yy))
  if (length(na.idx) > 0) {
    tree <- get.tree(tr)
    nodes <- rev(getNodes_by_postorder(tree))
    for (curNode in nodes) {
      parent <- getParent(tree, curNode)
      if (parent == 0) { ## already reach root
        next
      }
      idx <- which(is.na(yy[parent]))
      if (length(idx) > 0) {
        child <- getChild(tree, parent)
        yy[parent[idx]] <- mean(yy[child], na.rm=TRUE)
      }
    }
  }
  df[, variable] <- yy
  return(df)
}

getYcoord_scale_category <- function(tr, df, yscale, yscale_mapping=NULL, ...) {
  if (is.null(yscale_mapping)) {
    stop("yscale is category variable, user should provide yscale_mapping,
         which is a named vector, to convert yscale to numberical values...")
  }
  if (! is(yscale_mapping, "numeric") ||
      is.null(names(yscale_mapping))) {
    stop("yscale_mapping should be a named numeric vector...")
  }

  if (yscale == "label") {
    yy <- df[, yscale]
    ii <- which(is.na(yy))
    if (length(ii)) {
      df[ii, yscale] <- df[ii, "node"]
    }
  }

  ## assign to parent status is more prefer...
  df <- .assign_parent_status(tr, df, yscale)
  df <- .assign_child_status(tr, df, yscale, yscale_mapping)

  y <- df[, yscale]

  if (anyNA(y)) {
    warning("NA found in y scale mapping, all were setting to 0")
    y[is.na(y)] <- 0
  }
  return(y)
  }


add_angle_slanted <- function(res) {
  dy <- (res[, "y"] - res[res$parent, "y"]) / diff(range(res[, "y"]))
  dx <- (res[, "x"] - res[res$parent, "x"]) / diff(range(res[, "x"]))
  theta <- atan(dy/dx)
  theta[is.na(theta)] <- 0 ## root node
  res$angle <- theta/pi * 180
  branch.y <- (res[res$parent, "y"] + res[, "y"])/2
  idx <- is.na(branch.y)
  branch.y[idx] <- res[idx, "y"]
  res[, "branch.y"] <- branch.y
  return(res)
}

calculate_branch_mid <- function(res) {
  res$branch <- (res[res$parent, "x"] + res[, "x"])/2
  if (!is.null(res$length)) {
    res$length[is.na(res$length)] <- 0
  }
  res$branch[is.na(res$branch)] <- 0
  return(res)
}

