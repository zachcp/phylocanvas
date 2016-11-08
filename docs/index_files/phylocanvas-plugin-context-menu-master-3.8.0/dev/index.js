import 'phylocanvas/polyfill';
import Phylocanvas from 'phylocanvas';
import contextMenuPlugin from '../src/index';

Phylocanvas.plugin(contextMenuPlugin);

const tree = Phylocanvas.createTree('phylocanvas', {
  // contextMenu: false,
  contextMenu: {
    className: 'extra-class',
    // unstyled: true,
    // parent: document.body,
    filenames: {
      image: 'tree.png',
      leafLabels: 'labels.txt',
      newick: 'tree.nwk',
    },
  },
});

tree.showLabels = true;
tree.hoverLabel = true;
tree.setTreeType('rectangular');

tree.on('error', function (event) { throw event.error; });

tree.on('loaded', function () {
  console.log('loaded');
});

tree.load('((B:0.2,(C:0.3,(G:0.2,H:0.3)D:0.4)E:0.5)F:0.1)A;');
