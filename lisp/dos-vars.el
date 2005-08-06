;;; dos-vars.el --- MS-Dos specific user options

;; Copyright (C) 1998, 2002, 2003, 2004, 2005 Free Software Foundation, Inc.

;; Maintainer: FSF
;; Keywords: internal

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:

(defgroup dos-fns nil
  "MS-DOS specific functions."
  :group 'environment)

(defcustom msdos-shells '("command.com" "4dos.com" "ndos.com")
  "*List of shells that use `/c' instead of `-c' and a backslashed command."
  :type '(repeat string)
  :group 'dos-fns)

(defcustom dos-codepage-setup-hook nil
  "*List of functions to be called after the DOS terminal and coding
systems are set up.  This is the place, e.g., to set specific entries
in `standard-display-table' as appropriate for your codepage, if
`IT-display-table-setup' doesn't do a perfect job."
  :group 'dos-fns
  :type '(hook)
  :version "20.3.3")

;;; arch-tag: dce8a0d9-ab29-413f-84ed-8b89d6190546
;;; dos-vars.el ends here
