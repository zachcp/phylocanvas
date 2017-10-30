## Test environments
* local OS X install, R 3.4.0
* ubuntu 14.04 (on travis-ci), R 3.4.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 note

* This is a small bugfix release. There is a change in the javascript code used to highlight
nodes. Previosuly it was possible to specify a regex that owuld match more than one node but only stylize the first node. This has been changed to only allow a single node.

* A few small doc fixes.