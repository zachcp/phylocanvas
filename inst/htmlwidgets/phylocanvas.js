var gparams, tre;

HTMLWidgets.widget({

  name: 'phylocanvas',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {
        //pass params globally

        var tree = Phylocanvas.default.createTree(el);

        //set global variables
        tree.setTreeType(x.treetype);
        tree.setNodeSize(x.nodesize);
        tree.setTextSize(x.textsize);
        tree.lineWidth = x.linewidth;
        tree.showLabels = x.showlabels;
        tree.alignLabels = x.alignlabels;

        gparams = x;
        tre = tree;

        // loading will draw the tree
        tree.load(x.tree);

        // apply node styles after the tree is loaded
        for (key in x.nodestyles) {
          tree.findLeaves(key)[0].setDisplay( x.nodestyles[key] );
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
