# Phylocanvas Context Menu Plugin
Contextual functions for Phylocanvas

## Usage
```
npm install phylocanvas phylocanvas-plugin-context-menu
```
```javascript
import Phylocanvas from 'phylocanvas';
import contextMenuPlugin, {
  DEFAULT_MENU_ITEMS,
  DEFAULT_BRANCH_MENU_ITEMS,
  DEFAULT_FILENAMES,
} from 'phylocanvas-plugin-context-menu';

Phylocanvas.plugin(contextMenuPlugin);

Phylocanvas.createTree('id', {
  contextMenu: { // config defaults
    menuItems: DEFAULT_MENU_ITEMS,
    branchMenuItems: DEFAULT_BRANCH_MENU_ITEMS, 
    unstyled: false,
    className: '',
    parent: undefined, // supply parent element to fix z-index issues
    filenames: DEFAULT_FILENAMES, 
  }
})
```
