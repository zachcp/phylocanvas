var gparams, tre;

HTMLWidgets.widget({

  name: 'phylocanvas',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {
        //pass params globally

        // clear the sub nodes. Necessary for shiny apps
        while (el.firstChild)
          el.removeChild(el.firstChild);

        var tree = Phylocanvas.createTree(el, x.config);

        //set global variables
        tree.setTreeType(x.treetype);
        tree.setNodeSize(x.nodesize);
        tree.lineWidth = x.linewidth;
        tree.showLabels = x.showlabels;
        tree.alignLabels = x.alignlabels;

        gparams = x;
        tre = tree;

        // loading will draw the tree
        tree.load(x.tree);
        
        tree.setTextSize(x.textsize);

        // apply node styles after the tree is loaded
        if (x.nodestyles !== null) {
          Object.keys(x.nodestyles).forEach(function(key){
          var leaf = tree.findLeaves("^" + key + "$")[0];
          leaf.setDisplay( x.nodestyles[key] );
          leaf.highlighted = x.nodestyles[key].highlighted;
          });
        }

        // apply collapse styles after the tree is loaded
        if (x.nodecollapses) {
          Object.keys(x.nodecollapses).forEach(function(key){
          tree.branches[key].collapsed =  x.nodecollapses[key][0];
          });
        }

        // apply rotations
        if (x.noderotations) {
          Object.keys(x.noderotations).forEach(function(key){
          tree.branches[key].rotate();
          });
        }

        // select branches
        if (x.selectbranch) {
          Object.keys(x.selectbranch).forEach(function(key){
            if (x.selectbranch[key][0] === false) {
              tree.branches[key].selected = true;
            } else {
              tree.branches[key].selected = true;
              tree.branches[key].cascadeFlag('selected', true);
            }
          });
        }

        // prune branches
        if (x.prunebranch) {
          Object.keys(x.prunebranch).forEach(function(key){
              tree.branches[key].pruned = true;
          });
        }

        // highlight nodes
        if (x.nodehighlights) {
          Object.keys(x.nodehighlights).forEach(function(key){
            var leaf = tree.findLeaves(key)[0];
            leaf.highlighted=true;
          });
        }

        // activate all styles
        tree.draw();

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
