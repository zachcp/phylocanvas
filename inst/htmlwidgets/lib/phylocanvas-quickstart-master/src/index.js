import 'phylocanvas/polyfill';

import historyPlugin from 'phylocanvas-plugin-history';
import ajaxPlugin from 'phylocanvas-plugin-ajax';
import metadataPlugin from 'phylocanvas-plugin-metadata';
import contextMenuPlugin from 'phylocanvas-plugin-context-menu';
import scalebarPlugin from 'phylocanvas-plugin-scalebar';

import phylocanvas from 'phylocanvas';

phylocanvas.plugin(historyPlugin);
phylocanvas.plugin(ajaxPlugin);
phylocanvas.plugin(metadataPlugin);
phylocanvas.plugin(contextMenuPlugin);
phylocanvas.plugin(scalebarPlugin);

// commonjs to ensure default exports are available in global scope
module.exports = phylocanvas;
