/* Definitions for interface to indent.c
   Copyright (C) 1985, 1986 Free Software Foundation, Inc.

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


struct position
  {
    int bufpos;
    int hpos;
    int vpos;
    int prevhpos;
    int contin;
  };

struct position *compute_motion ();
struct position *vmotion ();

/* Value of point when current_column was called */
extern int last_known_column_point;

/* Functions for dealing with the column cache.  */

/* Return true iff the display table DISPTAB specifies the same widths
   for characters as WIDTHTAB.  We use this to decide when to
   invalidate the buffer's column_cache.  */
extern int disptab_matches_widthtab ( /* struct Lisp_Vector *disptab,
                                         struct Lisp_Vector *widthtab */ );

/* Recompute BUF's width table, using the display table DISPTAB.  */
extern void recompute_width_table ( /* struct buffer *buf,
                                       struct Lisp_Vector *disptab */ );
