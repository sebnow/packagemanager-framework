---
layout: post
title: Filling the void
---

{{ post.title }}
================

When I first started using GNU/Linux, I fell in love with the concept of
package management. The first package manager I used was apt-get, which
was nice. Unfortunately it was also a mess, with plenty of conflicts and
"dummy packages". Later I discovered [Archlinux][] and again fell in
love with package management. Archlinux uses [pacman][], which has (not
so) recently been libified, producing libalpm. GNU/Linux has plenty of
package managers, unfortunately Mac OS X does not.

Various solutions do exist, such as Sparkle, AppFresh, fink, macports
and the like, but none of these suite my needs. Sparkle is a framework
that does per-application updates. It simply queries some we server,
checks if there's an update, and updates the application. There's no
catalogue, there's no list of packages installed, it doesn't help remove
packages, it just updates a single application. AppFresh is a layer
above Sparkle, it uses Sparkle, and a bunch of other similar
frameworks/applications to provide a list of applications that can be
upgraded, but it doesn't do much beyond that. Fink is a real package
manager, it's the equivalent of apt-get for Mac OS X, even the same
problems apply. Macports is the equivalent of FreeBSD ports for Mac OS
X, which means you still have to compile and such. A nice system, but I
don't want to compile. Furthermore, these so-called package managers
only work with other Mac OS X application bundles, or Unix software, but
not both. Basically there's no package manager like pacman on Mac OS X,
and I really want one!

I have started a project which aims to port (rather wrap around) libalpm
to Mac OS X, as a native Objective-C framework. I have never created a
framework before, so this is quite a challenge, especially in terms of
linking against libalpm. Since libalpm is a C library, it's not quite as
simple as dragging the .dylib into Xcode and compiling. It does work,
sure, but only on a system which is properly setup and has libalpm
installed in the static location you dragged from. Third party
frameworks tend to be embedded in Application bundles, as opposed to
being installed on the system, like in Linux. This is possibly due to
the lack of a package manager, but also to some of the benefits
Application bundles provide. Application bundles can easily be
relocated. I can move some application from */Applications* to my $HOME
if I so wished, without anything breaking. This requires some trickery
during linking, as explained in [a blog post about the
subject][codeshorts07].

Linking against libalpm itself isn't much of a problem. I simply have to
change the install name to *@rpath* and then set the runtime search path
of the framework to *@loader_path/../Frameworks*, simple. The problem is
that libalpm itself links against libarchive and libfetch, which in turn
links against gettext. This requires me to recompile each of these wit
the appropriate install names and runtime search paths. It does not need
to be said that this is very, very annoying. I have yet to figure out a
nice workflow, and how to set up the repository to let other developers
easily start working on it. Obviously I don't want to simply commit the
actual libraries, as that would considerably and unnecessarily increase
the size of the repository. Fortunately [pacman uses git as
well][pacman-git], meaning that it would be possible to use a submodule
and compile from there. However this does not solve the dependency
problem.

I have also encountered some design issues, trying to "translate"
libalpm into Objective-C classes which act like any other Cocoa
classes. The library's "question" callbacks are especially difficult to
translate. These callbacks would be equivalent to delegates in
Objective-C, but delegates pass in the object which sent the message.
The library does not provide a way to send this information, and I did
not expect it to. However it appears that the only solution is a
hack-ish one - using a static global variable and assigning it the
object right before committing a transaction (yuk).

On top of that libalpm seems to lack a lot of documentation. Hopefully
once I understand the library more, I will be able to contribute some,
but so far I am still trying to grasp how everything fits together.

Pacman is a command line tool, and libalpm was re-factored from it.
Naturally libalpm is oriented around command line usage. It does not
provide some features that graphical user interface would take advantage
of - mainly application icons. Mac OS X applications are mostly GUI,
thus most applications using my framework will also be GUI, and such
features would be useful in it.

It may seem this post is a little negative, but it's not. I chose the
libalpm framework for a reason - it's simple and fast ([or will
be][libalpm-packed-backend]). It's also reasonably new, it only came
into being in the pacman 3.0 release and since then it has been
constantly improved. More libalpm frontends (e.g., [shaman][]) are being
created, as well as various bindings to other languages (e.g.,
[pyalpm][], [aqpm][]) and I expect people to at least contribute documentation
back into the project.

The PackageManager.framework is of course open source, MIT licensed, you
can find the code on [github][packagemanager-framework]. Yes, patches
welcome ;).

[archlinux]: http://www.archlinux.org/
[pacman]: http://www.archlinux.org/pacman/
[codeshorts07]: http://www.codeshorts.ca/2007/nov/01/leopard-linking-making-relocatable-libraries-movin
[pacman-git]: http://projects.archlinux.org/?p=pacman.git;a=summary
[libalpm-packed-backend]: http://www.archlinux.org/pipermail/pacman-dev/2008-December/007805.html
[shaman]: http://shaman.iskrembilen.com/
[pyalpm]: http://pyalpm.sourceforge.net/
[aqpm]: http://github.com/drf/aqpm/
[packagemanager-framework]: http://www.github.com/sebnow/packagemanager-framework
