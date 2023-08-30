# efault.m4 serial 2 (libsigsegv-2.15)
dnl Copyright (C) 2009 Eric Blake <ebb9@byu.net>
dnl Copyright (C) 2023 Bruno Haible <bruno@clisp.org>
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.

dnl Determine whether the behaviour of system calls, when passed an invalid
dnl memory reference, is the traditional behaviour, namely to return with
dnl errno = EFAULT.
AC_DEFUN([SV_SYSCALLS_EFAULT], [
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([AC_CANONICAL_HOST])

  AC_CACHE_CHECK([whether system calls support EFAULT error],
    [sv_cv_syscalls_EFAULT],
    [dnl On MacOS X 10.2 or newer: If we were to perform the tests, a
     dnl Crash Report dialog window would pop up.
     case "$host_os" in
       macos* | darwin[[6-9]]* | darwin[[1-9]][[0-9]]*)
         sv_cv_syscalls_EFAULT=yes ;;
       *)
         AC_RUN_IFELSE([
           AC_LANG_PROGRAM([[
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
/* A NULL pointer.
   If we were to use a literal NULL, gcc would give a warning on glibc systems:
   "warning: null argument where non-null required".  */
const char *null_pointer = NULL;
]],
             [[return !(open (null_pointer, O_RDONLY) < 0
                        && errno == EFAULT);
             ]])],
           [sv_cv_syscalls_EFAULT=yes],
           [sv_cv_syscalls_EFAULT=no],
           [dnl When cross-compiling, guess yes everywhere except on
            dnl native Win32.
            case "$host_os" in
              mingw* | windows*) sv_cv_syscalls_EFAULT="guessing no" ;;
              *)                 sv_cv_syscalls_EFAULT="guessing yes" ;;
            esac
           ])
         ;;
     esac
    ])
  case "$sv_cv_syscalls_EFAULT" in
    *yes)
      AC_DEFINE([HAVE_EFAULT_SUPPORT], [1],
       [Define to 1 if system calls detect invalid memory references and
        return error EFAULT.])
      ;;
  esac
])
