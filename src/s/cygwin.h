/* System description header file for Cygwin.

Copyright (C) 1985-1986, 1992, 1999, 2002-2012 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.  */

#define PTY_ITERATION		int i; for (i = 0; i < 1; i++) /* ick */
#define PTY_NAME_SPRINTF	/* none */
#define PTY_TTY_NAME_SPRINTF	/* none */
#define PTY_OPEN					\
  do							\
    {							\
      int dummy;					\
      SIGMASKTYPE mask;					\
      mask = sigblock (sigmask (SIGCHLD));		\
      if (-1 == openpty (&fd, &dummy, pty_name, 0, 0))	\
	fd = -1;					\
      sigsetmask (mask);				\
      if (fd >= 0)					\
	emacs_close (dummy);				\
    }							\
  while (0)

/* Used in various places to enable cygwin-specific code changes.  */
#define CYGWIN 1

/* Emacs supplies its own malloc, but glib (part of Gtk+) calls
   memalign and on Cygwin, that becomes the Cygwin-supplied memalign.
   As malloc is not the Cygwin malloc, the Cygwin memalign always
   returns ENOSYS.  A workaround is to set G_SLICE=always-malloc. */
#define G_SLICE_ALWAYS_MALLOC
