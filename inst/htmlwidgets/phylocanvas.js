HTMLWidgets.widget({

  name: 'phylocanvas',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        var tree = Phylocanvas.default.createTree(el);

        //set global variables
        tree.setTreeType(x.treetype);
        tree.setNodeSize(x.nodesize);
        tree.setTextSize(x.textsize);
        tree.lineWidth = x.linewidth;
        tree.alignLabels = x.alignlabels;

        // loading will draw the tree
        tree.load(x.tree);




      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
