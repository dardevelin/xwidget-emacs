;;; georgian.el --- Quail package for inputting Georgian characters  -*-coding: utf-8;-*-

;; Copyright (C) 2001  Free Software Foundation, Inc.

;; Author: Dave Love <fx@gnu.org>
;; Keywords: i18n

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Georgian input following the Yudit map from Mark Leisher
;; <mleisher@crl.nmsu.edu>.

;;; Code:

(require 'quail)

(quail-define-package
 "georgian" "Georgian" "გ" t
 "A common Georgian transliteration (using Unicode)"
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("a" ?ა)
 ("b" ?ბ)
 ("g" ?გ)
 ("d" ?დ)
 ("e" ?ე)
 ("v" ?ვ)
 ("z" ?ზ)
 ("t" ?თ)
 ("i" ?ი)
 (".k" ?კ)
 ("l" ?ლ)
 ("m" ?მ)
 ("n" ?ნ)
 ("o" ?ო)
 (".p" ?პ)
 ("\+z"	?ჟ)
 ("r" ?რ)
 ("s" ?ს)
 (".t" ?ტ)
 ("u" ?უ)
 ("p" ?ფ)
 ("k" ?ქ)
 (".g" ?ღ)
 ("q" ?ყ)
 ("\+s"	?შ)
 ("\+c"	?ჩ)
 ("c" ?ც)
 ("j" ?ძ)
 (".c" ?წ)
 (".\+c" ?ჭ)
 ("x" ?ხ)
 ("\+j"	?ჯ)
 ("h" ?ჰ)
 ("q1" ?ჴ)
 ("e0" ?ჱ)
 ("o1" ?ჵ)
 ("i1" ?ჲ)
 ("w" ?ჳ)
 ("f" ?ჶ)
 ;; Presumably, these are GEORGIAN LETTER YN, GEORGIAN LETTER ELIFI,
 ;; accepted for U+10F7, U+10F8  -- fx
 ("y" ?) ;; Letter not in Unicode (private use code).
 ("e1" ?) ;; Letter not in Unicode (private use code).
 )

;;; georgian.el ends here
