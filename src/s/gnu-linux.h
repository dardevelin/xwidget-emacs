/* This file is the configuration file for the Linux operating system.
   Copyright (C) 1985, 1986, 1992 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* This file was put together by Michael K. Johnson and Rik Faith.  */


/*
 *	Define symbols to identify the version of Unix this is.
 *	Define all the symbols that apply correctly.
 */

/* #define UNIPLUS */
/* #define USG5 */
#define USG
#define BSD
#define LINUX

/* SYSTEM_TYPE should indicate the kind of system you are using.
 It sets the Lisp variable system-type.  */

#define SYSTEM_TYPE "linux"		/* All the best software is free. */

/* Emacs can read input using SIGIO and buffering characters itself,
   or using CBREAK mode and making C-g cause SIGINT.
   The choice is controlled by the variable interrupt_input.
   Define INTERRUPT_INPUT to make interrupt_input = 1 the default (use SIGIO)

   SIGIO can be used only on systems that implement it (4.2 and 4.3).
   CBREAK mode has two disadvatages
     1) At least in 4.2, it is impossible to handle the Meta key properly.
        I hear that in system V this problem does not exist.
     2) Control-G causes output to be discarded.
        I do not know whether this can be fixed in system V.

   Another method of doing input is planned but not implemented.
   It would have Emacs fork off a separate process
   to read the input and send it to the true Emacs process
   through a pipe.
*/

/* There have been suggestions made to add SIGIO to Linux.  If this
   is done, you may, at your discretion, uncomment the line below.
*/

/* #define INTERRUPT_INPUT */

/* Letter to use in finding device name of first pty,
  if system supports pty's.  'p' means it is /dev/ptyp0  */

#define FIRST_PTY_LETTER 'p'

/*
 *	Define HAVE_TERMIOS if the system provides POSIX-style
 *	functions and macros for terminal control.
 */

#define HAVE_TERMIOS

/*
 *	Define HAVE_TIMEVAL if the system supports the BSD style clock values.
 *	Look in <sys/time.h> for a timeval structure.
 */

#define HAVE_TIMEVAL

/*
 *	Define HAVE_SELECT if the system supports the `select' system call.
 */

#define HAVE_SELECT

/*
 *	Define HAVE_PTYS if the system supports pty devices.
 */

#define HAVE_PTYS

/* Uncomment this later when other problems are dealt with -mkj */

/* #define HAVE_SOCKETS */

/* Define this symbol if your system has the functions bcopy, etc. */

#define BSTRING

/* subprocesses should be defined if you want to
   have code for asynchronous subprocesses
   (as used in M-x compile and M-x shell).
   This is generally OS dependent, and not supported
   under most USG systems. */

#define subprocesses

/* define MAIL_USE_FLOCK if the mailer uses flock
   to interlock access to /usr/spool/mail/$USER.
   The alternative is that a lock file named
   /usr/spool/mail/$USER.lock.  */

/* Both are used in Linux by different mail programs.  I assume that most
   people are using newer mailers that have heard of flock.  Change this
   if you need to. */

#define MAIL_USE_FLOCK

/* Define CLASH_DETECTION if you want lock files to be written
   so that Emacs can tell instantly when you try to modify
   a file that someone else has modified in his Emacs.  */

/* #define CLASH_DETECTION */

/* Here, on a separate page, add any special hacks needed
   to make Emacs work on this system.  For example,
   you might define certain system call names that don't
   exist on your system, or that do different things on
   your system and must be used only through an encapsulation
   (Which you should place, by convention, in sysdep.c).  */


/* If you mount the proc file system somewhere other than /proc
   you will have to uncomment the following and make the proper
   changes */

/* #define LINUX_LDAV_FILE "/proc/loadavg" */

/* This is needed for disknew.c:update_frame() */

#define PENDING_OUTPUT_COUNT(FILE) ((FILE)->_pptr - (FILE)->_pbase)

/* Linux has crt0.o in a non-standard place */
#define START_FILES pre-crt0.o /usr/lib/crt0.o

/* Linux has SIGIO defined, but not implemented, as of version 0.99.8
 * What an ugly kludge!  This will not be necessary if the
 * INTERRUPT_INPUT define gets fully implemented.
 */
#ifdef emacs
#include <signal.h>
#undef SIGIO
#endif

/* This is needed for sysdep.c */

#define HAVE_RENAME
#define HAVE_UNISTD_H	      /* for getpagesize.h */
#define HAVE_ALLOCA_H	      /* for getdate.y */
#define NO_SIOCTL_H           /* don't have sioctl.h */

#define HAVE_DUP2             /* is builtin */
#define HAVE_RANDOM           /* is builtin */
#define HAVE_CLOSEDIR
#define HAVE_GETPAGESIZE
#define HAVE_VFORK
#define HAVE_SYS_SIGLIST
#define HAVE_GETWD            /* cure conflict with getcwd? */

#define USE_UTIME             /* don't have utimes */
#define SYSV_SYSTEM_DIR       /* use dirent.h */
#define USG_SYS_TIME          /* use sys/time.h, not time.h */

#define POSIX                 /* affects only getpagesize.h */
#define POSIX_SIGNALS

/* libc-linux/sysdeps/linux/i386/ulimit.c says that due to shared library, */
/* we cannot get the maximum address for brk */
#define ULIMIT_BREAK_VALUE (32*1024*1024)

/* Best not to include -lg, unless it is last on the command line */
#define LIBS_DEBUG
#define LIBS_TERMCAP -ltermcap -lcurses /* save some space with shared libs*/
#define LIB_STANDARD -lc /* avoid -lPW */
#ifdef HAVE_X11
#define LD_SWITCH_SYSTEM -L/usr/X386/lib
#endif
