PackageManager.framework Overview and Internals
===============================================

This project is an attempt at making a high-level, object-oriented
Objective-C package management framework. The main goal is to make this
framework feel like any other set of Cocoa classes, and be native to
Objective-C. Currently the framework uses the [Archlinux Package
Management (libalpm) library][alpm] as the backend. The framework is
mostly a wrapper around libalpm, providing a higher-level interface
using Foundation classes.

The framework will aim to be interface agnostic, but it should be easy
to use for graphical user interfaces. However, some features graphical
interfaces would like to use may currently be missing, since libalpm was
born from a command line program ([pacman][pacman]).

License
=======

The PackageManager.framework is released under the MIT license. For more
details, see the [LICENSE](./LICENSE) file.

[alpm]: http://archlinux.org/pacman/
[pacman]: http://archlinux.org/pacman/
