dnl
dnl Configuring kagoiri-musume
dnl  process this file with "autoconf" to generate 'configure'.
dnl $Id: configure.ac,v 1.16 2006/12/27 18:18:06 cut-sea Exp $
AC_PREREQ(2.59)
AC_INIT(kagoiri-musume, 0.1.4, cut-sea@master.email.ne.jp)

dnl Check for programs.  Set up PATH according to prefix.
if test "$prefix" != NONE; then
  tpath=$prefix/bin:$PATH
else
  tpath=$PATH
fi

AC_PATH_PROGS([GOSH], gosh)
AC_PATH_PROGS([KAHUA_INSTALL], kahua-install, [], $tpath)

dnl Check for other program
AC_PROG_INSTALL

if test X$GOSH = X; then 
  AC_MSG_ERROR([Cannot find Gauche installed.  Please install Gauche-0.8.8 or later, and make sure to set PATH properly.])
fi
if test X$KAHUA_INSTALL = X; then 
  AC_MSG_ERROR([Cannot find Kahua installed.  Please install Kahua-1.0 or later, and make sure to set PATH properly.])
fi

KAHUACONFIG_OPTION=' -c $(sysconfdir)/kahua.conf'
AC_ARG_WITH(site-bundle,
  AC_HELP_STRING([--with-site-bundle=/path/to/bundle],
                 [Target site bundle path. Default: none]),
  [
    case "$with_site_bundle" in
      no) KAHUACONFIG_OPTION=' -c $(sysconfdir)/kahua.conf' ;;
      *)  KAHUACONFIG_OPTION=" -S $with_site_bundle" ;;
    esac
  ])
AC_SUBST(KAHUACONFIG_OPTION)

dnl Add more test

dnl Output
echo $PACKAGE_VERSION > VERSION
AC_OUTPUT(Makefile)
