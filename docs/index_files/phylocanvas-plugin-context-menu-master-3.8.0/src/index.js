import { Tooltip, utils } from 'phylocanvas';

const { createHandler, preventDefault } = utils.events;
const { createBlobUrl } = utils.dom;

function createAnchorElement({ text = 'link', filename = 'file', href }) {
  const anchorElement = document.createElement('a');
  anchorElement.appendChild(document.createTextNode(text));
  anchorElement.href = href;
  anchorElement.download = filename;
  return anchorElement;
}

function createImageLink({ tree, filenames }) {
  return createAnchorElement({
    text: this.text,
    filename: filenames.image,
    href: tree.getPngUrl(),
  });
}

function createLeafLabelsLink({ tree, filenames }, node) {
  return createAnchorElement({
    text: this.text,
    filename: filenames.leafLabels,
    href:
      createBlobUrl((node || tree.root).getChildProperties('label').join('\n')),
  });
}

function createSelectedLabelsLink({ tree, filenames }) {
  const labels = tree.leaves.reduce((memo, leaf) => {
    if (leaf[tree.clickFlag] === true) {
      memo.push(leaf.label);
    }
    return memo;
  }, []);
  if (labels.length === 0) {
    return null;
  }
  return createAnchorElement({
    text: this.text,
    filename: filenames.leafLabels,
    href: createBlobUrl(labels.join('\n')),
  });
}

function createNewickLink({ tree, filenames }, node) {
  return createAnchorElement({
    text: this.text,
    filename: filenames.newick,
    href: createBlobUrl((node || tree.root).getNwk()),
  });
}

function createAboutLink() {
  const anchorElement = document.createElement('a');
  anchorElement.appendChild(document.createTextNode('About Phylocanvas...'));
  anchorElement.href = 'http://phylocanvas.org/';
  anchorElement.target = '_blank';
  return anchorElement;
}

export const DEFAULT_MENU_ITEMS = [

  [ {
    text: 'Show/Hide Labels',
    handler: 'toggleLabels',
  }, {
    text: 'Align/Realign Labels',
    handler(tree) {
      tree.alignLabels = !tree.alignLabels;
    },
  } ],

  [ {
    text: 'Fit in Panel',
    handler(tree) {
      tree.fitInPanel();
    },
  }, {
    text: 'Redraw Original Tree',
    handler: 'redrawOriginalTree',
  } ],

  [ {
    text: 'Export Leaf Labels',
    element: createLeafLabelsLink,
  }, {
    text: 'Export Selected Labels',
    element: createSelectedLabelsLink,
  }, {
    text: 'Export as Newick File',
    element: createNewickLink,
  }, {
    text: 'Export as Image',
    element: createImageLink,
  } ],

  [ {
    element: createAboutLink,
  } ],
];

export const DEFAULT_BRANCH_MENU_ITEMS = [

  [ {
    text: 'Collapse/Expand Subtree',
    handler(branch) {
      branch.toggleCollapsed();
      branch.tree.draw(); // some browsers do not fire mousemove after clicking
    },
  }, {
    text: 'Rotate Subtree',
    handler: 'rotate',
  } ],

  [ {
    text: 'Redraw Subtree',
    handler: 'redrawTreeFromBranch',
  } ],

  [ {
    text: 'Export Subtree Leaf Labels',
    element: createLeafLabelsLink,
  }, {
    text: 'Export Subtree as Newick File',
    element: createNewickLink,
  } ],

  [ {
    element: createAboutLink,
  } ],
];

const DEFAULT_FILENAMES = {
  image: 'phylocanvas.png',
  leafLabels: 'phylocanvas-leaf-labels.txt',
  newick: 'phylocanvas.nwk',
};

/**
 * The menu that is shown when the PhyloCanvas widget is right-clicked
 *
 * @constructor
 * @memberOf PhyloCanvas
 * @extends Tooltip
 */
function ContextMenu(tree, {
  menuItems = DEFAULT_MENU_ITEMS,
  branchMenuItems = DEFAULT_BRANCH_MENU_ITEMS,
  unstyled = false,
  className = '',
  parent,
  filenames = DEFAULT_FILENAMES,
} = {}) {
  Tooltip.call(this, tree, {
    className: `phylocanvas-context-menu ${className}`.trim(),
    element: document.createElement('ul'),
    parent,
  });

  this.menuItems = menuItems;
  this.branchMenuItems = branchMenuItems;
  this.filenames = filenames;

  if (!unstyled) {
    require('./style.css');
  }

  this.element.addEventListener('click', (event) => event.stopPropagation());
}

ContextMenu.prototype = Object.create(Tooltip.prototype);
ContextMenu.prototype.constructor = ContextMenu;

ContextMenu.prototype.createSublist = function (menuItems, node) {
  const sublist = document.createElement('ul');
  for (const menuItem of menuItems) {
    let listElement = null;

    if (menuItem.element) {
      const menuItemContent = menuItem.element(this, node);
      if (menuItemContent) {
        listElement = document.createElement('li');
        listElement.appendChild(menuItemContent);
      }
    } else {
      listElement = document.createElement('li');
      listElement.appendChild(document.createTextNode(menuItem.text));
      listElement.addEventListener(
        'click',
        createHandler(node || this.tree, menuItem.handler)
      );
    }
    if (listElement) {
      listElement.addEventListener('click', createHandler(this, 'close'));
      listElement.addEventListener('contextmenu', preventDefault);

      sublist.appendChild(listElement);
    }
  }

  if (sublist.hasChildNodes()) {
    this.element.appendChild(sublist);
  }
};

ContextMenu.prototype.createContent = function (node) {
  const menuItems =
    node && node.children.length ? this.branchMenuItems : this.menuItems;
  for (const subgroup of menuItems) {
    this.createSublist(subgroup, node);
  }
  document.body.addEventListener('click', createHandler(this, 'close'));
};


function handleContextmenu(event) {
  if (event.button === 2) {
    event.preventDefault();
    const node = this.getNodeAtMousePosition(event);
    this.contextMenu.open(
      event.clientX,
      event.clientY,
      node && node.interactive ? node : null
    );
    this.contextMenu.closed = false;
    this.tooltip.close();
  }
}

export default function contextMenuPlugin(decorate) {
  decorate(this, 'createTree', (delegate, args) => {
    const tree = delegate(...args);
    const [ , config = {} ] = args;

    if (config.contextMenu !== false) {
      tree.contextMenu = new ContextMenu(tree, config.contextMenu);
      tree.addListener('contextmenu', handleContextmenu.bind(tree));
    }

    return tree;
  });

  this.ContextMenu = ContextMenu;
}
