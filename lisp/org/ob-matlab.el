;;; ob-matlab.el --- org-babel support for matlab evaluation

;; Copyright (C) 2010  Free Software Foundation, Inc.

;; Author: Dan Davison
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org
;; Version: 7.01

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

;; Functions that are common to org-babel support for matlab and
;; octave are in org-babel-octave.el

;;; Requirements:

;; Matlab

;; matlab.el required for interactive emacs sessions and matlab-mode
;; major mode for source code editing buffer
;; http://matlab-emacs.sourceforge.net/

;;; Code:
(require 'ob)
(require 'ob-octave)

;; see ob-octave for matlab implementation

(provide 'ob-matlab)

;; arch-tag: 6b234299-c1f7-4eb1-ace8-7b93344065ac

;;; ob-matlab.el ends here
