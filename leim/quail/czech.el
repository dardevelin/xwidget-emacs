;;; czech.el --- Quail package for inputting Czech -*-coding: iso-2022-7bit;-*-

;; Copyright (C) 1998, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009
;;   Free Software Foundation, Inc.

;; Author: Milan Zamazal <pdm@zamazal.org>
;; Maintainer: Pavel Jan,Bm(Bk <Pavel@Janik.cz>
;; Keywords: i18n, multilingual, input method, Czech

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file defines the following Czech keyboards:
;; - "standard" Czech keyboard in the Windoze NT 105 keys version (both
;;   "QWERTZ" and "QWERTY" versions)
;; - three non-standard Czech keyboards for programmers

;;; Code:

(require 'quail)


(quail-define-package
 "czech" "Czech" "CZ" t
 "\"Standard\" Czech keyboard in the Windoze NT 105 keys version."
 nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("1" ?+)
 ("2" ?,Bl(B)
 ("3" ?,B9(B)
 ("4" ?,Bh(B)
 ("5" ?,Bx(B)
 ("6" ?,B>(B)
 ("7" ?,B}(B)
 ("8" ?,Ba(B)
 ("9" ?,Bm(B)
 ("0" ?,Bi(B)
 ("!" ?1)
 ("@" ?2)
 ("#" ?3)
 ("$" ?4)
 ("%" ?5)
 ("^" ?6)
 ("&" ?7)
 ("*" ?8)
 ("(" ?9)
 (")" ?0)
 ("-" ?=)
 ("_" ?%)
 ("[" ?,Bz(B)
 ("{" ?/)
 ("]" ?\))
 ("}" ?\()
 ("|" ?`)
 (";" ?,By(B)
 (":" ?\")
 ("'" ?,B'(B)
 ("\"" ?!)
 ("<" ??)
 (">" ?:)
 ("/" ?-)
 ("?" ?_)
 ("`" ?\;)
 ("y" ?z)
 ("z" ?y)
 ("Y" ?Z)
 ("Z" ?Y)
 ("\\a" ?,Bd(B)
 ("\\o" ?,Bv(B)
 ("\\s" ?,B_(B)
 ("\\u" ?,B|(B)
 ("\\A" ?,BD(B)
 ("\\O" ?,BV(B)
 ("\\S" ?,B_(B)
 ("\\U" ?,B\(B)
 ("~u" ?,By(B)
 ("~U" ?,BY(B)
 ("=a" ?,Ba(B)
 ("+c" ?,Bh(B)
 ("+d" ?,Bo(B)
 ("=e" ?,Bi(B)
 ("+e" ?,Bl(B)
 ("=i" ?,Bm(B)
 ("+n" ?,Br(B)
 ("=o" ?,Bs(B)
 ("+r" ?,Bx(B)
 ("+s" ?,B9(B)
 ("+t" ?,B;(B)
 ("=u" ?,Bz(B)
 ("=z" ?,B}(B)
 ("+y" ?,B>(B)
 ("=A" ?,BA(B)
 ("+C" ?,BH(B)
 ("+D" ?,BO(B)
 ("=E" ?,BI(B)
 ("+E" ?,BL(B)
 ("=I" ?,BM(B)
 ("+N" ?,BR(B)
 ("=O" ?,BS(B)
 ("+R" ?,BX(B)
 ("+S" ?,B)(B)
 ("+T" ?,B+(B)
 ("=U" ?,BZ(B)
 ("=Z" ?,B](B)
 ("+Y" ?,B.(B)
 ("=1" ?!)
 ("=2" ?@)
 ("=3" ?#)
 ("=4" ?$)
 ("=5" ?%)
 ("=6" ?^)
 ("=7" ?&)
 ("=8" ?*)
 ("=9" ?\()
 ("=0" ?\))
 ("+1" ?!)
 ("+2" ?@)
 ("+3" ?#)
 ("+4" ?$)
 ("+5" ?%)
 ("+6" ?^)
 ("+7" ?&)
 ("+8" ?*)
 ("+9" ?\()
 ("+0" ?\))
 ("=<" ?<)
 ("=>" ?>)
 ("=[" ?\[)
 ("=]" ?\])
 ("={" ?{)
 ("=}" ?})
 ([kp-1] ?1)
 ([kp-2] ?2)
 ([kp-3] ?3)
 ([kp-4] ?4)
 ([kp-5] ?5)
 ([kp-6] ?6)
 ([kp-7] ?7)
 ([kp-8] ?8)
 ([kp-9] ?9)
 ([kp-0] ?0)
 ([kp-add] ?+))

(quail-define-package
 "czech-qwerty" "Czech" "CZ" t
 "\"Standard\" Czech keyboard in the Windoze NT 105 keys version, QWERTY layout."
 nil t nil nil t nil nil nil nil nil t)

(quail-define-rules
 ("1" ?+)
 ("2" ?,Bl(B)
 ("3" ?,B9(B)
 ("4" ?,Bh(B)
 ("5" ?,Bx(B)
 ("6" ?,B>(B)
 ("7" ?,B}(B)
 ("8" ?,Ba(B)
 ("9" ?,Bm(B)
 ("0" ?,Bi(B)
 ("!" ?1)
 ("@" ?2)
 ("#" ?3)
 ("$" ?4)
 ("%" ?5)
 ("^" ?6)
 ("&" ?7)
 ("*" ?8)
 ("(" ?9)
 (")" ?0)
 ("-" ?=)
 ("_" ?%)
 ("[" ?,Bz(B)
 ("{" ?/)
 ("]" ?\))
 ("}" ?\()
 ("|" ?`)
 (";" ?,By(B)
 (":" ?\")
 ("'" ?,B'(B)
 ("\"" ?!)
 ("<" ??)
 (">" ?:)
 ("/" ?-)
 ("?" ?_)
 ("`" ?\;)
 ("\\a" ?,Bd(B)
 ("\\o" ?,Bv(B)
 ("\\s" ?,B_(B)
 ("\\u" ?,B|(B)
 ("\\A" ?,BD(B)
 ("\\O" ?,BV(B)
 ("\\S" ?,B_(B)
 ("\\U" ?,B\(B)
 ("~u" ?,By(B)
 ("~U" ?,BY(B)
 ("=a" ?,Ba(B)
 ("+c" ?,Bh(B)
 ("+d" ?,Bo(B)
 ("=e" ?,Bi(B)
 ("+e" ?,Bl(B)
 ("=i" ?,Bm(B)
 ("+n" ?,Br(B)
 ("=o" ?,Bs(B)
 ("+r" ?,Bx(B)
 ("+s" ?,B9(B)
 ("+t" ?,B;(B)
 ("=u" ?,Bz(B)
 ("=y" ?,B}(B)
 ("+z" ?,B>(B)
 ("=A" ?,BA(B)
 ("+C" ?,BH(B)
 ("+D" ?,BO(B)
 ("=E" ?,BI(B)
 ("+E" ?,BL(B)
 ("=I" ?,BM(B)
 ("+N" ?,BR(B)
 ("=O" ?,BS(B)
 ("+R" ?,BX(B)
 ("+S" ?,B)(B)
 ("+T" ?,B+(B)
 ("=Y" ?,B](B)
 ("+Z" ?,B.(B)
 ("=U" ?,BZ(B)
 ("=1" ?!)
 ("=2" ?@)
 ("=3" ?#)
 ("=4" ?$)
 ("=5" ?%)
 ("=6" ?^)
 ("=7" ?&)
 ("=8" ?*)
 ("=9" ?\()
 ("=0" ?\))
 ("+1" ?!)
 ("+2" ?@)
 ("+3" ?#)
 ("+4" ?$)
 ("+5" ?%)
 ("+6" ?^)
 ("+7" ?&)
 ("+8" ?*)
 ("+9" ?\()
 ("+0" ?\))
 ("=<" ?<)
 ("=>" ?>)
 ("=[" ?\[)
 ("=]" ?\])
 ("={" ?{)
 ("=}" ?})
 ([kp-1] ?1)
 ([kp-2] ?2)
 ([kp-3] ?3)
 ([kp-4] ?4)
 ([kp-5] ?5)
 ([kp-6] ?6)
 ([kp-7] ?7)
 ([kp-8] ?8)
 ([kp-9] ?9)
 ([kp-0] ?0)
 ([kp-add] ?+))

(quail-define-package
 "czech-prog-1" "Czech" "CZ" t
 "Czech (non-standard) keyboard for programmers #1.

All digits except of `1' are replaced by Czech characters as on the standard
Czech keyboard.
`1' is replaced by `+'.
`+' is a dead key.  Multiple presses of the dead key generate various accents.
All other keys are the same as on standard US keyboard."
 nil t nil nil t nil nil nil nil nil t)

(quail-define-rules
 ("1" ?+)
 ("2" ?,Bl(B)
 ("3" ?,B9(B)
 ("4" ?,Bh(B)
 ("5" ?,Bx(B)
 ("6" ?,B>(B)
 ("7" ?,B}(B)
 ("8" ?,Ba(B)
 ("9" ?,Bm(B)
 ("0" ?,Bi(B)
 ("+1" ?1)
 ("+2" ?2)
 ("+3" ?3)
 ("+4" ?4)
 ("+5" ?5)
 ("+6" ?6)
 ("+7" ?7)
 ("+8" ?8)
 ("+9" ?9)
 ("+0" ?0)
 ("+a" ?,Ba(B)
 ("++a" ?,Bd(B)
 ("+c" ?,Bh(B)
 ("+d" ?,Bo(B)
 ("+e" ?,Bi(B)
 ("++e" ?,Bl(B)
 ("+i" ?,Bm(B)
 ("+l" ?,Be(B)
 ("++l" ?,B5(B)
 ("+n" ?,Br(B)
 ("+o" ?,Bs(B)
 ("++o" ?,Bv(B)
 ("+++o" ?,Bt(B)
 ("+r" ?,Bx(B)
 ("++r" ?,B`(B)
 ("+s" ?,B9(B)
 ("++s" ?,B_(B)
 ("+t" ?,B;(B)
 ("+u" ?,Bz(B)
 ("++u" ?,By(B)
 ("+++u" ?,B|(B)
 ("+y" ?,B}(B)
 ("+z" ?,B>(B)
 ("+A" ?,BA(B)
 ("++A" ?,BD(B)
 ("+C" ?,BH(B)
 ("+D" ?,BO(B)
 ("+E" ?,BI(B)
 ("++E" ?,BL(B)
 ("+I" ?,BM(B)
 ("+L" ?,BE(B)
 ("++L" ?,B%(B)
 ("+N" ?,BR(B)
 ("+O" ?,BS(B)
 ("++O" ?,BV(B)
 ("+++O" ?,BT(B)
 ("+R" ?,BX(B)
 ("++R" ?,B@(B)
 ("+S" ?,B)(B)
 ("++S" ?,B_(B)
 ("+T" ?,B+(B)
 ("+U" ?,BZ(B)
 ("++U" ?,BY(B)
 ("+++U" ?,B\(B)
 ("+Y" ?,B](B)
 ("+Z" ?,B.(B)
 ([kp-1] ?1)
 ([kp-2] ?2)
 ([kp-3] ?3)
 ([kp-4] ?4)
 ([kp-5] ?5)
 ([kp-6] ?6)
 ([kp-7] ?7)
 ([kp-8] ?8)
 ([kp-9] ?9)
 ([kp-0] ?0)
 ([kp-add] ?+))

(quail-define-package
 "czech-prog-2" "Czech" "CZ" t
 "Czech (non-standard) keyboard for programmers #2.

All digits except of `1' are replaced by Czech characters as on the standard
Czech keyboard.
`1' is replaced by `,By(B'.
`+' is a dead key.  Multiple presses of the dead key generate various accents.
All other keys are the same as on standard US keyboard."
 nil t nil nil t nil nil nil nil nil t)

(quail-define-rules
 ("1" ?,By(B)
 ("2" ?,Bl(B)
 ("3" ?,B9(B)
 ("4" ?,Bh(B)
 ("5" ?,Bx(B)
 ("6" ?,B>(B)
 ("7" ?,B}(B)
 ("8" ?,Ba(B)
 ("9" ?,Bm(B)
 ("0" ?,Bi(B)
 ("+1" ?1)
 ("+2" ?2)
 ("+3" ?3)
 ("+4" ?4)
 ("+5" ?5)
 ("+6" ?6)
 ("+7" ?7)
 ("+8" ?8)
 ("+9" ?9)
 ("+0" ?0)
 ("+a" ?,Ba(B)
 ("++a" ?,Bd(B)
 ("+c" ?,Bh(B)
 ("+d" ?,Bo(B)
 ("+e" ?,Bi(B)
 ("++e" ?,Bl(B)
 ("+i" ?,Bm(B)
 ("+l" ?,Be(B)
 ("++l" ?,B5(B)
 ("+n" ?,Br(B)
 ("+o" ?,Bs(B)
 ("++o" ?,Bv(B)
 ("+++o" ?,Bt(B)
 ("+r" ?,Bx(B)
 ("++r" ?,B`(B)
 ("+s" ?,B9(B)
 ("++s" ?,B_(B)
 ("+t" ?,B;(B)
 ("+u" ?,Bz(B)
 ("++u" ?,By(B)
 ("+++u" ?,B|(B)
 ("+y" ?,B}(B)
 ("+z" ?,B>(B)
 ("+A" ?,BA(B)
 ("++A" ?,BD(B)
 ("+C" ?,BH(B)
 ("+D" ?,BO(B)
 ("+E" ?,BI(B)
 ("++E" ?,BL(B)
 ("+I" ?,BM(B)
 ("+L" ?,BE(B)
 ("++L" ?,B%(B)
 ("+N" ?,BR(B)
 ("+O" ?,BS(B)
 ("++O" ?,BV(B)
 ("+++O" ?,BT(B)
 ("+R" ?,BX(B)
 ("++R" ?,B@(B)
 ("+S" ?,B)(B)
 ("++S" ?,B_(B)
 ("+T" ?,B+(B)
 ("+U" ?,BZ(B)
 ("++U" ?,BY(B)
 ("+++U" ?,B\(B)
 ("+Y" ?,B](B)
 ("+Z" ?,B.(B)
 ([kp-1] ?1)
 ([kp-2] ?2)
 ([kp-3] ?3)
 ([kp-4] ?4)
 ([kp-5] ?5)
 ([kp-6] ?6)
 ([kp-7] ?7)
 ([kp-8] ?8)
 ([kp-9] ?9)
 ([kp-0] ?0)
 ([kp-add] ?+))

(quail-define-package
 "czech-prog-3" "Czech" "CZ" t
 "Czech (non-standard) keyboard for programmers compatible with the default
keyboard from the obsolete `emacs-czech' package.

All digits except of `1' are replaced by Czech characters as on the standard
Czech keyboard.
`[' and `]' are replaced with `,Bz(B' and `,By(B', respectively.
There are two dead keys on `=' and `+'.  Characters with diaresis are
accessible through `+='.
All other keys are the same as on standard US keyboard."
 nil t nil nil t nil nil nil nil nil t)

(quail-define-rules
 ("2" ?,Bl(B)
 ("3" ?,B9(B)
 ("4" ?,Bh(B)
 ("5" ?,Bx(B)
 ("6" ?,B>(B)
 ("7" ?,B}(B)
 ("8" ?,Ba(B)
 ("9" ?,Bm(B)
 ("0" ?,Bi(B)
 ("[" ?,Bz(B)
 ("]" ?,By(B)
 ("==" ?=)
 ("++" ?+)
 ("=+" ?+)
 ("=[" ?\[)
 ("=]" ?\])
 ("+[" ?\[)
 ("+]" ?\])
 ("=1" ?1)
 ("=2" ?2)
 ("=3" ?3)
 ("=4" ?4)
 ("=5" ?5)
 ("=6" ?6)
 ("=7" ?7)
 ("=8" ?8)
 ("=9" ?9)
 ("=0" ?0)
 ("+1" ?1)
 ("+2" ?2)
 ("+3" ?3)
 ("+4" ?4)
 ("+5" ?5)
 ("+6" ?6)
 ("+7" ?7)
 ("+8" ?8)
 ("+9" ?9)
 ("+0" ?0)
 ("=A" ?,BA(B)
 ("+A" ?,BD(B)
 ("+=A" ?,BD(B)
 ("+C" ?,BH(B)
 ("+D" ?,BO(B)
 ("=E" ?,BI(B)
 ("+E" ?,BL(B)
 ("=I" ?,BM(B)
 ("=L" ?,B%(B)
 ("+L" ?,BE(B)
 ("+N" ?,BR(B)
 ("=O" ?,BS(B)
 ("+O" ?,BT(B)
 ("+=O" ?,BV(B)
 ("=R" ?,B@(B)
 ("+R" ?,BX(B)
 ("+S" ?,B)(B)
 ("=S" ?,B_(B)
 ("+T" ?,B+(B)
 ("=U" ?,BZ(B)
 ("+U" ?,BY(B)
 ("+=U" ?,B\(B)
 ("=Y" ?,B](B)
 ("+Z" ?,B.(B)
 ("=a" ?,Ba(B)
 ("+a" ?,Bd(B)
 ("+=a" ?,Bd(B)
 ("+c" ?,Bh(B)
 ("+d" ?,Bo(B)
 ("=e" ?,Bi(B)
 ("+e" ?,Bl(B)
 ("=i" ?,Bm(B)
 ("=l" ?,B5(B)
 ("+l" ?,Be(B)
 ("+n" ?,Br(B)
 ("=o" ?,Bs(B)
 ("+o" ?,Bt(B)
 ("+=o" ?,Bv(B)
 ("=r" ?,B`(B)
 ("+r" ?,Bx(B)
 ("+s" ?,B9(B)
 ("=s" ?,B_(B)
 ("+t" ?,B;(B)
 ("=u" ?,Bz(B)
 ("+u" ?,By(B)
 ("+=u" ?,B|(B)
 ("=y" ?,B}(B)
 ("+z" ?,B>(B)
 ([kp-1] ?1)
 ([kp-2] ?2)
 ([kp-3] ?3)
 ([kp-4] ?4)
 ([kp-5] ?5)
 ([kp-6] ?6)
 ([kp-7] ?7)
 ([kp-8] ?8)
 ([kp-9] ?9)
 ([kp-0] ?0)
 ([kp-add] ?+))

;; arch-tag: 0a27dffc-a5e1-479f-9da2-a9eb91b34d8a
;;; czech.el ends here
