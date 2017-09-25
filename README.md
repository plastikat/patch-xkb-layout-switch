# patch-xkb-layout-switch

This tiny script tries to do all the chores to patch the X.Org Server source code to allow keyboard layout switch on keys release (instead of keys press). It is for apt-based distributions (Debian/Ubuntu). It relies on patches provided by the community. It downloads package source code, applies the patch, builds deb package files, installs and "freezes" one of them.

Bug https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/1683383

Original gist https://gist.github.com/elw00d/0826917118d58e81843e2d11bc6cf885

Original article https://habrahabr.ru/post/87408/

Thanks to Artem Kovalov, Igor Kostromin

Reworked by Plastikat
