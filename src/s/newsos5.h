/* Definitions file for GNU Emacs running on Sony's NEWS-OS 5.0.1
   Copyright (C) 1992 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* Use the SysVr4 file for at least base configuration. */

#include "s-usg5-4.h"

#define NEWSOS5

/* These will be defined by "m-mips.h". */
#undef START_FILES
#undef LIB_STANDARD

/* Disable use of "unexelf.c" and shared libraries,
   because NEWS-OS on MIPS doesn't support ELF. */
#undef UNEXEC
#undef USG_SHARED_LIBRARIES

#ifndef HAVE_SOCKETS
#define HAVE_SOCKETS
#endif
